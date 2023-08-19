// ======================================= Universidade Federal de Pelotas
// ======================================= Centro de Desenvolvimento Tecnológico
// ======================================= Bacharelado em Engenharia de Computação
// ======================================= Disciplina: 22000279 --- Microcontroladores
// ======================================= Turma: 2023/1 --- M1
// ======================================= Professor: Alan Rossetto
//
//										  Descrição: Tarefa 8
//
// 										  Identificação:
// 										  Nome da(o) aluna(o) & Matrícula: Ari Vitor da Silva Lazzarotto, 17200917
// 										  Nome da(o) aluna(o) & Matrícula: Adriel Correa Matielo, 16105321
//										  Data: 19/08/2023			
//
//======================================= Counter 
#include <at89x52.h>										

	#define displayA P0
	#define displayB P2
	
	void restart(void);
	
	void ISR_INT0(void);
	void ISR_INT1(void);
	void ISR_TF0 (void);
	void ISR_TF1 (void);
	
	//flag that controls the restart
	bit requestRestart = 0;
	//tens of display A
	int tensA;
	//tens of display B
	int tensB;
	

	void main (void){
//===================== REGISTERS CONFIGURATION
		//Interrupt Register: (1)Enable-(X)-(X)-(0)E/S -$- (1)Timer1-(1)Ex1-(1)Timer0-(1)Ex0
		IE = 0xFF;
		//Interrupt Priority: (X)IP.7-(X)IP.6-(X)IP.5-(0)Serial -$- (0)Timer1-(0)Ex1-(0)Timer0-(0)Ex0
		IP = 0x0;
		//Timer Mode Register: T1 (0)GATE1-(1)Timer/Contador-(10)Mode02 -$- T2 (0)GATE2-(1)Timer/Contador-(10)Mode02
		TMOD = 0x66;
		//Timer Control Register: (0)TF1-(1)TR1-(0)TF0-(1)TR0 -$- (0)IE1-(1)IT1-(0)IE0-(1)IT0
		TCON = 0x50;
		
//===================== START CONFIGURATION	
		
		//set timers and reset display
		restart();

//===================== PRINCIPAL LOOP
		
		while(1){
			displayA = tensA + TL0 - 0xF6;
			displayB = tensB + TL1 - 0xF6;
			if(requestRestart) restart();
			if(tensA == 0xA0) {
				tensA = 0;
				displayA = 0;
			}
			
			if(tensB == 0xA0) {
				tensB = 0;
				displayB = 0;
			}
		}
	}

//===================== FUNCTIONS

	void restart(){
		requestRestart = 0;
		TH0 = 0xF6;
		TL0 = 0xF6;
		TH1 = 0xF6;
		TL1 = 0xF6;
		
		tensA = 0;
		tensB = 0;
		
		return;
	}
	
//===================== INTERRUPTIONS
//Pause/Resume Timers 0 and 1
	void ISR_INT0(void) interrupt 0{
		TR0 = !TR0;
		TR1 = !TR1;
		return;
	}
	
//Stop (restart counter and displays)
	void ISR_INT1(void) interrupt 2{
		requestRestart = 1;
		return;
	}
	
//Timer Flag 0 adds 1 ten on display A
	void ISR_TF0 (void) interrupt 1{
		TF0 = 0;
		tensA += 0x10;
		return;
	}	
//Timer Flag 1 adds 1 ten on display B
	void ISR_TF1 (void) interrupt 3{
		TF1 = 0;
		tensB += 0x10;
		return;
	}