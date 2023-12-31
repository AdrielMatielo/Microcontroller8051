// ======================================= Universidade Federal de Pelotas
// ======================================= Centro de Desenvolvimento Tecnologico
// ======================================= Bacharelado em Engenharia de Computacao
// ======================================= Disciplina: 22000279 --- Microcontroladores
// ======================================= Turma: 2023/1 --- M1
// ======================================= Professor: Alan Rossetto
//
//										  Descricao: Trabalho Final
//
// 										  Identificacao:
// 										  Nome da(o) aluna(o) & Matricula: Adriel Correa Matielo, 16105321
//                                        github.com/AdrielMatielo
// 										  Nome da(o) aluna(o) & Matricula: Ari Vitor da Silva Lazzarotto, 17200917
//										  Data: 12/09/2023
//
//
//For this task, the strategy adopted was to keep all the code in a single file,
//as the Keil software (mandatory for this task) has limitations regarding the number of lines of code.
//=======================================
#include "at89x52.h"

//=======================================
//=============== DEFINES ===============

//pins P1
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
#define insert  P3_2 //this port is IT0
#define MINUS1  P3_3
#define MINUS10 P3_4
//LCD
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

//value of timers in ms
#define TIMER_WAIT 10000
#define LITTLE_WAIT 1000

//=======================================
//=========== GLOBAL VARIABLES ==========

//flags of interruption 8051
unsigned int timer0end;         //Flag TF0
unsigned int timer1end;         //Flag TF1
unsigned int moneyIsReady;      //Flag IE0

//global variables
unsigned char empty[]= {"                 "};   //to save memory
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

//=======================================
//===============   LCD   ===============
void ConfigLCD();                   //Settings for LCD working
void WriteMSG(char msg[]);          //Write String
void Line1();                       //Write on line1
void Line2();                       //Write on line2
void WrCMD();                       //Command mode
void WrCHAR();                      //Write char mode
void routine1_MSG();                //Group of function to save memory
void msg_CLEANER();                 //Clean LCD

//=======================================
//==============  TIMERS  ===============
void timer0(unsigned int ms);       //like an alarm
void delayMs0(unsigned int ms);     //wait for the delay to end
void timer1(unsigned int ms);       //like an alarm
void delayMs1(unsigned int ms);     //wait for the delay to end
void Delay5us();                    //wait for the delay to end

//=======================================
//============  KEYBOARD  ===============
unsigned int scanKeyboard();    //scan keyboard 4x3

//=======================================
//=====  SPECIFIC FOR THIS MACHINE  =====
void start();                   //Start registers and variables
unsigned int startCode();       //Start machine with code
int codeValidation();           //Compare given code with possible codes
int sumOfMoney();               //Sum of the entered value
void change();                  //Sum of change
unsigned int giveMeTheMoney();  //Request money for product | when knows the code
void dispenseProduct();         //Set motors of respective COD_PRODUCT
void convertIntToBinary();      //To set specific motor

//=======================================
//=============  MESSAGES  ==============
void msg_Start();                   //First message
void msg_InsertCode2();             //Request second code
void msg_CanceledByUsr();           //Operation canceled by user
void msg_Code2Required();           //When pressed confirm before second code
void msg_Code2Insert();             //Show code provided (after second code)
void msg_IllegalCode();             //Code provided doesn't match with code of product
void msg_TimeOut_Code2_WTMoney();   //Timeout for second code
void msg_insertMoney();             //Request and shows amount of money provided
void msg_ConfirmBuy();              //Confirm or cancel operation
void msg_dispenseChange();          //Give change after confirm operation
void msg_timeoutWithMoney();        //Give change after timeout of confirmation
void msg_WorkingOnDispenser();      //Working on solicitation
void msg_done();                    //End of request
void WriteMSG_DIGIT2(char msg[]);   //Like "%d",&d - of digit2
void WriteMSG_DIGIT1(char msg[]);   //Like "%d",&d - of digit1
void WriteMSG_Amount(char msg[]);   //Like "%d",&d - of money



void main() {
    start:
    start();
    while(1){
        digit1 = scanKeyboard();
        //10 == '*' | 12 == '#' | 77 == void
        if((digit1 != 10) && (digit1 != 12) && (digit1 != 77)){
            if (startCode()) {
                TR0 = 0;
                TR1 = 0;
                if (giveMeTheMoney()) {
                    TR0 = 0;
                    TR1 = 0;
                    dispenseProduct();
                }
            }
            goto start;
        }
        goto start;
        //start with money
        //if (EX0) {
        //    //startMoney();
        //    goto start;
        //}
    }
}

unsigned int scanKeyboard() {
    COL1 = 1;
    COL2 = 1;
    COL3 = 1;
    while(1) {
        Delay5us();
        LINA = 0;
        LINB = 1;
        LINC = 1;
        LIND = 1;
        if (!COL1) {
            Delay5us();
            return 1;
        }
        if (!COL2) {
            Delay5us();
            return 2;
        }
        if (!COL3) {
            Delay5us();
            return 3;
        }

        LINA = 1;
        LINB = 0;
        LINC = 1;
        LIND = 1;
        if (!COL1) {
            Delay5us();
            return 4;
        }
        if (!COL2) {
            Delay5us();
            return 5;
        }
        if (!COL3) {
            Delay5us();
            return 6;
        }

        LINA = 1;
        LINB = 1;
        LINC = 0;
        LIND = 1;
        if (!COL1) {
            Delay5us();
            return 7;
        }
        if (!COL2) {
            Delay5us();
            return 8;
        }
        if (!COL3) {
            Delay5us();
            return 9;
        }

        LINA = 1;
        LINB = 1;
        LINC = 1;
        LIND = 0;
        if (!COL1) {
            //'*' key
            Delay5us();
            return 10;
        }
        if (!COL2) {
            // '0' key
            Delay5us();
            return 11;
        }
        if (!COL3) {
            // '#' key
            Delay5us();
            return 12;
        }
        if (timer1end)
            return 77;
    }
}

void ConfigLCD(){
    LCD = 0x38;                 //Start LCD
    WrCMD();
    LCD = 0x06;                 //Move the cursor
    WrCMD();
    LCD = 0x0E;                 //Cursor ON
    WrCMD();
    LCD = 0x01;                 //Clean LCD
    WrCMD();
}
void WriteMSG(char msg[]){
    unsigned char i;
    for(i = 0; i <= 16; i++){
        LCD = msg[i];
        WrCHAR();
    }
}
void WriteMSG_DIGIT1(char msg[]){
    unsigned char i;
    for(i = 0; i <= 16; i++){
        if(i==7) {
            if (digit1 == 11) {
                LCD = '0';
            } else {
                LCD = '0' + digit1;
            }
        }else if(i==8)
            LCD = '*';
        else
            LCD = msg[i];
        WrCHAR();
    }
}
void WriteMSG_DIGIT2(char msg[]){
    unsigned char i;
    for(i = 0; i <= 16; i++){
        if(i==7) {
            if (digit1 == 11) {
                LCD = '0';
            } else {
                LCD = '0' + digit1;
            }
        }else if(i==8) {
            if (digit2 == 11) {
                LCD = '0';
            } else {
                LCD = '0' + digit2;
            }
        }
        else
            LCD = msg[i];
        WrCHAR();
    }
}
void WriteMSG_Amount(char msg[]){
    unsigned char i;
    for(i = 0; i <= 16; i++){
        if(i==6) {
            LCD = '$';
        }else if(i==7) {
            LCD = '0' + amount/10;
        }else if(i==8)
            LCD = '0' + amount%10;
        else
            LCD = msg[i];
        WrCHAR();
    }
}

void Line1(){
    LCD = 0x00;
    WrCMD();
}
void Line2(){
    LCD = 0xC0;
    WrCMD();
}
void WrCMD(){
    RS = 0;
    EN = 1;
    delayMs0(5);
    EN = 0;
    delayMs0(5);
}
void WrCHAR(){
    RS = 1;
    EN = 1;
    delayMs0(5);
    EN = 0;
    delayMs0(5);
}
void routine1_MSG(){
    msg_CLEANER();
    ConfigLCD();
    Line1();
}
void msg_CLEANER(){
    LCD = 0x01;
    WrCMD();
}
void msg_Start(){
    routine1_MSG();
    WriteMSG(" Insert product ");
    Line2();
    WriteMSG("     code :)    ");
}
void msg_InsertCode2(){
    routine1_MSG();
    WriteMSG("   Second code  ");
    Line2();
    WriteMSG_DIGIT1(empty);
}
void msg_CanceledByUsr(){
    routine1_MSG();
    WriteMSG("    Canceled    ");
    Line2();
    WriteMSG("  By custumer   ");
}
void msg_Code2Required(){
    routine1_MSG();
    WriteMSG("  Second code!  ");
    Line2();
    WriteMSG("    # Denied!   ");
}
void msg_Code2Insert(){
    routine1_MSG();
    WriteMSG("  Product code: ");
    Line2();
    WriteMSG_DIGIT2(empty);
}
void msg_IllegalCode(){
    routine1_MSG();
    WriteMSG("Illegal Operatio");
    Line2();
    WriteMSG(" Code not exist ");
}
void msg_TimeOut_Code2_WTMoney(){
    routine1_MSG();
    WriteMSG(" Time is Over!  ");
    Line2();
    WriteMSG("Vending restarte");
}
void msg_insertMoney(){
    routine1_MSG();
    WriteMSG(" Amount of money");
    Line2();
    WriteMSG_Amount(empty);
}
void msg_ConfirmBuy(){
    routine1_MSG();
    WriteMSG("'#' for Confirm ");
    Line2();
    WriteMSG(" '*' for Cancel ");
}
void msg_dispenseChange(){
    routine1_MSG();
    WriteMSG(" Your change is:");
    Line2();
    WriteMSG_Amount(empty);
}
void msg_timeoutWithMoney(){
    routine1_MSG();
    WriteMSG("  Time is Out!  ");
    Line2();
    WriteMSG(empty);
}
void msg_WorkingOnDispenser(){
    routine1_MSG();
    WriteMSG("   Working on   ");
    Line2();
    WriteMSG("    request!    ");
}
void msg_done(){
    routine1_MSG();
    WriteMSG("      Done      ");
    Line2();
    WriteMSG("    Enjoy! :)   ");
}

void start() {
    digit1 = 77;
    digit2 = 77;
    IE = 0xFF;
    TMOD = 0x11;
    TH0 = 0xFC;
    TL0 = 0x18;
    TH1 = 0xFC;
    TL1 = 0x18;

    price = 0;
    amount = 0;
    moneyIsReady = 0;
    msg_Start();
}
int codeValidation(){
    unsigned int i;
    for(i = 0; i <= MAX_PRODUCT; i++) {
        if (digit12 == codeProduct[i]) {
            dispenser = i;
            price = priceProduct[dispenser];
            return 1;
        }
    }
    return 0;
}
int sumOfMoney(){
    if(!PLUS1 && !PLUS10)
        return 11;
    else if(!PLUS1 && !MINUS10)
        return -9;
    else if(!MINUS1 && !PLUS10)
        return 9;
    else if(!MINUS1 && !MINUS10)
        return -11;
    else if(!PLUS1)
        return 1;
    else if(!PLUS10)
        return 10;
    else if(!MINUS1)
        return -1;
    else if(!MINUS10)
        return -10;
    else return 0;
}
void change(){
    amount = amount - price;
}

unsigned int startCode(){
    EX0 = 0; //interrupt of money disabled
    msg_InsertCode2();
    delayMs1(LITTLE_WAIT); //time for read msg
    timer1(TIMER_WAIT);
    while(timer1end){
        digit2 = scanKeyboard();
        //10 == '*' | CANCEL
        if (digit2 == 10){
            msg_CanceledByUsr();
            timer1(TIMER_WAIT);
            delayMs1(LITTLE_WAIT); //time for read msg
            return 0; //canceled by user | without money
        }
        //12 == '#' CONFIRM | required digit 2
        if(digit2 == 12){
            msg_Code2Required();
            digit2 = 77;
            timer1(TIMER_WAIT);
            //digit 2 is a number
        }if (digit2 != 77) {
            digit12 = digit1 * 10 + digit2;
            msg_Code2Insert();
            delayMs1(LITTLE_WAIT); //time for read msg
            if (codeValidation()) {
                return 1; //digit 1 ok, digit2 ok | without money
            } else {
                msg_IllegalCode();
                timer1(TIMER_WAIT);
                delayMs1(LITTLE_WAIT); //time for read msg
                return 0; //canceled | illegal code
            }
        }
    }
    msg_TimeOut_Code2_WTMoney();
    delayMs1(LITTLE_WAIT); //time for read msg
    return 0; //digit1 ok, digit2 timeout | without money
}

unsigned int giveMeTheMoney(){
    msg_insertMoney();
    delayMs1(LITTLE_WAIT); //time for read msg
    timer1(TIMER_WAIT);
    EX0 = 1; //interrupt of money enable
    while(timer1end){
        if(moneyIsReady) {
            EX0 = 0;
            amount = amount + sumOfMoney();
            msg_insertMoney();
            timer1(TIMER_WAIT);
            moneyIsReady = 0;
            EX0 = 1;
        }
        if (amount >= price){
            EX0 = 0;
            timer1(TIMER_WAIT);
            msg_ConfirmBuy();
            change();
            delayMs1(LITTLE_WAIT);
            timer0(TIMER_WAIT);
            while(timer0end){
                int x = scanKeyboard();
                if(x == 10){
                    msg_CanceledByUsr();
                    delayMs1(LITTLE_WAIT);
                    return 0; //canceled by user | with money
                }
                if(x == 12) {
                    msg_dispenseChange();
                    delayMs1(LITTLE_WAIT);
                    return 1; //confirmed by user
                }
            }
        }
    }
    msg_timeoutWithMoney();
    delayMs1(LITTLE_WAIT);
    return 0; //digit1 ok digit2 ok | money timeout
}
void dispenseProduct() {
    P1 = 0;
    P1_7 = 1;
    convertIntToBinary();
    P1_7 = 0;
    msg_WorkingOnDispenser();
    delayMs1(200);
    P1_7 = 1;
    delayMs1(5000);
    msg_done();
    delayMs1(LITTLE_WAIT);

    MOTOR0 = 0;
    MOTOR1 = 1;
    MOTOR2 = 1;
    MOTOR3 = 1;
    return;
}
void convertIntToBinary(){
    MOTOR0 = (dispenser >> 0) & 1;
    MOTOR1 = (dispenser >> 1) & 1;
    MOTOR2 = (dispenser >> 2) & 1;
    MOTOR3 = (dispenser >> 3) & 1;
}

//Wait until MICRO delay ends
void Delay5us(){
    unsigned char i;
    for(i = 0; i < 5; i++){}
}
//Wait until delay ends
void delayMs0(unsigned int ms){          //use timer0 Mode01 (16 bits)
    timer0(ms);
    while(timer0end){}
}
//Wait until delay ends
void delayMs1(unsigned int ms){          //use timer1 Mode01 (16 bits)
    timer1(ms);
    while(timer1end){}
}
//like set an alarm
void timer0(unsigned int ms){            //use timer0 Mode01 (16 bits)
    timer0end = ms;
    TH0 = 0xFC;				//1 ms @ f = 12 MHz (i.e. 64535) on Mode01
    TL0 = 0x18;
    TF0 = 0;
    TR0 = 1;
}
//like set an alarm
void timer1(unsigned int ms){            //use timer0 Mode01 (16 bits)
    timer1end = ms;
    TH1 = 0xFC;				//1 ms @ f = 12 MHz (i.e. 64535) on Mode01
    TL1 = 0x18;
    TR1 = 1;
    TF1 = 0;
}
//interruptions

void ISR_External0(void) interrupt 0{
    //EX0 = 0;
    moneyIsReady = 1;
    return;
}
void ISR_Timer0(void) interrupt 1{
    TF0 = 0;
    TH0 = 0xFC;				//1 ms @ f = 12 MHz (i.e. 64535) on Mode01
    TL0 = 0x18;
    timer0end = timer0end-1;
    if(!timer0end)
        TR0 = 0;
    return;
}
void ISR_Timer1(void) interrupt 3{
    TF1 = 0;
    TH1 = 0xFC;				//1 ms @ f = 12 MHz (i.e. 64535) on Mode01
    TL1 = 0x18;
    timer1end--;
    if(!timer1end)
        TR1 = 0;
    return;
}

