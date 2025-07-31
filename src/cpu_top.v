wire [31:0] pc, pc_plus4;
pc PC_inst (
  .clk(clk),
  .reset(reset),
  .next_pc(pc_plus4),
  .pc_out(pc)
);
