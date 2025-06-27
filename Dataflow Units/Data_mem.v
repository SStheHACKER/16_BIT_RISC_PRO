`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2025 18:49:49
// Design Name: 
// Module Name: Data_mem
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


module Data_mem(
input clk, // Clock signal
 input [15:0] Mem_add, Din, // 16-bit memory address and data input
 output reg [15:0] Dout, // 16-bit data output
 input Enable // Enable signal
    );
    // Memory declaration: 65536 locations, 8 bits each
(* rom_style = "block" *) reg [7:0] mem [0:1023];
// Initialize memory (Optional, only for simulation purposes)
initial begin
 mem[1] = 8'b00000000;
 mem[2] = 8'b00000000;
end
// Write Process
always @(posedge clk) begin
 if (Enable) begin
 mem[Mem_add] <= Din[15:8]; // Upper 8 bits written at address Mem_add
 mem[Mem_add+1] <= Din[7:0]; // Lower 8 bits written at address Mem_add+1
 end
end
// Read Process
always @(*) begin
 Dout <= {mem[Mem_add], mem[Mem_add+1]}; // Read two 8-bit locations and concatenate
end
 
endmodule
