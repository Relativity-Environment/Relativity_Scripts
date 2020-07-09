
<# Opcion 1 - Instalacion de opcion minimal #>

$BoxPackageName         = "install.minimal"

if (Test-PendingReboot) { Invoke-Reboot }   

$null = New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\module_relativity" -ErrorAction SilentlyContinue
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/environment_files/module.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\module.psm1" -ErrorAction SilentlyContinue
Write-Host "import module" -ForegroundColor red
Import-Module "$env:LOCALAPPDATA\module_relativity\module.psm1" -Force 
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

# BoxStarter setup
Set-BoxstarterConfig -NugetSources "https://chocolatey.org/api/v2"

$BypassDefenderPaths = @('C:\Tools', 'C:\Program Files (x86)', 'C:\Program Files' )
$ByPassDefenderPaths | Add-DefenderBypassPath


# Utilidades
$ChocoInstalls = @(
        
        'syspin',
        'ruby',
        'javaruntime',
        'nuget.commandline',
        'git',
        'git-credential-manager-for-windows',
        'git-credential-winstore',
        'gitextensions',
        'dotnet4.7.2',
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
        'winrar',
        'winpcap',
        'nmap',
        'wireshark',
        'mitmproxy',
        'openssl',
        'tor-browser'    
        
)

<#$global:ChocoInstalls = @(
        

        'nuget.commandline',
        'git',
        'git-credential-manager-for-windows',
        'git-credential-winstore',
        'gitextensions',
        '7zip',
        '7zip.commandline'
        'winrar',
        'winpcap'
        'javaruntime'
 
        
)#>
Install-ChocoPackages
refreshenv


# Recopilacion de Informacion
    
    $global:ManualDownloadInstall = @{

        
        'FOCA-v3.4.7.0.zip'                         = 'https://github.com/ElevenPaths/FOCA/releases/download/v3.4.7.0/FOCA-v3.4.7.0.zip'
        'PIT-Public_Intellegence_Tool_V2.5.1.rar'   = 'http://52.210.171.72/gravity/PIT-Public_Intellegence_Tool_V2.5.1.rar'
        'ipscan-3.7.2-setup.exe'			        = 'https://github.com/angryip/ipscan/releases/download/3.7.2/ipscan-3.7.2-setup.exe'

    }
    Install-Apps "Recopilacion de Informacion" 

# Analisis de Vulnerabilidades
    
    $global:ManualDownloadInstall = @{
        
        'Nessus-8.10.1-x64.msi'                     = 'http://52.210.171.72/gravity/Nessus-8.10.1-x64.msi'
        'ZAP_2_9_0_windows.exe' 					= 'https://github.com/zaproxy/zaproxy/releases/download/v2.9.0/ZAP_2_9_0_windows.exe'
        'metasploitframework-latest.msi' 			= 'https://windows.metasploit.com/metasploitframework-latest.msi'
        

    }
   Install-Apps "Analisis de Vulnerabilidades" 



# Analisis Bases de Datos

    $global:ManualDownloadInstall = @{
        
        
    
    }
#    Install-Apps "Analisis Bases de Datos" 
            
# Ataques de Contraseña

    $global:ManualDownloadInstall = @{
            
            
        
    }
#    Install-Apps "Ataques de Contraseña" 
            
# Herramientas de Explotacion

    $global:ManualDownloadInstall = @{
                
                
            
    }
#    Install-Apps " Herramientas de Explotacion" 


# Herramientas para Sniffing/Spoofing

    $global:ManualDownloadInstall = @{
                
                
            
    }
#    Install-Apps "Herramientas para Sniffing/Spoofing" 



# Herramientas para Ing. Social
  
    $global:ManualDownloadInstall = @{
                
                
            
    }
#    Install-Apps " Herramientas para Ing. Social" 




#### Remove Desktop Shortcuts ####
Write-Host "[+] Cleaning up the Desktop" -ForegroundColor Green
$shortcut_path = "$Env:Public\Desktop\Boxstarter Shell.lnk"
if (Test-Path $shortcut_path) { Remove-Item $shortcut_path -Force -ErrorAction Ignore | Out-Null }
$shortcut_path = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
if (Test-Path $shortcut_path) { Remove-Item $shortcut_path -Force  -ErrorAction Ignore | Out-Null }
$shortcut_path = "$Env:USERPROFILE\Desktop\Google Chrome.lnk"
if (Test-Path $shortcut_path) { Remove-Item $shortcut_path -Force  -ErrorAction Ignore | Out-Null }
$shortcut_path = "$Env:USERPROFILE\Desktop\VirusTotal Uploader 2.2.lnk"
if (Test-Path $shortcut_path) { Remove-Item $shortcut_path -Force  -ErrorAction Ignore | Out-Null }
$shortcut_path = "$Env:Public\Desktop\Simple DNSCrypt.lnk"
if (Test-Path $shortcut_path) { Remove-Item $shortcut_path -Force -ErrorAction Ignore | Out-Null }

# Remove desktop.ini files
try {
    Get-ChildItem -Path (Join-Path ${Env:UserProfile} "Desktop") -Hidden -Filter "desktop.ini" -Force | foreach {$_.Delete()}
    Get-ChildItem -Path (Join-Path ${Env:Public} "Desktop") -Hidden -Filter "desktop.ini" -Force | foreach {$_.Delete()}
  } catch {
    Write-Host "Could not remove desktop.ini files"
  }



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



#### Fix shift+space in powershell
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
  Sleep -seconds 3
  rundll32.exe user32.dll, UpdatePerUserSystemParameters, 1, True
}

