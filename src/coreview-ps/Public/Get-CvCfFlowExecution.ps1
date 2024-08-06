function Get-CvCfFlowExecution {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateScript({ $_ -ne [Guid]::Empty }, ErrorMessage = 'The ExecutionId parameter must be a valid GUID.')]
		[guid]$ExecutionId
	)

	process {
		FetchFlowExecutionDetailsFromCoreFlow
		ExtractGeneralFlowInfo
		ExtractFlowStatus
		ExtractFlowInput
		ExtractFlowError
		ExtractFlowOutput
	}

	end {
		return (ReturnFlowExecutionInfo)
	}

	begin {
		$mutable = @{}

		function FetchFlowExecutionDetailsFromCoreFlow {
			$mutable.flowExecution = Invoke-CvCfRestMethod -Endpoint "api/executions/$([guid]::Empty)/${ExecutionId}"

			if (-not $mutable.flowExecution) {
				Write-ErrorMsg FlowExecutionNotFound $ExecutionId
			}
		}

		function ExtractGeneralFlowInfo {
			$mutable.executionDetails = @{
				ExecutionId = $mutable.flowExecution.workflowExecutionId
				FlowId      = $mutable.flowExecution.workflowId
			}
		}

		function ExtractFlowStatus {
			$mutable.executionDetails += @{
				Status = $mutable.flowExecution.status
			}
		}

		function ExtractFlowInput {
			if (-not $mutable.flowExecution.workflowInput) {
				return
			}

			$mutable.executionDetails += @{
				Input = $mutable.flowExecution.workflowInput | Convert-JsonToHashtable
			}
		}

		function ExtractFlowError {
			if ($mutable.flowExecution.error -and $mutable.flowExecution.cause) {
				ExtractGenericErrorDetails

				if ($mutable.flowExecution.executionHistoryEvents) {
					ExtractErrorCause
				}
			}
		}

		function ExtractGenericErrorDetails {
			$mutable.executionDetails += @{
				Error = @{
					Message = $mutable.flowExecution.error
					Cause   = $mutable.flowExecution.cause
				}
			}
		}

		function ExtractErrorCause {
			$failedStep = $mutable.flowExecution.executionHistoryEvents | Where-Object { $_.cause } | Select-Object -First 1

			$mutable.executionDetails.Error += @{
				StepName = $failedStep.action.name
				Details  = $failedStep.cause
			}
		}

		function ExtractFlowOutput {
			ExtractGenericFlowOutput

			if ($mutable.flowExecution.executionHistoryEvents) {
				ExtractOutputFromExecutionHistory
			}
		}

		function ExtractGenericFlowOutput {
			if (-not $mutable.flowExecution.workflowOutput) {
				return
			}

			$mutable.executionDetails += @{
				Output = $mutable.flowExecution.workflowOutput | Convert-JsonToHashtable
			}
		}

		function ExtractOutputFromExecutionHistory {
			$mutable.executionDetails += @{
				ExecutionHistory = $mutable.flowExecution.executionHistoryEvents | Where-Object { $_.output -and $_.output.Contains('"response":[') } | ForEach-Object {
					@{
						StepName = $_.action.name
						Output   = $_.output | Convert-JsonToHashtable | Select-Object -ExpandProperty response | Select-Object -First 1
					}
				}
			}
		}

		function ReturnFlowExecutionInfo {
			return $mutable.executionDetails
		}
	}
}
