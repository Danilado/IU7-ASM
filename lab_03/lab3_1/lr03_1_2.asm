PUBLIC output_X
EXTRN X: byte

DS2 SEGMENT AT 0b800h ; сегмент начинается с 0800h
	      ; первый адрес на 08000h, видеопамять
	CA LABEL byte ; на начало сегмента
	; установить смещение для след. команд
	; 80 символов в строке 2 строки по 2 байта на символ + ещё 2 символа
	ORG 80 * 2 * 2 + 2 * 2
	SYMB LABEL word ; указатель на 2 байта с учётом смещения
DS2 ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, ES:DS2
output_X proc near
	mov ax, DS2 
	mov es, ax

	mov ah, 10
	mov al, X
	; ax = 10(X)

	mov symb, ax
	ret ; вернуться туда, откуда вызвали
output_X endp
CSEG ENDS
END