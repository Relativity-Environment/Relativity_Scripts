


Function Add-EnvPath {
    # Adds a path to the $ENV:Path list for a user or system if it does not already exist (in both the system and user Path variables)
    param (
        [string]$Location,
        [string]$NewPath
    )

    $AllPaths = $Env:Path -split ';'
    if ($AllPaths -notcontains $NewPath) {
        Write-Output "Adding Utilties bin directory path to the environmental path list: $UtilBinPath"

        $NewPaths = (@(([Environment]::GetEnvironmentVariables($Location).GetEnumerator() | Where-Object {$_.Name -eq 'Path'}).Value -split ';') + $UtilBinPath | Select-Object -Unique) -join ';'

        [Environment]::SetEnvironmentVariable("PATH", $NewPaths, $Location)
    }
}

function Add-Folders{

    $RootPath = "$env:systemdrive\Relativity_Tools"
    if(-not(Test-Path $RootPath)){
        
        New-Item -ItemType "directory" $RootPath -ErrorAction SilentlyContinue 

        $paths  = @(

            'Recopilacion de Informacion',
            'Analisis de Vulnerabilidades',
            'Analisis Bases de Datos',
            'Ataques de Contraseña',
            'Herramientas de Explotacion',
            'Herramientas para Sniffing/Spoofing',
            'Herramientas para Ing. Social',
            'Utilidades'


        )

            if ($paths.Count -gt 0) {
              
                $paths | Foreach-Object {
                echo "Creando path $_"
                New-Item -ItemType "directory" "$RootPath\$_"
            }
        }     
    }
}


function test-hash{

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"

    
    Write-Output "$UtilDownloadPath"
    Write-Output "$UtilBinPath"
    
    Push-Location $UtilDownloadPath
    # Store all the file we download for later processing
    $FilesDownloaded = @()

    Foreach ($software in $ManualDownloadInstall.keys) {
        Write-Output "Downloading $software"
        if ( -not (Test-Path $software) ) {
            try {
                
                Invoke-WebRequest $ManualDownloadInstall[$software] -OutFile $software -UseBasicParsing
                $FilesDownloaded += $software

                Write-Host "se puede acceder a $software "

            }
            catch {}
        }
        else {
            Write-Warning "File is already downloaded, skipping: $software"
        }
    }

}




function Get-DownloadManual($tool)
{   
    
  

    Switch (($tool) )
    {
        'Recopilacion de Informacion'{$UtilDownloadPath         = "C:\tmp\info"     ; $UtilBinPath= "$env:systemdrive\Relativity_Tools\Recopilacion de Informacion" }
        'Analisis de Vulnerabilidades'{$UtilDownloadPath        = "C:\tmp\vuls"     ; $UtilBinPath= "$env:systemdrive\Relativity_Tools\Analisis de Vulnerabilidades" }
        'Analisis Bases de Datos'{$UtilDownloadPath             = "C:\tmp\bbdd"     ; $UtilBinPath= "$env:systemdrive\Relativity_Tools\Analisis Bases de Datos" }
        'Ataques de Contraseña'{$UtilDownloadPath               = "C:\tmp\passwd"   ; $UtilBinPath= "$env:systemdrive\Relativity_Tools\Ataques de Contraseña" }
        'Herramientas de Explotacion'{$UtilDownloadPath         = "C:\tmp\expl"     ; $UtilBinPath= "$env:systemdrive\Relativity_Tools\Herramientas de Explotacion" }
        'Herramientas para Sniffing/Spoofing'{$UtilDownloadPath = "C:\tmp\spoof"    ; $UtilBinPath= "$env:systemdrive\Relativity_Tools\Herramientas para Sniffing/Spoofing" }
        'Herramientas para Ing. Social'{$UtilDownloadPath       = "C:\tmp\social"   ; $UtilBinPath= "$env:systemdrive\Relativity_Tools\Herramientas para Ing. Social" }
                  
    }

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"

    If (-not (Test-Path $UtilDownloadPath)) {
        mkdir $UtilDownloadPath -Force
    }

    Write-Output "$UtilDownloadPath"
    Write-Output "$UtilBinPath"

    $ManualDownloadInstall = @{

        'nikto.zip'             = 'https://github.com/sullo/nikto/archive/master.zip'
        'Vulnerator.zip'        = 'https://github.com/Vulnerator/Vulnerator/releases/download/v6.1.9/Vulnerator_v6-1-9.zip'
        'VegaSetup64.exe'       = 'https://support.subgraph.com/downloads/VegaSetup64.exe'
        'Nessus-8.10.1-x64.msi' = 'http://52.210.171.72/gravity/Nessus-8.10.1-x64.msi'
    }

    
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

    # Extracting self-contained binaries (zip files) to our bin folder
    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.zip' | Where {$FilesDownloaded -contains $_.Name} | Foreach {
        Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath -Force -ErrorAction SilentlyContinue
    }
    
    Add-EnvPath -Location 'User' -NewPath $UtilBinPath

    # Kick off msi installs
    Write-Output 'Buscando archivos msi'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | Where {$FilesDownloaded -contains $_.Name} | Foreach {Start-Proc -Exe $_.FullName -waitforexit}
    
    
    # Kick off exe installs
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.exe' | Where {$FilesDownloaded -contains $_.Name} | Foreach {Start-Proc -Exe $_.FullName -waitforexit}


}
    
    



<#

function Install-Zip([string]$UtilDownloadPath,[string]$UtilBinPath)
{

    # zip installs
    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.zip' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
    Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath -Force
    Add-EnvPath -Location 'machine' -NewPath $UtilBinPath
    }

}

function Install-Exe([string]$UtilDownloadPath)
{

         
     # exe installs
     Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.exe' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
     Start-Proc -Exe $_.FullName -waitforexit
     }
 
 
}

function Install-Msi([string]$UtilDownloadPath)
{
       
     # msi installs
     Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
     Start-Proc -Exe $_.FullName -waitforexit
     }



}




function Install-Exe([string]$UtilDownloadPath)
{

         
     # exe installs
     Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.exe' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
     Start-Proc -Exe $_.FullName -waitforexit
     }
 
 
}

function Install-Msi([string]$UtilDownloadPath)
{
       
     # msi installs
     Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
     Start-Proc -Exe $_.FullName -waitforexit
     }



}



#>




function Install-ChocoPackages
{


    Write-Output "Installing software via chocolatey" 

    if ($ChocoInstalls.Count -gt 0) {
        # Install a ton of other crap I use or like, update $ChocoInsalls to suit your needs of course
        $ChocoInstalls | Foreach-Object {
            try {
                
                cinst -y $_
            }
            catch {
                Write-Warning "Unable to install software package with Chocolatey: $($_)"
        }
    }
}
            else {
                Write-Output 'There were no packages to install!'
            }


}



function Start-Proc {
    param([string]$Exe = $(Throw "An executable must be specified"),
          [string]$Arguments,
          [switch]$Hidden,
          [switch]$waitforexit)

    $startinfo = New-Object System.Diagnostics.ProcessStartInfo
    $startinfo.FileName = $Exe
    $startinfo.Arguments = $Arguments
    if ($Hidden) {
        $startinfo.WindowStyle = 'Hidden'
        $startinfo.CreateNoWindow = $True
    }
    $process = [System.Diagnostics.Process]::Start($startinfo)
    if ($waitforexit) { $process.WaitForExit() }
}


Function Get-SpecialPaths {
    $SpecialFolders = @{}

    $names = [Environment+SpecialFolder]::GetNames([Environment+SpecialFolder])

    foreach($name in $names) {
        $SpecialFolders[$name] = [Environment]::GetFolderPath($name)
    }

    $SpecialFolders
}



Function Get-SpecialPaths {
    $SpecialFolders = @{}

    $names = [Environment+SpecialFolder]::GetNames([Environment+SpecialFolder])

    foreach($name in $names) {
        $SpecialFolders[$name] = [Environment]::GetFolderPath($name)
    }

    $SpecialFolders
}

$SpecialPaths = Get-SpecialPaths
$packages = Get-Package

Pop-Location

$ClearDesktopShortcuts = $true

function Get-DesktopShortcuts{

        
        Write-Output "Moving .lnk files from $($SpecialPaths['CommonDesktopDirectory']) to the Shortcuts folder"
        Get-ChildItem -Path  $SpecialPaths['CommonDesktopDirectory'] -Filter '*.lnk' | ForEach-Object {
            Move-Item -Path $_.FullName -Destination $DesktopShortcuts -ErrorAction:SilentlyContinue
        }
    
        Write-Output "Moving .lnk files from $Desktop to the Shortcuts folder"
        Get-ChildItem -Path $Desktop -Filter '*.lnk' | ForEach-Object {
            Move-Item -Path $_.FullName -Destination $DesktopShortcuts -ErrorAction:SilentlyContinue
        }
}
   
