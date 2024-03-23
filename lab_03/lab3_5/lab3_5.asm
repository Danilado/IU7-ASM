STK SEGMENT para STACK 'STACK'
        db 100 dup(0)
STK ENDS

DS1 SEGMENT para public 'DATA'
        NUM1 db 0
        NUM2 db 0
DS1 ENDS

DS2 SEGMENT para public 'DATA'
        db 0
        SUM db 0
DS2 ENDS

CSEG SEGMENT para public 'CODE'
        assume DS:DS1, ES:DS2, SS:STK

endl proc near
        mov ah, 02
        mov dl, 13
        int 21h
        mov dl, 10
        int 21h
        ret
endl endp

main:
        mov ax, DS1
        mov ds, ax

        mov ax, DS2
        mov es, ax

        xor ax, ax
        mov ah, 01h ; считать
        int 21h
        sub al, '0'
        mov NUM1, al

        call endl
        
        mov ah, 01h ; считать
        int 21h
        sub al, '0'
        mov NUM2, al

        call endl

        xor ax, ax
        add al, NUM1
        add al, NUM2
        add al, '0'
        mov SUM, al

        mov dl, SUM
        mov ah, 02
        int 21h

        call endl

        mov ax, 4c00h
        int 21h
CSEG ENDS

END main
