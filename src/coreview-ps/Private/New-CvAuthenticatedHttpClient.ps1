function New-CvAuthenticatedHttpClient {
	<#
	.SYNOPSIS
		Logs in to CoreView and returns a [HttpClient] object
	#>
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([System.Net.Http.HttpClient])]
	param(
		[Parameter(Mandatory, Position = 1)]
		[securestring]$APIKey
	)

	process {
		CreateNewHttpClient
		GetLoginEndpointURL
		InitiateLoginRequest
		ExtractBearerTokenFromResponse
		AddBearerTokenToHttpClient
	}

	end {
		ReturnHttpClient
	}

	begin {
		$mutable = @{}

		function CreateNewHttpClient {
			$mutable.httpClient = New-CvHttpClient
		}

		function GetLoginEndpointURL {
			$env = (Get-CvEnvironment -HttpClient $mutable.httpClient -ErrorAction Stop)
			$mutable.loginEndpoint = $env.baseAuthUrl.ToString() + 'api/auth'
		}

		function InitiateLoginRequest {
			try {
				$response = SendLoginRequest
			}
			catch {
				HandleErrorResponse $_
			}
			$mutable.response = $response
		}

		function SendLoginRequest {
			$params = @{
				Method     = 'POST'
				Endpoint   = $mutable.loginEndpoint
				HttpClient = $mutable.httpClient
			}
			$mutable.httpClient.DefaultRequestHeaders.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::new('Bearer', (DecodeApiKey))
			return Invoke-CvRequest @params
		}

		function DecodeApiKey {
			return ($APIKey | ConvertFrom-SecureString -AsPlainText).Trim()
		}

		function HandleErrorResponse ($err) {
			Write-ErrorMsg CoreViewCredentialsRefused
		}

		function ExtractBearerTokenFromResponse {
			if (-not $mutable.response.ContainsKey('bearerToken')) {
				Write-ErrorMsg CoreViewDidNotGenerateJWT
			}

			$mutable.bearerToken = $mutable.response.bearerToken
		}

		function AddBearerTokenToHttpClient {
			$mutable.httpClient.DefaultRequestHeaders.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::new('Bearer', $mutable.bearerToken)
		}

		function ReturnHttpClient {
			return $mutable.httpClient
		}
	}
}
