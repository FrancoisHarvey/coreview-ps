function Connect-CvAPI {
	[CmdletBinding(ConfirmImpact = 'Low', SupportsShouldProcess)]
	param (
		[Parameter(Mandatory = $true)]
		[string]$APIKey
	)

	process {
		InitiateNewSession
		ExtractBearerTokenFromSession
		ExtractClaimsFromBearerToken
		GenerateSCompanyFromClaims
		AddSCompanyHeaderToSession
		CreateSessionObject
		SaveSessionObject
	}

	end {
		PrintSuccessMessage
	}

	begin {
		$mutable = @{}

		function CheckIfShouldProcess {
			return $PSCmdlet.ShouldProcess((Get-Msg 'LoginShouldProcess' $APIKey), 'Connect-CvAPI', 'Script')
		}

		function InitiateNewSession {
			$mutable.cvSession = New-CvWebRequestSession $APIKey -ErrorAction Stop
		}

		function ExtractBearerTokenFromSession {
			$mutable.bearerToken = $mutable.cvSession.Headers.Authorization.Substring(7)
		}

		function ExtractClaimsFromBearerToken {
			$mutable.JWTContent = Expand-JWTClaims $mutable.bearerToken -ErrorAction Stop
		}

		function GenerateSCompanyFromClaims {
			$mutable.SCompany = $mutable.JWTContent.oid + '|' + (ConvertTo-Base64 $mutable.JWTContent.oname) + '--'
		}

		function AddSCompanyHeaderToSession {
			if (-not $mutable.cvSession.Headers.ContainsKey('X-SCompany')) {
				$mutable.cvSession.Headers.Add('X-SCompany', $mutable.SCompany) | Out-Null
			}
		}

		function CreateSessionObject {
			$mutable.SessionObject = @{
				webRequestSession = $mutable.cvSession
				SessionId         = $mutable.JWTContent.skey.Split(':')[2]
				IssuedAt          = [DateTimeOffset]::FromUnixTimeSeconds([long]$mutable.JWTContent.iat)
				Expiry            = [DateTimeOffset]::FromUnixTimeSeconds([long]$mutable.JWTContent.exp)
				SCompany          = $mutable.SCompany
				CompanyId         = $mutable.JWTContent.oid
				CompanyName       = $mutable.JWTContent.oname
				OperatorUserName  = $mutable.JWTContent.preferred_username
				OperatorUserId    = $mutable.JWTContent.sub
				OperatorName      = $mutable.JWTContent.name
				Audience          = $mutable.JWTContent.aud
				Roles             = $mutable.JWTContent.roles
				_claims           = $mutable.JWTContent
			}
		}

		function SaveSessionObject {
			if (-not (CheckIfShouldProcess)) {
				Write-WarningMsg OperationCancelled -Stop
			}
			$script:CvSessionObject = $mutable.SessionObject
		}

		function PrintSuccessMessage {
			Write-InfoMsg LoginSuccess ($mutable.SessionObject.OperatorUserName)
			Write-VerboseMsg RunCvContextForInfo
		}
	}
}
