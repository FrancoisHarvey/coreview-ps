function New-CvCfFlowExecution {
	<#
	.SYNOPSIS
		Executes a CoreFlow flow with the given input parameters.

	.DESCRIPTION
		The `New-CvCfFlowExecution` cmdlet is used to execute a CoreFlow flow with
		the given input parameters. The flow is identified by the `FlowId` parameter
		and the input parameters are provided as a hashtable.

	.PARAMETER FlowId
		Specifies the identifier of the flow to execute.

	.PARAMETER InputParameters
		Specifies the input parameters to provide to the flow.

	.OUTPUTS
		System.Guid
	#>
	[CmdletBinding()]
	[OutputType([guid])]
	param(
		[Parameter(Mandatory, Position = 0)]
		[ValidateScript({ $_ -ne [Guid]::Empty }, ErrorMessage = 'The FlowId parameter must be a valid GUID.')]
		[Guid]$FlowId,

		[Parameter(Mandatory, Position = 1)]
		[hashtable]$InputParameters
	)

	Confirm-CvOperatorHasRole @('Management', 'Workflow', 'WorkflowEditor', 'WorkflowPublisher')
	Test-CvCfFlowInputParameters -FlowId $FlowId -InputParameters $InputParameters

	$execution = Invoke-CvCfRestMethod -Endpoint "api/executions/${FlowId}" -Method Post -Body $InputParameters
	return [guid]$execution.executionId
}
