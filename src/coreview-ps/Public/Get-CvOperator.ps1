function Get-CvOperator {
	<#
	.SYNOPSIS
	Retrieves details about a CoreView operator from the CoreView API.

	.DESCRIPTION
	The Get-CvOperator cmdlet retrieves detailed information about a CoreView
	operator. When the -Username parameter is specified, it requests details for
	the specified CoreView operator. If the -Username parameter is absent, it
	retrieves details for the logged-in user.

	.PARAMETER Username
	Specifies the email address of the CoreView operator whose details are to be
	retrieved. If this parameter is not provided, the cmdlet retrieves details
	for the logged-in user.

	.OUTPUTS
	Hashtable
	A hashtable containing the details of the CoreView operator, including
	permissions.

	.EXAMPLE
	PS> Get-CvOperator -Username "operator@example.com"

	This example retrieves the details for the CoreView operator with the email
	address "operator@example.com".

	.EXAMPLE
	PS> Get-CvOperator

	This example retrieves the details for the logged-in user.
	#>
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
