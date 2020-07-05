


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
            'Analisis Aplicaciones Web',
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
   
