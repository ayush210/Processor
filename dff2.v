module dff2(in,clk,out,reset);
input reset;
input[5:0] in;
input clk;
output[5:0] out;
reg[5:0] out;
always @(posedge clk)
		begin
if(reset==1)
		begin
		out<=0;
		end
		else
		begin
		out<=in;
		end
		end
		endmodule
