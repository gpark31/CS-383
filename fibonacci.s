/*
 * fibonacci.s
 *
 *  Created on: Oct 21, 2020
 *      Author: GaYoung Park
 */
  .text
  .global main
  .extern printf
main:
	MOV X1, #number
	MOV X3, #0 //store 0 in x3 = fib_previous
	MOV X4, #1 //store 1 in X4 = fib_current
	BL fibonacci  //call fibonacci
	BR X30    //returns to caller
fibonacci:
	SUB SP,SP,#32
	STR X30,[SP, #24]	//store the return address//
	STR X3,[SP, #16]	//store x3 , fibprevious
	STR X4, [SP, #8] //store x4, fibcurrent
	STR X1, [SP, #0]  //store n
	SUBS X11,X1,#1	//Test for n=1 by setting the flag 0=X0-1//
	CBNZ X11, L1	//if n!=1 branch to L1//
	ADD X1, X4, xzr //fibcurrent to X1
	LDR X0, =string 	//return fibcurrent
	BL printf   //print the value of fibonacci
	ADD SP,SP,#32	//Re-store stack pointer//
	BR X30		//Exit to caller//

L1:
	SUB X1,X1,#1	//n=n-1
	ADD X5, X3, X4   //next_number = fib_prev + fib_current
	ADD X3, X4, xzr  // fib_prev = fib_current
	ADD X4, X5, xzr   //fib_current = next_number
	BL fibonacci    //call fibonacci
	LDR X1, [SP, #0] //restore n
	LDR X4,[SP,#8]	//restore current
	LDR X3,[SP,#16]	//Restore fib_prev
	LDR X30, [SP, #24] //restore return address
	ADD SP,SP,#32	//clear stack frames//
	BR X30		//return to caller//

.data
  .equ number, 5

string:
	.ascii "Output is: %d\n\0"
	.end


