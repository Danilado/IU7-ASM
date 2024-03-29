public endl
public input_digit
public get_cmd

DSEG SEGMENT para public USE16 'DATA'
        endl_text db 13, 10, '$'
DSEG ENDS


CSEG SEGMENT para public USE16 'CODE'
endl proc near
        xor ax, ax
        mov ah, 9
        mov dx, offset endl_text
        int 21h
        ret
endl endp

input_digit proc near
        mov ah, 1
        int 21h
        xor ah, ah
        sub al, '0'
        ret
input_digit endp

get_cmd proc near
        call input_digit
        mov dl, 2
        mul dl
        mov si, ax
        ret
get_cmd endp

CSEG ENDS

END