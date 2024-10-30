
// alu_decoder.v - logic for ALU decoder

module alu_decoder (
    input            opb5,
    input [2:0]      funct3,
    input            funct7b5,
    input [1:0]      ALUOp,
    output reg [2:0] ALUControl,
	 output reg			aluflag
);

always @(*) begin
	aluflag = 0; //defult
    case (ALUOp)
        2'b00: ALUControl = 3'b000;             // addition
        2'b01: ALUControl = 3'b001;             // subtraction
        default:
            case (funct3) // R-type or I-type ALU
                3'b000: begin
                    // True for R-type subtract
                    if   (funct7b5 & opb5) ALUControl = 3'b001; //sub
                    else ALUControl = 3'b000; // add, addi
                end
					 3'b100: ALUControl = 3'b110; // XOR, XORI
                3'b110: ALUControl = 3'b111; // OR, ORI
					 3'b111: ALUControl = 3'b100; //AND ANDI BLT, SLTU
                3'b001:begin
								ALUControl = 3'b110; // SLL, SLLI //facing isssue
								aluflag = 1;
							end
                3'b010: ALUControl = 3'b101; // SLT, SLTI
                3'b101:if(funct7b5) begin		//sra, arai
											ALUControl = 3'b011;
											aluflag = 1;
											end
							  else ALUControl = 3'b011; // SRL, SRLI
                
                3'b110: ALUControl = 3'b010; // AND, ANDI
                3'b011:begin
								ALUControl = 3'b100; // SLL, SLLI //facing isssue
								aluflag = 1;
							end
								 
                default: ALUControl = 3'bxxx; // ???
            endcase
    endcase
end

endmodule

