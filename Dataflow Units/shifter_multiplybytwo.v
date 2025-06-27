`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 17:38:14
// Design Name: 
// Module Name: shifter_multiplybytwo
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


module shifter_multiplybytwo (
    input  wire [15:0] shift_in,
    input  wire SH_EN,
    output reg  [15:0] shift_out
);

always @(*) begin
    if (SH_EN == 1'b1) begin
        shift_out = {shift_in[14:0], 1'b0}; // Shift left by 1 (multiply by 2)
    end else begin
        shift_out = shift_in; // No shift when SH_EN is 0
    end
end

endmodule
