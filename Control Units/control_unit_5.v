`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2025 19:07:32
// Design Name: 
// Module Name: control_unit_5
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


module control_unit_5(
input clk,
input wire [15:0] IF_ID_IR, ID_RR_IR, RR_EX_IR, EX_MEM_IR, MEM_WB_IR,
output reg MEM_WB_EN,
output reg MEM_WR_EN
    );
    
    wire [3:0] opcode;   // Extract opcode from MEM_WB_IR
    assign opcode= EX_MEM_IR[15:12];
     always @(posedge clk) begin
   
    

    MEM_WB_EN <= 1'b1; // Default enable

    // Check opcode for SM or SW
    if (opcode == 4'b0101 || opcode == 4'b0111) begin
        MEM_WR_EN <= 1'b1;
    end else begin
        MEM_WR_EN <= 1'b0;
    end
end

endmodule
