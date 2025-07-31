module control_unit (
    input  wire [6:0] opcode,
    output reg       RegWrite,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       Branch,
    output reg       ALUSrc,
    output reg [1:0] ALUOp,
    output reg       MemToReg
);
    always @(*) begin
        case (opcode)
            7'b0110011: // R-type
                {RegWrite, MemRead, MemWrite, Branch, ALUSrc, ALUOp, MemToReg}
                  = 7'b1_0_0_0_0_10_0;
            7'b0000011: // LW
                {RegWrite, MemRead, MemWrite, Branch, ALUSrc, ALUOp, MemToReg}
                  = 7'b1_1_0_0_1_00_1;
            7'b0100011: // SW
                {RegWrite, MemRead, MemWrite, Branch, ALUSrc, ALUOp, MemToReg}
                  = 7'b0_0_1_0_1_00_0;
            7'b1100011: // BEQ
                {RegWrite, MemRead, MemWrite, Branch, ALUSrc, ALUOp, MemToReg}
                  = 7'b0_0_0_1_0_01_0;
            7'b0010011: // ADDI
                {RegWrite, MemRead, MemWrite, Branch, ALUSrc, ALUOp, MemToReg}
                  = 7'b1_0_0_0_1_00_0;
            // add others as needed…
            default:
                {RegWrite, MemRead, MemWrite, Branch, ALUSrc, ALUOp, MemToReg}
                  = 7'b0_0_0_0_0_00_0;
        endcase
    end
endmodule