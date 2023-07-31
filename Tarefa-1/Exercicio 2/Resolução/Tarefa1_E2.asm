; Exemplo de solução para a Parte I da Tarefa 1.

				$mod51
					
				GO_DN equ P1.0			; Definição dos botões.
				GO_UP equ P1.7

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

INIT:			mov A, #254
				sjmp DOWN_UP			; Pula para um laço de deslocamento arbitrário.
					
DOWN_UP:		rl A					; Rotaciona o acumulador para a esquerda e
				mov P0, A				; atrubui ele à porta P0.
				lcall DELAY_500MS		; Espera 500 ms.
				jnb GO_DN, UP_DOWN		; Monitora o botão indicativo de sentido e salta se o sentido for trocado.
				sjmp DOWN_UP			; Continua no laço se o sentido de rotação não foi alterado.
				
UP_DOWN:		rr A					; Rotaciona o acumulador para a direita e
				mov P0, A				; atrubui ele à porta P0.
				lcall DELAY_500MS		; Espera 500 ms.
				jnb GO_UP, DOWN_UP		; Monitora o botão indicativo de sentido e salta se o sentido for trocado.
				sjmp UP_DOWN			; Continua no laço se o sentido de rotação não foi alterado.

DELAY_500MS:	mov R2, #5				; Rotina de atraso de A x 100 ms (com A = 5).
LOOP1:			mov R1, #255
LOOP2:			mov R0, #255
LOOP3:			djnz R0, LOOP3
				djnz R1, LOOP2
				djnz R2, LOOP1
				ret

ISR_EX0:		reti					; Retorna da interrupção.
			
ISR_TIMER0:		reti					; Retorna da interrupção.
			
ISR_EX1:		reti					; Retorna da interrupção.

ISR_TIMER1:		reti					; Retorna da interrupção.
			
ISR_SERIAL:		reti					; Retorna da interrupção.
	   
end