    .text
    .globl _start
_start:
    # --- Forwarding chain (R-type) ---
    addi x1, x0, 5          # x1 = 5
    addi x2, x0, 7          # x2 = 7
    add  x3, x1, x2         # x3 = 12        (no hazard)
    add  x4, x3, x2         # x4 = 19        (forward x3 from EX/MEM)
    sub  x5, x4, x1         # x5 = 14        (forward x4)

    # --- Load-use hazard (stall expected) ---
    addi x10, x0, 0         # x10 = 0 (base addr for data_mem[0])
    lw   x6, 0(x10)         # x6 = mem[0] (we'll preload mem[0] = 42)
    add  x7, x6, x5         # x7 = 42 + 14 = 56 (must stall 1 cycle if no early bypass)

    # --- Branch taken ---
    beq  x7, x7, taken      # always taken

not_taken:
    addi x8, x0, 1          # should be skipped when branch is taken
    jal  x0, done

taken:
    addi x8, x0, 2          # executed because branch taken
    # --- Branch not taken ---
    bne  x7, x7, not_taken  # never taken

done:
    jal  x0, done           # tight loop for waveform capture
