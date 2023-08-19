				$mod51
					
				LCD	equ P2
				EN	equ P3.1
				RS	equ P3.0
	
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

INIT:			lcall LCD_CONFIG
				lcall LINE_1
				mov DPTR, #MSG1
				lcall LCD_WRITE
				lcall LINE_2
				mov DPTR, #MSG2
				lcall LCD_WRITE
				ljmp $
	
LCD_WRITE:		mov R4, #0				; Carrega o iterador no acumulador.
LOOP:			mov A, R4				; 
				movc A, @A+DPTR			; Move para o acumulador o conteúdo da posição de memória apontada pelo iterador.
				cjne A, #0FFh, CONTINUE	; Compara pra verificar se a string não chegou ao fim.
				ret						; Se a string chegou ao fim, retorna da função.
CONTINUE:		mov LCD, A				; Do contrário, move o dado para o barramento e
				lcall WR_CHAR			; escreve um caractere.
				lcall DELAY_50MS		; Espera 500 ms.
				inc R4					; Incrementa o iterador.
				sjmp LOOP				; e continua no laço principal.

MSG1:			db ' Disciplina de: ', 0FFh
	MSG2:			db 0E4h,'Controladores :D', 0FFh

LINE_1:			mov LCD, #80h
				lcall WR_CMD
				ret

LINE_2:			mov LCD, #0C0h
				lcall WR_CMD
				ret

WR_CMD:			clr RS
				nop
				setb EN
				lcall DELAY_5US
				clr EN
				lcall DELAY_5MS
				ret

WR_CHAR:		setb RS
				nop
				setb EN
				lcall DELAY_5US
				clr EN
				lcall DELAY_5MS
				ret


DELAY_5US:		nop
				nop
				nop
				ret

DELAY_5MS:		mov R1, #27
LDL1:			mov R2, #255
LDL2:			djnz R2, LDL2
				djnz R1, LDL1
				ret

DELAY_50MS:		mov R3, #10
LDL3:			lcall DELAY_5MS
				djnz R3, LDL3
				ret

LCD_CONFIG:		mov LCD, #38h	; Define a matriz 5x7 pontos.
				lcall WR_CMD
				mov LCD, #06h	; Deslocamento do cursor E->D.
				lcall WR_CMD
				mov LCD, #0Eh	; Cursor fixo.
				lcall WR_CMD
				mov LCD, #01h	; Limpa o display.
				lcall WR_CMD
				mov LCD, #02h	; Vai para a primeira linha (opcional).
				lcall WR_CMD
				ret
				
ISR_EX0:		reti					; Retorna da interrupção.
			
ISR_TIMER0:		reti					; Retorna da interrupção.
			
ISR_EX1:		reti					; Retorna da interrupção.

ISR_TIMER1:		reti					; Retorna da interrupção.
			
ISR_SERIAL:		reti					; Retorna da interrupção.

end
