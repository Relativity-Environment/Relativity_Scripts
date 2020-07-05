
<# Opcion 1 - Instalacion de opcion minimal #>

$BoxPackageName         =   "install.minimal"

if (Test-PendingReboot) { Invoke-Reboot }   

$null = New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\module_relativity" -ErrorAction SilentlyContinue
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/module/module.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\module.psm1"
Write-Host "import module" -ForegroundColor red
Import-Module "$env:LOCALAPPDATA\module_relativity\module.psm1" -Force 
#Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force
#Add-Folders




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


    $UtilDownloadPath   = "C:\tmp\vuls"
    $UtilBinPath        = "$env:systemdrive\Relativity_Tools\Analisis de Vulnerabilidades"

    If (-not (Test-Path $UtilDownloadPath)) {
        mkdir $UtilDownloadPath -Force
    }

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"

    
        Push-Location $UtilDownloadPath
        # Store all the file we download for later processing
        $FilesDownloaded = @()

    Foreach ($software in $ManualDownloadInstall.keys) {
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

    echo "$UtilDownloadPath"
    echo "$UtilBinPath"
    # Extracting self-contained binaries (zip files) to our bin folder
    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.zip' | Where {$FilesDownloaded -contains $_.Name} | Foreach {
        Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath -Force -ErrorAction SilentlyContinue
    }
    
    Add-EnvPath -Location 'User' -NewPath $UtilBinPath

    # Kick off msi installs
    Get-ChildItem -Path $UtilDownloadPath-File -Filter '*.msi' | Where {$FilesDownloaded -contains $_.Name} | Foreach {
           echo $FilesDownloaded | Start-Proc -Exe $_.FullName -waitforexit
    }
    
    
    # Kick off exe installs
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.exe' | Where {$FilesDownloaded -contains $_.Name} | Foreach {
        Start-Proc -Exe $_.FullName -waitforexit
    }
    







#Install-Zip -UtilDownloadPath $UtilDownloadPath -UtilBinPath $UtilBinPath   
#Install-Exe -UtilDownloadPath $UtilDownloadPath
#Install-Msi -UtilDownloadPath $UtilDownloadPath



