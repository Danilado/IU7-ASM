bits 64

global _copy_string

section .text
; User-level applications use as integer registers for passing the sequence 
; %rdi, %rsi, %rdx, %rcx, %r8 and %r9. 
; The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9.
;                             ^     ^     ^     ^
;                           arg1  arg2  arg3 ....

; rdi -> char* dst
; rsi -> char* src
; rdx -> size_t length 
_copy_string:
        mov rcx, rdx

        cmp rsi, rdi
        je skip         ; dst == src
        jl backwards    ; if src < dst

                inc rcx ; чтобы учитывать \0
                rep movsb ; копировать rsi в rdi rcx раз
                jmp skip

backwards:              ; dst > src
                std ; обратный ход строки (movsb будет
                    ; уменьшать rdi и rsi)

                add rdi, rcx ; смещаем указатели
                add rsi, rcx ; на длину строки
                inc rcx ; чтобы учитывать \0

                rep movsb

                cld ; убираем обратный ход строки

skip:
        ret

end
