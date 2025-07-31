`timescale 1ns/1ps
module id_ex_regs_tb;
  reg clk = 0, reset = 1;
  // Control inputs
  reg RegWrite_i=1, MemRead_i=0, MemWrite_i=1, Branch_i=0, ALUSrc_i=1, MemToReg_i=0;
  reg [1:0] ALUOp_i = 2'b10;
  // Data inputs
  reg [31:0] rs1_data_i=32'hA, rs2_data_i=32'hB, imm_i=32'h10, pc4_i=32'h4;
  // Addr inputs
  reg [4:0] rs1_addr_i=5'd1, rs2_addr_i=5'd2, rd_addr_i=5'd3;

  // Outputs
  wire RegWrite_o, MemRead_o, MemWrite_o, Branch_o, ALUSrc_o, MemToReg_o;
  wire [1:0] ALUOp_o;
  wire [31:0] rs1_data_o, rs2_data_o, imm_o, pc4_o;
  wire [4:0] rs1_addr_o, rs2_addr_o, rd_addr_o;

  id_ex_regs DUT (
    .clk(clk), .reset(reset),
    .RegWrite_i(RegWrite_i), .MemRead_i(MemRead_i), .MemWrite_i(MemWrite_i),
    .Branch_i(Branch_i), .ALUSrc_i(ALUSrc_i), .MemToReg_i(MemToReg_i),
    .ALUOp_i(ALUOp_i),
    .rs1_data_i(rs1_data_i), .rs2_data_i(rs2_data_i),
    .imm_i(imm_i), .pc4_i(pc4_i),
    .rs1_addr_i(rs1_addr_i), .rs2_addr_i(rs2_addr_i), .rd_addr_i(rd_addr_i),
    .RegWrite_o(RegWrite_o), .MemRead_o(MemRead_o), .MemWrite_o(MemWrite_o),
    .Branch_o(Branch_o), .ALUSrc_o(ALUSrc_o), .MemToReg_o(MemToReg_o),
    .ALUOp_o(ALUOp_o),
    .rs1_data_o(rs1_data_o), .rs2_data_o(rs2_data_o),
    .imm_o(imm_o), .pc4_o(pc4_o),
    .rs1_addr_o(rs1_addr_o), .rs2_addr_o(rs2_addr_o), .rd_addr_o(rd_addr_o)
  );

  always #5 clk = ~clk;

  initial begin
    #10 reset = 0;          // release reset
    #10;                    // capture inputs
    $display("RegWrite=%b MemRead=%b MemWrite=%b Branch=%b ALUSrc=%b MemToReg=%b",
             RegWrite_o, MemRead_o, MemWrite_o, Branch_o, ALUSrc_o, MemToReg_o);
    $display("ALUOp=%b", ALUOp_o);
    $display("rs1_data=0x%0h rs2_data=0x%0h imm=0x%0h pc4=0x%0h",
             rs1_data_o, rs2_data_o, imm_o, pc4_o);
    $display("rs1_addr=%d rs2_addr=%d rd_addr=%d",
             rs1_addr_o, rs2_addr_o, rd_addr_o);
    #10 $finish;
  end
endmodule
