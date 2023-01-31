; -----------------------------------------------
; int slen(String message)
; calcul longueur d'une string
; rax doit avoir l'adresse de la string
; en retour rax contient le nombre de caractères
strlen:
    push rbx
    mov  rbx, rax

.nextchar:
    cmp byte[rax], 0
    jz  .finished
    inc rax
    jmp .nextchar

.finished:
    sub rax, rbx
    pop rbx
    ret


; -----------------------------------------------------
; void sprint(String message)
; affiche une string sur la console
; rax doit contenir le message a afficher
; pas de retour
SYS_WRITE: equ 1
STDOUT: equ 1

sprint:
    push rdx
    push rsi
    push rdi
    push rax
    call strlen

    mov rdx, rax
    pop rax

    mov rsi, rax
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

    pop rdi
    pop rsi
    pop rdx
    ret


; -----------------------------------------------------
; void sprintRC(String message)
; la fonction sprint mais avec un Retour Charriot
;
sprintRC:
    call sprint

    push rax       ; on sauvegarde le contenu de rax
    mov  rax, 0Ah  ; on met 10 dans rax = valeur du retour charriot
    push rax       ; on met le RC dans la pile pour avoir l'adresse
    mov  rax, rsp  ; on récupère l'addres de la pile ou est gardé le RC
    call sprint    ; on appelle sprint pour afficher le RC
    pop rax        ; on pop le RC pour le virer de la pile
    pop rax        ; ce pop remet la valeur originale de rax
    ret




; ---------------------------------------------------
; void exit()
; fonction pour quitter le prog
SYS_EXIT: equ 60

quit:
    mov rdi, 0
    mov rax, SYS_EXIT
    syscall
    ret


; -----------------------------------------------------
; void iprint(Integer number)
; fonction que print un entier sur la console 
iprint: 
    push rax      ; on sauvegarde rax dans la pile
    push rdi      ; on sauvegarde rdi dans la pile
    push rdx      ; on sauvegarde rdx dans la pile
    push rsi      ; on sauvegarde rsi dans la pile
    mov rdi, 0    ; on initialise rdi a 0 ( compteur)

divideLoop:
    inc rdi       ; on compte le nombre de bytes a imprimer
    mov rdx, 0    ; on vide rdx
    mov rsi, 10   ; on met 10 dans rsi pour la division 
    idiv rsi      ; la division divise rax par rsi
    add rdx, 48   ; rdx contient le reste de la division, on ajoute 48 pour convertir en integer
    push rdx      ; on sauvegarde notre integer
    cmp rax, 0    ; rax contient le résultat d ela division, on regarde si il vaut 0
    jnz divideLoop ; si rax n'est pas egal a 0 alors on recommence

printLoop:
    dec rdi       ; rdi contient le nombre de bytes (digit) a imprimer, on commence a décrémenter
    mov rax, rsp  ; on met dans rax l'adresse du premier digit (byte) a imprimer
    call sprint   ; on appelle la fonction sprint
    pop rax       ; le pop va effacer le digit qui a été imprimé
    cmp rdi, 0    ; on vérifie si rdi est a 0, sinon on recommence
    jnz printLoop

    pop rsi       ; on restaure le svaleurs sauvegardées dans la pile
    pop rdx
    pop rdi
    pop rax
    ret


; -----------------------------------------------------
; void iprintRC(Integer number)
; fonction que print un entier sur la console avec un Retour Charriot
iprintRC:
    call iprint

    push rax
    mov rax, 0Ah
    push rax
    mov rax, rsp
    call sprint
    pop rax
    pop rax
    ret

; ------------------------------------------------
; int atoi(int number)
; fonction qui convertit la valeur ASCII en integer
; si rax contient une valeur ASCII, la fonction retourne un integer dans rax

atoi:
    push rbx
    push rdi
    push rdx
    push rsi
    mov rsi, rax
    mov rax, 0
    mov rdi, 0

multiplyLoop:
    xor rbx, rbx
    mov bl, [rsi+rdi]
    cmp bl, 48
    jl endLoop
    cmp bl, 57
    jg endLoop

    sub bl, 48
    add rax, rbx
    mov rbx, 10
    mul rbx
    inc rdi
    jmp multiplyLoop

endLoop:
    cmp rdi, 0
    je restore
    mov rbx, 10
    div rbx

restore:
    pop rsi
    pop rdx
    pop rdi
    pop rbx
    ret
