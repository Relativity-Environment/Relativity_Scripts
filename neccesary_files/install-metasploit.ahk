#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn   ; Enable warnings to assist with detecting common errors.
#WinActivateForce

SendMode Input
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 50

Run, "metasploitframework-latest.msi"
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