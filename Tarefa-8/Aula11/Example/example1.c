#include <at89x52.h>										// header with assembly commands for 8051

	#define LED P0
	#define BUTTON P3_3											// change direction
	
	void delay_v1(unsigned int);						// function for delay in ms

		bit direction = 1;										// direction 1=LSB to MSB

	void main (void){
		LED = 0xFE;														// LSB on

		while(1){
			if (!BUTTON){												// on button press
				while (!BUTTON){}									// wait button release
				if(direction) direction = 0;			// change direction
					else direction = 1;
			}
			
			if(!direction){
				delay_v1(250);
				LED = (LED << 1) +1;							// roll left
				if (LED == 0xFF)
					LED = 0xFE;
			}else{
				delay_v1(250);
				LED = (LED >> 1) +128;						// roll right
				if (LED == 0xFF)
					LED = 0x7F;
			}
		}
		
	}

	void delay_v1(unsigned int ms){					// Delay with polling in T/C 0.

	TMOD |= 0x01;													// Operation OR keeps previously configuration of T/C 1.
	
	while(ms){
		TH0 = 0xFC;													// 1 ms @ f = 12 MHz (i.e. 64535).
		TL0 = 0x17;
		TR0 = 1;
		while(!TF0);
		TF0 = 0;
		TR0 = 0;
		ms--;
	}
}