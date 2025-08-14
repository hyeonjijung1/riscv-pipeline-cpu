module mem_wb_regs(
    input clk, reset,
    input [31:0] alu_result_in, mem_data_in,
    input [4:0] rd_in,
    input MemtoReg_in, RegWrite_in,
    output reg [31:0] alu_result_out, mem_data_out,
    output reg [4:0] rd_out,
    output reg MemtoReg_out, RegWrite_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 0; mem_data_out <= 0; rd_out <= 0;
            MemtoReg_out <= 0; RegWrite_out <= 0;
        end else begin
            alu_result_out <= alu_result_in;
            mem_data_out <= mem_data_in;
            rd_out <= rd_in;
            MemtoReg_out <= MemtoReg_in;
            RegWrite_out <= RegWrite_in;
        end
    end
endmodule
