// John Barckley


        .syntax     unified
        .cpu        cortex-m4
        .text


// UseLDRB(void *dst, void *src)
// R0 = *dst, R1 = *src
.global UseLDRB
.thumb_func
.align

UseLDRB:
        .rept 512
        LDRB R3, [R1], 1  // R3 = R1[x]
        STRB R3, [R0], 1  // R0[x] = R3  (post increment means on first instance x = 0)
        .endr

        BX LR


// UseLDRH(void *dst, void *src)
// R0 = *dst, R1 = *src
.global UseLDRH
.thumb_func
.align

UseLDRH:
        .rept 256  // 512 / 2
        LDRH R3, [R1], 2  // use 2 since 16 bits = 2 bytes
        STRH R3, [R0], 2
        .endr

        BX LR


// UseLDR(void *dst, void *src)
// R0 = *dst, R1 = *src
.global UseLDR
.thumb_func
.align

UseLDR:
        .rept 128  // 512 / 4
        LDR R3, [R1], 4  // use 4 since 32 bits = 4 bytes
        STR R3, [R0], 4
        .endr

        BX LR


// UseLDRD(void *dst, void *src)
// R0 = *dst, R1 = *src
.global UseLDRD
.thumb_func
.align

UseLDRD:
        .rept 64  // 512 / 8
        LDRD R3, R2, [R1], 8  // use 8 since 64 bits = 8 bytes
        STRD R3, R2, [R0], 8
        .endr

        BX LR


// UseLDM(void *dst, void *src)
// R0 = *dst, R1 = *src
.global UseLDM
.thumb_func
.align

UseLDM:
        PUSH {R4-R11}  // keep R4-R11 in case outside program uses them
        .rept 11  // each register is 4 bytes, and 12 - 2 + 1 = 11 so each .rept copies 44 bytes. 11*44 < 512 < 12*44
        LDMIA R1!, {R2-R12}
        STMIA R0!, {R2-R12}
        .endr

        LDMIA R1, {R2-R8} // copy remaining 7*4 bytes
        STMIA R0, {R2-R8}

        POP {R4-R11}
        BX LR