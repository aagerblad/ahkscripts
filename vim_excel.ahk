;---------------------------------------
; Basic VIM Keybinds for Excel.
;---------------------------------------

;---------------------------------------
; Usage - Run vim_Excel.ahk, or autohotkey vim_Excel.ahk
;---------------------------------------

;--------------------------------------------------------------------------------
; https://github.com/idvorkin/Vim-Keybindings-For-Excel
;
; Acknowledgments:
; This is based on a vim autohotkey script which I can no longer find. If you find it, 
; please tell me and I'll add it to the acknowledgments
;---------------------------------------

;---------------------------------------
; Settings
;---------------------------------------
;#NoTrayIcon ; NoTrayIcon hides the tray icon.
#SingleInstance Force ; SingleInstance makes the script automatically reload.

;---------------------------------------
; The code itself.
;---------------------------------------

; The VIM input model has two modes, normal mode, where you enter commands, 
; and insert mode, where keys are inserted into the text.
;
; In insert mode, this script is suspended, and only the ESC hotkey is active, all other 
; keystrokes are propagated to Excel. When ESC is pressed, the script enters normal mode.

; In normal mode, this script is active and all HotKeys are active. Hotkeys that need to
; return to insert mode, end by calling InsertMode. On script startup, InsertMode is entered.

;--------------------------------------------------------------------------------
Gosub InsertMode ; goto InsertMode mode on script startup
visualmode = 0
SetTitleMatchMode 2 ;- Mode 2 is window title substring.
#IfWinActive, Excel ; Only apply this script to Excel.

;--------------------------------------------------------------------------------
IsLastKey(key)
{
    return (A_PriorHotkey == key and A_TimeSincePriorHotkey < 400)
}

; ESC enters Normal Mode
ESC::
    Suspend, Off
    visualmode = 1
    ; send escape on through to exit from find
    SendInput, {ESC} 
    ToolTip, Excel Vim Command Mode Active %visualmode%, 0, 0
return

; Caps also enters Normal Mode
Capslock::
    Suspend, Off
    visualmode = 0
    ; send escape on through to exit from find
    SendInput, {ESC} 
    ToolTip, Excel Vim Command Mode Active %visualmode%, 0, 0
return
;--------------------------------------------------------------------------------
; Return to InsertMode
InsertMode:
    ToolTip
    Suspend, On
    visualmode = 0 
return

VisualMode:
    visualmode = 1
    Tooltip, Excel Vim Visual Mode Active %visualmode%, 0,0
Return

;--------------------------------------------------------------------------------
+i::
    SendInput, {Home}
    Gosub InsertMode
return 

i::Gosub InsertMode
return 

v::Gosub VisualMode
return

;--------------------------------------------------------------------------------
; vi left and right

h::
    if visualmode = 0
        SendInput, {Left}
    else
        SendInput, +{Left}
return 
l::
    if visualmode = 0
        SendInput, {Right}
    else
        SendInput, +{Right}
return 

;--------------------------------------------------------------------------------
; vi up and down.
;  Excel does some magic that blocks up/down processing. See more @ 
; (Excel 2013) http://www.autohotkey.com/board/topic/74113-down-in-Excel/
; (Excel 2007) http://www.autohotkey.com/board/topic/15307-up-and-down-hotkeys-not-working-for-Excel-2007/
j::
    if visualmode = 0
        SendInput,{down}
    else
        SendInput, +{down}
return 
k::
    if visualmode = 0
        SendInput,{up}
    else
        SendInput, +{Up}
return 

Return::SendInput,^{down}
return


+x::SendInput, {BackSpace}
return 

x::SendInput, {Delete}
return 

; undo
u::Send, ^z
return 
; redo.
^r::Send, ^y
return 


b::Send, ^{Left}
return 
+4::Send, {End}
return 
0::Send, {Home}
return 
+6::Send, {Home}
return 
+5::Send, ^b
return 
^f::Send, {PgDn}
return 

;; TBD Design a more generic <command> <motion> pattern, for now implement yy and dd the most commonly used commands.
y::
if IsLastKey("y")
{
    Send, {Home}{ShiftDown}{End}
    Send, ^c
    Send, {Shift}
}
return 

; Cut to end of line
+d::
Send, {ShiftDown}{End}
Send, ^x ; Cut instead of yank and delete
Send, {ShiftUp}
return

; Delete current line
d::
if IsLastKey("d")
{
    Send, {Home}{ShiftDown}{End}
    Send, ^c ; Yank before delete, don't use cut so blank lines are deleted 
    Send, {Del}
    Send, {Shift}
}
return 

+s::
Send, {Home}{ShiftDown}{End}
Send, ^x ; Cut instead of yank and delete
Send, {ShiftUp}
Gosub, InsertMode   
return 

return 
; TODO handle regular paste , vs paste something picked up with yy
; current behavior assumes yanked with yy.
p::
Send, {End}{Enter}^v
return

; Search 
/::
Send, ^f
Gosub InsertMode
return
; don't know if there is a reverse find
?::
Send, ^f
Gosub InsertMode
return

; C-P => Search all notebooks.
^p::
Send, ^e
; a bit weird - we're in insert mode after the search.
GoSub InsertMode
return 

;--------------------------------------------------------------------------------
; Eat all other keys if in command mode.
;--------------------------------------------------------------------------------
c::
e::
f::
m::
n::
r::
s::
t::
+C::
+E::
+H::
+L::
+M::
+N::
+P::
+Q::
+R::
; +S::
+T::
+U::
+V::
+W::
;+X::
+Y::
+Z::
.::
'::
;::
; return::
