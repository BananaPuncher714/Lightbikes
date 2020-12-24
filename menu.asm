        section .data
menu_1: db      "1 Player"
m1_l:   db      $ - menu_1
menu_2: db      "2 Player"
m2_l:   db      $ - menu_2
color1: db      "Color 1"
c1_l:   db      $ - color1
color2: db      "Color 2"
c2_l:   db      $ - color2
menu_3: db      "Exit"
m3_l:   db      $ - menu_3

        section .text
        global draw_menu

; Draw the main menu in all of its fancy and glory
; Prototype: long draw_menu( struct LB* game, short width, short height );
draw_menu:
        push    rbp
        mov     rbp, rsp

        cmp     dword [rdi - 32], 0
        jne     draw_menu.end

        movsx   r8, word [rdi - 14]     ; max x
        movsx   r9, word [rdi - 16]     ; max y

        mov     r10, 10
        shr     r8, 1
        sub     r8, r10

        shr     r9, 1
        add     r9, 2

        sub     rsi, r8
        sub     rdx, r9

        mov     r11, rdx
        mov     rax, [rdi - 8]           ; Get the current tick
        xor     rdx, rdx
        mov     r9, 66
        div     r9
        mov     rax, rdx
        mov     r9, 33
        xor     rdx, rdx
        div     r9
        mov     r9, rax
        xor     rax, rax
        sub     r9, 3
        mov     rdx, r11

        cmp     rsi, r9
        je      draw_menu.select

        cmp     rsi, 0
        jl      draw_menu.end
        cmp     rsi, 20
        jge     draw_menu.end

        cmp     rdx, 0                  ; The copy and paste is incredibly strong
        je      draw_menu.line_1
        cmp     rdx, 1
        je      draw_menu.line_2
        cmp     rdx, 2
        je      draw_menu.line_3
        cmp     rdx, 3
        je      draw_menu.line_4
        cmp     rdx, 4
        je      draw_menu.line_5
        jmp     draw_menu.end

draw_menu.select:
        ; Check if it's equal or not
        cmp     dl, byte [rdi - 398]
        jne     draw_menu.end

        mov     ax, 0x3932
        shl     rax, 32
        mov     al, ">"

        jmp     draw_menu.end

; Yes, this is terrible, yes this is assembly
draw_menu.line_1:
        movsx   r9, byte [m1_l]         ; So, I just learned that movsx was a thing
        cmp     rsi, r9
        jge     draw_menu.end

        add     rsi, menu_1

        jmp     draw_menu.color

draw_menu.line_2:
        movsx   r9, byte [m2_l]
        cmp     rsi, r9
        jge     draw_menu.end

        add     rsi, menu_2

        jmp     draw_menu.color

draw_menu.line_3:
        movsx   r9, byte [c1_l]
        cmp     rsi, r9
        jge     draw_menu.line_3.color

        add     rsi, color1

        jmp     draw_menu.color

draw_menu.line_3.color:
        add     r9, 3
        cmp     rsi, r9
        jle     draw_menu.end

        mov     rax, "█"
        movsx   r10, word [rdi - 334]
        shl     r10, 32
        or      rax, r10

        jmp     draw_menu.end

draw_menu.line_4:
        movsx   r9, byte [c2_l]
        cmp     rsi, r9
        jge     draw_menu.line_4.color

        add     rsi, color2

        jmp     draw_menu.color

draw_menu.line_4.color:
        add     r9, 3
        cmp     rsi, r9
        jle     draw_menu.end

        mov     rax, "█"
        movsx   r10, word [rdi - 374]
        shl     r10, 32
        or      rax, r10

        jmp     draw_menu.end

draw_menu.line_5:
        xor     r9, r9
        mov     r9b, byte [m3_l]
        cmp     rsi, r9
        jge     draw_menu.end

        add     rsi, menu_3

draw_menu.color:
        mov     al, byte [rsi]

        cmp     dl, byte [rdi - 398]
        jne     draw_menu.color.select

        cmp     dl, 4
        je      draw_menu.color.exit

        mov     r8, 0x3936
        jmp     draw_menu.color.select_end

draw_menu.color.exit:
        mov     r8, 0x3931
        jmp     draw_menu.color.select_end

draw_menu.color.select:
        mov     r8, 0x3937

draw_menu.color.select_end:
        shl     r8, 32
        or      rax, r8

draw_menu.end:
        pop     rbp

        ret