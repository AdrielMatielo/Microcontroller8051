#ifndef DEFINES_H
#define DEFINES_H

#include "at89x52.h"
#include "Keyboard4x3.h"
#include "LCD.h"
#include "Machine.h"
#include "Messages.h"
#include "Timers.h"

//pins P0
#define MOTOR0 P1_0
#define MOTOR1 P1_1
#define MOTOR2 P1_2
#define MOTOR3 P1_3
//pins P1
#define LINA    P1_0
#define LINB    P1_1
#define LINC    P1_2
#define LIND    P1_3
#define COL1    P1_4
#define COL2    P1_5
#define COL3    P1_6
//pins P2
#define LCD     P2
//pin P3
#define PLUS1   P3_0
#define PLUS10  P3_1
#define insert  P3_2
#define MINUS1  P3_3
#define MINUS10 P3_4

#define EN      P3_6
#define RS      P3_7
//Products
#define MAX_PRODUCT 9

#define PRICE_PRODUCT_0 6
#define PRICE_PRODUCT_1 10
#define PRICE_PRODUCT_2 7
#define PRICE_PRODUCT_3 13
#define PRICE_PRODUCT_4 2
#define PRICE_PRODUCT_5 15
#define PRICE_PRODUCT_6 20
#define PRICE_PRODUCT_7 18
#define PRICE_PRODUCT_8 1

#define COD_PRODUCT_0 32
#define COD_PRODUCT_1 52
#define COD_PRODUCT_2 78
#define COD_PRODUCT_3 10
#define COD_PRODUCT_4 11
#define COD_PRODUCT_5 12
#define COD_PRODUCT_6 23
#define COD_PRODUCT_7 21
#define COD_PRODUCT_8 22
//value of times in ms
#define TIME_WAIT 10000
#define LITTLE_WAIT 1000

//global variables
unsigned int digit1;            //1st digit of COD_PRODUCT
unsigned int digit2;            //2nd digit of COD_PRODUCT
unsigned int digit12;           //COD_PRODUCT
unsigned int amount;            //amount of money entered
unsigned int price;             //price of COD_PRODUCT
unsigned int dispenser;         //position of COD_PRODUCT = MOTOR
unsigned int priceProduct[MAX_PRODUCT] = {PRICE_PRODUCT_0, PRICE_PRODUCT_1, PRICE_PRODUCT_2,
                                          PRICE_PRODUCT_3, PRICE_PRODUCT_4, PRICE_PRODUCT_5,
                                          PRICE_PRODUCT_6, PRICE_PRODUCT_7, PRICE_PRODUCT_8};
unsigned int codeProduct[MAX_PRODUCT] = {COD_PRODUCT_0, COD_PRODUCT_1, COD_PRODUCT_2,
                                         COD_PRODUCT_3, COD_PRODUCT_4, COD_PRODUCT_5,
                                         COD_PRODUCT_6, COD_PRODUCT_7, COD_PRODUCT_8};


#endif