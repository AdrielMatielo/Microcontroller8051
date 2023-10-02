//
// Created by Adriel on 01/10/2023.
//

#include "../Headers/Machine.h"

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

unsigned int startCode(){
    EX0 = 0; //interrupt of money disabled
    msg_InsertCode2();
    delayMs1(LITTLE_WAIT); //time for read msg
    timer1(TIME_WAIT);
    while(timer1end){
        digit2 = scanKeyboard();
        //10 == '*' | CANCEL
        if (digit2 == 10){
            msg_CanceledByUsr();
            timer1(TIME_WAIT);
            delayMs1(LITTLE_WAIT); //time for read msg
            return 0; //canceled by user | without money
        }
        //12 == '#' CONFIRM | required digit 2
        if(digit2 == 12){
            msg_Code2Required();
            digit2 = 77;
            timer1(TIME_WAIT);
            //digit 2 is a number
        }if (digit2 != 77) {
            digit12 = digit1 * 10 + digit2;
            msg_Code2Insert();
            delayMs1(LITTLE_WAIT); //time for read msg
            if (codeValidation()) {
                return 1; //digit 1 ok, digit2 ok | without money
            } else {
                msg_IllegalCode();
                timer1(TIME_WAIT);
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
    timer1(TIME_WAIT);
    EX0 = 1; //interrupt of money enable
    while(timer1end){
        if(moneyIsReady) {
            EX0 = 0;
            amount = amount + sumOfMoney();
            msg_insertMoney();
            timer1(TIME_WAIT);
            moneyIsReady = 0;
            EX0 = 1;
        }
        if (amount >= price){
            EX0 = 0;
            timer1(TIME_WAIT);
            msg_ConfirmBuy();
            delayMs1(LITTLE_WAIT);
            timer0(TIME_WAIT);
            while(timer0end){
                int x = scanKeyboard();
                if(x == 10){
                    msg_CanceledByUsr();
                    delayMs1(LITTLE_WAIT);
                    return 0; //canceled by user | with money
                }
                if(x == 12) {
                    msg_dispenseProduct();
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
}

void convertIntToBinary(){
    MOTOR0 = (dispenser >> 0) & 1;
    MOTOR1 = (dispenser >> 1) & 1;
    MOTOR2 = (dispenser >> 2) & 1;
    MOTOR3 = (dispenser >> 3) & 1;
}




