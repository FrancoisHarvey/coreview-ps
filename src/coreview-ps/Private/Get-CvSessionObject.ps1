function Get-CvSessionObject {
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([Hashtable])]
	param ()

	process {
		ThrowExceptionIfNotAuthenticated
		RefreshBearerTokenIfRequired
	}

	end {
		ReturnSessionObject
	}

	begin {
		function ThrowExceptionIfNotAuthenticated {
			if (-not (Test-Path Variable:script:CvSessionObject)) {
				Write-ErrorMsg SessionNotInitialized
			}
		}

		function RefreshBearerTokenIfRequired {
			if (-not (IsTokenExpired)) {
				return
			}

			Write-InfoMsg RefreshingJWT
			Connect-CvApi (RetreiveApiKey) -Confirm:$false | Out-Null
			Write-VerboseMsg SessionSuccessfullyRefreshed
		}

		function IsTokenExpired {
			# Adjusted for a maximum clock skew of 10 minutes
			return [DateTimeOffset]::UtcNow.AddMinutes(10) -ge $script:CvSessionObject.Expiry
		}

		function RetreiveApiKey {
			return $script:CvSessionObject._apiKey
		}

		function ReturnSessionObject {
			return $script:CvSessionObject
		}
	}
}
