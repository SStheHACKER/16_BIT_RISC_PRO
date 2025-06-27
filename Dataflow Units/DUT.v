`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2025 22:36:48
// Design Name: 
// Module Name: DUT
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DUT (
    input wire [0:0] input_vector,             // Single-bit input
    output wire [130:0] output_vector          // 131-bit output
);

    // Instantiate the CPU module
    CPU CPU_IITG_RISC (
        .clk(input_vector[0]),                 // Connect the clock
        .output_dummy(output_vector[130]),     // Map output_dummy to bit 130
        .Reg0(output_vector[129:114]),         // Map Reg0 to bits 129 to 114
        .Reg1(output_vector[113:98]),          // Map Reg1 to bits 113 to 98
        .Reg2(output_vector[97:82]),           // Map Reg2 to bits 97 to 82
        .Reg3(output_vector[81:66]),           // Map Reg3 to bits 81 to 66
        .Reg4(output_vector[65:50]),           // Map Reg4 to bits 65 to 50
        .Reg5(output_vector[49:34]),           // Map Reg5 to bits 49 to 34
        .Reg6(output_vector[33:18]),           // Map Reg6 to bits 33 to 18
        .Reg7(output_vector[17:2]),            // Map Reg7 to bits 17 to 2
        .Current_Zero_OUT(output_vector[1]),   // Map Current_Zero_OUT to bit 1
        .Current_Carry_OUT(output_vector[0])   // Map Current_Carry_OUT to bit 0
    );

endmodule

