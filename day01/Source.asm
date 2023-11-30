INCLUDELIB kernel32.lib
ExitProcess PROTO
CreateFileA PROTO
ReadFile PROTO
GetLastError PROTO

.DATA
file_name BYTE ".\input.txt", 0 ; file name
file_handle QWORD ?             ; file handle
buffer BYTE 256 DUP (0)         ; buffer, temp size
_ QWORD ?                       ; discard

.CODE
main PROC


; open file
; stack arguments, 3 QWORDs
PUSH 0                          ; 7: template file, ignored when opening files (NULL)
PUSH 128                        ; 6: file attribute: FILE_ATTRIBUTE_NORMAL
PUSH 3                          ; 5: file mode: OPEN_EXISTING
MOV R9, 0                       ; 4: no security attributes (NULL)
MOV R8, 0                       ; 3: share mode: ???
MOV RDX, 3                      ; 2: read permission
LEA RCX, file_name              ; 1: name of file
SUB RSP, 4*8                    ; reserve 4 QWORDs
CALL CreateFileA                ; open file
ADD RSP, 7*8                    ; free 7 QWORDs

MOV file_handle, RAX            ; save file handle

; Read from file
; stack argument, 1 QWORD
PUSH 0                          ; 5: overlap flag (NULL)
LEA R9, _                       ; 4: actual length read (discard)
MOV R8, LENGTHOF buffer         ; 3: max number of bytes to read
LEA RDX, buffer                 ; 2: pointer to buffer
MOV RCX, file_handle            ; 1: file handle
SUB RSP, 32                     ; reserve 4 QWORDs
CALL ReadFile                   ; read file
ADD RSP, 5*8                    ; free 5 QWORDS


CALL GetLastError

CALL ExitProcess
main ENDP

END