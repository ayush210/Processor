module comparator(taginput,tagoutput,match,read_signal,validbit);

parameter memory_bits = 5;
parameter index = 3;

input validbit;
input read_signal;
input[memory_bits-index-1:0] taginput;
input[memory_bits-index-1:0] tagoutput;
output match;
reg match;
always @(*)
		begin
		if((taginput==tagoutput)&&(read_signal==1)&&(validbit==1))
			match = 1;
		else 
			match = 0;
			end

endmodule
