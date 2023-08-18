#include <at89x52.h>										// Carrega as definicões padrão do microcontrolador alvo.

#define		DISPLAY		P0									// Define a Porta P0 como o barramento do display.

void delay_v1(unsigned int);						// Define o protótipo da(s) função(ões) utilizada(s).

void main(void){												// Início do programa principal.
	
	DISPLAY = 0x00;												// Inicializa o display com zero;
	
	while(1){															// Entra em laço infinito.
		delay_v1(500);											// Aguarda 500 ms.
		DISPLAY++;													// Incrementa a contagem.
			if(DISPLAY > 9){									// Zera a contagem se esta exceder 9.
				DISPLAY = 0;
      }
	}
}																				// Fim do programa principal.

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