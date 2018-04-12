module decode_stage(ir2_output,pc2_output,clk,r1_value,r2_value,z5_output,reset,ir3_output,pc3_output,x3_output,y3_output,md3_output,ir3_input,pc3_input,x3_input,y3_input,md3_input,branchaddress_input,select_ir3,select_pc3,select_x3,select_y3,select_md3,alu_select_input);
		
input[31:0] ir3_output,pc3_output,x3_output,y3_output,md3_output; //output of dff of next stage as input for stall
input[31:0] ir2_output,pc2_output,r1_value,r2_value,z5_output;  //input from dff of previous stage
input reset,clk;     
input[1:0] select_ir3,select_x3,select_y3,select_md3; 
input select_pc3;
output[31:0] ir3_input,pc3_input,x3_input,y3_input,md3_input,branchaddress_input;//output of this stage as input for dff of next stage
output[5:0] alu_select_input;  //select line for alu
wire[31:0] ir2_output,pc2_output,r1_value,r2_value,z5_output,sextended_value; // ir - instruction register 
wire reset,clk;	
wire[5:0] alu_select_input; //alu_select line input to dff for next stage
wire[1:0] select_ir3,select_x3,select_y3,select_md3; //select lines for mux of x3,y3,ir3 and memory data(md3)
wire select_pc3;  // select line for mux of pc3 for next stage
reg[31:0] nop;  //nop register
wire[2:0] sext_select;   // select line for sign extension block

always @(reset)
		begin
			if(reset==1)
				begin
					nop <= 0;
				end
		end
		
alu_decode decode(.ir2_output(ir2_output),.alu_select(alu_select_input)); //instantiation of decoder for alu_select 
mux4 ir3mux(.in0(ir2_output),.in1(nop),.in2(ir3_output),.in3(ir3_output),.select(select_ir3),.out(ir3_input));//mux for ir of next stage
mux2 pc3mux(.in0(pc2_output),.in1(pc3_output),.select(select_pc3),.out(pc3_input)); //mux for pc of next stage
// mux for x3 and y3 of next stage to decide whether pc relative or to take values from registers
mux4 x3mux(.in0(r1_value),.in1(pc2_output),.in2(x3_output),.in3(z5_output),.select(select_x3),.out(x3_input));
mux4 y3mux(.in0(r2_value),.in1(sextended_value),.in2(y3_output),.in3(z5_output),.select(select_y3),.out(y3_input));
mux4 md3mux(.in0(r2_value),.in1(z5_output),.in2(md3_output),.in3(md3_output),.select(select_md3),.out(md3_input)); // mux for memory data
decoder de(ir2_output[6:0],sext_select);  //select line for sign extension 
sext ext(ir2_output,sext_select,sextended_value); //sign extension block
adder branchadd(pc2_output,sextended_value,branchaddress_input); //address for branch instruction dff 

endmodule
