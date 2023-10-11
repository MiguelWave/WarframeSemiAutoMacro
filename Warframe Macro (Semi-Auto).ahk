#SingleInstance, force

;================
;---Parameters--- Edit at will.
;================
global abilityDelay := 45
global meleeSpamDelay := 45
global semiDelay := 45
global chargeTime := 500
global chargeDelay := 300

;global GarudaQuickSpamDelay := 450
;global GarudaQuickSpamTimes := 13

; GUI Settings
global GUIx := 0 ; X&Y of the GUI
global GUIy := 600 ;
global textS := 1 ; Text size
global textF := "Fixedsys" ; Text font - Alt fonts (monospaced): Consolas, Courier, Courier New, *Fixedsys, Lucida Console, Script, Terminal
global textW := 500 ; Maximum width of the GUI text
;global textR := 1 ; bugged? seems to have no effect on the number of lines

; Initital text color
global textR := 255 ; Oddity: Starting color R not being 255 only prints out the first line of the GUI
global textG := 255
global textB := 0
global textColor := Format("{:.2x}{:.2x}{:.2x}", textR, textG, textB)

; GUI Lighting
global curr := "g"
global RGBDelay := 100 ; Delay between color swaps
global RGBStep := 15 ; Must be 17, 17*3, 17*5 or 15

global tuningStep := 45
global AgentOfChange := "Ability delay"

;=============
;---Toggles--- Initial state of toggles
;=============
global abilitySpam := false
global meleeMode := "None"
global fireMode := "None"
global IsSuspended := false
global RGBToggle := false

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
GuiControl,, GUIText, [Y] Ability spam - %abilitySpam%`n[U] Melee mode - %meleeMode%`n[I] Fire mode - %fireMode%`n[P] Rainbow GUI - %RGBToggle%`n`n[Arrows] Currently changing - %AgentOfChange%`n`nAbility delay - %abilityDelay%`nMelee delay - %meleeSpamDelay%`nSemi delay - %semiDelay%`nCharge time - %chargeTime%`nCharge delay - %chargeDelay%
return

SuspendMsg:
GuiControl,, GUIText, [F3] Script suspended
return

;============
;---Tuning---
;============
Up::
switch AgentOfChange {
	case "Ability delay":
		AgentOfChange := "Charge delay"
		Gosub, UpdateOSD
		return
	case "Melee delay":
		AgentOfChange := "Ability delay"
		Gosub, UpdateOSD
		return
	case "Semi delay":
		AgentOfChange := "Melee delay"
		Gosub, UpdateOSD
		return
	case "Charge time":
		AgentOfChange := "Semi delay"
		Gosub, UpdateOSD
		return
	case "Charge delay":
		AgentOfChange := "Charge time"
		Gosub, UpdateOSD
		return
}
return

Down::
switch AgentOfChange{
case "Ability delay":
	AgentOfChange := "Melee delay"
	Gosub, UpdateOSD
	return
case "Melee delay":
	AgentOfChange := "Semi delay"
	Gosub, UpdateOSD
	return
case "Semi delay":
	AgentOfChange := "Charge time"
	Gosub, UpdateOSD
	return
case "Charge time":
	AgentOfChange := "Charge delay"
	Gosub, UpdateOSD
	return
case "Charge delay":
	AgentOfChange := "Ability delay"
	Gosub, UpdateOSD
	return
}
return

Right::
switch AgentOfChange{
case "Ability delay":
	if (abilityDelay<1000){
		abilityDelay += tuningStep
		Gosub, UpdateOSD
	}
	return
case "Melee delay":
	if (meleeDelay<1000){
		meleeDelay += tuningStep
		Gosub, UpdateOSD
	}
	return
case "Semi delay":
	if (semiDelay<1000){
		semiDelay += tuningStep
		Gosub, UpdateOSD
	}
	return
case "Charge time":
	if (chargeTime<1000){
		chargeTime += tuningStep
		Gosub, UpdateOSD
	}
	return
case "Charge delay":
	if (chargeDelay<1000){
		chargeDelay += tuningStep
		Gosub, UpdateOSD
	}
	return
}
return

Left::
switch AgentOfChange{
case "Ability delay":
	if (abilityDelay>10){
		abilityDelay -= tuningStep
		Gosub, UpdateOSD
	}
	return
case "Melee delay":
	if (meleeDelay>10){
		meleeDelay -= tuningStep
		Gosub, UpdateOSD
	}
	return
case "Semi delay":
	if (semiDelay>10){
		semiDelay -= tuningStep
		Gosub, UpdateOSD
	}
	return
case "Charge time":
	if (chargeTime>10){
		chargeTime -= tuningStep
		Gosub, UpdateOSD
	}
	return
case "Charge delay":
	if (chargeDelay>10){
		chargeDelay -= tuningStep
		Gosub, UpdateOSD
	}
	return
}
return

;====================
;---Script Control---
;====================
*F3::
	Suspend
	IsSuspended := !IsSuspended
	if (!IsSuspended){
		Gosub, UpdateOSD
		return
	} else {
		Gosub, SuspendMsg
		return
	}
return
*F4::ExitApp
*F5::Reload

;===============
;---Togglings---
;===============
!p::
	RGBToggle := !RGBToggle
	Gosub, UpdateOSD
return

!y::
	abilitySpam:=!abilitySpam
	Gosub, UpdateOSD
return

!u::
	if (meleeMode = "None"){
		meleeMode := "Glaive"
	} else if (meleeMode = "Glaive"){
		meleeMode := "Spam"
	} else meleeMode := "None"
	Gosub, UpdateOSD
return

!i::
	if (fireMode = "None"){
		fireMode := "Semi"
	} else if (fireMode = "Semi"){
		fireMode := "Charge"
	} else fireMode := "None"
	Gosub, UpdateOSD
return

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
if (fireMode = "Semi"){
	while GetKeyState("LButton","P"){
		send, {Blind}{LButton}
		sleep semiDelay
	}
} else if (fireMode = "Charge") {
	while GetKeyState("LButton","P"){
		sleep chargeTime
		send, {Blind}{LButton Up}
		sleep chargeDelay
		if (!GetKeyState("LButton","P")){
			break
		}
		send, {Blind}{LButton Down}
	}
}
return

!z::send {LControl Down}
;---Glaive mode alt---
;~MButton::
;if (glaiveMode)
;	send, {XButton1 Up}{XButton1 Down}
;return
;----------------------
;To-do:
; Make script exclusive to wf
;	Make an extension GUI displaying parameters
;