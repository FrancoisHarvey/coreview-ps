function Convert-JsonToHashtable {
	[CmdletBinding()]
	[OutputType([hashtable])]
	param(
		[Parameter(ValueFromPipeline)]
		[String]$Json
	)

	return $Json | ConvertFrom-Json -AsHashtable -ErrorAction Stop | ConvertTo-Hashtable -ErrorAction Stop
}
