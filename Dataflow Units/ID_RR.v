`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 17:44:00
// Design Name: 
// Module Name: ID_RR
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


module ID_RR (
    input wire clk,
    input wire ID_RR_EN, 
    input wire ID_RR_CLR,
    input wire [2:0] RB_ADD_IN,
    input wire [2:0] RC_ADD_IN,
    input wire [2:0] RA_ADD_IN,
    input wire [15:0] PC_2_IN,
    input wire [15:0] PC_2xIMM_IN,
    input wire [15:0] IMM_SE,
    input wire [15:0] IR_IN,
    output reg [2:0] RA_ADD_OUT,
    output reg [2:0] RB_ADD_OUT,
    output reg [2:0] RC_ADD_OUT,
    output reg [15:0] PC_2xIMM_OUT,
    output reg [15:0] PC_2_OUT,
    output reg [15:0] SE_2xIMM,
    output reg [15:0] IR_OUT
);

    // Internal signals
    reg [2:0] RA_ADD, RB_ADD, RC_ADD;
    reg [15:0] IMM_SE_dummy, PC_2, PC_2xIMM, IR;

    always @(posedge clk or posedge ID_RR_CLR) begin
        if (ID_RR_CLR) begin
            // Reset condition
            IR <= 16'b1011000010110000;
            PC_2 <= 16'b0;
            PC_2xIMM <= 16'b0;
            IMM_SE_dummy <= 16'b0;
            RA_ADD <= 3'b000;
            RB_ADD <= 3'b000;
            RC_ADD <= 3'b000;
        end else if (ID_RR_EN) begin
            // Latching inputs when enabled
            IR <= IR_IN;
            PC_2 <= PC_2_IN;
            PC_2xIMM <= PC_2xIMM_IN;
            IMM_SE_dummy <= IMM_SE;
            RA_ADD <= RA_ADD_IN;
            RB_ADD <= RB_ADD_IN;
            RC_ADD <= RC_ADD_IN;
        end
    end

    // Assigning the output values
    always @(posedge clk) begin
        if (ID_RR_EN) begin
            RA_ADD_OUT <= RA_ADD;
            RB_ADD_OUT <= RB_ADD;
            RC_ADD_OUT <= RC_ADD;
            PC_2_OUT <= PC_2;
            PC_2xIMM_OUT <= PC_2xIMM;
            SE_2xIMM <= IMM_SE_dummy;
            IR_OUT <= IR;
        end
    end

endmodule

