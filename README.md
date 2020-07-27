# Relativity - Security Tools for Windows Environment

Script en Powershell que prepara un entorno con herramientas orientadas a la seguridad y al pentesting. 
Instalación de forma desatendidad en sistemas Microsoft Windows 10 , contiene una recopilación de herramientas que cubre las necesidades básicas del pentester.


# Comenzando 🚀

### Pre-requisitos 📋

#### Sistema Operativo

- Windows 10 (compilaciones más recientes)

#### Conexión a internet

- Imprescindible para descargar las herramientas

#### Espacio en disco

- PentestTools   : += 45Gb libres
- ReversingTools :  (aún no disponible)
- WiFiTools       : (aún no disponible)

#### Memoria RAM

- += 4Gb

#### CPU

- Cualquier CPU con al menos 2 cores

#### Protección Anti-Tampering

Para realizar la instalación es necesario desactivar antes la protección 'Anti-Tampering' (es obligatorio para la instalación), para más información:
 
 - https://www.tenforums.com/tutorials/123792-turn-off-tamper-protection-windows-defender-antivirus.html
 
 
### Instalación 🔧

*Soporta ser instalado en un máquina virtual
 
Una vez realizado el paso anterior ejecutar el siguiente código en una consola de Powershell como adminstrador:


```powershell
. {iwr -useb https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/menu.ps1} | iex ;menu -Force
```

### Punto de restauración 🛠️

Al comenzar la instalación se crea un checkpoint que sirve para volver a un punto anterior el sistema en caso de que algo vaya mal o que queramos prescindir del entorno.


## Herramientas disponibles ⚙️

De momento solo estas disponibles las herramentas orientas a un pentest básico, más adelante se agregarán herramientas para auditorias WiFi y Reversing/Análisis de Malware.

### Pentest Tools

#### 1- Recopilación de Información                                           
* [adaudit](https://github.com/phillips321/adaudit)
* [aquatone](https://github.com/michenriksen/aquatone)
* [Asnlookup](https://github.com/yassineaboukir/Asnlookup)
* [CCrawlDNS](https://github.com/lgandx/CCrawlDNS)
* [enum4linux](https://github.com/CiscoCXSecurity/enum4linux)
* [fierce](https://github.com/mschwager/fierce)
* [FOCA](https://github.com/ElevenPaths/FOCA)
* [gmtcheck](https://www.elevenpaths.com/es/labstools/gmtchecksp/index.html)
* [googleindexretriever](https://www.elevenpaths.com/es/labstools/googleindexretriever-2/index.html)
* [instagram-py](https://github.com/deathsec/instagram-py)
* [ipscan](https://github.com/angryip/ipscan)
* [ldapdomaindump](https://github.com/dirkjanm/ldapdomaindump)
* [Maltego Community](https://www.maltego.com/maltego-community/)
* [NetfoxDetective](https://github.com/nesfit/NetfoxDetective)
* [NetworkMiner](https://www.netresec.com/?page=NetworkMiner)
* [Nmap](https://nmap.org/)
* [PhEmail](https://github.com/Dionach/PhEmail)
* [PhoneInfoga](https://github.com/sundowndev/PhoneInfoga)
* [Public Intelligence Tool](https://sourceforge.net/projects/publicintelligencetool/)
* [pwnedOrNot](https://github.com/thewhiteh4t/pwnedOrNot)
* [Ultimate-Facebook-Scraper](https://github.com/harismuneer/Ultimate-Facebook-Scraper)
* [sherlock](https://github.com/sherlock-project/sherlock)
* [smbmap](https://github.com/ShawnDEvans/smbmap)
* [smtp_diag_tool](https://www.adminkit.net/smtp_diag_tool.aspx)
* [snmp-scanner](https://sourceforge.net/projects/snmp-scanner/)
* [spiderfoot](https://www.spiderfoot.net/documentation/)
* [tacyt-maltego-transforms](https://github.com/ElevenPaths/tacyt-maltego-transforms)
* [theHarvester](https://github.com/laramies/theHarvester)
* [wesng](https://github.com/bitsadmin/wesng)
* [zenmap](https://nmap.org/zenmap/)

 #### 2 - Análisis de Aplicaciones Web
* []()
* []()
* []()
* []()
* []()




## Wiki 📖
Aún no disponible 


## Autor ✒️

* **Victor M. Gil** - *Trabajo Inicial* - (victorgilasp@gmail.com)


## Licencia 📄

Este proyecto está bajo la Licencia (GNU) - mira el archivo [LICENSE](LICENSE) para detalles

