/*module test(clk,pc,instruction,instruction_reset,write_signal );
input[]
reg[31:0] mem[0:2];
integer i;
initial begin
$readmemb("machinecode.txt",mem);
end
initial begin
for(i=0;i<7;i=i+1)
$display("%b",mem[i]);
end
endmodule*/

module instruction_memory;
reg reset;  //reset signal given to processor
reg clk;     // clk signal 
wire[31:0] pc;   //program counter 
reg[31:0] instruction;         //instruction
reg[0:31] memory[0:40]; //memory registers
always @(*)             //generating clock signal       
		begin
#5 clk<=~clk;
		end 
processor proc(.clk(clk),.reset(reset),.pc(pc),.instruction(instruction)); //instantiating processor module
initial begin
clk = 0;reset = 1;
$readmemb("machinecode.txt",memory);     //reading instructions from memory
#5 
#10 reset = 0;
#200 $finish;
end
always @(posedge clk)
		begin
		instruction = memory[pc]; // reading instruction from instruction memory
		end
endmodule

