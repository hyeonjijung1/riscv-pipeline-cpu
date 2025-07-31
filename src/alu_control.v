// src/alu_control.v
// Translates ALUOp + funct3/funct7 into a 3-bit ALU control signal

module alu_control (
    input  wire [1:0] ALUOp,      // from Control Unit
    input  wire [2:0] funct3,     // instr[14:12]
    input  wire       funct7_5,   // instr[30] (bit 5 of funct7)
    output reg  [2:0] alu_ctrl    // to ALU
);

    always @(*) begin
        case (ALUOp)
            2'b00: alu_ctrl = 3'b010;       // LW/SW: ADD
            2'b01: alu_ctrl = 3'b110;       // BEQ:    SUBTRACT
            2'b10: begin                    // R-type: use funct3/funct7
                case ({funct7_5, funct3})
                    4'b0000: alu_ctrl = 3'b010; // ADD
                    4'b1000: alu_ctrl = 3'b110; // SUB
                    4'b0001: alu_ctrl = 3'b001; // SLL (optional)
                    4'b0110: alu_ctrl = 3'b001; // OR
                    4'b0111: alu_ctrl = 3'b000; // AND
                    default: alu_ctrl = 3'b010; // default ADD
                endcase
            end
            default: alu_ctrl = 3'b010;
        endcase
    end

endmodule
