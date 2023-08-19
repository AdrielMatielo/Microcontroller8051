; Código para recepção de número via canal serial e escrita em display BCD / 7 segmentos ligado à Porta P0.
; Configuração da serial: Modo 1, baudrate de 1200 bps @ f = 6 MHz.

				$mod51
	
				DISPLAY equ P0
					
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

INIT:			lcall INTs_CONFIG
				lcall TIMER_CONFIG
				lcall SERIAL_CONFIG
				mov DISPLAY, #0
				sjmp LOOP
	
LOOP:			sjmp $

INTs_CONFIG:	mov IE, #90h			; Habilita interrupção serial.
				ret

TIMER_CONFIG:	mov TMOD, #20h			; Configura T/C 1 em modo 8 bits com recarga.
				mov TH1, #243
				mov TL1, #243
				setb TR1
				ret

SERIAL_CONFIG:	mov PCON, #00h			; SMOD = 0.
				mov SCON, #50h			; Modo 1, recepção habilitada (REN = 1).
				ret
				
ISR_EX0:		reti					; Retorna da interrupção.
			
ISR_TIMER0:		reti					; Retorna da interrupção.
			
ISR_EX1:		reti					; Retorna da interrupção.

ISR_TIMER1:		reti					; Retorna da interrupção.
			
ISR_SERIAL:		mov A, SBUF				; Copia o conteúdo do buffer da serial para o acumulador.
                ; clr C					; Limpa o carry (opcional).
				subb A, #30h			; Subtrai 30h do valor do acumulador para remover a codificação ASCII do número.
				mov DISPLAY, A			; Envia o número para o display.
				clr RI					; Limpa a flag de detecção de recebimento serial.
				reti					; Retorna da interrupção.

end