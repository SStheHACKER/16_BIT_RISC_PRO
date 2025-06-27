`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 18:29:14
// Design Name: 
// Module Name: RR_EX
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


module RR_EX (
    input wire clk,
    input wire RR_EX_EN,
    input wire RR_EX_CLR,
    input wire [2:0] DEST_IN,
    input wire [15:0] ALU_A_MUX_IN,
    input wire [15:0] ALU_B_MUX_IN,
    input wire [15:0] RA_IN,
    input wire [15:0] PC_2xIMM_IN,
    input wire [15:0] PC_2_IN,
    input wire [15:0] IR_IN,

    output reg [2:0] DEST_OUT,
    output reg [15:0] ALU_A_MUX_OUT,
    output reg [15:0] ALU_B_MUX_OUT,
    output reg [15:0] RA_OUT,
    output reg [15:0] PC_2xIMM_OUT,
    output reg [15:0] PC_2_OUT,
    output reg [15:0] IR_OUT
);

    reg [2:0] DEST;
    reg [15:0] ALU_A, ALU_B, RA, PC_2, PC_2xIMM, IR;

    always @(posedge clk or posedge RR_EX_CLR) begin
        if (RR_EX_CLR) begin
            // Clear all registers to their reset values
            IR <= 16'b1011000010110000;
            PC_2 <= 16'b0000000000000000;
            PC_2xIMM <= 16'b0000000000000000;
            RA <= 16'b0000000000000000;
            ALU_A <= 16'b0000000000000000;
            ALU_B <= 16'b0000000000000000;
            DEST <= 3'b000;
        end else if (RR_EX_EN) begin
            // Latch the inputs when RR_EX_EN is high
            IR <= IR_IN;
            ALU_B <= ALU_B_MUX_IN;
            PC_2 <= PC_2_IN;
            PC_2xIMM <= PC_2xIMM_IN;
            RA <= RA_IN;
            ALU_A <= ALU_A_MUX_IN;
            DEST <= DEST_IN;
        end
    end

    always @(posedge clk) begin
        // Output the latched values
        DEST_OUT <= DEST;
        ALU_A_MUX_OUT <= ALU_A;
        ALU_B_MUX_OUT <= ALU_B;
        PC_2_OUT <= PC_2;
        PC_2xIMM_OUT <= PC_2xIMM;
        RA_OUT <= RA;
        IR_OUT <= IR;
    end

endmodule

