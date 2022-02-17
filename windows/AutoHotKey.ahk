SetTitleMatchMode, REGEX
SetTitleMatchMode, 2

;#InstallKeybdHook
;#InstallMouseHook

::uuu::UniqueIdentifier
::recieve::receive
::teh ::the 
::txiso::set transaction isolation level read uncommitted
::lable::label
::vim fzf::vim $(fzf)
::(TM)::™
::(R)::®
::(C)::©
::``e::é
::udpate::update
::rmslinux::I'd just like to interject for a moment. What you're refering to as Linux, is in fact, GNU/Linux, or as I've recently taken to calling it, GNU plus Linux. Linux is not an operating system unto itself, but rather another free component of a fully functioning GNU system made useful by the GNU corelibs, shell utilities and vital system components comprising a full OS as defined by POSIX.

; ^ = ctrl
; + = shift
; ! = Alt
; # = super
; & = key glue
; http://ahkscript.org/docs/Hotkeys.htm

; run FTS index
#IfWinActive Realm Service Jobs - Support - Google Chrome
	^m::
		Send {Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Tab}
		Send FTS Sync{Tab}{Tab}
		Send FTS Sync{Tab}{Tab}{Tab}{Tab}{Tab}

		ControlClick Add Parameter, Realm Service Jobs - Support - Google Chrome
		Send {ShiftDown}{Tab}{Tab}{ShiftUp}
		Send siteId{Tab}
		Send {CtrlDown}v{CtrlUp}{Tab}
		Sleep 2000

		ControlClick Add Parameter, Realm Service Jobs - Support - Google Chrome
		Send {ShiftDown}{Tab}{Tab}{ShiftUp}
		Send refreshAll{Tab}
		Send true{Tab}
		Sleep 2000

#IfWinActive


; caps lock, more like craps lock, amiright?
CapsLock::
    Send #{Tab}
	Return

; open help page CTrl+alt+shift+H
^+!H::
	Run, http://ahkscript.org/docs/Hotkeys.htm
Return

; my mouse has these cool but useless buttons on them. Why not scroll left and right with it?
;remap forward/back buttons on mouse
XButton1::
	loop {
		MouseClick,WheelRight,,,10,0,D,R
		GetKeyState, T, XButton2
		If T=U
			Break
	}
Return

XButton2::
	loop {
		MouseClick,WheelLeft,,,10,0,D,R
		GetKeyState, T, XButton1
		If T=U
			Break
	}
Return

FindWindow(){
	InputBox, winName, "Find which window",,,300,100

	WinGet Window, List

	Loop %Window%
	{
		Id := Window%A_Index%
		WinGetTitle, title, % "ahk_id " Id

		if InStr(title, winName, 0) {
			WinActivate, % "ahk_id " Id
			return
		}

		WinGetClass, classs, % "ahk_id " Id
		if InStr(classs, winName, 0) {
			WinActivate, % "ahk_id " Id
			return
		}
	}
}
^!Tab::
	FindWindow()
Return

global CurrentMousePosX := 0, CurrentMousePosY := 0

ClearMouse(){
	SysGet, X, 78
	SysGet, Y, 79
	Y := Y-50
	MouseMove, %X%, %Y%
	return
}

; Ctrl+Shift+M =>move the mouse to the edge of the current screen (out of the way)
^+M::
	ClearMouse()
Return

; Ctrl+Shift+*I =>move the mouse to the cursor
^+I::
	MouseMove, A_CaretX, A_CaretY, 0
Return

; Middle mouse button is annoying, kill it
MButton::

return

; Ctrl+Space makes that window Always on top
;^SPACE::  Winset, Alwaysontop, toggle , A

;; My keyboard doesn't have a right windows key, so Ctrl+AppsKey does it
;^AppsKey::
;	SendInput, {Ctrl up}{AppsKey up}{RWin}
;Return

; My keyboard doesn't have a right windows key, so AppsKey+r is Winkey+R (run box)
;AppsKey & r::
;	WinActivate, Program Manager
;	Send, #r
;Return

;AppsKey & d::
;	Send #d
;Return

; SQL Server: I have the bad habit of opening a thousand files over time and never closing them, this is to correct MY bad behavior, not SSMS's
#IfWinActive ahk_exe Ssms.exe
	^n::
		RunWait, powershell.exe -NoLogo -NoProfile -File c:\gitrepos\dotfiles\newsql.ps1
		;Send {Down}{Down}
		;Send {ShiftDown}{End}{ShiftUp}
		return
	^+n::
		Run powershell.exe -NoLogo -NoProfile -File c:\gitrepos\dotfiles\newsql.ps1
		Send {Down}{Down}{Down}{Down}
		Send {F5}
		Send {CtrlDown}r{CtrlUp}
		return

	; When I switch connections, my mouse is in the way and the wrong dialog box opens, so move the mouse first
	AppsKey::
		ClearMouse()
		Send {AppsKey}
		return
#IfWinActive

#IfWinActive ahk_exe SoapUI-5.5.0.exe
	; F5 in SoapUI is a command to "destroy everything without a backup", so let's not do that.
	F5::
		Send {AltDown}{Enter}{AltUp}
		return
#IfWinActive

#IfWinActive ahk_class ConsoleWindowClass
	^+v::
		Send {RightMouseButton}
		return
#IfWinActive

; BEST EVER!! Tab inside of a run-box or open file dialog does what a tab SHOULD do, moves to the next item in the list, not the next button/etc.
; So c:\Us{tab} takes me to c:\Users
#IfWinActive, ahk_class #32770
	Tab::
		Send {Down}
		return
	^Tab::
		Send {Tab}
		return
#IfWinActive

; Oh lync or skype for business, or whatever your name is: you suck a lot
#IfWinActive ahk_class LyncConversationWindowClass
	; Ctrl+Enter in Outlook sends the mail, but in skype it "calls" the person.
	; This just makes it send the message
	^Enter::
		Send {Enter}
		return
	; Esc closes the conversation, it should not do that, it should just remove any highlighting I have
	Esc::
		;MouseGetPos , origX , origY
		;CursorX = %A_CaretX%
		;CursorY = %A_CaretY%
		;MsgBox "x: %A_CaretX%, y: %CursorY%"
		;Click %CursorX%, %CursorY%-100
		;Click %CursorX%, %CursorY%
		;MouseMove, %origX%, %origY%
		return
	; Ctrl+F4 SHOULD close the conversation
	^F4::
		Send {Esc}
		return
	AppsKey::
		Send {AppsKey}
		return
#IfWinActive

#IfWinActive echelon@team-echelon
    ^w::
        Send {ctrlDown}e{ctrlup}
        return
    ^n::
        Send {ctrlDown}m{ctrlup}
        return
#IfWinActive

#IfWinActive localhost - Community Edition
    f5::
        Send {Esc}{Tab}{Enter}
        return
#IfWinActive
#IfWinActive Couchbase Console
    f5::
        Send {Esc}{Tab}{Enter}
        return
#IfWinActive


; VOLUME
#Warn,UseUnsetLocal
#NoEnv
#SingleInstance force
SetBatchLines,-1

SoundGet,Volume
Volume:=Round(Volume)
TrayTip:="CtrlAlt+UpArrow or CtrlAlt+DownArrow to adjust volume" . "Current Volume=" . Volume
TrayIconFile:=A_WinDir . "\System32\DDORes.dll" ; get tray icon from DDORes.dll
TrayIconNum:="-2032" ; use headphones as tray icon (icon 2032 in DDORes)
Menu,Tray,Tip,%TrayTip%
Menu,Tray,Icon,%TrayIconFile%,%TrayIconNum%
Return

^!Down::
SetTimer,SliderOff,3000
SoundSet,-1
Gosub,DisplaySlider
Return

^!Up::
SetTimer,SliderOff,3000
SoundSet,+1
Gosub,DisplaySlider
Return

SliderOff:
Progress,Off
Return

DisplaySlider:
SoundGet,Volume
Volume:=Round(Volume)
Progress,%Volume%,%Volume%,Volume,Adjust Volume
TrayTip:="CtrlAlt+LeftArrow or CtrlAlt+RightArrow to adjust volume" . "Current Volume=" . Volume
Menu,Tray,Tip,%TrayTip%
Return

DetectHiddenWindows, On
Script_Hwnd := WinExist("ahk_class AutoHotkey ahk_pid " DllCall("GetCurrentProcessId"))
DetectHiddenWindows, Off
; Register shell hook to detect flashing windows.
DllCall("RegisterShellHookWindow", "uint", Script_Hwnd)
OnMessage(DllCall("RegisterWindowMessage", "str", "SHELLHOOK"), "ShellEvent")
;...
ShellEvent(wParam, lParam) {
    if (wParam = 0x8006) ; HSHELL_FLASH
    {   ; lParam contains the ID of the window which flashed:
        WinActivate, ahk_id %lParam%
    }
}
