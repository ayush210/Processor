module dff(in,clk,out,reset);

input reset;   
input[31:0] in;      //input signal
input clk;
output[31:0] out;  //output of dff
reg[31:0] out;

	always @(posedge clk)
		begin
			if(reset==1'b1)           
				begin
					out<=0;
				end
			else
				begin
					out<=in;
				end
		end
		
endmodule
