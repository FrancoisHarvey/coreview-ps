Set-StrictMode -Version 3.0
$script:ErrorActionPreference = 'Stop'
$OutputEncoding = [System.Text.Encoding]::UTF8

$msgTable = Data {
ConvertFrom-StringData @'
helloWorld = Hello, happy {0} World!
'@
}
Import-LocalizedData -BindingVariable msgTable

function Get-Msg {
    [CmdletBinding()]
    Param
    (
        [parameter(mandatory=$true, position=0)][string]$MsgKey,
        [parameter(mandatory=$false, position=1, ValueFromRemainingArguments=$true)]$Substitutions
    )
    return $msgTable.$MsgKey -f $Substitutions
}
