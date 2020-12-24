extern  bikes

        section .text
        global tick

; This subroutine controls the main events, such as handling the keypresses and handling other parts of the game

; It's a pipe bomb, Harry!
tick:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 16
        mov     [rbp - 8], rdi

        movsx   rax, dword [rdi - 32]

        mov     r8b, byte [rdi - 400]
        call    k
        cmp     r8b, 1
        je      tick.select
        cmp     r8b, 2
        je      tick.up
        cmp     r8b, 3
        je      tick.down
        cmp     r8b, 4
        je      tick.left
        cmp     r8b, 5
        je      tick.right

        cmp     r8b, 10
        je      tick.left2
        cmp     r8b, 12
        je      tick.right2
        cmp     r8b, 13
        je      tick.down2
        cmp     r8b, 14
        je      tick.up2
        cmp     r8b, 69
        je      tick.esc

        ; Now check the game states or something

        jmp     tick.end

tick.esc:
        cmp     dword [rdi - 32], 1
        jge     tick.state.reset_game
        jmp     tick.end

tick.select:
        cmp     dword [rdi - 32], 0
        je      tick.select.menu
        cmp     dword [rdi - 32], 3
        je      tick.select.ending

        jmp     tick.end

tick.up:
        cmp     dword [rdi - 32], 0
        je      tick.up.menu
        cmp     dword [rdi - 32], 2
        je      tick.up.game

        jmp     tick.end

tick.down:
        cmp     dword [rdi - 32], 0
        je      tick.down.menu
        cmp     dword [rdi - 32], 2
        je      tick.down.game

        jmp     tick.end

tick.left:
        cmp     dword [rdi - 32], 0
        je      tick.left.menu
        cmp     dword [rdi - 32], 2
        je      tick.left.game

        jmp     tick.end

tick.right:
        cmp     dword [rdi - 32], 0
        je      tick.right.menu
        cmp     dword [rdi - 32], 2
        je      tick.right.game

        jmp     tick.end

tick.up2:
        cmp     dword [rdi - 32], 2
        je      tick.up2.game

        jmp     tick.end

tick.down2:
        cmp     dword [rdi - 32], 2
        je      tick.down2.game

        jmp     tick.end

tick.left2:
        cmp     dword [rdi - 32], 2
        je      tick.left2.game

        jmp     tick.end

tick.right2:
        cmp     dword [rdi - 32], 2
        je      tick.right2.game

        jmp     tick.end

tick.select.menu:
        mov     r8b, byte [rdi - 398]
        cmp     r8b, 0
        je      tick.select.menu.start
        cmp     r8b, 1
        je      tick.select.menu.start2
        cmp     r8b, 4
        je      tick.select.menu.quit

        jmp     tick.end

tick.select.menu.start:
        mov     byte [rdi - 300], 0
        jmp     tick.state.start_game

tick.select.menu.start2:
        mov     byte [rdi - 300], 1
        jmp     tick.state.start_game

tick.select.menu.quit:
        jmp     tick.state.end_game

tick.select.ending:
        jmp     tick.state.reset_game

tick.up.menu:
        mov     r8b, byte [rdi - 398]

        dec     r8b

        cmp     r8b, 0
        jge     tick.up.menu.end

        mov     r8b, 4

tick.up.menu.end:
        mov     byte [rdi - 398], r8b

        jmp     tick.end

tick.down.menu:
        mov     r8b, byte [rdi - 398]

        inc     r8b

        cmp     r8b, 5
        jl      tick.down.menu.end

        mov     r8b, 0

tick.down.menu.end:
        mov     byte [rdi - 398], r8b

        jmp     tick.end

tick.left.menu:
        cmp     byte [rdi - 398], 2
        je      tick.left.menu.color1
        cmp     byte [rdi - 398], 3
        je      tick.left.menu.color2
        jmp     tick.end

; The copy paste is just too great
tick.left.menu.color1:
        mov     r8w, word [rdi - 334]
        dec     r8w
        cmp     r8w, 0x3930
        jge     tick.left.menu.color1.end

        mov     r8w, 0x3937

tick.left.menu.color1.end:
        mov     word [rdi - 334], r8w

        jmp     tick.end

tick.left.menu.color2:
        mov     r8w, word [rdi - 374]
        dec     r8w
        cmp     r8w, 0x3930
        jge     tick.left.menu.color2.end

        mov     r8w, 0x3937

tick.left.menu.color2.end:
        mov     word [rdi - 374], r8w

        jmp     tick.end

tick.right.menu:
        cmp     byte [rdi - 398], 2
        je      tick.right.menu.color1
        cmp     byte [rdi - 398], 3
        je      tick.right.menu.color2
        jmp     tick.end

; The copy paste is just too great
tick.right.menu.color1:
        mov     r8w, word [rdi - 334]
        inc     r8w
        cmp     r8w, 0x3937
        jle     tick.right.menu.color1.end

        mov     r8w, 0x3930

tick.right.menu.color1.end:
        mov     word [rdi - 334], r8w

        jmp     tick.end

tick.right.menu.color2:
        mov     r8w, word [rdi - 374]
        inc     r8w
        cmp     r8w, 0x3937
        jle     tick.right.menu.color2.end

        mov     r8w, 0x3930

tick.right.menu.color2.end:
        mov     word [rdi - 374], r8w

        jmp     tick.end

tick.up.game:
        cmp     byte [rdi - 336], 2     ; Don't let the player go in the opposite direction
        je      tick.end  
        mov     byte [rdi - 336], 0
        jmp     tick.end

tick.down.game:
        cmp     byte [rdi - 336], 0
        je      tick.end  
        mov     byte [rdi - 336], 2
        jmp     tick.end

tick.left.game:
        cmp     byte [rdi - 336], 1
        je      tick.end  
        mov     byte [rdi - 336], 3
        jmp     tick.end

tick.right.game:
        cmp     byte [rdi - 336], 3
        je      tick.end  
        mov     byte [rdi - 336], 1
        jmp     tick.end

tick.up2.game:
        cmp     byte [rdi - 300], 0     ; Single player?
        je      tick.end
        cmp     byte [rdi - 376], 2
        je      tick.end  
        mov     byte [rdi - 376], 0
        jmp     tick.end

tick.down2.game:
        cmp     byte [rdi - 300], 0
        je      tick.end
        cmp     byte [rdi - 376], 0
        je      tick.end  
        mov     byte [rdi - 376], 2
        jmp     tick.end

tick.left2.game:
        cmp     byte [rdi - 300], 0
        je      tick.end
        cmp     byte [rdi - 376], 1
        je      tick.end  
        mov     byte [rdi - 376], 3
        jmp     tick.end

tick.right2.game:
        cmp     byte [rdi - 300], 0
        je      tick.end
        cmp     byte [rdi - 376], 3
        je      tick.end  
        mov     byte [rdi - 376], 1
        jmp     tick.end

k:
        cmp     dword [rdi - 32], 0
        jne     k_5
        mov     r9b, byte [rdi - 290]
        and     r9b, 1
        cmp     r9b, 1
        mov     r9b, byte [rdi - 290]
        je      k_8
        cmp     r8b, 0
        je      k_10
        cmp     r9b, 0
        je      k_2
        cmp     r9b, 2
        je      k_2
        cmp     r8b, 2
        je      k_0
        cmp     r9b, 4
        je      k_7
        cmp     r9b, 6
        je      k_7
        cmp     r9b, 8
        je      k_1
        cmp     r9b, 10
        je      k_4
        cmp     r9b, 12
        je      k_1
        cmp     r9b, 14
        je      k_4
        cmp     r9b, 16
        je      k_3
        cmp     r9b, 18
        je      k_6
        jmp     k_5
k_0:
        cmp     r9b, 4
        jne     k_5
        jmp     k_10
k_1:
        cmp     r8b, 4
        jne     k_5
        jmp     k_9
k_2:
        cmp     r8b, 2
        jne     k_5
        jmp     k_9
k_3:
        cmp     r8b, 11
        jne     k_5
        jmp     k_9
k_4:
        cmp     r8b, 5
        jne     k_5
        jmp     k_9
k_5:
        mov     r9b, 0
        jmp     k_10
k_6:
        cmp     r8b, 10
        jne     k_5
        mov     word [rdi - 294], 8
        mov     word [rdi - 292], 1
        jmp     k_5
k_7:
        cmp     r8b, 3
        jne     k_5
        jmp     k_9
k_8:
        cmp     r8b, 0
        jne     k_5
k_9:
        inc     r9b
k_10:
        mov     byte [rdi - 290], r9b
        ret

tick.state.start_game:
        mov     eax, 42
        mov     r9w, 161
        mov     word [rdi - 396], r9w

        jmp     tick.end

tick.state.reset_game:
        mov     eax, 1337
        jmp     tick.end

tick.state.end_game:
        mov     eax, 69
        jmp     tick.end

        ; So, the menu has been handled
        ; Now we need to handle the actual gameplay
        ; State of 1 means the game is about to start
        ; State of 2 should mean it's actively happening

tick.end:
        cmp     eax, 1
        je      tick.exec.starting
        cmp     eax, 666
        je      tick.exec.init
        cmp     eax, 2
        je      tick.exec.playing
        cmp     eax, 3
        je      tick.exec.ending

        jmp     tick.finish

tick.exec.starting:
        mov     r8w, word [rdi - 396]
        dec     r8
        mov     word [rdi - 396], r8w

        cmp     r8d, 0
        jge     tick.finish

tick.exec.starting.next:
        inc     eax

        jmp     tick.finish

tick.exec.init:
        ; Initialize the board and whatever else, now that we have it

        xor     r8, r8
        mov     r9d, dword [rdi - 386]

tick.exec.init.loop_board:
        mov     r10, [rdi - 394]
        add     r10, r8

        mov     byte [r10], 0

        inc     r8
        cmp     r8d, r9d
        jl      tick.exec.init.loop_board

        ; Set up the player positions
        movsx   r8, word [rdi - 14]     ; We have the dimensions of the board
        movsx   r9, word [rdi - 16]

        sub     r8, 12
        sub     r9, 2

        shr     r9, 1                   ; We have the y position of our players
        mov     word [rdi - 378], r9w
        mov     word [rdi - 338], r9w

        mov     word [rdi - 380], 10    ; The x position
        mov     word [rdi - 340], r8w

        ; Set up the directions
        mov     byte [rdi - 376], 1     ; NESW
        mov     byte [rdi - 375], 1
        mov     byte [rdi - 336], 3
        mov     byte [rdi - 335], 3

        ; Add them to the board
        mov     r10, [rdi - 394]        ; Add player 1
        movsx   r8, word [rdi - 380]
        add     r10, r8
        movsx   rax, word [rdi - 378]
        movsx   r8, word [rdi - 14] 
        sub     r8, 2
        mul     r8
        add     r10, rax
        mov     byte [r10], 7

        mov     r10, [rdi - 394]        ; Add player 2
        movsx   r8, word [rdi - 340]
        add     r10, r8
        movsx   rax, word [rdi - 338]
        movsx   r8, word [rdi - 14]
        sub     r8, 2 
        mul     r8
        add     r10, rax
        mov     byte [r10], 17

        ; The game is done setting up
        mov     eax, 1

        jmp     tick.finish

tick.exec.playing:
        ; Run the main action here
        ; So, I need a board, the positions of the players, their current direction
        ; Also, only make this change once every few frames, so like 10 times per second?
        ; Never mind, running the game tick any slower is too easy and slow
        mov     r8, [rdi - 8]           ; Get the current tick
        and     r8b, 0                  ; Right now it's running every tick...
        cmp     r8b, 0
        jne     tick.finish

        push    rdi
        call    bikes
        pop     rdi

        cmp     rax, 1                  ; Player 1 has crashed
        je      tick.exec.playing.p2_win
        cmp     rax, 2                  ; Player 2 has crashed
        je      tick.exec.playing.p1_win

        ; Update the players' old directions
        mov     r8b, byte [rdi - 376]
        mov     byte [rdi - 375], r8b
        mov     r8b, byte [rdi - 336]
        mov     byte [rdi - 335], r8b

        mov     eax, 2
        jmp     tick.finish

tick.exec.playing.p1_win:
        mov     eax, 3
        mov     byte [rdi - 299], 1

        mov     r8w, word [rdi - 340]
        mov     word [rdi - 298], r8w
        mov     r8w, word [rdi - 338]
        mov     word [rdi - 296], r8w

        jmp     tick.finish

tick.exec.playing.p2_win:
        mov     eax, 3
        mov     byte [rdi - 299], 2

        mov     r8w, word [rdi - 380]
        mov     word [rdi - 298], r8w
        mov     r8w, word [rdi - 378]
        mov     word [rdi - 296], r8w

        jmp     tick.finish

tick.exec.ending:
        ; Well, the game's ended... Not much to do here, really
        jmp     tick.finish

tick.finish:
        mov     rsp, rbp
        pop     rbp

        ret