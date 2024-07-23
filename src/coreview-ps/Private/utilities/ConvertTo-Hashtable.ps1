function ConvertTo-Hashtable {
	<#
	.SYNOPSIS
		Converts a [PSObject] to [Hashtable]

	.PARAMETER Obj
		The [PSObject] to be converted

	.OUTPUTS
		A new [Hashtable] that represents the [PSObject]
	#>
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline, Position = 1)]
		$Obj
	)

	$isArray = $Obj -is [System.Collections.IEnumerable] `
		-and $Obj -isnot [String] `
		-and $Obj -isnot [System.Collections.IDictionary]

	if ($isArray) {
		$json = $Obj | ConvertTo-Json -Depth 20 -Compress -AsArray -ErrorAction Stop
		$ht = $json | ConvertFrom-Json -AsHashtable -ErrorAction Stop

		if ($Obj.Count -eq 0) {
			return , @()
		}
		elseif ($Obj.Count -eq 1) {
			return , @($ht)
		}
		else {
			return , $ht
		}
	}

	$json = $Obj | ConvertTo-Json -Depth 20 -Compress -ErrorAction Stop
	$ht = $json | ConvertFrom-Json -AsHashtable -ErrorAction Stop

	return $ht
}
