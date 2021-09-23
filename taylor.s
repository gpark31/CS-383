
/*
 * taylorSeries.s
 *
 *  Created on: Nov 26, 2020
 *      Author: GaYoung Park
 *		I pledge my honor that I have abided by the Stevens Honor System.
 */

	.text
	.global main
	.extern printf
main:
	SUB sp, sp, #96
	STR x30, [sp]

	// load inputs into stack
	LDR x2, =x     //double saved in x2
	LDR d2, [x2]   //d2 is going to be x
	LDR x1, =i     //x3 = i
	LDR x4, [x1]   //x4 has i value

	MOV x19, #1
	MOV x20, #0
	MOV x3, #0
	MOV x0, #1 //x0 is going to be n!
	MOV x6, #0

	SCVTF d4, x19
	SCVTF d19, x20
	SCVTF d1, x19 //d1 is going to be 1/n!
	SCVTF d3, x19 //d3 is going to be x^n
	SCVTF d0, x20 //d0 is going to be the sum

	STR d2, [sp, #8]
	STR d1, [sp, #16]
	STR d0, [sp, #24]
	STR x4, [sp, #32]
	STR x5, [sp, #40]
	STR x3, [sp, #48]
	STR x0, [sp, #56]
	STR d3, [sp, #64]
	STR d4, [sp, #72]
	STR x6, [sp, #80]
	B Loop
	BR x30

printfunc:
	MOV x20, #0
	SCVTF d19, x20
	FADD d0, d0, d19
	LDR x0, =print 	//print
	BL printf
	LDR x30, [sp]
	LDR d2, [sp, #8]
	LDR d1, [sp, #16]
	LDR d0, [sp, #24]
	LDR x4, [sp, #32]
	LDR x5, [sp, #40]
	LDR x3, [sp, #48]
	LDR x0, [sp, #56]
	LDR d3, [sp, #64]
	LDR d4, [sp, #72]
	LDR x6, [sp, #80]
	ADD sp, sp, #96
	BR x30

Loop:
	//calculating n!
	CMP x3, x6
	BEQ SUM
	ADD x3, x3, #1
	MUL x0, x0, x3  //calculating n!
	FMUL d3, d3, d2
	STR d3, [sp, #64]
	STR x0, [sp, #56]
	B Loop



SUM:
	//calculate 1/n!
	MOV x19, #1
	SCVTF d20, x0
	SCVTF d19, x19
	FDIV d1, d19, d20
	//calculate 1th term
	FMUL d4, d1, d3 //ith term
	//calculate sum
	FADD d0, d0, d4  //sum
	ADD x6, x6, #1

	MOV x0, #1
	MOV x3, #0
	SCVTF d3, x19
	SCVTF d1, x19
	MOV x0, x19
	SCVTF d4, x19

	STR d1, [sp, #16]
	STR d4, [sp, #72]
	STR d0, [sp, #24]
	STR x6, [sp, #80]
	STR x0, [sp, #56]
	STR x3, [sp, #48]
	STR d1, [sp, #16]
	STR d0, [sp, #24]
	STR d3, [sp, #64]

	CMP x6, x4
	BEQ printfunc
	B Loop

.data
	i:
		.quad 3
	x:
		.double 2.4


print:
	.ascii "The approximation is %f\n\0"
	.end
