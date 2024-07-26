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
			'ContextInfoConfigUrl'        = $script:CV_ENVIRONMENT_JSON
			'ContextInfoPortalAppName'    = $context.PortalAppName
			'ContextInfoPortalAppVersion' = $context.PortalAppVersion
			'ContextInfoApiUrl'           = $context.ApiUrl
			'ContextInfoCoreFlowUrl'      = $context.CoreFlowUrl
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
