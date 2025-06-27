`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 16:53:22
// Design Name: 
// Module Name: IF_ID
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


module IF_ID (
    input wire clk,
    input wire IF_ID_EN,
    input wire IF_ID_CLR,
    input wire [15:0] PC_IN,
    input wire [15:0] PC_2_IN,
    input wire [15:0] IM_DATA_IN,
    output reg [2:0] RA_ADD,
    output reg [2:0] RB_ADD,
    output reg [2:0] RC_ADD,
    output reg [5:0] IMM_6,
    output reg [8:0] IMM_9,
    output reg [15:0] PC_OUT,
    output reg [15:0] PC_2_OUT,
    output reg [15:0] IM_DATA_OUT
);

    // Internal registers
    reg [15:0] PC = 16'b0;
    reg [15:0] PC_2 = 16'b0;
    reg [15:0] IM_data = 16'b0;

    always @(posedge clk) begin
        if (IF_ID_EN) begin
            PC <= PC_IN;
            PC_2 <= PC_2_IN;
            IM_data <= IM_DATA_IN;
        end

        if (IF_ID_CLR) begin
            PC <= 16'b0;
            PC_2 <= 16'b0;
            IM_data <= 16'b1011000010110000;
        end

        // Assign outputs on clock edge
        RA_ADD <= IM_data[11:9];
        RB_ADD <= IM_data[8:6];
        RC_ADD <= IM_data[5:3];
        IMM_6 <= IM_data[5:0];
        IMM_9 <= IM_data[8:0];
        PC_OUT <= PC;
        PC_2_OUT <= PC_2;
        IM_DATA_OUT <= IM_data;
    end
endmodule

