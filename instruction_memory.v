/*module instruction_memory(clk,pc,instruction,instruction_reset,write_signal,instruction_write,write_address);

input instruction_reset,write_signal,clk; //write_signal - enable for writing to instruction memory
input[31:0] pc,instruction_write,write_address; 
output[31:0] instruction; //output of instruction read
reg[31:0] instruction;
reg[8:0] i; //temp variable only for "for" loop
reg[31:0] memory[20:0]; //memory registers

	always @(posedge clk)
		begin
			if(instruction_reset==1'b1)   //resetting instruction memory to all 0
				begin
					for(i=0;i<21;i=i+1)
					memory[i] = 0;
				end
			else if(write_signal==1)
				begin
					memory[write_address] = instruction_write; //writing instruction to instruction memory
				end
			else
				begin
					instruction = memory[pc]; // reading instruction from instruction memory
				end
		end

endmodule*/

		
