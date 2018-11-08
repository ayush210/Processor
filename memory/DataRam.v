module DataRam(address,datainput,dataoutput,clk,write_signal);

parameter index = 3;
parameter cachesize = 8;
parameter memorybits = 5;

input[index-1:0] address;
input[31:0] datainput;
output[31:0] dataoutput;
input clk;
input write_signal;

reg[31:0] dataoutput;
reg[31:0] data[7:0];

always @(posedge clk)
begin
if(write_signal==1)
			data[address] = datainput;
end

always @(negedge clk)
begin
			dataoutput = data[address];
end

endmodule

module mainmeory(fulladdress,datainput,dataoutput,clk,write_signal);
parameter memorybits = 5;
input[memorybits-1:0] fulladdress;
input[31:0] datainput;
output[31:0] dataoutput;
input clk;
input write_signal;
reg[31:0] dataoutput;
reg[31:0] data[31:0];

always @(posedge clk)
		begin
			if(write_signal==1)
				data[fulladdress] = datainput;
		end

always @(negedge clk)
		begin
			dataoutput = data[fulladdress];
		end

endmodule
