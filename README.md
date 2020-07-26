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

#### Recopilación de Información                                           

* [asnlookup](https://github.com/yassineaboukir/Asnlookup)


 #### Análisis de Aplicaciones Web


## Wiki 📖
Aún no disponible 


## Autor ✒️

* **Victor M. Gil** - *Trabajo Inicial* - (victorgilasp@gmail.com)


## Licencia 📄

Este proyecto está bajo la Licencia (GNU) - mira el archivo [LICENSE](LICENSE) para detalles

