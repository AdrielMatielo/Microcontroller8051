//
// Created by Adriel on 01/10/2023.
//

#include "../Headers/LCD.h"
#include "../Headers/defines.h"
//Configure settings for LCD 8-bit 2row
void ConfigLCD(){
    LCD = 0x38; //Configuring settings to 16x2 8-bit
    WrCMD();
    LCD = 0x06; //Display On
    WrCMD();
    LCD = 0x0E; //Cursor ON
    WrCMD();
    LCD = 0x01; //Clear LCD
    WrCMD();
}
//Write the string (limited to 16 character)
void WriteMSG(char msg[]){
    unsigned char i;
    for(i = 0; i <= 16; i++){
        LCD = msg[i];
        WrCHAR();
    }
}
//Write only one char on display
void WrCHAR(){
    RS = 1;
    EN = 1;
    delayMs0(5);
    EN = 0;
    delayMs0(5);
}
//Configures the settings for write message on line 1
void Line1(){
    LCD = 0x00;
    WrCMD();
}
//Configures the settings for write message on line 2
void Line2(){
    LCD = 0xC0;
    WrCMD();
}
//Configures the LCD to receive a command
void WrCMD(){
    RS = 0;
    EN = 1;
    delayMs0(5);
    EN = 0;
    delayMs0(5);
}
//Clear the LCD
void msg_CLEANER(){
    LCD = 0x01;
    WrCMD();
}