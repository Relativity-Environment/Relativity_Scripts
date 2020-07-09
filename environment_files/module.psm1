

function Disable-Defender{

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth" -ErrorAction SilentlyContinue
  
}


function Add-DefenderBypassPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline = $true)]
        [string[]]$Path
    )
    begin {
        $Paths = @()
    }
    process {
        $Paths += $Path
    }
    end {
        $Paths | Foreach-Object {
            if (-not [string]::isnullorempty($_)) {
                Add-MpPreference -ExclusionPath $_ -Force
               
            }
        }
    }

    
} 
#$BypassDefenderPaths = @('C:\')
#$ByPassDefenderPaths | Add-DefenderBypassPath

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


function Install-Apps($tool)
{   

    Switch (($tool) )
    {
        'Recopilacion de Informacion'{$UtilDownloadPath         = "$env:systemdrive\cache"   ; $UtilBinPath= "$env:systemdrive\Tools\" }
        'Analisis de Vulnerabilidades'{$UtilDownloadPath        = "$env:systemdrive\cache"     ; $UtilBinPath= "$env:systemdrive\Tools\" }
        'Analisis Bases de Datos'{$UtilDownloadPath             = "$env:systemdrive\cache"     ; $UtilBinPath= "$env:systemdrive\Tools\" }
        'Ataques de Contraseña'{$UtilDownloadPath               = "$env:systemdrive\cache"   ; $UtilBinPath= "$env:systemdrive\Tools\" }
        'Herramientas de Explotacion'{$UtilDownloadPath         = "$env:systemdrive\cache"     ; $UtilBinPath= "$env:systemdrive\Tools\" }
        'Herramientas para Sniffing/Spoofing'{$UtilDownloadPath = "$env:systemdrive\cache"    ; $UtilBinPath= "$env:systemdrive\Tools\" }
        'Herramientas para Ing. Social'{$UtilDownloadPath       = "$env:systemdrive\cache"   ; $UtilBinPath= "$env:systemdrive\Tools\" }
                  
    }

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"



    If (-not (Test-Path $UtilDownloadPath)) {

        mkdir $UtilDownloadPath
    }
      

    Push-Location $UtilDownloadPath 
    # Store all the file we download for later processing
    
    $FilesDownloaded = @()

    
    Foreach ($software in $global:ManualDownloadInstall.keys) {
        Write-Output "Downloading $software"
        if ( -not (Test-Path $software) ) {
            try {
                Invoke-WebRequest $global:ManualDownloadInstall[$software] -OutFile $software -UseBasicParsing -ErrorAction SilentlyContinue
                $FilesDownloaded += $software
            }
            catch {}
        }
        else {
            Write-Warning "File is already downloaded, skipping: $software"
        }
    }

    # Extracting self-contained binaries (rar files) to our bin folder
    Write-Output 'Extracting self-contained binaries (rar files) to our bin folder'
    $Rars = Get-ChildItem -filter "*.rar" -path "$UtilDownloadPath"-Recurse
    $WinRar = "C:\Program Files\WinRAR\winrar.exe"
    foreach ($rar in $Rars)
    {   
        &$Winrar x $rar.FullName $UtilBinPath
        Get-Process winrar | Wait-Process -ErrorAction SilentlyContinue
        #Add-EnvPath -Location 'User' -NewPath $UtilBinPath\$rar.FullName
   }
    

    # Extracting self-contained binaries (zip files) to our bin folder
    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.zip' | Where {$FilesDownloaded -contains $_.Name} | Foreach {
        
        #Push-Location $UtilBinPath
        Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath\$($_.Basename) 
        
    }
            
    # Kick off msi installs
    Write-Output 'Buscando archivos msi'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | Foreach {Install-ChocolateyPackage -PackageName $_.Name -FileType 'msi' -File $_.FullName -SilentArgs '/qn'} 
    
    
    
    Remove-Item -Recurse "$env:SystemDrive\cache" -Force -ErrorAction SilentlyContinue

}


function Install-ChocoPackages($UtilBinPath)
{

     # Chocolatey setup
    Write-Host "Initializing chocolatey"
    Invoke-Expression "choco feature enable -n allowGlobalConfirmation"
    Invoke-Expression "choco feature enable -n allowEmptyChecksums"

    Write-Output "Installing software via chocolatey" 

    if ($global:ChocoInstalls.Count -gt 0) {
        # Install a ton of other crap I use or like, update $ChocoInsalls to suit your needs of course
        $global:ChocoInstalls | Foreach-Object {
            try {
                
                cinst $_ -y
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



function Add-Folders{

    $RootPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Tools"
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
                Write-Output "Creando path $_"
                New-Item -ItemType "directory" "$RootPath\$_" -ErrorAction SilentlyContinue
            }
        }     
    }
}





# Create .lnk
function Add-Toolslnk{


    Add-Folders

    #arpspoof.exe
    

        

}