; Exemplo de solução para a Tarefa 6. 
; Temporização baseada em f = 10 MHz.

				$mod51
										; Definição das saídas:
										
DISPLAY			equ P2
FLAG_COUNT		equ P3.4

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

INIT:			mov R0, #0				; Inicializa os registradores contendo a unidade,
				mov R1, #0				; dezena,
				mov R2, #0				; centena e
				mov R3, #0				; milhar.
				mov R4, #2
				;mov R7, #5
				mov DISPLAY, #0
				mov IE, #1000$1101b		; Inicializa as interrupções externas e do T/C 1, responsável pela cadência de tempo.
				mov TMOD, #11h
				mov TH1, #5Dh
				mov TL1, #3Dh
				clr TR1					; Inicializa com o timer desligado.
				sjmp LOOP				; Pula para o laço principal.


; Outra maneira de implementar o programa utilizando o vetor BIRTHDAY:
LOOP:			lcall DEPICT			; Faz a varredura dos displays de 7 segmentos.
				sjmp LOOP				; Permanece no laço principal.
;=======================================
DEPICT:			mov A, #0
				swap A
				orl A, R0
				mov DISPLAY, A
				lcall DELAY
				mov A, #1
				swap A
				orl A, R1
				mov DISPLAY, A
				lcall DELAY
				mov A, #2
				swap A
				orl A, R2
				mov DISPLAY, A
				lcall DELAY
				mov A, #3
				swap A
				orl A, R3
				mov DISPLAY, A
				lcall DELAY
				ret


DELAY:			mov R5, #255			; Gasta ~500 us por polling.
				djnz R5, $
				mov R5, #255
				djnz R5, $
				ret
;=============================================================================
ISR_EX0:		clr IE0					; Limpa a flag de interrupção.
				cpl TR1					; Liga / desliga o Timer 1.
				jnb P3.2, $				; Aguarda o botão ser liberado.
				reti					; Retorna da interrupção.
			
ISR_TIMER0:		reti					; Retorna da interrupção.
			
ISR_EX1:		clr IE1					; Limpa a flag de interrupção.
				clr TR1					; Desliga o Timer 1.
				mov R0, #0				; Zera o contador.
				mov R1, #0
				mov R2, #0
				mov R3, #0
				jnb P3.3, $				; Aguarda o botão ser liberado.
				reti					; Retorna da interrupção.

ISR_TIMER1:		clr TF1
				mov TH1, #5Dh
				mov TL1, #3Dh
				djnz R4, RETURN2
				jb FLAG_COUNT, DOWN2UP
				jnb FLAG_COUNT, UP2DOWN
DOWN2UP:		lcall COUNT_UP
				mov R4, #2
				reti
UP2DOWN:		lcall COUNT_DN
				mov R4, #2
RETURN2:		reti					; Retorna da interrupção.
			
			
ISR_SERIAL:		reti					; Retorna da interrupção.
	   
				end