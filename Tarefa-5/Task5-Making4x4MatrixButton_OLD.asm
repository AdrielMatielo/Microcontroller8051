; ======================================= Universidade Federal de Pelotas
; ======================================= Centro de Desenvolvimento Tecnológico
; ======================================= Bacharelado em Engenharia de Computação
; ======================================= Disciplina: 22000279 --- Microcontroladores
; ======================================= Turma: 2023/1 --- M1
; ======================================= Professor: Alan Rossetto
;
;										  Descrição: Tarefa 4 
;
; 										  Identificação:
; 										  Nome da(o) aluna(o) & Matrícula: Ari Vitor da Silva Lazzarotto, 17200917
; 										  Nome da(o) aluna(o) & Matrícula: Adriel Correa Matielo, 16105321
;										  Data: 29/07/2023			

				$mod51
					
				DISPLAY EQU P0
				ACT_DISPLAY EQU P3

				org 0000h	; RESET	
					ljmp INIT

				org 0003h	; /INT0
					ljmp ISR_EX0
					
				org 000Bh	; TIMER0
					ljmp ISR_TIMER0

				org 0013h	; /INT1
					ljmp ISR_EX1
					
				org 001Bh	; TIMER1
					ljmp ISR_TIMER1
					
				org 0023h	; SERIAL
					ljmp ISR_SERIAL
					
; Creates a list with all the numbers to be displayed using the DB directive

; Equ 7seg: 		0----1----2----3----4----5----6----7----8----9-				
NUMBERS:		db 003, 159, 037, 013, 153, 073, 065, 031, 001, 009
	
; Equ 7seg: 		2----9----0----7----2----0----2----3
DATE:			db 037, 009, 003, 031, 037, 003, 037, 013


INIT:			mov A,  #0111$1111b		; Set the first digit to appear
				mov R1, A				; Saves the accumulator(The first digit to appear) on R1
				mov R3, #0				; Initializes the list iterator on R3
				mov DPTR, #DATE		    ; Load the list into data pointer.	
				
LOOP:			mov A, R3				; Loads the iterator into the accumulator
				movc A, @A+DPTR			; Moves the number corresponding to the position pointed by the iterator to the accumulator
				mov DISPLAY, A			; Put accumulator in P0(Display the number)
				
				mov A, R1				; Load the old accumulator(activated display number) into accumulator
				mov ACT_DISPLAY, A		; Put the accumulator in P3(The activated display for this turn)
				lcall TIMER5MS			; Timer for see the activated display
				RR A					; Rotate the accumulator
				mov R1, A				; Saves the accumulator on R1 again(The activated display for the next turn)
				
				cjne R3, #7, CONTINUE	; If the list has not reached the end(number 7), jump
				mov R3, #0				; Else recharge the iterator
				sjmp LOOP				
				
CONTINUE:		inc R3					; Increment the iterator
				sjmp LOOP				
				
ISR_EX0:		reti

TIMER5MS:  		MOV  TMOD, #01h
				MOV  TH0,  #0F2h
				MOV  TL0,  #000h
				SETB TR0
				JNB  TF0, $
				CLR  TR0
				CLR  TF0
				reti				
	
ISR_TIMER0:		reti
			
ISR_EX1:		reti

ISR_TIMER1:		reti
			
ISR_SERIAL:		reti
	   
end