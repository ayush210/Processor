//`define index 3;
//integer index=3;
module TagRam(address,Taginput,Tagout,write_signal,clk,read_signal);
	parameter index = 3;
	parameter cachesize = 8;
	parameter memorybits = 5;
	input[index-1:0] address;          //input index
	input[memorybits-index-1:0] Taginput;
	output[memorybits-index-1:0] Tagout;
	input write_signal;
	input clk;
	input read_signal;
	reg[memorybits-index-1:0] Tagout;
	reg[memorybits-index-1:0] Tagbits;

	always@(posedge clk)     //write
		begin
			if(write_signal==1)
				Tagbits[address] = Taginput;
			if(read_signal==1)
				Tagout = Tagbits[address];
			else	
				Tagout = 0;
		end
endmodule

module Test;

reg[4:0]address;
wire[1:0] tagoutput;
reg write_signal;
reg read_signal;
reg clk;

TagRam(.address(address[2:0]),.Taginput(address[4:3]),.Tagout(tagoutput),.write_signal(write_signal),.clk(clk),.read_signal(read_signal));

always @(*)
		begin
#5 clk<=~clk
		end

	
initial begin
$monitor("%d",tagoutput);
clk = 0;
#5 address = 1;write_signal = 1;
#10 address = 1;write_signal = 0;
end


endmodule
