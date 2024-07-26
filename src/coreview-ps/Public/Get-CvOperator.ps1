function Get-CvOperator {
	[OutputType([hashtable])]
	[CmdletBinding(ConfirmImpact = 'Low')]
	param (
		[Parameter()]
		[System.Net.Mail.MailAddress]$Username
	)

	$session = Get-CvSessionObject

	$params = @{
		Endpoint   = [Uri]::new($session.ApiURL, 'api/register')
		HttpClient = $session.httpClient
	}

	if ($Username) {
		$params.SearchParams = @{
			username = $Username.ToString()
		}
	}

	$operator = Invoke-CvRequest @params

	$params = @{
		Endpoint     = [Uri]::new($session.ApiURL, 'api/securitymanager/customMenu')
		HttpClient   = $session.httpClient
		SearchParams = @{
			userId = $operator.userAuthId
		}
	}

	$operator.permissions += (Invoke-CvRequest @params).customMenus | Select-Object -ExpandProperty name

	return $operator
}
