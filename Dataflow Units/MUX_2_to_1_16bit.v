`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 17:36:36
// Design Name: 
// Module Name: MUX_2_to_1_16bit
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


module MUX_2_to_1_16bit (
    input  wire [15:0] A0,
    input  wire [15:0] A1,
    input  wire S,
    output reg  [15:0] Op
);

always @(*) begin
    case (S)
        1'b0: Op = A0;
        1'b1: Op = A1;
        default: Op = 16'b0; // Default case to prevent latches
    endcase
end

endmodule

