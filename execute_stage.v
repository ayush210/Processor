module execute_stage(ir3_output,pc3_output,x3_output,y3_output,md3_output,pc4_output,z4_output,z5_output,select_ir4,select_pc4z4,select_operand1,select_operand2,select_md4,clk,reset,ir4_input,pc4_input,z4_input,md4_input,alu_select_output,branch_control_input,select_z4,md4_output,ir4_output,select_pc4);

input select_pc4;
input[31:0] ir4_output;
input select_z4;
input[5:0] alu_select_output;        //input for dff for next stage 
input[1:0] select_operand1,select_operand2,select_md4;  //select lines for operand1 and operand2 of alu and for memory data 
input[1:0] select_ir4;
input select_pc4z4;   // select lines for next stage instruction reg 
input[31:0] ir3_output,pc3_output,x3_output,y3_output,md3_output,z4_output,z5_output,pc4_output; //output of dff from previous stage
input clk,reset;     
output[31:0] ir4_input,pc4_input,z4_input,md4_input; // input for dff for next stage
reg[31:0] nop;   		
wire[31:0] ir4_input,pc4_input,z4_input,md4_input;  
wire[31:0] operand1,operand2,mux_operand_in; //alu inputs operand1 and operand2 //	
wire[5:0] alu_select_output;    // alu_select coming from previous stage output of dff
output branch_control_input;
reg branch_control_input;
wire[31:0] alu_output;
input[31:0] md4_output;

always @(posedge clk)
		begin
if(reset==1)
		nop = 0;
		end
		//passing instruction and isntruction address to next stage for pc relative computation
		//assign ir4_input = ir3_output;

		//mux2 ir4mux(.in0(ir3_output),.in1(nop),.select(select_ir4),.out(ir4_input));
		mux2 pc4z4mux(.in0(pc4_output),.in1(z4_output),.select(select_pc4z4),.out(mux_operand_in));

		//mux for operand1 and operand2 of alu
		mux4 operand1mux(.in0(x3_output),.in1(z5_output),.in2(z4_output),.in3(z4_output),.select(select_operand1),.out(operand1));
		mux4 operand2mux(.in0(y3_output),.in1(z5_output),.in2(z4_output),.in3(z4_output),.select(select_operand2),.out(operand2));
		mux4 ir4mux(.in0(ir3_output),.in1(nop),.in2(ir4_output),.in3(ir4_output),.select(select_ir4),.out(ir4_input));
		//mux for memory data 
		mux4 md4mux(.in0(md3_output),.in1(z5_output),.in2(z4_output),.in3(md4_output),.select(select_md4),.out(md4_input));
		
		//	alu_decode decode(.ir3_output(ir3_output),.alu_select(alu_select));
		//alu instantiation
		alu al(.operand1(operand1),.operand2(operand2),.alu_select(alu_select_output),.z4_input(alu_output));
		mux2 z4mux(.in0(alu_output),.in1(z4_output),.select(select_z4),.out(z4_input));	
		mux2 pc4mux(.in0(pc3_output),.in1(pc4_output),.select(select_pc4),.out(pc4_input));
//initial begin
//$monitor("%d",branch_control_input);
//end

always @(*)
		begin
			if(ir3_output[6:0]==7'b1100011)
				begin
//					$display("%b",ir3_output);
					if(ir3_output[14:12]==3'b000&&z4_input[31:0]==32'b0)
						branch_control_input = 1;
					else if(ir3_output[14:12]==3'b001&&z4_input[31:0]!=32'b0)
						branch_control_input = 1;
					else if(ir3_output[14:12]==3'b100&&z4_input[31]==1'b1)
						branch_control_input = 1;
					else if(ir3_output[14:12]==3'b101&&z4_input[31]==1'b0)
						branch_control_input = 1;
					else if(ir3_output[14:12]==3'b110&&z4_input[31]==1'b1)
						branch_control_input = 1;
					else if(ir3_output[14:12]==3'b111&&z4_input[31]==1'b0)
						branch_control_input = 1;
					else 
						branch_control_input = 0;
				end
			else
				begin
					branch_control_input = 0;
				end
		 end
endmodule
