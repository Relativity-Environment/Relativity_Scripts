
<# Opcion 1 #>

if (Test-PendingReboot) { Invoke-Reboot }   

$null = New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\module_relativity" -ErrorAction SilentlyContinue
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/neccesary_files/module.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\module.psm1" -ErrorAction SilentlyContinue

Write-Host "Import the OWN module" -ForegroundColor red
Import-Module "$env:LOCALAPPDATA\module_relativity\module.psm1" -Force 
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

Add-EnvVariables


## Install log

$global:chageLog = "$Env:USERPROFILE\Desktop\changelog"

If (-not (Test-Path $global:chageLog )) {

  New-Item -ItemType 'file' $global:chageLog -ErrorAction SilentlyContinue

}

Write-Output "[+] Comienza la instalacion:"  > $global:chageLog 
Get-Date >> $global:chageLog 


#### CINST Install

$global:ChocoInstalls = @(
        
        'syspin',
        'ruby',
        'javaruntime',
        'nuget.commandline',
        'git',
        'git-credential-manager-for-windows',
        'git-credential-winstore',
        'gitextensions',
        'dotnet3.5',
        'python2',
        'python3',
        'golang',
        'activeperl',
        'strawberryperl',
        'winpcap', 
        'curl',
        'php',
        'Cygwin',
        'keypirinha',
        'nano',
        'vim',
        'phantomjs',
        'nmap',
        'notepadplusplus',
        'putty',
        'babun',
        'superputty',
        'terminals',
        'toolsroot',
        'ffmpeg',
        'win32diskimager',
        'windirstat',
        'winscp',
        '7zip',
        '7zip.commandline',
        'winrar',
        'openssl',
        'tor-browser'
        'Firefox',
        'wireshark',
        'netfoxdetective',
        'microsoft-message-analyzer',
        'nmap',
        'zap',
        'mitmproxy',
        'hashtools',
        'burp-suite-free-edition'
        
)
Install-ChocoPackages
refreshenv

Stop-process -Name "HashTools"


## Manual Install
  
    $global:ManualDownloadInstall = @{

       # compress files

        'FOCA-v3.4.7.0.zip'                         = 'https://github.com/ElevenPaths/FOCA/releases/download/v3.4.7.0/FOCA-v3.4.7.0.zip'
        'EvilFoca.zip'					                    = 'https://github.com/ElevenPaths/EvilFOCA/releases/download/0.1.4.0/EvilFoca.zip'
        'john-1.8.0.13-jumbo-b7eae75d7-win64.zip'  	= 'https://download.openwall.net/pub/projects/john/contrib/windows/john-1.8.0.13-jumbo-b7eae75d7-win64.zip'
        'sqlmap-master.zip'					                = 'https://github.com/sqlmapproject/sqlmap/zipball/master'
        'SMTP_Diag_Tool.zip'					            	= 'https://www.adminkit.net/files/smtp_diag_tool/SMTP_Diag_Tool.zip'
        'thc-hydra.zip'								              = 'https://github.com/maaaaz/thc-hydra-windows/archive/master.zip'
        'nikto-master.zip'			                  	= 'https://github.com/sullo/nikto/archive/master.zip'
        'Vulnerator.zip'       					          	= 'https://github.com/Vulnerator/Vulnerator/releases/download/v6.1.9/Vulnerator_v6-1-9.zip'
        'NetworkMiner_2-5.zip'					          	= 'https://www.netresec.com/?download=NetworkMiner'
        'JavaRuleSetter.zip'	                    	= 'https://www.elevenpaths.com/downloads/JavaRuleSetter.zip'
        'emetrules.zip'                 						= 'https://www.elevenpaths.com/downloads/emetrules.zip'
        'gmtcheck'						                      = 'https://www.elevenpaths.com/downloads/gmtcheck.zip'
        'Google_Index_Retriever.zip'	             	= 'https://www.elevenpaths.com/downloads/Google_Index_Retriever.zip'
        'rainbowcrack-1.7-win64.zip' 				        = 'https://project-rainbowcrack.com/rainbowcrack-1.7-win64.zip'
        'bettercap_windows_amd64_v2.28.zip'			    = 'https://github.com/bettercap/bettercap/releases/download/v2.28/bettercap_windows_amd64_v2.28.zip' 
        'hashcat-6.0.0.7z'                          = 'https://hashcat.net/files/hashcat-6.0.0.7z'

        # aws
        'PIT-Public_Intellegence_Tool_V2.5.1.rar'   = 'http://52.210.171.72/gravity/PIT-Public_Intellegence_Tool_V2.5.1.rar'
        'SpiderFoot-2.11-w32.zip'               	  = 'http://52.210.171.72/gravity/SpiderFoot-2.11-w32.zip'
        'ettercap-0.7.6.zip'                        = 'http://52.210.171.72/gravity/ettercap-0.7.6.zip'
        'ophcrack-3.8.0-bin.zip'                    = 'http://52.210.171.72/gravity/ophcrack-3.8.0-bin.zip'
        'proxytunnel-190-cygwin.zip'                = 'http://52.210.171.72/gravity/proxytunnel-190-cygwin.zip'    
       
        #>
        
        # MSI files

        'Nessus-8.10.1-x64.msi'                   = 'http://52.210.171.72/gravity/Nessus-8.10.1-x64.msi'
        'metasploitframework-latest.msi' 			    = 'https://windows.metasploit.com/metasploitframework-latest.msi'
        
        # AHK install
        'MaltegoSetup.JRE64.v4.2.11.13104.exe' 			= 'https://maltego-downloads.s3.us-east-2.amazonaws.com/windows/MaltegoSetup.JRE64.v4.2.11.13104.exe'
        'VegaSetup64.exe'     						        	= 'https://support.subgraph.com/downloads/VegaSetup64.exe'
        'MedusaInstaller-d33b6ab.exe'               = 'https://github.com/pymedusa/MedusaInstaller/releases/download/0.6/MedusaInstaller-d33b6ab.exe'
        'ncrack-0.7-setup.exe'                      = 'https://nmap.org/ncrack/dist/ncrack-0.7-setup.exe'
        'smac27_setup.exe'                          = 'http://www.klcconsulting.net/smac/smac27_download/smac27_setup.exe'
        'mitmproxy-5.1.1-windows-installer.exe'     = 'https://snapshots.mitmproxy.org/5.1.1/mitmproxy-5.1.1-windows-installer.exe'
        'DirBuster-0.12-Setup.exe'                  = 'http://52.210.171.72/gravity/DirBuster-0.12-Setup.exe'
        'smart_dns_changer_setup.exe'               = 'http://52.210.171.72/gravity/smart_dns_changer_setup.exe'
          # unzip and install
            'johnny_2.2_win.zip'                        = 'https://openwall.info/wiki/_media/john/johnny/johnny_2.2_win.zip'
            'TMACv6.0.7_Setup.zip'                      = 'https://download.technitium.com/tmac/TMACv6.0.7_Setup.zip'
            'SNMPScannerSetup.zip'                      = 'http://52.210.171.72/gravity/SNMPScannerSetup.zip' 
        
        
        #>
        

    }
    Install-Apps

## Get PE Files

    $global:PEAPPS = @{
  
      # EXE
       'ipscan-3.7.2-setup.exe'					          = 'https://github.com/angryip/ipscan/releases/download/3.7.2/ipscan-win64-3.7.2.exe'
       'arpspoof.exe' 							              = 'https://github.com/alandau/arpspoof/releases/download/v0.1/arpspoof.exe'
       'MicEnum.exe'					                  	= 'https://www.elevenpaths.com/downloads/MicEnum.exe'
       'crunch_win.exe'                           = 'https://github.com/shadwork/Windows-Crunch/releases/download/v1.1/crunch_win.exe'
       'HashIdentifier.exe'                       = 'http://52.210.171.72/gravity/HashIdentifier.exe'
       'tcprelay.exe'                             = 'http://52.210.171.72/gravity/tcprelay.exe'
       
       
      # JAR
       'webgoat-server-8.0.0.M21.jar'             = 'https://github.com/WebGoat/WebGoat/releases/download/v8.0.0.M21/webgoat-server-8.0.0.M21.jar'
       'webwolf-8.0.0.M21.jar'                    = 'https://github.com/WebGoat/WebGoat/releases/download/v8.0.0.M21/webwolf-8.0.0.M21.jar'
      
      # PY
       'pesto.py'						                      = 'https://raw.githubusercontent.com/ElevenPaths/PESTO/master/pesto.py'

      # Others
       'certificate transparency'		              = 'https://www.elevenpaths.com/downloads/firefox/certificate-transparency-checker.xpi'
       'thumbprint.ps1'		                      	= 'https://raw.githubusercontent.com/ElevenPaths/Gists/master/Thumbprint/thumbprint.ps1'

    }
    Get-PE


## Get GIT Files

    $global:GitPackages = @(
  
      'https://github.com/Tuhinshubhra/RED_HAWK.git'
      'https://github.com/beefproject/beef.git'		
      'https://github.com/andresriancho/w3af.git'
      'https://github.com/laramies/theHarvester.git'
      'https://github.com/laramies/metagoofil.git'
      'https://github.com/sherlock-project/sherlock.git'
      'https://github.com/cldrn/davtest.git'
      'https://github.com/ElevenPaths/tacyt-maltego-transforms.git'
      'https://github.com/ElevenPaths/uac-a-mola.git'
      'https://github.com/ElevenPaths/neto.git'
      'https://github.com/ElevenPaths/PySCTChecker.git'
      'https://github.com/EmpireProject/Empire.git'
      'https://github.com/samratashok/nishang.git'
      'https://github.com/PowerShellMafia/PowerSploit.git'
      'https://github.com/hfiref0x/UACME.git'
      'https://github.com/commixproject/commix.git'
      'https://github.com/xmendez/wfuzz.git'
      'https://github.com/sysdream/hershell.git'
      'https://github.com/lanmaster53/recon-ng.git'
      'https://github.com/ShawnDEvans/smbmap.git'
      'https://github.com/urbanadventurer/WhatWeb.git'
      'https://github.com/digininja/CeWL.git'
      'https://github.com/maaaaz/patator-windows.git'
      'https://github.com/trustedsec/unicorn.git'
      'https://github.com/trustedsec/social-engineer-toolkit.git'
      'https://github.com/trustedsec/SysWhispers.git'
      'https://github.com/trustedsec/quicksql.git'
      'https://github.com/iphelix/dnschef.git'
      'https://github.com/epinna/weevely3.git'
      'https://github.com/SpiderLabs/Responder.git'

      

    )
    Get-GITPackages




# Use AutoHotKey to install various software

<#$scripts = @(

  #"install-metasploit.ahk",         
  #"install-zap.ahk"        

)
$filesDir = "$env:systemdrive\cache"
ForEach ($name in $scripts) {
  $script = Join-Path $filesDir $name
  Write-Host "[+] Executing $script" -ForegroundColor Green
  AutoHotKey $script

}#>

Clear-Desktop

Add-StartMenu


# Remove desktop.ini files
try {
    Get-ChildItem -Path (Join-Path ${Env:UserProfile} "Desktop") -Hidden -Filter "desktop.ini" -Force | ForEach-Object {$_.Delete()}
    Get-ChildItem -Path (Join-Path ${Env:Public} "Desktop") -Hidden -Filter "desktop.ini" -Force | ForEach-Object {$_.Delete()}
  } catch {
    Write-Host "Could not remove desktop.ini files"
  }


#### Fix shift+space in powershell ####

# https://superuser.com/questions/1365875/shiftspace-not-working-in-powershell
Set-PSReadLineKeyHandler -Chord Shift+Spacebar -Function SelfInsert
Write-Host "[+] Fixed shift+space keybinding in PowerShell" -ForegroundColor Green


#### Pin Items to Taskbar ####

Write-Host "[-] Pinning items to Taskbar" -ForegroundColor Green
# Explorer
$target_file = Join-Path ${Env:WinDir} "explorer.exe"
try {
  Write-Host "`tPinning $target_file to taskbar" -ForegroundColor Green
  syspin.exe "$target_file" 5386
} catch {}
# CMD prompt
$target_file = Join-Path ${Env:WinDir} "system32\cmd.exe"
$target_dir = ${Env:UserProfile}
$target_args = '/K "cd ' + ${Env:UserProfile} + '"'
$shortcut = Join-Path ${Env:UserProfile} "temp\cmd.lnk"
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_file -Arguments $target_args -WorkingDirectory $target_dir -PinToTaskbar -RunasAdmin
try {
  Write-Host "`tPinning $target_file to taskbar" -ForegroundColor Green
  syspin.exe "$shortcut" 5386
} catch {}
# Powershell
$target_file = Join-Path (Join-Path ${Env:WinDir} "system32\WindowsPowerShell\v1.0") "powershell.exe"
$target_dir = ${Env:UserProfile}
$target_args = '-NoExit -Command "cd ' + "${Env:UserProfile}" + '"'
$shortcut = Join-Path ${Env:UserProfile} "temp\PowerShell.lnk"
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_file -Arguments $target_args -WorkingDirectory $target_dir -PinToTaskbar -RunasAdmin
try {
  Write-Host "`tPinning $target_file to taskbar" -ForegroundColor Green
  syspin.exe "$shortcut" 5386
} catch {}
# Babun
$target_file = Join-Path (Join-Path ${Env:USERPROFILE} ".babun\cygwin\bin\") "mintty.exe"
$target_dir = ${Env:UserProfile}
$shortcut = Join-Path ${Env:UserProfile} "temp\mintty.lnk"
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_file -WorkingDirectory $target_dir -PinToTaskbar -RunasAdmin
try {
  Write-Host "`tPinning $target_file to taskbar" -ForegroundColor Green
  syspin.exe "$shortcut" 5386
} catch {}
# PITT
$target_file = "$env:TOOLS\PITT - Public Intellegence Tool V2.5.1\Public Intellegence Tool Portable.exe"
$target_dir = ${Env:UserProfile}
$target_args = '-NoExit -Command "cd ' + "${Env:UserProfile}" + '"'
$shortcut = Join-Path ${Env:UserProfile} "temp\Public Intellegence Tool Portable.lnk"
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_file -Arguments $target_args -WorkingDirectory $target_dir -PinToTaskbar -RunasAdmin
try {
  Write-Host "`tPinning $target_file to taskbar" -ForegroundColor Green
  syspin.exe "$shortcut" 5386
} catch {}
# Firefox
$target_file = "C:\Program Files\Mozilla Firefox\firefox.exe"
$target_dir = ${Env:UserProfile}
$shortcut = Join-Path ${Env:UserProfile} "temp\firefox.lnk"
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_file -WorkingDirectory $target_dir -PinToTaskbar -RunasAdmin
try {
  Write-Host "`tPinning $target_file to taskbar" -ForegroundColor Green
  syspin.exe "$shortcut" 5386
} catch {}
# Tor-Browser
$target_file = "C:\ProgramData\chocolatey\lib\tor-browser\tools\tor-browser\Browser\firefox.exe"
$target_dir = ${Env:UserProfile}
$shortcut = Join-Path ${Env:UserProfile} "temp\tor-browser.lnk"
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_file -WorkingDirectory $target_dir -PinToTaskbar -RunasAdmin
try {
  Write-Host "`tPinning $target_file to taskbar" -ForegroundColor Green
  syspin.exe "$shortcut" 5386
} catch {}
# Notepad++
$target_file = "C:\Program Files\Notepad++\notepad++.exe"
$target_dir = ${Env:UserProfile}
$shortcut = Join-Path ${Env:UserProfile} "temp\notepad++.lnk"
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_file -WorkingDirectory $target_dir -PinToTaskbar -RunasAdmin
try {
  Write-Host "`tPinning $target_file to taskbar" -ForegroundColor Green
  syspin.exe "$shortcut" 5386
} catch {}
# Vim
$target_file = "C:\tools\vim\vim82\vim.exe"
$target_dir = ${Env:UserProfile}
$shortcut = Join-Path ${Env:UserProfile} "temp\vim.lnk"
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_file -WorkingDirectory $target_dir -PinToTaskbar -RunasAdmin
try {
  Write-Host "`tPinning $target_file to taskbar" -ForegroundColor Green
  syspin.exe "$shortcut" 5386
} catch {}



# Fix PATH 
$paths = @(
    "${Env:HomeDrive}\\Python37\\Scripts",
    "${Env:HomeDrive}\\Python37",
    "${Env:HomeDrive}\\Python27\\Scripts",
    "${Env:HomeDrive}\\Python27"
)

$env_path = cmd /c echo %PATH%
if ($env_path[-1] -ne ';') {
    $env_path += ';'
}
$old_path = $env_path
foreach ($p in $paths) {
    if ($env_path -match "$p[\\]{0,1};") {
        $env_path = $env_path -replace "$p[\\]{0,1};",""
        $env_path += $p.Replace("\\","\") + ";"
    }
}

if ($env_path -ne $old_path) {
    try {
      setx /M PATH $env_path
      refreshenv
    } catch {
      Write-Host "Could not set PATH properly, please submit GitHub issue." -ForegroundColor Red
    }
}


# CMD MENU CONTEXT
New-Item -Path 'HKCR:\Directory\Background\shell\OpenElevatedCmd' -Force | Out-Null
Set-ItemProperty -Path 'HKCR:\Directory\Background\shell\OpenElevatedCmd' -Name "(Default)" -Value "System CMD - ELevated (here)"
Set-ItemProperty -Path 'HKCR:\Directory\Background\shell\OpenElevatedCmd' -Name "Icon" -Value "cmd.exe"
New-Item -Path 'HKCR:\Directory\Background\shell\OpenElevatedCmd\command' -Force | Out-Null
$valueCMD = @"
PowerShell.exe -windowstyle hidden -Command "Start-Process cmd.exe -ArgumentList '/s,/k,pushd,%V' -Verb RunAs"
"@
Set-ItemProperty -Path 'HKCR:\Directory\Background\shell\OpenElevatedCmd\command' -Name "(Default)" -Value $value

# PS MENU CONTEXT
New-Item -Path 'HKCR:\Directory\Background\shell\OpenElevatedPS' -Force | Out-Null
Set-ItemProperty -Path 'HKCR:\Directory\Background\shell\OpenElevatedPS' -Name "(Default)" -Value "System Powershell - Elevated (here)"
Set-ItemProperty -Path 'HKCR:\Directory\Background\shell\OpenElevatedPS' -Name "Icon" -Value "powershell.exe"
New-Item -Path 'HKCR:\Directory\Background\shell\OpenElevatedPS\command' -Force | Out-Null
$valuePS = @"
PowerShell.exe -windowstyle hidden -Command "Start-Process cmd.exe -ArgumentList '/s,/c,pushd %V && powershell' -Verb RunAs"
"@
Set-ItemProperty -Path 'HKCR:\Directory\Background\shell\OpenElevatedPS\command' -Name "(Default)" -Value $value

#### Rename the computer ####
Write-Host "[+] Renaming host to 'relativity_tools'" -ForegroundColor Green
(Get-WmiObject win32_computersystem).rename("relativity_tools") | Out-Null
Write-Host "`t[-] Change will take effect after a restart" -ForegroundColor Yellow


#### Update background ####
Write-Host "[+] Changing Desktop Background" -ForegroundColor Green
# Set desktop background to black
Set-ItemProperty -Path 'HKCU:\Control Panel\Colors' -Name Background -Value "0 0 0" -Force | Out-Null
# Set desktop wallpaper using WallpaperChanger utility
$wallpaperName = 'wallpaper.jpg'
$fileBackground = Join-Path "$env:LOCALAPPDATA\module_relativity\" $wallpaperName
$publicWallpaper = Join-Path ${env:public} $wallpaperName
$WallpaperChanger = Join-Path "$env:LOCALAPPDATA\module_relativity\" 'WallpaperChanger.exe'
Invoke-Expression "$WallpaperChanger $fileBackground 3"
# Copy background images
$background = 'wallpaper.jpg'
$backgrounds = Join-Path "$env:LOCALAPPDATA\module_relativity\"  $background
Invoke-Expression "copy $backgrounds ${Env:USERPROFILE}\Pictures"

foreach ($item in "0", "1", "2") {
  # Try to set it multiple times! Windows 10 is not consistent
  if ((Test-Path $publicWallpaper) -eq $false)
  {
    Copy-Item -Path $fileBackground -Destination $publicWallpaper -Force 
  }
  Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name Wallpaper -value $publicWallpaper
  Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name TileWallpaper -value "0" -Force
  Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name WallpaperStyle -value "6" -Force
  Start-Sleep -seconds 3
  rundll32.exe user32.dll, UpdatePerUserSystemParameters, 1, True
}

#Remove-Item -Path "$env:SystemDrive\cache\*" -Force -Recurse

Write-Output "[+] Instalacion Finalizada"  >> $global:chageLog 
Get-Date >> $global:chageLog 