[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=5468091&assignment_repo_type=AssignmentRepo)

# RISC-V pipelining in TL-Verilog using Makerchip

This repository gives a strong overview of the Linux environment for RISC-V and has pipelined examples.

1. Linux instructions to help compile, disassemble, simulate and debug using RISC-V's toolchain
2. A pipelined calculator with validity and recall for four basic operations: addition, subtraction, multiplication and division
3. A 4 stage RISC-V pipelined processor that supports most of RV32I instructions

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










