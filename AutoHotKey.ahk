
MsgBox 0, Running, AutoHotKey is now running, .7

person = 
choice =
BreakCount = 0
site = 
password = 
chgnum = 
ring = 
jira = 
application = 
test = 
programs =
description = 
appl =
ChangeNumber = 
InhouseTesting = 
Application = 
DevID = 
Downtime = 
ToggleBkgJobs = 
Comments = 
returnPaste = 

InputBox, password, Password, What's your password? , HIDE , 250,130 

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!P::
; Ctrl + Alt + P - Password

	Sleep, 250 
	Send, %password%
        Sleep, 1000 
        Send, {enter}

Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^+v::
; CTRL + SHIFT + V = Paste the clipboard without whitespace

returnPaste = %clipboard%

Send, %returnPaste%

return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^`::
; Ctrl + ` - Put in a line of ~

	Send, ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!M::
;Ctrl+Alt+M - moved a change

Gui, Add, Text,, Who are you sending this to?
Gui, Add, Edit, vperson,
Gui, Add, DropDownList, vchoice, Test|Live|Both
Gui,Add,Button,gOk wp,Ok
Gui, Show,,Moves
return

Ok:
Gui,Submit
	If (choice == "Test" or choice == "Live")
		{
		string = % Format("Hi {:T}, this change has been moved into {:U}. Thanks{!} Richie", person, choice)
		Send, %string%
		}
	Else
		{
		string = % Format("Hi {:T}, this change has been moved into both TEST and LIVE. Thanks{!} Richie", person)
		Send, %string%
		}
Gui, Destroy		
return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

!B::
;Alt + B - send a break with a number

Send, [@Break(%BreakCount%)]

BreakCount++

return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

!+B::
;Alt+Shift+B - reset the break counter

BreakCount = 0

return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!A::
;Ctrl+Alt+A - Open AA machine

Run C:\Program Files (x86)\MEDITECH\Workstation5.x\Client.mtad �0�AA�CS�MENU�0 ,, Max
Sleep, 750
Send, {enter}

return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!E::
;Ctrl+Alt+E - Open Expprog

Run "C:\Program Files (x86)\MEDITECH\MTAppDwn.exe" -meditech "C:\Program Files (x86)\MEDITECH\CUS61.Universe\EXPPROG.Ring\Client.mtad"

return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!S::
;Ctrl+Alt+S - M-AT Signon
;Asks for site and brings that up

InputBox, site, Site, What Site? , , 150,130 

If site
	{
	Run "C:\Program Files (x86)\MEDITECH\MTAppDwn.exe" -run:"M-AT Signon" "C:\Program Files (x86)\MEDITECH\M-AT Tools\client.mtad"
	Sleep, 2500
	Send, %site%
	Sleep, 500
	Send, {enter}
	}
Else If ErrorLevel
	Run "C:\Program Files (x86)\MEDITECH\MTAppDwn.exe" -run:"M-AT Signon" "C:\Program Files (x86)\MEDITECH\M-AT Tools\client.mtad"

return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;                                                                                        ;
; [Ctrl]+[F2] 				Toggle borderless fullscreen			 ;
;                                                                                        ;
;    AutoHotkey scripts can not be used on a remote client when the remote desktop is    ;
; fullscreen. This command will allow us to have a fullscreen window while being able    ;
; to use AutoHotkey commands                                                             ;
;                                                                                        ;
; Author: Klaus2                                                                         ;
; Created: 03 September 2014 - 12:40 PM                                                  ;
; Source: https://autohotkey.com/board/topic/114598-borderless-windowed-mode-forced-fullscreen-script-toggle/
;                                                                                        ;
; Known issues:                                                                          ;
;                                                                                        ;
; - Weird results for windows with custom decorations such as                            ;
;      Chrome, or programs with a Ribbon interface.                                      ;
;                                                                                        ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;

#SingleInstance force

ToggleFakeFullscreen(){
	CoordMode Screen, Window
	static WINDOW_STYLE_UNDECORATED := -0xC40000
	static savedInfo := Object() ;; Associative array!
	WinGet, id, ID, A
	if (savedInfo[id]){
		inf := savedInfo[id]
		WinSet, Style, % inf["style"], ahk_id %id%
		WinMove, ahk_id %id%,, % inf["x"], % inf["y"], % inf["width"], % inf["height"]
		savedInfo[id] := ""
	}else{
		savedInfo[id] := inf := Object()
		WinGet, ltmp, Style, A
		inf["style"] := ltmp
		WinGetPos, ltmpX, ltmpY, ltmpWidth, ltmpHeight, ahk_id %id%
		inf["x"] := ltmpX
		inf["y"] := ltmpY
		inf["width"] := ltmpWidth
		inf["height"] := ltmpHeight
		WinSet, Style, %WINDOW_STYLE_UNDECORATED%, ahk_id %id%
		mon := GetMonitorActiveWindow()
		SysGet, mon, Monitor, %mon%
		WinMove, A,, %monLeft%, %monTop%, % monRight-monLeft, % monBottom-monTop
	}
}

GetMonitorAtPos(x,y){
	;; Monitor number at position x,y or -1 if x,y outside monitors.
	SysGet monitorCount, MonitorCount
	i := 0
	while(i < monitorCount)	{
		SysGet area, Monitor, %i%
		if ( areaLeft <= x && x <= areaRight && areaTop <= y && y <= areaBottom ){
			return i
		}
		i := i+1
	}
	return -1
}

GetMonitorActiveWindow(){
	;; Get Monitor number at the center position of the Active window.
	WinGetPos x,y,width,height, A
	return GetMonitorAtPos(x+width/2, y+height/2)
}

^F2::ToggleFakeFullscreen()

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!J::
;Ctrl+Alt+J - Takes the clipboard, makes a jira link out of it, and sends it back

xJira = %clipboard%
Send, https://jira.meditech.com/browse/%xJira%
Sleep, 500
Send, {enter}

return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^+Z::
;Ctrl+Shift+Z - Mouse click on remote client and enter password

;MouseClick, Left, 510, 400
;Sleep, 500
;MouseClick, Left, 510, 500
;Sleep, 5000
MouseClick, Left, 960, 705
Sleep, 1000
MouseClick, Left, 250, 125
Sleep, 2500
Send, %password%

Send, {Enter}

Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!T::
;Ctrl+Alt+T - Takes the Clipboard, and makes a Task Link

Send, https://cswebtools.meditech.com/tasks/view?taskID=%clipboard%
Sleep, 500
Send, {enter}

return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
;====================THIS ONE IS RETIRED ========================
;Ctrl+Alt+T - Takes the clipboard, opens task in AB to connect

;Run C:\Program Files (x86)\MEDITECH\Workstation5.x\Client.mtad �0�AB�CS�MENU�0 ,, Max
;Sleep, 1500
;Send, {enter}
;Sleep, 3000
;Send, {enter}
;Send, %clipboard%
;Sleep, 500
;Send, {enter}

return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^+M::
;Ctrl+Shift+M - Mouse click on remote client and enter password

;MouseClick, Left, 70, 430
;Sleep, 750
;MouseClick, Left, 295, 350
;Sleep, 750
;MouseClick, Left, 475, 385
;Sleep, 750
;MouseClick, Left, 650, 335
;Sleep, 750
;MouseClick, Left, 750, 275

;WinWait, Connect to Customer - core
;WinGetText, test, "Remote Support Client"
;ControlGetText, test,,Connect to

;MsgBox, The text is:`n%test%

Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!C::
; Ctrl + Alt + C - Create a new change number

LookFor := "."

Gui, Add, Text,, What is the application?
Gui, Add, Edit, vappl Limit3
Gui, Add, Text,, What is the task number?
Gui, Add, Edit, vtask Limit8
Gui, Add, Text,, What is the description?
Gui, Add, Edit, vdescription Limit42
Gui, Add, Text,, What are the programs?
Gui, Add, Edit, R10 vprograms w500
Gui, Add, Button, gOkay wp,Okay
Gui, Show,,Create Change Number
Return

Okay:
Gui,Submit
	Sleep, 1000
	Send, %appl%
	Send, {enter}
	Sleep, 850
	MouseClick, Left, 825, 330
	Sleep, 1000
	Send, {enter}
	Send, %task%
	Sleep, 850
	Send, {enter}
	Sleep, 850
	Send, {enter}
	Send, N
	Send, {enter}
	Sleep, 850
	Send, N
	Send, {enter}
	Sleep, 850
	Send, C
	Send, {enter}
	Sleep, 850
	Send, {enter}
	Sleep, 850
	Send, Task {#} %task% - %description%
	Sleep, 850
	Send, {enter}
	Sleep, 350
	Send, {enter}
	
	Loop, Parse, programs, `n
	{
 		StringGetPos, pos, A_LoopField, %LookFor%
    		StringLeft, Left, A_LoopField, pos
    		StringTrimLeft, Right, A_LoopField, pos+1
    		if (pos > 0)
    		{
    			Send, %Left%
    			Send, {enter}
			Sleep, 850
    			Send, %Right%
    			Send, {enter}
    			Sleep, 850
    			Send, N
    			Send, {enter}
    			Sleep, 350
    		}
	}
	
Gui, Destroy	
Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

;Ctrl+Space AlwaysOnTop

^SPACE::  Winset, Alwaysontop, , A

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

!Up::Send {PgUp}
Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

!Down::Send {PgDn}
Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

#If (WinActive("ahk_class MRW") || WinActive("ahk_class MRWF")) && WinActive("ahk_exe T.exe")

	WheelDown::
		SendInput, {Down}
	return

	WheelUp::
		SendInput, {Up}
	Return

	^C::
		Send, {Alt Down}c{Alt Up}
	Return

	^V::
		Send, {Alt Down}v{Alt Up}
	Return

	; Alt+P - insert programming notes for inhouse text

	!P::
	   Send, programming notes
	   ================================================================================{enter}{enter}
	   Send, ACCT:{enter}{enter}
	   Send, ISSUE:{enter}{enter}
	   Send, RESOLUTION:{enter}{enter}
	   Send, ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{enter}{enter}{enter}
	   Send, ================================================================================
	Return

	;$LButton::RButton

#If

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

![::Send,{Home}
Return

!]::Send,{End}
Return

^![::Send,{Ctrl Down}{Home}{Ctrl Up}
Return

^!]::Send,{Ctrl Down}{End}{Ctrl Up}
Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^+K::
;Ctrl+Shift+K - KML.PROG.INFO Canned Text

Gui, Add, Text,, What is the application?
Gui, Add, Edit, vApplication, BAR

Gui, Add, Text,, What is the Dev ID?
Gui, Add, Edit, vDevID

Gui, Add, Text,, What is the change number?
Gui, Add, Edit, vChangeNumber

Gui, Add, Text,, Inhouse Testing Required?
Gui, Add, DropDownList, vInhouseTesting, No||Yes

Gui, Add, Text,, Downtime?
Gui, Add, DropDownList, vDowntime, No||Yes

Gui, Add, Text,, Toggle Background Jobs?
Gui, Add, DropDownList, vToggleBkgJobs, No||Yes

Gui, Add, Text,, Comments:
Gui, Add, Edit, vComments, No additional steps

Gui,Add,Button,gReturnKmlProgInfoCannedText wp,Ok
Gui, Show,,KML.PROG.INFO Canned Text
return

ReturnKmlProgInfoCannedText:
Gui,Submit
Send, APPL / DEV-ID              Change Number            In-House Testing Required?{enter}
Send, -------------              -------------            --------------------------{enter}
Send, %Application% / %DevID%           %ChangeNumber%        %InhouseTesting%{enter}{enter}
Send, ---------------------------{enter}
Send, Downtime: (time/routine) **| %Downtime%{enter}
Send, {space}    Toggle Background Job | %ToggleBkgJobs%{enter}
Send, Interacting Changes/Tasks  | None{enter}{enter}
Send, **Note for Web Changes no downtime is needed to move to TEST/LIVE, however users{enter}
Send, will need to close out of all web sessions to ensure they are using the updated{enter}
Send, code. The Return To menu/Close All option will accomplish this.**{enter}{enter}
Send, Comments: (CFS, reload/rebuild,etc){enter}
Send, -----------------------------------{enter}
Send, %comments%{enter}
  
Gui, Destroy
return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!l:: 
; Ctrl+Alt+L - Length of Highlighted 
; Save off old clipboard and empty it. 
saveClipboard := Clipboard 
Clipboard := "" 
Sleep, 250 
 
; Copy highlighted message to clipboard.  Count the characters and spaces. 
; 12345 6789 
Send, ^c 
ClipWait, 2 
Chars := StrLen(Clipboard) 
RegExReplace(Clipboard,A_Space,"",Spaces)

MsgBox,, Character Count, The highlighted text is %Chars% characters in length and contains %Spaces% spaces.
Sleep, 250

; Put old contents of clipboard back into clipboard
Clipboard := saveClipboard
return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////


