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
buffer BYTE 1024 DUP (0)        ; buffer, 1 KiB
                                ; not enough for whole input, read from file in 1 KiB units
first_num BYTE 255              ; first number in line (255 if not set)
last_num BYTE 0                 ; last number in line (current assumption)
calibration QWORD 0             ; sum of calibration values
len QWORD ?                     ; length read from file
out_buffer BYTE 21 DUP (' ')    ; output buffer, fill with SP, max 20 digits

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

; Initialize registers

; Load more data into the input buffer
get_more_input:
    ; Save registers


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

    CMP len, 0                      ; check if chars were read
    JE parse_done                   ; parsing is done if no more chars can be read

    ; Reload registers
    XOR R12, R12                    ; number of bytes read currently (0)
    LEA R10, buffer                 ; pointer to buffer

; Take the next char and see if it is a number
next_char:
    MOV R11B, [R10]                 ; get next char from buffer
    CMP R11B, 10                    ; compare to LN
    JE line_done                    ; jump if line is done
    CMP R11B, '0'                   ; compare to '0'
    JB char_done                    ; skip if below '0'
    CMP R11B, '9'                   ; compare to '9'
    JA char_done                    ; skip if above '9'

    SUB R11B, '0'                   ; char to number
    CMP first_num, 255              ; check if first number is set
    JNE set_last_num                ; update the last number if the first exists
    MOV first_num, R11B             ; set first number         

; Set the last number (can be the same as first number)
set_last_num:
    MOV last_num, R11B              ; update last number

; Parsing of the char is done
char_done:
    INC R10                         ; increment next address
    INC R12                         ; increment number of read bytes
    CMP R12, len                    ; compare to amount of read bytes
    JNE next_char                   ; get next char if max not reached
    CMP len, LENGTHOF buffer        ; check if buffer was filled to the end
    JNE parse_done                  ; if not, parsing is done
    JMP get_more_input              ; get more input if it is empty

; LN was encountered (line done parsing)
line_done:
    XOR RAX, RAX                    ; clear RAX
    XOR RBX, RBX                    ; clear RBX
    MOV AL, first_num               ; load first number
    MOV BL, 10                      ; MUL takes no immediates
    MUL BL                          ; multiply by 10 (result => RAX)
    ADD AL, last_num                ; add last number
    ADD calibration, RAX            ; add to calibration sum
    MOV first_num, 255              ; reset first number (last number does not matter)
    JMP char_done                   ; char is done

; When all input has been parsed
parse_done:
    ; Convert to decimal
    MOV RCX, 20                     ; max 20 decimal digits in 64 bits
    LEA R10, out_buffer+19          ; start at last digit
    MOV R11, 10                     ; 10
    MOV RAX, calibration            ; load calibration
    conv_dec:
        XOR RDX, RDX                ; clear RDX because it crashes otherwise
        DIV R11                     ; divide by 10 (result => RAX, mod => RDX)
        ADD RDX, '0'                ; number to char
        MOV [R10], DL               ; write to buffer
        DEC R10                     ; next digit to the left
    LOOP conv_dec

    ; Print to console
    LEA R9, _                       ; 4: discard actual length written
    MOV R8, LENGTHOF out_buffer     ; 3: print as many characters as were read from the file
    LEA RDX, out_buffer             ; 2: pointer to buffer to write
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