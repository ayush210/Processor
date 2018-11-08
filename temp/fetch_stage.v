module fetch_stage(z4,clk,reset,select_pc,select_ir2,select_pc2,instruction,pc,branchaddress,ir2_input,pc2_input,ir2_output,pc2_output);
		
input clk,reset;
input[31:0] z4; //z4_output from output from 4th stage for forwarding
input[1:0] select_pc,select_ir2;  //select lines for pc and instruction reg for next stage
input select_pc2; //select line for program counter for next stage
input[31:0] instruction,branchaddress,ir2_output,pc2_output;  //input from ir memory,3rd stage for branching (branchaddress) 
output[31:0] pc;   //pc as input to instruction memory
output[31:0] ir2_input,pc2_input;
wire[31:0] pcout,incrementedpc;
reg[31:0] nop;
	always @(reset)
		begin
			if(reset==1) // reset to set nop instruction
				begin
					nop <= 0;
				end
		end
		
mux4 pcmux(.in0(z4),.in1(incrementedpc),.in2(pcout),.in3(branchaddress),.select(select_pc),.out(pc));//mux for program counter
dff pcd(.in(pc),.clk(clk),.out(pcout),.reset(reset));   
incby1 inc(.in(pcout),.out(incrementedpc),.clear(reset));  //incrementation for pc by 1
mux2 pc2mux(.in0(incrementedpc),.in1(pc2_output),.select(select_pc2),.out(pc2_input)); //mux for pc of next stage
mux4 ir2mux(.in0(instruction),.in1(nop),.in2(ir2_output),.in3(ir2_output),.select(select_ir2),.out(ir2_input)); //mux for ir of next stage
		
endmodule
