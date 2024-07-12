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

	return $Obj
}
