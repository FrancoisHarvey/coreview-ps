function Confirm-CvOperatorHasRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string[]]$OneOf
	)

	$session = Get-CvSessionObject
	$operatorRoles = $session.OperatorRoles

	foreach ($role in $oneOf) {
		if ($operatorRoles -contains $role) {
			return
		}
	}

	Write-ErrorMsg OperatorMustPossessRole ($OneOf -join ', ')
}
