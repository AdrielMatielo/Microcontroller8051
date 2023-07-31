; ======================================= Universidade Federal de Pelotas
; ======================================= Centro de Desenvolvimento Tecnológico
; ======================================= Bacharelado em Engenharia de Computação
; ======================================= Disciplina: 22000279 --- Microcontroladores
; ======================================= Turma: 2023/1 --- M1
; ======================================= Professor: Alan Rossetto
;
;										  Descrição: AT80C51RD2 - 12MHz - Faz a contagem em um display de 7 segmentos 
; 										  Arquivo base para desenvolvimento da Tarefa 1.
;
; 										  Identificação:
; 										  Nome da(o) aluna(o) & Matrícula: Adriel Correa Matielo
; 										  Nome da(o) aluna(o) & Matrícula:
;										  Data: 06/07/2023

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

INIT:									; Subrotina para eventuais inicializações (não necessária na Tarefa 1).
					
LOOP:									; Início do laço principal e do trecho editável do programa.
				;		 abcdefgp
				mov P0, #00000011b	;0
				call DELAY
				mov P0, #10011111b	;1
				call DELAY
				mov P0, #00100101b	;2
				call DELAY
				mov P0, #00001101b	;3
				call DELAY
				mov P0, #10011001b	;4
				call DELAY
				mov P0, #01001001b	;5
				call DELAY
				mov P0, #01000001b	;6
				call DELAY
				mov P0, #00011111b	;7
				call DELAY
				mov P0, #00000001b	;8
				call DELAY
				mov P0, #00001001b	;9
				call DELAY

				sjmp LOOP				; Fim do laço principal e término do trecho editável do programa.

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