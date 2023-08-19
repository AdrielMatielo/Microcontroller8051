; Programa em Assembly para o envio �nico (FLAG = 0) ou cont�nuo (FLAG = 1) de uma string via porta serial.
; Configura��es da serial: Modo 1 e 9600 bps @ f = 11.0592 MHz.

				$mod51
				
				FLAG equ P1.0
				REPEAT equ 002Ch
					
				org 0000h	; RESET	
					ljmp INIT			; Salta para a rotina de inicializa��o.

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

INIT:			lcall TIMER_CONFIG		; Configura o T/C 1 para gerar o baudrate necess�rio.
				lcall SERIAL_CONFIG		; Configura a opera��o da porta serial.
				clr REPEAT				; Desabilita a repeti��o do envio.
				jnb FLAG, LOOP			; Se FLAG = 0, salta para o la�o principal, com repeti��o desabilitada.
				setb REPEAT				; Se FLAG = 1, habilita a repeti��o e em seguida salta para o la�o principal.
				sjmp LOOP
	
LOOP:			mov DPTR, #MSG			; Carrega a posi��o de mem�ria inicial da string no DPTR.
				lcall SERIAL_SEND		; Envia a string atrav�s do canal serial.
				jb FLAG, LOOP			; Repete o envio de FLAG = 1.
				sjmp $					; Retem a execu��o do programa ap�s um �nico envio.
	
MSG:			db 'Teste de Comunicacao Serial - Aula de Microcontroladores (2023-1) - Engenharia de Computacao / UFPEL', 0Dh, 0FFh 

TIMER_CONFIG:	mov TMOD, #21h			; T/C 1 em Modo 8 bits com recarga autom�tica (Modo 2) | T/C 0 em modo 16 bits (Modo 1).
				mov TH1, #253			; 0FDh: valor de recarga para 9600 bps.
				mov TL1, #253			; 0FDh: valor inicial para 9600 bps
				setb TR1
				ret

SERIAL_CONFIG:	mov PCON, #00h			; Baudrate simples (SMOD = 0).
				mov SCON, #50h			; 0101$0000 -> Modo 1, recep��o serial habilitada (REN = 1).
				ret
				
SERIAL_SEND:	clr A					; Limpa o acumulador.
				movc A, @A+DPTR			; Move para o acumulador o conte�do de mem�ria apontado por A+DPTR.
				cjne A, #0FFh, SERIAL_WRITE
				ret				
SERIAL_WRITE:	mov SBUF, A				; Mode dado para o buffer da serial.
				jnb TI, $				; Aguarda a transmiss�o (TI = 0->1).
				clr TI					; Limpa a flag de transmiss�o.
				inc DPTR				; Incrementa o data pointer.
				lcall DELAY_50MS		; Define a cad�ncia de escrita.
				ljmp SERIAL_SEND		; Continua a transmiss�o se a string n�o acabou.
				
DELAY_50MS:		mov TH0, #04Bh
				mov TL0, #0FFh
				setb TR0
				jnb TF0, $
				clr TF0
				ret
				
ISR_EX0:		reti					; Retorna da interrup��o.
			
ISR_TIMER0:		reti					; Retorna da interrup��o.
			
ISR_EX1:		reti					; Retorna da interrup��o.

ISR_TIMER1:		reti					; Retorna da interrup��o.
			
ISR_SERIAL:		reti					; Retorna da interrup��o.

end