.MODEL TINY
.DOSSEG

.CODE

.STARTUP
    mov ah, 40h         ; печатай в поток вывода
    ;mov bx, 1           ; поток вывода stdout

    mov cl, ds:[0080h]  ; печатать столько символов, какое значение написано в 0080h
    mov dx, [0082h]       ; начинай печатать отсюда
    int 21h             ; фигачим

    ; mov ah, 09h
    ; mov dx, OFFSET ENDL
    ; int 21h      

    mov AH, 4Ch
    int 21h
END
