extern  get_screen_size
extern  printf
extern  reset_cursor

        section .text
        global draw

; This file is a mess, and I can't justify any of it
; But, it works to a certain extent, and I think that's good enough
; I spent way too much time on this. The actual gameplay and menu stuff took like a day to complete
; while this took two and a half, mostly because I had no clue how the bytes were stored
; I still don't know, but it works, so I won't complain
%define length  dword [rbp - 56]
%define b_h     word [rbp - 52]
%define b_w     word [rbp - 50]

draw:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 80

        mov     [rbp - 8], r12
        mov     [rbp - 16], r13
        mov     [rbp - 24], r14
        mov     [rbp - 32], rdi

        ; Save the screen size from the struct
        mov     r8w, word [rdi - 16]
        mov     b_h, r8w
        mov     r8w, word [rdi - 14]
        mov     b_w, r8w

        mov     length, 4               ; This should be the length of our buffer
        mov     dword [rbp - 60], 0     ; Store the color code of our buffer, also the start

        ; The drawing loop starts here
        xor     r13, r13

draw.vertical_loop:
        xor     r12, r12

draw.horizontal_loop:
        ; I'm given the x and y of the screen starting in the top left, as r12w and r13w
        ; Calculate what goes where, or exactly what character should belong to whatever
        ; I need a screen buffer

        ; Ok, I need an array of function pointers or something... I guess that comes in rdi?
        ; Do I need to add anything else? Hopefully not, since I don't have any
        ; more space, and I don't feel like changing the numbers

        xor     rax, rax
        mov     r14, [rbp - 32]
        sub     r14, 272                ; The location of the function pointers

        mov     r8, [r14]
        cmp     r8, 0
        jz      draw.window_loop_end

draw.window_loop:
        ; Need to give them  the game structure, x and y
        mov     rdi, [rbp - 32]
        ; Calculate the x, but flip it around
        movsx   rsi, b_w
        dec     rsi
        sub     rsi, r12

        ; Calculate the y too, but it also needs flipping
        movsx   rdx, b_h
        dec     rdx
        sub     rdx, r13
        call    [r14]

        cmp     eax, 0                  ; If it's not zero, then it means we should be drawing something
        jne     draw.window_loop_end    ; The lower the index, the higher the priority.

        add     r14, 8
        mov     r8, [r14]
        cmp     r8, 0
        jne     draw.window_loop

draw.window_loop_end:
        cmp     eax, 0                    ; If it's null, then print out an empty space
        jne     draw.window_if_end

        mov     al, " "

draw.window_if_end:

        ; Anyways, let's say that I have a stack size of whatever
        ; Do whatever, and let's say that I get the color and character to add in rax
        mov     rdi, rbp                ; Get the start of our buffer struct
        sub     rdi, 56                 ; rdi contains the start of our buffer

        movsx   r8, length              ; Get the current length
        mov     rsi, rdi                ; Copy the start address of our buffer
        sub     rsi, r8                 ; Subtract length to get the end

        mov     ecx, eax                ; Get the character
        shr     rax, 32
        mov     edx, eax                ; Get the color

        call    add_to_buffer           ; At this point, the characters should have been added

        ; We have the amount of characters added
        mov     r8d, length              ; Get the length
        add     r8d, eax                ; Add the amount of characters
        mov     length, r8d             ; Set the new length

        ; Figure out how long it is, if we subtract it
        lea     r9, [rbp - 72]          ; Get the current base and subtract 72
        sub     r9, r8                  ; Subtract the current length calculated previously

        ; Now we have the ending address + 16, check if it's less than rsp
        cmp     rsp, r9                 ; Compare rsp - r9
        jb      draw.if_end             ; If rsp is larger than r9, then add more to the stack

        ; If so, then add another few bytes onto the stack
        sub     rsp, 16

draw.if_end:
        inc     r12
        cmp     r12w, b_w
        jl      draw.horizontal_loop

        ; Add a newline, but only if it's not the last loop
        mov     r8w, r13w
        inc     r8w
        cmp     r8w, b_h
        jge     draw.newline_end

        inc     length
        movsx   r9, length
        mov     r8, rbp
        sub     r8, r9
        mov     byte [r8 - 56], 10

draw.newline_end:

        inc     r13
        cmp     r13w, b_h
        jl      draw.vertical_loop

        ; Set the color, since it gets reversed
        add     length, 10
        movsx   r9, length
        mov     r8, rbp
        sub     r8, r9

        mov     byte [r8 - 47], "m"
        mov     r9b, byte [rbp - 60]
        mov     byte [r8 - 48], r9b
        mov     r9b, byte [rbp - 59]
        mov     byte [r8 - 49], r9b
        mov     byte [r8 - 50], "["
        mov     byte [r8 - 51], 0x1b
        mov     byte [r8 - 52], "m"
        mov     r9b, byte [rbp - 58]
        mov     byte [r8 - 53], r9b
        mov     r9b, byte [rbp - 57]
        mov     byte [r8 - 54], r9b
        mov     byte [r8 - 55], "["
        mov     byte [r8 - 56], 0x1b

        ; Flip the input or something
        lea     rdi, [rbp - 60]
        movsx   rsi, length
        sub     rsi, 4

        ; Move the cursor
        call    reset_cursor

        ; Print out the buffer, which should be an entire screen
        mov     rax, 1                  ; System call write
        mov     rdi, 1                  ; stdout
        movsx   r8, length
        lea     rsi, [rbp - 56]
        sub     rsi, r8
        movsx   rdx, length
        sub     rdx, 4
        syscall

        mov     r12, [rbp - 8]
        mov     r13, [rbp - 16]
        mov     r14, [rbp - 24]

        mov     rsp, rbp
        pop     rbp

        ret

; Give the buffer start, end, new color and character, add however many characters need to be added, and return the amount added
; The buffer's first word should contain the current foreground and background
; The buffer also goes backwards, since I don't feel like figuring out how to do otherwise
; rdi, rsi, rdx, rcx
; Prototype: int add_to_buffer( unsigned char* buffer, unsigned char* end, unsigned long color, unsigned char character );
add_to_buffer:
        push    rbp
        mov     rbp, rsp

        push    r12

        mov     r12d, dword [rdi - 4]

        mov     rax, 4

        cmp     r12d, edx
        je      add_to_buffer.if_end

        ; The colors aren't the same as the current one, so save the old color by printing it
        mov     byte [rsi - 1], "m"
        mov     byte [rsi - 2], r12b
        shr     r12, 8
        mov     byte [rsi - 3], r12b
        shr     r12, 8
        mov     byte [rsi - 4], "["
        mov     byte [rsi - 5], 0x1b
        mov     byte [rsi - 6], "m"
        mov     byte [rsi - 7], r12b
        shr     r12, 8
        mov     byte [rsi - 8], r12b
        mov     byte [rsi - 9], "["
        mov     byte [rsi - 10], 0x1b

        sub     rsi, 10
        add     rax, 10

        mov     dword [rdi - 4], edx

add_to_buffer.if_end:
        mov     dword [rsi - 4], ecx

        pop     r12

        mov     rsp, rbp
        pop     rbp

        ret

; Reverse the bytes
; Prototype: flip_buffer( unsigned char* buffer, unsigned int length );
flip_buffer:
        push    rbp
        mov     rbp, rsp

        xor     r8, r8
        mov     r9, rsi
        shr     r9, 1
        xor     r10, r10

flip_buffer.loop_start:
        lea     r10, [rdi + r8]
        sub     r10, rsi

        mov     rax, rdi
        sub     rax, r8

        mov     cl, byte [rax - 1]
        mov     dl, byte [r10]

        mov     byte [rax - 1], dl
        mov     byte [r10], cl

        inc     r8
        cmp     r8d, r9d
        jl      flip_buffer.loop_start

        pop     rbp

        ret