# 🧠 16-Bit RISC-Based Pipelined Processor

A 16-bit RISC processor with a custom instruction set architecture (ISA), designed and implemented using Verilog HDL. This project features a **6-stage pipeline**, **hazard mitigation**, and a functional verification suite built on **Xilinx Vivado**.


---
![image](https://github.com/user-attachments/assets/c165bae5-0e07-4e60-bb74-727b314dda6c)

## 🚀 Features

### 🔧 Custom 16-bit RISC Architecture
A lightweight, custom-designed Reduced Instruction Set Computing (RISC) processor capable of executing 14 essential instructions tailored for embedded and educational applications.

Supported instruction categories include:

- **Arithmetic Operations**: `ADD`, `SUB`  
  Perform basic integer operations using register-based operands.

- **Logical Operations**: `AND`, `OR`, `NOT`, `XOR`  
  Enable bitwise logic computations within the ALU.

- **Data Transfer**: `LD` (Load), `ST` (Store)  
  Support memory interaction for loading data into and storing data from registers.

- **Control Flow Instructions**: `BEQ` (Branch if Equal), `BNE` (Branch if Not Equal), `JUMP`  
  Facilitate program control and decision-making through conditional and unconditional branching.

This custom ISA ensures clarity, simplicity, and efficient hardware implementation while covering essential functionality.

---

### ⛓️ 6-Stage Pipeline Architecture

To enhance instruction throughput and mimic modern processor behavior, the CPU is designed with a **6-stage pipeline**. Each instruction progresses through the following stages:

1. **Instruction Fetch (IF)**  
   Retrieves the next instruction from program memory.

2. **Instruction Decode (ID)**  
   Decodes the instruction opcode and determines the required control signals.

3. **Register Read (RR)**  
   Reads data from the register file based on the instruction’s source operands.

4. **Execute (EX)**  
   Performs arithmetic or logical operations using the ALU.

5. **Memory Access (MEM)**  
   Loads from or stores data to memory if required by the instruction.

6. **Write Back (WB)**  
   Writes the result back into the destination register.

This pipeline structure enables **instruction-level parallelism**, significantly improving overall performance compared to a single-cycle design. Proper hazard detection and stall mechanisms are implemented to ensure correctness during pipeline execution.

---


### 🧪 **Simulation & Testing**
  - Functionality verified through **testbenches**.
  - Simulated and tested using **Xilinx Vivado** to ensure performance and correctness.
---
## 🧩 Modules
- Control Unit - It controls how the input are processed by the processor to perform the required operation as defined by the instruction sets. The image given below is the how the Control Unit is connected in the main processor unit (CPU).
Note - For a detailed, view please refer to `Controller_Schematic.pdf`.
![image](https://github.com/user-attachments/assets/be6a420f-8e39-43d1-9599-280b74be233b)
- Dataflow - Based on the instructions sets, it is responsible fro performing multiple operations in the processor which is a 6 pipelined structure as above. Instructions are passed through this part of processor and the operation is performed. The image given below is the how the Control Unit is connected in the main processor unit (CPU).
Note - For a detailed, view please refer to `Dataflow_Schematic.pdf`.
![image](https://github.com/user-attachments/assets/34698b29-6878-41de-8430-adc4aa36da32)
- Below is the a testbench which is simualated on the Xilinx Vivado. 
![Screenshot 2025-06-28 030147](https://github.com/user-attachments/assets/820c42cd-f29f-42fe-81ff-94bd1243a8d5)


---

## 🛠️ Tools & Technologies

- **Verilog HDL**
- **Xilinx Vivado 2024**

---
## 🔭 Future Enhancements
- **Hazard Mitigation**
  - Implemention of  mechanisms to handle **data hazards** and **control hazards**.
-  **Adding custom instruction sets**

