#lang racket
(require parser-tools/lex
         parser-tools/yacc
         (prefix-in : parser-tools/lex-sre))
         

#| Return the literal token |#
(define-empty-tokens operators (+ - / * :=))
#| Tokens that will hold a value |#
(define-tokens scanTokens (numbers characters strings endOfFile))
#| Abbrevs are used as shorthand for scanner to recognize |#
(define-lex-abbrevs
  (scanChar (:or (char-range "a" "z")))
  (scanNum (:or( char-range "0" "9")))
  (invalidScan (:or "^" "&" "%" "!"))
  (eofScan (:or "$$"))
  )

#|
  Initilization of scanner ("lexer")
  Using the abbrev to recognize what is being read then sending
  the resulting token depending on what the scanner has read
|#
(define myScanner
  (lexer
   (scanNum (token-numbers(string->number lexeme)))
   (scanChar (token-characters))
   #| If whitespace -> recurse back to input position |#
   (whitespace (myScanner input-port))
   (invalidScan (string->symbol lexeme))
   (eofScan (token-endOfFile((string->symbol lexeme))))

   ))

(myScanner (file->string "Input02.txt"))