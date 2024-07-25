function Get-CvContext {
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([Hashtable])]
	param ()

	$session = Get-CvSessionObject
	$env = Get-CvEnvironment -HttpClient $session.httpClient
	$module = Get-Module 'coreview-ps'

	return @{
		TenantId             = $session.TenantId
		CompanyId            = $session.CompanyId
		CompanyName          = $session.CompanyName
		OrgIdentity          = $session.OrgIdentity
		OrgType              = $session.OrgType
		OrgSubscriptionLevel = $session.OrgSubscriptionLevel
		OrgRoles             = $session.OrgRoles
		OrgPortalSkus        = $session.OrgPortalSkus
		ModuleName           = $module.Name
		ModuleVersion        = $module.Version
		OperatorName         = $session.OperatorName
		OperatorRoles        = $session.OperatorRoles
		OperatorUserId       = $session.OperatorUserId
		OperatorUserName     = $session.OperatorUserName
		PortalAppName        = $env.name
		PortalAppVersion     = $env.appVersion
		PSHostVersion        = $PSVersionTable.PSVersion
		SessionAudience      = $session.Audience
		SessionExpiry        = $session.Expiry
		SessionId            = $session.SessionId
		ApiUrl               = $session.ApiURL
		CoreFlowUrl          = $session.CoreFlowUrl
		Datacenter           = $session.Datacenter
	}
}
