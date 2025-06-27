`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 17:43:03
// Design Name: 
// Module Name: ALU23
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


module ALU23 (
    input wire [15:0] input1,
    input wire [15:0] input2,
    output reg [15:0] ALU_out
);

// Function to perform bitwise addition with carry
function [15:0] add;
    input [15:0] A, B;
    reg [16:0] C;  // Carry
    integer i;
    begin
        C = 17'b0;  // Initialize carry
        for (i = 0; i < 16; i = i + 1) begin
            ALU_out[i] = A[i] ^ B[i] ^ C[i];  // Sum bit
            C[i+1] = (A[i] & C[i]) | ((A[i] ^ C[i]) & B[i]);  // Carry bit
        end
        add = ALU_out;
    end
endfunction

// Always block to execute the addition
always @(*) begin
    ALU_out = add(input1, input2);
end

endmodule

