INCLUDELIB kernel32.lib
ExitProcess PROTO
CreateFileA PROTO
ReadFile PROTO
GetLastError PROTO
GetStdHandle PROTO
WriteConsoleA PROTO

; Check a letter or jump to char_done if there is no more letter in the buffer
check_letter MACRO index, letter
    DEC RCX
    JZ char_done
    MOV R11B, [digit_buffer+index]
    CMP R11B, letter
    JNE not_a_digit
ENDM

found_digit MACRO digit, unique_label
    MOV R11B, digit             ; load digit
    CMP first_num, 255          ; if first number is set
    JNE unique_label            ; skip setting first number
    MOV first_num, R11B         ; save digit as first number
    unique_label:
    MOV last_num, R11B          ; save digit as last number
    JMP not_a_digit             ; is a digit, but could partly contain another digit
ENDM

.DATA
file_name BYTE ".\input.txt", 0 ; file name
file_handle QWORD ?             ; file handle
stdout QWORD ?                  ; output handle
buffer BYTE 1024 DUP (0)        ; buffer, 1 KiB
                                ; not enough for whole input, read from file in 1 KiB units
first_num BYTE 255              ; first number in line (255 if not set)
last_num BYTE 0                 ; last number in line (current assumption)
digit_buffer BYTE 8 DUP (0)     ; buffer for parsing a written digit
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
XOR R13, R13                        ; clear index of digit buffer

; Load more data into the input buffer
get_more_input:
    ; Save registers
    PUSH R13                        ; length of digit buffer

    ; Read from file
    ; stack argument, 1 QWORD
    PUSH 0                          ; 5: overlap flag (NULL)
    LEA R9, len                     ; 4: actual length read
    MOV R8, LENGTHOF buffer         ; 3: max number of bytes to read
    LEA RDX, buffer                 ; 2: pointer to buffer
    MOV RCX, file_handle            ; 1: file handle
    SUB RSP, 4*8                    ; reserve 4 QWORDs
    CALL ReadFile                   ; read file

    CALL GetLastError               ; check if there was an error
    ADD RSP, 5*8                    ; free 7 QWORDs
    CMP RAX, 0                      ; compare to 0 (OK)
    JNE file_error                  ; jump if there was an error

    ; Reload registers
    XOR R12, R12                    ; number of bytes read currently (0)
    LEA R10, buffer                 ; pointer to buffer
    POP R13                         ; length of digit buffer
    
    CMP len, 0                      ; check if chars were read
    JE parse_done                   ; parsing is done if no more chars can be read

; Take the next char and see if it is a number
next_char:
    MOV R11B, [R10]                 ; get next char from buffer
    CMP R11B, 10                    ; compare to LN
    JE line_done                    ; jump if line is done
    CMP R11B, 13                    ; compare to CR
    JE char_done                    ; skip if it is CR
    CMP R11B, '0'                   ; compare to '0'
    JB is_letter                    ; handle letter if below '0'
    CMP R11B, '9'                   ; compare to '9'
    JA is_letter                    ; handle letter if above '9'

    XOR R13, R13                    ; clear length of digit buffer
    SUB R11B, '0'                   ; char to number

; Number has been found
found_number:
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

; When a letter is encountered
is_letter:
    ; #region Parse digit
    LEA R14, digit_buffer           ; load address of digit buffer
    ADD R14, R13                    ; add length of buffer
    MOV [R14], R11B                 ; append letter to buffer
    INC R13                         ; increment length

    ; Check for letters in the buffer
    ; If the letters cannot match a digit, delete the first char, shift left and try again
check_letters:
    MOV RCX, R13                    ; copy length to RCX for parsing (must be decremented)
    MOV R11B, [digit_buffer]
    CMP R11B, 'o'                   ; is first char 'o'?
    JE _d_o                         ;   could match "one"
    CMP R11B, 't'                   ; is first char 't'?
    JE _d_t                         ;   could match "two", "three"
    CMP R11B, 'f'                   ; is first char 'f'?
    JE _d_f                         ;   could match "four", "five"
    CMP R11B, 's'                   ; is first char 's'?
    JE _d_s                         ;   could match "six", "seven"
    CMP R11B, 'e'                   ; is first char 'e'?
    JE _d_e                         ;   could match "eight"
    CMP R11B, 'n'                   ; is first char 'n'?
    JE _d_n                         ;   could match "nine"
    JMP not_a_digit                 ; a letter cannot start with this char

    _d_t:                               ; could match "two", "three"
        DEC RCX                         ; if this becomes zero, end of buffer is reached
        JZ char_done                    ; cannot continue until next char is read

        MOV R11B, [digit_buffer+1]
        CMP R11B, 'w'
        JE _d_tw
        CMP R11B, 'h'
        JE _d_th
        JMP not_a_digit                 ; 't' not followed by 'w' or 'h' cannot be a digit

    _d_f:                               ; could match "four", "five"
        DEC RCX
        JZ char_done

        MOV R11B, [digit_buffer+1]
        CMP R11B, 'o'
        JE _d_fo
        CMP R11B, 'i'
        JE _d_fi
        JMP not_a_digit                 ; 'f' not followed by 'o' or 'i' cannot be a digit

    _d_s:                               ; could match "six", "seven"
        DEC RCX
        JZ char_done

        MOV R11B, [digit_buffer+1]
        CMP R11B, 'i'
        JE _d_si
        CMP R11B, 'e'
        JE _d_se
        JMP not_a_digit                 ; 's' not followed by 'i' or 'e' cannot be a digit

    _d_o:                               ; could match "one"
        check_letter 1, 'n'             ; check if second letter is 'n'
        check_letter 2, 'e'             ; check if third letter is 'e'

        found_digit 1, digit1           ; 1 was found

    _d_tw:                              ; could match "two"
        check_letter 2, 'o'

        found_digit 2, digit2

    _d_th:                              ; could match "three"
        check_letter 2, 'r'
        check_letter 3, 'e'
        check_letter 4, 'e'

        found_digit 3, digit3

    _d_fo:                              ; could match "four"
        check_letter 2, 'u'
        check_letter 3, 'r'

        found_digit 4, digit4

    _d_fi:                              ; could match "five"
        check_letter 2, 'v'
        check_letter 3, 'e'

        found_digit 5, digit5

    _d_si:                              ; could match "six"
        check_letter 2, 'x'

        found_digit 6, digit6

    _d_se:                              ; could match "seven"
        check_letter 2, 'v'
        check_letter 3, 'e'
        check_letter 4, 'n'

        found_digit 7, digit7

    _d_e:                               ; could match "eight"
        check_letter 1, 'i'
        check_letter 2, 'g'
        check_letter 3, 'h'
        check_letter 4, 't'

        found_digit 8, digit8

    _d_n:                               ; could match "nine"
        check_letter 1, 'i'
        check_letter 2, 'n'
        check_letter 3, 'e'

        found_digit 9, digit9

; If it does not match any digit
not_a_digit:
    DEC R13                         ; decrease length
    JZ char_done                    ; no more chars in the buffer

    ; Shift buffer left
    MOV RCX, R13                    ; number of loops = length - 1 (which R13 currently is)
    LEA RDX, digit_buffer           ; load pointer to buffer
    shift_buffer:
        MOV AL, [RDX+1]             ; load next char
        MOV [RDX], AL               ; replace current char
        INC RDX                     ; point to next char
    LOOP shift_buffer

    JMP check_letters               ; try again with next char
    ; #endregion

; LN was encountered (line done parsing)
line_done:
    XOR RAX, RAX                    ; clear RAX
    XOR RBX, RBX                    ; clear RBX
    XOR R13, R13                    ; clear length of digit buffer
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