`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 17:50:43
// Design Name: 
// Module Name: LMSM
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

module LMSM (
    input wire [15:0] IMM_IN,      // 16-bit input IMM_IN
    output wire [2:0] PENC_OP,     // 3-bit output PENC_OP
    output wire [15:0] IMM_OP,     // 16-bit output IMM_OP
    output reg IS_IMM_ZERO         // Output IS_IMM_ZERO (1-bit)
);

    // Function to perform the PENC operation
    function [18:0] PENC;
        input [15:0] imm;
        reg [18:0] ret;
        reg [15:0] imm_out;
        integer i;
        begin
            imm_out = imm;
            ret = 19'b0;

            for (i = 0; i < 8; i = i + 1) begin
                if (imm[i] == 1'b1) begin
                    ret = { (7 - i), imm_out[15:0] }; // set PENC result and clear the bit in imm_out
                    imm_out[i] = 1'b0;
                end
            end
            PENC = {imm_out, ret[2:0]}; // concatenate imm_out and ret[2:0]
        end
    endfunction

    // Internal signal to store PENC result
    wire [18:0] penc_out;

    // Assign PENC result
    assign penc_out = PENC(IMM_IN);
    assign PENC_OP = penc_out[2:0];      // Lower 3 bits of PENC result
    assign IMM_OP = penc_out[18:3];      // Upper 16 bits of PENC result
    
    // Process to check if IMM_IN is zero
    always @(*) begin
        if (IMM_IN == 16'b0) begin
            IS_IMM_ZERO = 1'b1;
        end else begin
            IS_IMM_ZERO = 1'b0;
        end
    end

endmodule

