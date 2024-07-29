function Connect-CvAPI {
	<#
	.SYNOPSIS
	Connects to the CoreView API using the specified API key.

	.DESCRIPTION
	The Connect-CvAPI cmdlet is used to connect to the CoreView API using the
	specified API key. The API key must be provided as a SecureString. Once
	connected, the -Cv cmdlets can be used to interact with the CoreView
	4ward365 API and the CoreView CoreFlow API.

	.PARAMETER APIKey
	Specifies the API key to use to connect to the CoreView API. The API key
	must be provided as a SecureString.

	.OUTPUTS
	None

	.EXAMPLE
	PS> Connect-CvAPI -APIKey (ConvertTo-SecureString -String 'my-api-key' -AsPlainText -Force)

	.EXAMPLE
	PS> Connect-CvAPI -APIKey $SecureAPIKey
	#>
	[CmdletBinding(ConfirmImpact = 'Low', SupportsShouldProcess)]
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[SecureString]$APIKey
	)

	process {
		InitiateNewSession
		ExtractBearerTokenFromHttpClient
		ExtractClaimsFromBearerToken
		AddFromHeaderToHttpClient
		GenerateSCompanyFromClaims
		AddSCompanyHeaderToHttpClient
		ObtainOrganizationInfo
		ExtractAPIUrls
		ObtainOperatorInfo
		CreateSessionObject
		SaveSessionObject
	}

	end {
		PrintSuccessMessage
	}

	begin {
		$mutable = @{}

		function CheckIfShouldProcess {
			return $PSCmdlet.ShouldProcess((Get-Msg 'LoginShouldProcess' (DecodeApiKey)), 'Connect-CvAPI', 'Script')
		}

		function InitiateNewSession {
			$mutable.httpClient = New-CvAuthenticatedHttpClient $APIKey -ErrorAction Stop
		}

		function DecodeApiKey {
			return ($APIKey | ConvertFrom-SecureString -AsPlainText).Trim()
		}

		function ExtractBearerTokenFromHttpClient {
			$mutable.bearerToken = $mutable.httpClient.DefaultRequestHeaders.Authorization.ToString().Substring(7)
		}

		function ExtractClaimsFromBearerToken {
			$mutable.JWTContent = Expand-JWTClaims $mutable.bearerToken -ErrorAction Stop
		}

		function AddFromHeaderToHttpClient {
			$mutable.httpClient.DefaultRequestHeaders.From = $mutable.JWTContent.email
		}

		function GenerateSCompanyFromClaims {
			$mutable.SCompany = $mutable.JWTContent.oid + '|' + (ConvertTo-Base64 $mutable.JWTContent.oname) + '--'
		}

		function AddSCompanyHeaderToHttpClient {
			if (-not $mutable.httpClient.DefaultRequestHeaders.Contains('X-SCompany')) {
				$mutable.httpClient.DefaultRequestHeaders.Add('X-SCompany', $mutable.SCompany) | Out-Null
			}
		}

		function ObtainOrganizationInfo {
			Write-VerboseMsg ObtainingOrganizationInfo
			$params = @{
				HttpClient = $mutable.httpClient
				Endpoint   = [Uri]::new((GetEnvironment).baseCentralUrl, "api/organization/check")
			}
			$mutable.orgInfo = Invoke-CvRequest @params
		}

		function ExtractAPIUrls {
			$mutable.APIUrl = [Uri]$mutable.orgInfo.apiUrl
			$mutable.Datacenter = $mutable.orgInfo.dataCenter
			$mutable.CoreFlowAPIUrl = (GetEnvironment).workflowUrlV2.($mutable.Datacenter)
		}

		function GetEnvironment {
			return Get-CvEnvironment -HttpClient $mutable.httpClient
		}

		function ObtainOperatorInfo {
			Write-VerboseMsg ObtainingOperatorInfo
			$params = @{
				HttpClient = $mutable.httpClient
				Endpoint   = [Uri]::new($mutable.APIUrl, "api/register")
			}
			$mutable.operatorInfo = Invoke-CvRequest @params
		}

		function CreateSessionObject {
			$mutable.SessionObject = @{
				HttpClient           = $mutable.httpClient
				SessionId            = $mutable.JWTContent.skey.Split(':')[2]
				IssuedAt             = [DateTimeOffset]::FromUnixTimeSeconds([long]$mutable.JWTContent.iat)
				Expiry               = [DateTimeOffset]::FromUnixTimeSeconds([long]$mutable.JWTContent.exp)
				SCompany             = $mutable.SCompany
				TenantId             = $mutable.orgInfo.tenantID
				CompanyId            = $mutable.JWTContent.oid
				CompanyName          = $mutable.orgInfo.displayName
				OrgIdentity          = $mutable.orgInfo.identity
				OrgType              = $mutable.orgInfo.organizationType
				OrgSubscriptionLevel = $mutable.orgInfo.subscriptionLevel
				OrgRoles             = $mutable.orgInfo.organizationRoles
				OrgPortalSkus        = $mutable.orgInfo.portalSkus
				OperatorUserName     = $mutable.JWTContent.preferred_username
				OperatorUserId       = $mutable.JWTContent.sub
				OperatorName         = $mutable.JWTContent.name
				OperatorRoles        = $mutable.JWTContent.roles
				OperatorDirectRoles  = $mutable.operatorInfo.roles
				OperatorRoleGroups   = $mutable.operatorInfo.roleGroups
				OperatorVTenants     = $mutable.operatorInfo.userGroupMemberships
				OperatorLanguage     = $mutable.operatorInfo.preferredLanguage
				Audience             = $mutable.JWTContent.aud
				ApiURL               = $mutable.APIUrl
				CoreFlowUrl          = $mutable.CoreFlowAPIUrl
				Datacenter           = $mutable.Datacenter
				_claims              = $mutable.JWTContent
				_apiKey              = $APIKey
			}
		}

		function SaveSessionObject {
			if (-not (CheckIfShouldProcess)) {
				Write-WarningMsg OperationCancelled -Stop
			}
			$script:CvSessionObject = $mutable.SessionObject.Clone()
		}

		function PrintSuccessMessage {
			Write-InfoMsg LoginSuccess ($mutable.SessionObject.OperatorUserName)
			Write-VerboseMsg RunCvContextForInfo
		}
	}
}
