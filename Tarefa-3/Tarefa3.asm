; Arquivo assembly de um contador externo de 8 bits (c/ recarga autom?tica) com duas entradas de contagem.
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
					ljmp INIT			; Pula para o in?cio do programa.

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

INIT:			mov IE, #83h		; Habilita a interrupção do Timer 0. 1000$0011b
				mov TMOD, #01h		; Configura o Timer 0 em Modo 1. 0000$0001b
				mov TH0, #3Ch		; Move o byte superior para gerar 50k contagens (50 ms). 0111$1100b
				mov TL0, #0AFh		; Move o byte inferior. 1010$1111b
				
				setb FLAG
				
				setb VD
				setb AM
				setb VM
				setb VD1
				setb VM1
				
LOOP:			
				clr VD				;Deixa o verde ligado
				mov R0, #800		;Faz R0 = 800 para repetir 800x a rotina de 1000 ms. preparado para a interrupção
				jnb FLAG, Amarelo
				sjmp LOOP				; Retorna ao la?o principal.
				Amarelo:
					setb FLAG
					setb VD
					clr AM
					jnb Vermelho
					sjmp Amarelo				; Retorna para amarelo.
					Vermelho:
						setb FLAG
						setb AM
						clr VM
						clr AM
						
							
				
			; Retorna ao la?o principal.

ISR_EX0:		setb TR0			; Liga o Timer 0 e a contagem começa.
				clr TF0				; Limpa a flag que gerou a interrupção.
				clr FLAG			; Sinaliza que o b foi prescionado
				reti				; Retorna da interrup??o.
			
ISR_TIMER0:		
				clr TF0				; Limpa a flag que gerou a interrupção.
				mov TH0, #3Ch		; Recarrega os bytes superior e inferior.
				mov TL0, #0AFh		; Move o byte inferior.
				djnz R0, return		; Retorna da interrupção neste ponto se R0 > 0.
				setb VD				; Desliga o Verde Carro
				setb AM				; Liga o Amarelo Carro
				mov R0, #800		; Recarrega o R0.
return:			reti				; Retorna da interrupção.
			
ISR_EX1:		reti					; Retorna da interrup??o.

ISR_TIMER1:		reti					; Retorna da interrup??o.
			
ISR_SERIAL:		reti					; Retorna da interrup??o.
	   
end
	
	