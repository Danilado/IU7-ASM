.MODEL tiny 

CSEG SEGMENT 
    assume CS:CSEG
    org 100h            

    main:
        jmp init
        
        speed db 00011111b
        flag db 42
        cur_time db 0
        old_handler dd 0

    handler proc near
        pushf
        ; call dword ptr CS:old_handler

        mov ah, 02h ; CH:CL:DH
        int 1ah

        cmp dh, cur_time    
        je no_change_speed  

        mov cur_time, dh    
        dec speed           

        mov al, 0F3h
        out 60h, al 
        mov al, speed
        out 60h, al

        cmp speed, 0
        jne no_change_speed

        mov speed, 011111b

        no_change_speed:

        popf
        iret
    HANDLER endp

    init:       
        mov ax, 351ch ; предыдущее прерывание
        int 21h

        cmp es:flag, 42   
        je remove                  

        mov word ptr old_handler, bx  
        mov word ptr old_handler + 2, es    

        mov ax, 251ch              
        mov dx, offset HANDLER
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

        ;устанавливаем период автоповтора 30.0, задержку включения режима автоповтора 250 мс (восстанавливаем дефолтные значения)
        mov al, 0
        out 60h, al                 
        
        ; устанавливаем период автоповтора 30.0, задержку включения режима автоповтора 250 мс (восстанавливаем дефолтные значения)
        mov dx, word ptr es:old_handler                       
        mov ds, word ptr es:old_handler + 2
        mov ax, 251ch
        int 21h                  

        mov ah, 49h                         
        int 21h

        mov ax, 4c00h
        int 21h

        init_msg db 'lab_06 init$'   
        exit_msg db 'lab_06 stop$'
CSEG ENDS
END MAIN
    