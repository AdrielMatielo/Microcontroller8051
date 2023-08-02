; ======================================= Universidade Federal de Pelotas
; ======================================= Centro de Desenvolvimento Tecnológico
; ======================================= Bacharelado em Engenharia de Computação
; ======================================= Disciplina: 22000279 --- Microcontroladores
; ======================================= Turma: 2023/1 --- M1
; ======================================= Professor: Alan Rossetto
;
;										  Descrição: Tarefa 6
;
; 										  Identificação:
; 										  Nome da(o) aluna(o) & Matrícula: Ari Vitor da Silva Lazzarotto, 17200917
; 										  Nome da(o) aluna(o) & Matrícula: Adriel Correa Matielo, 16105321
;										  Data: 01/08/2023			
;
; ======================================= Decoder with multiplexer
;Timer 100ms @ 10MHz (100ms / 0.8333us = 120k) -> 65535 - 12000 = 53635 (D183h)


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
					
									
				STOP equ 0028h
				



INIT:			mov IE, #1000$1111b      			; Interruption Register: (1)EA -(X)-(X)-(0)E/S- $ -(1)Timer1-(1)Ex1-(1)Timer0-(1)Ex0
				mov TMOD, #0001$0001b				; Timer/Counter Register: T1 (0)TR1-(0)Timer-(01)Mode01 -$- T2 (0)TR2-(0)Timer-(01)Mode01
				
				mov TH0, #0D1h						;timer for multplexer
				mov TL0, #083h
				;mov R0, 10							;Repet Counter R0 times
				
				mov TH1, #0D1h						;Timer for counting
				mov TL1, #083h
				mov R1, 10							;Repet Counter R1 times
				
				setb STOP
				
				mov R3, #0				; Inicializa o iterador da lista (aqui vamos usar o registrador R3).
				mov DPTR, #NUMBERS0		; Carrega a lista de números no data pointer.
				
				setb EA
				setb TR0
				
				
				sjmp START				; Pula para o laço principal

START:				
			
				lcall MULTIPLEX0
				jnb TF0, $	
				lcall MULTIPLEX1
				jnb TF0, $	
				lcall MULTIPLEX2
				jnb TF0, $	
				lcall MULTIPLEX3
				jnb TF0, $				;espera a contagem terminar
				jnb TR1, START
				jnb STOP, INIT
				mov A, R3
				movc A, @A+DPTR
				cjne A, #010, CONTINUE	; Compara pra verificar se a lista não chegou ao fim (número 9).
				mov R3, #0				; Se a lista chegou ao fim, zera o iterador (pra começar do início novamente		
				sjmp START				; e retorna ao início do laço neste ponto.
				
CONTINUE:		inc R3					; Se a lista não chegou ao fim, incrementa o iterador
				sjmp START	
	
	
; ======================================= ROUTINES

NUMBERS0: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
;NUMBERS1: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
;NUMBERS2: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
;NUMBERS3: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9


SHOWDISPLAY:	anl A, #0x0F
				mov P2, A
				anl A, #0x0F
				ret
				
MULTIPLEX0:		clr P3.0
				clr P3.1
				lcall SHOWDISPLAY
				ret

MULTIPLEX1:		setb P3.0
				clr P3.1
				lcall SHOWDISPLAY
				ret
				
MULTIPLEX2:		clr P3.0
				setb P3.1
				lcall SHOWDISPLAY
				ret
				
MULTIPLEX3:		setb P3.0
				setb P3.1
				lcall SHOWDISPLAY
				ret
				
; ======================================= INTERRUPTIONS

ISR_EX0:		jnb P3.2, $						; Wait until release button.
				cpl TR1
				reti
				
	
ISR_TIMER0:			
				clr EA				; Clear interruption
				;djnz R0, ENDTIMER0					; If TF0 interrupts R0 times, Flag gets 0 and stop TR0
				mov TH0, #0E8h						;
				mov TL0, #08Fh						;
				;mov R0, 10
ENDTIMER0:		clr TF0
				setb EA
				reti
			
ISR_EX1:		jnb P3.3, $
				clr STOP
				reti

ISR_TIMER1:			
				clr EA				; Clear interruption
				djnz R1, ENDTIMER1					; If TF0 interrupts R0 times, Flag gets 0 and stop TR0
				mov TH1, #0A2h						; 3C is the high part of (FF00 - 50ms/1us)  
				mov TL1, #03Fh						; AF is the low part of (FFFF - 50ms/1us)
				mov TH0, #0E8h						;
				mov TL0, #08Fh						;
				mov R1, 10
ENDTIMER1:		clr TF1
				setb EA
				reti
			
ISR_SERIAL:		reti
	   
end