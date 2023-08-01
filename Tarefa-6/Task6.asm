; Exemplo de solução para a Parte II da Tarefa 1.

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

INIT:			mov R3, #0				; Inicializa o iterador da lista (aqui vamos usar o registrador R3).
				mov DPTR, #NUMBERS		; Carrega a lista de números no data pointer.
				sjmp LOOP				; Pula para o laço principal
					
LOOP:			mov A, R3				; Carrega o iterador no acumulador.
				movc A, @A+DPTR			; Move para o acumulador o número correspondente à posição apontada pelo iterador.
				mov P0, A				; Move o acumulador para a porta P0.
				lcall DELAY_500MS		; Espera 500 ms.
				cjne A, #009, CONTINUE	; Compara pra verificar se a lista não chegou ao fim (número 9).
				mov R3, #0				; Se a lista chegou ao fim, zera o iterador (pra começar do início novamente)
				sjmp LOOP				; e retorna ao início do laço neste ponto.
CONTINUE:		inc R3					; Se a lista não chegou ao fim, incrementa o iterador
				sjmp LOOP				; e continua no laço principal.
	
; Cria uma lista com todos os números a serem exibidos utilizando a diretiva DB.
; Equivalentes 7seg: 0----1----2----3----4----5----6----7----8----9-
NUMBERS:		db	003, 159, 037, 013, 153, 073, 065, 031, 001, 009

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