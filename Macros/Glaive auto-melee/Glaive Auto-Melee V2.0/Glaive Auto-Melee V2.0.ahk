; a program to spam the melee and reload button
#NoEnv

; variables used
MeleeKey := ""
ReloadKey := ""
AutoGlaiveKey := ""
DelayKey := 5				; key delay in milliseconds
ConfigKey := ""
SuspendKey := ""
SuspendActive := false		; remember the state of suspension when Destiny 2 is not the active window

; GUI style
GroupBoxXM := 10			; group box y-margin
GroupBoxYM := 20 			; group box x-margin
GroupBoxW := 225			; group box default width
ConfigActive := true		; remember the state of the config window, if it is active or not

;;; GUI to configure the macro ;;;
Gui, Config:New, , Config

; config GroupBox
GroupSection1 := 131
Gui, Add, GroupBox, W%GroupBoxW% H%GroupSection1% Section, Hotkeys
; melee hotkey config
Gui, Add, Text, XS+%GroupBoxXM% YS+%GroupBoxYM% W75, Melee Key:
Gui, Add, Hotkey, X+0 vMeleeKey, %MeleeKey%
; reload key config
Gui, Add, Text, XS+%GroupBoxXM% Y+0 W75, Reload key:
Gui, Add, Hotkey, X+0 vReloadKey, %ReloadKey%
; autoglaive key config
Gui, Add, Text, XS+%GroupBoxXM% Y+0 W75, AutoGlaive key:
Gui, Add, Hotkey, X+0 vAutoGlaiveKey, %AutoGlaiveKey%
; config key config
Gui, Add, Text, XS+%GroupBoxXM% Y+0 W75, Config menu:
Gui, Add, Hotkey, X+0 vConfigKey, %ConfigKey%
; suspend key config
Gui, Add, Text, XS%GroupBoxXM% Y+0 W75, Suspend key:
Gui, Add, Hotkey, X+0 vSuspendKey, %SuspendKey%

; config GroupBox
GroupSection2 := 79
Gui, Add, GroupBox, XM+0 YS+%GroupSection1% W%GroupBoxW% H%GroupSection2% Section, Config
; config the delay
Gui, Add, Text, XS+%GroupBoxXM% YS+%GroupBoxYM% W180, Enter delay between key presses `n(5 ms recommended)
Gui, Add, Edit, Y+5 W100 Number Limit3 vDelayKey, %DelayKey%
Gui, Add, UpDown, Range0-999
Gui, Add, Text, X+5, milliseconds of delay

; submit button
Gui, Add, Button, XM YS+%GroupSection2% W100 gSubmitHotkeys, &Submit Settings

Gui, Config:Show
;;; Gui Config end ;;;

;;; Gui info begin ;;;
Gui, info:New, , Info

Gui, Add, Text, , % "Thanks for using my Auto-Glaive macro!"
Gui, Add, Link, Y+, If you want to see more of my macros or contribute, visit <a href="https://github.com/RomaBureacov/Destiny-Macros">the GitHub</a>

; notes groupbox
Gui, Add, GroupBox, XM Y+ W500 H275 Section, Notes
Gui, Add, Text, XS+%GroupBoxXM% YS+%GroupBoxYM% W480, % "There are a few notes about this macro:"
												. "`n`n 1 - You may set the Auto-Glaive key to your desire, but note that only the final key must be held to keep the Auto-Glaive active (e.g.: shift + c requires you to hit shift + c, but after that you only have to hold down c to keep the autoglaive active)."
												. "`n`n 2 - The macro will only remain active while Destiny 2 is your active window."
												. "`n`n 3 - The macro will remain suspended while the config menu is active."
												. "`n`n 4 - This macro will spam your keyboard buttons and might cause problems when trying to type out messages in the text chat. Utilize your suspend key to temporarily suspend the macro, and hit it again to unsuspend the macro later."
												. "`n`n 5 - if you desire it, feel free to use this script as a general auto-melee script by omittin the reload parameter."
												. "`n`n 6 - To close the macro, either x-out of, or use Esc while in, the config menu. You may also simply close it through the tray icon by right-click and then exit."

Gui, info:Show
;;; Gui info end ;;;

; do not run code after this point after starting the application
return

;;;;;; force close, development feature ;;;;;
;@Ahk2Exe-IgnoreBegin
RCtrl::
Suspend, Permit
ExitApp
;@Ahk2Exe-IgnoreEnd

;;; GUI config logic ;;;
; set hotkeys
SubmitHotkeys:
; scrub old hotkeys
if (AutoGlaiveKey != "")
	Hotkey, %AutoGlaiveKey%, AutoGlaiveActivate, Off
if (ConfigKey != "")
	Hotkey, %ConfigKey%, OpenConfig, Off
if (SuspendKey != "") {
	Hotkey, %SuspendKey%, SuspendKeys, Off
}
; get new keys
Gui, Config:Submit, NoHide
; check if all keys are set by the user
if (MeleeKey == "" || ReloadKey == "" || AutoGlaiveKey == "" || ConfigKey == "" || SuspendKey == "") {
	; assure that the user wants to continue with missing ConfigKey
	if (ConfigKey == "") {
		MsgBox, 52, Warning, You do not have a configuration key set.`nIf you continue`, configuration may only be done by restarting the application. You will still be able to close the application through the tray icon.`n`nDo you wish to Continue?
		IfMsgBox, no
			Exit
	; assure that the user wants to continue with missing keys
	}
	MsgBox, 52, Warning, One or more of your keys are not set.`nDo you wish to continue?
	IfMsgBox no
		Exit
}
; set new hotkeys
Hotkey, If, !ConfigActive && WinActive("Destiny 2") ; create hotkeys with the directive
if (AutoGlaiveKey != "")
	Hotkey, %AutoGlaiveKey%, AutoGlaiveActivate, On
if (ConfigKey != "")
	Hotkey, %ConfigKey%, OpenConfig, On
if (SuspendKey != "")
	Hotkey, %SuspendKey%, SuspendKeys, On
; finalize operation, close GUI and inform of completion
Gui, Config:Hide
ConfigActive := false

Suspend, Off
SuspendActive := false

TempToolTip("Keys Set!")

return
;;; GUI logic end ;;;

;;; keys, labels, and functions ;;;

;; Only activate when Destiny 2 is the active window and the config menu is closed
; directive only here in case of future hotkeys being placed in this area
#If !ConfigActive && WinActive("Destiny 2")

; do AutoGlaive
AutoGlaiveActivate:
; get the unmodified key in the auto-glaive key or extract the final key from the auto glaive key
AutoGlaiveKeyHold := StrLen(AutoGlaiveKey) == 1 ? AutoGlaiveKey : SubStr(AutoGlaiveKey, StrLen(AutoGlaiveKey))
while (GetKeyState(AutoGlaiveKeyHold, "P")) {
	Send, %ReloadKey%
	Sleep, %DelayKey%
	Send, %MeleeKey%
}
return

; Open Config
OpenConfig:
Suspend, On
SuspendActive = true
Gui, Config:Show
ConfigActive := true
TempToolTip("Keys Deactivated. Confirm your keys.")
return

; Suspend keys
; Note: because of the directive above, this label will not fire when not focused on the Destiny 2
SuspendKeys:
Suspend, Permit
Suspend, Toggle
SuspendActive := !SuspendActive
TempToolTip(SuspendActive ? "Keys Suspended!" : "Keys Unsuspended!")
return

#If

;;; labels for the config window and while it is active
#IfWinActive Config

; hit enter in the config menu to submit
Enter::
Suspend, Permit
GoSub, SubmitHotkeys
return

;;; info gui
infoGuiClose:
infoGuiEscape:
Gui, info:Show, Hide
return

#IfWinActive

;;; general-purpose labels
ClearToolTip:
ToolTip,
return

; close app upon deliberate closing or escape key
ConfigGuiEscape:
ConfigGuiClose:
	MsgBox, 52, Warning, Are you sure you want to close the application?
	IfMsgBox Yes
		ExitApp
return

;;; functions

TempToolTip(string) {
	ToolTip, %string%
	SetTimer, ClearToolTip, -1500
}