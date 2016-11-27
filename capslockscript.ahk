SpecialMode := 0
+Capslock::Capslock
Capslock::Esc
RWin::AppsKey

#Esc::
	if (SpecialMode = 1)
		SpecialMode = 0
	else if (SpecialMode = 0 )
		SpecialMode = 1
return 

#If, (SpecialMode = 0)
:*:kj::
	send, {Esc}
return  

#If, (SpecialMode = 1) 
J::send, {Down}
K::send, {Up}
L::send, {Right}
H::send, {Left}
; CheckOff::
; 	Check :- False
; 	send k
; return

; k::
;     Check := true
;     SetTimer, CheckOff, 10 ; 1 second to type in 001
; return

; j::
;     If Check
;         Run, program.exe
;     Else
;     	Send j
; return

