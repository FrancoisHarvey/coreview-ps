# Enable strict mode:
Set-StrictMode -Version 3.0
$script:ErrorActionPreference = 'Stop'

# Set the output encoding to UTF-8:
$OutputEncoding = [System.Text.Encoding]::UTF8

# Import the localized translations:
$mainCulture = 'en-US'
$i18nBaseDirectory = $PSScriptRoot + '\i18n'
Import-LocalizedData -BaseDirectory $i18nBaseDirectory -FileName 'i18n.psd1' -BindingVariable msgTable -UICulture $mainCulture

if ($PSUICulture -ne $mainCulture) {
	$localizedMsgTable = @{}
	Import-LocalizedData -BaseDirectory $i18nBaseDirectory -FileName 'i18n.psd1' -BindingVariable localizedMsgTable -ErrorAction SilentlyContinue

	$localizedMsgTable.GetEnumerator() | ForEach-Object {
		$msgTable[$_.Key] = $_.Value
	}
}
