
INCLUDELIB kernel32.lib
ExitProcess PROTO
; CreateFileA PROTO
; ReadFile PROTO

.DATA
; filename BYTE "./input.txt", 0  ; input file name
input BYTE 256 DUP (0)          ; buffer, temp size
; handle HANDLE ?                 ; file handle

.CODE
main PROC

; SUB RSP, 32     ; Windows

; open file
; stack arguments, reverse order?
; PUSH 0                          ; template file, ignored when opening files
; PUSH 128                        ; file attribute: FILE_ATTRIBUTE_NORMAL
; PUSH 3                          ; OPEN_EXISTING
; MOV R9, 0                       ; no security attributes
; MOV R8, 1                       ; share mode: FILE_SHARE_READ
; MOV RDX, GENERIC_READ           ; read permission
; LEA RCX, filename               ; name of file
; CALL CreateFileA                ; open file
; ADD RSP, 24                     ; free stack
; 
; MOV hfile, RAX                  ; save file handle

; Read from file


; ADD RSP, 32     ; /Windows

CALL ExitProcess
main ENDP

END