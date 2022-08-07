#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; beginning jargon of every AHK script^

; on launch, greet and prompt for settings
MsgBox, 32, Instructions, Welcome to the glaive melee spam macro!`nLet us begin by setting up your keys
Gosub, Settings
return

; exit macro on win + shift + e
#+e:: ExitApp

; toggle suspension of macro
suspendBoolean := false
^+p::
Suspend, Toggle
; toggle boolean
suspendBoolean := !suspendBoolean
; notify the user of suspension
outputString := suspendBoolean ? "Suspended!" : "Unsuspended!"
MsgBox, 32, Macro Suspension, %outputString%
return

; get state of the melee key, spam melee + reload while "v" is held down
/*
looking at source code? change the v in "v::" and in "GetKeyState("v", "P")" to any alphanumeric key of your desire!
*/
v::
while (GetKeyState("v", "P") = 1) {
	Send, %meleeButton%
	sleep, %sleepVariable%
	Send, %reloadButton%
	sleep, %sleepVariable%
}
return

; either ctrl + shift + s to activate settings or activate settings on subroutine call
Settings:
^+s::
InputBox, sleepVariable, Settings, % "Input a delay between pressing the keys in milliseconds"
							. "`n(helps with consistency, if too low, the macro might not function exactly as expected. recommended: 5 ms)"
,,,,,,,,5
InputBox, meleeButton, Settings, % "Input your melee button"
InputBox, reloadButton, Settings, % "Input your reload button"
MsgBox, 32, Configured!, % "Your keys are configured:"
				. "`n - macro will spam " . meleeButton . " then " . reloadButton . " with a " . sleepVariable . " ms delay."
				. "`n - Use ""v"" to activate. Hold to continue auto-melee."
				. "`n - Use ctrl + shift + s to open the settings menu again."
				. "`n - Use ctrl + shift + p to pause the macro."
				. "`n - Use win + shift + e to close the macro"
return
