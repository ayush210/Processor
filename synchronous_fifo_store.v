module fifos(clk,reset,write_enable,read_enable,data_in,data_out,empty_signal,full_signal);

parameter word_size = 54;
parameter fifo_size = 20;
input clk,reset;
input write_enable,read_enable;
input [word_size-1:0] data_in;
output [word_size-1:0] data_out;
output empty_signal;
output full_signal;
reg [word_size-1:0] data_out;
reg looped;      //bool variable 0-false 1-true
reg [word_size-1:0] memory[fifo_size:0];
reg head,tail;
reg empty_signal;
reg full_signal;

always @(posedge clk)
		begin
			if(reset==1)
				begin
					head = 0;
					tail = 0;
					looped = 0;
					full_signal = 0;
					empty_signal = 1;
				end
			if(reset!=1&&write_enable==1)
				begin
					//$display("%d",data_in);
					//$display("workd");
					if((looped==0)||(head!=tail))
						begin
							empty_signal = 0;
							memory[head] = data_in;
						end
					if(head==fifo_size)
						begin
							head = 0;
							looped = 1;
						end
					else 
						begin
							head = head + 1;
						end
				end
			if(reset!=1&&head==tail)
				begin
					if(looped==1)
						begin
							full_signal = 1;
						end
					else
						begin
							empty_signal = 1;
						end
				end
		end

always @(negedge clk)
		begin
			if(reset==1)
				begin
					head = 0;
					tail = 0;
					looped = 0;
					full_signal = 0;
					empty_signal = 1;
				end
			if(reset!=1&&read_enable==1)
				begin
					if((looped==1)||(head!=tail))
						begin	
							data_out = memory[tail];
						end
					if(tail==fifo_size)
						begin
							tail = 0;
							looped = 0;
						end
					else
						begin
							tail = tail + 1;
						end
				end
			if(reset!=1&&head==tail)
				begin
					if(looped==1)
						begin
							full_signal = 1;
						end
					else
						begin
							//$display("loope");
							empty_signal = 1;
						end
				end
		end

endmodule

/*module test;

reg clk,reset;
reg write_enable;
reg read_enable;
reg[53:0] data_in; 
wire[53:0] data_out;
wire empty_signal;
wire full_signal;

fifos f(.clk(clk),.reset(reset),.write_enable(write_enable),.read_enable(read_enable),.data_in(data_in),.data_out(data_out),.empty_signal(empty_signal),.full_signal(full_signal));

always @(*)
		begin
#5 clk<=	~clk;
		end


initial begin
$monitor("%d",data_out);
clk = 0;reset = 1;
#20 reset = 0;write_enable = 1;data_in = 20;
#50 write_enable = 0;
#20 read_enable = 1;
#20 read_enable = 0;
#100 $finish;
end



endmodule*/
