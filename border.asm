        section .data
NW:     db      "╔", 0
NE:     db      "╗", 0
SE:     db      "╝", 0
SW:     db      "╚", 0
HORI:   db      "═", 0
VERT:   db      "║", 0

        section .text
        global draw_border

; Draw the border around the screen
; Prototype: long draw_border( struct LB* game, short width, short height );
draw_border:
        push    rbp
        mov     rbp, rsp

        mov     r8w, word [rdi - 14]  ; max x
        mov     r9w, word [rdi - 16]  ; max y

        inc     rsi                     ; x
        inc     rdx                     ; y

        xor     rax, rax

        cmp     si, 1
        jle     draw_border.if_west     ; It's the left
        cmp     si, r8w
        jge     draw_border.if_east     ; It's the right

        cmp     dx, 1
        jle     draw_border.hori        ; It's the top
        cmp     dx, r9w
        jge     draw_border.hori        ; It's the bottom

        jmp     draw_border.if_end      ; Return with 0

draw_border.if_west:
        cmp     dx, 1
        jle     draw_border.if_west_north
        cmp     dx, r9w
        jge     draw_border.if_west_south

        jmp     draw_border.vert

draw_border.if_east:
        cmp     dx, 1
        jle     draw_border.if_east_north
        cmp     dx, r9w
        jge     draw_border.if_east_south

        jmp     draw_border.vert

draw_border.if_west_north:
        mov     eax, dword [NW]
        jmp     draw_border.if_end

draw_border.if_west_south:
        mov     eax, dword [SW]
        jmp     draw_border.if_end

draw_border.if_east_north:
        mov     eax, dword [NE]
        jmp     draw_border.if_end

draw_border.if_east_south:
        mov     eax, dword [SE]
        jmp     draw_border.if_end

draw_border.hori:
        mov     eax, dword [HORI]
        jmp     draw_border.if_end

draw_border.vert:
        mov     eax, dword [VERT]

draw_border.if_end:
        mov     r10, 0x3937
        shl     r10, 32
        or      rax, r10

        pop     rbp

        ret