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
;========================================
;Development in AT80C51RD2 @ 8MHz


				$mod51

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
					
								
;===============================================					
INIT:					
				mov P2, #0x0
				clr P3.7						; Actvate display P3.7
				mov R6, #0						; For list position 0
				mov IE, #1000$0010b				; Interruption Register: (1)Enable-(X)-(X)-(0)E/S-$-(0)Timer1-(0)Ex1-(1)Timer0-(0)Ex0
				mov TMOD, #0000$0001b			; Timer/Counter Register: T1 (0)TR1-(0)Timer-(01)Mode01 -$- T2 (0)TR2-(0)Timer-(01)Mode01
				
				;Timer for 5ms @ 8MHz => 5ms/(8MHz^-1/12) - 65536 = 8*0xCA60
				mov TH0, #0CAh
				mov TL0, #060h
				mov R1, #8
				setb TR0						; Start timer
				setb TF0
							
;============== || ============ || ==============
;============== | PRINCIPAL LOOP | ==============
;============== || =============|| ==============
LOOP:									
				acall SHOWDISPLAY				; Set number to show on display
				jnb TF0, $						; Wait timer
				acall MULTIPLEX					; Multiplexer display
				sjmp LOOP

;=================== ROUTINES ===================

MULTIPLEX:		mov P0, #0xFF					; Clean display
				mov A, P3
				rr A							; Move 1bit to right to set next display
				mov P3, A
				ret

SHOWDISPLAY:	mov DPTR, #DAY
				mov A, R6
				movc A, @A+DPTR
				mov P0, A
				cjne R6, #7, CONTINUE
				mov R6, 0						; End of list
				ret
				
CONTINUE:		inc R6
				ret

;Display7 0=0x03 1=0x9F 2=0x25 3=0x0D 4=0x99 5=0x49 6=0xC1 7=0x1F 8=0x01 9=0x19
DAY:		db 0x25, 0x19, 0x03, 0x1F, 0x25, 0x03, 0x25, 0x0D

;================= INTERRUPTIONS ================

ISR_EX0:		reti

TIMER5MS:  		reti				
	
ISR_TIMER0:		clr TF0
				mov TH0, #0CAh
				mov TL0, #060h
				djnz R1, RETURN_TIMER0
				mov R1, #8
RETURN_TIMER0:	reti
			
ISR_EX1:		reti

ISR_TIMER1:		reti
			
ISR_SERIAL:		reti
	   
end