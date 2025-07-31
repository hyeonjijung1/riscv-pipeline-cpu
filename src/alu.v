// src/alu.v
// Arithmetic Logic Unit: ADD, SUB, AND, OR

module alu (
    input  wire [31:0] A,          // operand 1
    input  wire [31:0] B,          // operand 2 (or imm)
    input  wire [2:0]  alu_ctrl,   // from alu_control
    output reg  [31:0] result,     
    output wire        zero        // high when result == 0
);

    always @(*) begin
        case (alu_ctrl)
            3'b010: result = A + B;   // ADD
            3'b110: result = A - B;   // SUB
            3'b000: result = A & B;   // AND
            3'b001: result = A | B;   // OR
            default: result = A + B;  // safe default
        endcase
    end

    assign zero = (result == 0);

endmodule
