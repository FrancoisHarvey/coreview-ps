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
	Describe 'Get-CvEnvironment Private Function Tests' -Tag Unit {
		BeforeAll {
			$WarningPreference = 'SilentlyContinue'
			$ErrorActionPreference = 'SilentlyContinue'
		}
		Context 'Error' {
		}
		Context 'Success' {
			It 'should return a hashtable' {
				Should -ActualValue (Get-CvEnvironment) -BeOfType System.Collections.Hashtable
			}

			It 'should have the property baseAuthUrl of type Uri' {
				$env = Get-CvEnvironment
				$env.baseAuthUrl | Should -BeOfType System.Uri
			}
		}
	}
}
