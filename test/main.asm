;Написать резидентную программу под DOS, которая будет каждую секунду менять
;скорость автоповтора ввода символов в циклическом режиме, от самой медленной до
;самой быстрой. По желанию можно реализовать другой способ взаимодействия с
;устройствами через порты ввода-вывода, но такой, который можно будет
;наглядно продемонстрировать на сдаче лаб. работы.

;Вариант вызова предшествующего обработчика прерывания:
;Командой дальнего безусловного перехода JMP в конце 
;обработчика прерывания, сохранив адрес перехода в 
;переменной.

.model tiny

CSEG SEGMENT
    assume CS:CSEG, DS:CSEG
    org 100h
main:
    jmp init
    
    before_addr dd 0
    cur_speed db 1Fh
    cur_time db 0
    init_msg db 'Handler installed.', 0Dh, 0Ah, '$'
    exit_msg db 'Handler uninstalled.', 0Dh, 0Ah, '$'

inc_input_speed proc
    pushf
    
    call cs:before_addr

    push ax
    push cx
    push dx
    push ds
    
    mov ax, 0
    mov ah, 2ch
    int 21h

    cmp dh, cur_time
    je skip_speed_change

    mov cur_time, dh
    
    cmp cur_speed, 0h
    je reset_speed 

    dec cur_speed
    
    cmp cur_speed, 1Fh
    jbe set_speed

set_speed:
    mov al, 0F3h
    out 60h, al

    mov al, cur_speed
    out 60h, al
    jmp skip_speed_change

reset_speed:
    mov cur_speed, 1Fh

skip_speed_change:
    pop dx
    pop cx
    pop ax
    pop ds

    iret

inc_input_speed endp

init:
    mov ax, 3508h
    int 21h

    cmp bx, offset inc_input_speed
    je exit

    mov word ptr before_addr, bx
    mov word ptr before_addr[2], es

    mov ax, 2508h
    mov dx, offset inc_input_speed
    int 21h

    mov dx, offset init_msg
    mov ah, 09h
    int 21h

    mov dx, offset init
    int 27h

exit:
    mov dx, offset exit_msg
    mov ah, 09h
    int 21h
    
    mov al, 0F3h
    out 60h, al

    mov al, 0
    out 60h, al
    
    mov dx, word ptr es:before_addr
    mov ds, word ptr es:before_addr[2]
    mov ax, 2508h
    int 21h

    mov ax, 4C00h
    int 21h

CSEG ENDS
END main
