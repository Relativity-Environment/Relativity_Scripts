
function Add-Folders{
  
  
    # Start Menu (RelaTools)
    $ToolslnkPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\RelaTools" 
    New-Item -ItemType "directory" $ToolslnkPath -Force -ErrorAction SilentlyContinue
    

    # Cache PATH - Tools PATH
    $UtilDownloadPath   = "$env:systemdrive\cache"
    $UtilBinPath        = "$env:systemdrive\RelaTools\"

    If (-not (Test-Path $UtilDownloadPath)) {

        mkdir $UtilDownloadPath -ErrorAction SilentlyContinue
    }


    If (-not (Test-Path $UtilBinPath)) {

        mkdir $UtilBinPath -ErrorAction SilentlyContinue
    }
    
       
}


function Add-StartMenu
{

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"

    $Download = "$env:LOCALAPPDATA\module_relativity\"
    Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/Relativity-Environment/Relativity_Scripts/raw/master/neccesary_files/ZIP/RelaTools.zip" -Outfile "$Download\RelaTools.zip" 
    $StartMenu = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'    
    Expand-Archive -path "$Download\RelaTools.zip" -DestinationPath $StartMenu

    $value = "$env:USERPROFILE\Desktop\"
    New-Item -ItemType SymbolicLink -Path $value -Name "RelaTools" -Value "$StartMenu\RelaTools"

}

Function Get-SpecialPaths {
    $SpecialFolders = @{}

    $names = [Environment+SpecialFolder]::GetNames([Environment+SpecialFolder])

    foreach($name in $names) {
        $SpecialFolders[$name] = [Environment]::GetFolderPath($name)
    }

    $SpecialFolders
}


function Clear-Desktop
{
    $ClearDesktopShortcuts = $True
    $SpecialPaths = Get-SpecialPaths

    if ($ClearDesktopShortcuts) {
        $Desktop = $SpecialPaths['DesktopDirectory']
        $DesktopShortcuts = Join-Path $Desktop 'DesktopShortcuts'
        if (-not (Test-Path $DesktopShortcuts)) {
            Write-Host -ForegroundColor:Cyan "Creating a new shortcuts folder on your desktop and moving all .lnk files to it: $DesktopShortcuts"
            $null = mkdir $DesktopShortcuts
        }
    
        Write-Output "Moving .lnk files from $($SpecialPaths['CommonDesktopDirectory']) to the Shortcuts folder"
        Get-ChildItem -Path  $SpecialPaths['CommonDesktopDirectory'] -Filter '*.lnk' | Foreach {
            Move-Item -Path $_.FullName -Destination $DesktopShortcuts -ErrorAction:SilentlyContinue
        }
    
        Write-Output "Moving .lnk files from $Desktop to the Shortcuts folder"
        Get-ChildItem -Path $Desktop -Filter '*.lnk' | Foreach {
            Move-Item -Path $_.FullName -Destination $DesktopShortcuts -ErrorAction:SilentlyContinue
        }
    }
    

}


# Add PATH to env variables
Function Add-EnvVariables{

    $toolListDirShortcut = "$env:systemdrive\RelaTools"
    [Environment]::SetEnvironmentVariable("TOOLS", $toolListDirShortcut, 1)

}

  

function Get-NeccesaryFiles {
  
    if(-not(Test-Path "$env:LOCALAPPDATA\module_relativity\tweaks.psm1" )){
  
    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
      
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/neccesary_files/tweaks.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\tweaks.psm1"
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/neccesary_files/tweaks.ps1" -Outfile "$env:LOCALAPPDATA\module_relativity\tweaks.ps1"
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/neccesary_files/tweaks.txt" -Outfile "$env:LOCALAPPDATA\module_relativity\tweaks.txt"
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/neccesary_files/wallpaper.jpg" -Outfile "$env:LOCALAPPDATA\module_relativity\wallpaper.jpg"
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/neccesary_files/WallpaperChanger.exe" -Outfile "$env:LOCALAPPDATA\module_relativity\WallpaperChanger.exe" 
  
    #Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/neccesary_files/install-metasploit.ahk" -Outfile "$env:systemdrive\cache\install-metasploit.ahk"
    #Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/neccesary_files/install-zap.ahk" -Outfile "$env:systemdrive\cache\install-zap.ahk"
    
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:LOCALAPPDATA\module_relativity\tweaks.ps1" -include "$env:LOCALAPPDATA\module_relativity\tweaks.psm1" -preset "$env:LOCALAPPDATA\module_relativity\tweaks.txt" 
  
  
    }
  
  
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

##
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



#######################################  INSTALL PACKAGES ############################################


### Install Apps ##
function Install-Apps
{   

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
  
    
    $UtilDownloadPath   = "$env:systemdrive\cache"
    $UtilBinPath        = "$env:systemdrive\Tools\"
      

    Push-Location $UtilDownloadPath 
    # Store all the file we download for later processing
    
    $FilesDownloaded = @()

    
    Foreach ($software in $global:ManualDownloadInstall.keys) {
        Write-Output "Downloading $software"
        Write-Output "[-] Descargando Apps" >> $global:chageLog 
       

        if ( -not (Test-Path $software) ) {
            try {
                
                Invoke-WebRequest $global:ManualDownloadInstall[$software] -OutFile $software -UseBasicParsing -ErrorAction SilentlyContinue
                Write-Output "$software - Ok" >> $global:chageLog 
                $FilesDownloaded += $software
               

            }
            catch {

                Write-Output "$software - Fallo" >> $global:chageLog   -ErrorAction "SilentlyContinue"

            }
        }
        else {
            Write-Warning "File is already downloaded, skipping: $software"
            Write-Output "$software - Existe" >> $global:chageLog 
        }
    }

    # Extracting self-contained binaries (rar% 7z files) to our bin folder
    Write-Output 'Extracting self-contained binaries (rar files) to our bin folder'
    $Rars = Get-ChildItem -filter "*.rar" -path "$UtilDownloadPath"-Recurse
    $WinRar = "C:\Program Files\WinRAR\winrar.exe"
    foreach ($rar in $Rars)
    {   
        &$Winrar x $rar.FullName $UtilBinPath
        Get-Process winrar | Wait-Process -ErrorAction SilentlyContinue
       }

   $7zs = Get-ChildItem -filter "*.7z" -path "$UtilDownloadPath"-Recurse
    $WinRar = "C:\Program Files\WinRAR\winrar.exe"
    foreach ($7z in $7zs)
    {   
        &$Winrar x $7z.FullName $UtilBinPath
        Get-Process winrar | Wait-Process -ErrorAction SilentlyContinue
     }
    

    # Extracting self-contained binaries (zip files) to our bin folder
    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.zip' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
        
        #Push-Location $UtilBinPath
        Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath\$($_.Basename) 
        
    }

               
    # Kick off msi installs
    Write-Output 'Search msi files'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | ForEach-Object {Install-ChocolateyPackage -PackageName $_.Name -FileType 'msi' -File $_.FullName -SilentArgs '/qn'}
       

}

### Install PE ##
function Get-PE
{   

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
  
    $UtilDownloadPath   = "$env:systemdrive\cache\pe"
    $UtilBinPath        = "$env:systemdrive\RelaTools\"

    If (-not (Test-Path $UtilDownloadPath)) {

        mkdir $UtilDownloadPath -ErrorAction SilentlyContinue
    }


    Push-Location $UtilDownloadPath 
    # Store all the file we download for later processing
    
    $FilesDownloaded = @()
    Write-Output "Downloading PE $software"
    
    Foreach ($software in $global:PEAPPS.keys) {
        Write-Output "Downloading $software"
        if ( -not (Test-Path $software) ) {
            try {
                Invoke-WebRequest $global:PEAPPS[$software] -OutFile $software -UseBasicParsing -ErrorAction SilentlyContinue
                Write-Output "Downloading PE $software" >> $global:chageLog 
                Write-Output "$software - Ok" >> $global:chageLog 
                $FilesDownloaded += $software
            }
            catch {

                Write-Output "$software - Fallo" >> $global:chageLog   -ErrorAction SilentlyContinue

            }
        }
        else {
            Write-Warning "File is already downloaded, skipping: $software"
            Write-Output "$software - Existe" >> $global:chageLog 
        }
    }

        # Kick off PE files
        Write-Output 'Search PE files'
        $Files = Get-ChildItem -Path $UtilDownloadPath
        $Files | ForEach-Object {
        $FileFullName = $_.FullName
        $foldername = $_.BaseName 
        $destinationFolder = "$UtilBinPath\$foldername"
        New-Item -Path "$UtilBinPath\$foldername" -ItemType Directory
        Move-Item $FileFullName $destinationFolder
       }

}


### Install Git ##
function Get-GITPackages
{

    $destiny = "$env:systemdrive\RelaTools"
    Set-Location $destiny
       
    if ($global:GitPackages.Count -gt 0) {
        $global:GitPackages | Foreach-Object {
             try {
                    
                    Write-Output "Descargando de GITHUB $_"
                    Write-Output "Descargando de GITHUB $_" >> $global:chageLog 
    
                    git clone $_ -q
                }
                
                catch {
                   
                    Write-Warning "Unable to download git package: $($_)"
                    Write-Warning "Unable to download git package: $($_)" >> $global:chageLog 
            }      
        }
    }
                else {
                   
                    Write-Output 'There were no git to download!'
                    Write-Output 'There were no git to download!' >> $global:chageLog 
                }
                    
}




### Install Choco ##

function Get-ChocoPackages {
    if (get-command clist -ErrorAction:SilentlyContinue) {
        clist -lo -r -all | ForEach-Object {
            $Name,$Version = $_ -split '\|'
            New-Object -TypeName psobject -Property @{
                'Name' = $Name
                'Version' = $Version
            }
        }
    }
}


function Install-ChocoPackages
{

     # Chocolatey setup
    Write-Host "Initializing chocolatey"
    Invoke-Expression "choco feature enable -n allowGlobalConfirmation"
    Invoke-Expression "choco feature enable -n allowEmptyChecksums"

    Write-Output "Installing software via chocolatey" >> $global:chageLog 
    
    $InstalledChocoPackages = (Get-ChocoPackages).Name
    $global:ChocoInstalls = $global:ChocoInstalls | Where-Object { $InstalledChocoPackages -notcontains $_ }

    if ($global:ChocoInstalls.Count -gt 0) {
        # Install a ton of other crap I use or like, update $ChocoInsalls to suit your needs of course
        $global:ChocoInstalls | Foreach-Object {
            try {
                
                cinst $_ --force
                Write-Output "$_ - Ok" >> $global:chageLog   -ErrorAction SilentlyContinue
            }
            catch {
                Write-Warning "Unable to install software package with Chocolatey: $($_)"
                Write-Output "$_ - Fallo" >> $global:chageLog   -ErrorAction SilentlyContinue
        }
    }
}
            else {
                Write-Output 'There were no packages to install!'
                Write-Output "$_ - Existe" >> $global:chageLog 
            }

}



### Create README ##
function Add-README{

    $toolsPath      = "$env:systemdrive\RelaTools"
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