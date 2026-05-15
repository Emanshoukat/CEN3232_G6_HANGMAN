# Coal-Project-Hangman
.model small
.stack 100h

.data

word1 db "EmanPagal$"
word2 db "Cristiano$"
word3 db "Bobzy$"
word4 db "Kroos$"
word5 db "Monitors$"
word6 db "Huraira$"
word7 db "Resume$"
word8 db "Griffins$"

wordptr dw offset word1, offset word2, offset word3, offset word4,
        dw offset word5, offset word6, offset word7, offset word8



currentWord db 20 dup<"$">
guessedWord db 20 dup<" ">
wrongGuesses db 20 dup<0>
wordLen      db 0
wrongCount   db 0
guessesCount db 0
gameOver     db 0

msgTitle   db '========= HANGMAN GAME =========' , 13,10, '$'
msgGuess   db 13, 10, 'Enter a letter: $'
msgWord    db 13, 10, 'Wrong! Try again.', 13, 10, '$'
msgCorrect db 13, 10, 'Correct!', 13,10,'$'
msgAlready db 13, 10, 'Already guessed that letter!', 13, 10, '$'
msgWin     db 13, 10, '*** YOU WIN! Congratulations! ***', 13, 10 '$'
msgLose    db 13, 10, '*** YOU LOSE! Better luck next time! ***', 13, 10 '$'
msgWord    db 13, 10, 'The word was: $'
msgWrongs  db 13, 10, 'Wrong letters: $'
msgsTries  db 13, 10, 'Tries left: $'
msgNewline db 13, 10, '$'
msgEnter   db 13, 10, 'Press any key to exit---', '$'

randSeed dw 0

hang0 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang1 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10, ; head appears
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang2 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |   |  ', 13, 10,   ; body appears
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang3 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |  /|  ', 13, 10,   ; left arm appears
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang4 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |  /|\ ', 13, 10, ; both arms appear
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang5 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |  /|\ ', 13, 10,
DB '  |  /   ', 13, 10, ; left leg appears 
DB '  |      ', 13, 10,
DB '=========$'

hang6 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |  /|\ ', 13, 10,
DB '  |  / \ ', 13, 10, ; both legs - game over stage
DB '  |      ', 13, 10,
DB '=========$'












































