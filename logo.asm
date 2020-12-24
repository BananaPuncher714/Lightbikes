        section .data

; Yes, this is a super convoluted way to store the data
; The ╳ is for taking up 3 bytes, and the space is to make each character 4 bytes long
; That way I can shift instead of performing div or mul
; Thankfully, with some python, it's not very hard to generate
logo:
        db      "╗ ╳ ╳ ╳ ═ ╦ ═ ╳ ╔ ═ ═ ╗ ╳ ╳ ╗ ╳ ╳ ║ ╳ ═ ╦ ═ ╳ ╳ ╳ ╔ ═ ╗ ╳ ╳ ═ ╦ ═ ╳ ╗ ╳ ║ ╳ ╔ ═ ═ ╳ ╔ ═ ═ ╝ ╳ "
        db      "║ ╳ ╳ ╳ ╳ ║ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╳ ║ ╳ ╔ ╣ ╳ ╳ ║ ╳ ╳ ╳ ╳ ║ ╔ ╩ ╗ ╳ ╳ ║ ╳ ╳ ║ ╔ ╝ ╳ ║ ╳ ╳ ╳ ║ ╳ ╳ ╳ ╳ "
        db      "║ ╳ ╳ ╳ ╳ ║ ╳ ╳ ║ ╳ ═ ╦ ╗ ╳ ╠ ═ ╝ ║ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╠ ╝ ╳ ║ ╳ ╳ ║ ╳ ╳ ╠ ╩ ╗ ╳ ╠ ═ ╳ ╳ ╚ ═ ═ ═ ╗ "
        db      "╚ ═ ═ ╳ ═ ╩ ═ ╳ ╚ ═ ═ ╝ ║ ╳ ║ ╳ ╳ ╚ ╳ ╳ ║ ╳ ╳ ╳ ╳ ╚ ═ ═ ╝ ╳ ═ ╩ ═ ╳ ║ ╳ ╚ ╳ ╚ ═ ═ ╳ ╳ ╔ ═ ═ ╝ "
logo_end:

        section .text
        global draw_logo

; Prototype: long draw_logo( struct LB* game, short width, short height );
draw_logo:
        push    rbp
        mov     rbp, rsp

        cmp     dword [rdi - 32], 0
        jne     draw_logo.blank

        movsx   r8, word [rdi - 14]     ; max x
        movsx   r9, word [rdi - 16]     ; max y

        mov     r10, logo_end           ; Get the logo's width
        sub     r10, logo
        shr     r10, 4
        mov     r11, r10
        shr     r11, 1                  ; Get half the width
        shr     r8, 1
        sub     r8, r11                 ; Get the top left coord of our logo

        shr     r9, 2                   ; Divide by 4
        sub     r9, 2                   ; Subtract 2 to get the height

        sub     rsi, r8
        sub     rdx, r9

        ; Now, rsi and rdx should be relative to whatever
        cmp     rsi, 0
        jl      draw_logo.blank
        cmp     rsi, r10
        jge     draw_logo.blank
        cmp     rdx, 0
        jl      draw_logo.blank
        cmp     rdx, 4
        jge     draw_logo.blank

        mov     rax, rdx
        mul     r10
        add     rsi, rax
        shl     rsi, 2
        add     rsi, logo

        movsx   rax, dword [rsi]
        cmp     eax, "╳ "
        je      draw_logo.blank
        and     eax, 0x00FFFFFF

        mov     r11, rax
        mov     rax, [rdi - 8]          ; Get the current tick
        movsx   r9, word [rdi - 294]    ; KONAMI CODE
        xor     rdx, rdx
        div     r9
        mov     rax, rdx
        movsx   r9, word [rdi - 292]
        xor     rdx, rdx
        div     r9
        mov     r10, 0x3930
        add     r10, rax
        shl     r10, 32

        mov     rax, r11
        or      rax, r10

        jmp     draw_logo.end

draw_logo.blank:
        xor     rax, rax

draw_logo.end:
        pop     rbp

        ret