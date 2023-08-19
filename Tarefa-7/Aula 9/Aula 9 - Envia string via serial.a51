; Programa em Assembly para o envio único (FLAG = 0) ou contínuo (FLAG = 1) de uma string via porta serial.
; Configurações da serial: Modo 1 e 9600 bps @ f = 11.0592 MHz.

				$mod51
				
				FLAG equ P1.0
				REPEAT equ 002Ch
					
				org 0000h	; RESET	
					ljmp INIT			; Salta para a rotina de inicialização.

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

INIT:			lcall TIMER_CONFIG		; Configura o T/C 1 para gerar o baudrate necessário.
				lcall SERIAL_CONFIG		; Configura a operação da porta serial.
				clr REPEAT				; Desabilita a repetição do envio.
				jnb FLAG, LOOP			; Se FLAG = 0, salta para o laço principal, com repetição desabilitada.
				setb REPEAT				; Se FLAG = 1, habilita a repetição e em seguida salta para o laço principal.
				sjmp LOOP
	
LOOP:			mov DPTR, #MSG			; Carrega a posição de memória inicial da string no DPTR.
				lcall SERIAL_SEND		; Envia a string através do canal serial.
				jb FLAG, LOOP			; Repete o envio de FLAG = 1.
				sjmp $					; Retem a execução do programa após um único envio.
	
MSG:			db 'Teste de Comunicacao Serial - Aula de Microcontroladores (2023-1) - Engenharia de Computacao / UFPEL', 0Dh, 0FFh 

TIMER_CONFIG:	mov TMOD, #21h			; T/C 1 em Modo 8 bits com recarga automática (Modo 2) | T/C 0 em modo 16 bits (Modo 1).
				mov TH1, #253			; 0FDh: valor de recarga para 9600 bps.
				mov TL1, #253			; 0FDh: valor inicial para 9600 bps
				setb TR1
				ret

SERIAL_CONFIG:	mov PCON, #00h			; Baudrate simples (SMOD = 0).
				mov SCON, #50h			; 0101$0000 -> Modo 1, recepção serial habilitada (REN = 1).
				ret
				
SERIAL_SEND:	clr A					; Limpa o acumulador.
				movc A, @A+DPTR			; Move para o acumulador o conteúdo de memória apontado por A+DPTR.
				cjne A, #0FFh, SERIAL_WRITE
				ret				
SERIAL_WRITE:	mov SBUF, A				; Mode dado para o buffer da serial.
				jnb TI, $				; Aguarda a transmissão (TI = 0->1).
				clr TI					; Limpa a flag de transmissão.
				inc DPTR				; Incrementa o data pointer.
				lcall DELAY_50MS		; Define a cadência de escrita.
				ljmp SERIAL_SEND		; Continua a transmissão se a string não acabou.
				
DELAY_50MS:		mov TH0, #04Bh
				mov TL0, #0FFh
				setb TR0
				jnb TF0, $
				clr TF0
				ret
				
ISR_EX0:		reti					; Retorna da interrupção.
			
ISR_TIMER0:		reti					; Retorna da interrupção.
			
ISR_EX1:		reti					; Retorna da interrupção.

ISR_TIMER1:		reti					; Retorna da interrupção.
			
ISR_SERIAL:		reti					; Retorna da interrupção.

end