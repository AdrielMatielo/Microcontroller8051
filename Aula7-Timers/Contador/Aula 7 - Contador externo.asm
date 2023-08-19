; Arquivo assembly de um contador externo de 8 bits (c/ recarga automática) com duas entradas de contagem.
; Entrada 0 no pino T0 (P3.4) e contagem no T/C 0.
; Entrada 1 no pino T1 (P3.5) e contagem no T/C 1.
; O pino P1.0 suspende / retoma a contagem.

				$mod51
				
				COUNTER0	equ	P1
				COUNTER1	equ	P2
				BUTTON		equ	P3.0

				org 0000h	; RESET	
					ljmp INIT			; Pula para o início do programa.

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

INIT:			mov TMOD, #0110$0110b	; Configura os T/Cs na função contador e modo 2 (8 bits c/ recarga automática). 
				mov TL0, #00h			; Move para o byte inferior do Contador 0 o valor inicial da contagem.
				mov TH0, #00h			; Move para o byte superior do Contador 0 o valor de retomada da contagem após o estouro do contador (contagem > 255).
				mov TL1, #00h			; Move para o byte inferior do Contador 1 o valor inicial da contagem.
				mov TH1, #00h			; Move para o byte superior do Contador 1 o valor de retomada da contagem após o estouro do contador (contagem > 255).
				setb TR0				; Habilita o Contador 0.
				setb TR1				; Habilita o Contador 1.
				
LOOP:			mov COUNTER0, TL0		; Exibe a contagem do Contador 0 na porta P1 (nesse exemplo ativo em nível ALTO).
				mov COUNTER1, TL1		; Exibe a contagem do Contador 1 na porta P2 (nesse exemplo ativo em nível ALTO).
				jnb BUTTON, SR_COUNTING ; Monitora o botão pra saber se a contagem vai ser suspensa / retomada.
				sjmp LOOP				; Retorna ao laço principal.
				
SR_COUNTING: 	cpl TR0					; Desliga / liga o Contador 0.
				cpl TR1					; Desliga / liga o Contador 1.
				jnb BUTTON, $			; Espera a liberação do botão.
				sjmp LOOP				; Retorna ao laço principal.

ISR_EX0:		reti					; Retorna da interrupção.
			
ISR_TIMER0:		reti					; Retorna da interrupção.
			
ISR_EX1:		reti					; Retorna da interrupção.

ISR_TIMER1:		reti					; Retorna da interrupção.
			
ISR_SERIAL:		reti					; Retorna da interrupção.
	   
end
	
	