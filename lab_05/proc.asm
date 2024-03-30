extrn NUM: WORD         ; main
extrn endl: near        ; utils

public bin_processing

DSEG SEGMENT para public USE16 'DATA'
        out_buf db ' ', '$'
        proc_res db 0
DSEG ENDS

CSEG SEGMENT para public USE16 'CODE'
        assume DS:DSEG

print_proc_res proc near
        mov cl, proc_res
        cmp cl, 10
        jb one_digit_res
                mov al, '1'
                mov out_buf[0], al

                mov ah, 9
                mov dx, offset out_buf
                int 21h

                sub cl, 10
        one_digit_res:

        mov al, cl
        add al, '0'
        mov out_buf[0], al

        mov ah, 9
        mov dx, offset out_buf
        int 21h

        ret
print_proc_res endp

process_bin proc near
        mov ax, NUM
        xor bx, bx
        xor cx, cx

        bin_proc_loop:
                cmp bx, 16
                jge bin_proc_loop_end
                
                cmp ax, 0
                je bin_proc_loop_end

                        sar ax, 1      ; ax >> 1
                        inc bx
                jmp bin_proc_loop
        bin_proc_loop_end:
        
        inc bx
        mov proc_res, bl

        ret
process_bin endp

bin_processing proc near
        call process_bin
        call print_proc_res
        call endl

        ret
bin_processing endp

CSEG ENDS

END