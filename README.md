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



### Pentest Tools (aún en pruebas -  no definitivas)

| 1- Recopilación de Información | 2 - Analisis de Aplicaciones Web | 3 - Analisis de Bases de Datos  |
|--------------------------------|----------------------------------|---------------------------------|                                 
|[adaudit](https://github.com/phillips321/adaudit) |              [CMSeeK](https://github.com/Tuhinshubhra/CMSeeK)| [Damn Small SQLi Scanner](https://github.com/stamparm/DSSS)|
|[aquatone](https://github.com/michenriksen/aquatone)|            [dirbuster](https://sourceforge.net/projects/dirbuster/)  | [explo](https://github.com/dtag-dev-sec/explo)
|[Asnlookup](https://github.com/yassineaboukir/Asnlookup)|        [droopescan](https://github.com/droope/droopescan)        | [jsql-injection](https://github.com/ron190/jsql-injection)
|[CCrawlDNS](https://github.com/lgandx/CCrawlDNS)|                [havij](https://www.darknet.org.uk/2010/09/havij-advanced-automated-sql-injection-tool/)  | [NoSQLMap](https://github.com/codingo/NoSQLMap)
|[enum4linux](https://github.com/CiscoCXSecurity/enum4linux)|     [joomscan](https://github.com/rezasp/joomscan)                                            | [padding-oracle-attacker](https://github.com/KishanBagaria/padding-oracle-attacker)
|[fierce](https://github.com/mschwager/fierce)|                   [mutiny-fuzzer](https://github.com/Cisco-Talos/mutiny-fuzzer)                             | [quicksql](https://github.com/trustedsec/quicksql)
|[FOCA](https://github.com/ElevenPaths/FOCA)|                     [N-Stalker X - Free Edition](https://www.nstalker.com/products/editions/free/)            | [safe3si](https://sourceforge.net/projects/safe3si/)
|[gmtcheck](https://www.elevenpaths.com/es/labstools/gmtchecksp/index.html)| [radamsa](https://github.com/aoh/radamsa)                                      | [sqlmap](https://github.com/sqlmapproject/sqlmap)
|[googleindexretriever](https://www.elevenpaths.com/es/labstools/googleindexretriever-2/index.html)|[w3af](https://github.com/andresriancho/w3af)           | [themole](https://github.com/tiankonguse/themole)
|[instagram-py](https://github.com/deathsec/instagram-py)|  [wapiti](https://wapiti.sourceforge.io/)                                                        | [whitewidow](https://github.com/WhitewidowScanner/whitewidow/blob/master/whitewidow.rb)
|[ipscan](https://github.com/angryip/ipscan)|               [weevely3](https://github.com/epinna/weevely3)                                                  
|[ldapdomaindump](https://github.com/dirkjanm/ldapdomaindump)| [wfuzz](https://github.com/xmendez/wfuzz)
|[Maltego Community](https://www.maltego.com/maltego-community/)| [WhatWeb](https://github.com/urbanadventurer/WhatWeb)
|[NetfoxDetective](https://github.com/nesfit/NetfoxDetective)| [OWASP-Xenotix-XSS-Exploit-Framework](https://github.com/ajinabraham/OWASP-Xenotix-XSS-Exploit-Framework)
|[NetworkMiner](https://www.netresec.com/?page=NetworkMiner)|[XSStrike](https://github.com/s0md3v/XSStrike)
|[Nmap](https://nmap.org/)| [zaproxy](https://github.com/zaproxy/zaproxy)
|[PhEmail](https://github.com/Dionach/PhEmail)| []()
|[PhoneInfoga](https://github.com/sundowndev/PhoneInfoga)|
|[Public Intelligence Tool](https://sourceforge.net/projects/publicintelligencetool/)|
|[pwnedOrNot](https://github.com/thewhiteh4t/pwnedOrNot)|
|[Ultimate-Facebook-Scraper](https://github.com/harismuneer/Ultimate-Facebook-Scraper)|
|[sherlock](https://github.com/sherlock-project/sherlock)|
|[smbmap](https://github.com/ShawnDEvans/smbmap)|
|[smtp_diag_tool](https://www.adminkit.net/smtp_diag_tool.aspx)|
|[snmp-scanner](https://sourceforge.net/projects/snmp-scanner/)|
|[spiderfoot](https://www.spiderfoot.net/documentation/)|
|[tacyt-maltego-transforms](https://github.com/ElevenPaths/tacyt-maltego-transforms)|
|[theHarvester](https://github.com/laramies/theHarvester)|
|[wesng](https://github.com/bitsadmin/wesng)|
|[zenmap](https://nmap.org/zenmap/)|

| 4 - Analisis de Vulnerabilidades | 5 - Anonimato | 6 - Ataques de Contraseña |
|--------------------------------|----------------------------------|---------------------------------|
|[RED_HAWK](https://github.com/Tuhinshubhra/RED_HAWK)   |[demonsaw](https://www.demonsaw.com/)                              | [john-jumbo](https://www.openwall.com/john/) |
|[Nessus](https://docs.tenable.com/Nessus.htm)          |[onionshare](https://blog.torproject.org/new-release-onionshare-2) | [ncrack](https://nmap.org/ncrack/) |
|[Nikto2](https://cirt.net/Nikto2)                      |[proxytunnel](https://proxytunnel.sourceforge.io/)                 | [pack](https://github.com/iphelix/pack) |
|[vega](https://subgraph.com/vega/)                     |[tor-network-anon](https://trac.torproject.org/projects/tor/wiki)  | [Responder](https://github.com/lgandx/Responder-Windows) |
|[Vulnerator](https://github.com/Vulnerator/Vulnerator) |[torchat](https://github.com/prof7bit/TorChat)                     | [brutescrape](https://github.com/cheetz/brutescrape) |
| []() | []() | [hashcat](https://hashcat.net/hashcat/) |
| []() | []() | [johnny](https://openwall.info/wiki/john/johnny) |
| []() | []() | [ophcrack](https://ophcrack.sourceforge.io/) |
| []() | []() | [patator](https://github.com/lanjelot/patator) |
| []() | []() | [pwdump](https://www.openwall.com/passwords/windows-pwdump) |
| []() | []() | [rainbowcrack](https://project-rainbowcrack.com/) |
| []() | []() | [thc-hydra](https://github.com/maaaaz/thc-hydra-windows/) |
| []() | []() | [Crunch](https://github.com/shadwork/Windows-Crunch/) |
| []() | []() | [cupp](https://github.com/Mebus/cupp) |

| 7 - Criptografia y Hashing | 8 - Explotacion de Vulnerabilidades| 9 - MITM - Envenenamiento |
|--------------------------------|----------------------------------|---------------------------------|
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |

| 10 - Networking | 11 - Diccionarios | 12 - RAT| 
|--------------------------------|----------------------------------|---------------------------------|
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |


## Wiki 📖
Aún no disponible 


## Autor ✒️

* **Victor M. Gil** - *Trabajo Inicial* - (victorgilasp@gmail.com)


## Licencia 📄

Este proyecto está bajo la Licencia (GNU) - mira el archivo [LICENSE](LICENSE) para detalles

