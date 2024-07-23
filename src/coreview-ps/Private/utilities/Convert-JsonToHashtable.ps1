function Convert-JsonToHashtable {
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([hashtable])]
	param(
		[Parameter(ValueFromPipeline)]
		[String]$Json
	)

	process {
		return $Json | ConvertFrom-Json -AsHashtable -ErrorAction Stop | ConvertTo-Hashtable -ErrorAction Stop
	}
}
