function Disconnect-CvAPI {
	<#
	.SYNOPSIS
	Disconnects from the CoreView API.
	#>
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([Hashtable])]
	param ()

	process {
		ThrowExceptionIfNotAuthenticated
		DisconnectSession
		WriteSuccessMsg
	}

	begin {
		function ThrowExceptionIfNotAuthenticated {
			if (-not (Test-Path Variable:script:CvSessionObject)) {
				Write-ErrorMsg SessionNotInitialized
			}
		}

		function DisconnectSession {
			Remove-Variable -Name CvSessionObject -Scope Script -Force -ErrorAction SilentlyContinue | Out-Null
		}

		function WriteSuccessMsg {
			Write-InfoMsg SessionSuccessfullyDisconnected
		}
	}
}
