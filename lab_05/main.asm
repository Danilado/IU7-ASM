; IN: знаковое в 8 с/с
; OUT1: беззнаковое в 2 с/с
; OUT2: знаковое в 16 с/с 
; 2-й вариант

public NUM

extrn input_number: near       ; input
extrn output_ubin: near        ; bin
extrn output_hex: near         ; hex
extrn bin_processing: near     ; proc

extrn endl: near               ; utils
extrn get_cmd: near            ; utils

STK SEGMENT para STACK USE16 'STACK'
        db 4096 dup(0)
STK ENDS

DSEG SEGMENT para public USE16 'DATA' 
        NUM dw 0

        menu_text db 'Menu:', 13, 10, 10
        db '0: Exit', 13, 10
        db '1: Input number (signed oct)', 13, 10
        db '2: Convert to unsigned binary', 13, 10
        db '3: Truncate and convert to signed hexadecimal', 13, 10
        db '4: Find power of 2 to overcome unsigned number', 13, 10, 10
        db '> $'

        options dw exit, input_number, output_ubin, output_hex, bin_processing
DSEG ENDS

CSEG SEGMENT para public USE16 'CODE' 
        assume DS:DSEG, SS:STK

print_menu proc near
        xor ax, ax
        mov ah, 9h
        mov dx, offset menu_text
        int 21h
        ret
print_menu endp

exit proc near
        mov ax, 4c00h
        int 21h
        ret
exit endp

main:
        mov ax, STK
        mov ss, ax

        mov ax, DSEG
        mov ds, ax

        mov bx, offset options

        main_loop:
                call print_menu
                call get_cmd ; ввод цифры, умножение её на 2 -> si
                call endl
                call DSEG:options[si]
        jmp main_loop

CSEG ENDS

END main