module test;

parameter memory_bits = 5;

reg [memory_bits-1:0] fulladdress;
reg clk,reset;
reg read_signal,write_signal;
wire[3:0] state;
reg [31:0] out_write;
wire [31:0] out_read;

combined c(.clk(clk),.reset(reset),.fulladdress(fulladdress),.read_signal(read_signal),.write_signal(write_signal),.state(state),.out_write(out_write),.out_read(out_read));

always@(*)
		begin
			#5 clk<=~clk;
		end

initial begin
$monitor($time,"%d %d",state,out_read);
	clk = 0;
#5 reset = 1;
//#10 reset = 0;fulladdress = 12; write_signal = 1;out_write = 6; 
//#20 fulladdress = 12; write_signal = 0;
#10 reset = 0;read_signal = 1;fulladdress = 12;
#20 read_signal = 0;
//#20 read_signal = 1;fulladdress = 20;
//#20 read_signal = 0;
//#100 read_signal = 1;
//#20 read_signal = 0;
	end

endmodule
