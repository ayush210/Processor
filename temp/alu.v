module alu(operand1,operand2,alu_select,z4_input);
input[31:0] operand1,operand2;
input[5:0] alu_select;
output[31:0] z4_input;
reg signed [31:0] z4_input;
always @(*)
				begin
				case(alu_select)
				0:	z4_input = operand1 + operand2;	//add
1:	z4_input = operand1 - operand2;	//sub
2:	z4_input = operand1 & operand2;	//and	
3:	z4_input = operand1|operand2; //or
4:	z4_input = operand1^operand2;	//xor
5:	begin//slt
if($signed(operand1)<$signed(operand2))
				z4_input = 1;
						else 
								z4_input = 0;
										end
												6:	begin
												if(operand1<operand2)
				z4_input =	1;
						else
								z4_input = 0;//sltu
										end
												7:	z4_input = operand1>>>operand2[4:0];//sra
8:	z4_input = operand1>>operand2[4:0];	//srl
9:	z4_input = operand1<<operand2[4:0];//sll
10:	z4_input = operand1 * operand2 ;	//mul
11:	z4_input = operand1 + operand2 ;	//addi
12:	z4_input = operand1 - operand2 ;	//subi
13:	z4_input = operand1 & operand2 ;	//andi
14:	z4_input = operand1 | operand2 ;	//ori
15:	z4_input = operand1 ^ operand2 ;	//xori
16:	z4_input = 	operand1 << operand2 ;//	slti
17:	begin
if(operand1<operand2)
				z4_input =	1;
						else
								z4_input = 0;//sltu
										end
												18:	z4_input = 	operand1>>>operand2;//srai
19:	z4_input = 	operand1>>operand2; //srli
20:	z4_input = 	operand1<<operand2;//slli
21:	z4_input = 	operand2;//lui
22:	z4_input = 	operand1 + operand2;//auipc
23:	z4_input = 	operand1 + operand2 ;//lw
24:	z4_input = 	operand1 + operand2;//sw
25:	z4_input = operand1 + operand2;	//jr
26:	z4_input = 	operand1 + operand2;//jalr
27:	z4_input = 	operand1 + operand2;//jal
28:	z4_input = operand1 - operand2 ;//beq
29:	z4_input = 	operand1 - operand2 ;//bne
30:	z4_input = 	operand1 - operand2 ;//blt
31:	z4_input = 	operand1 - operand2 ;//bge
32:	z4_input = 	operand1 - operand2 ;//bltu
33:	z4_input = 	operand1 - operand2 ;//bgeu
default:z4_input<=operand1 + operand2;
endcase
end
endmodule
