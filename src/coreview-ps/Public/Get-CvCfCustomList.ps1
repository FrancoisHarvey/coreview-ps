$script:CustomListCache = @{}

function Get-CvCfCustomList {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[Guid]$ListId,

		[Parameter()]
		[switch]$BypassCache
	)

	process {
		if (CacheExists) {
			return ReturnCustomListFromCache
		}

		EnsureOperatorHasRequiredRoles
		ObtainCustomListFromCoreFlow
		AddCustomListToCache
		ReturnCustomListFromCache
	}

	begin {
		$mutable = @{}

		function CacheExists {
			return -not $BypassCache -and $script:CustomListCache.ContainsKey($ListId)
		}

		function ReturnCustomListFromCache {
			return $script:CustomListCache[$ListId]
		}

		function EnsureOperatorHasRequiredRoles {
			Confirm-CvOperatorHasRole @('Management', 'Workflow', 'WorkflowEditor', 'WorkflowPublisher')
		}

		function ObtainCustomListFromCoreFlow {
			$customList = Invoke-CvCfRestMethod -Endpoint "api/v2/customlists/${ListId}" -Method Get
			$mutable.CustomList = $customList
		}

		function AddCustomListToCache {
			$script:CustomListCache[$ListId] = $mutable.CustomList
		}
	}
}
