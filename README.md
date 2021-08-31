[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=5468091&assignment_repo_type=AssignmentRepo)

# An introduction to RISC-V in TL-Verilog using Makerchip

This repository gives a strong overview of the toolchain for RISC-V and 2 easier pipelined examples due to TL-Verilog.

1. Commands to help compile, simulate, disassemble and debug in Linux using RISC-V's toolchain
2. A pipelined calculator with validity and recall for four basic operations: addition, subtraction, multiplication and division
3. A 5 stage RISC-V pipelined processor that supports most of RV32I instructions

# What is RISC-V?
RISC-V is an open standard ISA based on RISC principles. It is open, simple, modular, extensible, stable and supported in several software toolchains.

## Benefits of RISC-V
1. Free and open source which allows for easy collaboration
2. Small and easier to implement than most commercial ISAs
5. Multiple standard and optional extensions, and allows custom ones
4. Base and first standard instructions frozen so no major updates and stable

## RISC-V Toolchain 
The toolchain covers the flow from compilation to debug.

1. Compilation of C program to Object ->
`riscv64-unknown-elf-gcc -<compiler: O1, Ofast> -mabi=<ABI: lp32, lp64> -march=<architecture: RV32, RV64> -o <object filename> <C program filename>`

2. Simulation of Object ->
`spike pk <object filename>`

3. Disassembling of Object to Assembly ->
`riscv64-unknown-elf-objdump -d <object filename>`

4. Debug of Object ->
`spike -d pk <object filename>`



Examples: [Compilation and Simulation](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_aug21-varghese-rahul-1/blob/master/Day2/compile_simulate.PNG) |
[Disassembly](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_aug21-varghese-rahul-1/blob/master/Day2/disassemble.PNG) |
[Debug](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_aug21-varghese-rahul-1/blob/master/Day2/debug.png)

# Application Binary Interface (ABI)

An application program interacts with multiple low level layers of program to interact with the hardware. The ABI is one such interface and allows for the access of the hardware resources of the processor: the registers of the RISC-V architecture. It does so via system calls through the operating system or directly. Thus, an application and assembly program can be compiled together to create an object file. The RISC-V specification has 32 registers specified using 5 bits.

![This is an image](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_aug21-varghese-rahul-1/blob/master/Day2/ABI.PNG)

# RTL Design in TL-Verilog using Makerchip

Transaction-level Verilog (TL-Verilog) allows for high level models to be composed quickly. It allows for timing abstraction, simpler pipeling and the easy conversion to Verilog/SystemVerilog. Also, it removes a lot of constructs including always blocks in favor of more effective ones. 

Makerchip is an environment that allows you to code, compile, simulate and debug Verilog designs online. The code, block diagrams, waveforms, and novel visualization capabilities are tightly integrated.

More information can be found at [Redwood EDA TL-Verilog](https://www.redwoodeda.com/tl-verilog) and [Makerchip](https://www.makerchip.com/).

![This is an image](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_aug21-varghese-rahul-1/blob/master/Day2/makerchip.PNG)

## Pipelined Calculator 

1. A combinational calculator was setup which has no concept of state and two random input values. Four basic operations were implemented: addition, subtraction, multiplication and division and connected to a 4 input multiplexer.
2. A sequential calculator was then made by adding a flipflop at the end of the result using `>>1` which signifies lookahead 1, and connecting it back to one input. 
3. The calculator was pipelined right before the mux using `@1, @2 and |calc`, and a counter was used as an oscillator to generate a valid signal which was passed to the mux to calculate the output only every other cycle. 
4. An alternative to this form of validity was implemented by using `?$signal_name` which allowed for the creaton of valid signals. Another stage was added using `@0` and the reset and valid signals were implemented there. The signal was valid when there was reset or if the oscillatory behavior happened. `?$valid_or_reset` was used. 
5. Finally, single value memory functionality was added by extending the op code to 3 bits to support memory recall in the original mux and a memory mux. The memory mux can also grab the updated output.

The complete TL-Verilog code implementation in Makerchip can be found [here](https://myth3.makerchip.com/sandbox/0XDfnhQOQ/0BghPjx#)

![This is an image](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_aug21-varghese-rahul-1/blob/master/Day2/calculator.PNG)

## Pipelined 5 stage RISC-V CPU

The 5 stage pipeline shown in the schematic below is implemented.

![This is an image](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_aug21-varghese-rahul-1/blob/master/Day2/Final_Implementation.PNG)

1. `@0`, the program counter value is chosen depending on whether a branch is taken, a particular jump or load happens or reset happens. The instruction memory is enabled as long as reset is 0 and from the counter we get the address that is fed to this memory.
2. `@1`, the program counter gets incremented by 4 bytes to move to a new instruction by default. The data that is read from the instruction memory is fed to the decode. Using [6:2], the type of instruction is determined: I, S, R, U, B and J. Then the immediate value, $imm is extracted using different bits depending on the type. rs2, rs1, rd, funct7, funct3, and opcode validity are determined using the instruction types. Once a valid signal is generated for these fields, the appropriate bits are assigned to them. Following that, the decode bits which determine which instruction is being passed are determined using {funct7[5] ,$funct3, $opcode}. For the case of load, the opcode is only used because all 5 types of loads are treated equivalent to lw. 
3. `@2`, the register file allows two reads and one write. Read is enabled when the source signals are valid and the sources, $rs1 and $rs2 are then passed as addresses. When data is read from the two ports, they are fed into the ALU normally. [*However, to avoid a read after write hazard, the register file write is checked using >>1 to see if write was enabled and if $rd is equal to $rs1/$rs2. If that is the case, the register is bypassed by passing in the result of the ALU >>1 instead.*] Moreover, the target branch address is computed by adding $pc to $imm.
4. `@3`, depending on the instruction, the appropriate operations are performed in the ALU and stored in result. $taken_br is calculated by checking through the 5 branch instructions' conditions. For the register file write, write is enabled when the destination, rd is valid, when rd isn't 0 because write should be disabled, and when the valid signal is asserted or when >>2$valid_load is asserted. $valid_taken_br = $valid && $taken_br and the same logic applies to load. [*$valid is when (>>1 or >>2) valid_taken_br or valid_load are not taken. This invalidates the next two instructions and solves the control hazard.*] Jump happens when it's jal or jalr. Valid jump has the previous logic, jal has the same logic as target branch address, and jalr target pc is $src1_value of the ALU and $imm. [*If >>2$valid_load is invalid, then rd and result are chosen for write address and data, otherwise >>2$rd and >>2$ld_data are chosen.This load redirect solves the problem of load_data only being available two cycles after register write.*]
5. `@4`, for the data memory, read and write are enabled for a valid load and valid store respectively. [5:2] of result determines the address for load and store, and if it is a write $src2_value is written. 
6. `@5`, the data read from this memory is passed in ld_data. The RISC-V CPU can now be tested via the assembly program for sum of integers from 1 to 9, by storing the result in xreg[17]. This verification is done using `*passed = |cpu/xreg[17]>>5$value == (1+2+3+4+5+6+7+8+9)`.

The complete TL-Verilog code implementation in Makerchip can be found [here](https://myth3.makerchip.com/sandbox/0XDfnhQOQ/0Q1hBOy)

![This is an image](https://github.com/RISCV-MYTH-WORKSHOP/riscv_myth_workshop_aug21-varghese-rahul-1/blob/master/Day2/riscv.PNG)

# Future Work
















