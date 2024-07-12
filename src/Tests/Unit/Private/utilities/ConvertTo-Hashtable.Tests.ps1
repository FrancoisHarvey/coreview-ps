#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'coreview-ps'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'coreview-ps' {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------
    Describe 'ConvertTo-Hashtable Private Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        }
        Context 'Error' {
        }
        Context 'Success' {
            It 'should should return a Hashtable when given a PSObject' {
                $PSO = [PSCustomObject]@{
                    foo = 123
                }
                (ConvertTo-Hashtable $PSO).GetType() | Should -BeExactly [Hashtable]
            }
        }
    }
}
