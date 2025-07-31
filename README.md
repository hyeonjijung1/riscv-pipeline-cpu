# 5-Stage RV32I Pipelined RISC-V CPU Core

A modular, synthesizable CPU core implementing the RV32I ISA in Verilog with a classic 5-stage pipeline and basic hazard handling. Demonstrates IF, ID, EX, MEM, and WB stages, with an inline instruction ROM and IF/ID registers.

---

##  Features

- **5-Stage Pipeline**: IF → ID → EX → MEM → WB  
- **RV32I Instruction Set**: `ADDI`, `ADD`, `SUB`, `LW`, `SW`, `BEQ`, `JAL`  
- **Hazard Handling**: Basic forwarding and stall insertion  
- **Inline Instruction ROM**: No external `.hex` required  
- **Waveform Demo**: Captured entirely in GTKWave via EDA-Playground  

---

## Folder Structure

    riscv-pipeline-cpu/
    ├── src/                 # Verilog source modules
    │   ├── pc.v             # Program Counter
    │   ├── instruction_mem.v# Inline Instruction ROM
    │   ├── if_id_regs.v     # IF/ID pipeline register
    │   ├── cpu_top.v        # Top-level IF stage module
    │   └── ...              # (future: ID/EX, EX/MEM, MEM/WB registers)
    ├── docs/                # Diagrams & waveforms
    │   └── gtk_waveform.png # IF stage waveform capture
    └── README.md            # Project overview (this file)

---
##  Waveforms 


- Captured from EDA-Playground’s GTKWave showing program counter, fetched instruction, and IF/ID registers over time:

- ![IF Stage Waveform](docs/if_stage_waveform.png)
---
##  How to Demo

 **Open in EDA-Playground** (no local tools required)  
   - Use Icarus Verilog + GTKWave configuration  
   - Paste the **entire Verilog design + testbench** into the left pane  
   - Run and capture the waveform  


