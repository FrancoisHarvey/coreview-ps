function ConvertTo-CaseInsensitiveHashtable {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
		[Hashtable]$Hashtable
	)

	process {
		return [HashTable]::New($Hashtable, [StringComparer]::OrdinalIgnoreCase)
	}
}
