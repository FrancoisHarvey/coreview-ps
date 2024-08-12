function Wait-CvCfFlowExecution {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[ValidateScript({ $_ -ne [Guid]::Empty }, ErrorMessage = 'The ExecutionId parameter must be a valid GUID.')]
		[guid]$ExecutionId,

		[Parameter(Mandatory = $false)]
		[ValidateRange(5, 600)]
		[int]$Interval = 5,

		[Parameter(Mandatory = $false)]
		[ValidateRange(30, 28800)]
		[int]$Timeout = 1800
	)

	process {
		while ((FlowExecutionIsNotFinished) -and -not (TimeoutReached)) {
			ContinueWaiting
		}

		if ((TimeoutReached)) {
			Write-ErrorMsg FlowDidNotFinishBeforeTimeout $Timeout
		}
	}

	begin {
		$timeoutTime = (Get-Date).AddSeconds($Timeout)

		function FlowExecutionIsNotFinished {
			return (GetFlowExecutionStatus) -notin 'Succeeded', 'Finished', 'Failed'
		}

		function GetFlowExecutionStatus {
			$flowExecution = Invoke-CvCfRestMethod -Endpoint "api/executions/$([guid]::Empty)/${ExecutionId}"

			if (-not $flowExecution) {
				Write-ErrorMsg FlowExecutionNotFound $ExecutionId
			}

			return $flowExecution.status
		}

		function TimeoutReached {
			return (Get-Date) -ge $timeoutTime
		}

		function ContinueWaiting {
			Start-Sleep -Seconds $Interval
		}
	}
}
