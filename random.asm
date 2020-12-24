        section .bss
; Current random number and seed
rand:   resb    8

        section .text
global  set_seed
global  next_rand

; Generate the random number using the current Epoch time as the seed. Returns the seed used.
; This uses the current second though, not the millisecond, so it's not very good
; Prototype: long seed();
; Returns the seed used
%define CLK_M_R 4

set_seed:
        push    rbp
        mov     rbp, rsp

        sub     rsp, 32

        mov     [rbp - 8], rbx

        mov     rax, 228                ; System call clock_gettime
        mov     rdi, CLK_M_R
        lea     rsi, [rbp - 32]
        syscall

        mov     rax, [rbp - 24]         ; Get the nanoseconds
        xor     rdx, rdx                ; Clear upper 64 bits
        mov     rbx, 21569              ; Divide by m=21569
        div     rbx
        mov     [rand], rdx             ; Set the value at rand as the remainder

        mov     rbx, [rbp - 8]

        mov     rsp, rbp
        pop     rbp

        ret

; Returns a new random number
; Uses a linear congruential generator formula with the following constants:
; a = 14359
; b = 9654
; m = 21569
; Prototype: long next_rand()
; Returns a random number
next_rand:
        push    rbp
        mov     rbp, rsp

        push    rbx

        mov     rax, [rand]             ; Copy the current random number to rax

        mov     rbx, 14359              ; Multiply it by a=14359
        mul     rbx
        add     rax, 9654               ; Add b=9654
        xor     rdx, rdx
        mov     rbx, 21569              ; Divide it by m=21569
        div     rbx
        mov     [rand], rdx             ; Set the remainder as the new rand
        mov     rax, rdx

        pop     rbx

        pop     rbp

        ret