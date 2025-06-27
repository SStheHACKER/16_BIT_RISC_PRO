# 🧠 16-Bit RISC-Based Pipelined Processor

A 16-bit RISC processor with a custom instruction set architecture (ISA), designed and implemented using Verilog HDL. This project features a **6-stage pipeline**, **hazard mitigation**, and a functional verification suite built on **Xilinx Vivado**.


---
![image](https://github.com/user-attachments/assets/c165bae5-0e07-4e60-bb74-727b314dda6c)

## 🚀 Features

- **Custom 16-bit RISC Architecture**  
  Designed to execute 14 well-defined instructions including:
  - Arithmetic operations (ADD, SUB)
  - Logical operations (AND, OR, NOT, XOR)
  - Load/Store (LD, ST)
  - Control flow (BEQ, BNE, JUMP)

- **6-Stage Pipeline Architecture**  
  The processor pipeline consists of:
  1. Instruction Fetch (IF)  
  2. Instruction Decode (ID)  
  3. Register Read (RR)  
  4. Execute (EX)  
  5. Memory Access (MEM)  
  6. Write Back (WB)

- **Simulation & Testing**
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

