; ======================================= Universidade Federal de Pelotas
; ======================================= Centro de Desenvolvimento Tecnológico
; ======================================= Bacharelado em Engenharia de Computação
; ======================================= Disciplina: 22000279 --- Microcontroladores
; ======================================= Turma: 2023/1 --- M1
; ======================================= Professor: Alan Rossetto
;
;										  Descrição: Tarefa 5
;
; 										  Identificação:
; 										  Nome da(o) aluna(o) & Matrícula: Ari Vitor da Silva Lazzarotto, 17200917
; 										  Nome da(o) aluna(o) & Matrícula: Adriel Correa Matielo, 16105321
;										  Data: 07/08/2023
;========================================
;Development in AT80C51RD2 @ 12MHz


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
				mov P1, #0xFF					; upper nibble = rows | down nibble =  collums
				mov P2, #0x00					; show 0 when start
				
				mov R5, #0
				mov R6, #0
				acall SHOWDISPLAY
				
							
;============== || ============ || ==============
;============== | PRINCIPAL LOOP | ==============
;============== || =============|| ==============
LOOP:			
;=================================ROW 00
ROW00:			clr P1.0
				jnb P1.4, NUM1
				jnb P1.5, NUM2
				jnb P1.6, NUM3
				jnb P1.7, NUM4
				setb P1.0
				sjmp ROW01
NUM1:			mov R5, #0
				mov R6, #1
				acall SHOWDISPLAY
				jnb P1.4, $
				jmp LOOP
NUM2:			mov R5, #0
				mov R6, #2
				acall SHOWDISPLAY
				jnb P1.5, $
				jmp LOOP
NUM3:			mov R5, #0
				mov R6, #3
				acall SHOWDISPLAY
				jnb P1.6, $
				jmp LOOP
NUM4:			mov R5, #0
				mov R6, #4
				acall SHOWDISPLAY
				jnb P1.7, $
				jmp LOOP
;=================================ROW 01
ROW01:			clr P1.1
				jnb P1.4, NUM5
				jnb P1.5, NUM6
				jnb P1.6, NUM7
				jnb P1.7, NUM8
				setb P1.1
				sjmp ROW02
NUM5:			mov R5, #0
				mov R6, #5
				acall SHOWDISPLAY
				jnb P1.4, $
				jmp LOOP
NUM6:			mov R5, #0
				mov R6, #6
				acall SHOWDISPLAY
				jnb P1.5, $
				jmp LOOP
NUM7:			mov R5, #0
				mov R6, #7
				acall SHOWDISPLAY
				jnb P1.6, $
				jmp LOOP
NUM8:			mov R5, #0
				mov R6, #8
				acall SHOWDISPLAY
				jnb P1.7, $
				jmp LOOP
;=================================ROW 02
ROW02:			clr P1.2
				jnb P1.4, NUM9
				jnb P1.5, NUM10
				jnb P1.6, NUM11
				jnb P1.7, NUM12
				setb P1.2
				sjmp ROW03
NUM9:			mov R5, #0
				mov R6, #9
				acall SHOWDISPLAY
				jnb P1.4, $
				jmp LOOP
NUM10:			mov R5, #1
				mov R6, #0
				acall SHOWDISPLAY
				jnb P1.5, $
				jmp LOOP
NUM11:			mov R5, #1
				mov R6, #1
				acall SHOWDISPLAY
				jnb P1.6, $
				jmp LOOP
NUM12:			mov R5, #1
				mov R6, #2
				acall SHOWDISPLAY
				jnb P1.7, $
				jmp LOOP
;=================================ROW 03
ROW03:			clr P1.3
				jnb P1.4, NUM13
				jnb P1.5, NUM14
				jnb P1.6, NUM15
				jnb P1.7, NUM16
				setb P1.3
				jmp LOOP
NUM13:			mov R5, #1
				mov R6, #3
				acall SHOWDISPLAY
				jnb P1.4, $
				jmp LOOP
NUM14:			mov R5, #1
				mov R6, #4
				acall SHOWDISPLAY
				jnb P1.5, $
				jmp LOOP
NUM15:			mov R5, #1
				mov R6, #5
				acall SHOWDISPLAY
				jnb P1.6, $
				jmp LOOP
NUM16:			mov R5, #1
				mov R6, #6
				acall SHOWDISPLAY
				jnb P1.7, $
				jmp LOOP
;=================== ROUTINES ===================

SHOWDISPLAY:	mov DPTR, #BCD_1
				mov A, R5
				movc A, @A+DPTR				; digit of tens
				swap A						; move bits for upper nibble
				mov P2, A
				mov DPTR, #BCD_2
				mov A, R6
				movc A, @A+DPTR				; digit of units 
				orl P2, A					; make an OR opperating with upper nibble
				ret
				

;Display7 0=0x03 1=0x9F 2=0x25 3=0x0D 4=0x99 5=0x49 6=0xC1 7=0x1F 8=0x01 9=0x19
BCD_1:		db 0x00, 0x01
BCD_2:		db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09

;================= INTERRUPTIONS ================

ISR_EX0:		reti

TIMER5MS:  		reti				
	
ISR_TIMER0:		reti
			
ISR_EX1:		reti

ISR_TIMER1:		reti
			
ISR_SERIAL:		reti
	   
end