#SingleInstance, force

;================
;---Parameters--- Edit at will.
;================
global abilityDelay := 45
global meleeSpamDelay := 45
global semiDelay := 45

;global GarudaQuickSpamDelay := 450
;global GarudaQuickSpamTimes := 13
; global chargeTime :=
; global chargeDelay :=

; GUI Settings
global GUIx := 0 ; X&Y of the GUI
global GUIy := 900 ;
global textS := 1 ; Text size
global textF := "Fixedsys" ; Text font - Alt fonts (monospaced): Consolas, Courier, Courier New, *Fixedsys, Lucida Console, Script, Terminal
global textW := 700 ; Maximum width of the GUI text
global textR := 7 ; Maximum number of rows of the GUI text

; Initital color
global textR := 255
global textG := 255
global textB := 0
global textColor := Format("{:.2x}{:.2x}{:.2x}", textR, textG, textB)
; GUI Lighting
global curr := "g"
global RGBDelay := 100 ; Delay between color swaps
global RGBStep := 15 ; Must be 17, 17*3, 17*5 or 15

;=============
;---Toggles--- Initial state of toggles
;=============
global RGBToggle := false
global abilitySpam := false
;global GarudaQuickSpam := false
global meleeMode := "None"
global semiSpamToggle := false
global showGUI := true

;=========
;---GUI---
;=========

Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
; Transparent background
CustomColor := "AABBCC"
Gui, Color, %CustomColor%
WinSet, TransColor, %CustomColor% 255
; Text settings
Gui, Font, s%textS%, %textF%
Gui, Add, Text, vGUIText c%textColor% Left w%textW% r%textR%, placeHolder
Gosub, UpdateOSD
SetTimer, RGBCycle, %RGBDelay%
Gui, Show, x%GUIx% y%GUIy% NoActivate
return

RGBCycle:
if (RGBToggle){
	if (curr = "g"){
		if (textR > 0) {
			textR -= RGBStep
		} else if (textB < 255){
			textB += RGBStep
			if (textB = 255){
				curr := "b"
			}
		}
	} else if (curr = "b"){
		if (textG > 0) {
			textG -= RGBStep
		} else if (textR < 255){
			textR += RGBStep
			if (textR = 255){
				curr := "r"
			}
		}
	} else if (curr = "r"){
		if (textB > 0) {
			textB -= RGBStep
		} else if (textG < 255){
			textG += RGBStep
			if (textG = 255){
				curr := "g"
			}
		}
	}
	textColor := Format("{:.2x}{:.2x}{:.2x}", textR, textG, textB)
	GuiControl, +c%textColor%, GUIText
	gosub, UpdateOSD
}
return

UpdateOSD:
GuiControl,, GUIText, [Y] Ability spam - %abilitySpam%`n[U] Melee mode - %meleeMode%`n[I] Semi-Auto - %semiSpamToggle%`n[P] Rainbow GUI - %RGBToggle% ;`n`nAbility delay - %abilityDelay%`nMelee delay - %meleeSpamDelay%`nSemi delay - %semiDelay%pp
return

;====================
;---Script Control---
;====================
*F3::
	Suspend
	showGUI := !showGUI
	if (showGUI){
		Gui, Show, x%GUIx% y%GUIy% NoActivate
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
~p::
	RGBToggle := !RGBToggle
	Gosub, UpdateOSD
return

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
; Work in progress
;==================
;---Ability spam---
;==================
; 1st Ability
*1::
if (abilitySpam){
	while GetKeyState("1","P"){
		send, {Blind}{1}
		sleep abilityDelay
	}
} else send {Blind}{1 DownR}
return
*1 Up:: send {Blind}{1 Up}
; 2nd Ability
*2::
if (abilitySpam){
	while GetKeyState("2","P"){
		send, {Blind}{2}
		sleep abilityDelay
	}
} else send {Blind}{2 DownR}
return
*2 Up:: send {Blind}{2 Up}
; 3rd Ability
*3::
if (abilitySpam){
	while GetKeyState("3","P"){
		send, {Blind}{3}
		sleep abilityDelay
	}
} else send {Blind}{3 DownR}
return
*3 Up:: send {Blind}{3 Up}
; 4th Ability
*4::
if (abilitySpam){
	while GetKeyState("4","P"){
		send, {Blind}{4}
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
		send, {Blind}{XButton1}
		sleep meleeSpamDelay
	}
} else if (meleeMode = "Glaive") {
	send, {Blind}{MButton}
}
return

; For Garuda: hold mbutton2 to spam thermal and bloodlet
~XButton2::
if (abilitySpam){
	while GetKeyState("XButton2","P"){
		send, {Blind}{2}
		sleep abilityDelay
	}
}
; Retired:
;if (GarudaQuickSpam){
;	while GetKeyState("XButton2","P"){
;		loop %GarudaQuickSpamTimes% {
;			if (!GetKeyState("XButton2")){
;				break
;			}
;			send, {2}
;			sleep GarudaQuickSpamDelay
;		}
;		if (!GetKeyState("XButton2")){
;			break
;		}
;		send, {3}
;		sleep GarudaQuickSpamDelay
;	}
;}
return

; Spam semi-automatics
~LButton::
if (semiSpamToggle)
	while GetKeyState("LButton","P"){
		send, {Blind}{LButton}
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
;
;