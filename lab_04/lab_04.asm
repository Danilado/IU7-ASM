; Цифровая матрица
; прямоугольная
; заменить строку с наибольшей суммой цифр последней строкой

STK SEGMENT para STACK
        db 1000 dup(0)
STK ENDS

D1 SEGMENT para public 'DATA'
        MATRIX db 9 * 9 * 1 dup(0)
        I db 0
        ROWS db 0
        COLS db 0
        SUM dw 0
        MAXSUM dw 0
        MAXSUMI db 0
        BUFCX dw 0
D1 ENDS

CSEG SEGMENT para public 'CODE'
        assume DS:D1, SS:STK

endl proc near
        mov ah, 02
        mov dl, 13
        int 21h
        mov dl, 10
        int 21h
        ret
endl endp

space proc near
        mov ah, 02
        mov dl, 32 
        int 21h
        ret
space endp

input_rows proc near
        mov ah, 01h
        int 21h
        sub al, '0'
        mov ds:ROWS, al
        call endl
        ret
input_rows endp

input_cols proc near
        mov ah, 01h
        int 21h
        sub al, '0'
        mov ds:COLS, al
        call endl
        ret
input_cols endp

input_matrix proc near
        xor ax, ax
        mov al, ROWS
        mul COLS

        mov bx, offset MATRIX
        mov di, 0
        
        mov cx, ax
input_matrix_loop:
        mov ah, 01h
        int 21h
        sub al, '0'

        mov [bx + di], al

        mov ax, di
        inc ax
        div COLS
        cmp ah, 0

        call space
        jne noendl ; если остаток i%COLS != 0 не делаем \n
        call endl
noendl:

        inc di
        loop input_matrix_loop

        ret
input_matrix endp

find_row_sum proc near
        mov BUFCX, cx
        xor cx, cx
        mov cl, COLS

        mov SUM, 0
        mov al, I

        mul COLS
        mov di, ax
        
        mov bx, offset MATRIX

find_row_sum_loop:
        mov ax, SUM
        add al, [bx + di]
        mov SUM, ax

        inc di
        loop find_row_sum_loop

        mov cx, BUFCX
        ret
find_row_sum endp

find_maxsum_i proc near
        mov I, 0
        mov MAXSUMI, 0
        mov MAXSUM, 0

        xor cx, cx
        mov cl, ROWS
find_maxsum_i_loop:
        call find_row_sum

        mov ax, MAXSUM
        cmp SUM, ax
        jl no_new_max

        mov ax, SUM
        mov MAXSUM, ax
        xor ax, ax
        mov al, I
        mov MAXSUMI, al

no_new_max:
        inc I
        loop find_maxsum_i_loop

        ret
find_maxsum_i endp

replace_maxsum_i proc near
        mov bx, offset MATRIX

        xor ax, ax
        mov al, MAXSUMI
        mul COLS
        mov di, ax

        xor ax, ax
        mov al, ROWS
        dec ax
        mul COLS
        mov si, ax

        xor cx, cx
        mov cl, COLS
replace_row_loop:
        mov al, [bx + si]
        mov [bx + di], al

        inc bx
        loop replace_row_loop

        ret
replace_maxsum_i endp

print_matrix proc near
        mov bx, offset MATRIX
        mov si, 0

        xor ax, ax
        mov al, ROWS
        mul COLS

        mov cx, ax
        xor ax, ax
print_matrix_loop:
        mov ah, 02
        mov dl, [bx + si]
        add dl, '0'
        int 21h

        call space

        inc si

        mov ax, si
        div COLS
        cmp ah, 0
        jne noendlprint
        call endl
noendlprint:

        loop print_matrix_loop

        ret
print_matrix endp

main:
        mov ax, STK
        mov ss, ax 

        mov ax, D1
        mov ds, ax

        call input_rows
        call input_cols
        call input_matrix
        call endl
        call find_maxsum_i
        call replace_maxsum_i
        call print_matrix

        mov ax, 4c00h
        int 21h
CSEG ENDS

END main
