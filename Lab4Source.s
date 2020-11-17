// John Barckley


        .syntax     unified
        .cpu        cortex-m4
        .text

// 𝐷𝑖𝑠𝑐𝑟𝑖𝑚𝑖𝑛𝑎𝑛𝑡(𝑎, 𝑏, 𝑐) = 𝑏^2 - 4ac
// R0 = a, R1 = b, R2 = c
.global Discriminant
.thumb_func
.align

Discriminant:
        PUSH    {R1, R2}  // I debugged and found this necessary or else b^2 would be passed into R1 when this returns
        MUL     R1, R1, R1  // R1 = R1^2
        LSL     R2, R2, 2   // R2 = 4 * R2
        MLS     R0, R0, R2, R1  // R0 = R1 - R2 * R0 = b^2 - 4ac
        POP     {R1, R2}
        BX      LR


// Root1(a, b, c) = -b + sqrt(Discriminant(a, b, c)) / 2a
// R0 = a, R1 = b, R2 = c
.global Root1
.thumb_func
.align

Root1:
        PUSH    {LR, R4}
        MOV     R4, R0        // R4 = R0
        BL      Discriminant  // R0 = Discriminant(a, b, c)
        BL      SquareRoot    // R0 = SquareRoot(Discriminant(a, b, c))
        LDR     R3, =-1
        MUL     R1, R3, R1   // R1 = R1 * -1
        ADD     R2, R0, R1   // R2 = R1 + R0 = -b + sqrt(discrim(a, b, c))
        LDR     R3, =2
        MUL     R4, R3, R4   // R4 = 2 * R4 = 2 * a (R4 = R0)
        SDIV    R0, R2, R4   // R0 = R2 / R4 = -b + sqrt(discrim(a, b, c)) / 2a

        POP     {R4, PC}



// Root2(a, b, c) = -b + sqrt(discriminant(a, b, c)) / 2a
// R0 = a, R1 = b, R2 = c
.global Root2
.thumb_func
.align

Root2:
        PUSH    {LR, R4}
        MOV     R4, R0        // R4 = R0
        BL      Discriminant  // R0 = Discriminant(a, b, c)
        BL      SquareRoot    // R0 = SquareRoot(Discriminant(a, b, c))
        MOV     R3, -1
        MUL     R1, R1, R3   // R1 = R1 * -1
        SUB     R2, R1, R0   // R2 = R1 + R0 = -b - sqrt(discrim(a, b, c))   * Only difference from Root1 *
        MOV     R3, 2
        MUL     R4, R3, R4   // R4 = 2 * R4 = 2 * a
        SDIV    R0, R2, R4   // R0 = R2 / R0 = -b - sqrt(discrim(a, b, c)) / 2a
        POP     {R4, PC}


// Quadratic(x, a, b, c) = ax^2 + bx + c
// R0 = x, R1 = a, R2 = b, R3 = c
.global Quadratic
.thumb_func
.align

Quadratic:
        PUSH    {R4}
        MOV     R4, R0  // R4 = R0 = x
        MUL     R0, R0, R0  // R0 = R0 * R0 = x^2
        MUL     R0, R0, R1  // R1 = R0 * R1 = ax^2
        MUL     R2, R4, R2  // R2 = R3 * R2 = bx
        ADD     R3, R3, R2  // R3 = R3 + R2 = c + bx
        ADD     R0, R0, R3  // R0 = R3 + R0 = ax^2 + bx + c
        // I feel like there should be a simpler call than this mess, but oh well--it works.
        POP     {R4}
        BX      LR
