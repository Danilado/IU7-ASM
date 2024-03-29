extrn NUM: WORD     ; main
extrn endl: near
extrn input_digit: near

public input_number
public sign

DSEG SEGMENT para public USE16 'DATA'
        sign db 0
        i_prompt db 'Enter signed octal number (sign is necessary): $'
DSEG ENDS

CSEG SEGMENT para public USE16 'CODE'
        assume DS:DSEG

input_sign proc near
        mov ah, 1
        int 21h

        cmp al, '-'
        jne positive
                mov sign, 1
                jmp sign_flag_setter_end
        positive:
                mov sign, 0
        sign_flag_setter_end:
        ret
input_sign endp

prompt proc near
        xor ax, ax
        mov ah, 9
        mov dx, offset i_prompt
        int 21h
        ret
prompt endp

input_number proc near
        call prompt
        call input_sign

        xor dx, dx
        xor cx, cx
        mov cl, 3       ; 8-я система, одна цифра - 3 двоичных

        number_input_loop:
                mov ah, 1
                int 21h

                cmp al, 13      ; 0d == 13 == '\r'
                je number_input_loop_break
                        sub al, '0'
                        
                        sal dx, cl
                        add dl, al
                jmp number_input_loop
        number_input_loop_break:
        mov NUM, dx

        call endl
        
        cmp sign, 1
        jne not_neg
                neg NUM
        not_neg:
        ret
input_number endp

CSEG ENDS

END