INCLUDELIB kernel32.lib
ExitProcess PROTO
CreateFileA PROTO
ReadFile PROTO
GetLastError PROTO
GetStdHandle PROTO
WriteConsoleA PROTO

.DATA
file_name BYTE ".\input.txt", 0 ; file name
file_handle QWORD ?             ; file handle
stdout QWORD ?                  ; output handle
buffer BYTE 256 DUP (0)         ; buffer, temp size
len QWORD ?                     ; length read from file
_ QWORD ?                       ; discard

; Output texts
err_file BYTE "Could not read file", 0    ; file read error message

.CODE
main PROC

; Get console handle
MOV RCX, -11                    ; 1: output device code
SUB RSP, 4*8                    ; reserve 4 QWORDs
CALL GetStdHandle               ; get output handle
ADD RSP, 4*8                    ; free 4 QWORDs
MOV stdout, RAX                 ; save output handle

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
MOV file_handle, RAX            ; save file handle

CALL GetLastError               ; check if there was an error
ADD RSP, 7*8                    ; free 7 QWORDs
CMP RAX, 0                      ; compare to 0 (OK)
JNE file_error                  ; jump if there was an error

; Read from file
; stack argument, 1 QWORD
PUSH 0                          ; 5: overlap flag (NULL)
LEA R9, len                     ; 4: actual length read
MOV R8, LENGTHOF buffer         ; 3: max number of bytes to read
LEA RDX, buffer                 ; 2: pointer to buffer
MOV RCX, file_handle            ; 1: file handle
SUB RSP, 32                     ; reserve 4 QWORDs
CALL ReadFile                   ; read file

CALL GetLastError               ; check if there was an error
ADD RSP, 7*8                    ; free 7 QWORDs
CMP RAX, 0                      ; compare to 0 (OK)
JNE file_error                  ; jump if there was an error

; Print to console
LEA R9, _                       ; 4: discard actual length written
MOV R8, len                     ; 3: print as many characters as were read from the file
LEA RDX, buffer                 ; 2: pointer to buffer to write
MOV RCX, stdout                 ; 1: output handle
SUB RSP, 4*8                    ; reserve 4 QWORDs
CALL WriteConsoleA              ; get output handle
ADD RSP, 4*8                    ; free 4 QWORDs

CALL ExitProcess

; Handle file read error
file_error:
    ; Output to console
    LEA R9, _                       ; 4: discard actual length written
    MOV R8, LENGTHOF err_file       ; 3: print as many characters as were read from the file
    LEA RDX, err_file               ; 2: pointer to error message
    MOV RCX, stdout                 ; 1: output handle
    SUB RSP, 4*8                    ; reserve 4 QWORDs
    CALL WriteConsoleA              ; get output handle
    ADD RSP, 4*8                    ; free 4 QWORDs

    CALL ExitProcess

main ENDP

END