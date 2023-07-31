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
				
				FLAG equ 0
					
				mov IE, #10000101b
				clr EA
				setb IT0
				setb IT1
				
INIT:			mov A, #254
				sjmp DOWN_UP			; Pula para um laço de deslocamento arbitrário.
					
DOWN_UP:		jnb FLAG, UP_DOWN
				rl A					; Rotaciona o acumulador para a esquerda e
				mov P0, A				; atrubui ele à porta P0.
				lcall DELAY_500MS		; Espera 500 ms.
				sjmp DOWN_UP			; Continua no laço se o sentido de rotação não foi alterado.
				
UP_DOWN:		jb FLAG, DOWN_UP
				rr A					; Rotaciona o acumulador para a direita e
				mov P0, A				; atrubui ele à porta P0.
				lcall DELAY_500MS		; Espera 500 ms.
				sjmp UP_DOWN			; Continua no laço se o sentido de rotação não foi alterado.

DELAY_500MS:	mov R2, #5				; Rotina de atraso de A x 100 ms (com A = 5).
LOOP1:			mov R1, #255
LOOP2:			mov R0, #255
LOOP3:			djnz R0, LOOP3
				djnz R1, LOOP2
				djnz R2, LOOP1
				ret

ISR_EX0:		clr FLAG
				setb EA
				reti					; Retorna da interrupção.
			
ISR_TIMER0:		reti					; Retorna da interrupção.
			
ISR_EX1:		setb FLAG
				setb EA
				reti					; Retorna da interrupção.

ISR_TIMER1:		reti					; Retorna da interrupção.
			
ISR_SERIAL:		reti					; Retorna da interrupção.
	   
end