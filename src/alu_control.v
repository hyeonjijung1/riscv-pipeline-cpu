module alu_control(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] alu_ctrl
);
    always @(*) begin
        case (ALUOp)
            2'b00: alu_ctrl = 4'b0010; // LW, SW = ADD
            2'b01: alu_ctrl = 4'b0110; // BEQ = SUB
            2'b10: begin
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_ctrl = 4'b0010; // ADD
                    {7'b0100000, 3'b000}: alu_ctrl = 4'b0110; // SUB
                    {7'b0000000, 3'b111}: alu_ctrl = 4'b0000; // AND
                    {7'b0000000, 3'b110}: alu_ctrl = 4'b0001; // OR
                    default: alu_ctrl = 4'b0010;
                endcase
            end
            default: alu_ctrl = 4'b0010;
        endcase
    end
endmodule

