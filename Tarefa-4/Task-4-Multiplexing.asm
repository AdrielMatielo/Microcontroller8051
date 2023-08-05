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
				clr P3.7
				mov DPTR, #DAY
				mov R6, #0
							
;============== || ============ || ==============
;============== | PRINCIPAL LOOP | ==============
;============== || =============|| ==============
LOOP:			acall SHOWDISPLAY	
				acall MULTIPLEX
				
				sjmp LOOP

;=================== ROUTINES ===================
DELAY_500MS:	mov R2, #1		; Rotina de atraso de A x 100 ms (com A = 5).
LOOP1:			mov R1, #255
LOOP2:			mov R0, #255
LOOP3:			djnz R0, LOOP3
				djnz R1, LOOP2
				djnz R2, LOOP1
				ret

MULTIPLEX:		mov A, P3
				rr A
				mov P3, A
				ret

SHOWDISPLAY:	mov DPTR, #DAY
				mov A, R6
				movc A, @A+DPTR
				mov P0, A
				acall DELAY_500MS
				cjne R6, #7, CONTINUE
				mov R6, 0
				ret
				
CONTINUE:		inc R6
				ret

;Display7 0=#03h 1=#9fh 2=#25h 3=#0Dh 4=#99h 5=#49h 6=#C1h 7=#1Fh 8=#01h 9=#19h
DAY:		db 0x03, 0x49, 0x03, 0x01, 0x25, 0x03, 0x25, 0x0D

;================= INTERRUPTIONS ================

ISR_EX0:		reti

TIMER5MS:  		reti				
	
ISR_TIMER0:		mov TH0, #0F2h
				mov TL0, #0FAh
				reti
			
ISR_EX1:		reti

ISR_TIMER1:		reti
			
ISR_SERIAL:		reti
	   
end