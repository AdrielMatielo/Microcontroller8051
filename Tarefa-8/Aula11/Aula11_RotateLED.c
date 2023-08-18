#include <at89x52.h>										// Carrega as definicões padrão do microcontrolador alvo.

#define		LEDS		P0										// Define a Porta P0 como sendo o barramento dos LEDs.
#define		UP2DN		P1_0									// Define os pinos P1.0 e P1.7 como sendo os botões de sentido
#define		DN2UP		P1_7									// de deslocamento decrescente e crescente respectivamente.

void delay_v1(unsigned int);						// Declaração do(s) protótipo(s) de eventual(is) função(ões) utilizada(s).

void main(void){												// Início do programa principal.
	
	bit FLAG = 1;													// Arbitra um sentido inicial para o deslocamento:
																				// 0 - up to down; 1 - down to up.
	
	LEDS = 0xFE;													// Inicializa o barramento com 1111$1110b.
	
	while(1){															// Permanece em laço infinito.
		while(FLAG){												// Permanece deslocando de forma crescente.
			delay_v1(100);										// Aguarda 100 ms.
			LEDS = ((LEDS << 1) + 1);					// Desloca o conteúdo do barramento em uma posição para a esquerda e soma 1 para restaurar o LSb.
			if(LEDS == 0xFF){									// Restaura o zero no LSb após o deslocamento a partir do MSb.
				LEDS = 0xFE;
			}
			if(!UP2DN){												// Monitora a requisição de deslocamento decrescente.
				while(!UP2DN);									// Retém a execução enquanto o botão é pressionado.
				FLAG = 0;												// Habilita o deslocamento decrescente.
			}
		}
			
		while(!FLAG){
			delay_v1(100);										// Aguarda 100 ms.
			LEDS = ((LEDS >> 1) + 128);				// Desloca o conteúdo do barramento em uma posição para a direita e soma 128 para restaurar o MSb.
			if(LEDS == 0xFF){									// Restaura o zero no MSb após o deslocamento a partir do LSb.
				LEDS = 0x7F;
			}
			if(!DN2UP){												// Monitora a requisição de deslocamento crescente.
				while(!DN2UP);									// Retém a execução enquanto o botão é pressionado.
				FLAG = 1;												// Habilita o deslocamento crescente.
			}
		}
	}
}

void delay_v1(unsigned int ms){					// Delay por polling via T/C 0.

	TMOD |= 0x01;													// A operação OU preserva alguma eventual configuração prévia do T/C 1.
	
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