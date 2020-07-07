$OutputEncoding = [Console]::OutputEncoding

### Funcion de instalacion de InitialSetup
function Join-Initial
{

    # Boxmaster
    function Install-BoxStarter
    {
        $PathBixStarter = "C:\ProgramData\Boxstarter" 
        $InstallBoxStarter = $true
        Write-Debug "[+] Comprobando si Boxstarter esta instalado en el sistema"

    if ($InstallBoxStarter -and (-not (Test-Path $PathBixStarter))) {
    
      try {
 
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); get-boxstarter -Force
        return $true
        Write-Host "Boxstarter Instalado!!" -ForegroundColor Green
        continue
 
  } catch {
 
  }
  
  try {
  Add-Type @"
  using System.Net;
  using System.Security.Cryptography.X509Certificates;
  public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
      ServicePoint srvPoint, X509Certificate certificate,
      WebRequest request, int certificateProblem) {
      return true;
    }
  }
"@
  } catch {
    Write-Debug "Failed to add new type"
  }  
  try {
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
  } catch {
    Write-Debug "Failed to find SSL type...1"
  }  
  try {
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls'
  } catch {
    Write-Debug "Failed to find SSL type...2"
  }  
  $prevSecProtocol = [System.Net.ServicePointManager]::SecurityProtocol
  $prevCertPolicy = [System.Net.ServicePointManager]::CertificatePolicy  
  Write-Host "Instalando Boxstarter" -ForegroundColor Green
 
  [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
  [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy  
 
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); get-boxstarter -Force  
  [System.Net.ServicePointManager]::SecurityProtocol = $prevSecProtocol
  [System.Net.ServicePointManager]::CertificatePolicy = $prevCertPolicy
  return $true
  Write-Host " Boxstarter Instalado!!" -ForegroundColor Green
  continue
 
  }else {
   
    Write-Warning " Boxstarter ya esta instalado en el sistema"
 }


}

# Comprobar $Profile
function Test-PSProfile 
{  

  $CreatePowershellProfile = $true
  Write-Output "[+] Comprobando si existe Powershell Profile..." 
  if ($CreatePowershellProfile -and (-not (Test-Path $PROFILE))) {
    
    Write-Host " Creando Powershell Profile" -ForegroundColor Green 
    
    New-Item -path $PROFILE -type File -Force | Out-Null
    
  }else{

    Write-Warning ' El perfil ya esta creado ($PROFILE)'

  }


} 

# Comprobar privilegios
function Test-AdminExecution
{
 
  Write-Host "[+] Comprobando que el script se esta ejecuntado como administrador.."
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
  if (-Not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [ERR] Por favor ejecuta el script como administrador`n" -ForegroundColor Red -NoNewline
    Write-Host "`n  Parando`n" -ForegroundColor Red -NoNewline
    Read-Host  "Pulsa cualquier tecla para continuar"
    exit
  } else {
    Start-Sleep -Milliseconds 500
    Write-Host " Eres Administrador " -ForegroundColor Green 
    Start-Sleep -Milliseconds 500
  }
  
} 


# Comprobar si el sistema es compatible
function Test-HostSupported
{

   #
   Write-Host "[+] Comprobando compatibilidad del sistema operativo"
   if ((Get-WmiObject -class Win32_OperatingSystem).Version -eq "6.1.7601"){
     Write-Host "Windows 7 no esta soportado. ¿Deseas continuar? S/N" -ForegroundColor Yellow 
     $response = Read-Host
     if ($response -ne "S"){
       exit
     }
   }
   
   $osversion = (Get-WmiObject -class Win32_OperatingSystem).BuildNumber
   if (-Not (($osversion -eq 18363) -or ($osversion -eq 18361) -or ($osversion -eq 17763) -or ($osversion -eq 17134) -or ($osversion -eq 19041) )){
     Write-Host " [ERR] La version $osversion podría dar problemas" -ForegroundColor Yellow 
     Write-Host "[-] ¿Quieres continuar? S/N " -ForegroundColor Yellow 
     $response = Read-Host 
     if ($response -ne "S"){
       exit
     }
   } else {
     Write-Host " Esta version de Windows esta soportada $osversion" -ForegroundColor Green 
   }
 
   
  
}


# Modulo funciones propias para optimizacion
function Install-Module{
  
 
  $null = New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\module_relativity" -ErrorAction SilentlyContinue
  Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/module/module.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\module.psm1"
  Import-Module "$env:LOCALAPPDATA\module_relativity\module.psm1" -Force -ErrorAction Stop

} 


## Llamada a las funciones
  Test-AdminExecution;
  Test-HostSupported;
  Test-PSProfile;
  Install-Module;
  Install-BoxStarter
 

} #<<<<<<< Final funcion InitialSetup



## Funciones de instalacion

$minimal     =  "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/minimal/install.minimal.ps1"
$full        =  "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/full/install.full.ps1" 



## Funcion para instalar todos los paquetes [0]
function Install-Minimal{ 
      
    Join-Initial
    #Test-DiskSpace "Install-Minimal"
    Write-Host "[+] Instalando Minimal Version...." -ForegroundColor Green
    Install-BoxstarterPackage -PackageName $minimal
}


function Install-Full{ 
      
    Join-Initial
    #Test-DiskSpace "Install-Full"
    Write-Host "[+] Instalando Full Version...." -ForegroundColor Green
    Install-BoxstarterPackage -PackageName $minimal,$full
}



### Menu Instalador 
function menu {

  Write-Host "`n"
  Write-Host " __________________________________________________________________________________________________ " -ForegroundColor Green 
  Write-Host "|                                                                                                  |" -ForegroundColor Green 
  Write-Host "|                                          Creado por                                              |" -ForegroundColor Green 
  Write-Host "|                                         Victor M. Gil                                            |" -ForegroundColor Green 
  Write-Host "|                                                                                                  |" -ForegroundColor Green 
  Write-Host "|                                    Instalador de Gravity_tools                                   |" -ForegroundColor Green 
  Write-Host "|                                                                                                  |" -ForegroundColor Green 
  Write-Host "|                                                                                                  |" -ForegroundColor Green
  Write-Host "|__________________________________________________________________________________________________|" -ForegroundColor Green  
  Write-Host "|__________________________________________________________________________________________________|" -ForegroundColor Green 
  Write-Host "|                                   Inciando Menu...                                               |" -ForegroundColor Green 
  Write-Host "|                                                                                                  |" -ForegroundColor Green
  Write-Host "|                                  10. Instalar Minimal Version (10GB)                             |" -ForegroundColor Green
  Write-Host "|                                  20. Instalar Full Version    (20gb)                             |" -ForegroundColor Green
  Write-Host "|__________________________________________________________________________________________________|" -ForegroundColor Green 
  Write-Host "|__________________________________________________________________________________________________|" -ForegroundColor Green
  Write-Host "|                                                                                                  |" -ForegroundColor Green 
  Write-Host "|       " -ForegroundColor Green -NoNewLine; Write-Host "                 CHKPOINT - Restaura el sistema al punto de restauracion" -ForegroundColor Red -NoNewLine; Write-Host "                    |" -ForegroundColor Green
  Write-Host "|                                                                                                  |" -ForegroundColor Green
  Write-Host "|                                  [-] SALIR Ctrl + C                                              |" -ForegroundColor Green
  Write-Host "|                                                                                                  |" -ForegroundColor Green
  Write-Host "|                                                                                                  |" -ForegroundColor Green
  Write-Host "|__________________________________________________________________________________________________|" -ForegroundColor Green
  Write-Host ""

  
  
  while(($inp = Read-Host -Prompt "Select an option") -ne "9"){  #> Control opciones
  
  switch($inp){
        10 {
            Clear-Host;
            Install-Minimal;
            pause;
            menu;
            break
        }
        20 {
            Clear-Host;
            Install-Full;
            pause;
            menu;
            break
        }
        CHKPOINT {
            Clear-Host;
            pause;
            menu;
            break
        }
       C{"Exit"; exit}
       
      default {Write-Host -ForegroundColor red -BackgroundColor white "Opcion invalida, escoge otra opcion" menu;pause}
      
        
    }
  
  }
  ?>
}menu
