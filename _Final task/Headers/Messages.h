//
// Created by Adriel on 01/10/2023.
//

#ifndef MESSAGES_H
#define MESSAGES_H

#include "defines.h"

void msg_Start();
void msg_InsertCode2();
void msg_CanceledByUsr();
void msg_Code2Required();
void msg_Code2Insert();
void msg_IllegalCode();
void msg_TimeOut_Code2_WTMoney();
void msg_insertMoney();
void msg_ConfirmBuy();
//void msg_CanceledByUsr_money();
void msg_dispenseProduct();
void msg_timeoutWithMoney();
void msg_WorkingOnDispenser();
void msg_done();
void WriteMSG_DIGIT2(char msg[]);
void WriteMSG_DIGIT1(char msg[]);
//void WriteMSG_Amount(char msg[]);

#endif
