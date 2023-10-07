#SingleInstance, force
#MaxThreadsPerHotkey 2 ; So hotkeys like {A:=!A Loop until(!A)} can function

;================
;---Parameters---
;================
global abilityDelay := 45
global meleeSpamDelay := 45
global semiDelay := 45

;global GarudaQuickSpamDelay := 450
;global GarudaQuickSpamTimes := 13
; global chargeTime :=
; global chargeDelay :=

; RGB GUI
global textR := 255
global textG := 255
global textB := 0
global curr := "g"
global RGBDelay := 60 ; Delay between color swaps
global RGBStep := 15 ; Must be 17, 17*3, 17*5 or 15 since 255 = 15*17 and formatting cant handle negative numbers (-=)


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
global RGBToggle := false
global abilitySpam := false
;global GarudaQuickSpam := false
global meleeMode := "None"
global semiSpamToggle := false
global showGUI := true

;=========
;---GUI---
;=========

CustomColor := "AABBCC"
textColor := Format("{:.2x}{:.2x}{:.2x}", textR, textG, textB)
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui, Color, %CustomColor%
Gui, Font, s1, Fixedsys ;Alt fonts: Consolas, Courier, Courier New, *Fixedsys, Lucida Console, Script, Terminal
Gui, Add, Text, vGUIText c%textColor% Left w350 r7, Text
WinSet, TransColor, %CustomColor% 255
Gosub, UpdateOSD
;SetTimer, RGBCycle, %RGBDelay%
Gui, Show, x0 y900 NoActivate
return

RGBCycle:
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
GuiControl,, GUIText, [Y] Ability spam - %abilitySpam%`n[U] Melee mode - %meleeMode%`n[I] Semi-Auto - %semiSpamToggle%`n[P] Rainbow GUI - %RGBToggle%
return

UpdateOSD:
GuiControl,, GUIText, [Y] Ability spam - %abilitySpam%`n[U] Melee mode - %meleeMode%`n[I] Semi-Auto - %semiSpamToggle%`n[P] Rainbow GUI - %RGBToggle% ;`n`nAbility delay - %abilityDelay%`nMelee delay - %meleeSpamDelay%`nSemi delay - %semiDelay%
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
~p::
RGBToggle := !RGBToggle
gosub, UpdateOSD
if (RGBToggle){
	loop {
		if (!RGBToggle){
			break
		}
		gosub, RGBCycle
		sleep RGBDelay
	}
}
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
if (abilitySpam){
	while GetKeyState("XButton2","P"){
		send, {2}
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
;
;