module test;

parameter a_channel_size = 53;
parameter d_channel_size = 43; 

reg clk,reset;
reg [31:0] ir34;
reg[31:0] z4_input;
reg[31:0] md4_input;
reg a_ready;
reg d_ready;

wire a_valid;
wire[a_channel_size-1:0] a_channel;
wire[d_channel_size-1:0] d_channel;
wire backpressureslave;
wire d_valid;
wire d_error;

master m(.clk(clk),.reset(reset),.ir34(ir34),.a_ready(a_ready),.a_valid(a_valid),.a_channel(a_channel),.d_ready(d_ready),.d_channel(d_channel),.backpressureslave(backpressureslave),.z4_input(z4_input),.md4_input(md4_input),.d_valid(d_valid),.d_error(d_error));
slave s(.clk(clk),.reset(reset),.a_channel(a_channel),.d_channel(d_channel),.a_valid(a_valid),.a_ready(a_ready),.d_valid(d_valid),.d_ready(d_ready),.backpressureslave(backpressureslave),.d_error(d_error));

always@(*)
		begin
			#5 clk<= ~clk;
		end

initial begin
$monitor("%b %b %d %d",a_channel,d_channel,d_ready,a_ready);
//$monitor("%b",d_channel[31:0]);
clk = 0;reset = 0;a_ready = 1;d_ready = 1;
#5 reset <= 1;
#20 reset <= 0;
#20 ir34 <= 32'b00000000000000000000000000100011;md4_input <= 20; z4_input <= 10;
#10 ir34 <= 0; 
#50 ir34 <= 32'b00000000000000000000000000000011; 
#50 ir34 <= 32'b00000000000000000000000000100011;md4_input <= 30; z4_input <= 10;
#50 d_ready <= 0;
#50 ir34 <= 32'b00000000000000000000000000000011; 
#50 d_ready <= 1;
#50 a_ready <= 0;
#20 ir34 <= 32'b00000000000000000000000000100011;md4_input <= 20; z4_input <= 10;
#20 a_ready <= 1;
#50 ir34 <= 32'b00000000000000000000000000000011;md4_input <= 30; z4_input <= 10;
#50 $finish;
end

endmodule
