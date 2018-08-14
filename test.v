module test;

reg reset;
reg clk;
reg[4:0] fulladdress;
reg[31:0] write_data;
wire[31:0] read_data;
reg  write_signal;
reg read_signal;
wire validbit;
wire prevread;
wire hit_miss;

cachemem cache(.reset(reset),.clk(clk),.fulladdress(fulladdress),.write_data(write_data),.read_data(read_data),.write_signal(write_signal),.read_signal(read_signal),.match(hit_miss));

always @(*)
		begin
#5 clk <= ~clk;
		end

initial begin
$monitor($time,"%d %d %d",fulladdress,read_data,hit_miss);
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
