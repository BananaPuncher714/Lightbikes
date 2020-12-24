        section .data
prtcls: db      "░", 0, "▒", 0, "▓", 0

        section .text
        global draw_square

; Draw where the player lost
; Prototype: long draw_square( struct LB* game, short width, short height );
draw_square:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 16

        ; Only draw the crash while it's in state 3
        cmp     word [rdi - 32], 3
        jne     draw_square.blank

        movsx   r8, word [rdi - 298]    ; crash x
        movsx   r9, word [rdi - 296]    ; crash y

        cmp     rsi, r8
        jl      draw_square.blank
        cmp     rdx, r9
        jl      draw_square.blank

        add     r8, 3                   ; A 3x3 square
        add     r9, 3

        cmp     rsi, r8
        jge     draw_square.blank
        cmp     rdx, r9
        jge     draw_square.blank

        mov     rax, [rdi - 8]          ; Get the current tick
        mov     r9, 36                  ; Repeat 3 times
        xor     rdx, rdx
        div     r9
        mov     rax, rdx
        mov     r9, 12                  ; 12 tick cycle
        xor     rdx, rdx
        div     r9

        mov     r10, rax                ; Multiply by 4
        xor     rax, rax
        shl     r10, 2

        mov     r11, prtcls             ; Get the particle
        mov     eax, dword [r11 + r10]

        mov     r10, 0x34313933         ; Set it to red
        shl     r10, 32
        or      rax, r10

        jmp     draw_square.end

draw_square.blank:
        xor     rax, rax

draw_square.end:
        mov     rsp, rbp
        pop     rbp

        ret