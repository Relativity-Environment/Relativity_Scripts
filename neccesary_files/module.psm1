﻿

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
        'Herramientas para Sniffing-Spoofing'{$UtilDownloadPath = "$env:systemdrive\cache"    ; $UtilBinPath= "$env:systemdrive\Tools\" }
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

    $ToolslnkPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Tools" 
    New-Item -ItemType "directory" $ToolslnkPath -Force -ErrorAction SilentlyContinue

       
}



# Create README
function Add-README{

    $toolsPath      = "$env:systemdrive\Tools"
    Add-Folders

# > arpspoof.exe
$content = @" 

 - EXAMPLES:

    $ arpspoof.exe --list | [-i iface] [--oneway] victim-ip [target-ip]

"@
Add-Content -PassThru "$toolsPath\arpspoof\README" -Value $content


# > webgoat-server
$content = @" 

 - DOCUMENTATION:
    
    https://github.com/WebGoat/WebGoat

 - EXAMPLES:

  $ java -jar webgoat-server-8.1.0.jar [--server.port=8080] [--server.address=localhost]
  $ java -jar webwolf-8.1.0.jar [--server.port=9090] [--server.address=localhost]

  http://127.0.0.1:8080/WebGoat WebWolf will be located at: http://127.0.0.1:9090/WebWolf

"@
Add-Content -PassThru "$toolsPath\webgoat-server\README" -Value $content


# > PITT
$content = @" 

 - DOCUMENTATION:
    
    https://sourceforge.net/projects/publicintelligencetool/

    https://github.com/TheCyberViking/PublicIntelligenceTool


 - EXAMPLES:

   Portable Executable - Run as Administrator
 

"@
Add-Content -PassThru "$toolsPath\PITT - Public Intellegence Tool V2.5.1\README" -Value $content

# > Vulenrator
$content = @" 

 - DOCUMENTATION:
    
    The official distribution of the vulnerability parsing utility.

    https://github.com/Vulnerator/Vulnerator

 - EXAMPLES:

    Portable Executable - Run as Administrator
 

"@
Add-Content -PassThru "$toolsPath\Vulnerator_v6-1-9\README" -Value $content

# > Wapiti
$content = @" 

 - DOCUMENTATION:
    
    https://sourceforge.net/p/wapiti/wiki/Installation/

    Read:

        - INSTALL.md
        - README.md

 - EXAMPLES:

    Installation: python setup.py install

    Use: wapiti -h 
 

"@
Add-Content -PassThru "$toolsPath\wapiti3-3.0.3\README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:

        Modules that require an API key:
        --------------------------------
        Documentation to setup API keys can be found at - https://github.com/laramies/theHarvester/wiki/Installation#api-keys
        
        * bing
        * github
        * hunter
        * intelx
        * pentesttools
        * securityTrails
        * shodan
        * spyse
 
 
        Install and dependencies:
        -------------------------
        * Python 3.7+
        * python3 -m pip install pipenv
        * https://github.com/laramies/theHarvester/wiki/Installation 
   

 - EXAMPLES:

        !! before use require installation

        python theHarvester.py -h

 

"@
Add-Content -PassThru "$toolsPath\theHarvester-master\README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content



} #< end Add-Toolslnk