

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

function Add-Folders{

    $RootPath = "$env:systemdrive\Tools"
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
                New-Item -ItemType "directory" "$RootPath\$_"
            }
        }     
    }
}



function Install-Apps($tool)
{   

    Switch (($tool) )
    {
        'Recopilacion de Informacion'{$UtilDownloadPath         = "C:\tmp\info"     ; $UtilBinPath= "$env:systemdrive\Tools\Recopilacion de Informacion" }
        'Analisis de Vulnerabilidades'{$UtilDownloadPath        = "C:\tmp\vuls"     ; $UtilBinPath= "$env:systemdrive\Tools\Analisis de Vulnerabilidades" }
        'Analisis Bases de Datos'{$UtilDownloadPath             = "C:\tmp\bbdd"     ; $UtilBinPath= "$env:systemdrive\Tools\Analisis Bases de Datos" }
        'Ataques de Contraseña'{$UtilDownloadPath               = "C:\tmp\passwd"   ; $UtilBinPath= "$env:systemdrive\Tools\Ataques de Contraseña" }
        'Herramientas de Explotacion'{$UtilDownloadPath         = "C:\tmp\expl"     ; $UtilBinPath= "$env:systemdrive\Tools\Herramientas de Explotacion" }
        'Herramientas para Sniffing/Spoofing'{$UtilDownloadPath = "C:\tmp\spoof"    ; $UtilBinPath= "$env:systemdrive\Tools\Herramientas para Sniffing/Spoofing" }
        'Herramientas para Ing. Social'{$UtilDownloadPath       = "C:\tmp\social"   ; $UtilBinPath= "$env:systemdrive\Tools\Herramientas para Ing. Social" }
                  
    }

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"

    If (-not (Test-Path $UtilDownloadPath)) {
        mkdir $UtilDownloadPath -ErrorAction SilentlyContinue
    }

       
    Push-Location $UtilDownloadPath -ErrorAction SilentlyContinue
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
        Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath\$($_.Basename) -ErrorAction SilentlyContinue
        echo $UtilBinPath\$($_.Basename)
        #Add-EnvPath -Location 'User' -NewPath $UtilBinPath\$($_.Basename)
    }
    
        
    # Kick off msi installs
    Write-Output 'Buscando archivos msi'
    #Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | Where {$FilesDownloaded -contains $_.Name} | Foreach {Start-Proc -Exe $_.FullName -waitforexit}
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | Foreach {Install-ChocolateyPackage -PackageName $_.Name -FileType 'msi' -File $_.FullName -SilentArgs '/qn'} -ErrorAction SilentlyContinue
    #Install-ChocolateyPackage -PackageName 'Nessus' -FileType 'msi' -File 'Nessus.msi' -SilentArgs '/qn'
    
    # Kick off exe installs
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.exe' | Where {$FilesDownloaded -contains $_.Name} | Foreach {Start-Proc -Exe $_.FullName -waitforexit} -ErrorAction SilentlyContinue

}


function Install-ChocoPackages
{

     # Chocolatey setup
    Write-Host "Initializing chocolatey"
    Invoke-Expression "choco feature enable -n allowGlobalConfirmation"
    Invoke-Expression "choco feature enable -n allowEmptyChecksums"

    $cache                  = "$env:userprofile\AppData\Local\ChocoCache"
    $globalCinstArgs        = "--cacheLocation $cache -y"

    # Create the cache directory
    New-Item -Path $cache -ItemType directory -Force

    Write-Output "Installing software via chocolatey" 

    if ($global:ChocoInstalls.Count -gt 0) {
        # Install a ton of other crap I use or like, update $ChocoInsalls to suit your needs of course
        $ChocoInstalls | Foreach-Object {
            try {
                
                cinst $globalCinstArgs  $_
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



function CleanUp
{
  # clean up the cache directory
  Remove-Item $cache -Recurse

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
   



function Make-InstallerPackage($PackageName, $TemplateDir, $packages) {
	<#
	.SYNOPSIS
	Make a new installer package
	.DESCRIPTION
	Make a new installer package named installer. This package uses the custom packages.json file specified by the user.
	User can then call "Install-BoxStarterPackage installer" using the local repo.
	#>

	$PackageDir = Join-Path $BoxStarter.LocalRepo $PackageName
	if (Test-Path $PackageDir) {
		Remove-Item -Recurse -Force $PackageDir
	}

	$Tmp = [System.IO.Path]::GetTempFileName()
	Write-Host -ForegroundColor Green "packages file is" + $tmp
	ConvertTo-Json @{"packages" = $packages} | Out-File -FilePath $Tmp
	
  if ([System.IO.Path]::IsPathRooted($TemplateDir)) {
    $ToolsDir = Join-Path $TemplateDir "tools"
  } else {
	  $Here = Get-Location
	  $ToolsDir = Join-Path (Join-Path $Here $TemplateDir) "tools"
  }
  $Dest = Join-Path $ToolsDir "packages.json"

	Move-Item -Force -Path $Tmp -Destination $Dest
	New-BoxstarterPackage -Name $PackageName -Description "My Own Instalelr" -Path $ToolsDir
}
