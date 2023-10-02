//
// Created by Adriel on 01/10/2023.
//

#ifndef LCD_H
#define LCD_H

#include "defines.h"

//LCD
void ConfigLCD();
void WriteMSG(char msg[]);
void Line1();
void Line2();
void WrCMD();
void WrCHAR();
void msg_CLEANER();

#endif
