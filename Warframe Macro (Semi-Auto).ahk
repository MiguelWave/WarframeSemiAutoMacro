#SingleInstance, force

;================
;---Parameters---
;================
global abilityDelay := 45
global meleeSpamDelay := 45
global semiDelay := 45

global GarudaQuickSpamDelay := 450
global GarudaQuickSpamTimes := 13
; global chargeTime :=
; global chargeDelay :=

;====================
;---WF window info---
;====================
;Warframe
;ahk_class WarframePublicEvolutionGfxD3D11
;ahk_exe Warframe.x64.exe
;ahk_pid 11972

;=============
;---Toggles---
;=============
global abilitySpam := false
global GarudaQuickSpam := false
global meleeMode := "None"
global semiSpamToggle := false
global showGUI := true

;=========
;---GUI---
;=========
CustomColor := "AABBCC"
textR := 255
textG := 255
textB := 255
textColor .= Format("{:x}{:x}{:x}", textR, textG, textB)
; Regarding rainbow coloring of text: there are 2 options for looping, taking into account run time and complications: 1. Increase by 17, takes 15 cycles to go from 0 to 255, color will be smooth. 2. Increase by 17*3=51, takse 5 cycles, significantly less demanding in resources but the color will be jarry.
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui, Color, %CustomColor%
Gui, Font, s16, Fixedsys ;Alt fonts: Consolas, Courier, Courier New, *Fixedsys, Lucida Console, Script, Terminal
Gui, Add, Text, vGUIText c%textColor% Left w350 r4, Text
WinSet, TransColor, %CustomColor% 255
;SetTimer, UpdateOSD, 500 ; Updates everytime something is toggled instead.
Gosub, UpdateOSD
Gui, Show, x0 y900 NoActivate
return

UpdateOSD:
GuiControl,, GUIText, [Y] Ability spam - %abilitySpam%`n[U] Melee mode - %meleeMode%`n[I] Semi-Auto - %semiSpamToggle%`n[O] Garuda spam - %GarudaQuickSpam% ;`n`nAbility delay - %abilityDelay%`nMelee delay - %meleeSpamDelay%`nSemi delay - %semiDelay%
return

bringGameIntoFocus(){
	WinActivate ahk_exe Warframe.x64.exe
}

;====================
;---Script Control---
;====================
*F3::
	Suspend
	showGUI:=!showGUI
	if (showGUI){
		Gui, Show
		bringGameIntoFocus()
		return
	} else {
		Gui, Hide
		return
	}
return
*F4::ExitApp
*F5::Reload

;===============
;---Togglings---
;===============
~y::
	abilitySpam:=!abilitySpam
	Gosub, UpdateOSD

return
~u::
	if (meleeMode = "None"){
		meleeMode:= "Glaive"
	} else if (meleeMode = "Glaive"){
		meleeMode:= "Spam"
	} else meleeMode:="None"
	Gosub, UpdateOSD
return
~i::
	semiSpamToggle	:=	!semiSpamToggle
	Gosub, UpdateOSD
return
~o::
	GarudaQuickSpam := !GarudaQuickSpam
	Gosub, UpdateOSD
return
;============
;---Tuning---
;============
;b + <key> decreases parameter by 50ms, down to a min.
;m + <key> increases parameter by 50ms, up to a max.
;n + <key> resets parameter to its original value.
; Melee spam:
~b & u::
	if (meleeSpamDelay>50){
		meleeSpamDelay:=meleeSpamDelay-50
	}
	return
~m & u::
	if (meleeSpamDelay<1000){
		meleeSpamDelay:=meleeSpamDelay+50
	}
	return
~n & u:: meleeSpamDelay := 200

;==================
;---Ability spam---
;==================
; 1st
*1::
if (abilitySpam){
	while GetKeyState("1","P"){
	send, {1}
	sleep abilityDelay
	}
} else send {Blind}{1 DownR}
return
*1 Up:: send {Blind}{1 Up}
; 2nd
*2::
if (abilitySpam){
	while GetKeyState("2","P"){
	send, {2}
	sleep abilityDelay
	}
} else send {Blind}{2 DownR}
return
*2 Up:: send {Blind}{2 Up}
; 3nd
*3::
if (abilitySpam){
	while GetKeyState("3","P"){
	send, {3}
	sleep abilityDelay
	}
} else send {Blind}{3 DownR}
return
*3 Up:: send {Blind}{3 Up}
; 4th
*4::
if (abilitySpam){
	while GetKeyState("4","P"){
	send, {4}
	sleep abilityDelay
	}
} else send {Blind}{4 DownR}
return
*4 Up:: send {Blind}{4 Up}

;=====================================
;---Miscellaneous spams and scripts---
;=====================================
~XButton1::
if (meleeMode = "Spam"){
	while GetKeyState("XButton1","P"){
		send, {XButton1}
		sleep meleeSpamDelay
	}
} else if (meleeMode = "Glaive") {
	send, {MButton}
}
return

; For Garuda: hold mbutton2 to spam thermal and bloodlet
~XButton2::
if (GarudaQuickSpam)
	while GetKeyState("XButton2","P"){
		loop %GarudaQuickSpamTimes% {
		;if not (GetKeyState("XButton2")) return
		send, {2}
		sleep GarudaQuickSpamDelay
		}
		;if not (GetKeyState("XButton2")) return
		send, {3}
		sleep GarudaQuickSpamDelay
	}
return

; Spam semi-automatics
~LButton::
if (semiSpamToggle)
	while GetKeyState("LButton","P"){
		send, {LButton}
		sleep semiDelay
	}
return

*c::LButton
*z::send {LControl Down}
;---Glaive mode alt---
;~MButton::
;if (glaiveMode)
;	send, {XButton1 Up}{XButton1 Down}
;return
;----------------------
;To-do:
; Make script exclusive to wf
; Configure text fonts and color
;