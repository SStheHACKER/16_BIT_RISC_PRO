`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 18:27:30
// Design Name: 
// Module Name: MUX_6_to_1
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
module MUX_6_to_1 (
    input wire [15:0] A0,    // 16-bit input A0
    input wire [15:0] A1,    // 16-bit input A1
    input wire [15:0] A2,    // 16-bit input A2
    input wire [15:0] A3,    // 16-bit input A3
    input wire [15:0] A4,    // 16-bit input A4
    input wire [15:0] A5,    // 16-bit input A5
    input wire [2:0] S,      // 3-bit select signal
    output reg [15:0] Op     // 16-bit output Op
);

    always @(*) begin
        case (S)
            3'b000: Op = A0;   // When S is 000, Op gets A0
            3'b001: Op = A1;   // When S is 001, Op gets A1
            3'b010: Op = A2;   // When S is 010, Op gets A2
            3'b011: Op = A3;   // When S is 011, Op gets A3
            3'b100: Op = A4;   // When S is 100, Op gets A4
            3'b101: Op = A5;   // When S is 101, Op gets A5
            default: Op = 16'b0;  // Default case (if S is any other value)
        endcase
    end

endmodule

