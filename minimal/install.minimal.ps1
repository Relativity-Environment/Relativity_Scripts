
<# Opcion 1 - Instalacion de opcion minimal #>

$BoxPackageName         =   "install.minimal"

if (Test-PendingReboot) { Invoke-Reboot }   

function Install-Module{
  
 
    $null = New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\module_relativity" -ErrorAction SilentlyContinue
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/module/module.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\module.psm1"
    
  
} 

Install-Module
Write-Information "import"
Import-Module "$env:LOCALAPPDATA\module_relativity\module.psm1" -Force -ErrorAction Stop
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force
Add-Folders

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
#Install-ChocoPackages


# Vuls
$ManualDownloadInstall = @{

    'nikto.zip'             = 'https://github.com/sullo/nikto/archive/master.zip'
    'Vulnerator.zip'        = 'https://github.com/Vulnerator/Vulnerator/releases/download/v6.1.9/Vulnerator_v6-1-9.zip'
    'VegaSetup64.exe'       = 'https://support.subgraph.com/downloads/VegaSetup64.exe'
    'Nessus-8.10.1-x64.msi' = 'http://52.210.171.72/gravity/Nessus-8.10.1-x64.msi'
}

function Get-DownloadManual($UtilDownloadPath, $UtilBinPath)
{

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
    
    $FilesDownloaded = @()

    If (-not (Test-Path $UtilDownloadPath)) {
        mkdir $UtilDownloadPath -Force
    }

    If (-not (Test-Path $UtilBinPath)) {
        mkdir $UtilBinPath -Force
    }
    
    Push-Location $UtilDownloadPath
    
    Foreach($software in $ManualDownloadInstall.keys) {
    
    Write-Output "Downloading $software"
    if ( -not (Test-Path $software) ) {
        try {
                Invoke-WebRequest $ManualDownloadInstall[$software] -OutFile $software -UseBasicParsing
                $FilesDownloaded += $software
        }
        catch {}
    }
    else {

            Write-Warning "File is already downloaded, skipping: $software"
        }
    }

}

function Install-Zip($UtilDownloadPath, $UtilBinPath)
{

    # zip installs
    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.zip' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
    Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath -Force
    Add-EnvPath -Location 'machine' -NewPath $UtilBinPath
    }

}

function Install-Soft($UtilDownloadPath)
{

         
     # exe installs
     Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.exe' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
     Start-Proc -Exe $_.FullName -waitforexit
     }
 
     # msi installs
     Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
     Start-Proc -Exe $_.FullName -waitforexit
     }



}


$UtilBinPath = "$env:SystemDrive\Analisis de Vulnerabilidades"
Get-DownloadManual -UtilDownloadPath "C:\tmp\vuls" -UtilBinPath "$UtilBinPath"
Install-Zip -UtilDownloadPath "C:\tmp\vuls" -UtilBinPath "$UtilBinPath"
Install-Soft -UtilDownloadPath "C:\tmp\vuls" 
Add-EnvPath



