`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2025 18:33:57
// Design Name: 
// Module Name: ALU
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


module ALU(
 input [15:0] ALU_A,
 input [15:0] ALU_B,
 input [3:0] ALU_OP,
 output reg [15:0] ALU_C,
 input ALU_Z,
 input ALU_C1,
 output reg ALU_Carry,
 output reg ALU_Zero,
 input clk

    );
    
    
     // NAND Function
 function [15:0] NAND_16;
 input [15:0] A, B;
 integer i;
 begin
 for (i = 0; i < 16; i = i + 1) begin
 NAND_16[i] = ~(A[i] & B[i]);
 end
 end
 endfunction
 // ADD Function
 function [16:0] ADD_16;
 input [15:0] A, B;
 reg [16:0] C;
 integer i;
 begin
 C = 17'b0;
 for (i = 0; i < 16; i = i + 1) begin
 ADD_16[i] = A[i] ^ B[i] ^ C[i];
 C[i + 1] = (A[i] & C[i]) | ((A[i] ^ C[i]) & B[i]);
 end
 ADD_16[16] = C[16];
 end
 endfunction
 
 // ADD with Carry Function
 function [16:0] AWC_16;
 input [15:0] A, B;
 input Carry;
 reg [16:0] C;
 integer i;
 begin
 C[0] = Carry;
 for (i = 0; i < 16; i = i + 1) begin
 AWC_16[i] = A[i] ^ B[i] ^ C[i];
 C[i + 1] = (A[i] & C[i]) | ((A[i] ^ C[i]) & B[i]);
 end
 AWC_16[16] = C[16];
 end
 endfunction
 // LMSM Function

function [15:0] LMSM;
 input [15:0] A, B; // A = Start Address, B = Immediate Field (register selection)
 integer i;
 begin
 LMSM = A; // Initialize with start address
 for (i = 7; i >= 0; i = i - 1) begin // Start from bit 7 (R7) and move downward
 if (B[i] == 1'b1) begin
 LMSM = A; // Use current address for selected register
 A = A + 1; // Increment address for the next selected register
 end
 end
 end
endfunction
 reg [16:0] add16_out, awc16_out;
 
 always @(posedge clk) begin
 case (ALU_OP)
 4'b0000: begin // ADD
 add16_out = ADD_16(ALU_A, ALU_B);
 ALU_C = add16_out[15:0];
 ALU_Carry = add16_out[16];
 ALU_Zero = (add16_out[15:0] == 16'b0) ? 1'b1 : 1'b0;
 end
 4'b0001: begin // ADD With complement
 awc16_out = AWC_16(ALU_A, ALU_B, ALU_C1);
 ALU_C = awc16_out[15:0];
 ALU_Carry = awc16_out[16];
 ALU_Zero = (awc16_out[15:0] == 16'b0) ? 1'b1 : 1'b0;
 end
 4'b0010: begin // ADD with Complement
 add16_out = ADD_16(ALU_A, ~ALU_B);
 ALU_C = add16_out[15:0];
 ALU_Carry = add16_out[16];
 ALU_Zero = (add16_out[15:0] == 16'b0) ? 1'b1 : 1'b0;
 end
 4'b0011: begin // ADD with Complement and Carry
 awc16_out = AWC_16(ALU_A, ~ALU_B, ALU_C1);
 ALU_C = awc16_out[15:0];
ALU_Carry = awc16_out[16];
 ALU_Zero = (awc16_out[15:0] == 16'b0) ? 1'b1 : 1'b0;
 end
 4'b0100: begin // NAND
 ALU_C = NAND_16(ALU_A, ALU_B);
 ALU_Carry = ALU_C1;
 ALU_Zero = (ALU_C == 16'b0) ? 1'b1 : 1'b0;
 end
 4'b0101: begin // NAND with A and complement of B
 ALU_C = NAND_16(ALU_A, ~ALU_B);
 ALU_Carry = ALU_C1;
 ALU_Zero = (ALU_C == 16'b0) ? 1'b1 : 1'b0;
 end
 4'b0110: begin // BEQ
 ALU_C = (ALU_A == ALU_B) ? 16'b1 : 16'b0;
 ALU_Carry = ALU_C1;
 ALU_Zero = ALU_Z;
 end
 4'b0111: begin // BLT
 ALU_C = (ALU_A < ALU_B) ? 16'b1 : 16'b0;
 ALU_Carry = ALU_C1;
 ALU_Zero = ALU_Z;
 end
 4'b1000: begin // BLE
 ALU_C = (ALU_A <= ALU_B) ? 16'b1 : 16'b0;
 ALU_Carry = ALU_C1;
 ALU_Zero = ALU_Z;
 end
 4'b1110: begin // LMSM
 ALU_C = LMSM(ALU_A, ALU_B);
 ALU_Carry = ALU_C1;
 ALU_Zero = ALU_Z;
 end
 4'b1001: begin // LLI
 ALU_C = ALU_B;
 ALU_Carry = ALU_C1;
 ALU_Zero = ALU_Z;
 end
 default: begin
 ALU_C = 16'b0;
 ALU_Carry = ALU_C1;
 ALU_Zero = ALU_Z;
 end
 endcase
 end
endmodule
