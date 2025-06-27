`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2025 22:18:03
// Design Name: 
// Module Name: update_prev_carry
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


module update_prev_carry(
input clk,
input wire New_Carry,New_Zero,
output reg [2:0] prev3carry,
    output reg [2:0] prev3zero
    );
    
    always @(posedge clk) begin
    // Shift the carry values
    prev3carry[2:1] <= prev3carry[1:0];
    prev3carry[0] <= New_Carry;

    // Shift the zero values
    prev3zero[2:1] <= prev3zero[1:0];
    prev3zero[0] <= New_Zero;
end
endmodule
