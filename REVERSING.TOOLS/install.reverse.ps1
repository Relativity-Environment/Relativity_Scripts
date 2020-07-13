
<# Opcion 2 - Instalacion de opcion completa #>

$BoxPackageName   =   "install.full"

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1 -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth" -ErrorAction SilentlyContinue

if (Test-PendingReboot) { Invoke-Reboot }   

$null = New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\module_relativity" -ErrorAction SilentlyContinue
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/module/module.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\module.psm1"
Write-Host "import module" -ForegroundColor red
Import-Module "$env:LOCALAPPDATA\module_relativity\module.psm1" -Force 
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force
Add-Folders

$BypassDefenderPaths = @('C:\', 'C:\Program Files (x86)', 'C:\Program Files' )
$ByPassDefenderPaths | Add-DefenderBypassPath




<#$ChocoInstalls = @(
        
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
        'winrar',
        'winpcap',
        'javaruntime',
        'tor-browser'    
        
)#>
Install-ChocoPackages
refreshenv


# Recopilacion de Informacion
    
    $global:ManualDownloadInstall = @{

        
       

    }
    Install-Apps "Recopilacion de Informacion" 

# Analisis de Vulnerabilidades
    
    $global:ManualDownloadInstall = @{
        
            

    }
    Install-Apps "Analisis de Vulnerabilidades" 



# Analisis Bases de Datos

    $global:ManualDownloadInstall = @{
        
        
    
    }
    Install-Apps "Analisis Bases de Datos" 
            
# Ataques de Contraseña
            
# Herramientas de Explotacion

# Herramientas para Sniffing/Spoofing

# Herramientas para Ing. Social

# Utilidades
