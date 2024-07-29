function Test-CvCfFlowInputParameters {
	<#
	.SYNOPSIS
		Validates the input parameters for a CoreFlow flow.

	.DESCRIPTION
		The `Test-CvCfFlowInputParameters` cmdlet is used to validate the input
		parameters for a CoreFlow flow. The flow is identified by the `FlowId`
		parameter and the input parameters are provided as a hashtable. This
		cmdlet checks that all parameters are of the right type and that they
		match the expected schema for the flow.

	.PARAMETER FlowId
		Specifies the identifier of the flow to validate.

	.PARAMETER InputParameters
		Specifies the input parameters to validate.
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[Guid]$FlowId,

		[Parameter(Mandatory)]
		[hashtable]$InputParameters
	)

	process {
		ObtainFlowSchema
		EnsureRequiredParametersArePresent
		ValidateAllParameters
		ValidateEntireSchema
	}

	begin {
		$mutable = @{}

		function ObtainFlowSchema {
			$mutable.jsonFlowSchema = Get-CvCfFlowSchema -FlowId $FlowId
			$mutable.flowSchema = $mutable.jsonFlowSchema | ConvertFrom-Json -AsHashtable -Depth 10
		}

		function EnsureRequiredParametersArePresent {
			foreach ($paramName in $mutable.flowSchema.required) {
				if (-not $InputParameters.ContainsKey($paramName)) {
					Write-ErrorMsg MissingMandatoryFlowParameter $paramName
				}
			}
		}

		function ValidateAllParameters {
			foreach ($kv in $InputParameters.GetEnumerator()) {
				if (-not $mutable.flowSchema.properties.ContainsKey($kv.Key)) {
					Write-ErrorMsg UnknownFlowParameter $kv.Key
				}
				$propSchema = $mutable.flowSchema.properties[$kv.Key]
				if ($propSchema.ContainsKey('enum') -and -not $propSchema.enum.Contains($kv.Value)) {
					Write-ErrorMsg FlowParameterNotInAllowedValues $kv.Value $kv.Key ($propSchema.enum -join ', ')
				}

				try {
					Test-Json -Json $kv.Value -Schema ($propSchema | ConvertTo-Json -Compress -Depth 10)
				}
				catch {
					Write-ErrorMsg InvalidFlowParameter $kv.Key $_.Exception.ToString()
				}
			}
		}

		function ValidateEntireSchema {
			try {
				Test-Json -Json $InputParameters -Schema $mutable.jsonFlowSchema
			}
			catch {
				Write-ErrorMsg UnexpectedFlowValidationError $_.Exception.ToString()
			}
		}
	}
}
