// John Barckley


        .syntax     unified
        .cpu        cortex-m4
        .text

/*
void Hanoi(int num, int fm, int to, int aux) ;
{
    if (num > 1) Hanoi(num - 1, fm, aux, to) ;
    Move1Disk(fm, to) ;
    if (num > 1) Hanoi(num - 1, aux, to, fm) ;
}
*/

.global Hanoi
.thumb_func
.align

// R0 = num, R1 = fm, R2 = to, R3 = aux
Hanoi:
        PUSH {R0-R7, LR}
        CMP R0, 1
        BLE NumisOne  // if condition is not met, branch past body of IF
        MOV R4, R3 // R4 = R3 = aux
        MOV R3, R2 // R3 = R2 = to
        MOV R2, R4 // R2 = R4 = aux
        ADD R0, R0, -1 // R0 = R0 - 1 = num - 1
        BL Hanoi
        ADD R0, R0, 1 // R0 = R0 + 1 = num - 1 + 1 = num
        // Revert registers to values passed at start of function
        MOV R4, R3 // R4 = R3 = to
        MOV R3, R2 // R3 = R2 = aux
        MOV R2, R4 // R2 = R4 = to
NumisOne:
        MOV R4, R0 // R4 = R0 = num
        MOV R0, R1 // R0 = R1 = fm
        MOV R5, R1 // R5 = R1 = fm
        MOV R1, R2 // R1 = R2 = to
        PUSH {R0-R5}
        BL Move1Disk  // R0 = fm, R1 = to
        POP {R0-R5}
        MOV R0, R4 // R0 = R4 = num
        MOV R1, R5 // R1 = R5 = fm  (R2 = to at this point as well)
        CMP R0, 1
        BLE End   // if condition is not met, branch past body of IF
        MOV R4, R1 // R4 = R1 = fm
        MOV R1, R3 // R1 = R3 = aux
        MOV R3, R4 // R3 = R4 = fm
        ADD R0, R0, -1 // R0 = R0 - 1 = num - 1
        BL Hanoi
        ADD R0, R0, 1 // R0 = R0 + 1 = num - 1 + 1 = num
        // Revert registers to values passed at start of function
        MOV R4, R3 // R4 = R3 = fm
        MOV R3, R1 // R3 = R1 = aux
        MOV R1, R4 // R1 = R4 = fm
        // I feel like I'm playing the tower of hanoi trying to move all of these registers x.x
End:
        POP {R0-R7, LR}
        BX LR