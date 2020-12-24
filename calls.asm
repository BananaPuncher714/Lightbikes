extern  printf

; Just some utility functions for the project
; Some of them rely on ANSI tricks, so be sure your terminal is ANSI compatible!

        section .data
reset:  db      0x1b, "[0;0H"
r_len:  equ     $ - reset

clear:  db      0x1b, "[2J"
c_len:  equ     $ - clear

c_hide: db      0x1b, "[?25l"
ch_len: equ     $ - c_hide
c_show: db      0x1b, "[?25h"
cs_len: equ     $ - c_show

        section .bss
vmin:   resb    1
vtime:  resb    1

        section .text
        global set_canonical
        global clear_buffer
        global get_screen_size
        global sleep
        global reset_cursor
        global clear_screen
        global show_cursor
        global hide_cursor

; Set to non canonical without echoing input, or canonical with echoing input
%define flag    byte [rbp - 1]
%define lflag   byte [rbp - 36]

set_canonical:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 48
        mov     flag, al

        mov     rax, 16                 ; sys_ioctl
        mov     rdi, 0
        mov     rsi, 0x5401             ; tgets
        lea     rdx, [rbp - 48]         ; Store it in the stack
        syscall

        cmp     flag, 0
        je      set_canonical.if_not_canonical

        ; Set to canonical
        or      lflag, 0b00001010
        mov     r8b, [vmin]
        mov     byte [rbp - 25], r8b
        mov     r8b, [vtime]
        mov     byte [rbp - 24], r8b
        jmp     set_canonical.if_canonical_end

set_canonical.if_not_canonical:
        ; Set to non canonical and don't echo the input
        and     lflag, 0b11110101
        mov     r8b, byte [rbp - 25]    ; Thank goodness for this post: https://forum.nasm.us/index.php?topic=2236.0
        mov     [vmin], r8b             ; I wouldn't have figured out where the VTIME and VMIN were, since the termios
        mov     r8b, byte [rbp - 24]    ; description at https://man7.org/linux/man-pages/man3/termios.3.html says differently
        mov     [vtime], r8b
        mov     byte [rbp - 25], 0
        mov     byte [rbp - 24], 0

set_canonical.if_canonical_end:
        mov     rax, 16                 ; sys_ioctl
        mov     rdi, 0
        mov     rsi, 0x5402             ; tsets
        lea     rdx, [rbp - 48]
        syscall

        mov     rsp, rbp
        pop     rbp

        ret

; Get the size of the screen, in characters
get_screen_size:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 16

        mov     rax, 16                 ; sys_ioctl
        mov     rdi, 1                  ; stdout
        mov     rsi, 0x5413             ; tsiocgwinsz
        lea     rdx, [rbp - 16]
        syscall

        mov     eax, dword [rbp - 16]   ; Get the row + col

        mov     rsp, rbp
        pop     rbp

        ret

; I have no clue if this actually does much, but it's supposed to read in until the next newline
clear_buffer:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 16

clear_buffer.loop_start:
        xor     rax, rax                ; System call read
        xor     rdi, rdi                ; stdin
        lea     rsi, [rbp - 16]
        mov     rdx, 1
        syscall

        cmp     byte [rbp - 16], 10
        jne     clear_buffer.loop_start

        mov     rsp, rbp
        pop     rbp

        ret

; Sleep for the specified seconds and nanoseconds
; Uses sys_nanosleep
sleep:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 16                 ; Create the timespec struct
        mov     [rbp - 16], rdi
        mov     [rbp - 8], rsi

        mov     rax, 35
        mov     rdi, rsp
        xor     rsi, rsi
        syscall

        mov     rsp, rbp
        pop     rbp

        ret

; Set the cursor to the top left of the screen
reset_cursor:
        push    rbp
        mov     rbp, rsp

        mov     rax, 1                  ; System call write
        mov     rdi, 1                  ; stdout
        mov     rsi, reset
        mov     rdx, r_len
        syscall

        pop     rbp

        ret

; Clear the screen
clear_screen:
        push    rbp
        mov     rbp, rsp

        mov     rax, 1                  ; System call write
        mov     rdi, 1                  ; stdout
        mov     rsi, clear
        mov     rdx, c_len
        syscall

        pop     rbp

        ret

; Show the cursor
show_cursor:
        push    rbp
        mov     rbp, rsp

        mov     rax, 1                  ; System call write
        mov     rdi, 1                  ; stdout
        mov     rsi, c_show
        mov     rdx, cs_len
        syscall

        pop     rbp

        ret

; Hide the cursor, hopefully the terminal supports it
hide_cursor:
        push    rbp
        mov     rbp, rsp

        mov     rax, 1                  ; System call write
        mov     rdi, 1                  ; stdout
        mov     rsi, c_hide
        mov     rdx, ch_len
        syscall

        pop     rbp

        ret