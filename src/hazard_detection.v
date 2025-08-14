module hazard_detection(
    input        MemRead_IDEX,
    input  [4:0] rd_IDEX,
    input  [4:0] rs1_IFID,
    input  [4:0] rs2_IFID,
    output reg   PCWrite,
    output reg   IFIDWrite,
    output reg   control_mux
);
    always @(*) begin
        if (MemRead_IDEX && ((rd_IDEX == rs1_IFID) || (rd_IDEX == rs2_IFID)) && rd_IDEX != 0) begin
            PCWrite     = 1'b0;
            IFIDWrite   = 1'b0;
            control_mux = 1'b1;
        end else begin
            PCWrite     = 1'b1;
            IFIDWrite   = 1'b1;
            control_mux = 1'b0;
        end
    end
endmodule

