#|
Justin Foster
CS 441 - Parser Project
10/17/2021
|#

#lang racket

#|trying to import lexer library and use ":" as lexer prefix
 so that math operators are read
 (https://docs.racket-lang.org/parser-tools/Lexers.html)
|#
(provide (all-defined-out))
(require parser-tools/lex
         parser-tools/yacc
         (prefix-in : parser-tools/lex-sre))

#|Converting input file to a string |#
#|
(define inputToString(file->list "Input01.txt"))
(list? inputToString)
(for ([i inputToString])
  (display i))
|#

(define inputToString(file->string "Input01.txt"))
(display inputToString)

#|I think this might be redudant but it seems to not work if i dont list
every character |#
(define-lex-abbrevs
  [character (:or (char-range "A" "z"))]
  [digit (:/ #\0 #\9)]
  [string (:/ "read" "write")]
  )


(define-empty-tokens operators (- + / * := $$))
(define-tokens numbers (number identifier string))
(define-tokens characters (character charIdentifier))
(define-tokens words (word wordIdentifier))

#| "#/" starts character
   "#:" starts keyword
   "#'" starts syntax quote
   "#+" starts a vector
|#
#|
Lexer function only returns once per call,
need to find a way to call recursively
|#

(define lexer
  (lexer-src-pos
   [(:or "$$")
    eof]

   (whitespace (lexer input-port))
   
   [(:or "-" "+" "/" "*" ":=" "(" ")")
    (string->symbol lexeme)]

   [(:or #\n #\r #\ #\space "char-whitespace")
    (return-without-pos (lexer input-port))]

   (:+ character)
    ((token-character(lexer input-port)))

   [(:+ digit)
    (token-number (string->number lexeme))]
   
   [(:or )
    (return-without-pos (lexer input-port))]

   [(:+ "read" "write")
    (token-word (string->list lexeme))]
)
)


(define (scanner)
  (lexer (open-input-string inputToString)))
         (cond
           (empty? inputToString)
           (lexer))

(scanner)