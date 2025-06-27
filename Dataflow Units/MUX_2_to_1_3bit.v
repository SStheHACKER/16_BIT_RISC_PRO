`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 18:21:33
// Design Name: 
// Module Name: MUX_2_to_1_3bit
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


module MUX_2_to_1_3bit (
    input wire [2:0] A0,    // 3-bit input A0
    input wire [2:0] A1,    // 3-bit input A1
    input wire S,           // 1-bit select signal
    output reg [2:0] Op     // 3-bit output Op
);

    always @(*) begin
        case (S)
            1'b0: Op = A0;   // When S is 0, Op gets A0
            1'b1: Op = A1;   // When S is 1, Op gets A1
            default: Op = 3'b000; // Default case (although not expected to reach this point)
        endcase
    end

endmodule
