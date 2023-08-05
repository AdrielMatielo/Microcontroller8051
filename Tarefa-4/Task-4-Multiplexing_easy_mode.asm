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
							
;============== || ============ || ==============
;============== | PRINCIPAL LOOP | ==============
;============== || =============|| ==============
LOOP:			
				mov R2, #0Dh
				clr P3.0
				mov P0, R2
				acall DELAY_500MS
				
				setb P3.0
				mov R2, #25h
				clr P3.1
				mov P0, R2
				acall DELAY_500MS
				
				setb P3.1
				mov R2, #03h
				clr P3.2
				mov P0, R2
				acall DELAY_500MS
				
				setb P3.2
				mov R2, #25h
				clr P3.3
				mov P0, R2
				acall DELAY_500MS
				
				setb P3.3
				mov R2, #01h
				clr P3.4
				mov P0, R2
				acall DELAY_500MS
				
				setb P3.4
				mov R2, #03h
				clr P3.5
				mov P0, R2
				acall DELAY_500MS
				
				setb P3.5
				mov R2, #99h
				clr P3.6
				mov P0, R2
				acall DELAY_500MS
				
				setb P3.6
				mov R2, #03h
				clr P3.7
				mov P0, R2
				acall DELAY_500MS
				
				setb P3.7
				sjmp LOOP

;=================== ROUTINES ===================
DELAY_500MS:	mov R2, #5			; Rotina de atraso de A x 100 ms (com A = 5).
LOOP1:			mov R1, #255
LOOP2:			mov R0, #255
;LOOP3:			djnz R0, LOOP3
				djnz R1, LOOP2
				djnz R2, LOOP1
				ret

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