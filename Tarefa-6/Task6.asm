; ======================================= Universidade Federal de Pelotas
; ======================================= Centro de Desenvolvimento Tecnol�gico
; ======================================= Bacharelado em Engenharia de Computa��o
; ======================================= Disciplina: 22000279 --- Microcontroladores
; ======================================= Turma: 2023/1 --- M1
; ======================================= Professor: Alan Rossetto
;
;										  Descri��o: Tarefa 6
;
; 										  Identifica��o:
; 										  Nome da(o) aluna(o) & Matr�cula: Ari Vitor da Silva Lazzarotto, 17200917
; 										  Nome da(o) aluna(o) & Matr�cula: Adriel Correa Matielo, 16105321
;										  Data: 01/08/2023			
;
; ======================================= Decoder with multiplexer
;Timer 100ms @ 10MHz (100ms / 0.8333us = 120k) -> 65535 - 12000 = 53635 (D183h)


				$mod51

				org 0000h	; RESET	
					ljmp KICK

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
				UNITS equ R4
				TENS equ R5
				HUNDREDS equ R6
				THOUSANDS equ R7



KICK:			mov IE, #1000$1111b      			; Interruption Register: (1)EA -(X)-(X)-(0)E/S- $ -(1)Timer1-(1)Ex1-(1)Timer0-(1)Ex0
				mov TMOD, #0001$0001b				; Timer/Counter Register: T1 (0)TR1-(0)Timer-(01)Mode01 -$- T2 (0)TR2-(0)Timer-(01)Mode01
				
				mov TH0, #006h						;timer for multiplexer
				mov TL0, #0F3h
				;mov R0, 10
				
				mov TH1, #006h						;Timer for counting
				mov TL1, #0F3h
				mov R1, 10							;Repet Counter R1 times
				
				setb STOP
				
				mov R3, #0				; Inicializa o iterador da lista (aqui vamos usar o registrador R3).
				
				setb EA
				setb TR0
				setb TR1
				
				mov UNITS, 0
				mov TENS, 0
				mov HUNDREDS, 0
				mov THOUSANDS, 0
				
				
				sjmp START				; Pula para o la�o principal

START:				
				lcall DISPLAY
				jnb STOP, KICK
				jnb TF1, START
				clr TF1
				lcall SUM
				sjmp START				; e retorna ao in�cio do la�o neste ponto.
				
CONTINUE:		inc R3					; Se a lista n�o chegou ao fim, incrementa o iterador
				sjmp START	
	
SUM:			cjne UNITS, #010, SUM_UNITS
				cjne TENS, #010, END_COUNTER
				cjne HUNDREDS, #010, END_COUNTER
				cjne THOUSANDS, #010, END_COUNTER
				mov UNITS, #0
				mov TENS, #0
				mov HUNDREDS, #0
				mov THOUSANDS, #0
				sjmp END_COUNTER
				SUM_UNITS:		inc UNITS
								ret
				SUM_TENS:		inc TENS
								ret
				SUM_HUNDREDS: 	inc HUNDREDS
								ret
				SUM_THOUSANDS: 	inc THOUSANDS
								ret
END_COUNTER:	ret
; ======================================= ROUTINES

NUMBERS0: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
	
MULTIPLEX0:		clr P3.0
				clr P3.1
				mov P2, UNITS
				ANL P2, #0Fh
				ANL A, #0F0h
				ORL P2, A
				ret

MULTIPLEX1:		setb P3.0
				clr P3.1
				mov P2, TENS
				ret
				
MULTIPLEX2:		clr P3.0
				setb P3.1
				mov P2, HUNDREDS
				ret
				
MULTIPLEX3:		setb P3.0
				setb P3.1
				mov P2, THOUSANDS
				ret
				
DISPLAY:	lcall MULTIPLEX0
				jnb TF0, $	
				lcall MULTIPLEX1
				jnb TF0, $	
				lcall MULTIPLEX2
				jnb TF0, $	
				lcall MULTIPLEX3
				jnb TF0, $
				ret
				
; ======================================= INTERRUPTIONS

ISR_EX0:		jnb P3.2, $						; Wait until release button.
				cpl TR1
				reti
				
	
ISR_TIMER0:			
				clr EA				; Clear interruption
				;djnz R0, ENDTIMER0					; If TF0 interrupts R0 times, Flag gets 0 and stop TR0
				mov TH0, #006h						;
				mov TL0, #0F3h						;
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
				mov TH1, #006h						; 3C is the high part of (FF00 - 50ms/1us)  
				mov TL1, #0F3h						; AF is the low part of (FFFF - 50ms/1us)
				mov TH0, #006h						;
				mov TL0, #0F3h
ENDTIMER1:		
				setb EA
				reti
			
ISR_SERIAL:		reti
	   
end