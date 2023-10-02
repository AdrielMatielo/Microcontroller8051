//
// Created by Adriel on 01/10/2023.
//

#ifndef MACHINE_H
#define MACHINE_H

#include "defines.h"



//machine
void start();                   //start registers and variables
//unsigned int startMoney();    //start machine with money
unsigned int startCode();       //start machine with code
int codeValidation();
int sumOfMoney();
unsigned int giveMeTheMoney();  //request money for product | when nows the code
void dispenseProduct();         //set motors of respective COD_PRODUCT
void convertIntToBinary();      //


#endif
