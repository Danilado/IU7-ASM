.MODEL tiny 

CSEG SEGMENT 
    assume CS:CSEG
    org 100h

    main:
        jmp init

        speed db 00011111b
        flag db 42
        timestamp db 0
        old_handler dd 0

    inter proc near
        pushf
        call cs:old_handler

        mov ah, 02h ; CH:CL:DH
        int 1ah

        cmp dh, timestamp
        je no_change_speed

        mov timestamp, dh
        dec speed

        mov al, 0F3h
        out 60h, al
        mov al, speed
        out 60h, al

        cmp speed, 0
        jne no_change_speed

        mov speed, 011111b

        no_change_speed:

        iret
    inter endp

    init:
        mov ax, 351ch ; предыдущее прерывание
        int 21h

        cmp es:flag, 42   
        je remove                  

        mov word ptr old_handler, bx
        mov word ptr old_handler + 2, es

        mov ax, 251ch
        mov dx, offset inter
        int 21h

        mov dx, offset init_msg
        mov ah, 09h
        int 21h

        mov ah, 27h
        mov dx, offset init ; init - последий байт программы (не обработчик прерывашки)
        int 27h             ; Делаем резидентом

    remove:
        mov dx, offset exit_msg
        mov ah, 09h
        int 21h

        mov al, 0F3h
        out 60h, al
        mov al, 0
        out 60h, al

        mov dx, word ptr es:old_handler
        mov ds, word ptr es:old_handler + 2
        mov ax, 251ch
        int 21h

        mov ah, 49h
        int 21h

        mov ax, 4c00h
        int 21h

        init_msg db "lab_06 init", 10, 13, '$'
        exit_msg db "lab_06 stop", 10, 13, '$'
CSEG ENDS
END MAIN
    