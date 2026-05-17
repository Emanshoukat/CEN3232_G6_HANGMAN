.model small
.stack 100h

.data

;Word Bank

word0 db "EmanPagal$"
word1 db "Cristiano$"
word2 db "Bobzy$"
word3 db "Kroos$"
word4 db "Monitors$"
word5 db "Huraira$"
word6 db "Resume$"
word7 db "Griffin$"

wordPtrs dw offset word0, offset word1, offset word2, offset word3,
         dw offset word4, offset word5, offset word6, offset word7

;Game State Variables

currentWord  db 20 dup("$")
guessedWord  db 20 dup(" ")
wrongGuesses db 20 dup(0)

wordLen      db 0
wrongCount   db 0
guessedCount db 0
gameOver     db 0

;LCG Seed

randSeed dw 0


msgTitle   db "========= HANGMAN GAME =========", 13, 10, "$"
msgGuess   db 13, 10, "Enter a letter: $"
msgWrong   db 13, 10, "Wrong! Try again.", 13, 10, "$"
msgCorrect db 13, 10, "Correct!" ,13, 10, "$"
msgAlready db 13, 10, "Already guessed that letter!", 13, 10, "$"
msgWin     db 13, 10, "*** YOU WIN! Congratulations!***", 13, 10, "$"
msgLose    db 13, 10, "*** YOU LOSE! Better luck next time! ***", 13, 10,"$"
msgWord    db 13, 10, "The word was: $" 
msgWrongs  db 13, 10, "Wrong letters: $"
msgTries   db 13, 10, "Tries left: $"
msgNewline db 13, 10, "$"
msgEnter   db 13, 10, "Press any key to exit...", "$"

;Hangman Stages 
hang0 db '  +---+  ', 13, 10,
           db '  |   |  ', 13, 10,
           db '  |      ', 13, 10,
           db '  |      ', 13, 10,
           db '  |      ', 13, 10,
           db '  |      ', 13, 10,
           db '=========$'
hang1 db '  +---+  ', 13, 10,
           db '  |   |  ', 13, 10,
           db '  |   O  ', 13, 10,
           db '  |      ', 13, 10,
           db '  |      ', 13, 10,
           db '  |      ', 13, 10,
           db '=========$'
hang2 db '  +---+  ', 13, 10,
           db '  |   |  ', 13, 10,
           db '  |   O  ', 13, 10,
           db '  |   |  ', 13, 10,
           db '  |      ', 13, 10,
           db '  |      ', 13, 10,
           db '=========$'
hang3 db '  +---+  ', 13, 10,
           db '  |   |  ', 13, 10,
           db '  |   O  ', 13, 10,
           db '  |  /|  ', 13, 10,
           db '  |      ', 13, 10,
           db '  |      ', 13, 10,
           db '=========$'
hang4 db '  +---+  ', 13, 10,
           db '  |   |  ', 13, 10,
           db '  |   O  ', 13, 10,
           db '  |  /|\ ', 13, 10,
           db '  |      ', 13, 10,
           db '  |      ', 13, 10,
           db '=========$'
hang5 db '  +---+  ', 13, 10,
           db '  |   |  ', 13, 10,
           db '  |   O  ', 13, 10,
           db '  |  /|\ ', 13, 10,
           db '  |  /   ', 13, 10,
           db '  |      ', 13, 10,
           db '=========$'
hang6 db '  +---+  ', 13, 10,
           db '  |   |  ', 13, 10,
           db '  |   O  ', 13, 10,
           db '  |  /|\ ', 13, 10,
           db '  |  / \ ', 13, 10,
           db '  |      ', 13, 10,
           db '=========$'
hangPtrs dw offset hang0, offset hang1, offset hang2, offset hang3, 
dw offset hang4, offset hang5, offset hang6

.code
main proc

       mov ax, @data
       mov ds, ax

       mov ah, 00h
       int 1ah


       xor dx, cx
       mov randSeed, dx

       call Pick_Word



Game_Loop:

        cmp gameOver, 1
        je Player_won

        cmp gameOver, 2
        je player_lost

        jmp Exit_Game




Player_won:

         lea dx, msgWin
         mov ah, 09h
         int 21h

         jmp Exit_Game



Player_Lost:

         lea dx, msgLose
         mov ah, 09h
         int 21h

         lea dx, msgWord
         mov ah, 09h
         int 21h


       
Exit_Game:

         lea dx, msgEnter
         mov ah, 09h
         int 21h

         mov ah, 01h
         int 21h
         

         mov ah, 4ch
         int 21h

main endp


Pick_Word proc

       mov ax, randSeed
       mov bx, 25173
       mul bx

       add ax, 13849
       mov randSeed, ax

       xor dx, dx
       mov bx, 8
       div bx

       mov bx, dx
       shl bx, 1

       mov si, wordPtrs[bx]
 
       lea di, currentWord
       lea bx, guessedWord

       mov cx, 0


Copy_Loop:

       mov al, [si]
       cmp al, "$"

       je Copy_Done

       mov [di], al
       mov byte ptr [bx], "_"

       inc si
       inc di
       inc bx
       inc cx

       jmp Copy_Loop



Copy_Done:

      mov [di], al
      mov byte ptr [bx], "$"

      mov wordLen, cl
      mov wrongCount,   0
      mov guessedCount, 0
      mov gameOver,     0

     lea di, wrongGuesses
     mov cx, 20



Clear_Wrong:

      mov byte ptr [di], 0

      inc di
      loop Clear_Wrong

      ret


Pick_Word endp

Print_Hangman proc 
push ax 
push bx 
push dx 
xor bx, bx 
mov bl, wrongCount
shl bx, 1
mov dx, hangPtrs[bx]
mov ah, 09h
int 21h
pop dx
pop bx
pop ax
ret 
Print_Hangman endp 

Print_Guessed_Word proc
push ax
push dx
push si 
lea si, guessedWord

pg_loop:
mov al, [si]
cmp al, '$'
je pg_done 
mov dl, al 
mov ah, 02h
int 21h 
mov dl, ' '
mov ah, 02h
int 21h 
inc si 
jmp pg_loop 

pg_done:
pop si 
pop dx
pop ax
ret 
Print_Guessed_Word endp

Print_Wrong_Letters proc
push ax
push cx
push dx 
push si 
lea si, wrongGuesses
mov cx, 20

pw_loop:
mov al, [si]
cmp al, 0 
je pw_done
mov dl, al 
mov ah, 02h
int 21h
inc si 
loop pw_loop 

pw_done:
pop si 
pop dx
pop cx
ret 
Print_Wrong_Letters endp 

Print_Current_Word proc
push ax
push dx
push si 
lea si, currentWord

pcw_loop:
mov al, [si]
cmp al, '$'
je pcw_done 
mov dl, al 
mov ah, 02h
int 21h 
inc si 
imp pcw_loop 

pcw_done:
pop si 
pop dx 
pop ax
ret
Print_Current_Word endp

Clear_Screen proc 
push ax
push bx
push cx
push dx
mov ah, 06h
mov al, 0
mov bh, 07h
mov cx, 0000h
mov dx, 184fh
int 10h 
mov ah, 02h
mov bh, 0 
mov dx, 0000h 
int 10h
pop dx
pop cx
pop bx
pop ax 
ret 
Clear_Screen endp


end main