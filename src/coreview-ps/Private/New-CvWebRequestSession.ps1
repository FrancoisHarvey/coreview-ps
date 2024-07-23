function New-CvWebRequestSession {
	<#
	.SYNOPSIS
		Logs in to CoreView and returns a [WebRequestSession] object
	#>
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([Microsoft.PowerShell.Commands.WebRequestSession])]
	param(
		[Parameter(Mandatory, Position = 1)]
		[String]$APIKey
	)

	process {
		GetLoginEndpointURL
		InitiateLoginRequest
		ConvertResponseToHashtable
		ExtractBearerTokenFromResponse
		AddBearerTokenToSession
		AddRefreshTokenToSession
	}

	end {
		ReturnWebRequestSession
	}

	begin {
		$APIKey = $APIKey.Trim()
		$mutable = @{}

		function GetLoginEndpointURL {
			$env = (Get-CvEnvironment -ErrorAction Stop)
			$mutable.loginEndpoint = $env.baseAuthUrl.ToString() + 'api/auth'
		}

		function InitiateLoginRequest {
			try {
				$response = SendLoginRequest
			}
			catch {
				HandleErrorResponse $_
			}
			$mutable.jsonResponse = $response.Content
		}

		function SendLoginRequest {
			$local:cvSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
			$params = @{
				Uri              = $mutable.loginEndpoint
				Method           = 'POST'
				Headers          = @{
					Accept           = 'application/json;charset=utf-8'
					'Accept-Charset' = 'utf-8'
					Authorization    = "Bearer $APIKey"
					'Content-Length' = 0
				}
				SessionVariable  = 'cvSession'
				UseBasicParsing  = $true
				DisableKeepAlive = $true
				TimeoutSec       = 30
			}
			Write-VerboseMsg SendingLoginRequestToCoreView
			$mutable.webRequestSession = $cvSession
			return (Invoke-WebRequest @params -ErrorAction Stop)
		}

		function HandleErrorResponse ($err) {
			Write-ErrorMsg CoreViewCredentialsRefused
		}

		function ConvertResponseToHashtable {
			$mutable.reponse = ($mutable.jsonResponse | Convert-JsonToHashtable -ErrorAction Stop)
		}

		function ExtractBearerTokenFromResponse {
			if (-not $mutable.reponse.ContainsKey('bearerToken')) {
				Write-ErrorMsg CoreViewDidNotGenerateJWT
			}

			$mutable.bearerToken = $mutable.reponse.bearerToken
		}

		function AddBearerTokenToSession {
			$mutable.webRequestSession.Headers.Remove('Authorization') | Out-Null
			$mutable.webRequestSession.Headers.Add('Authorization', "Bearer $($mutable.bearerToken)") | Out-Null
		}

		function AddRefreshTokenToSession {
			$mutable.webRequestSession.Headers.Add('X-RefreshToken', $mutable.reponse.refreshToken) | Out-Null
		}

		function ReturnWebRequestSession {
			return $mutable.webRequestSession
		}
	}
}
