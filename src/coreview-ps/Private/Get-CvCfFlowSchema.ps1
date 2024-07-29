
$script:FlowSchemaCache = @{}

function Get-CvCfFlowSchema {
	[CmdletBinding()]
	[OutputType([string])]
	param (
		[Parameter(Mandatory = $true)]
		[Guid]$FlowId,

		[Parameter()]
		[switch]$BypassCache
	)

	process {
		if (CacheExists) {
			return ReturnFlowSchemaFromCache
		}

		EnsureOperatorHasRequiredRoles
		ObtainFlowDataFromCoreFlow
		ExtractFlowSchemaFromFlowData
		BindCustomListsToFlowSchema
		ConvertFlowSchemaToJson
		AddFlowSchemaToCache
		ReturnFlowSchemaFromCache
	}

	begin {
		$mutable = @{}

		function CacheExists {
			return -not $BypassCache -and $script:FlowSchemaCache.ContainsKey($FlowId)
		}

		function ReturnFlowSchemaFromCache {
			return $script:FlowSchemaCache[$FlowId]
		}

		function EnsureOperatorHasRequiredRoles {
			Confirm-CvOperatorHasRole @('Management', 'Workflow', 'WorkflowEditor', 'WorkflowPublisher')
		}

		function ObtainFlowDataFromCoreFlow {
			$flow = Invoke-CvCfRestMethod -Endpoint "api/workflows/${FlowId}" -Method Get
			$mutable.flowData = $flow
		}

		function ExtractFlowSchemaFromFlowData {
			$flowSchema = $mutable.flowData.inputSchema
			$mutable.FlowSchema = $flowSchema | ConvertFrom-Json -AsHashtable -Depth 10
		}

		function BindCustomListsToFlowSchema {
			foreach ($kv in $mutable.FlowSchema.properties.GetEnumerator()) {
				if ($kv.Value.ContainsKey('x-cv-custom-list')) {
					$listId = [guid]($kv.Value.'x-cv-custom-list')
					$listDefinition = Get-CvCfCustomList -ListId $listId
					$mutable.FlowSchema.properties.($kv.Name).enum = $listDefinition.values
					$mutable.FlowSchema.properties.($kv.Name).'x-cv-list-name' = $listDefinition.name
					$mutable.FlowSchema.properties.($kv.Name).'x-cv-list-description' = $listDefinition.description
				}
			}
		}

		function ConvertFlowSchemaToJson {
			$mutable.FlowSchemaJson = $mutable.FlowSchema | ConvertTo-Json -Depth 10
		}

		function AddFlowSchemaToCache {
			$script:FlowSchemaCache[$FlowId] = $mutable.FlowSchemaJson
		}
	}
}
