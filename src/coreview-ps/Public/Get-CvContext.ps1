function Get-CvContext {
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([Hashtable])]
	param ()

	if (-not (Test-Path Variable:script:CvSessionObject)) {
		Write-ErrorMsg SessionNotInitialized
	}

	$env = Get-CvEnvironment
	$module = Get-Module 'coreview-ps'

	return @{
		CompanyId        = $CvSessionObject.CompanyId
		CompanyName      = $CvSessionObject.CompanyName
		ModuleName       = $module.Name
		ModuleVersion    = $module.Version
		OperatorName     = $CvSessionObject.OperatorName
		OperatorRoles    = $CvSessionObject.Roles
		OperatorUserId   = $CvSessionObject.OperatorUserId
		OperatorUserName = $CvSessionObject.OperatorUserName
		PortalAppName    = $env.name
		PortalAppVersion = $env.appVersion
		PSHostVersion    = $PSVersionTable.PSVersion
		SessionAudience  = $CvSessionObject.Audience
		SessionExpiry    = $CvSessionObject.Expiry
		SessionId        = $CvSessionObject.SessionId
	}
}
