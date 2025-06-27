`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2025 18:54:08
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB (
    input wire clk,              // Clock signal
    input wire MEM_WB_EN,        // Enable signal
    input wire MEM_WB_CLR,       // Clear signal
    input wire [2:0] DEST_IN,    // Input destination register address (3 bits)
    input wire [15:0] ALU_C_IN,  // Input ALU result (16 bits)
    input wire [15:0] D_OUT_IN,  // Input data from memory (16 bits)
    input wire [15:0] PC_2_IN,   // Input PC+2 value (16 bits)
    input wire [15:0] IR_IN,     // Input instruction (16 bits)
    
    output reg [15:0] PC_2_OUT,  // Output PC+2 value (16 bits)
    output reg [15:0] D_OUT_OUT, // Output data from memory (16 bits)
    output reg [15:0] ALU_C_OUT, // Output ALU result (16 bits)
    output reg [2:0] DEST_OUT,   // Output destination register address (3 bits)
    output reg [15:0] IR_OUT     // Output instruction (16 bits)
);

    // Internal signals to hold the values before they are written out
    reg [2:0] DEST;      // Destination register address (3 bits)
    reg [15:0] ALU_C;    // ALU result (16 bits)
    reg [15:0] D_OUT;    // Data from memory (16 bits)
    reg [15:0] PC_2;     // PC+2 value (16 bits)
    reg [15:0] IR;       // Instruction (16 bits)
    
    always @(posedge clk or posedge MEM_WB_CLR) begin
        if (MEM_WB_CLR) begin
            // Clear the pipeline register
            IR <= 16'b1011000010110000;   // Set IR to a specific value (likely a reset value)
            PC_2 <= 16'b0000000000000000; // Clear PC_2
            D_OUT <= 16'b0000000000000000; // Clear Data_out
            ALU_C <= 16'b0000000000000000; // Clear ALU result
            DEST <= 3'b000;               // Clear destination register address
        end
        else if (MEM_WB_EN) begin
            // Store inputs in internal registers when MEM_WB_EN is high
            IR <= IR_IN;
            PC_2 <= PC_2_IN;
            ALU_C <= ALU_C_IN;
            D_OUT <= D_OUT_IN;
            DEST <= DEST_IN;
        end
    end

    // Assign the internal signals to the output ports
    always @(posedge clk) begin
        D_OUT_OUT <= D_OUT;
        ALU_C_OUT <= ALU_C;
        PC_2_OUT <= PC_2;
        DEST_OUT <= DEST;
        IR_OUT <= IR;
    end

endmodule
