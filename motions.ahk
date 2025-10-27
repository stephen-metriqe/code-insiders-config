#Requires AutoHotkey v2.0
; SetBatchLines, -1 #SingleInstance Force

global speed := 10  ; Default movement speed
global fastSpeed := 20  ; Faster movement when Caps Lock + Shift is held

SetCapsLockState('AlwaysOff')

CapsLock:: return

; Enable Caps Lock as a modifier
CapsLock & h:: MouseMove -1000, 0, 0, "R" ; far Left
; CapsLock & j:: MouseMove 0, 500, 0, "R" ; Up
; CapsLock & k:: MouseMove 0, -500, 0, "R" ; Down
CapsLock & l:: MouseMove 1000, 0, 0, "R" ; far Right

CapsLock & m:: Send("{WheelDown}")
CapsLock & i:: Send("{WheelUp}")

; Ctrl + j → Down Arrow
CapsLock & j:: Send("{Down}")
; j::HandleDir("j")
CapsLock & k:: Send("{Up}")
; k::HandleDir("k")

CapsLock & p:: Send("{Right}")
CapsLock & n:: Send("{Left}")

CapsLock & `;:: Send("{Escape}")
CapsLock & /:: Send("{Backspace}")
CapsLock & ':: Send("^{Backspace}") ;Ctrl + backspace

CapsLock & d:: Send("{Delete}")
CapsLock & e:: Send("{End}")
CapsLock & w:: Send("{Home}")

CapsLock & [:: Send("^{Home}") ;Ctrl + home
CapsLock & ]:: Send("^{End}")  ;Ctrl + end

; ============================================================
; Use Left Alt + letter to send numbers
!m:: Send("1")   ; Left Alt + U → 1
!,:: Send("2")   ; Left Alt + I → 2
!.:: Send("3")   ; Left Alt + O → 3
!j:: Send("4")   ; Left Alt + P → 4
!k:: Send("5")   ; Left Alt + J → 5
!l:: Send("6")   ; Left Alt + K → 6
!u:: Send("7")   ; Left Alt + L → 7
!i:: Send("8")   ; Left Alt + ; → 8
!o:: Send("9")   ; Left Alt + ' → 9
!;:: Send("0")   ; Left Alt + / → 0
!p:: Send("{+}")   ; Left Alt + / → 0
!/:: Send("-")   ; Left Alt + / → 0
; ============================================================
![:: Send("{^}") ;

; ============================================================
; CapsLock & o:: {

;     ; Get the active window position
;     if WinExist("A") {
;         WinGetPos(&wx, &wy, &ww, &wh, "A")

;         ; Find which monitor the window is on
;         mon := MonitorFromRect(wx, wy, ww, wh)

;         if (mon > 0) {
;             MonitorGet(mon, &mx, &my, &mw, &mh)
;             ; Move mouse to monitor center
;             MouseMove(mx + mw / 2, my + mh / 2)
;         }
;     }
; }

; ; Helper: find which monitor rectangle contains the window
; MonitorFromRect(x, y, w, h) {
;     loop MonitorGetCount() {
;         MonitorGet(A_Index, &mx, &my, &mw, &mh)
;         if (x >= mx && x < mx + mw && y >= my && y < my + mh)
;             return A_Index
;     }
;     return 1 ; fallback to primary
; }
; ============================================================

; AHK v2: Alert when CapsLock is ON and letter key is pressed
; ----------------------------

letters := ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

for _, key in letters {
    Hotkey("~" key, CheckCapsAndAlert) ; no .Bind()
}

CheckCapsAndAlert(hotkeyName) {
    if GetKeyState("CapsLock", "T") { ; CapsLock is toggled ON
        ; MsgBox("CapsLock is ON — You pressed: " hotkeyName)

        result := MsgBox(
            "CapsLock is ON — You pressed: " hotkeyName "`n`n"
            . "Do you want to turn it OFF?",
            "CapsLock Alert",
            "YesNo 32"  ; Yes/No buttons, Question icon
        )

        if (result = "Yes") {
            SetCapsLockState("Off")
            ; MsgBox("CapsLock turned OFF")
        }
        ; If "No", keep CapsLock ON (do nothing) }
    }
}
; =======================================================================
; ----------------------------
; AHK v2: Focus window on specific monitor
; ----------------------------

; Monitor X coordinates

CoordMode("Mouse", "Screen") ; All mouse coordinates will now be relative to the screen

FocusMonitor(monNum) {
    ; monitorX := [-1920, 0, 1920]  ; 1-based array: index 1 = -1920
    monitorX := [-960, 960, 2600]  ; 1-based array: index 1 = -1920
    ; global monitorX
    targetX := monitorX[monNum]  ; now monNum is 1..3
    ; if (monNum == 1) {
    ;     targetX := -960
    ;     ; targetX := left - cx
    ; } else if (monNum == 2) {
    ;     targetX := 960
    ;     ; targetX := 960 + 960

    ; } else if (monNum == 3) {
    ;     targetX := 2600
    ; }

    targetY := 1070  ; vertical center at the bottom
    ; targetY := 540  ; vertical center
    ; SendMode('Event')

    ; Move mouse
    MouseMove(targetX, targetY)
    Sleep(100)
    MouseGetPos(&x, &y, &winHwnd) ; Get the window HWND under the mouse
    Sleep(100)

    if (winHwnd) {
        winTitle := WinGetTitle(winHwnd) ; Get the title from the HWND
        winExe := WinGetProcessName(winHwnd) ; Get the process name

        WinActivate(winHwnd)
        ; MsgBox("Window Title: " . winTitle . "`nProcess Name: " . winExe) ; Display the results
    } else {
        MsgBox("No window found under the mouse cursor.")
    }
}

; Hotkeys
!1:: FocusMonitor(1)
!2:: FocusMonitor(2)
!3:: FocusMonitor(3)
; --------------------------------------------------------------------
; CapsLock & 1:: FocusMonitor(1)
; CapsLock & 2:: FocusMonitor(2)
; CapsLock & 3:: FocusMonitor(3)

; FocusMonitor(monNumber) {
;     if (monNumber > 0 && monNumber <= MonitorGetCount()) {
;         MonitorGet(monNumber, &mx, &my, &mw, &mh)

;         ; Loop through all windows
;         for hwnd in WinGetList() {
;             WinGetPos(&wx, &wy, &ww, &wh, "ahk_id " hwnd)

;             ; Check if window is on the target monitor
;             if (wx >= mx && wx < mx + mw && wy >= my && wy < my + mh) {
;                 WinActivate("ahk_id " hwnd)
;                 return
;             }
;         }
;     } else {
;         MsgBox("Monitor " monNumber " not found")
;     }
; }
; -------------------------

; Step 1: List all top-level windows

; logFile := "D:\ahk_logs\log.txt"  ; absolute path
; FileDelete(logFile)  ; start fresh

; ; Get total monitor count
; totalMonitors := MonitorGetCount()  ; <-- call as a function, not method
; FileAppend("Total monitors: " totalMonitors "`n", logFile)

; ; Create an array of monitor numbers (up to 3)
; monArray := [1, 2, 3]

; for _, i in monArray {
;     if (i > totalMonitors)
;         continue  ; skip if fewer monitors connected

;     MonitorGet(i, &x, &y, &w, &h)
;     entry := "Monitor " i ": X=" x ", Y=" y ", Width=" w ", Height=" h "`n"
;     FileAppend(entry, logFile)
; }

; MsgBox("Monitor info logged here: " logFile)
; --------------------------------------------
; --------------------------------------------------------------

; FocusMonitor(monNum) {
;     ; Check if the monitor number exists.
;     if monNum > MonitorGetCount() {
;         MsgBox("Monitor " monNum " does not exist.")
;         return
;     }

;     ; Get the bounding coordinates of the specified monitor.
;     MonitorGet(monNum, &left, &top, &right, &bottom)

;     ; Calculate the center coordinates.
;     targetX := (left + right) // 2
;     targetY := (top + bottom) // 2

;     ; Move the mouse to the center of the target monitor.
;     MouseMove(targetX, targetY, 0)
;     Sleep(500) ; Increase delay to ensure the OS registers the mouse position

;     ; Find and activate the window under the mouse.
;     MouseGetPos(&x, &y, &winHwnd)
;     Sleep(150)

;     if (winHwnd) {
;         winTitle := WinGetTitle(winHwnd)
;         winExe := WinGetProcessName(winHwnd)
;         WinActivate(winHwnd)
;         MsgBox("Window Title: " . winTitle . "`nProcess Name: " . winExe)
;     } else {
;         MsgBox("No window found under the mouse cursor.")
;     }
; }

; ; Hotkeys
; !1:: FocusMonitor(1)
; !2:: FocusMonitor(2)
; !3:: FocusMonitor(3)
; -----------------------------------------------------
; CapsLock & o:: {
;     ; CoordMode("Mouse", "Screen")
;     ; x := 0
;     ; y := 0
;     A_CoordModeCaret := "Screen"

;     if CaretGetPos(&x, &y) {
;         MouseMove(x, y)
;     }
; }

; HandleDir(key){
;     if GetKeyState("CapsLock","P"){
;         mods := ""
;         if GetKeyState("Control","P")
;             mods .= "^"

;         if GetKeyState("Alt","P")
;             mods .= "!"

;         if GetKeyState("Shift","P")
;             mods .= "+"

;         if (key = "j")
;             Send(mods . "{Down}")

;         if (key = "k")
;             Send(mods . "{Up}")
;     }
; }

!Q:: ExitApp

; CapsLock & y::MouseMove -20, 0, 0, "R" ; Right
; CapsLock & u::MouseMove 0, 20, 0, "R" ; Left
; CapsLock & i::MouseMove 0, -20, 0, "R" ; Right
; CapsLock & o::MouseMove 20, 0, 0, "R" ; Right

; CapsLock & Enter::Click

; CapsLock & H::MouseMove -20, 0, 0, "R" ; Left
; CapsLock & J::MouseMove 0, 20, 0, "R" ; Left
; CapsLock & K::MouseMove 0, -20, 0, "R" ; Left
; CapsLock & L::MouseMove 20, 0, 0, "R" ; Left
; Mouse movement speed
; speed := 10

; Hold Shift for faster movement
; H::MouseMove(0.5, 0.5, 2, "R")
; +H::MouseMove, -%speed%, 0, 0, R  ; Move left
; +L::MouseMove, %speed%, 0, 0, R   ; Move right
; +K::MouseMove, 0, -%speed%, 0, R  ; Move up
; +J::MouseMove, 0, %speed%, 0, R   ; Move down

; Regular movement
; H::MouseMove, -5, 0, 0, R
; L::MouseMove, 5, 0, 0, R K::MouseMove, 0, -5, 0, R
; J::MouseMove, 0, 5, 0, R

; Click with Space
; Space::Click

; Exit script with Ctrl + Q
