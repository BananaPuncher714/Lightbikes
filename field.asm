        section .data
c1:     db      "│", 0
c2:     db      "─", 0
c3:     db      "┌", 0
c4:     db      "┐", 0
c5:     db      "└", 0
c6:     db      "┘", 0
c7:     db      "☻", 0

        section .text
        global draw_field

; Draw the playing board
; Prototype: long draw_field( struct LB* game, short width, short height );
draw_field:
        push    rbp
        mov     rbp, rsp

        cmp     dword [rdi - 32], 1     ; Only show the board during these 3 states
        jl      draw_field.blank
        cmp     dword [rdi - 32], 3
        jg      draw_field.blank

        movsx   r8, word [rdi - 14]     ; Screen width
        movsx   r9, word [rdi - 16]     ; Screen height
        sub     r8, 2                   ; Board width
        sub     r9, 2                   ; Board height

        dec     rsi                     ; Transform screen coords to board coords
        dec     rdx

        cmp     si, 0                   ; Don't draw out of bounds
        jl      draw_field.blank
        cmp     dx, 0
        jl      draw_field.blank
        cmp     si, r8w
        jge     draw_field.blank
        cmp     dx, r9w
        jge     draw_field.blank

        mov     rax, rdx                ; Get the index of the board for our piece
        mul     r8
        mov     r10, [rdi - 394]        ; Get the address of the board
        add     r10, rax
        add     r10, rsi

        movsx   r8, byte [r10]          ; Get the value in our board

        cmp     r8b, 0                  ; Check if it's nothing
        je      draw_field.blank

        mov     r9w, word [rdi - 374]

        cmp     r8b, 10
        jl      draw_field.if_player_end
        mov     r9w, word [rdi - 334]
        sub     r8b, 10

draw_field.if_player_end:
        ; Get whatever character
        lea     r10, [c1 + ( r8 - 1 )* 4]
        movsx   rax, dword [r10]

        ; Set the color
        shl     r9, 32
        or      rax, r9

        jmp     draw_field.end        

draw_field.blank:
        xor     rax, rax

draw_field.end:
        pop     rbp

        ret