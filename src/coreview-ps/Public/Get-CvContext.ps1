function Get-CvContext {
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([Hashtable])]
	param ()

	$session = Get-CvSessionObject
	$env = Get-CvEnvironment
	$module = Get-Module 'coreview-ps'

	return @{
		CompanyId        = $session.CompanyId
		CompanyName      = $session.CompanyName
		ModuleName       = $module.Name
		ModuleVersion    = $module.Version
		OperatorName     = $session.OperatorName
		OperatorRoles    = $session.Roles
		OperatorUserId   = $session.OperatorUserId
		OperatorUserName = $session.OperatorUserName
		PortalAppName    = $env.name
		PortalAppVersion = $env.appVersion
		PSHostVersion    = $PSVersionTable.PSVersion
		SessionAudience  = $session.Audience
		SessionExpiry    = $session.Expiry
		SessionId        = $session.SessionId
	}
}
