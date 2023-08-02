; ======================================= Universidade Federal de Pelotas
; ======================================= Centro de Desenvolvimento Tecnol�gico
; ======================================= Bacharelado em Engenharia de Computa��o
; ======================================= Disciplina: 22000279 --- Microcontroladores
; ======================================= Turma: 2023/1 --- M1
; ======================================= Professor: Alan Rossetto
;
;										  Descri��o: Tarefa 6
;
; 										  Identifica��o:
; 										  Nome da(o) aluna(o) & Matr�cula: Ari Vitor da Silva Lazzarotto, 17200917
; 										  Nome da(o) aluna(o) & Matr�cula: Adriel Matielo, 
;										  Data: 01/08/2023			
;
; ======================================= Cyclic Counter - 4 digits

				$mod51
				
				
	clr P3.0
	clr P3.1
	

				org 0000h	; RESET	
					ljmp INIT

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
					
; Creates a list with all the numbers to be displayed using the DB directive

INIT:			mov R3, #0				; Inicializa o iterador da lista (aqui vamos usar o registrador R3).
				mov DPTR, #NUMBERS		; Carrega a lista de n�meros no data pointer.
				lcall DELAY_500MS
				sjmp LOOP				; Pula para o la�o principal
					
LOOP:			mov A, R3				; Carrega o iterador no acumulador.
				movc A, @A+DPTR			; Move para o acumulador o n�mero correspondente � posi��o apontada pelo iterador.
				anl A, #0x0F
				mov P2, A				; Move o acumulador para a porta P0.
				lcall DELAY_500MS		; Espera 500 ms.
				cjne A, #009, CONTINUE	; Compara pra verificar se a lista n�o chegou ao fim (n�mero 9).
				mov R3, #0				; Se a lista chegou ao fim, zera o iterador (pra come�ar do in�cio novamente)
				sjmp LOOP				; e retorna ao in�cio do la�o neste ponto.
CONTINUE:		inc R3					; Se a lista n�o chegou ao fim, incrementa o iterador
				sjmp LOOP
				
				sjmp INIT
				
				
numbers: db 1, 2, 3, 4, 5, 6, 7, 8, 9
	
				
ISR_EX0:		reti

DELAY_500MS:	mov R2, #5				; Rotina de atraso de A x 100 ms (com A = 5).
LOOP1:			mov R1, #255
LOOP2:			mov R0, #255
LOOP3:			djnz R0, LOOP3
				djnz R1, LOOP2
				djnz R2, LOOP1
				ret			
	
ISR_TIMER0:		reti
			
ISR_EX1:		reti

ISR_TIMER1:		reti
			
ISR_SERIAL:		reti
	   
end