        section .data
p1_win:
        db      "╔ ═ ╗ ╳ ╔ ╣ ╳ ╳ ╳ ╳ ╳ ╗ ╳ ╳ ╳ ╳ ╔ ╳ ═ ╦ ═ ╳ ╗ ╳ ║ ╳ ╳ ╔ ═ ╗ "
        db      "║ ╳ ║ ╳ ╝ ║ ╳ ╳ ╳ ╳ ╳ ║ ╳ ╔ ╗ ╳ ║ ╳ ╳ ║ ╳ ╳ ╠ ╗ ║ ╳ ╔ ╝ ╳ ╳ "
        db      "╠ ═ ╝ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ╚ ╗ ║ ║ ╔ ╝ ╳ ╳ ║ ╳ ╳ ║ ╚ ╣ ╳ ╚ ═ ═ ╗ "
        db      "╝ ╳ ╳ ╳ ╔ ╩ ═ ╳ ╳ ╳ ╳ ╳ ╚ ╝ ╚ ╝ ╳ ╳ ═ ╩ ═ ╳ ║ ╳ ╚ ╳ ═ ═ ═ ╝ "
p1_end:

p2_win:
        db      "╔ ═ ╗ ╳ ╔ ═ ╗ ╳ ╳ ╳ ╳ ╗ ╳ ╳ ╳ ╳ ╔ ╳ ═ ╦ ═ ╳ ╗ ╳ ║ ╳ ╳ ╔ ═ ╗ "
        db      "║ ╳ ║ ╳ ╝ ╳ ╚ ╗ ╳ ╳ ╳ ║ ╳ ╔ ╗ ╳ ║ ╳ ╳ ║ ╳ ╳ ╠ ╗ ║ ╳ ╔ ╝ ╳ ╳ "
        db      "╠ ═ ╝ ╳ ╔ ═ ═ ╝ ╳ ╳ ╳ ╚ ╗ ║ ║ ╔ ╝ ╳ ╳ ║ ╳ ╳ ║ ╚ ╣ ╳ ╚ ═ ═ ╗ "
        db      "╝ ╳ ╳ ╳ ╚ ═ ═ ═ ╳ ╳ ╳ ╳ ╚ ╝ ╚ ╝ ╳ ╳ ═ ╩ ═ ╳ ║ ╳ ╚ ╳ ═ ═ ═ ╝ "
p2_end:

        section .text
        global draw_winner

; Prototype: long draw_winner( struct LB* game, short width, short height );
draw_winner:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 16

        ; Only draw the winner while it's in state 3
        cmp     word [rdi - 32], 3
        jne     draw_winner.blank

        sub     rsp, 16

        ; Get the winner
        cmp     byte [rdi - 299], 1
        je      draw_winner.if_1

        mov     r8, p1_win
        mov     r9, p1_end
        jmp     draw_winner.if_end

draw_winner.if_1:
        mov     r8, p2_win
        mov     r9, p2_end
        jmp draw_winner.if_end

draw_winner.if_end:
        mov     [rbp - 16], r9
        mov     [rbp - 8], r8

        movsx   r8, word [rdi - 14]     ; max x
        movsx   r9, word [rdi - 16]     ; max y

        mov     r10, [rbp - 16]
        sub     r10, [rbp - 8]
        shr     r10, 4
        mov     r11, r10
        shr     r11, 1
        shr     r8, 1
        sub     r8, r11

        shr     r9, 1
        sub     r9, 2

        sub     rsi, r8
        sub     rdx, r9

        ; Now, rsi and rdx should be relative to whatever
        cmp     rsi, 0
        jl      draw_winner.blank
        cmp     rsi, r10
        jge     draw_winner.blank
        cmp     rdx, 0
        jl      draw_winner.blank
        cmp     rdx, 4
        jge     draw_winner.blank

        mov     rax, rdx                ; Hmm, hmm hmm. I have no clue what this section does anymore
        mul     r10                     ; Nor do I feel like trying to figure it out
        add     rsi, rax                ; BTW Ivan your face is beautiful
        shl     rsi, 2
        add     rsi, [rbp - 8]

        movsx   rax, dword [rsi]
        cmp     eax, "╳ "
        je      draw_winner.space
        and     eax, 0x00FFFFFF

        ; Set the color to whoever won
        cmp     byte [rdi - 299], 1
        je      draw_winner.player1_color

        movsx   r10, word [rdi - 334]

        jmp     draw_winner.color

draw_winner.player1_color:
        movsx   r10, word [rdi - 374]

draw_winner.color:
        shl     r10, 32
        or      rax, r10

        jmp     draw_winner.end

draw_winner.space:
        mov     rax, " "
        jmp     draw_winner.end

draw_winner.blank:
        xor     rax, rax

draw_winner.end:
        mov     rsp, rbp
        pop     rbp

        ret