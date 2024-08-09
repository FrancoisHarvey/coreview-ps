function Get-CvContext {
	<#
	.SYNOPSIS
	Retrieves data about the session of the logged-in user.

	.DESCRIPTION
	The Get-CvContext cmdlet retrieves detailed information about the current
	session after connecting to the CoreView API using the Connect-CvAPI cmdlet.
	It returns a hashtable containing various session details, environment
	information, and module metadata.

	.PARAMETER None
	This cmdlet does not take any parameters.

	.OUTPUTS
	Hashtable
	A hashtable containing the following keys and their corresponding values:
	- TenantId: The tenant ID of the organization.
	- CompanyId: The company ID of the organization.
	- CompanyName: The company name of the organization.
	- OrgIdentity: The M365 identity of the organization.
	- OrgType: The company type of the organization.
	- OrgSubscriptionLevel: The subscription level of the organization.
	- OrgRoles: The roles associated with the organization.
	- OrgPortalSkus: The portal SKUs associated with the organization.
	- ModuleName: The name of the PowerShell module.
	- ModuleVersion: The version of the PowerShell module.
	- OperatorName: The name of the operator.
	- OperatorRoles: The roles of the operator.
	- OperatorUserId: The user ID of the operator.
	- OperatorUserName: The username of the operator.
	- PortalAppName: The name of the portal application.
	- PortalAppVersion: The version of the portal application.
	- PSHostVersion: The version of the PowerShell host.
	- SessionAudience: The audience of the session.
	- SessionExpiry: The expiry time of the session.
	- SessionId: The ID of the session.
	- ApiUrl: The API URL used to communicate with 4ward365.
	- CoreFlowUrl: The CoreFlow URL used to communicate with CoreFlow.
	- Datacenter: The datacenter assigned to the organization.

	.EXAMPLE
	PS> Get-CvContext

	This example retrieves the current session context and displays the session
	details in a hashtable.
	#>
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([Hashtable])]
	param ()

	$session = Get-CvSessionObject
	$env = Get-CvEnvironment -HttpClient $session.httpClient
	$module = Get-Module 'coreview-ps'
	$moduleMeta = $MyInvocation.MyCommand.Module.PrivateData

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
		ModuleBuildNumber    = $moduleMeta.BuildNumber
		ModuleCommitHash     = $moduleMeta.BuildCommitHash
		OperatorName         = $session.OperatorName
		OperatorRoles        = $session.OperatorRoles
		OperatorDirectRoles  = $session.OperatorDirectRoles
		OperatorRoleGroups   = $session.OperatorRoleGroups
		OperatorUserId       = $session.OperatorUserId
		OperatorUserName     = $session.OperatorUserName
		OperatorVTenants     = $session.OperatorVTenants
		OperatorLanguage     = $session.OperatorLanguage
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
