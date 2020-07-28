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
      "Install-Pentest"{$espacio = 32}
      "Install-REversing"{$espacio = 32}
      
}

    $disk = $env:systemdrive.Split(":")[0] 
    $disk = Get-PSDrive C
      Start-Sleep -Seconds 1
      if (-Not (($disk.free)/1GB -gt $espacio)){
        Write-Host " [ERR] Esta instalacion requiere de $espacio GB de espacio en disco`n" -ForegroundColor Red
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


        $StartMenu = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\RelaTools'     
        Remove-Item $StartMenu -Force -Recurse
        $Download = "$env:LOCALAPPDATA\RELATIVITY\"
        $value = "$env:USERPROFILE\Desktop\"
        Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/Relativity-Environment/Relativity_Scripts/raw/master/PENTEST.TOOLS/FILES/ZIP/Pentest_Tools.zip" -Outfile "$Download\Pentest_Tools.zip" 
        Expand-Archive -path "$Download\Pentest_Tools.zip" -DestinationPath $StartMenu -Force
        New-Item -ItemType SymbolicLink -Path $value -Name "Pentest_Tools" -Value "$StartMenu\Pentest_Tools" -Force
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
    $clearDesktop = "$env:LOCALAPPDATA\RELATIVITY\clear_desktop"
    if(-not(Test-Path $clearDesktop)){
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
        New-Item -ItemType file -Path $clearDesktop
        }
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

## Create Restore POINT
Function Add-Checkpoint($name){
    $exist = Get-ComputerRestorePoint | Where-Object {$_.description -match $name } | Select-Object -ExpandProperty Description
    
    if($exist -eq $name)
    {
            
        Write-Output "$name exist!"
    
    
       }else{
        
        Write-Host "[+] Checkpoint create: $name" -ForegroundColor Cyan
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
                
                Write-Host "[+] Downloading $software" -ForegroundColor Cyan
                Invoke-WebRequest $global:ManualDownloadInstall[$software] -OutFile $software -UseBasicParsing -ErrorAction SilentlyContinue
                $FilesDownloaded += $software
                

            }
            catch {

                Write-Output "$software fail" -ErrorAction SilentlyContinue

            }
        }
        else {

            Write-Information "[-] File is already downloaded, skipping: $software"
            
        }
     }

    Write-Information '[-] Extracting self-contained binaries (rar files) to our bin folder'
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
    
    $tgzs = Get-ChildItem -filter "*.tgz" -path "$UtilDownloadPath"-Recurse
    $WinRar = "C:\Program Files\WinRAR\winrar.exe"
    foreach ($tgz in $tgzs)
    {   
        $tg = [io.path]::GetFileNameWithoutExtension($tgz)
        if(-not(Test-Path "$UtilBinPath\$tg")){
       
        New-Item -ItemType Directory -Path $UtilBinPath -Name $tg
        &$Winrar x $tgz.FullName "$UtilBinPath\$tg"
        Get-Process winrar | Wait-Process -ErrorAction SilentlyContinue
       

        }
    }

    <#
    $zips = Get-ChildItem -filter "*.zip" -path "$UtilDownloadPath"-Recurse
    $WinRar = "C:\Program Files\WinRAR\winrar.exe"
    foreach ($zip in $zips)
    {   
        $zp = [io.path]::GetFileNameWithoutExtension($zip)
        if(-not(Test-Path "$UtilBinPath\$zp")){
       
        New-Item -ItemType Directory -Path $UtilBinPath -Name $zp
        &$Winrar x $zip.FullName "$UtilBinPath\$zp"
        Get-Process winrar | Wait-Process -ErrorAction SilentlyContinue

        }
    }#>

    # Extracting self-contained binaries (zip files) to our bin folder
    Write-Information '[-] Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.zip' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
        
        #Push-Location $UtilBinPath
        Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath\$($_.Basename)
        refreshenv
        
        
    }#>

               
    # Kick off msi installs
    $msi = Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi'
    ForEach ($name in $msi) {          
    $file = [io.path]::GetFileNameWithoutExtension($name)  
    if(-not(Test-Path "$UtilBinPath\$file" )){
            
           Get-ChildItem -Path $UtilDownloadPath -File -Filter $name | ForEach-Object {Install-ChocolateyPackage -PackageName $_.Name -FileType 'msi' -File $_.FullName -SilentArgs '/qn'} 
           New-Item -ItemType directory -Path $UtilBinPath -Name $file
                 
        }else{

            Write-Information "[-] $name is installed"

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

        mkdir $UtilDownloadPath -ErrorAction SilentlyContinue | Out-Null
    }

    Push-Location $UtilDownloadPath 
       
    $FilesDownloaded = @()
        
    Foreach ($software in $global:PEAPPS.keys) {
        
        $path = [io.path]::GetFileNameWithoutExtension($software)

        if ( -not (Test-Path "$UtilBinPath\$path") ) {
            try {

                Write-Host "[+] Downloading $software" -ForegroundColor Cyan
                Invoke-WebRequest $global:PEAPPS[$software] -OutFile $software -UseBasicParsing -ErrorAction SilentlyContinue
                refreshenv
                $FilesDownloaded += $software
            
            }
            catch {

                
                Write-Error "[!] $software fail" 
            }
        }
        else {
            
            Write-Information "[-] File is already downloaded, skipping: $software"
        }
    }

        # Kick off PE files
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
                    
                    Write-Host "[+] Downloading $software" -ForegroundColor Cyan
                    git clone $global:GitPackages[$software] -q
                    refreshenv
                    if (Test-PendingReboot) { Invoke-Reboot }
                
                }
                
                catch {
                   
                    Write-Error "[!] Unable to download git package: $software"
            }      
        }
    
    else {
                   
            Write-Information "[-] There were no git to download: $software"

       }
    }
 }



## Install from AHK

Function Get-AHKPackages
{

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
  
    $UtilDownloadPath   = "$env:systemdrive\cache\ahk"

   
    
    If (-not (Test-Path $UtilDownloadPath)) {

        mkdir $UtilDownloadPath -ErrorAction SilentlyContinue | Out-Null
    }

    Push-Location $UtilDownloadPath 
    $content = get-content "$env:LOCALAPPDATA\RELATIVITY\pentest_ahk_dowload" -ErrorAction SilentlyContinue
    Foreach ($software in $global:AHKPackages.keys) {
        
        if (-not($content | select-string -pattern $software) ) {
           
            try {

                Write-Host "[+] Downloading $software" -ForegroundColor Cyan
                Invoke-WebRequest $global:AHKPackages[$software] -OutFile $software -UseBasicParsing -ErrorAction SilentlyContinue
                refreshenv
                Write-Output "$software" >> "$env:LOCALAPPDATA\RELATIVITY\pentest_ahk_dowload"
            }
            catch {

                Write-Error "[!] $software fail" 

            }
        }
        else {

            Write-Information "[-] File is already downloaded, skipping: $software"
           
        }

        
    }

    

    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path "$env:SYSTEMDRIVE\cache\ahk" -File -Filter '*.zip' | ForEach-Object {
    Push-Location "$env:SYSTEMDRIVE\cache\ahk"
    Expand-Archive -Path $_.FullName -DestinationPath . -ErrorAction SilentlyContinue
    refreshenv
    
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
    Write-Information "[-] Initializing chocolatey"
    Invoke-Expression "choco feature enable -n allowGlobalConfirmation"
    Invoke-Expression "choco feature enable -n allowEmptyChecksums"   
    $InstalledChocoPackages = (Get-ChocoPackages).Name
    $global:ChocoInstalls = $global:ChocoInstalls | Where-Object { $InstalledChocoPackages -notcontains $_ }

    if ($global:ChocoInstalls.Count -gt 0) {
        $global:ChocoInstalls | Foreach-Object {
            try {
                
                choco install "$_" --update
                refreshenv
                
            }
            catch {
               
                Write-Error "[!] Unable to install software package with Chocolatey: $_"
               
        }
    }
}
            else {
                
                Write-Information "[-] File is already downloaded, skipping: $_"
                
            }

}



### Control installed (not used)##
Function Confirm-Installed($command){

    $controlInstall = "$env:LOCALAPPDATA\RELATIVITY\control_installed"
    # pruebas - $controlInstall = "$env:userprofile\Desktop\control_installed"
  
  
    if(-not(Test-Path $controlInstall)){
    
        New-Item -ItemType file -Path $controlInstall
        Write-Output "start" >> $controlInstall
    } 
    $control = get-content $controlInstall 
        
    foreach($comm in $control){
     
        if (-not($control | select-string -pattern $command)) {          
            
            powershell.exe $command        
            Write-Output "$command" >> $controlInstall

         }else{}
    }    
}    
  

### Create README (not used) ##
function Add-README{

    $toolsPath      = "$env:systemdrive\RelaTools"

# > 
$content = @" 

 - DOCUMENTATION:
    
   

 - EXAMPLES:

 

"@
Add-Content -PassThru "$toolsPath\    \README" -Value $content


}

Export-ModuleMember -Function *