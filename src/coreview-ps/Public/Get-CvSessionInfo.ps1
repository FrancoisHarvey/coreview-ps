function Get-CvSessionInfo {
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()

	$context = Get-CvContext

	$info = [ordered]@{
		'ContextInfoCoreViewSection'    = [ordered]@{
			'ContextInfoPortalAppName'    = $context.PortalAppName
			'ContextInfoPortalAppVersion' = $context.PortalAppVersion
			'ContextInfoCompanyName'      = $context.CompanyName
			'ContextInfoCompanyId'        = $context.CompanyId
		}
		'ContextInfoOperatorSection'    = [ordered]@{
			'ContextInfoOperatorUserId'   = $context.OperatorUserId
			'ContextInfoOperatorUserName' = $context.OperatorUserName
			'ContextInfoOperatorName'     = $context.OperatorName
			'ContextInfoOperatorRoles'    = $context.OperatorRoles -join ', '
		}
		'ContextInfoSessionSection'     = [ordered]@{
			'ContextInfoSessionId'       = $context.SessionId
			'ContextInfoSessionExpiry'   = $context.SessionExpiry
			'ContextInfoSessionAudience' = $context.SessionAudience -join ', '
		}
		'ContextInfoEnvironmentSection' = [ordered]@{
			'ContextInfoPSHostVersion' = $context.PSHostVersion
			'ContextInfoModuleName'    = $context.ModuleName
			'ContextInfoModuleVersion' = $context.ModuleVersion
		}
	}

	foreach ($sectionKV in $info.GetEnumerator()) {
		Write-Information "`n[ $(Get-Msg $sectionKV.Key) ]" -InformationAction Continue

		$orderedSection = [ordered]@{}
		foreach ($kv in $sectionKV.Value.GetEnumerator()) {
			$orderedSection[(Get-Msg $kv.Key)] = $kv.Value
		}

		([pscustomobject]$orderedSection) | Format-List
		Write-Information ''
	}
}
