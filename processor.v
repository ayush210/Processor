//module for complete processor testbench
module processor(clk,reset,pc,instruction);
input[31:0] instruction;
output[31:0] pc;
wire data_write_signal; //data memory write enable
reg instruction_reset; //reset for instruction memory
input clk,reset;
wire clk,reset;
reg write_signal; //write signal for instruction memory
reg[31:0] instruction_write; //instruction to be written to instruction memory
reg[31:0] write_address; //write address for instruction memory
wire[31:0] z4_input,instruction,pc,branchaddress,z4_output;  
wire[1:0] select_pc,select_ir2; //select line for pc and ir2 mux
wire select_pc2;  //select line for pc2
wire[31:0] ir2_input,pc2_input,ir2_output,pc2_output; 
wire[31:0] r1_value,r2_value; //value read from register file
wire[31:0] ir3_output,pc3_output,x3_output,y3_output,md3_output,ir3_input,pc3_input,x3_input,y3_input,md3_input,branchaddress_input; 
wire[1:0] select_ir3,select_x3,select_y3,select_md3; //select lines 
wire select_pc3;  //select line for pc3
wire[31:0] ir4_output,pc4_output,md4_output;
wire[31:0] ir4_input,pc4_input,md4_input;
wire select_ir4,select_pc4z4; //select lines 
wire[1:0] select_operand1,select_operand2,select_md4; 
wire[31:0] ir5_input,z5_input,z5_output,ir5_output;  
wire[31:0] read_data,write_data; //data read to be written to data memory 
wire[1:0] select_z5;	
wire select_writedata;
wire reg_write_enable; //enable for writing to register file
wire branch_control_output; //branch enable for branch has to be taken or not
wire[31:0] branchaddress3_input,branchaddress3_output; //branch address from output of 2nd stage
wire[5:0] alu_select_input,alu_select_output; //select line for alu 
wire branch_control_input;

//1st stage instantiated
fetch_stage fetch(.z4(z4_output),.clk(clk),.reset(reset),.select_pc(select_pc),.select_ir2(select_ir2),.select_pc2(select_pc2),.instruction(instruction),.pc(pc),.branchaddress(branchaddress),.ir2_input(ir2_input),.pc2_input(pc2_input),.ir2_output(ir2_output),.pc2_output(pc2_output));

//instruction_memory instantiated
//instruction_memory ins(.clk(clk),.pc(pc),.instruction(instruction),.instruction_reset(instruction_reset),.write_signal(write_signal),.instruction_write(instruction_write),.write_address(write_address));

//instruction_memory ins(.clk(clk),.pc(pc),.instruction(instruction));

//dff for intermediate pipeline registers from fetch stage
dff ir2(.in(ir2_input),.clk(clk),.out(ir2_output),.reset(reset));
dff pc2(.in(pc2_input),.clk(clk),.out(pc2_output),.reset(reset));

//2nd stage instantiated
decode_stage decode(.ir2_output(ir2_output),.pc2_output(pc2_output),.clk(clk),.r1_value(r1_value),.r2_value(r2_value),.z5_output(z5_output),.reset(reset),.ir3_output(ir3_output),.pc3_output(pc3_output),.x3_output(x3_output),.y3_output(y3_output),.md3_output(md3_output),.ir3_input(ir3_input),.pc3_input(pc3_input),.x3_input(x3_input),.y3_input(y3_input),.md3_input(md3_input),.branchaddress_input(branchaddress3_input),.select_ir3(select_ir3),.select_pc3(select_pc3),.select_x3(select_x3),.select_y3(select_y3),.select_md3(select_md3),.alu_select_input(alu_select_input));

//dff for intermediate pipeline registers from decode stage
dff ir3(.in(ir3_input),.clk(clk),.out(ir3_output),.reset(reset));
dff pc3(.in(pc3_input),.clk(clk),.out(pc3_output),.reset(reset));
dff x3(.in(x3_input),.clk(clk),.out(x3_output),.reset(reset));
dff y3(.in(y3_input),.clk(clk),.out(y3_output),.reset(reset));
dff branchadd(.in(branchaddress3_input),.clk(clk),.out(branchaddress3_output),.reset(reset));
dff md3(.in(md3_input),.clk(clk),.out(md3_output),.reset(reset));
dff2 aluselect(.in(alu_select_input),.clk(clk),.out(alu_select_output),.reset(reset));

//3rd stage instantiated 
execute_stage execute(.ir3_output(ir3_output),.pc3_output(pc3_output),.x3_output(x3_output),.y3_output(y3_output),.md3_output(md3_output),.pc4_output(pc4_output),.z4_output(z4_output),.z5_output(z5_output),.select_ir4(select_ir4),.select_pc4z4(select_pc4z4),.select_operand1(select_operand1),.select_operand2(select_operand2),.select_md4(select_md4),.clk(clk),.reset(reset),.ir4_input(ir4_input),.pc4_input(pc4_input),.z4_input(z4_input),.md4_input(md4_input),.alu_select_output(alu_select_output),.branch_control_input(branch_control_input));

//dff for intermediate pipeline registers from execute stage
dff ir4(.in(ir4_input),.clk(clk),.out(ir4_output),.reset(reset));
dff pc4(.in(pc4_input),.clk(clk),.out(pc4_output),.reset(reset));
dff z4(.in(z4_input),.clk(clk),.out(z4_output),.reset(reset));
dff md4(.in(md4_input),.clk(clk),.out(md4_output),.reset(reset));
dff branch4(.in(branchaddress3_output),.clk(clk),.out(branchaddress),.reset(reset));
dff3 controlbranch(.in(branch_control_input),.clk(clk),.out(branch_control_output),.reset(reset));

//4th stage instantiated
memory_stage mem(.ir4_output(ir4_output),.pc4_output(pc4_output),.z4_output(z4_output),.md4_output(md4_output),.z5_output(z5_output),.read_data(read_data),.write_data(write_data),.select_z5(select_z5),.select_writedata(select_writedata),.ir5_input(ir5_input),.z5_input(z5_input));

//dff for intermediate pipeline registers from 4th stage
dff ir5(.in(ir5_input),.clk(clk),.out(ir5_output),.reset(reset));
dff z5(.in(z5_input),.clk(clk),.out(z5_output),.reset(reset));

//data memory instantiated
datamemory data(.clk(clk),.reset(reset),.address(z4_input),.write_data(write_data),.read_data(read_data),.write_signal(data_write_signal));

regfile registers(.r1_add(ir2_input[19:15]),.r2_add(ir2_input[24:20]),.write_add(ir5_output[11:7]),.z5_output(z5_output),.write_enable(reg_write_enable),.clk(clk),.reset(reset),.r1_value(r1_value),.r2_value(r2_value));

//control module instantiation:1

control control_part(.reset(reset),.ir2_output(ir2_output),.ir3_output(ir3_output),.ir4_output(ir4_output),.ir5_output(ir5_output),.select_pc(select_pc),.select_pc2(select_pc2),.select_ir2(select_ir2),.select_ir3(select_ir3),.select_ir4(select_ir4),.select_pc3(select_pc3),.select_x3(select_x3),.select_y3(select_y3),.select_md3(select_md3),.select_operand1(select_operand1),.select_operand2(select_operand2),.select_md4(select_md4),.select_datawrite(select_datawrite),.select_z5(select_z5),.reg_write_enable(reg_write_enable),.data_write_signal(data_write_signal),.branch_control_output(branch_control_output));
		//assign select_pc = 1;
		//assign select_ir2 = 0;
		//assign select_pc2 = 0;
		//assign select_ir3 = 0;
		//assign select_pc3 = 0;
		//assign select_x3 = 0;
		//assign select_y3 = 0;
		//assign select_md3 = 0;
		//assign r1_value = 5;
		//assign r2_value = 6;
		//assign select_ir4 = 0;
		//assign select_pc4z4 = 0;
		//assign select_operand1 = 0;
		//assign select_operand2 = 0;
		//assign select_md4 = 0;

/*initial 
	begin
//$monitor("%d",instruction);
	//$monitor("%d %d %d %d %d",ir2_output,ir3_output,ir4_output,ir5_output,pc);
	//	$monitor($time,"%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d",ir2_output,ir3_output,ir4_output,ir5_output,data_write_signal,branch_control_output,pc,branchaddress,select_pc,select_ir2,select_ir3,z4_output,select_operand1,select_operand2,select_datawrite);
$monitor("%b %d %d %d %d %d %d",z5_output,r1_value,r2_value,x3_output,y3_output,select_x3,select_y3);
	//$monitor("%d %d %d",select_pc,select_ir2,select_pc2);
//	$monitor("%d %d %d %d",select_x3,select_y3,select_md3,select_pc3);
//$monitor("%d %d %d",select_operand1,select_operand2,select_md4);
//$monitor("%d",reg_write_enable);
//	$monitor("%d %d",select_z5,data_write_signal);
//$monitor("%d",select_operand1);
	//$monitor("%b %d %d %d %b %b %d %d %d %d %d ",z5_output,branch_control_output,pc,z4_input,ir3_output,ir4_output,x3_output,y3_output,ir2_input[19:15],ir2_input[24:20],select_ir3);
//$monitor("%d %b",pc,ir2_output);
//$monitor("%d",select_ir3);
//$monitor("%b %d",z5_output,reg_write_enable);
	clk = 0; reset = 1;
		reset = 1;clk = 0;write_signal = 1;instruction_reset = 1;
		#5
//#10 instruction_write=32'b00000000000000000001000010110111;write_address = 0;instruction_reset = 0; //lui 
//		#10 instruction_write[31:0]={{11{1'b0}},1'b1,{2{1'b0}},1'b1,{3{1'b0}},1'b1,{4{1'b0}},{2{1'b1}},{5{1'b0}},{2{1'b1}}};write_address = 0;instruction_reset = 0; //lw r' imm(rs1) 
//#10 instruction_write = {{6{1'b0}},1'b1,{4{1'b0}},1'b1,{3{1'b0}},1'b0,{8{1'b0}},{3{1'b1}},{3{1'b0}},{2{1'b1}}};write_address = 0;instruction_reset = 0; //branch_condition beq
//#10 instruction_write = {{20'b1},{4{1'b0}},1'b1,{2{1'b1}},1'b0,{4{1'b1}}};write_address = 0;instruction_reset= 0; //jal
//#10 instruction_write = {{6'b0},1'b1,{4'b0},1'b1,{3'b0},1'b1,{2'b0},1'b1,{5'b0},1'b1,1'b0,1'b1,{3'b0},{2'b11}};instruction_reset = 0;write_address = 0; //sw
//#10 instruction_write = {{12'b1},5'b00001,3'b000,5'b00010,7'b0010011}; instruction_reset =0;write_address = 0; //addi
//#10 instruction_write = {{20'b1},5'b00001,7'b0110111}; instruction_reset = 0;write_address = 0;//lui
//#10 instruction_write = {{20'b1},5'b00001,7'b0010111}; instruction_reset = 0;write_address = 0; //auipc
//#10 instruction_write = {7'b0100000,5'b00001,5'b00010,3'b000,5'b00011,7'b0110011};instruction_reset=0;write_address = 0;//add
/*#10 instruction_write = {{12'b1},5'b00001,3'b010,5'b00010,7'b0000011};instruction_reset =0 ;write_address =0;  // lw and jalr 
#10 instruction_write = {{12'b1},5'b00010,3'b000,5'b00011,7'b1100111};write_address = 1;*/
/*#10 instruction_write = {{12'b1},5'b00001,3'b010,5'b00010,7'b0000011};instruction_reset =0;write_address = 0; //lw and jr
#10	instruction_write = {{12'b0},5'b00010,{3'b0},{5'b0},7'b1100111}; write_address = 1;*/
/*#10 instruction_write = {{7'b1},5'b00010,5'b00011,3'b010,{5'b1},7'b0100011};instruction_reset = 0;write_address = 0; //sw and add
#10 instruction_write = {7'b0100000,5'b00010,5'b00011,3'b000,5'b00100,7'b0110011};write_address = 1;*/
/*#10 instruction_write = {7'b0100000,5'b00010,5'b00011,3'b000,5'b00100,7'b0110011};instruction_reset = 0;write_address = 0; //add add forward
#10 instruction_write = {7'b0000000,5'b00100,5'b01000,3'b000,5'b01001,7'b0110011};write_address = 1;*/ //forward from z4
/*#10 instruction_write = {{12'b1},5'b00001,3'b010,5'b00010,7'b0000011};instruction_reset = 0;write_address = 0;//lw and sw
#10 instruction_write ={{7'b1},5'b00010,5'b00100,3'b010,{5'b1},7'b0100011};write_address = 1;*/
/*#10 instruction_write ={{7'b1},5'b00001,5'b00010,3'b000,5'b00001,7'b1100011}; instruction_reset = 0;write_address = 0;//beq and add
#10 instruction_write = {7'b0100000,5'b00010,5'b00011,3'b000,5'b00100,7'b0110011};write_address = 1;*/
//#10 instruction_write=32'b00000000000000000001000010110111;instruction_reset = 0;write_address=0;
/*#10 instruction_write = 32'b00000000000000000001000010110111;instruction_reset = 0;write_address =0;
#10 instruction_write = 32'b00000000001000001000000100010011;write_address = 1; 
#10 instruction_write = 32'b00000000010000010000000110010011;write_address = 2;
#10 instruction_write = 32'b00000000001000011001001000010011;write_address = 3;
#10 instruction_write = 32'b00000000000000000110001010110111;write_address = 4;
#10 instruction_write = 32'b01000000010000101000001110110011;write_address = 5;*/
//01000000010000101000001110110011
/*#10 instruction_write = 32'b00000000000000000001000010110111;instruction_reset = 0;write_address = 0;
#10 instruction_write = 32'b00000000001000001000000100010011;write_address = 1;
#10 instruction_write = 32'b00000000011000010000000110010011;write_address = 2;
#10 instruction_write = 32'b00000000001000011001001000010011;write_address = 3;
#10 instruction_write = 32'b00000000000000000001001010110111;write_address = 4;
#10 instruction_write = 32'b00000000011000101000001110010011;write_address = 5;
#10 instruction_write = 32'b00000000010000111001010101100011;write_address = 6;
#10 instruction_write = 32'b01000000001100010000000010110011;write_address = 7;
#10 instruction_write =	32'b00000000010000111000010101100011;write_address = 8;*/
//	 #10 write_signal = 0;reset = 0;
		//#10 instruction_write = 0;write_address = 2;
		//#10 instruction_write = 0;write_address = 3;
//#10  reset = 0;
//		#200 $finish;
//	end

endmodule
















