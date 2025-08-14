module control(
    input  [6:0] opcode,
    output       Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output [1:0] ALUOp
);
    reg [8:0] controls;

    assign {Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp} = controls;

    always @(*) begin
        case (opcode)
            7'b0110011: controls = {1'b0,0,0,0,1'b0,1'b1,2'b10}; // R-type
            7'b0000011: controls = {1'b0,1,1,0,1'b1,1'b1,2'b00}; // LW
            7'b0100011: controls = {1'b0,0,0,1,1'b1,1'b0,2'b00}; // SW
            7'b1100011: controls = {1'b1,0,0,0,1'b0,1'b0,2'b01}; // BEQ
            default:    controls = {1'b0,0,0,0,1'b0,1'b0,2'b00}; // default NOP
        endcase
    end
endmodule


