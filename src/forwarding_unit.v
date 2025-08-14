module forwarding_unit(
    input        RegWrite_EXMEM,
    input        RegWrite_MEMWB,
    input  [4:0] rd_EXMEM,
    input  [4:0] rd_MEMWB,
    input  [4:0] rs1_IDEX,
    input  [4:0] rs2_IDEX,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);
    always @(*) begin
        forwardA = 2'b00;
        forwardB = 2'b00;

        if (RegWrite_EXMEM && (rd_EXMEM != 0) && (rd_EXMEM == rs1_IDEX))
            forwardA = 2'b10;
        if (RegWrite_EXMEM && (rd_EXMEM != 0) && (rd_EXMEM == rs2_IDEX))
            forwardB = 2'b10;

        if (RegWrite_MEMWB && (rd_MEMWB != 0) && 
           !(RegWrite_EXMEM && (rd_EXMEM != 0) && (rd_EXMEM == rs1_IDEX)) &&
            (rd_MEMWB == rs1_IDEX))
            forwardA = 2'b01;

        if (RegWrite_MEMWB && (rd_MEMWB != 0) && 
           !(RegWrite_EXMEM && (rd_EXMEM != 0) && (rd_EXMEM == rs2_IDEX)) &&
            (rd_MEMWB == rs2_IDEX))
            forwardB = 2'b01;
    end
endmodule

