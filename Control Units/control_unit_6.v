`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2025 19:13:58
// Design Name: 
// Module Name: control_unit_6
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


module control_unit_6(
input wire clk,
    input wire [15:0] IF_ID_IR, ID_RR_IR, RR_EX_IR, EX_MEM_IR, MEM_WB_IR,
   output reg  MUX_MEMDOUT_SEL
    );
    wire [3:0] opcode;   // Extract opcode from MEM_WB_IR
    assign opcode= MEM_WB_IR[15:12];
  always @(posedge clk) begin
   
  

    // Check opcode for LW or LM
    if (opcode == 4'b0100 || opcode == 4'b0110) begin
        MUX_MEMDOUT_SEL <= 1'b1; // Select MEM_DOUT
    end else begin
        MUX_MEMDOUT_SEL <= 1'b0; // Select ALU_C
    end
    // 1 and zero shayad interchange
    
end
endmodule
