function Get-CvSessionInfo {
	<#
	.SYNOPSIS
	Retrieves details about the current session, the operator accessing the API,
	the CoreView environment, and the PowerShell module.

	.DESCRIPTION
	The `Get-CvSessionInfo` cmdlet is used to retrieve information about the
	current session in CoreView. This includes details about the operator
	accessing the API, the CoreView environment, and the PowerShell module being
	used.

	.PARAMETER None
	This cmdlet does not accept any parameters.

	.EXAMPLE
	Get-CvSessionInfo
	This example retrieves information about the current session in CoreView.

	.LINK
	Connect-CvAPI
	#>
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()

	$context = Get-CvContext

	$info = [ordered]@{
		'ContextInfoCoreViewSection'    = [ordered]@{
			'ContextInfoConfigUrl'        = Format-Hyperlink $script:CV_ENVIRONMENT_JSON
			'ContextInfoPortalAppName'    = $context.PortalAppName
			'ContextInfoPortalAppVersion' = $context.PortalAppVersion
			'ContextInfoApiUrl'           = Format-Hyperlink $context.ApiUrl
			'ContextInfoCoreFlowUrl'      = Format-Hyperlink $context.CoreFlowUrl
		}
		'ContextInfoCompanySection'     = [ordered]@{
			'ContextInfoTenantId'             = $context.TenantId
			'ContextInfoCompanyName'          = $context.CompanyName
			'ContextInfoCompanyId'            = $context.CompanyId
			'ContextInfoDatacenter'           = $context.Datacenter
			'ContextInfoOrgIdentity'          = $context.OrgIdentity
			'ContextInfoOrgType'              = $context.OrgType
			'ContextInfoOrgSubscriptionLevel' = $context.OrgSubscriptionLevel
			'ContextInfoOrgRoles'             = $context.OrgRoles -join ', '
			'ContextInfoOrgPortalSkus'        = $context.OrgPortalSkus -join ', '
		}
		'ContextInfoOperatorSection'    = [ordered]@{
			'ContextInfoOperatorUserId'   = Format-Hyperlink -Uri `
				"https://app.coreview.com/administrations/manage-operators/user;id=$($context.OperatorUserId)" `
				-Label $context.OperatorUserId
			'ContextInfoOperatorUserName' = $context.OperatorUserName
			'ContextInfoOperatorName'     = $context.OperatorName
			'ContextInfoOperatorRoles'    = $context.OperatorRoles -join ', '
			'ContextInfoOperatorVTenants' = $context.OperatorVTenants -join ', '
			'ContextInfoOperatorLanguage' = $context.OperatorLanguage
		}
		'ContextInfoSessionSection'     = [ordered]@{
			'ContextInfoSessionId'       = $context.SessionId
			'ContextInfoSessionExpiry'   = $context.SessionExpiry
			'ContextInfoSessionAudience' = $context.SessionAudience -join ', '
		}
		'ContextInfoEnvironmentSection' = [ordered]@{
			'ContextInfoPSHostVersion' = Format-Hyperlink -Uri `
				"https://github.com/PowerShell/PowerShell/releases/tag/v$($context.PSHostVersion)" `
				-Label $context.PSHostVersion
			'ContextInfoModuleName'    = $context.ModuleName
		}
	}

	if ($context.ModuleCommitHash) {
		$manifestUrl = "https://github.com/SanteQc/coreview-ps/blob/$($context.ModuleCommitHash)/src/coreview-ps/coreview-ps.psd1#L14"
		$commitUrl = "https://github.com/SanteQc/coreview-ps/commit/$($context.ModuleCommitHash)"
		$runsURl = 'https://github.com/SanteQc/coreview-ps/actions'

		$info.ContextInfoEnvironmentSection = $info.ContextInfoEnvironmentSection + `
			[ordered] @{
			'ContextInfoModuleVersion'     = "v$($context.ModuleVersion)+rev.$($context.ModuleBuildNumber) (commit $($context.ModuleCommitHash.Substring(0, 7)))"
			'ContextInfoManifestVersion'   = Format-Hyperlink -Uri $manifestUrl -Label $context.ModuleVersion
			'ContextInfoModuleBuildNumber' = Format-Hyperlink -Uri $runsURl -Label $context.ModuleBuildNumber
			'ContextInfoModuleCommitHash'  = Format-Hyperlink -Uri $commitUrl -Label $context.ModuleCommitHash
		}
	}
	else {
		$info.ContextInfoEnvironmentSection = $info.ContextInfoEnvironmentSection + `
			[ordered] @{
			'ContextInfoManifestVersion' = $context.ModuleVersion
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
