.ORIG x3000

; Number of test scores
NUM_SCORES  .FILL x0005         ; Number of test scores (5)

; Initialize each score to 0 (5 scores)
SCORE_1     .FILL x0000         ; Score 1
SCORE_2     .FILL x0000         ; Score 2
SCORE_3     .FILL x0000         ; Score 3
SCORE_4     .FILL x0000         ; Score 4
SCORE_5     .FILL x0000         ; Score 5

; Initialize variables for maximum, average, and sum of scores
MAX_SCORE   .FILL x0000         ; Maximum score
AVG_SCORE   .FILL x0000         ; Average score
SUM_SCORES  .FILL x0000         ; Sum of the scores

; Prompt for Input and Output Messages
PROMPT      .STRINGZ "Enter test score (0-100) ODD ONlY: "
PROMPT1 		.STRINGZ "Enter ten's digit: \n"
PROMPT2 		.STRINGZ "Enter one's digit: \n"
ASCII_C 		.FILL #-48
OUTPUT_MIN  .STRINGZ "Minimum Score: "
OUTPUT_MAX  .STRINGZ "Maximum Score: "
OUTPUT_AVG  .STRINGZ "Average Score: "
LETTER_GRADE .STRINGZ "Letter Grade: "
NEWLINE     .FILL x0A
SPACE       .FILL x20

; Main Program
    LEA R0, PROMPT         ; Load address of prompt
    PUTS                   ; Print prompt
JSR GETSCORES
    ; Input Loop
    LD R2, NUM_SCORES      ; Load number of scores
    LEA R1, SCORE_1        ; Load address of first score
INPUT_LOOP
    JSR READ_NUMBER        ; Read a number from user
    STR R0, R1, #0         ; Store number in current score location
    ADD R1, R1, #1         ; Move to next score location
    ADD R2, R2, #-1        ; Decrease counter
    BRp INPUT_LOOP         ; Repeat for alll scores

GETSCORES
GETSCORES
;'TENS DIGIT'
JSR CLEARREG		; CLEARS ALL REGISTERS
LD R6, ASCII_C		; LOAD ASCII_C (#-48) INTO R6
LEA R0, PROMPT1		; 
PUTS
AND R0, R0, #0		; CLEAR R0
IN			; GET 'TENS' DIGIT			; ECHO
ADD R1, R0, R6		; ADD INPUT + R6 TO GET DECIMAL VALUE
OUT

;'ONES' DIGIT
AND R0, R0, #0		; CLEAR R0
LEA R0, PROMPT2
PUTS
AND R0, R0, #0
IN			; GET 'ONES' DIGIT
OUT			; ECHO
ADD R2, R0, #0		; MOVE 'ONES' DIGIT TO R2
ADD R2, R0, R6
ADD R3, R2, R1		; ADD 'TENS' VALUE AND 'ONES VALUE
OUT			; ECHO
HALT

CLEARREG
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0
RET


    ;Maximum Score
    LEA R1, SCORE_1        ; Load address of first score
    LDR R0, R1, 0          ; first score

    LD R2, NUM_SCORES
    ADD R2, R2, #-1        
FIND_MAX_LOOP
    ADD R1, R1, #1         ; move to next score
    LDR R3, R1, 0          ; next score
    LD R0, MAX_SCORE      ; Load current maximum
    ADD R4, R0, R3  
    BRp SKIP_MAX           ; If R0 >= R3, skip
    ST R3, MAX_SCORE      ; Update max
SKIP_MAX
    ADD R2, R2, #-1        ; Decrease counter
    BRp FIND_MAX_LOOP        ; Repeat until all scores are checked

    ; Compute Sum
    LEA R1, SCORE_1        ; Address of first score
    LD R2, NUM_SCORES      ; Load number of scores
    AND R6, R6, #0          ; Initialize sum to 0 
SUM_LOOP
    LDR R3, R1, 0         
    ADD R6, R6, R3         ; Add to sum
    ADD R1, R1, #1         
    ADD R2, R2, #-1        ; Decrease counter
    BRp SUM_LOOP           
    ST R6, SUM_SCORES      ; Store the sum

    ;Average
    LD R0, NUM_SCORES
    LD R1, SUM_SCORES
    JSR DIVIDE               ; Divide sum by number of scores (assuming a custom division subroutine)
    ST R0, AVG_SCORE      ; Store average

    ; Display Results
    LEA R0, OUTPUT_MIN  
    PUTS
   

    LEA R0, OUTPUT_MAX
    PUTS
    LD R0, MAX_SCORE
    JSR PRINT_NUMBER
    LD R0, NEWLINE
    OUT

    LEA R0, OUTPUT_AVG
    PUTS
    LD R0, AVG_SCORE
    JSR PRINT_NUMBER
    LD R0, NEWLINE
    OUT

    ; Display for Letter Grade
    LEA R0, LETTER_GRADE
    PUTS

    ; Adjust Average 
    ADD R4, AVG_SCORE, #60  ; Adjusted average 


    ; Check ranges
    CMP R4, #LOW_PASS_SCORE  ; Compare with passing score (60)
    BLT FAIL_GRADE  ; Branch if less than passing score 
    CMP R4, #HIGH_PASS_SCORE  ; Compare with high score (90)
    BLT ABOVE_AVG_GRADE  ; Branch if less than high score
    LEA R0, ASCII_A  ; Load ASCII code for 'A'
    BR DONE_GRADE  ; Branch to display 'A' grade

;Above avg grade
    LEA R0, ASCII_B	; Load ASCII code for 'B'
    BR DONE_GRADE  ; Branch to display 'B' grade

;Fail grade
    LEA R0, ASCII_F	; Load ASCII code for 'F'
    BR DONE_GRADE  ; Branch to display 'F' grade

DONE_GRADE
    OUT
    LD R0, NEWLINE
    OUT

    HALT

; Subroutine to Read a Number
READ_NUMBER
    ; Read a character
    GETC
    ; Convert ASCII to integer
    OUT
    AND R0, R0, #15
    RET

; Subroutine to Print a Number
PRINT_NUMBER
    ; Convert integer to ASCII
    OUT
    RET

LOW_PASS_SCORE .FILL #60  ; Minimum passing score D
HIGH_PASS_SCORE .FILL #90 ; Minimum score for an A' grade 

; ASCII Values for Letter Grades
ASCII_A .FILL x0041 ; ASCII code for 'A'
ASCII_B .FILL x0042 ; ASCII code for 'B'
ASCII_C .FILL x0043  ; ASCII code for 'C'
ASCII_D .FILL x0044  ; ASCII code for 'D'
ASCII_E .FILL x0045  ; ASCII code for 'E'
ASCII_F .FILL x0046  ; ASCII code for 'F'
.END
