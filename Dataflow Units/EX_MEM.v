`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2025 18:46:33
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
input clk, EX_MEM_EN, EX_MEM_CLR, // Clock, Enable, and Clear signals
 input [2:0] DEST_IN, // 3-bit Destination Input
 input [15:0] RA_IN, // 16-bit RA Input
 input [15:0] ALU_C_IN, // 16-bit ALU Result Input
 input [15:0] PC_2_IN, // 16-bit PC+2 Input
 input [15:0] IR_IN, // 16-bit Instruction Register Input
 output reg [2:0] DEST_OUT, // 3-bit Destination Output
 output reg [15:0] RA_OUT, // 16-bit RA Output
 output reg [15:0] ALU_C_OUT, // 16-bit ALU Result Output
 output reg [15:0] PC_2_OUT, // 16-bit PC+2 Output
 output reg [15:0] IR_OUT // 16-bit Instruction Register Output
    );
    // Internal signals
reg [2:0] DEST = 3'b000;
reg [15:0] ALU_C = 16'b0000000000000000;
reg [15:0] RA = 16'b0000000000000000;
reg [15:0] PC_2 = 16'b0000000000000000;
reg [15:0] IR = 16'b0000000000000000;
// Process logic
always @(posedge clk) begin
 if (EX_MEM_EN) begin
 IR <= IR_IN;
 PC_2 <= PC_2_IN;
 ALU_C <= ALU_C_IN;
 RA <= RA_IN;
 DEST <= DEST_IN;
 end
 if (EX_MEM_CLR) begin
 IR <= 16'b1011000010110000;
 PC_2 <= 16'b0000000000000000;
 RA <= 16'b0000000000000000;
 ALU_C <= 16'b0000000000000000;
 DEST <= 3'b000;
 end
 // Update Outputs on rising edge
 ALU_C_OUT <= ALU_C;
 RA_OUT <= RA;
 PC_2_OUT <= PC_2;
 DEST_OUT <= DEST;
 IR_OUT <= IR;
end
endmodule

