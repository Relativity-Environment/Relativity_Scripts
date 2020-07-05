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
    
    New-Item -path $PROFILE -type File -Force
    
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
function Install-OptimizeEnvModule{
  
 
  $null = New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\module_relativity" -ErrorAction SilentlyContinue
  Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/module/module.psm1" -Outfile "$env:LOCALAPPDATA\module_relativity\module.psm1"
  Import-Module "$env:LOCALAPPDATA\module_relativity\module.psm1" -Force -ErrorAction Stop

} 


## Llamada a las funciones
  Test-AdminExecution;
  Test-HostSupported;
  Test-PSProfile;
  Install-OptimizeEnvModule;
  Install-BoxStarter
 

} #<<<<<<< Final funcion InitialSetup



## Funciones de instalacion

$minimal     =  "https://gist.githubusercontent.com"
$full        =     



## Funcion para instalar todos los paquetes [0]
function Install-Minimal{ 
      
    Join-Initial
    Test-DiskSpace "Install-Minimal"
    Write-Host "[+] Instalando version minima...." -ForegroundColor Green
    #Install-BoxstarterPackage -PackageName  $Base, $url$Info, $url$Vuls, $url$Web, $url$Bbdd, $url$Passwd, $url$Explot, $url$Spoof, $url$Set -ErrorAction Continue
    Install-BoxstarterPackage -PackageName 
}


function InstallInfo{ 
      
    Join-Setup
    #Test-DiskSpace "InstallInfo"
    Write-Host "[+] Instalando paquete Recopilacion de Informacion..." -ForegroundColor Green
    Install-BoxstarterPackage -PackageName $minimal

  }


function InstallVulns{ 
      
    InitialSetup
    Test-DiskSpace "InstallVuls"
    Write-Host "[+] Instalando paquete Analisis de Vulnerabilidades..." -ForegroundColor Green
    #Install-Nessus
    Install-BoxstarterPackage -PackageName $url$Vuls

  }

function InstallWeb{ 

    InitialSetup

    Write-Host "[+] Instalando paquete Analisis de Aplcaciones Web..." -ForegroundColor Green
    Install-BoxstarterPackage -PackageName $Web

  }

function InstallBbdd{ 

    InitialSetup

    Write-Host "[+] Instalando paquete Analisis de Bases de datos..." -ForegroundColor Green
    Install-BoxstarterPackage -PackageName $Bbdd

  }


function InstallPasswd{ 

    InitialSetup

    Write-Host "[+] Instalando paquete Ataques de Contraseña..." -ForegroundColor Green
    Install-BoxstarterPackage -PackageName $Passwd

  }

function InstallExplot{ 

    InitialSetup

    Write-Host "[+] Instalando paquete Herramientas de Explotacion..." -ForegroundColor Green
    Install-BoxstarterPackage -PackageName $Explot

  }


function InstallSpoof{ 

    InitialSetup

    Write-Host "[+] Instalando paquete Herramientas de Sniff/Spoof.." -ForegroundColor Green
    Install-BoxstarterPackage -PackageName $Spoof

  }


function InstallSet{ 

    InitialSetup

    Write-Host "[+] Instalando paquete Herramientas para Ing. Social.." -ForegroundColor Green
    Install-BoxstarterPackage -PackageName $Set

  }



### Menu Instalador 
function menu {

  Write-Host "`n"
  Write-Host " __________________________________________________________________________________________________ " -ForegroundColor Red 
  Write-Host "|                                                                                                  |" -ForegroundColor Red 
  Write-Host "|                                          Creado por                                              |" -ForegroundColor Red 
  Write-Host "|                                         Victor M. Gil                                            |" -ForegroundColor Red 
  Write-Host "|                                                                                                  |" -ForegroundColor Red 
  Write-Host "|                                    Instalador de Gravity_tools                                   |" -ForegroundColor Red 
  Write-Host "|                                                                                                  |" -ForegroundColor Red 
  Write-Host "|                                                                                                  |" -ForegroundColor Red 
  Write-Host "|__________________________________________________________________________________________________|" -ForegroundColor Red 
  Write-Host "|                                   Inciando Menu...                                               |" -ForegroundColor Red 
  Write-Host "|                                                                                                  |" -ForegroundColor Red
  Write-Host "|                                  00. Instalar todas las herramientas                             |" -ForegroundColor Red
  Write-Host "|                                  10. Instalar solo Recopilacion de Informacion                   |" -ForegroundColor Red
  Write-Host "|                                  20. Instalar solo Analisis de Vulnerabilidades                  |" -ForegroundColor Red
  Write-Host "|                                  30. Instalar solo Analisis Aplicaciones Web                     |" -ForegroundColor Red
  Write-Host "|                                  40. Instalar solo Analisis Bases de Datos                       |" -ForegroundColor Red
  Write-Host "|                                  50. Instalar solo Ataques de Contraseña                         |" -ForegroundColor Red
  Write-Host "|                                  60. Instalar solo Herramientas de Explotacion                   |" -ForegroundColor Red
  Write-Host "|                                  70. Instalar solo Herramientas para Sniffing/Spoofing           |" -ForegroundColor Red
  Write-Host "|                                  80. Instalar solo Herramientas para Ing. Social                 |" -ForegroundColor Red
  Write-Host "|                                                                                                  |" -ForegroundColor Red
  Write-Host "|                                  [-] SALIR Ctrl + C                                              |" -ForegroundColor Red
  Write-Host "|                                                                                                  |" -ForegroundColor Red
  Write-Host "|__________________________________________________________________________________________________|" -ForegroundColor Red 
  Write-Host ""
  
  
  while(($inp = Read-Host -Prompt "Select an option") -ne "9"){  #> Control opciones
  
  switch($inp){
        00 {
            Clear-Host
            Write-Host "----------------------------------";
            Write-Host "Instalando todas las herramientas "; 
            Write-Host "----------------------------------";
            InstallAll;
            pause;
            menu;
            break
        }
        10 {
            Clear-Host
            Write-Host "----------------------------------------------------";
            Write-Host "Instalando herramientas Recopilacion de Informacion ";
            Write-Host "----------------------------------------------------";
            InstallInfo;
            pause;
            menu;
            break
        }
        20 {
            Clear-Host
            Write-Host "-----------------------------------------------------";
            Write-Host "Instalando herramientas Analisis de Vulnerabilidades ";
            Write-Host "-----------------------------------------------------";
            InstallVulns;
            pause;
            menu;
            break
        }
        30 {
            Clear-Host
            Write-Host "-----------------------------------------";
            Write-Host "Instalando herramientas Aplicaciones Web ";
            Write-Host "-----------------------------------------";
            InstallWeb;
            pause;
            menu;
            break
        }
        40 {
            Clear-Host
            Write-Host "------------------------------------------------";
            Write-Host "Instalando herramientas Analisis Bases de Datos ";
            Write-Host "------------------------------------------------";
            InstallBbdd;
            pause;
            menu;
            break
        }
        50 {
            Clear-Host
            Write-Host "-----------------------------------------------------";
            Write-Host "Instalando herramientas para Ataques de Constraseñas ";
            Write-Host "-----------------------------------------------------";
            InstallPasswd;
            pause;
            menu;
            break
        }
        60 {
            Clear-Host
            Write-Host "---------------------------------------";
            Write-Host "Instalando herramientas de Explotacion ";
            Write-Host "---------------------------------------";
            InstallExplot;
            pause;
            menu;
            break
        }
        70 {
          Clear-Host
          Write-Host "--------------------------------------------";
          Write-Host "Instalando herramientas Sniffing y Spoofing ";
          Write-Host "--------------------------------------------";
          InstallSpoof;
          pause;
          menu;
          break
        }
        80 {
          Clear-Host
          Write-Host "------------------------------------";
          Write-Host "Instalando herramientas Ing. Social ";
          Write-Host "------------------------------------";
          InstallSet;
          pause;
          menu;
          break
       }

       C{"Exit"; exit}
       
      default {Write-Host -ForegroundColor red -BackgroundColor white "Opcion invalida. Escoge otra opcion";pause}
        
    }
  
  }
  ?>
}menu
