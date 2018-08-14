module DataRam(address,datainput,dataoutput,clk,write_signal,read_signal,match,prevaddress,prevread,prevvalue,prevmatch);

parameter index = 3;
parameter cachesize = 8;
parameter memorybits = 5;

input[index-1:0] address;
input[31:0] datainput;
output[31:0] dataoutput;
input[31:0] prevvalue;
input[memorybits-1:0] prevaddress;
input prevread;
input clk;
input write_signal;
input read_signal;
input match;
input prevmatch;

reg[31:0] dataoutput;
reg[31:0] data[7:0];

always @(posedge clk)
begin
if(write_signal==1)
			data[address] = datainput;
if(prevread==1&&prevmatch==0)
			data[prevaddress[index-1:0]] = prevvalue;
end

always @(negedge clk)
begin
		if(read_signal==1&&match==1)
			dataoutput = data[address];
end

endmodule
