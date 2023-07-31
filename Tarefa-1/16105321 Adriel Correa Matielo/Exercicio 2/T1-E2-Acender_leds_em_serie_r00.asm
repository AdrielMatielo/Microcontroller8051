; ======================================= Universidade Federal de Pelotas
; ======================================= Centro de Desenvolvimento Tecnológico
; ======================================= Bacharelado em Engenharia de Computação
; ======================================= Disciplina: 22000279 --- Microcontroladores
; ======================================= Turma: 2023/1 --- M1
; ======================================= Professor: Alan Rossetto
;
;										  Descrição: AT80C51RD2 12MHz - Rola o LED aceso de acordo com o pressionar o botão P1.7
; 										  Arquivo base para desenvolvimento da Tarefa 2.
;
; 										  Identificação:
; 										  Nome da(o) aluna(o) & Matrícula: Adriel Correa Matielo 16105321
; 										  Nome da(o) aluna(o) & Matrícula:
;										  Data: __/__/__

				$mod51

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INIT:									; Subrotina para eventuais inicializações
				mov A, #11111110b		; Carrega 1 LED ACESO ao acomulador
				
	MSB:								; DECRESCENTE
				mov P0, A				; Acende os LEDs
				call DELAY
				rr A					; Rola o acomulador para DIREITA
				jnb P1.7, LSB			; Se o Botão P1.7 estiver prescionado (0) pula para LSB
				sjmp MSB				; Permanece no decrescente.
				
	LSB:								; CRESCENTE
				mov P0, A				; Acende os LEDs
				call DELAY				
				rl A					; Rola o acomulador para ESQUERDA
				jnb P1.7, MSB			; Se o Botão P1.7 estiver prescionado (0) pula para MSB
				sjmp LSB				; Permanece no crescente.
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DELAY:			mov R2, #002			; Rotina de atraso de A x 100 ms (com A = 2).
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