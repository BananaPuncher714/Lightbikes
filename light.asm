extern  draw
extern  get_screen_size
extern  sleep
extern  set_canonical
extern  show_cursor
extern  hide_cursor

extern  tick

extern  draw_border
extern  draw_logo
extern  draw_menu
extern  draw_field
extern  draw_countdown
extern  draw_square
extern  draw_winner

        section .text
        global main

; Now, a technical explanation so you don't have to trudge through the mess of comments
; and random stuff that I never bothered to clean up.
;
; I have the game running at 40 fps. In addition, the main menu will resize itself if
; you resize your terminal. It will "lock" the resolution once the game starts, since
; it uses the entire screen as the playing field. The actual drawing is done by a draw method
; which creates a huge string that it prints every frame. I have a bunch of function pointers
; in an array that determine what character goes where. I also have a game state var so that
; the functions know when to draw and when not to draw. The function pointers also support unicode,
; so that's a pretty big plus. The colors are done using ANSI color sequences and everything else
; is standard Tron game logic.

; The main stuff works, sort of. So far it hasn't broken yet
; I can't care enough to define any more macros
%define GM_STE  dword [rbp - 32]

main:
light:
        push    rbp
        mov     rbp, rsp

        xor     rax, rax                ; Set to non canonical mode
        call    set_canonical
        call    hide_cursor

        sub     rsp, 464                ; Overkill? Maybe, but it sucks to not have space when you need it

        ; Initialize the game struct here
        mov     dword [rbp - 4], 0
        mov     dword [rbp - 8], 0      ; The current tick
        mov     dword [rbp - 16], 0     ; The screen width and height
        mov     dword [rbp - 24], 0     ; The location of the board
        mov     GM_STE, 0               ; The game state

        ; The amount of ns per tick
        ; Right now it's set to 40 tps
        ; You wouldn't make it slower... right?!
        ; After all, only kids play on EASY MODE
        mov     dword [rbp - 40], 25000000

        ; mov     dword [rbp - 268], 0  ; The drawing functions
        ; mov     dword [rbp - 272], 0

        mov     byte [rbp - 290], 0
        mov     word [rbp - 292], 20
        mov     word [rbp - 294], 160
        mov     word [rbp - 296], 0     ; Y crash
        mov     word [rbp - 298], 0     ; X crash
        mov     byte [rbp - 299], 0     ; The winner
        mov     byte [rbp - 300], 0     ; Multiplayer

        mov     word [rbp - 334], 0x3935; Player 2 color
        mov     byte [rbp - 335], 0     ; Player 2 previous direction
        mov     byte [rbp - 336], 0     ; Player 2 direction
        mov     word [rbp - 338], 0     ; Player 2 y
        mov     word [rbp - 340], 0     ; Player 2 x
        mov     word [rbp - 374], 0x3934; Player 1 color
        mov     byte [rbp - 375], 0     ; Player 1 previous direction
        mov     byte [rbp - 376], 0     ; Player 1 direction
        mov     word [rbp - 378], 0     ; Player 1 y
        mov     word [rbp - 380], 0     ; Player 1 x

        mov     dword [rbp - 386], 0    ; The length of the board
        mov     dword [rbp - 390], 0
        mov     dword [rbp - 394], 0    ; The address of the board
        mov     word [rbp - 396], 0     ; Countdown
        mov     byte [rbp - 398], 0     ; Menu option
        mov     byte [rbp - 399], 0     ; Lock the size of the screen
        mov     byte [rbp - 400], 0     ; Keypress
        mov     dword [rbp - 416], 0    ; The timespec for the start of the tick
        mov     dword [rbp - 432], 0    ; The timespec for the end of the tick

        ; Set up the drawing functions
        mov     r8, draw_winner
        mov     [rbp - 272], r8
        mov     r8, draw_square
        mov     [rbp - 264], r8
        mov     r8, draw_countdown
        mov     [rbp - 256], r8
        mov     r8, draw_field
        mov     [rbp - 248], r8
        mov     r8, draw_logo
        mov     [rbp - 240], r8
        mov     r8, draw_menu
        mov     [rbp - 232], r8
        mov     r8, draw_border
        mov     [rbp - 224], r8
        mov     dword [rbp - 216], 0
        mov     dword [rbp - 212], 0

light.loop_start:
        ; First, calculate when the tick starts
        mov     rax, 228                ; System call clock_gettime
        mov     rdi, 4
        lea     rsi, [rbp - 416]
        syscall

        ; Then, capture user input
        xor     rax, rax
        call    get_key
        mov     byte [rbp - 400], al

        ; If the game state is 42, then set it to 666 and set up the board, it means the game is starting
        cmp     GM_STE, 42
        jne     light.special_state_end

        mov     GM_STE, 666             ; Set the state to 666
        mov     byte [rbp - 399], 1     ; Lock the screen dimensions
        movsx   r8, word [rbp - 14]
        sub     r8, 2
        movsx   rax, word [rbp - 16]
        sub     rax, 2
        mul     r8                      ; Get the dimensions in rax
        mov     r8, rax
        mov     dword [rbp - 386], eax  ; Store the length
        shr     r8, 4                   ; Calculate how many alignment things we need
        inc     r8
        shl     r8, 4
        sub     rsp, r8
        mov     [rbp - 394], rsp        ; Get the current position and save it as the board

light.special_state_end:
        ; If the game has ended, then let's undo the stack
        cmp     GM_STE, 1337
        jne     light.end_state_end

        mov     GM_STE, 0               ; Go back to the menu
        mov     byte [rbp - 399], 0     ; Unlock the screen dimensions
        lea     rsp, [rbp - 464]

light.end_state_end:
        ; Update the game struct
        cmp     byte [rbp - 399], 1     ; Check if the screen dimensions are locked
        je      light.update_screen_end
        call    get_screen_size         ; Update the screen size
        mov     [rbp - 16], eax

light.update_screen_end:

        ; Set the screen size to 40x20 for debugging purposes
        ; mov     word [rbp - 16], 20
        ; mov     word [rbp - 14], 40

        ; Then, run the main game tick
        mov     rdi, rbp
        call    tick
        mov     GM_STE, eax    ; Update the game state

        ; Then, draw to the board
        mov     rdi, rbp
        call    draw

        ; Check for end status
        cmp     GM_STE, 69
        je      light.loop_end

        ; Wait until the next game tick
        mov     rax, 228                ; System call clock_gettime
        mov     rdi, 4
        lea     rsi, [rbp - 432]
        syscall

        ; Assuming that the events took no time, then sleep for 25,000,000 ns
        ; But, we know when so we need to calculate the difference
        mov     r8, [rbp - 416]         ; Get the difference in seconds
        mov     r9, [rbp - 432]

        sub     r9, r8
        mov     rax, r9
        mov     r10, 1000000000
        mul     r10                     ; Multiply by 1 billion
        mov     r8, [rbp - 408]         ; Get the nanoseconds
        mov     r9, [rbp - 424]
        sub     r9, r8                  ; Calculate the difference
        add     rax, r9                 ; Find the total amount of time that's passed
        movsx   r9, dword [rbp - 40]
        sub     r9, rax                 ; Subtract the amount that's elapsed from the wait time
        cmp     r9, 0
        jle     light.loop_sleep_end    ; It's been well over 25000000 ns... Continue on
        mov     rax, r9
        xor     rdx, rdx
        mov     r10, 1000000000
        div     r10                     ; Divide to find how many seconds and nanoseconds
        mov     rdi, rax                ; Move the amount of seconds to rdi
        mov     rsi, rdx                ; Move the amount of ns to rsi
        call    sleep                   ; Sleep

        mov     r8, [rbp - 8]           ; Increment the current tick
        inc     r8
        mov     [rbp - 8], r8

light.loop_sleep_end:
        jmp     light.loop_start

light.loop_end:
        call    clear_non_canonical_buffer

        mov     al, 1                   ; Set to canonical mode
        call    set_canonical
        call    show_cursor

        xor     rax, rax

        mov     rsp, rbp
        pop     rbp

        ret

; So, we need to get which key the user is pressing... Hopefully we can read it in properly
; Let's say
; 0 = no input
; 1 = space/enter
; 2 = up
; 3 = down
; 4 = left
; 5 = right
get_key:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 16

        xor     rax, rax                ; Read in syscall
        xor     rdi, rdi
        lea     rsi, [rbp - 16]
        mov     rdx, 1
        syscall

        mov     cl, byte [rbp - 16]     ; Get the key that they pressed
        cmp     cl, 0x1b
        je      get_key.arrow_input
        cmp     cl, " "
        je      get_key.space
        cmp     cl, "a"
        je      get_key.a
        cmp     cl, "b"
        je      get_key.b
        cmp     cl, "d"
        je      get_key.d
        cmp     cl, "s"
        je      get_key.s
        cmp     cl, "w"
        je      get_key.w
        cmp     cl, 10
        je      get_key.space
        jmp     get_key.clear

get_key.space:
        mov     rax, 1
        jmp     get_key.end

get_key.a:
        mov     rax, 10
        jmp     get_key.end

get_key.b:
        mov     rax, 11
        jmp     get_key.end

get_key.d:
        mov     rax, 12
        jmp     get_key.end

get_key.s:
        mov     rax, 13
        jmp     get_key.end

get_key.w:
        mov     rax, 14
        jmp     get_key.end

get_key.arrow_input:
        xor     rax, rax                ; Read in syscall
        xor     rdi, rdi
        lea     rsi, [rbp - 16]
        mov     rdx, 2
        syscall

        mov     cl, byte [rbp - 15]
        cmp     cl, 0
        je      get_key.esc
        cmp     cl, "A"
        je      get_key.arrow_input.up
        cmp     cl, "B"
        je      get_key.arrow_input.down
        cmp     cl, "C"
        je      get_key.arrow_input.right
        cmp     cl, "D"
        je      get_key.arrow_input.left
        jmp     get_key.end

get_key.esc:
        mov     rax, 69
        jmp     get_key.end

get_key.arrow_input.up:
        mov     rax, 2
        jmp     get_key.end

get_key.arrow_input.down:
        mov     rax, 3
        jmp     get_key.end

get_key.arrow_input.right:
        mov     rax, 5
        jmp     get_key.end

get_key.arrow_input.left:
        mov     rax, 4
        jmp     get_key.end

get_key.clear:
        xor     rax, rax

get_key.end:
        mov     rsp, rbp
        pop     rbp

        ret

clear_non_canonical_buffer:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 16

clear_non_canonical_buffer.loop_start:
        xor     rax, rax                ; Read in syscall
        xor     rdi, rdi
        lea     rsi, [rbp - 16]
        mov     rdx, 16
        syscall

        cmp     rax, 0                  ; Keep looping until we have captured all the input
        jne     clear_non_canonical_buffer.loop_start

        mov     rsp, rbp
        pop     rbp

        ret