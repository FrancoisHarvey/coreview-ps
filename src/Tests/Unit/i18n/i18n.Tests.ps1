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
	Describe 'i18n System Tests' -Tag Unit {
		BeforeAll {
			$WarningPreference = 'SilentlyContinue'
			$ErrorActionPreference = 'SilentlyContinue'

			$i18nBaseDirectory = $PSScriptRoot + '\..\..\..\coreview-ps\i18n'
			$mainCulture = 'en-US'
			$otherCultures = [string[]]((Get-ChildItem -Directory -Path $i18nBaseDirectory -Exclude $mainCulture).Name)
		}
		Context 'Error' {
		}
		Context 'Success' {
			It 'should define the same number of strings for each language' {
				Import-LocalizedData -BaseDirectory $i18nBaseDirectory -FileName 'i18n.psd1' -BindingVariable msgTable -UICulture $mainCulture

				foreach ($otherCulture in $otherCultures) {
					$localizedMsgTable = @{}
					Import-LocalizedData -BaseDirectory $i18nBaseDirectory -FileName 'i18n.psd1' -BindingVariable localizedMsgTable -UICulture $otherCulture -ErrorAction Stop

					$localizedMsgTable.Count | Should -BeExactly $msgTable.Count -Because "$otherCulture should contain the same number of lines as $mainCulture"
				}
			}
		}
	}
}
