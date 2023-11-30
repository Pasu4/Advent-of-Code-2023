INCLUDELIB kernel32.lib
ExitProcess PROTO

.DATA
file BYTE "input.txt", 0

.CODE
main PROC
CALL ExitProcess
main ENDP

END