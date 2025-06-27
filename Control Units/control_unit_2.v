`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2025 21:38:04
// Design Name: 
// Module Name: control_unit_2
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


module control_unit_2(
input clk,
   input [15:0] IF_ID_IR,
    input [15:0] ID_RR_IR,
    input [15:0] RR_EX_IR,
    input [15:0] EX_MEM_IR,
    input [15:0] MEM_WB_IR,
    input is_sm1,
    output reg ID_RR_EN,
    output reg MUX_SE_SEL,
    output reg SH_EN,
    output reg MUX_SM_SEL
    );
        always @(posedge clk) begin
    // Default assignments
    ID_RR_EN <= 1'b1;

    // MUX_SE_SEL Logic
    if ((IF_ID_IR[15:12] == 4'b0011) || // LLI
        (IF_ID_IR[15:12] == 4'b0110) || // LM
        (IF_ID_IR[15:12] == 4'b0111) || // SM
        (IF_ID_IR[15:12] == 4'b1100) || // JAL
        (IF_ID_IR[15:12] == 4'b1111)) begin // JRI
        MUX_SE_SEL <= 1'b1;
    end else begin
        MUX_SE_SEL <= 1'b0; // Default: SE_6
    end

    // SH_EN Logic
    if ((IF_ID_IR[15:12] == 4'b1000) || // BEQ
        (IF_ID_IR[15:12] == 4'b1001) || // BLE
        (IF_ID_IR[15:12] == 4'b1010) || // BLT
        (IF_ID_IR[15:12] == 4'b1100) || // JAL
        (IF_ID_IR[15:12] == 4'b1111)) begin // JRI
        SH_EN = 1'b1;
    end else begin
        SH_EN <= 1'b0;
    end

    // MUX_SM_SEL Logic
    if (is_sm1 == 1'b1) begin
        MUX_SM_SEL <= 1'b1;
        ID_RR_EN <= 1'b0;
    end else begin
        MUX_SM_SEL <= 1'b0; // Default for non-SM situations
    end
end

endmodule
