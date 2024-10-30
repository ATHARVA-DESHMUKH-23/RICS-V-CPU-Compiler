
// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [2:0] alu_ctrl,	 // ALU control
	 input				 aluflag,
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                    // zero flag
);

always @(a, b, alu_ctrl) begin
    case (alu_ctrl)
        3'b000:  alu_out <= a + b;       // ADD
        3'b001:  alu_out <= a + ~b + 1;  // SUB
        3'b100: if (!aluflag) alu_out <= a & b;    // AND
					 else alu_out <= (a < b) ? 1 : 0; // SLT
		  3'b110:begin                     // SRL or SRA
            if (aluflag) begin
                 alu_out <= a << b;            // SLL
            end else begin
                alu_out <= a ^ b;       // XOR
            end
        end  
        3'b111:  alu_out <= a | b;       // OR
		  
        3'b100:  alu_out <= (a < b) ? 1 : 0; // SLT
        3'b101:  alu_out <= a << b;      // SLL
        
        3'b011:  begin                     // SRL or SRA
            if (aluflag) begin
                alu_out <= $signed(a) >>> b; // SRA (arithmetic shift right)
            end else begin
                alu_out <= a >> b;      // SRL (logical shift right)
            end
        end
        default: alu_out = 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule

