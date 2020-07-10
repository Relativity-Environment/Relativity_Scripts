Run, "c:\users\vagrant\desktop\ZAP_2_9_0_windows.exe"
WinWait, Instalador - OWASP Zed Attack Proxy 2.9.0, 
Send, {ENTER}
IfWinNotActive, Instalador - OWASP Zed Attack Proxy 2.9.0, , WinActivate, Instalador - OWASP Zed Attack Proxy 2.9.0, 
WinWaitActive, Instalador - OWASP Zed Attack Proxy 2.9.0, 
MouseClick, left,  288,  325
Sleep, 100
MouseClick, left,  115,  254
Sleep, 100
Send, {TAB}
Sleep, 100
Send, {TAB}
Sleep, 100
Send, {TAB}
Sleep, 100
Send, {ENTER}
Sleep, 100
Send, {TAB 3}
Sleep, 100
Send, {ENTER}
Sleep, 100
Send, {TAB 3}
Send, {ENTER}
Sleep, 10000
IfWinNotActive, Instalador - OWASP Zed Attack Proxy 2.9.0, , WinActivate, Instalador - OWASP Zed Attack Proxy 2.9.0, 
WinWaitActive, Instalador - OWASP Zed Attack Proxy 2.9.0, 
Send, {TAB 2}
Sleep, 100
Send, {ENTER}
ExitApp
