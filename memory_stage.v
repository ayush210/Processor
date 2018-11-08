//4th stage
module memory_stage(clk,reset,ir4_output,pc4_output,z4_output,md4_output,z5_output,read_data,write_data,select_z5,select_writedata,ir5_input,z5_input,select_ir5);
input clk,reset,select_ir5;
input[31:0] ir4_output,pc4_output,z4_output,md4_output,z5_output,read_data; //inputs from 3rd stage and from data memory 
output[31:0] write_data,ir5_input,z5_input;  // data to be written in memory and inputs to dff for next stage
input[1:0] select_z5; //select line for z5 
input select_writedata;         //to select data to be written to memory
//assign ir5_input = ir4_output; //passing instruction to next stage
wire[31:0] ir5_input;
reg[31:0] nop;

mux2 writedatamux(.in0(z5_output),.in1(md4_output),.select(select_writedata),.out(write_data));
mux4 z5mux(.in0(read_data),.in1(z4_output),.in2(pc4_output),.in3(pc4_output),.select(select_z5),.out(z5_input));
mux2 ir5_mux(.in0(ir4_output),.in1(nop),.select(select_ir5),.out(ir5_input));

always@(*)
		begin
			if(reset==1)
				begin
				nop<=0;
				end
		end

endmodule
