# ASM_guessNum

someone asked me if I could develop a game in assembly language.... 
this is super simple, but it'0s a game :-)

intel syntax, 64 bits, linux...

; 64 bits:
; Compile with: nasm -f elf64 guessNum.asm -o guessNum.o
; 64 bits: Link with : ld guessNum.o -o guessNum

; Run calling guessNum with the number to guess as an argument
; example: : ./guessNum 48
