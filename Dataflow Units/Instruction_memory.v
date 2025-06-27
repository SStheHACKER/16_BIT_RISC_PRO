`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2025 18:19:19
// Design Name: 
// Module Name: Instruction_memory
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


module Instruction_memory(
      input wire clk,
      input wire [15:0] address,
      output reg[15:0] IM_DATA
      
    );
    
    //memory size 2^16 locations and 8 bit wide data
    //8 bit data it is general practice for 16 bit architecture to have 8 bit wide data
    reg [7:0] mem[0:65535];
     integer i;
     initial begin
     // initializing  values randomly
    
     for(i=0;i<65536;i=i+1) begin
     mem[i]=8'b00010010;
     end
     end
         always @(address) begin
        // Read memory and combine two 8-bit values into a 16-bit value
        IM_DATA <= {mem[address], mem[address + 1]};
    end


endmodule
