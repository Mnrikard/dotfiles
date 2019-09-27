SetTitleMatchMode, REGEX
SetTitleMatchMode, 2

;#InstallKeybdHook
;#InstallMouseHook

::uuu::UniqueIdentifier
::recieve::receive
::teh ::the 
::EqeustPlus::EquestPlus
::txiso::set transaction isolation level read uncommitted
::lable::label
::eqpcode::c:\repos\eqPlusClientServices\EquestPlusWS\EquestPlusWSInternal\EquestPlusWS.asmx.vb
::db3suplink::[proddb3sup\proddb3sup]


;#IfWinActive ahk_exe firefox.exe
;	; so FireFox say "tab" means move to the next item... but I want it to send the tab char
;	Tab::
;		ClipboardSaved := ClipboardAll  ; Backup clipboard contents.
;		Clipboard := "	"  ; Tab character (you can also use `t).
;		Send ^v
;		Clipboard := ClipboardSaved  ; Restore.
;		ClipboardSaved =  ; Free the memory.
;	return
;#IfWinActive

; ^ = ctrl
; + = shift
; ! = Alt
; # = super
; & = key glue
; http://ahkscript.org/docs/Hotkeys.htm

; caps lock, more like craps lock, amiright?
CapsLock::
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
		GetKeyState, T, XButton1
		If T=U
			Break
	}
Return

XButton2::
	loop {
		MouseClick,WheelLeft,,,10,0,D,R
		GetKeyState, T, XButton2
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
	;^n::
	;	Run, open "c:\SQL\TopTen\new.sql"
	;	return
	^n::
		RunWait, powershell.exe -NoLogo -NoProfile -File c:\repos\dotfiles\newsql.ps1
		;Send {Down}{Down}
		;Send {ShiftDown}{End}{ShiftUp}
		return
	^+n::
		Run powershell.exe -NoLogo -NoProfile -File c:\repos\recovery\scripts\newsql.ps1
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
#IfWinActive, ahk_exe dsNetworkConnect.exe
	Tab::
		Send {Tab}
		return
#IfWinActive

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

#IfWinActive ahk_exe Radmin.exe
	AppsKey::
		Send {AppsKey}
		return
#IfWinActive

; Cherwell sucks a lot too.
#IfWinActive ahk_exe Trebuchet.App.exe
	; For example, Alt+F4 takes you to the home screen THE HOME SCREEN! who does this?
	!f4::
		Send {AltDown}{Space}{AltUp}c
		return
	; There's an actual button on my keyboard with the word HOME on it! Why not make that take me to the home screen?!
	; answer: because I keep hitting it while inside of a text box, and it doesn't do what I need it to in that scenario
	^home::
		Send !v n h
		return
#IfWinActive



; Hey, I can vim keybind my mouse! cool
; Mouse move in direction h
;^+h::
;	loop {
;		MouseMove, -20, 0, 2, R
;		GetKeyState, T, h
;		If T=U
;			Break
;	}
;Return

; Mouse move in direction l
;^+l::
;	loop {
;		MouseMove, 20, 0, 2, R
;		GetKeyState, T, h
;		If T=U
;			Break
;	}
;Return

; Mouse move in direction j
;^+j::
;	loop {
;		MouseMove, 0, 20, 2, R
;		GetKeyState, T, h
;		If T=U
;			Break
;	}
;Return

; Mouse move in direction k
;^+k::
;	loop {
;		MouseMove, 0, -20, 2, R
;		GetKeyState, T, h
;		If T=U
;			Break
;	}
;Return

; Move window up
;+#Up::
;  WinGetPos,X,Y,W,H,A,,,
;  WinMaximize
;  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
;
;  ; if this is greater than 1, we're on the secondary (right) monitor. This means the center of the active window is a positive X coordinate
;  if ( X + W/2 > 0 ) {
;	  SysGet, MonitorWorkArea, MonitorWorkArea, 1
;	  WinMove,A,,X,0 , , (MonitorWorkAreaBottom/2)
;  }
;  else {
;	  SysGet, MonitorWorkArea, MonitorWorkArea, 2
;	  WinMove,A,,X,0 , , (MonitorWorkAreaBottom/2)
;  }  
;return
;
;; Move window down
;+#Down::
;  WinGetPos,X,Y,W,H,A,,,
;  WinMaximize
;  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
;
;  ; if this is greater than 1, we're on the secondary (right) monitor. This means the center of the active window is a positive X coordinate
;  if ( X + W/2 > 0 ) {
;	  SysGet, MonitorWorkArea, MonitorWorkArea, 1
;	  WinMove,A,,X,MonitorWorkAreaBottom/2 , , (MonitorWorkAreaBottom/2)
;  }
;  else {
;	  SysGet, MonitorWorkArea, MonitorWorkArea, 2
;	  WinMove,A,,X,MonitorWorkAreaBottom/2 , , (MonitorWorkAreaBottom/2)
;  }
;return
