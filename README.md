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

*El sistema se reiniciará varias veces y se instalarán todos los parches disponibles
 
Una vez realizado el paso anterior ejecutar el siguiente código en una consola de Powershell como adminstrador:


```powershell
. {iwr -useb https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/menu.ps1} | iex ;menu -Force
```

#### ERRORES

El script está aún en desarrollo y aunque la mayoría de errores no interrumpen la instalación hay casos en que si lo hacen, así mismo reiniciando la máquina y volviendo a lanzar la instalación estos errores son resueltos.

Aunque de forma mínima algunas aplicaciones no se estan instalando correctamente, se está trabajando para solventar estos problemas.

### Punto de restauración 🛠️

Al comenzar la instalación se crea un checkpoint que sirve para volver a un punto anterior el sistema en caso de que algo vaya mal o que queramos prescindir del entorno.


## Herramientas disponibles ⚙️

De momento solo estas disponibles las herramentas orientas a pentesting, próximamente se agregarán herramientas para auditorias WiFi y Reversing/Análisis de Malware.

### Informar de errores y sugerencias

Dado que este proyecto se encuentra en una fase muy temprana se agredece el reporte de errores y sugerencias al correo victorgilasp@gmail.com 


### Pentest Tools (aún en pruebas -  no definitivas)

| 1 - Recopilación de Información | 2 - Analisis de Aplicaciones Web | 3 - Analisis de Bases de Datos |
|--------------------------------|---------------------------------------|-----------------------------------|                                 
|[adaudit](https://github.com/phillips321/adaudit)                          | [CMSeeK](https://github.com/Tuhinshubhra/CMSeeK)                                          | [Damn Small SQLi Scanner](https://github.com/stamparm/DSSS)|
|[aquatone](https://github.com/michenriksen/aquatone)                       | [dirbuster](https://sourceforge.net/projects/dirbuster/)                                  | [whitewidow](https://github.com/WhitewidowScanner/whitewidow/blob/master/whitewidow.rb)
|[Asnlookup](https://github.com/yassineaboukir/Asnlookup)                   | [droopescan](https://github.com/droope/droopescan)                                        | [jsql-injection](https://github.com/ron190/jsql-injection)
|[CCrawlDNS](https://github.com/lgandx/CCrawlDNS)                           | [havij](https://www.darknet.org.uk/2010/09/havij-advanced-automated-sql-injection-tool/)  | [NoSQLMap](https://github.com/codingo/NoSQLMap)
|[enum4linux](https://github.com/CiscoCXSecurity/enum4linux)                | [joomscan](https://github.com/rezasp/joomscan)                                            | [padding-oracle-attacker](https://github.com/KishanBagaria/padding-oracle-attacker)
|[fierce](https://github.com/mschwager/fierce)                              | [mutiny-fuzzer](https://github.com/Cisco-Talos/mutiny-fuzzer)                             | [quicksql](https://github.com/trustedsec/quicksql)
|[FOCA](https://github.com/ElevenPaths/FOCA)                                | [N-Stalker X - Free Edition](https://www.nstalker.com/products/editions/free/)            | [safe3si](https://sourceforge.net/projects/safe3si/)
|[gmtcheck](https://www.elevenpaths.com/es/labstools/gmtchecksp/index.html) | [radamsa](https://github.com/aoh/radamsa)                                                 | [sqlmap](https://github.com/sqlmapproject/sqlmap)
|[googleindexretriever](https://www.elevenpaths.com/es/labstools/googleindexretriever-2/index.html) |[w3af](https://github.com/andresriancho/w3af)                      | [themole](https://github.com/tiankonguse/themole)
|[instagram-py](https://github.com/deathsec/instagram-py)                   | [wapiti](https://wapiti.sourceforge.io/)                                                  
|[ipscan](https://github.com/angryip/ipscan)                                | [weevely3](https://github.com/epinna/weevely3)                                                  
|[ldapdomaindump](https://github.com/dirkjanm/ldapdomaindump)               | [wfuzz](https://github.com/xmendez/wfuzz)
|[Maltego Community](https://www.maltego.com/maltego-community/)            | [WhatWeb](https://github.com/urbanadventurer/WhatWeb)
|[NetfoxDetective](https://github.com/nesfit/NetfoxDetective)               | [OWASP-Xenotix-XSS-Exploit-Framework](https://github.com/ajinabraham/OWASP-Xenotix-XSS-Exploit-Framework)
|[NetworkMiner](https://www.netresec.com/?page=NetworkMiner)                | [XSStrike](https://github.com/s0md3v/XSStrike)
|[Nmap](https://nmap.org/)                                                  | [zaproxy](https://github.com/zaproxy/zaproxy)
|[PhEmail](https://github.com/Dionach/PhEmail)                              | [explo](https://github.com/dtag-dev-sec/explo)
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

| 4 - Analisis de Vulnerabilidades | 5 - Anonimato         | 6 - Ataques de Contraseña  |
|--------------------------------|----------------------------------|---------------------------------|
|[RED_HAWK](https://github.com/Tuhinshubhra/RED_HAWK)   |[demonsaw](https://www.demonsaw.com/)                              | [john-jumbo](https://www.openwall.com/john/) |
|[Nessus](https://docs.tenable.com/Nessus.htm)          |[onionshare](https://blog.torproject.org/new-release-onionshare-2) | [ncrack](https://nmap.org/ncrack/) |
|[Nikto2](https://cirt.net/Nikto2)                      |[proxytunnel](https://proxytunnel.sourceforge.io/)                 | [pack](https://github.com/iphelix/pack) |
|[Vega](https://subgraph.com/vega/)                     |[tor-network-anon](https://trac.torproject.org/projects/tor/wiki)  | [Responder](https://github.com/lgandx/Responder-Windows) |
|[Vulnerator](https://github.com/Vulnerator/Vulnerator) |[torchat](https://github.com/prof7bit/TorChat)                     | [brutescrape](https://github.com/cheetz/brutescrape) |
| []() | []()                                                                                                               | [hashcat](https://hashcat.net/hashcat/) |
| []() | []()                                                                                                               | [johnny](https://openwall.info/wiki/john/johnny) |
| []() | []()                                                                                                               | [ophcrack](https://ophcrack.sourceforge.io/) |
| []() | []()                                                                                                               | [patator](https://github.com/lanjelot/patator) |
| []() | []()                                                                                                               | [pwdump](https://www.openwall.com/passwords/windows-pwdump) |
| []() | []()                                                                                                               | [rainbowcrack](https://project-rainbowcrack.com/) |
| []() | []()                                                                                                               | [thc-hydra](https://github.com/maaaaz/thc-hydra-windows/) |
| []() | []()                                                                                                               | [Crunch](https://github.com/shadwork/Windows-Crunch/) |
| []() | []()                                                                                                               | [cupp](https://github.com/Mebus/cupp) |

| 7 - Criptografia y Hashing    | 8 - Explotacion de Vulnerabilidades  | 9 - MITM - Envenenamiento  |
|--------------------------------|---------------------------------------|---------------------------------|
| [Hash Suite](https://hashsuite.openwall.net/)                       | [Commix](https://github.com/commixproject/commix)                           | [Ettercap-ng](https://sourceforge.net/projects/ettercap/files/unofficial%20binaries/windows/) |
| [Hash Identifier](https://sourceforge.net/projects/hashidentifier/) | [CrackMapExecWin](https://github.com/maaaaz/CrackMapExecWin)                | [evil-foca](https://www.elevenpaths.com/es/labstools/evil-focasp/index.html) |
| [HashTools](https://www.binaryfortress.com/HashTools/ChangeLog/)    | [mimikatz](https://github.com/gentilkiwi/mimikatz/)                         | [mitmproxy](https://docs.mitmproxy.org/stable/overview-tools/) |
| []()                                                                | [PowerMemory](https://github.com/giMini/PowerMemory)                        | [arpspoof](https://github.com/alandau/arpspoof) |
| []()                                                                | [PrivExchange](https://github.com/dirkjanm/PrivExchange)                    | [dnschef](https://github.com/iphelix/dnschef) |
| []()                                                                | [SessionGopher](https://github.com/Arvanaghi/SessionGopher)                 | [tmac](https://technitium.com/tmac/) |
| []()                                                                | [DAVOSET (DoS)](https://github.com/MustLive/DAVOSET)                        | []() |
| []()                                                                | [LOIC (DoS)](https://github.com/NewEraCracker/LOIC)                         | []() |
| []()                                                                | [evil-winrm](https://github.com/Hackplayers/evil-winrm)                     | []() |
| []()                                                                | [impacket](https://github.com/SecureAuthCorp/impacket)                      | []() |
| []()                                                                | [metasploit-framework](https://github.com/rapid7/metasploit-framework)      | []() |
| []()                                                                | [nishang](https://github.com/samratashok/nishang)                           | []() |
| []()                                                                | [p0wnedShell](https://github.com/Cn33liz/p0wnedShell)                       | []() |
| []()                                                                | [PowerSploit](https://github.com/PowerShellMafia/PowerSploit)               | []() |
| []()                                                                | [SysWhispers](https://github.com/jthuraisamy/SysWhispers)                   | []() |
| []()                                                                | [uacamola](https://github.com/ElevenPaths/uac-a-mola/tree/master/uacamola)  | []() |
| []()                                                                | [AutoBlue-MS17-010 (exploit)](https://github.com/3ndG4me/AutoBlue-MS17-010) | []() |
| []()                                                                | [MS17-010 (exploit)](https://github.com/worawit/MS17-010)                   | []() |
| []()                                                                | []()                                                                        | []() |
| []()                                                                | []()                                                                        | []() |


| 10 - Networking - | 11 - Diccionarios - | 12 - RAT - | 
|--------------------------------|----------------------------------|---------------------------------|
| [netcat](https://crysol.org/recipe/2005-10-10/netcat-la-navaja-suiza-de-tcp-ip.html#.X0qrOO9xfyY) | [fuzdb](https://github.com/fuzzdb-project/)           | [DarkComet](https://github.com/zxo2004/DarkComet-RAT-5.3.1) |
| [socat](https://sourceforge.net/projects/unix-utils/files/socat/1.7.3.2/)                         | [SecList](https://github.com/danielmiessler/SecLists) | [NjRat](https://github.com/AliBawazeEer/RAT-NjRat-0.7d-modded-source-code) |
| [tcping](https://www.elifulkerson.com/projects/tcping.php)                                        | []() | []() |
| [tcprelay](https://tcpreplay.appneta.com/)                                                        | []() | []() |
| [tcptrace](http://www.tcptrace.org/)                                                              | []() | []() |
| [tcptunnel](http://www.vakuumverpackt.de/tcptunnel/)                                              | []() | []() |
| [tcpview](https://docs.microsoft.com/en-us/sysinternals/downloads/tcpview)                        | []() | []() |
| [Wireshark](https://www.wireshark.org/)                                                           | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
| []() | []() | []() |
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

