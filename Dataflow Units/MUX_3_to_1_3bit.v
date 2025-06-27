`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 17:50:43
// Design Name: 
// Module Name: MUX_3_to_1_3bit
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


module MUX_3_to_1_3bit (
    input wire [2:0] A0,  // 3-bit input A0
    input wire [2:0] A1,  // 3-bit input A1
    input wire [2:0] A2,  // 3-bit input A2
    input wire [1:0] S,   // 2-bit select input
    output reg [2:0] Op   // 3-bit output
);

    always @(*) begin
        case (S)
            2'b00: Op = A0;   // Select A0 when S is "00"
            2'b01: Op = A1;   // Select A1 when S is "01"
            2'b10: Op = A2;   // Select A2 when S is "10"
            default: Op = 3'b000;  // Default case: output 000
        endcase
    end

endmodule

