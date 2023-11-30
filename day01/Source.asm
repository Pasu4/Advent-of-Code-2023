INCLUDELIB kernel32.lib
ExitProcess PROTO

.DATA

.CODE
main PROC
CALL ExitProcess
main ENDP

END