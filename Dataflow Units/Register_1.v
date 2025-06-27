`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2025 18:55:33
// Design Name: 
// Module Name: Register_1
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


module Register_1 (
    input wire DIN,
    input wire CLK,
    input wire WE,
    output reg DOUT
);

    always @(posedge CLK) begin
        if (WE == 1'b1) begin
            DOUT <= DIN;  // Store input in output when write enable is high
        end
    end

endmodule

