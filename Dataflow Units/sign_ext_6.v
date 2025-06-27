`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 17:32:01
// Design Name: 
// Module Name: sign_ext_6
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


module sign_ext_6 (
    input  wire [5:0] SE_IN,
    output reg  [15:0] SE_OUT
);

always @(*) begin
    if (SE_IN[5] == 1'b0) begin
        SE_OUT = {10'b0000000000, SE_IN};
    end else begin
        SE_OUT = {10'b1111111111, SE_IN};
    end
end

endmodule

