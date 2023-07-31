; Exemplo de solu��o para a Parte I da Tarefa 1.

				$mod51
					
				GO_DN equ P1.0			; Defini��o dos bot�es.
				GO_UP equ P1.7

				org 0000h	; RESET	
					ljmp INIT			; Pula para o in�cio do programa.

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
				
				FLAG equ 0
					
				mov IE, #10000101b
				clr EA
				setb IT0
				setb IT1
				
INIT:			mov A, #254
				sjmp DOWN_UP			; Pula para um la�o de deslocamento arbitr�rio.
					
DOWN_UP:		jnb FLAG, UP_DOWN
				rl A					; Rotaciona o acumulador para a esquerda e
				mov P0, A				; atrubui ele � porta P0.
				lcall DELAY_500MS		; Espera 500 ms.
				sjmp DOWN_UP			; Continua no la�o se o sentido de rota��o n�o foi alterado.
				
UP_DOWN:		jb FLAG, DOWN_UP
				rr A					; Rotaciona o acumulador para a direita e
				mov P0, A				; atrubui ele � porta P0.
				lcall DELAY_500MS		; Espera 500 ms.
				sjmp UP_DOWN			; Continua no la�o se o sentido de rota��o n�o foi alterado.

DELAY_500MS:	mov R2, #5				; Rotina de atraso de A x 100 ms (com A = 5).
LOOP1:			mov R1, #255
LOOP2:			mov R0, #255
LOOP3:			djnz R0, LOOP3
				djnz R1, LOOP2
				djnz R2, LOOP1
				ret

ISR_EX0:		clr FLAG
				setb EA
				reti					; Retorna da interrup��o.
			
ISR_TIMER0:		reti					; Retorna da interrup��o.
			
ISR_EX1:		setb FLAG
				setb EA
				reti					; Retorna da interrup��o.

ISR_TIMER1:		reti					; Retorna da interrup��o.
			
ISR_SERIAL:		reti					; Retorna da interrup��o.
	   
end