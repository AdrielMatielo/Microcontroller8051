; ======================================= Universidade Federal de Pelotas
; ======================================= Centro de Desenvolvimento Tecnológico
; ======================================= Bacharelado em Engenharia de Computação
; ======================================= Disciplina: 22000279 --- Microcontroladores
; ======================================= Turma: 2023/1 --- M1
; ======================================= Professor: Alan Rossetto
;
;										  Description: AT80C51RD2 - 12MHz
;										  Traffic light with wait time using timers
;										  Lights activate in low state
;
; 										  Identificação:
; 										  Nome da(o) aluna(o) & Matrícula: Adriel Correa Matielo 16105321
; 										  Nome da(o) aluna(o) & Matrícula:
;										  Data: 22/07/2023

				$mod51
				
				RED 		equ P0.2	; Red Light - car
				YELLOW 		equ P0.1	; Yellow Light - car
				GREEN		equ P0.0	; Green Light - car
					
				RED_P		equ P0.4	; Red Light - pedestrian
				GREEN_P		equ P0.3	; Green Light - pedestrian
					
				BUTTON		equ	P3.2	; Semaphore Button
					
				FLAG		equ 002Ch	; Return of interruptions

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
					
;;;;;;;;;;;;;;;;;;;START;;;;;;;;;;;;;;;;;;;

INIT:			mov IE, #1000$1011b      			; Interruption Register: (1)Enable-(X)-(X)-(0)E/S-$-(1)Timer1-(0)Ex1-(1)Timer0-(1)Ex0
				mov TMOD, #0001$0001b				; Timer/Counter Register: T1 (0)TR1-(0)Timer-(01)Mode01 -$- T2 (0)TR2-(0)Timer-(01)Mode01
				
				mov R0, #40							; TR0 repeats 40x 50ms  (@12MHZ) = 2 seconds
				mov TH0, #3Ch						; 3C is the high part of (FFFF - 50ms/1us)  
				mov TL0, #0AFh						; AF is the low part of (FFFF - 50ms/1us)
				mov R1, #200						; TR1 repeats 200x 50ms  (@12MHZ) = 10 seconds
				mov TH1, #3Ch						; 3C is the high part of (FFFF - 50ms/1us)
				mov TL1, #0AFh						; AF is the low part of (FFFF - 50ms/1us)

;;;;;;;;;;;;;;;;;;;TRAFFIC LIGHT;;;;;;;;;;;;;;;;;;;
				
GREEN_STATE:
				setb FLAG
 			
				setb RED
				setb YELLOW 
				clr GREEN
				clr RED_P
				setb GREEN_P
GREEN_WAIT:
				jnb FLAG, YELLOW_STATE 				; When EX0 interrupts, Flag gets 0 then jump to YELLOW_STATE.
				sjmp GREEN_WAIT						; Else return to GREEN_WAIT
				
YELLOW_STATE:
				setb RED
				clr YELLOW 
				setb GREEN
				clr RED_P
				setb GREEN_P
				
				setb FLAG
				setb TR0							; Start Timer0
YELLOW_WAIT:
				jnb FLAG, RED_STATE 				; When TF0 interrupts R0 times, Flag gets 0 then jump to RED_STATE.
				jmp YELLOW_WAIT						; Else return to YELLOW_WAIT
RED_STATE:	
				clr RED
				setb YELLOW 
				setb GREEN
				setb RED_P
				clr GREEN_P
				
				setb FLAG
				setb TR1							; Start Timer1
RED_WAIT:											
				jnb FLAG, INIT						; When TF1 interrupts R1 times, Flag gets 0 then jump to  INIT
				jmp RED_WAIT						; Else return to RED_WAIT

				
;;;;;;;;;;;;;;;;;;;INTERRUPTIONS;;;;;;;;;;;;;;;;;;;

ISR_EX0:		
				jnb BUTTON, $						; Wait until release button.
				mov IE, #10001010b  				; Disable EX0.
				clr FLAG							; Turns on Flag
				reti
			
ISR_TIMER0:		
				clr TF0								; Clear interruption
				djnz R0, ENDTIMER0					; If TF0 interrupts R0 times, Flag gets 0 and stop TR0
				clr FLAG
				clr TR0
ENDTIMER0:		reti
				
ISR_TIMER1:		
				clr TF1								; Clear interruption
				djnz R1, ENDTIMER1					; If TF1 interrupts R1 times, Flag gets 0 and stop TR1
				clr FLAG
				clr TR1
ENDTIMER1:		reti

ISR_EX1:		reti								;
ISR_SERIAL:		reti								;
	   
end