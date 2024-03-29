extrn NUM: WORD         ; main
extrn endl: near

public output_hex

DSEG SEGMENT para public USE16 'DATA'
        sign_text db '+', '$'
        hex_text db 2 dup(0), '$'
        last_4bit_mask dw 15
        charmask dw 01111111b
        charsignmask dw 10000000b
DSEG ENDS

CSEG SEGMENT para public USE16 'CODE'
        assume DS:DSEG

output_sign proc near
        mov ax, NUM
        and ax, charsignmask
        cmp ax, 0

        jne negative
                mov al, '+'
                mov sign_text[0], al
        jmp sign_out_end
        negative:
                mov al, '-'
                mov sign_text[0], al
        sign_out_end:

        mov ah, 9
        mov dx, offset sign_text
        int 21h

        ret
output_sign endp

build_shex proc near
        mov ax, NUM
        and ax, charmask

        mov di, 1       ; 2 т.к. обрезаем до char

        set_4bit_loop:
                mov dx, ax
                and dx, last_4bit_mask
                cmp dl, 10
                jb hexconv_isdigit
                        sub dl, 10
                        add dl, 'A'
                        jmp hexconv_ifdigit_end
                hexconv_isdigit:
                        add dl, '0'
                hexconv_ifdigit_end:
                
                mov hex_text[di], dl

                dec di
                mov cl, 4
                sar ax, cl      ; ax >> 4
 
                cmp di, -1
                jne set_4bit_loop
        ret
build_shex endp

output_hex proc near
        call output_sign
        call build_shex

        mov ah, 9
        mov dx, offset hex_text
        int 21h

        call endl
        
        ret
output_hex endp

CSEG ENDS

END