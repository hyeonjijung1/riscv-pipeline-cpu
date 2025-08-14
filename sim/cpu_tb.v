`timescale 1ns/1ps

module cpu_tb;
    reg clk;
    reg reset;

    // Instantiate CPU top module
    cpu_top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Reset & program load
    initial begin
        reset = 1;
        #20;
        reset = 0;
    end

    // Stop simulation after N cycles
    initial begin
        $dumpfile("cpu_wave.vcd");  // For GTKWave
        $dumpvars(0, cpu_tb);
        #2000; // Run for 2000 ns
        $display("Simulation complete.");
        $finish;
    end
endmodule
