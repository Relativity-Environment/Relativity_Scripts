#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn   ; Enable warnings to assist with detecting common errors.
#WinActivateForce

SendMode Input
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 50

;Handle installation
title = Instalador - OWASP Zed Attack Proxy 2.9.0
Run, ZAP_2_9_0_windows.exe
WinWait, %title%,,5000
IfWinExist %title%
{
  WinActivate, %title%  

  Sleep, 500
  BlockInput On
  
  Sleep, 500
  SendInput, {enter}      

  Sleep, 500
  MouseClick, left,  288,  325             
  
  Sleep, 500
  SendInput, {tab}

  Sleep, 500
  SendInput, {tab}

  Sleep, 500
  SendInput, {enter}

  Sleep, 500
  SendInput, {tab}

  Sleep, 500
  SendInput, {tab}

  Sleep, 500
  SendInput, {tab}

  Sleep, 500
  SendInput, {enter}

  Sleep, 500
  SendInput, {tab}

  Sleep, 500
  SendInput, {tab}

  Sleep, 500
  SendInput, {tab}

  Sleep, 500
  SendInput, {enter}

  Sleep, 10000
  SendInput, {tab}
  
  Sleep, 100
  SendInput, {enter}
  
  BlockInput Off
}

Exit,