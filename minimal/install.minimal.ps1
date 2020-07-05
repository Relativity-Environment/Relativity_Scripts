﻿
<# Opcion 1 - Instalacion de opcion minimal #>

$BoxPackageName         =   "install.minimal"

if (Test-PendingReboot) { Invoke-Reboot }   

function Install-Module{
  
 
    $null = New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\module_relativity" -ErrorAction SilentlyContinue
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/module/module.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\module.psm1"
    
  
} 

Install-Module
Import-Module "$env:LOCALAPPDATA\module_relativity\module.psm1" -Force -ErrorAction Stop
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

$ErrorActionPreference  =   'Continue'


$ChocoInstalls = @(
        
        'ruby',
        'nuget.commandline',
        'git',
        'git-credential-manager-for-windows',
        'git-credential-winstore',
        'gitextensions',
        'python2',
        'python3',
        'golang',
        'strawberryperl', 
        'curl',
        'php',
        'Cygwin',
        'Firefox',
        'keypirinha',
        'nano',
        'vim',
        'openssl',
        'mitmproxy',
        'phantomjs',
        'ffmpeg',
        'nmap',
        'notepadplusplus',
        'putty',
        'babun',
        'superputty',
        'terminals',
        'toolsroot',
        'activeperl',
        'win32diskimager',
        'windirstat',
        'winscp',
        'yumi',
        '7zip',
        '7zip.commandline',
        'rar',
        'winpcap',
        'javaruntime',
        'tor-browser'    
        
)
Install-ChocoPackages
<#

    $ManualDownloadInstall = @{

    'nikto.zip'   = 'https://github.com/sullo/nikto/archive/master.zip'
    'Vulnerator.zip'  = 'https://github.com/Vulnerator/Vulnerator/releases/download/v6.1.9/Vulnerator_v6-1-9.zip'
}

    Get-DownloadManual -UtilDownloadPath "$env:TEMP\vulsweb" -UtilBinPath 



#>

