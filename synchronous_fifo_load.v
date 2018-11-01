module fifol(clk,reset,write_enable,read_enable,data_in,data_out,empty_signal,full_signal);

parameter word_size = 22;
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
			/*if(reset!=1&&write_enable==1)
				begin
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
				end*/
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

endmodule
	

