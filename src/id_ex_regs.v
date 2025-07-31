module id_ex_regs (
  input  wire        clk, reset,
  // Control signals from ID
  input  wire        RegWrite_i, MemRead_i, MemWrite_i, Branch_i, ALUSrc_i, MemToReg_i,
  input  wire [1:0]  ALUOp_i,
  // Data from ID
  input  wire [31:0] rs1_data_i, rs2_data_i, imm_i, pc4_i,
  input  wire [4:0]  rs1_addr_i, rs2_addr_i, rd_addr_i,
  // Outputs to EX
  output reg         RegWrite_o, MemRead_o, MemWrite_o, Branch_o, ALUSrc_o, MemToReg_o,
  output reg  [1:0]  ALUOp_o,
  output reg  [31:0] rs1_data_o, rs2_data_o, imm_o, pc4_o,
  output reg  [4:0]  rs1_addr_o, rs2_addr_o, rd_addr_o
);
   always @(posedge clk) begin
        if (reset) begin
            RegWrite_o  <= 0;  MemRead_o   <= 0;
            MemWrite_o  <= 0;  Branch_o    <= 0;
            ALUSrc_o    <= 0;  MemToReg_o  <= 0;
            ALUOp_o     <= 2'b00;
            rs1_data_o  <= 0;  rs2_data_o  <= 0;
            imm_o       <= 0;  pc4_o       <= 0;
            rs1_addr_o  <= 0;  rs2_addr_o  <= 0;
            rd_addr_o   <= 0;
        end else begin
            RegWrite_o  <= RegWrite_i;  
            MemRead_o   <= MemRead_i;
            MemWrite_o  <= MemWrite_i;  
            Branch_o    <= Branch_i;
            ALUSrc_o    <= ALUSrc_i;    
            MemToReg_o  <= MemToReg_i;
            ALUOp_o     <= ALUOp_i;
            rs1_data_o  <= rs1_data_i;  
            rs2_data_o  <= rs2_data_i;
            imm_o       <= imm_i;       
            pc4_o       <= pc4_i;
            rs1_addr_o  <= rs1_addr_i;  
            rs2_addr_o  <= rs2_addr_i;
            rd_addr_o   <= rd_addr_i;
        end
    end
endmodule