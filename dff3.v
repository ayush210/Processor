module dff3(in,clk,out,reset);

input reset;   
input in;      //input signal
input clk;
output out;  //output of dff
reg out;

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
