format PE console
entry start

; «амилов јртур –афаэлович
; √рупппа: Ѕѕ»-193
; ¬ариант: 6

; ѕрограмма получает массив A,
; составить и вывести массив B из элементов A кратных x

include 'win32a.inc'

;-----------------------Ч Data Ч------------------------------------------Ч
section '.data' data readable writable

strASize db 'Input size of A: ', 0
strX db 'Input X: ', 0
strIncorrect db 'Incorrect size of A= %d', 10, 0
strAI db '[%d] = ', 0
strScanInt db '%d', 0
strOutA db 10, 'A:', 10, 0
strB db 10, 'B:', 10, 0
strVecElemOut db '[%d] = %d', 10, 0

x dd 0
ASize dd 0
BSize dd 0
count dd 0
i dd ?
tmp dd ?
tmpStack dd ?
A rd 100
B rd 100
;-----------------------Ч Code Ч-------------------------------------------Ч
section '.code' code readable executable
start:
; 0) number x input
push strX
call [printf]

push x
push strScanInt
call [scanf]


call AInput

call getB

push strB
call [printf]

call BOut

finish:
call [getch]

push 0
call [ExitProcess]

;------------------------------------------------------------------------Ч
AInput:
push strASize
call [printf]
add esp, 4

push ASize
push strScanInt
call [scanf]
add esp, 8

push strOutA
call [printf]
add esp, 4

mov eax, [ASize]
cmp eax, 0
jg getVector

push ASize
push strIncorrect
call [printf]
push 0
call [ExitProcess]

getVector:
xor ecx, ecx
mov ebx, A
getVecLoop:
mov [tmp], ebx
cmp ecx, [ASize]
jge endInputVector


mov [i], ecx
push ecx
push strAI
call [printf]
add esp, 8

push ebx
push strScanInt
call [scanf]
add esp, 8

mov ecx, [i]
inc ecx
mov ebx, [tmp]
add ebx, 4
jmp getVecLoop
endInputVector:
ret
;------------------------------------------------------------------------Ч
getB:
mov ebx, A
mov ecx, B
VecLoop:
mov edx, [count]
cmp edx, [ASize]
je endSumVector

mov eax, [ebx]
mov edx,0
div [x]
cmp edx, 0
jne ToNextElem

mov eax, [ebx]
mov [ecx], eax
add ecx, 4
inc [BSize]

ToNextElem:
inc [count]
add ebx, 4
jmp VecLoop
endSumVector:
ret
;------------------------------------------------------------------------Ч
BOut:
mov [tmpStack], esp
xor ecx, ecx
mov ebx, B
putVecLoop:
mov [tmp], ebx
cmp ecx, [BSize]
je endOutputVector
mov [i], ecx

push dword [ebx]
push ecx
push strVecElemOut
call [printf]

mov ecx, [i]
inc ecx
mov ebx, [tmp]
add ebx, 4
jmp putVecLoop
endOutputVector:
mov esp, [tmpStack]
ret

;-----------------Ч Imports Ч---------------------------------------------------Ч

section '.idata' import data readable
library kernel, 'kernel32.dll',\
msvcrt, 'msvcrt.dll',\
user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
import kernel,\
ExitProcess, 'ExitProcess',\
HeapCreate,'HeapCreate',\
HeapAlloc,'HeapAlloc'
include 'api\kernel32.inc'
import msvcrt,\
printf, 'printf',\
scanf, 'scanf',\
getch, '_getch'