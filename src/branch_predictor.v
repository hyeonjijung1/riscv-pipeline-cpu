module branch_predictor(
    input         clk, reset,
    input         branch_taken_actual,
    input  [31:0] pc_in,
    output reg    predict_taken
);
    // 2-bit saturating counter table
    reg [1:0] counter [0:255];
    wire [7:0] idx = pc_in[9:2];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            integer i;
            for (i = 0; i < 256; i = i + 1) counter[i] <= 2'b01; // weak not taken
        end else begin
            if (branch_taken_actual && counter[idx] != 2'b11)
                counter[idx] <= counter[idx] + 1;
            else if (!branch_taken_actual && counter[idx] != 2'b00)
                counter[idx] <= counter[idx] - 1;
        end
    end

    always @(*) begin
        predict_taken = counter[idx][1]; // taken if high bit is 1
    end
endmodule

