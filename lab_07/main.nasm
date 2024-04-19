bits 64

section .text
global _copy_string

; User-level applications use as integer registers for passing the sequence 
; %rdi, %rsi, %rdx, %rcx, %r8 and %r9. 
; The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9.
;                             ^     ^     ^     ^
;                           arg1  arg2  arg3 ....

; rdi -> char* src
; rsi -> char* dst
; rdx -> size_t length 
_copy_string:
        push rax

        mov rcx, rdx
        mov rax, rsi
        lea rsi, [rdi]
        lea rdi, [rax]
        rep movsb

        pop rax
        ret

end
