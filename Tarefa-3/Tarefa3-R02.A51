; Arquivo assembly de um contador externo de 8 bits (c/ recarga autom�tica) com duas entradas de contagem.
; Entrada 0 no pino T0 (P3.4) e contagem no T/C 0.
; Entrada 1 no pino T1 (P3.5) e contagem no T/C 1.
; O pino P1.0 suspende / retoma a contagem.

				$mod51
				
				VD			equ P0.0	; Verde - veiculos
				AM 			equ P0.1	; Amarelo - veiculos
				VM 			equ P0.2	; Vermelho - veiculos
				VD1			equ P0.3	; Verde - pedestres
				VM1			equ P0.4	; Vermelho - pedestres
				COUNTER0	equ	P1
				COUNTER1	equ	P2
				BUTTON		equ	P3.2
				FLAG		equ 002Ch

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

		INIT:	mov IE, #10000001b      			; Enable EX0 interrupt and Timer 0 overflow interrupt.
				mov TMOD, #01100110b 				; Configura os T/Cs na função contador e modo 2 (8 bits c/ recarga automática). 
				mov R0, #20							; Faz R0 = 20 para repetir 20x a rotina de 50 ms.
				mov TH0, #3Ch						; Move o byte superior para gerar 50k contagens (50 ms).
				mov TL0, #0AFh						; Move o byte inferior.
				mov R1, #20							; Faz R1 = 20 para repetir 20x a rotina de 50 ms.
				mov TH1, #3Ch						; Move o byte superior para gerar 50k contagens (50 ms).
				mov TL1, #0AFh						; Move o byte inferior.
				setb FLAG               			; Set the FLAG to start the counting.
				setb EA                 			; Enable global interrupts.
				setb TR0                			; Enable Timer 0.
				setb TR1                			; Enable Timer 1.
				clr VD                  			; Turn on the traffic light signal GREEN.
				clr VM1								; Turn on the pedestrians light signal RED.
				setb VD1
				setb VM
				setb AM 							; Turn off the traffic light signal YELLOW.			
LOOP:			mov COUNTER0, TL0					; Exibe a contagem do Contador 0 na porta P1 (nesse exemplo ativo em n�vel ALTO).
				mov COUNTER1, TL1					; Exibe a contagem do Contador 1 na porta P2 (nesse exemplo ativo em n�vel ALTO).
				jnb FLAG, SR_COUNTING0 				; Monitora o bot�o pra saber se a contagem vai ser suspensa / retomada.
				sjmp LOOP							; Retorna ao la�o principal.
				
SR_COUNTING0: 	cpl TR0								; Desliga / liga o Contador 0.
				cpl TR1								; Desliga / liga o Contador 1.
				jnb BUTTON, $						; Espera a libera��o do bot�o.
				setb VD
				clr VM1
				setb VD1
				setb VM
				clr AM 
				; 2 segundos , aqui vai a rotina amarelo
SR_COUNTING1: 	cpl TR0								; Desliga / liga o Contador 0.
				cpl TR1								; Desliga / liga o Contador 1.
				jnb BUTTON, $						; Espera a libera��o do bot�o.
				setb VD
				setb VM1
				clr VD1
				clr VM
				setb AM 
				; 10 segundos,  aqui vai a outra rotina de volta pro vermelho
				sjmp INIT							; Retorna ao la�o principal.

ISR_EX0:		clr EA
				clr FLAG
				reti								; Retorna da interrup��o.
			
ISR_TIMER0:		clr TF0								; Limpa a flag que gerou a interrup��o.
				mov TH0, #3Ch						; Recarrega os bytes superior e inferior.
				mov TL0, #0AFh						; Move o byte inferior.
				djnz R0, return						; Retorna da interrup��o neste ponto se R0 > 0.
				cpl LED								; Complementa o valor do LED.
				mov R0, #20							; Recarrega o R0.
return:			reti								; Retorna da interrup��o.
			
ISR_EX1:		clr EA
				clr FLAG
				reti								; Retorna da interrup��o.

ISR_TIMER1:		clr TF0								; Limpa a flag que gerou a interrup��o.
				mov TH1, #3Ch						; Recarrega os bytes superior e inferior.
				mov TL1, #0AFh						; Move o byte inferior.
				djnz R1, return2					; Retorna da interrup��o neste ponto se R0 > 0.
				cpl LED								; Complementa o valor do LED.
				mov R1, #20							; Recarrega o R0.
return2:		reti								; Retorna da interrup��o.
			
ISR_SERIAL:		reti								; Retorna da interrup��o.
	   
end