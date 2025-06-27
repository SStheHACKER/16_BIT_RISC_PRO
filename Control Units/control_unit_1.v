`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2025 21:22:55
// Design Name: 
// Module Name: control_unit_1
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


module control_unit_1(
input clk,
input wire [15:0] IF_ID_IR, ID_RR_IR, RR_EX_IR, EX_MEM_IR, MEM_WB_IR,
 input wire Sign_Bit, IS_IMM_ZERO_LM, IS_IMM_ZERO_SM,
   output reg MEM_WB_CLR,
    output reg EX_MEM_CLR,
    output reg RR_EX_CLR,
    output reg ID_RR_CLR,
    output reg IF_ID_CLR,
    output reg IF_ID_EN,
    output reg RF_PC_EN,
    output reg [1:0] MUX_PC_SEL,
    output reg is_lm0,is_sm0
 
    );
    
    always @(posedge clk) begin
    // Default assignments
    MEM_WB_CLR <= 1'b0;
    EX_MEM_CLR <= 1'b0;
    RR_EX_CLR <= 1'b0;
    ID_RR_CLR <= 1'b0;
    IF_ID_CLR <= 1'b0;
    IF_ID_EN <= 1'b1;

  // lm and sm elsewhere
    if ((IF_ID_IR[15:12] == 4'b0110) || is_lm0 == 1'b1) begin // LM
        IF_ID_CLR <= 1'b1;
        is_lm0 <= 1'b1;
        RF_PC_EN <= 1'b0;
    end else if ((IF_ID_IR[15:12] == 4'b0111) || is_sm0 == 1'b1) begin // SM
        IF_ID_CLR <= 1'b1;
        is_sm0 <= 1'b1;
        RF_PC_EN <= 1'b0;
    end else if (MEM_WB_IR == 16'b1011000010110000) begin
        is_lm0 <= 1'b0;
    end else begin
        is_lm0 <= 1'b0;
        is_sm0 <= 1'b0;
        RF_PC_EN <= 1'b1; // PC_EN is ON by default
    end
  //nops for lm and sm later
    // LM and IMM is zero
    if ((RR_EX_IR[15:12] == 4'b0110) && (IS_IMM_ZERO_LM == 1'b1)) begin
        RR_EX_CLR <= 1'b1; // NOP for LM
    end else begin
        RR_EX_CLR <= 1'b0; // Optional: Set default value explicitly
    end

    // SM and IMM is zero
    if ((ID_RR_IR[15:12] == 4'b0111) && (IS_IMM_ZERO_SM == 1'b1)) begin
        ID_RR_CLR <= 1'b1; // NOP for SM
        is_sm0 <= 1'b0;
    end else begin
        ID_RR_CLR <= 1'b0;  // Optional: Set default value explicitly
        is_sm0 <= is_sm0;   // Maintain current value (if sequential logic is used)
    end
    
  if ((((RR_EX_IR[15:12] == 4'b1000) || (RR_EX_IR[15:12] == 4'b1001) || 
         (RR_EX_IR[15:12] == 4'b1010)) && (Sign_Bit == 1'b1)) || 
        (RR_EX_IR[15:12] == 4'b1100)) begin // BLT, BLE, BEQ, JAL
        MUX_PC_SEL <= 2'b01;
        RR_EX_CLR <= 1'b1;
  ID_RR_CLR <= 1'b1;
        IF_ID_CLR <= 1'b1;
  //clr as on brannching we will go on with the next instructions and the instruction which came due to not branching will be vanished.
  // sign bit used for recognising if equal or not
  end else if (ID_RR_IR[15:12] == 4'b1101) begin // JLR
        MUX_PC_SEL <= 2'b10;
        ID_RR_CLR <= 1'b1;
        IF_ID_CLR <= 1'b1;
  end else if (RR_EX_IR[15:12] == 4'b1111) begin // JRI
        MUX_PC_SEL <= 2'b11;
        RR_EX_CLR <= 1'b1;
        ID_RR_CLR <= 1'b1;
        IF_ID_CLR <= 1'b1;
    end else begin
        MUX_PC_SEL <= 2'b00;
    end
   end
endmodule
