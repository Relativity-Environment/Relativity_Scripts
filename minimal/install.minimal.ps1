
<# Opcion 1 - Instalacion de opcion minimal #>

$BoxPackageName         =   "install.minimal"

if (Test-PendingReboot) { Invoke-Reboot }   

Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

$ErrorActionPreference  =   'Continue'



$ManualDownloadInstall = @{

    'nikto.zip'   = 'https://github.com/sullo/nikto/archive/master.zip'
    'Vulnerator.zip'  = 'https://github.com/Vulnerator/Vulnerator/releases/download/v6.1.9/Vulnerator_v6-1-9.zip'

}

Get-DownloadManual -UtilDownloadPath  -UtilBinPath




















Write-Output "[+] Instalando paquetes desde chocolatey..."

if ($ChocoInstalls.Count -gt 0) {
  
     
  try{

        $ChocoInstalls | Foreach-Object {

        Write-Output "INFO Intentando instalar $_"
                 
        cinst -y --ignore-checksums $_ 
        Start-Sleep 1
        Get-Icon $_ 
        Write-Output "INFO Instalacion de $_ finalizada correctamente"
        
  
    }
                   

    }catch{
            
        Write-Warning "ERROR No se ha podido instalar: $($_)"
        continue
            
 }

}else{
    
       Write-Output "INFO No hay paquetes que instalar"

}
