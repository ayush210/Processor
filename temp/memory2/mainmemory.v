module mainmeory(fulladdress,datainput,dataoutput,clk,write_signal,read_signal,match);
parameter memorybits = 5;
input[memorybits-1:0] fulladdress;
input[31:0] datainput;
output[31:0] dataoutput;
input clk;
input write_signal;
input read_signal;
input match;
reg[31:0] dataoutput;
reg[31:0] data[31:0];

always @(posedge clk)
		begin
			if(write_signal==1)
				data[fulladdress] = datainput;
		end

always @(negedge clk)
		begin
			if(read_signal==1&&match==0)
				dataoutput = data[fulladdress];
		end

endmodule
