extrn NUM: WORD         ; main
extrn endl: near        ; utils
public output_ubin

DSEG SEGMENT para public USE16 'DATA'
        last_bit_mask dw 1 ; 0000....0001
        unbin_text db 16 dup(0), '$'
DSEG ENDS


CSEG SEGMENT para public USE16 'CODE'
        assume DS:DSEG

build_ubin proc near
        mov ax, NUM
        mov di, 15

        set_bit_loop:
                mov dx, ax
                and dx, last_bit_mask
                add dl, '0'
                mov unbin_text[di], dl

                dec di
                mov cl, 1
                sar ax, cl      ; ax >> 1

                cmp di, -1
                jne set_bit_loop
        ret
build_ubin endp

output_ubin proc near
        call build_ubin

        mov ah, 9
        mov dx, offset unbin_text
        int 21h

        call endl

        ret
output_ubin endp

CSEG ENDS

END