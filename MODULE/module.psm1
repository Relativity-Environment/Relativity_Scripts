function Add-PSContextualMenu{

    pwsh.exe -command {Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;`
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/lextm/windowsterminal-shell/master/install.ps1'))}

}


## DISKSPACE & CHKPOINT
Function Test-DiskSpace([string]$instalacion)
{

      Switch (($instalacion) )
    {
      "Install-Pentest"{$espacio = 40}
      "Install-REversing"{$espacio = 35}
      
    }

    $disk = $env:systemdrive.Split(":")[0] 
    $disk = Get-PSDrive C
      Start-Sleep -Seconds 1
      if (-Not (($disk.used + $disk.free)/1GB -gt $espacio)){
        Write-Host " [ERR] Esta instalacion requiere de $espacio GB de espacio`n" -ForegroundColor Red
        Read-Host "Pulsa cualquier tecla para continuar"
        exit

      } else {
        Write-Host " > $espacio GB; espacio requerido correcto" -ForegroundColor Green
        # crea punto de restauracion
        Enable-ComputerRestore -Drive "$env:systemdrive" 
        vssadmin resize shadowstorage /for=C: /on=C: /maxsize=15GB
        Add-Checkpoint $instalacion
    }

  
}


function Add-InstallFolders{
  
  
    # Start Menu (RelaTools)
    $ToolsMenuPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\RelaTools" 
    New-Item -ItemType "directory" $ToolsMenuPath -Force -ErrorAction SilentlyContinue | Out-Null
    

    # Cache PATH - RalaTools PATH
    $UtilDownloadPath   = "$env:systemdrive\cache"
    $UtilBinPath        = "$env:systemdrive\RelaTools\"

    If (-not (Test-Path $UtilDownloadPath)) {

        mkdir $UtilDownloadPath -ErrorAction SilentlyContinue | Out-Null
    }


    If (-not (Test-Path $UtilBinPath)) {

        mkdir $UtilBinPath -ErrorAction SilentlyContinue | Out-Null
    }
    
}

function Add-PentestMenu
{

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"

    
        $Download = "$env:LOCALAPPDATA\RELATIVITY\"
        Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/Relativity-Environment/Relativity_Scripts/raw/master/PENTEST.TOOLS/FILES/ZIP/Pentest_Tools.zip" -Outfile "$Download\Pentest_Tools.zip" 
        $StartMenu = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\RelaTools'    
        Expand-Archive -path "$Download\Pentest_Tools.zip" -DestinationPath $StartMenu
        $value = "$env:USERPROFILE\Desktop\"
        New-Item -ItemType SymbolicLink -Path $value -Name "Pentest_Tools" -Value "$StartMenu\Pentest_Tools"  
        $StartMenu = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\RelaTools'    
        $value = "$env:USERPROFILE\Desktop\"
        New-Item -ItemType SymbolicLink -Path $value -Name "Pentest_Tools" -Value "$StartMenu\Pentest_Tools"
}

function Add-ReversingMenu
{

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"

    $Download = "$env:LOCALAPPDATA\RELATIVITY\"
    Invoke-WebRequest -UseBasicParsing -Uri " " -Outfile "$Download\ " 
    $StartMenu = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'    
    Expand-Archive -path "$Download\ " -DestinationPath $StartMenu

    $value = "$env:USERPROFILE\Desktop\"
    New-Item -ItemType SymbolicLink -Path $value -Name " " -Value "$StartMenu\Relatools\ "

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
        Get-ChildItem -Path  $SpecialPaths['CommonDesktopDirectory'] -Filter '*.lnk' | ForEach-Object {
            Move-Item -Path $_.FullName -Destination $DesktopShortcuts -ErrorAction:SilentlyContinue
        }
    
        Write-Output "Moving .lnk files from $Desktop to the Shortcuts folder"
        Get-ChildItem -Path $Desktop -Filter '*.lnk' | ForEach-Object {
            Move-Item -Path $_.FullName -Destination $DesktopShortcuts -ErrorAction:SilentlyContinue
            
        }

        Move-Item -path $DesktopShortcuts -Destination $env:USERPROFILE -ErrorAction SilentlyContinue
        Remove-Item -Path $DesktopShortcuts -Force -Recurse -ErrorAction SilentlyContinue
    }

}

function Remove-DesktioIni
{
       
    # Remove desktop.ini files
    try {
        Get-ChildItem -Path (Join-Path ${Env:UserProfile} "Desktop") -Hidden -Filter "desktop.ini" -Force | ForEach-Object {$_.Delete()}
        Get-ChildItem -Path (Join-Path ${Env:Public} "Desktop") -Hidden -Filter "desktop.ini" -Force | ForEach-Object {$_.Delete()}
    } catch {
        Write-Host "Could not remove desktop.ini files"
    }

}

## Restore POINT
Function Add-Checkpoint($name){
    $exist = Get-ComputerRestorePoint | Where-Object {$_.description -match $name } | Select-Object -ExpandProperty Description
    
    if($exist -eq $name)
    {
            
        Write-Output "$name exist!"
    
    
       }else{
        
        Write-Output "Checkpoint create: $name"
        Checkpoint-Computer -Description "$name"
    
   }
}

## TWEAKS
function Get-Tweaks {
  
    if(-not(Test-Path "$env:LOCALAPPDATA\RELATIVITY\TWEAKS" )){

    New-Item -ItemType 'Directory' "$env:LOCALAPPDATA\RELATIVITY\TWEAKS"


  
    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
      
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/TWEAKS/tweaks.psm1" -Outfile "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\tweaks.psm1" 
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/TWEAKS/tweaks.ps1" -Outfile "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\tweaks.ps1" 
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/TWEAKS/tweaks.txt" -Outfile "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\tweaks.txt"
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/TWEAKS/wallpaper.jpg" -Outfile "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\wallpaper.jpg" 
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/TWEAKS/WallpaperChanger.exe" -Outfile "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\WallpaperChanger.exe"
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/TWEAKS/Windows Terminal.lnk" -Outfile "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\Windows Terminal.lnk"  
    
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\tweaks.ps1" -include "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\tweaks.psm1" -preset "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\tweaks.txt" 
  
    }

    
  }

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


function Add-Background
{
    if(-not(Test-Path "${Env:USERPROFILE}\Pictures\wallpaper.jpg")){
        #### Update background ####
        Write-Host "[+] Changing Desktop Background" -ForegroundColor Green
        # Set desktop background to black
        Set-ItemProperty -Path 'HKCU:\Control Panel\Colors' -Name Background -Value "0 0 0" -Force | Out-Null
        # Set desktop wallpaper using WallpaperChanger utility
        $wallpaperName = 'wallpaper.jpg'
        $fileBackground = Join-Path "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\" $wallpaperName
        $publicWallpaper = Join-Path ${env:public} $wallpaperName
        $WallpaperChanger = Join-Path "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\" 'WallpaperChanger.exe'
        Invoke-Expression "$WallpaperChanger $fileBackground 3"
        # Copy background images
        $background = 'wallpaper.jpg'
        $backgrounds = Join-Path "$env:LOCALAPPDATA\RELATIVITY\TWEAKS\"  $background
        Invoke-Expression "copy $backgrounds ${Env:USERPROFILE}\Pictures"

        foreach ($item in "0", "1", "2") {
        # Try to set it multiple times! Windows 10 is not consistent
        if ((Test-Path $publicWallpaper) -eq $false)
        {
            Copy-Item -Path $fileBackground -Destination $publicWallpaper -Force 
        }
        Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name Wallpaper -value $publicWallpaper
        Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name TileWallpaper -value "0" -Force
        Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name WallpaperStyle -value "6" -Force
        Start-Sleep -seconds 3
        rundll32.exe user32.dll, UpdatePerUserSystemParameters, 1, True

        }	

    }else{}

}



#######################################  INSTALL PACKAGES ############################################


### Install Apps ##
function Install-Apps
{   

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
  
    
    $UtilDownloadPath   = "$env:systemdrive\cache"
    $UtilBinPath        = "$env:systemdrive\RelaTools\"
    
    $FilesDownloaded = @()

    Push-Location $UtilDownloadPath 
   
    Foreach ($software in $global:ManualDownloadInstall.keys) {
    $path       = [io.path]::GetFileNameWithoutExtension($software)
    $matches    = Get-ChildItem $UtilBinPath 
    
    
        if (-not(Test-Path "$UtilBinPath\$path") ) {
            
            try {
                
                Write-Output "Downloading $software"
                Invoke-WebRequest $global:ManualDownloadInstall[$software] -OutFile $software -UseBasicParsing -ErrorAction SilentlyContinue
                Write-Output "$software" >> $global:chageLog 
                $FilesDownloaded += $software
                

            }
            catch {

                Write-Output "$software - Fallo"  -ErrorAction "SilentlyContinue"
                Write-Output "$software - Fallo" >> $global:chageLog  

            }
        }
        else {

            Write-Warning "File is already downloaded, skipping: $software"
            Write-Output "$software - Existe" 
            Write-Output "$software - Existe" >> $global:chageLog 
        }
     }

    # Extracting self-contained binaries (rar / 7z files) to our bin folder
    Write-Output 'Extracting self-contained binaries (rar files) to our bin folder'
    $Rars = Get-ChildItem -filter "*.rar" -path "$UtilDownloadPath"-Recurse
    $WinRar = "C:\Program Files\WinRAR\winrar.exe"
    foreach ($rar in $Rars)
    {   
        $file = [io.path]::GetFileNameWithoutExtension($rar)
        if(-not(Test-Path "$UtilBinPath\$file")){
        New-Item -ItemType Directory -Path $UtilBinPath -Name $file
        &$Winrar x $rar.FullName "$UtilBinPath\$file"
        Get-Process winrar | Wait-Process -ErrorAction SilentlyContinue
      }
    }

    $7zs = Get-ChildItem -filter "*.7z" -path "$UtilDownloadPath"-Recurse
    $WinRar = "C:\Program Files\WinRAR\winrar.exe"
    foreach ($7z in $7zs)
    {   
        
        $file = [io.path]::GetFileNameWithoutExtension($7z)
        if(-not(Test-Path "$UtilBinPath\$file")){
        New-Item -ItemType Directory -Path $UtilBinPath -Name $file
        &$Winrar x $7z.FullName "$UtilBinPath\$file"
        Get-Process winrar | Wait-Process -ErrorAction SilentlyContinue
        }
    }

    $gzs = Get-ChildItem -filter "*.gz" -path "$UtilDownloadPath"-Recurse
    $WinRar = "C:\Program Files\WinRAR\winrar.exe"
    foreach ($gz in $gzs)
    {   
        $tar = [io.path]::GetFileNameWithoutExtension($gz)
        $tar = [io.path]::GetFileNameWithoutExtension($tar)
        if(-not(Test-Path "$UtilBinPath\$tar")){
        New-Item -ItemType Directory -Path $UtilBinPath -Name $tar
        &$Winrar x $gz.FullName "$UtilBinPath\$tar"
        Get-Process winrar | Wait-Process -ErrorAction SilentlyContinue

        }
    }
    

    # Extracting self-contained binaries (zip files) to our bin folder
    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.zip' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
        
        #Push-Location $UtilBinPath
        Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath\$($_.Basename)
        
}

               
    # Kick off msi installs
    #$msiInstalled = Get-Content "$env:LOCALAPPDATA\RELATIVITY\pentest_msi_install" -ErrorAction SilentlyContinue
    #Write-Output 'Search msi files'
    #Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | ForEach-Object {Install-ChocolateyPackage -PackageName $_.Name -FileType 'msi' -File $_.FullName -SilentArgs '/qn'} -ErrorAction SilentlyContinue
    #Write-Output "$_" >> "$env:LOCALAPPDATA\RELATIVITY\pentest_msi_install"
    Write-Output 'Instalando paquetes MSI'
    $msi = Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi'
    #if(-not(Test-Path "$env:LOCALAPPDATA\RELATIVITY\pentest_msi_install")){New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\RELATIVITY\" -Name "pentest_msi_install" }
    ForEach ($name in $msi) {          
    #$content = get-content "$env:LOCALAPPDATA\RELATIVITY\pentest_msi_install"
    $file = [io.path]::GetFileNameWithoutExtension($name)  
    if(-not(Test-Path "$UtilBinPath\$file" )){
            
           Get-ChildItem -Path $UtilDownloadPath -File -Filter $name | ForEach-Object {Install-ChocolateyPackage -PackageName $_.Name -FileType 'msi' -File $_.FullName -SilentArgs '/qn'} 
           #New-Item -ItemType File -Path "$env:LOCALAPPDATA\RELATIVITY\" -Name "$name.log"
           New-Item -ItemType directory -Path $UtilBinPath -Name $file

        
        }else{

            Write-Host "$name is installed"

        }
    
  }

}

### Install PE
function Get-PE
{   

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
  
    $UtilDownloadPath   = "$env:systemdrive\cache\pe"
    $UtilBinPath        = "$env:systemdrive\RelaTools\"

    If (-not (Test-Path $UtilDownloadPath)) {

        mkdir $UtilDownloadPath -ErrorAction SilentlyContinue
    }

    Push-Location $UtilDownloadPath 
       
    $FilesDownloaded = @()
        
    Foreach ($software in $global:PEAPPS.keys) {
        
        $path = [io.path]::GetFileNameWithoutExtension($software)

        if ( -not (Test-Path "$UtilBinPath\$path") ) {
            try {

                Write-Output "Downloading $software"
                Invoke-WebRequest $global:PEAPPS[$software] -OutFile $software -UseBasicParsing -ErrorAction SilentlyContinue
                Write-Output "$software" >> $global:chageLog 
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


## Install from Git
function Get-GITPackages
{

    $UtilBinPath = "$env:systemdrive\RelaTools"
    Set-Location $UtilBinPath

Foreach ($software in $global:GitPackages.keys) {
    
    $path = [io.path]::GetFileNameWithoutExtension($software)

    if (-not (Test-Path "$UtilBinPath\$path")){
               
            try {
                    
                    Write-Output "Descargando de GITHUB $software"
                    Write-Output "$software" >> $global:chageLog 
    
                    git clone $global:GitPackages[$software] -q 
                
                }
                
                catch {
                   
                    Write-Warning "Unable to download git package: $($_)"
                    Write-Warning "Unable to download git package: $($_)" >> $global:chageLog 
            }      
        }
    
    else {
                   
        Write-Output "There were no git to download!: $($_)"
        Write-Output "There were no git to download!: $($_)" >> $global:chageLog 
    }
    }
 }



## Install from AHK

Function Get-AHKPackages
{

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
  
    $UtilDownloadPath   = "$env:systemdrive\cache\ahk"

   
    
    If (-not (Test-Path $UtilDownloadPath)) {

        mkdir $UtilDownloadPath -ErrorAction SilentlyContinue
    }

    Push-Location $UtilDownloadPath 
    $content = get-content "$env:LOCALAPPDATA\RELATIVITY\pentest_ahk_dowload" -ErrorAction SilentlyContinue
    Foreach ($software in $global:AHKPackages.keys) {
        
        if (-not($content | select-string -pattern $software) ) {
           
            try {

                Write-Output "Downloading AHK $software"
                Invoke-WebRequest $global:AHKPackages[$software] -OutFile $software -UseBasicParsing -ErrorAction SilentlyContinue
                Write-Output "$software" >> $global:chageLog 
                Write-Output "$software" >> "$env:LOCALAPPDATA\RELATIVITY\pentest_ahk_dowload"
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

    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path "$env:SYSTEMDRIVE\cache\ahk" -File -Filter '*.zip' | ForEach-Object {
    Push-Location "$env:SYSTEMDRIVE\cache\ahk"
    Expand-Archive -Path $_.FullName -DestinationPath . -ErrorAction SilentlyContinue
    
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
    Write-Output "Installing software via chocolatey" 
    
    $InstalledChocoPackages = (Get-ChocoPackages).Name
    $global:ChocoInstalls = $global:ChocoInstalls | Where-Object { $InstalledChocoPackages -notcontains $_ }

    if ($global:ChocoInstalls.Count -gt 0) {
        # Install a ton of other crap I use or like, update $ChocoInsalls to suit your needs of course
        $global:ChocoInstalls | Foreach-Object {
            try {
                
                choco install "$_" --update
                refreshenv
                Write-Output "$_" >> $global:chageLog   -ErrorAction SilentlyContinue
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

# > arpspoof.exe
$content = @" 

 - EXAMPLES:

    $ arpspoof.exe --list | [-i iface] [--oneway] victim-ip [target-ip]

    >>

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

#
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


}
Export-ModuleMember -Function *