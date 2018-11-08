// for pc incrementation
module incby1(in,out,clear);

input clear; //reset signal 
input[31:0] in; //pc input 
output[31:0] out; //incremented by 1
reg[31:0] out;
	
always @(in or clear)
	begin
		if(clear==1)
			begin
				out<=0;
			end
		else
			begin
				out<= in + 1;
			end
	end

endmodule
