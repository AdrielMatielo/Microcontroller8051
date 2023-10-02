//
// Created by Adriel on 01/10/2023.
//

#include "../Headers/Keyboard4x3.h"

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
