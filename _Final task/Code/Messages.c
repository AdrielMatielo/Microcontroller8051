//
// Created by Adriel on 01/10/2023.
//

#include "../Headers/Messages.h"
#include "../Headers/defines.h"

void msg_Start(){
    routine1_MSG();
    WriteMSG(" Insert product ");
    Line2();
    WriteMSG("    code :)     ");
}
void msg_InsertCode2(){
    routine1_MSG();
    WriteMSG("   Second code  ");
    Line2();
    WriteMSG_DIGIT1("                ");
}
void msg_CanceledByUsr(){
    routine1_MSG();
    WriteMSG("    Canceled    ");
    Line2();
    WriteMSG("  By custumer   ");
}
void msg_Code2Required(){
    routine1_MSG();
    WriteMSG("   Second code! ");
    Line2();
    WriteMSG("    # Denied!   ");
}
void msg_Code2Insert(){
    routine1_MSG();
    WriteMSG("  Product code: ");
    Line2();
    WriteMSG_DIGIT2("                ");
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
    WriteMSG("      $**       ");
}
void msg_ConfirmBuy(){
    routine1_MSG();
    WriteMSG("'#' for Confirm ");
    Line2();
    WriteMSG(" '*' for Cancel ");
}
void msg_dispenseProduct(){
    routine1_MSG();
    WriteMSG("   Thank you  ");
    Line2();
    WriteMSG("    =>.<=     ");
}
void msg_timeoutWithMoney(){
    routine1_MSG();
    WriteMSG("  Time is Out!  ");
    Line2();
    WriteMSG("       :(       ");
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