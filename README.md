# Relativity_Scripts

Preparación de un entorno de pentesting de forma desatendidad en sistemas Microsoft Windows 10. Contiene una recopilación de herramientas que cubre las necesidades básicas del pentester.

# Instalación

Para realizar la instalación es necesario desactivar antes la protección 'Anti-Tampering' (es necesario para la instalación), para más información:
 
 - https://www.tenforums.com/tutorials/123792-turn-off-tamper-protection-windows-defender-antivirus.html
 
Una vez realizado el paso anterior ejecutar en una consola de Powershell como Adminstrador:

. {iwr -useb https://raw.githubusercontent.com/Relativity-Environment/Relativity_Scripts/master/menu.ps1}|iex;menu

# Herramientas disponibles

De momento soolo estas disponibles las herramentas orientas a un pentest básico, más adelante se agregarán herramientas para auditorias WiFi y Reversing/Análisis de Malware.


# Punto de restauración

Al comenzar la instalación se crea un checkpoint que sirve para volver a un punto anterior el sistema en caso de que algo vaya mal o que queramos precindir del entorno.
