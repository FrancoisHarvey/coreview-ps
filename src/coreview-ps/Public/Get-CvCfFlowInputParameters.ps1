function Write-CvInputParameterInfo {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[Hashtable]$Parameter
	)

	process {
		ExtractParameterName
		ExtractParameterDisplayName
		ExtractParameterDescription
		ExtractParameterType
		ExtractParameterTarget
		ExtractParameterTooltip
		ExtractParameterIsRequired
		PrintParameterInfo
	}

	begin {
		$paramInfo = [ordered]@{}

		function ExtractParameterName {
			[void]$paramInfo.Add('FlowParameterName', $Parameter.title)
		}

		function ExtractParameterDisplayName {
			$translation = Get-CvTranslationString -Key $Parameter.title

			if ($null -ne $translation) {
				[void]$paramInfo.Add('FlowParameterDisplayName', $translation)
			}
		}

		function ExtractParameterType {
			$type = GetJsonSchemaTypeName $Parameter.type

			if ($parameter.ContainsKey('x-cv-data-source')) {
				$type = Get-Msg FlowParameterOfType $type $parameter.'x-cv-data-source'
			}
			elseif ($parameter.ContainsKey('x-cv-password')) {
				$type = Get-Msg FlowParameterOfPasswordType $type
			}
			elseif ($parameter.ContainsKey('format')) {
				$type = Get-Msg FlowParameterOfType $type (GetJsonSchemaFormat $parameter.format)
			}
			elseif ($parameter.ContainsKey('enum')) {
				$type = Get-Msg FlowParameterFromListOfValues $type
				[void]$paramInfo.Add('FlowParameterPermittedValues', $parameter.enum -join ', ')
			}

			[void]$paramInfo.Add('FlowParameterType', $type)
		}

		function GetJsonSchemaTypeName($type) {
			return (Get-Msg "JsonSchema${type}Type")
		}

		function ExtractParameterTarget {
			if ($Parameter.ContainsKey('x-cv-target-type')) {
				[void]$paramInfo.Add('FlowParameterTargetType', $Parameter.'x-cv-target-type')
			}
		}

		function ExtractParameterDescription {
			if ($Parameter.ContainsKey('description')) {
				[void]$paramInfo.Add('FlowParameterDescription', $Parameter.description)
			}
		}

		function ExtractParameterTooltip {
			if ($Parameter.ContainsKey('x-cv-tooltip')) {
				$translation = Get-CvTranslationString -Key "workflow_$($Parameter.'x-cv-tooltip')"

				if ($null -ne $translation) {
					[void]$paramInfo.Add('FlowParameterTooltip', $translation)
				}
				else {
					[void]$paramInfo.Add('FlowParameterTooltip', $Parameter.'x-cv-tooltip')
				}
			}
		}

		function ExtractParameterIsRequired {
			[void]$paramInfo.Add('FlowParameterIsRequired', ($Parameter.isRequired | ConvertTo-YesNo))
		}

		function GetJsonSchemaFormat($format) {
			return (Format-Hyperlink -Uri 'https://json-schema.org/understanding-json-schema/reference/string#built-in-formats' -Label $format)
		}

		function PrintParameterInfo {
			Write-Information "`n[ $($Parameter.title) ]" -InformationAction Continue

			$translatedParamInfo = [ordered]@{}
			foreach ($kv in $paramInfo.GetEnumerator()) {
				$translatedParamInfo[(Get-Msg $kv.Key)] = $kv.Value
			}

			([pscustomobject]$translatedParamInfo) | Format-List
		}
	}
}

function Get-CvCfFlowInputParameters {
	<#
	.SYNOPSIS
		Retrieves the input parameters for a CoreFlow flow.

	.DESCRIPTION
		The `Get-CvCfFlowInputParameters` cmdlet is used to retrieve the input
		parameters for a CoreFlow flow. The flow is identified by the `FlowId`
		parameter.

	.PARAMETER FlowId
		Specifies the identifier of the flow to retrieve input parameters for.

	.EXAMPLE
		Get-CvCfFlowInputParameters -FlowId '00000000-0000-0000-0000-000000000000'
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[Guid]$FlowId
	)

	process {
		ObtainFlowInputSchemaJson
		ConvertFlowInputSchemaJsonToHashtable
		PrintExpectedInputParameters
	}

	begin {
		$mutable = @{}

		function ObtainFlowInputSchemaJson {
			$flowSchema = Get-CvCfFlowSchema -FlowId $FlowId
			$mutable.FlowSchemaJson = $flowSchema
		}

		function ConvertFlowInputSchemaJsonToHashtable {
			$mutable.FlowSchema = $mutable.FlowSchemaJson | ConvertFrom-Json -AsHashtable -Depth 10
		}

		function PrintExpectedInputParameters {
			foreach ($kv in $mutable.FlowSchema.properties.GetEnumerator()) {
				Write-CvInputParameterInfo ($kv.Value + @{
						isRequired = $mutable.FlowSchema.required -contains $kv.Value.title
					})
			}
		}
	}
}
