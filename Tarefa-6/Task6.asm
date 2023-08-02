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
;Timer 100ms @ 10MHz (100ms / 0.8333us = 120k) -> 65535 - 12000 = 53635 (D183h


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
					
				FLAG equ 0028h
				



INIT:			mov IE, #1000$1011b      			; Interruption Register: (1)EA -(X)-(X)-(0)E/S- $ -(1)Timer1-(0)Ex1-(1)Timer0-(1)Ex0
				mov TMOD, #0001$0001b				; Timer/Counter Register: T1 (0)TR1-(0)Timer-(01)Mode01 -$- T2 (0)TR2-(0)Timer-(01)Mode01
				
				mov TH0, #0D1h						;Conunter 12000
				mov TL0, #083h
				mov R0, 10							;Repet Counter R0 times
				
				mov TH1, #015h						;Conunter 60000
				mov TL1, #09Fh
				mov R1, 2							;Repet Counter R1 times
				
				setb FLAG
				
				mov R3, #0				; Inicializa o iterador da lista (aqui vamos usar o registrador R3).
				mov DPTR, #NUMBERS0		; Carrega a lista de números no data pointer.
				
				sjmp START				; Pula para o laço principal

START:			setb EA
				setb TR1
				mov A, R3
				movc A, @A+DPTR
				lcall SHOWDISPLAY
				jnb TF1, $				;espera a contagem terminar
PROXIMO:		cjne A, #010, CONTINUE	; Compara pra verificar se a lista não chegou ao fim (número 9).
				mov R3, #0				; Se a lista chegou ao fim, zera o iterador (pra começar do início novamente)
				sjmp START				; e retorna ao início do laço neste ponto.
CONTINUE:		inc R3					; Se a lista não chegou ao fim, incrementa o iterador
				sjmp START	
	
	
; ======================================= ROUTINES

NUMBERS0: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
NUMBERS1: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

demux: db 0, 1, 2, 3
	
	

DELAY_500MS:	mov R7, #255				; Rotina de atraso de A x 100 ms (com A = 5).
LOOP1:			mov R6, #255
				djnz R7, LOOP1
				ret

SHOWDISPLAY:	anl A, #0x0F
				mov P2, A
				anl A, #0x0F
				ret
				
; ======================================= INTERRUPTIONS

ISR_EX0:		reti
				
	
ISR_TIMER0:			
				clr EA				; Clear interruption
				djnz R0, ENDTIMER0					; If TF0 interrupts R0 times, Flag gets 0 and stop TR0
				mov TH0, #0D1h						; 3C is the high part of (FF00 - 50ms/1us)  
				mov TL0, #083h						; AF is the low part of (FFFF - 50ms/1us)
				mov R0, 10
ENDTIMER0:		clr TF0
				setb EA
				reti
			
ISR_EX1:		reti

ISR_TIMER1:			
				clr EA				; Clear interruption
				djnz R0, ENDTIMER1					; If TF0 interrupts R0 times, Flag gets 0 and stop TR0
				mov TH1, #0A2h						; 3C is the high part of (FF00 - 50ms/1us)  
				mov TL1, #03Fh						; AF is the low part of (FFFF - 50ms/1us)
				mov R1, 5
ENDTIMER1:		clr TF1
				setb EA
				reti
			
ISR_SERIAL:		reti
	   
end