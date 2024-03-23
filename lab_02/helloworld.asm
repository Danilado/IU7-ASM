StkSeg SEGMENT PARA STACK 'STACK'
  DB 200h DUP (?)
StkSeg    ENDS

DataS SEGMENT WORD 'DATA'
HelloMessage  DB 'Hello, world!'
              DB 13 ; "\r"
              DB 10 ; "\n"
              DB '$'

Endl          DB 10
              DB 13
              DB '$'
DataS ENDS

Code SEGMENT WORD 'CODE'
  ASSUME  CS:Code, DS:DataS
DispMsg:
  mov AX,DataS
  mov DS,AX

  mov CX, 3
  mov DX, OFFSET HelloMessage
  mov AH, 9
message_loop:
  int 21h
  loop message_loop

  mov AH,7
  int 21h

  mov AH,4Ch
  int 21h
Code ENDS
END DispMsg
