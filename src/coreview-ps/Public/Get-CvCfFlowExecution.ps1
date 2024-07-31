function Get-CvCfFlowExecution {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateScript({ $_ -ne [Guid]::Empty }, ErrorMessage = 'The ExecutionId parameter must be a valid GUID.')]
		[guid]$ExecutionId
	)

	$flowExecution = Invoke-CvCfRestMethod -Endpoint "api/executions/$([guid]::Empty)/${ExecutionId}"

	if (-not $flowExecution) {
		Write-ErrorMsg FlowExecutionNotFound $ExecutionId
	}

	# TODO: extract execution info

	return $flowExecution
}
