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

//`define index 3;
//integer index=3;
module TagRam(address,Taginput,Tagout,write_signal,clk,read_signal,prevaddress,prevread,prevmatch);
	parameter index = 3;
	parameter cachesize = 8;
	parameter memorybits = 5;
	input read_signal;
	input[index-1:0] address;          //input index
	input[memorybits-index-1:0] Taginput;
	output[memorybits-index-1:0] Tagout;
	input write_signal;
	input clk;
	reg[memorybits-index-1:0] Tagout;
	reg[memorybits-index-1:0] Tagbits[cachesize-1:0];
	input[memorybits-1:0] prevaddress;
	input prevread;
	input prevmatch;
	
	always@(posedge clk)     //write
		begin
			if(write_signal==1)
				Tagbits[address] = Taginput;
			if(read_signal==1)
				Tagout = Tagbits[address];
			else 
				Tagout = 0;
			if(prevread==1&&prevmatch==0)
				Tagbits[prevaddress[index-1:0]] = prevaddress[memorybits-1:index];
		end
	//always@(negedge clk)	//read
	//	begin
	//				Tagout = Tagbits[address];
	//	end
//	initial begin
//		$monitor("%d",address);
//	end
endmodule

module ValidRam(address,ValidOut,write_signal,reset,clk,read_signal,prevread,match,prevaddress,prevmatch);
	parameter index = 3;
	parameter cachesize = 8;
	parameter memory_bits = 5;
	input[memory_bits-1:0] prevaddress;
	input match;
	input prevread;
	input[index-1:0] address;
	input write_signal;
	input reset;
	input clk;
	input read_signal;
	output ValidOut;
	integer i;
	reg ValidOut;
	reg Validbits[cachesize-1:0];
	input prevmatch;
	always@(posedge clk)       // write
		begin
			if(write_signal==1&&reset==0)
			//	$display("%d",address);
				Validbits[address] = 1;
			else if(reset==1)
			begin
					for(i=0;i<cachesize;i++)
							Validbits[i] = 0;
			end
			if(read_signal==1)
				ValidOut = Validbits[address];
			else 
				ValidOut = 0;
			if(prevread==1&&prevmatch==0)
				Validbits[prevaddress[index-1:0]] = 1; 
		end
	//initial begin
	//$monitor("%d",address);
	//end
//	always@(negedge clk)	  // read
//		begin
//			ValidOut = Validbits[address];
//		end
endmodule

module mux(in0,in1,out,select);

input[31:0] in0;
input[31:0] in1;
output[31:0] out;
input select;

assign out = (select==0)?in0:in1;

endmodule

module combined(reset,clk,fulladdress,write_data,read_data,write_signal,read_signal,match,validout,prevread);

parameter memory_bits = 5;
parameter index = 3;
output prevread;
output validout;
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

always @(negedge clk)
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

module test;

reg reset;
reg clk;
reg[4:0] fulladdress;
reg[31:0] write_data;
wire[31:0] read_data;
reg  write_signal;
reg read_signal;
wire match;
wire validbit;
wire prevread;

combined com(.reset(reset),.clk(clk),.fulladdress(fulladdress),.write_data(write_data),.read_data(read_data),.write_signal(write_signal),.read_signal(read_signal),.match(match),.validout(validbit),.prevread(prevread));

always @(*)
		begin
#5 clk <= ~clk;
		end

initial begin
$monitor($time," %d %d %d %d %d",read_data,match,validbit,fulladdress,prevread);
clk = 0;reset = 1;
#5 reset = 0;fulladdress = 1; write_data = 5; write_signal = 1;
#10 fulladdress = 2; write_data = 6;
#10 fulladdress = 1;write_signal = 0;read_signal = 1;
#10 fulladdress = 2;write_signal = 0;read_signal = 1;
//#10 fulladdress = 1; write_data = 6; write_signal = 1;
//#10 fulladdress = 0; write_data = 5;write_signal = 1;read_signal = 0;
//#10 fulladdress = 1; read_signal = 1; write_signal = 0;
#10 fulladdress = 3;
#10 fulladdress = 2;
#10 fulladdress = 1;
#10 fulladdress = 3;
#10 fulladdress = 3;
//#10 
//#10 fulladdress = 0; 
end


endmodule

/*module test;
reg clk;
reg[4:0]fulladdress;
reg[31:0] write_data;
wire[31:0] read_data;

endmodule*/
