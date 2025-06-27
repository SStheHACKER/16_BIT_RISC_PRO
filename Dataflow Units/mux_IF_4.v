`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2025 18:20:37
// Design Name: 
// Module Name: mux_IF_4
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


module mux_IF_4(
    input wire [15:0] ALU_2C, // Input 0
    input wire [15:0] ALU3_C, // Input 1
    input wire [15:0] RB_RR_EX, // Input 2
    input wire [15:0] ALU1_C, // Input 3
    input wire [1:0] S,   // 2-bit select line
    output reg [15:0] Op  // Output
    );
    always @(*) begin
        case (S)
            2'b00: Op = ALU_2C; // Select input A0
            2'b01: Op = ALU3_C; // Select input A1
            2'b10: Op = RB_RR_EX; // Select input A2
            2'b11: Op = ALU1_C; // Select input A3
            default: Op = 16'b0; // Default case (optional)
        endcase
    end
    
endmodule
