function ConvertTo-YesNo {
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
		[Boolean]$Value
	)

	process {
		if ($Value) {
			return (Get-Msg YesBoolean)
		}

		return (Get-Msg NoBoolean)
	}
}
