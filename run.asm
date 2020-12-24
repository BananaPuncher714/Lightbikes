extern  next_rand

        section .text
        global bikes

; The main game logic
; First one player goes, then the next
; This entire file is a mess too, so I wouldn't look closely
bikes:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 32
        mov     [rbp - 8], r12
        mov     [rbp - 16], r13
        mov     [rbp - 24], r14
        mov     [rbp - 32], r15

        cmp     byte [rdi - 300], 1     ; Multiplayer?
        je      bikes.player1.end

        ; Get the direction of the computer
        mov     r14b, byte [rdi - 376]

        ; Check if the computer is going to hit anything
        movsx   rdx, word [rdi - 380]
        movsx   rcx, word [rdi - 378]
        mov     sil, r14b
        call    intersects

        ; If not, then skip this section
        cmp     rax, 1
        je      bikes.player1.if_end

        ; Set the "find new direction" order
        mov     r12b, 3
        mov     r15b, -1
        call    next_rand
        and     al, 1
        cmp     al, 0
        je      bikes.player1.if_jmp

        mov     r12b, 0
        mov     r15b, 1

bikes.player1.if_jmp:
        movsx   rdx, word [rdi - 380]
        movsx   rcx, word [rdi - 378]
        mov     sil, r12b
        call    intersects

        mov     r14b, r12b
        add     r12b, r15b
        cmp     rax, 1                  ; Check if we've found an empty spot
        je      bikes.player1.if_end
        cmp     r12b, 0                 ; See if we've looped out of bounds
        jl      bikes.player1.if_end
        cmp     r12b, 3
        jg      bikes.player1.if_end
        jmp     bikes.player1.if_jmp

bikes.player1.if_end:
        ; At this point, r14b contains our direction
        ; Save it
        mov     byte [rdi - 376], r14b

bikes.player1.end:

        ; For now, just move the piece
        lea     rsi, [rdi - 380]
        xor     rdx, rdx
        call    move_player

        ; Check if it intersects
        cmp     rax, 1                  ; The computer has lost
        jne     bikes.player1.lose

        ; Now it's time to check if the player is has lost or not
        lea     rsi, [rdi - 340]
        mov     rdx, 10
        call    move_player

        cmp     rax, 1                  ; The player has lost
        jne     bikes.player2.lose

        xor     rax, rax
        jmp     bikes.end

bikes.player1.lose:
        mov     rax, 1
        jmp     bikes.end

bikes.player2.lose:
        mov     rax, 2

bikes.end:
        mov     r12, [rbp - 8]
        mov     r13, [rbp - 16]
        mov     r14, [rbp - 24]
        mov     r15, [rbp - 32]

        mov     rsp, rbp
        pop     rbp

        ret

; Prototype: byte intersects( game struct something, direction, x, y );
intersects:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 16
        mov     [rbp - 8], r12
        mov     [rbp - 16], r13

        cmp     sil, 1                  ; East
        je      intersects.if_1
        cmp     sil, 2                  ; South
        je      intersects.if_2
        cmp     sil, 3                  ; West
        je      intersects.if_3

        dec     cx                     ; Go up 1
        jmp     intersects.if_end

intersects.if_1:
        inc     dx                     ; Go right 1
        jmp     intersects.if_end

intersects.if_2:
        inc     cx                     ; Go down 1
        jmp     intersects.if_end

intersects.if_3:
        dec     dx                     ; Go left 1

intersects.if_end:
        xor     rax, rax
        movsx   r12, word [rdi - 14]    ; Screen width
        movsx   r13, word [rdi - 16]    ; Screen height
        sub     r12, 2                  ; Board width
        sub     r13, 2                  ; Board height

        cmp     dx, 0                  ; Make sure it's within bounds
        jl      intersects.end
        cmp     dx, r12w
        jge     intersects.end
        cmp     cx, 0
        jl      intersects.end
        cmp     cx, r13w
        jge     intersects.end

        ; It's not out of bounds, so check if it intersects with anything on the board
        mov     rax, rcx                ; Get the y
        mov     r9, rdx
        mul     r12                     ; Multiply by the width
        add     rax, r9                 ; Add the x to get the index
        mov     r8, [rdi - 394]         ; Get the address of the board
        add     r8, rax                 ; Add whatever index
        xor     rax, rax
        cmp     byte [r8], 0            ; Check if it's an empty spot
        jne     intersects.end

        mov     rax, 1

intersects.end:
        mov     r12, [rbp - 8]
        mov     r13, [rbp - 16]

        mov     rsp, rbp
        pop     rbp

        ret

; Prototype: int move_player( game struct, player address, modifier );
move_player:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 32

        mov     [rbp - 16], rdx

        mov     r10, [rdi - 394]        ; Get the position to write to
        movsx   r8, word [rsi]
        add     r10, r8
        movsx   rax, word [rsi + 2]
        movsx   r8, word [rdi - 14]
        sub     r8, 2 
        mul     r8
        add     r10, rax
        mov     [rbp - 8], r10

        movsx   r8, word [rsi]
        movsx   r9, word [rsi + 2]

        cmp     byte [rsi + 4], 1
        je      move_player.head.east
        cmp     byte [rsi + 4], 2
        je      move_player.head.south
        cmp     byte [rsi + 4], 3
        je      move_player.head.west
        dec     r9
        jmp     move_player.head.end

move_player.head.east:
        inc     r8
        jmp     move_player.head.end

move_player.head.south:
        inc     r9
        jmp     move_player.head.end

move_player.head.west:
        dec     r8

move_player.head.end:
        movsx   r10, word [rdi - 14]    ; Screen width
        movsx   r11, word [rdi - 16]    ; Screen height
        sub     r10, 2                  ; Board width
        sub     r11, 2                  ; Board height

        cmp     r8, 0                   ; Make sure it's within bounds
        jl      move_player.fail
        cmp     r8, r10
        jge     move_player.fail
        cmp     r9, 0
        jl      move_player.fail
        cmp     r9, r11
        jge     move_player.fail

        mov     word [rbp - 32], r8w
        mov     word [rbp - 30], r9w

        mov     r11, [rdi - 394]        ; Get the position to write to
        add     r11, r8                 ; Add the current x
        mov     rax, r9
        mul     r10                     ; Multiply by the width
        add     r11, rax                ; Add them together
        add     rdx, 7                  ; Get the whatever symbol

        mov     r8b, byte [r11]
        cmp     r8b, 0
        jne     move_player.fail

        mov     rdx, [rbp - 16]
        mov     rcx, 7
        add     rcx, rdx
        mov     byte [r11], cl         ; Set it in place

        mov     r8w, word [rbp - 32]    ; Save the positions if it's successful and continue
        mov     word [rsi], r8w
        mov     r8w, word [rbp - 30]
        mov     word [rsi + 2], r8w

        ; Time to draw the trail
        ; Now, determine exactly what character to use
        mov     cx, word [rsi + 4]      ; The current direction

        xor     r10, r10
        cmp     ch, cl
        je      move_player.trail.same

        cmp     ch, 0                   ; Is it a north bend
        je      move_player.trail.north
        cmp     ch, 1
        je      move_player.trail.east
        cmp     ch, 2
        je      move_player.trail.south
        jmp     move_player.trail.west

move_player.trail.north:
        cmp     cl, 1
        je      move_player.trail.southeast
        jmp     move_player.trail.southwest

move_player.trail.east:
        cmp     cl, 0
        je      move_player.trail.northwest
        jmp     move_player.trail.southwest

move_player.trail.south:
        cmp     cl, 1
        je      move_player.trail.northeast
        jmp     move_player.trail.northwest

move_player.trail.west:
        cmp     cl, 0
        je      move_player.trail.northeast
        jmp     move_player.trail.southeast

move_player.trail.same:
        mov     r8b, cl                 ; Test which direction, either NS or EW
        and     r8b, 1
        cmp     r8b, 0
        je      move_player.trail.same.vertical
        jmp     move_player.trail.same.horizontal

move_player.trail.same.vertical:
        mov     r10, 1
        jmp     move_player.trail_end

move_player.trail.same.horizontal:
        mov     r10, 2
        jmp     move_player.trail_end

move_player.trail.northeast:
        mov     r10, 5
        jmp     move_player.trail_end

move_player.trail.northwest:
        mov     r10, 6
        jmp     move_player.trail_end

move_player.trail.southeast:
        mov     r10, 3
        jmp     move_player.trail_end

move_player.trail.southwest:
        mov     r10, 4
        jmp     move_player.trail_end

move_player.trail_end:
        add     r10, rdx
        mov     r11, [rbp - 8]
        mov     byte [r11], r10b

        mov     rax, 1
        jmp     move_player.end

move_player.fail:
        mov     rax, 0

move_player.end:
        mov     rsp, rbp
        pop     rbp

        ret