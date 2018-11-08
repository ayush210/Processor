// main module for memory

module cachemem(reset,clk,fulladdress,write_data,read_data,write_signal,read_signal,.match(match));

parameter memory_bits = 5;
parameter index = 3;
//output prevread;
//output validout;
input reset;
input clk;
input[memory_bits-1:0] fulladdress;
input[31:0] write_data;
output[31:0] read_data;
output match;
input write_signal;
input read_signal;
wire[memory_bits-index-1:0] tagoutput;
wire[31:0] read_data1;
wire[31:0] read_data2;
wire validout;
reg[memory_bits-1:0] prevaddress;
reg  prevread;
reg prevmatch;

ValidRam vram(.address(fulladdress[index-1:0]),.ValidOut(validout),.write_signal(write_signal),.reset(reset),.clk(clk),.read_signal(read_signal),.prevread(prevread),.match(match),.prevaddress(prevaddress),.prevmatch(prevmatch));
TagRam tram(.address(fulladdress[index-1:0]),.Taginput(fulladdress[memory_bits-1:index]),.Tagout(tagoutput),.write_signal(write_signal),.clk(clk),.read_signal(read_signal),.prevaddress(prevaddress),.prevread(prevread),.prevmatch(prevmatch));
DataRam dram(.address(fulladdress[index-1:0]),.datainput(write_data),.dataoutput(read_data1),.clk(clk),.write_signal(write_signal),.read_signal(read_signal),.match(match),.prevaddress(prevaddress),.prevread(prevread),.prevvalue(read_data),.prevmatch(prevmatch));
mainmeory mmem(.fulladdress(fulladdress),.datainput(write_data),.dataoutput(read_data2),.clk(clk),.write_signal(write_signal),.match(match),.read_signal(read_signal));
//TagRam (.address(fulladdress[index-1:0]),.Taginput(fulladdress[memorybits-1:index]),.Tagout(tagout),.write_signal(write_signal),.clk(clk));
comparator com(.taginput(fulladdress[memory_bits-1:index]),.tagoutput(tagoutput),.match(match),.read_signal(read_signal),.validbit(validout));
mux m(.in0(read_data2),.in1(read_data1),.out(read_data),.select(match));

always @(negedge clk)   //storing the prevadd and match at the negedge for next cycle 
begin
prevaddress = fulladdress;
		if(read_signal==1)
				prevread = 1;
prevmatch = match;
end


initial begin
//$monitor("%d %d",tagoutput,fulladdress[memory_bits-1:index]);
end
endmodule




