Run, "c:\users\vagrant\desktop\metasploitframework-latest.msi"
WinWait, Metasploit-framework v5.0.98 Setup, 
IfWinNotActive, Metasploit-framework v5.0.98 Setup, , WinActivate, Metasploit-framework v5.0.98 Setup, 
WinWaitActive, Metasploit-framework v5.0.98 Setup, 
Send, {ENTER} 
Send, {SPACE}
Send, {ENTER}
Send, {ENTER} 
Send, {ENTER} 
WinWait, Metasploit-framework v5.0.98 Setup, Finish,
Send, {ENTER}
ExitApp