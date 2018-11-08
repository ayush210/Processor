// decoder for select line of alu
module alu_decode(ir2_output,alu_select);
input[31:0] ir2_output;
output[5:0] alu_select;
reg[5:0] alu_select;
always @(*)
		begin

		if(ir2_output[6:0]==7'b0110011)
		begin
		if(ir2_output[31:25]==7'b0100000&&ir2_output[14:12]==3'b000)
		alu_select = 6'b000000;//add
		if(ir2_output[31:25]==7'b0000000&&ir2_output[14:12]==3'b000)
		alu_select = 6'b000001;//sub
		if(ir2_output[31:25]==7'b0000000&&ir2_output[14:12]==3'b111)
		alu_select = 6'b000010;//and
		if(ir2_output[31:25]==7'b0000000&&ir2_output[14:12]==3'b110)
		alu_select = 6'b000011;//or
		if(ir2_output[31:25]==7'b0000000&&ir2_output[14:12]==3'b100)
		alu_select = 6'b000100;//xor
		if(ir2_output[31:25]==7'b0000000&&ir2_output[14:12]==3'b010)
		alu_select = 6'b000101;//slt
		if(ir2_output[31:25]==7'b0000000&&ir2_output[14:12]==3'b011)
		alu_select = 6'b000110;//sltu
		if(ir2_output[31:25]==7'b0100000&&ir2_output[14:12]==3'b101)
		alu_select = 6'b000111;//sra
		if(ir2_output[31:25]==7'b0000000&&ir2_output[14:12]==3'b101)
		alu_select = 6'b001000;//srl
		if(ir2_output[31:25]==7'b0000000&&ir2_output[14:12]==3'b001)
		alu_select = 6'b001001;//sll
		if(ir2_output[31:25]==7'b0000001&&ir2_output[14:12]==3'b000)
		alu_select = 6'b001010;//mul
		end

		else if(ir2_output[6:0]==7'b0010011)
		begin
		if(ir2_output[14:12] == 3'b000)
		alu_select = 6'b001011;//addi
		if(ir2_output[14:12] == 3'b001)
		alu_select = 6'b001100;//subi
		if(ir2_output[14:12] == 3'b111)
		alu_select = 6'b001101;//andi
		if(ir2_output[14:12] == 3'b110)
		alu_select = 6'b001110;//ori
		if(ir2_output[14:12] == 3'b100)
		alu_select = 6'b001111;//xori
		if(ir2_output[14:12] == 3'b010)
		alu_select = 6'b010000;//slti
		if(ir2_output[14:12] == 3'b011)
		alu_select = 6'b010001;//sltiu
		if(ir2_output[14:12] == 3'b101&&ir2_output[31:25]==7'b0100000)
		alu_select = 6'b010010;//srai
		if(ir2_output[14:12] == 3'b101&&ir2_output[31:25]==7'b0000000)
		alu_select = 6'b010011;//srli
		if(ir2_output[14:12] == 3'b101&&ir2_output[31:25]==7'b0000001)
		alu_select = 6'b010100;//slli
		end

		else if(ir2_output[6:0]==7'b0110111)
		alu_select = 6'b010101;//lui

		else if(ir2_output[6:0]==7'b0010111)
		alu_select = 6'b010110;//auipc

		else if(ir2_output[6:0]==7'b0000011&&ir2_output[14:12]==3'b010)
		alu_select = 6'b010111;//lw

		else if(ir2_output[6:0]==7'b0100011&&ir2_output[14:12]==3'b010)
		alu_select = 6'b011000;//sw

		else if(ir2_output[6:0]==7'b1101111)
		alu_select = 6'b011001;//jal

		else if(ir2_output[6:0]==7'b1100111)
		begin
		if (ir2_output[11:7]==5'b00000)//jr
		alu_select = 6'b011011;
		else
		alu_select = 6'b011010;//jalr
		end

		else if(ir2_output[6:0]==7'b1100011)
		begin
		if(ir2_output[14:12]==3'b000)
		alu_select = 6'b011100;//beq
		if(ir2_output[14:12]==3'b001)
		alu_select = 6'b011101;//bne
		if(ir2_output[14:12]==3'b100)
		alu_select = 6'b011110;//blt
		if(ir2_output[14:12]==3'b101)
		alu_select = 6'b011111;//bge
		if(ir2_output[14:12]==3'b110)
		alu_select = 6'b100000;//bltu
		if(ir2_output[14:12]==3'b111)
		alu_select = 6'b100001;//bgeu
		end

		else 
		alu_select = 6'b000000; //for all other instructions

		end
		endmodule


