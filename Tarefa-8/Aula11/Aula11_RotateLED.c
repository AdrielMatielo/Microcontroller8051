#include <at89x52.h>										// Carrega as definic�es padr�o do microcontrolador alvo.

#define		LEDS		P0										// Define a Porta P0 como sendo o barramento dos LEDs.
#define		UP2DN		P1_0									// Define os pinos P1.0 e P1.7 como sendo os bot�es de sentido
#define		DN2UP		P1_7									// de deslocamento decrescente e crescente respectivamente.

void delay_v1(unsigned int);						// Declara��o do(s) prot�tipo(s) de eventual(is) fun��o(�es) utilizada(s).

void main(void){												// In�cio do programa principal.
	
	bit FLAG = 1;													// Arbitra um sentido inicial para o deslocamento:
																				// 0 - up to down; 1 - down to up.
	
	LEDS = 0xFE;													// Inicializa o barramento com 1111$1110b.
	
	while(1){															// Permanece em la�o infinito.
		while(FLAG){												// Permanece deslocando de forma crescente.
			delay_v1(100);										// Aguarda 100 ms.
			LEDS = ((LEDS << 1) + 1);					// Desloca o conte�do do barramento em uma posi��o para a esquerda e soma 1 para restaurar o LSb.
			if(LEDS == 0xFF){									// Restaura o zero no LSb ap�s o deslocamento a partir do MSb.
				LEDS = 0xFE;
			}
			if(!UP2DN){												// Monitora a requisi��o de deslocamento decrescente.
				while(!UP2DN);									// Ret�m a execu��o enquanto o bot�o � pressionado.
				FLAG = 0;												// Habilita o deslocamento decrescente.
			}
		}
			
		while(!FLAG){
			delay_v1(100);										// Aguarda 100 ms.
			LEDS = ((LEDS >> 1) + 128);				// Desloca o conte�do do barramento em uma posi��o para a direita e soma 128 para restaurar o MSb.
			if(LEDS == 0xFF){									// Restaura o zero no MSb ap�s o deslocamento a partir do LSb.
				LEDS = 0x7F;
			}
			if(!DN2UP){												// Monitora a requisi��o de deslocamento crescente.
				while(!DN2UP);									// Ret�m a execu��o enquanto o bot�o � pressionado.
				FLAG = 1;												// Habilita o deslocamento crescente.
			}
		}
	}
}

void delay_v1(unsigned int ms){					// Delay por polling via T/C 0.

	TMOD |= 0x01;													// A opera��o OU preserva alguma eventual configura��o pr�via do T/C 1.
	
	while(ms){
		TH0 = 0xFC;													// Valor de recarga para 1 ms @ f = 12 MHz (i.e. 64535).
		TL0 = 0x17;
		TR0 = 1;
		while(!TF0);
		TF0 = 0;
		TR0 = 0;
		ms--;
	}
}