    .syntax unified
    .cpu cortex-m4
    .thumb

/* ---------------------------------------------------------
   Vector table @ 0x08000000
   --------------------------------------------------------- */
    .section .isr_vector,"a",%progbits
    .word   _estack             /* initial stack pointer */
    .word   Reset_Handler       /* reset handler */
    .word   NMI_Handler
    .word   HardFault_Handler
    .word   0,0,0,0,0,0,0       /* reserved */
    .word   SVC_Handler
    .word   0,0
    .word   PendSV_Handler
    .word   SysTick_Handler

/* ---------------------------------------------------------
   Default weak handlers
   --------------------------------------------------------- */
    .section .text.Default_Handler,"ax",%progbits
Default_Handler:
    b .

    .weak NMI_Handler
    .thumb_set NMI_Handler, Default_Handler

    .weak HardFault_Handler
    .thumb_set HardFault_Handler, Default_Handler

    .weak SVC_Handler
    .thumb_set SVC_Handler, Default_Handler

    .weak PendSV_Handler
    .thumb_set PendSV_Handler, Default_Handler

    .weak SysTick_Handler
    .thumb_set SysTick_Handler, Default_Handler

/* ---------------------------------------------------------
   Reset_Handler
   --------------------------------------------------------- */
    .section .text.Reset_Handler,"ax",%progbits
    .global Reset_Handler
Reset_Handler:
    /* Copy .data from Flash to RAM */
    ldr r0, =_sdata
    ldr r1, =_edata
    ldr r2, =_etext
1:  cmp r0, r1
    ittt lt
    ldrlt r3, [r2], #4
    strlt r3, [r0], #4
    blt 1b

    /* Zero .bss */
    ldr r0, =_sbss
    ldr r1, =_ebss
    movs r2, #0
2:  cmp r0, r1
    itt lt
    strlt r2, [r0], #4
    blt 2b

    /* Call main() */
    bl main

    /* If main exits, loop forever */
    b .
