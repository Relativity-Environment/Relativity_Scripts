﻿[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

## JOIN-INITIAL
function Join-Initial
{

    ## BOXSTARTER
    function Install-BoxStarter
    {
        $PathBoxStarter = "C:\ProgramData\Boxstarter" 
        $InstallBoxStarter = $true
        Write-Debug "[+] Comprobando si Boxstarter esta instalado en el sistema"

    if ($InstallBoxStarter -and (-not (Test-Path $PathBoxStarter))) {
    
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


## $PROFILE 
Function Test-PSProfile 
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

## PRIVILEGE
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

## COMPATIBILITY
function Test-HostSupported
{

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

## TAMPER
Function Test-TamperProtection
{

  if (-not(Test-Path "$env:LOCALAPPDATA\RELATIVITY\TWEAKS")) {
    
    $tamperTrue = Get-MpComputerStatus | Select-Object IsTamperProtected | Where-Object {$_.IsTamperProtected -eq $true} -ErrorAction SilentlyContinue
    if($tamperTrue -eq $null){
    
      Write-Host "`tTamper Protection is off, looks good." -ForegroundColor Green
    
    }else{
    
      Write-Host "[!] Por favor deshabilita la Proteccion contra alteraciones de Windows Defender (Tamper Protection) e intentalo de nuevo." -ForegroundColor Red
      Write-Host "`t[+] Hint: https://www.tenforums.com/tutorials/123792-turn-off-tamper-protection-windows-defender-antivirus.html" -ForegroundColor Yellow
      exit
    
    }
  }else{}
  
}


## MODULO
function Install-Module{
   
  New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\RELATIVITY" -ErrorAction SilentlyContinue | Out-Null
  Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/MODULE/module.psm1" -Outfile "$env:LOCALAPPDATA\RELATIVITY\module.psm1" -ErrorAction SilentlyContinue
  Import-Module "$env:LOCALAPPDATA\RELATIVITY\module.psm1" 

} 

function Test-PowershellExecution{
   
  Set-ExecutionPolicy Unrestricted | Out-Null
 
} 

## CALL FUNCTIONS
  Test-AdminExecution;
  Test-PowershellExecution;
  Test-TamperProtection;
  Test-HostSupported;
  Test-PSProfile;
  Install-Module;
  Install-BoxStarter;
  Add-InstallFolders
  

} #<<<<<<< Final Join-Initial



## INSTALLATION PACKAGES

$pentest     =  "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/PENTEST.TOOLS/install.pentest.ps1"
#$reversing   =  "https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/REVERSING.TOOLS/install.reverse.ps1" 


function Install-Pentest{ 
      
    Join-Initial

    if (-not(Test-Path "$env:LOCALAPPDATA\RELATIVITY\Install-Pentest")) {
      
      Test-DiskSpace "Install-Pentest"
      New-Item -ItemType file -Path "$env:LOCALAPPDATA\RELATIVITY" -Name "Install-Pentest"
    
    }

    if (-not(Test-Path "$env:LOCALAPPDATA\RELATIVITY\TWEAKS")) {Get-Tweaks}   
   
    Write-Host "[+] Instalando Pentest Tools..." -ForegroundColor Green
    $cred=Get-Credential 
    Install-BoxstarterPackage -PackageName $pentest -Credential $cred
     
} 
   

function Install-Reversing{ 
      
  #TODO

}


function Install-Wifi{ 
      
  #TODO

}


# RESTORE COMPUTER
Function Restore-Point{
  
  if(Test-Path "$env:LOCALAPPDATA\RELATIVITY\TWEAKS")
  {

    Write-Warning "[!] Atencion has elegido restaurar el sistema"
    Get-ComputerRestorePoint
    $num = Read-Host "Elige el id del punto de restauracion y pulsa enter:"
    Restore-Computer -RestorePoint $num -Confirm
  
 }else{

    Write-Warning "Aun no has instalado ninguna herramienta"

  }

}

### Menu Instalador 
function menu {

  Write-Host "`n"
  Write-Host "      __________________________________________________________________________________________________ " -ForegroundColor Green 
  Write-Host "     |                                                                                                  |" -ForegroundColor Green 
  Write-Host "     |                                     Created by Victor M. Gil                                     |" -ForegroundColor Green 
  Write-Host "     |                                                                                                  |" -ForegroundColor Green 
  Write-Host "     |                                                                                                  |" -ForegroundColor Green 
  Write-Host "     |                          RELATIVITY - Security Tools for Windows Environment                     |" -ForegroundColor Green 
  Write-Host "     |                                                                                                  |" -ForegroundColor Green 
  Write-Host "     |                                                                                                  |" -ForegroundColor Green
  Write-Host "     |__________________________________________________________________________________________________|" -ForegroundColor Green  
  Write-Host "     |__________________________________________________________________________________________________|" -ForegroundColor Green 
  Write-Host "     |                                                                                                  |" -ForegroundColor Green
  Write-Host "     |                                                                                                  |" -ForegroundColor Green
  Write-Host "     |                               [+] INSTALL MENU                                                   |" -ForegroundColor Green 
  Write-Host "     |                                                                                                  |" -ForegroundColor Green
  Write-Host "     |                               10. PENTEST TOOLS                                                  |" -ForegroundColor Green
  Write-Host "     |                               20. REVERSING TOOLS (Unavalaible)                                  |" -ForegroundColor Green
  Write-Host "     |                               30. WIFI TOOLS (Unavalaible)                                       |" -ForegroundColor Green
  Write-Host "     |                                                                                                  |" -ForegroundColor Green
  Write-Host "     |__________________________________________________________________________________________________|" -ForegroundColor Green 
  Write-Host "     |__________________________________________________________________________________________________|" -ForegroundColor Green
  Write-Host "     |                                                                                                  |" -ForegroundColor Green 
  Write-Host "     |  " -ForegroundColor Green -NoNewLine; Write-Host "                             BACK. Restaurar el sistema" -ForegroundColor Yellow -NoNewLine; Write-Host "                                         |" -ForegroundColor Green
  Write-Host "     |                                                                                                  |" -ForegroundColor Green
  Write-Host "     |                               [-] SALIR Ctrl + C                                                 |" -ForegroundColor Green
  Write-Host "     |                                                                                                  |" -ForegroundColor Green
  Write-Host "     |                                                                                                  |" -ForegroundColor Green
  Write-Host "     |__________________________________________________________________________________________________|" -ForegroundColor Green
  Write-Host ""

  while(($inp = Read-Host -Prompt "Select an option") ){  
  
  switch($inp){
        10 {
            Clear-Host;
            Install-Pentest;
            pause;
            menu;
            break
        }
        20 {
            Clear-Host;
            #Install-Reversing;
            Write-Host "No disponible"
            pause;
            menu;
            break
        }
        BACK {
            Clear-Host;
            Restore-Point;
            pause;
            menu;
            break
        }
       C{"Exit"; exit}
       
      default {Write-Host -ForegroundColor red -BackgroundColor white "Opcion invalida, escoge otra opcion"; menu; pause}
      
        
    }
  
  }
  ?>
}menu
