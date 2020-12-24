        section .data
; Yarrgh, even more inefficient data storage
three:
        db      "═ ═ ╦ ═ ═ ╳ ╗ ╳ ╳ ╳ ║ ╳ ╔ ═ ═ ╗ ╳ ╳ ╔ ═ ═ ═ ═ ═ ╳ ╔ ═ ═ ═ ═ ═ "
three_end:
        db      "╳ ╳ ║ ╳ ╳ ╳ ║ ╳ ╳ ╳ ║ ╳ ║ ╳ ╳ ╚ ╗ ╳ ║ ╳ ╳ ╳ ╳ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ "
        db      "╳ ╳ ║ ╳ ╳ ╳ ║ ╳ ╔ ═ ╣ ╳ ║ ╳ ╳ ╔ ╝ ╳ ╠ ═ ═ ╳ ╳ ╳ ╳ ╠ ═ ═ ╳ ╳ ╳ "
        db      "╳ ╳ ║ ╳ ╳ ╳ ╠ ═ ╝ ╳ ║ ╳ ╠ ═ ╦ ╝ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ "
        db      "╳ ╳ ║ ╳ ╳ ╳ ║ ╳ ╳ ╳ ║ ╳ ║ ╳ ╚ ╗ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ "
        db      "╳ ╳ ║ ╳ ╳ ╳ ║ ╳ ╳ ╳ ╚ ╳ ╝ ╳ ╳ ╚ ╗ ╳ ╚ ═ ═ ═ ═ ═ ╳ ╚ ═ ═ ═ ═ ═ "

two:
        db      "═ ═ ╦ ═ ═ ╳ ╗ ╳ ╳ ╳ ╳ ╳ ╳ ╳ ╳ ╔ ╳ ╳ ╔ ═ ═ ═ ╗ ╳ "
two_end:
        db      "╳ ╳ ║ ╳ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ╳ ╳ ╳ ║ ╳ ╔ ╝ ╳ ╳ ╳ ╚ ╗ "
        db      "╳ ╳ ║ ╳ ╳ ╳ ╚ ╗ ╳ ╳ ╔ ╗ ╳ ╳ ╔ ╝ ╳ ║ ╳ ╳ ╳ ╳ ╳ ║ "
        db      "╳ ╳ ║ ╳ ╳ ╳ ╳ ║ ╳ ╳ ║ ║ ╳ ╳ ║ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ║ "
        db      "╳ ╳ ║ ╳ ╳ ╳ ╳ ╚ ╗ ╔ ╝ ╚ ╗ ╔ ╝ ╳ ╳ ╚ ╗ ╳ ╳ ╳ ╔ ╝ "
        db      "╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ╚ ╝ ╳ ╳ ╚ ╝ ╳ ╳ ╳ ╳ ╚ ═ ═ ═ ╝ ╳ "

one:
        db      "╳ ╔ ═ ═ ═ ╗ ╳ ╳ ╗ ╳ ╳ ╳ ║ ╳ ╔ ═ ═ ═ ═ ═ "
one_end:
        db      "╔ ╝ ╳ ╳ ╳ ╚ ╗ ╳ ╠ ╗ ╳ ╳ ║ ╳ ║ ╳ ╳ ╳ ╳ ╳ "
        db      "║ ╳ ╳ ╳ ╳ ╳ ║ ╳ ║ ╚ ╗ ╳ ║ ╳ ╠ ═ ═ ╳ ╳ ╳ "
        db      "║ ╳ ╳ ╳ ╳ ╳ ║ ╳ ║ ╳ ╚ ╗ ║ ╳ ║ ╳ ╳ ╳ ╳ ╳ "
        db      "╚ ╗ ╳ ╳ ╳ ╔ ╝ ╳ ║ ╳ ╳ ╚ ╣ ╳ ║ ╳ ╳ ╳ ╳ ╳ "
        db      "╳ ╚ ═ ═ ═ ╝ ╳ ╳ ║ ╳ ╳ ╳ ╚ ╳ ╚ ═ ═ ═ ═ ═ "

zero:
        db      "╚ ═ ═ ═ ═ ╗ ╳ ╔ ═ ═ ═ ═ ═ ╳ ╔ ═ ═ ╗ ╳ ╳ ╳ ╔ ═ ═ ═ ╗ ╳ "
zero_end:
        db      "╳ ╳ ╳ ╳ ╔ ╝ ╳ ║ ╳ ╳ ╳ ╳ ╳ ╳ ║ ╳ ╳ ╚ ╗ ╳ ╔ ╝ ╳ ╳ ╳ ╚ ╗ "
        db      "╳ ╳ ╳ ╔ ╝ ╳ ╳ ╠ ═ ═ ╳ ╳ ╳ ╳ ║ ╳ ╳ ╔ ╝ ╳ ║ ╳ ╳ ╳ ╳ ╳ ║ "
        db      "╳ ╳ ╔ ╝ ╳ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ╳ ╠ ═ ╦ ╝ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ║ "
        db      "╳ ╔ ╝ ╳ ╳ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ╳ ║ ╳ ╚ ╗ ╳ ╳ ╚ ╗ ╳ ╳ ╳ ╔ ╝ "
        db      "╳ ╚ ═ ═ ═ ╗ ╳ ╚ ═ ═ ═ ═ ═ ╳ ╝ ╳ ╳ ╚ ╗ ╳ ╳ ╚ ═ ═ ═ ╝ ╳ "

        section .text
        global draw_countdown

; Prototype: long draw_countdown( struct LB* game, short width, short height );
draw_countdown:
        push    rbp
        mov     rbp, rsp

        ; Only draw the countdown while it's in state 1
        cmp     word [rdi - 32], 1
        jne     draw_countdown.blank

        sub     rsp, 16

        ; Get the countdown or whatever
        cmp     word [rdi - 396], 120
        jge     draw_countdown.if_3
        cmp     word [rdi - 396], 80
        jge     draw_countdown.if_2
        cmp     word [rdi - 396], 40
        jge     draw_countdown.if_1

        mov     r8, zero
        mov     r9, zero_end
        jmp     draw_countdown.if_end

draw_countdown.if_1:
        mov     r8, one
        mov     r9, one_end
        jmp     draw_countdown.if_end

draw_countdown.if_2:
        mov     r8, two
        mov     r9, two_end
        jmp     draw_countdown.if_end

draw_countdown.if_3:
        mov     r8, three
        mov     r9, three_end
        jmp     draw_countdown.if_end

draw_countdown.if_end:
        mov     [rbp - 16], r9
        mov     [rbp - 8], r8

        cmp     dword [rdi - 32], 1
        jne     draw_countdown.blank

        movsx   r8, word [rdi - 14]     ; max x
        movsx   r9, word [rdi - 16]     ; max y

        mov     r10, [rbp - 16]
        sub     r10, [rbp - 8]
        shr     r10, 2
        mov     r11, r10
        shr     r11, 1
        shr     r8, 1
        sub     r8, r11

        shr     r9, 1
        sub     r9, 4

        sub     rsi, r8
        sub     rdx, r9

        ; Now, rsi and rdx should be relative to whatever
        cmp     rsi, 0
        jl      draw_countdown.blank
        cmp     rsi, r10
        jge     draw_countdown.blank
        cmp     rdx, 0
        jl      draw_countdown.blank
        cmp     rdx, 6
        jge     draw_countdown.blank

        mov     rax, rdx
        mul     r10
        add     rsi, rax
        shl     rsi, 2
        add     rsi, [rbp - 8]

        movsx   rax, dword [rsi]
        cmp     eax, "╳ "
        je      draw_countdown.blank
        and     eax, 0x00FFFFFF         ; Clear the space

        mov     r10, 0x3932             ; Set it to green

        cmp     word [rdi - 396], 40
        jl      draw_countdown.color

        mov     r10, 0x3931             ; Set it to red

draw_countdown.color:
        shl     r10, 32
        or      rax, r10

        jmp     draw_countdown.end

draw_countdown.blank:
        xor     rax, rax

draw_countdown.end:
        mov     rsp, rbp
        pop     rbp

        ret