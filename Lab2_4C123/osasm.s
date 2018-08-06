;/*****************************************************************************/
; OSasm.s: low-level OS commands, written in assembly                       */
; Runs on LM4F120/TM4C123/MSP432
; Lab 2 starter file
; February 10, 2016
;


        AREA |.text|, CODE, READONLY, ALIGN=2
        THUMB
        REQUIRE8
        PRESERVE8

        EXTERN  RunPt            ; currently running thread
        EXPORT  StartOS
        EXPORT  SysTick_Handler
        IMPORT  Scheduler


SysTick_Handler                ; 1) Saves R0-R3,R12,LR,PC,PSR
    CPSID   I                  ; 2) Prevent interrupt during switch

    CPSIE   I                  ; 9) tasks run with interrupts enabled
    BX      LR                 ; 10) restore R0-R3,R12,LR,PC,PSR

StartOS
	;Get the context of first thread on to the processor
	LDR R0, =RunPt
	LDR R1, [R0]			   ; Get the contents of the Run pointer in R1
    LDR SP, [R1]			   ; Stack pointer is updated for the thread
	POP {R4-R11}			   ; Pop R4-R11
	POP {R0-R3}				   ; Pop R0-R3
	POP {R12}				   ; Pop R12
	ADD SP,#4				   ; LR on the stack is not of use for the first thread so discard it
	POP {LR}				   ; PC of the stack will stored in LR as after the subroutine this will become the PC
	ADD SP,#4				   ; Discard the PSR as it is not correct
	CPSIE   I                  ; Enable interrupts at processor level
    BX      LR                 ; start first thread

    ALIGN
    END
