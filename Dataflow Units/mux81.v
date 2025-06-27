`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 18:13:48
// Design Name: 
// Module Name: mux81
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


module mux81 (
    input wire [15:0] A0, A1, A2, A3, A4, A5, A6, A7,  // 16-bit input vectors
    input wire [2:0] S,                               // 3-bit select input
    output reg [15:0] Op                               // 16-bit output
);

    always @(*) begin
        case (S)
            3'b000: Op = A0;
            3'b001: Op = A1;
            3'b010: Op = A2;
            3'b011: Op = A3;
            3'b100: Op = A4;
            3'b101: Op = A5;
            3'b110: Op = A6;
            3'b111: Op = A7;
            default: Op = 16'b0;  // default case for safety, though it shouldn't reach here
        endcase
    end

endmodule

