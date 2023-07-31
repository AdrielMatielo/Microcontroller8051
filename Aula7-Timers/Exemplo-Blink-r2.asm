; Código para produzir uma rotina de atraso de 1 s e piscar um LED ligado no pino P1.0.
; Valores utilizados considerando f = 12 MHz.


				$mod51
					
				LED equ p0.0

				org 0000h	; RESET	
					ljmp INIT		; Pula para o início do programa.

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

INIT:			mov IE, #82h		; Habilita a interrupção do Timer 0. 1000$0010b
				mov TMOD, #01h		; Configura o Timer 0 em Modo 1. 0000$0001b
				mov R0, #20			; Faz R0 = 20 para repetir 20x a rotina de 50 ms.
				mov TH0, #3Ch		; Move o byte superior para gerar 50k contagens (50 ms). 0111$1100b
				mov TL0, #0AFh		; Move o byte inferior. 1010$1111b
				setb TR0			; Liga o Timer 0 e a contagem começa.
				sjmp LOOP			; Pula para o laço principal.
		
LOOP:			sjmp $				; Fica travado no loop (while(1)) até que ocorra o overflow do Timer 0.
									; Quando isso acontece, o programa desvia para a ISR_TIMER0.


ISR_EX0:		reti				; Retorna da interrupção.
			
ISR_TIMER0:		clr TF0				; Limpa a flag que gerou a interrupção.
				mov TH0, #3Ch		; Recarrega os bytes superior e inferior.
				mov TL0, #0AFh		; Move o byte inferior.
				djnz R0, return		; Retorna da interrupção neste ponto se R0 > 0.
				cpl LED				; Complementa o valor do LED.
				mov R0, #20			; Recarrega o R0.
return:			reti				; Retorna da interrupção.
			
ISR_EX1:		reti				; Retorna da interrupção.

ISR_TIMER1:		reti				; Retorna da interrupção.
			
ISR_SERIAL:		reti				; Retorna da interrupção.
	   
end