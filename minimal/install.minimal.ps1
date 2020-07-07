
<# Opcion 1 - Instalacion de opcion minimal #>

$BoxPackageName         =   "install.minimal"

if (Test-PendingReboot) { Invoke-Reboot }   

$null = New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\module_relativity" -ErrorAction SilentlyContinue
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/module/module.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\module.psm1"
Write-Host "import module" -ForegroundColor red
Import-Module "$env:LOCALAPPDATA\module_relativity\module.psm1" -Force 
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force
Add-Folders




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
        'rar',
        'winpcap',
        'javaruntime',
        'tor-browser'    
        
)#>

$global:ChocoInstalls = @(
        

        'nuget.commandline',
        'git',
        'git-credential-manager-for-windows',
        'git-credential-winstore',
        'gitextensions',
        '7zip',
        '7zip.commandline',
        'rar',
        'winpcap',
        'javaruntime'
 
        
)
Install-ChocoPackages
refreshenv


# Recopilacion de Informacion
    
    $global:ManualDownloadInstall = @{

        'PITT+-+Public+Intellegence+Tool.rar'    = 'https://sourceforge.net/projects/publicintelligencetool/files/latest/download'
        'FOCA-v3.4.7.0.zip'                      = 'https://github.com/ElevenPaths/FOCA/releases/download/v3.4.7.0/FOCA-v3.4.7.0.zip'
        'SpiderFoot-2.11-w32.zip'                  = 'https://sourceforge.net/projects/spiderfoot/files/SpiderFoot-2.11-w32.zip/download'
    }
    Get-DownloadManual "Recopilacion de Informacion" 

# Analisis de Vulnerabilidades
    
    $global:ManualDownloadInstall = @{

        'nikto.zip'             = 'https://github.com/sullo/nikto/archive/master.zip'
        'Vulnerator.zip'        = 'https://github.com/Vulnerator/Vulnerator/releases/download/v6.1.9/Vulnerator_v6-1-9.zip'
        #'VegaSetup64.exe'       = 'https://support.subgraph.com/downloads/VegaSetup64.exe'
        'Nessus-8.10.1-x64.msi' = 'http://52.210.171.72/gravity/Nessus-8.10.1-x64.msi'
    }
    Get-DownloadManual "Analisis de Vulnerabilidades" 



# Analisis Bases de Datos
            
# Ataques de Contraseña
            
# Herramientas de Explotacion

# Herramientas para Sniffing/Spoofing

# Herramientas para Ing. Social

# Utilidades
