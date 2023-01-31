; Game: guess the number

; 64 bits:
; Compile with: nasm -f elf64 guessNum.asm -o guessNum.o
; 64 bits: Link with : ld guessNum.o -o guessNum

; Run calling guessNum with the number to guess as an argument
; example: : ./guessNum 48

bits 64

%include 'functions.asm'

section .data
    msg_ask1: db "(try No ", 0
    msg_ask2: db ") - what is your choice?: ", 0
    msg_toosmall: db "nooooooo, that's too small, try again", 0
    msg_toobig: db "omg, that's too big, try again", 0
    msg_success1: db "you guessed in ", 0
    msg_success2: db " attempt(s)", 0

    STDIN: equ 0
    SYS_READ: equ 0

section .bss
    sinput: resb 255

section .text
    global _start

    _start:
        
        pop rdi    ; premiere valeur de la pile = nombre d'arguments, mais on ignore
        pop rdx    ; 2eme argument = nom du prog, on ignore aussi
        pop rax    ; normalement on recupère le nombre a deviner

        call atoi  ; on convertit le parametre en integer

        mov rdx, rax  ; on garde la valeur a deviner dans rdx
        mov rdi, 0    ; on met notre compteur d'essais a 0

    guessLoop:
        inc rdi
        mov rax, msg_ask1
        call sprint
        mov rax, rdi
        call iprint
        mov rax, msg_ask2
        call sprint


        push rdx     ; on sauvegarde notre rdx (valeur a trouver)
        push rdi     ; on sauvegarde notre compteur d'essais
        mov rdx, 255
        mov rsi, sinput
        mov rdi, STDIN
        mov rax, SYS_READ
        syscall

        mov rax, sinput
        call atoi

        pop rdi
        pop rdx

        cmp rax, rdx
        je winner
        jl toosmall

    toobig:
        mov rax, msg_toobig
        call sprintRC
        jmp guessLoop

    toosmall:
        mov rax, msg_toosmall
        call sprintRC
        jmp guessLoop

    winner:
        mov rax, msg_success1
        call sprint
        mov rax, rdi
        call iprint
        mov rax, msg_success2
        call sprintRC
        jmp lafin

    lafin:    
        call quit
