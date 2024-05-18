bits 64

%define GTK_WIN_POS_CENTER 1
%define GTK_WIN_WIDTH 700
%define GTK_WIN_HEIGHT 450

extern gtk_init
extern gtk_window_new
extern gtk_window_set_title
extern gtk_window_set_default_size

extern gtk_button_new_with_label

extern gtk_spin_button_new_with_range
extern gtk_spin_button_set_digits
extern gtk_spin_button_get_value
extern gtk_spin_button_set_value

extern gtk_label_new
extern gtk_label_set_text

extern gtk_box_new
extern gtk_widget_set_tooltip_text

extern gtk_container_add
extern gtk_widget_show_all

extern g_signal_connect_data
extern gtk_main_quit
extern gtk_main
extern exit

extern g_strdup_printf
extern g_free

section .bss
        window: resq 1
        box: resq 1
        input1: resq 1
        input2: resq 1
        
        run_button:
                .handle: resq 1
                .label: resq 1
        
        res_label:
                .handle: resq 1
                .default: resq 1
        
        str_ptr: resq 1

        fpu_buf: resq 1

        interval_start: resq 1
        interval_end: resq 1
        interval_mid: resq 1

section .data
        signal:
                .clicked: db "clicked", 0
        value: dq 9.9

section .rodata
        destroy_text: db "destroy", 0
        title: db "lab_10", 0
        double_format: db "%.16f", 0
        int_format: db "%ld", 0
        
        zero: dq 0.0
        two: dq 2.0
        five: dq 5.0


section .text

global _start

; x -> xmm0; res -> xmm0
my_sin:
        movq [fpu_buf], xmm0
        fld qword [fpu_buf]     ; st(0) = x
        fsin                    ; st(0) = sin(x)
        fstp qword [fpu_buf]    ; pop -> fpu_buf
        movq xmm0, [fpu_buf]

        ret

; x -> xmm0; res -> xmm0
get_func:
        movsd xmm1, xmm0  ; xmm1 = x

        movq xmm0, [five] ; xmm0 = 5.0
        mulsd xmm0, xmm1  ; xmm0 = 5x

        mulsd xmm1, xmm1  ; xmm1 = x^2
        addsd xmm0, xmm1  ; xmm0 = 5x + x^2

        call my_sin       ; xmm0 = sin(5x + x^2)

        ret


; start -> interval_start, end -> interval_end, res -> xmm0
get_mid:
        movq xmm0, [interval_start]
        movq xmm1, [interval_end]

        addsd xmm0, xmm1

        movq xmm1, [two]

        divsd xmm0, xmm1

        movq [interval_mid], xmm0

        ret


; start -> interval_start, end -> interval_end, res -> xmm0
get_root:
        mov rcx, 1000

        midpoint_getter_loop:
                movq xmm0, [interval_start]
                call get_func

                movsd xmm4, xmm0

                call get_mid

                movq xmm0, [interval_mid]
                call get_func

                mulsd xmm0, xmm4
                
                movq xmm1, [zero]
                cmpnlesd xmm0, xmm1 ; res of cmp -> xmm0 
                                    ; 0x0 or 0xfffff.....

                movq [fpu_buf], xmm0
                mov rbx, [fpu_buf]
                test rbx, rbx
                
                movq xmm0, [interval_mid]
                jz from_mid_to_b
                        movq [interval_start], xmm0
                        jmp to_end
                from_mid_to_b:
                        movq [interval_end], xmm0
                to_end:
                
                loop midpoint_getter_loop
        
        call get_mid
        ret


; x -> xmm0
print_double:
        push rax
        push rdi
        push rsi

        mov rax, 1
        mov rdi, double_format
        call g_strdup_printf

        mov rdi, qword[res_label.handle]
        mov rsi, rax
        call gtk_label_set_text

        mov rdi, rax
        call g_free

        pop rsi
        pop rdi
        pop rax
        ret


run_handler:
        push rsi

        ; получаем значение первого инпута
        mov rdi, qword[input1]
        call gtk_spin_button_get_value
        movq [interval_start], xmm0 

        ; получаем значение второго инпута
        mov rdi, qword[input2]
        call gtk_spin_button_get_value
        movq [interval_end], xmm0

        call get_root
        
        call print_double

        pop rsi
        ret

_start:
    ;init gtk
    xor     rsi,rsi                         ;argv
    xor     rdi,rdi                         ;argc
    call    gtk_init
    ;the main window
    xor     rdi,rdi                         ;GTK_WINDOW_TOPLEVEL
    call    gtk_window_new
    mov     qword[window],rax
    ;set title
    mov     rdi,qword[window]
    mov     rsi,title
    call    gtk_window_set_title
    ;set size
    mov     rdi,qword[window]
    mov     rsi,200                         ;width
    mov     rdx,100                         ;height
    call    gtk_window_set_default_size
    ;set border width

    mov     rdi, 1
    mov     rsi, 1
    call    gtk_box_new
    mov     qword[box], rax

    ;add the a_spin to the vbox container
    mov     rdi, __float64__(-100.0)
    movq    XMM0, rdi
    mov     rsi, __float64__(100.0)
    movq    XMM1, rsi
    mov     rdx, __float64__(1.0)
    movq    XMM2, rdx
    call    gtk_spin_button_new_with_range
    mov     qword[input1],rax

    mov     rdi, rax
    mov     rsi, 6
    movq    XMM0, rsi
    call    gtk_spin_button_set_digits

    mov     rdi,qword[box]
    mov     rsi,qword[input1]
    call    gtk_container_add


    ;add the + label to the vbox container


    ;add the b_spin to the vbox container
    mov     rdi, __float64__(-100.0)
    movq    XMM0, rdi
    mov     rsi, __float64__(100.0)
    movq    XMM1, rsi
    mov     rdx, __float64__(1.0)
    movq    XMM2, rdx
    call    gtk_spin_button_new_with_range
    mov     qword[input2],rax

    mov     rdi, rax
    mov     rsi, 6
    movq    XMM0, rsi
    call    gtk_spin_button_set_digits

    mov     rdi,qword[box]
    mov     rsi,qword[input2]
    call    gtk_container_add

    ;add the button to the vbox container
    mov     rdi,run_button.label
    call    gtk_button_new_with_label
    mov     qword[run_button],rax


    mov     rdi,qword[box]
    mov     rsi,qword[run_button]
    call    gtk_container_add

    ;add the label to the vbox container
    call    gtk_label_new
    mov     qword[res_label.handle], rax

    mov     rdi,qword[res_label.handle]
    mov     rsi,res_label.default
    call    gtk_label_set_text

    mov     rdi,qword[box]
    mov     rsi,qword[res_label.handle]
    call    gtk_container_add

    ;add the vbox container to the window
    mov     rdi,qword[window]
    mov     rsi,qword[box]
    call    gtk_container_add


    ; signal for button
    xor       r9d, r9d
    xor       r8d, r8d
    mov       rcx, 0
    mov       rdx, run_handler
    mov       rsi, signal.clicked
    mov       rdi, qword[run_button.handle]
    call      g_signal_connect_data

    ;show window
    mov     rdi,qword[window]
    call    gtk_widget_show_all
    ;connect destroy signal to the window
    xor     r9d,r9d                      ;combination of GConnectFlags
    xor     r8d,r8d                      ;a GClosureNotify for data
    mov     rcx,qword[window]            ;pointer to window instance in RCX
    mov     rdx,gtk_main_quit            ;pointer to the handler
    mov     rsi,destroy_text                ;pointer to the signal
    mov     rdi,qword[window]            ;pointer to window instance in RDI
    call    g_signal_connect_data        ;the value in RAX is the handler, but we don't store it now
    ;go into application main loop
    call    gtk_main
    ;exit program
    xor     rdi, rdi
    call    exit