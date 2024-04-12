CSEG SEGMENT para public "CODE"
  assume CS:CSEG, DS:CSEG
  org 100h

  main:
    jmp init
    timestamp db 0
    speed db 00011111b
    old_inter dd ?
    flag db 42
    init_msg db "lab_06 initialised$"
    stop_msg db "lab_06 stopped$"

  change_speed proc near:
    mov al, 00f3h
    out 60h, al
    mov al, speed
    out 60h, al

    dec speed
    cmp speed, 00000000b
    jne noreset

    mov speed, 00011111b

    noreset:

    ret
  change_speed endp

  inter proc:
    pushf

    call ptr old_inter

    mov ah, 02h ; CH:CL:DH <- Время
    int 1h      ; 1h - Для работы с таймером

    cmp dh, timestamp
    je skip
      mov timestamp, dh

      call change_speed

    skip:
    popf
    
    ret
  inter endp

  init proc near:
    mov ax, 3508h ; 35h -> получить старые данные о прерывании 08h
    int 21h       ;es - адрес сегмента
                  ;bx - смещение.

    cmp es:flag, 42 ; если мой флажок
    je remove

    mov word ptr old_inter, bx
    mov word ptr old_inter + 1, es

    mov ax, 2508h ; 25h -> установить в таблицу адрес прерывания 08h
    mov dx, offset inter
    int 21h

    mov ah, 09h
    mov dx, offset init_msg
    int 21h

    mov dx, offset init
    int 27h
  init endp

  remove proc near:
    mov al, 0f3h
    out 60h, al
    mov al, 0
    out 60h, al

    mov dx, word ptr old_inter
    mov ds, word ptr old_inter + 2
    mov ax, 2508h

    mov ah, 09h
    mov dx, offset stop_msg
    int 21h

    mov ax, 4c00h
    int 21h
  remove endp

CSEG ENDS

END main
