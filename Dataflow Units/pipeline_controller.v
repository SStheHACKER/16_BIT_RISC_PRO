`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2025 18:41:33
// Design Name: 
// Module Name: pipeline_controller
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

module pipeline_controller (
    input CLK,
    input Current_Zero, Current_Carry,
    input New_Carry, New_Zero, 
    input Sign_Bit, IS_IMM_ZERO_LM, IS_IMM_ZERO_SM,
    input [15:0] IF_ID_IR, ID_RR_IR, RR_EX_IR, EX_MEM_IR, MEM_WB_IR,

    output  IF_ID_CLR, ID_RR_CLR, RR_EX_CLR, EX_MEM_CLR, MEM_WB_CLR,
    output  ZF_EN, CF_EN, RF_D3_EN, RF_PC_EN, SH_EN, IF_ID_EN, ID_RR_EN, RR_EX_EN, EX_MEM_EN, MEM_WB_EN, MEM_WR_EN,
    output  MUX_SE_SEL, MUX_RF_D3_SEL, MUX_ALU1B_SEL, MUX_MEMDOUT_SEL, MUX_LM_SEL, MUX_SM_SEL, MUX_DEST2_SEL, MUX_RF_A3_SEL,
    output [1:0] MUX_PC_SEL, MUX_DEST_SEL,
    output [2:0] MUX_ALU_B_SEL, MUX_ALU_A_SEL,
    output [3:0] ALU_OP
);

    // Shared variables translated to internal registers
    wire [2:0] prev3carry = 3'b000; 
    wire [2:0] prev3zero = 3'b000;
    wire is_lm0 = 1'b0;
    wire is_lm1 = 1'b0;
    wire is_sm0 = 1'b0;
    wire is_sm1 = 1'b0;
    
    
    control_unit_5 c5 (
    .clk(CLK),
    .IF_ID_IR(IF_ID_IR),
    .ID_RR_IR(ID_RR_IR),
    .RR_EX_IR(RR_EX_IR),
    .EX_MEM_IR(EX_MEM_IR),
    .MEM_WB_IR(MEM_WB_IR),
    .MEM_WB_EN(MEM_WB_EN),
    .MEM_WR_EN(MEM_WR_EN)
    );
    
    control_unit_1 C1(
          .clk(CLK),
          .IF_ID_IR(IF_ID_IR),
          .ID_RR_IR(ID_RR_IR),
          .RR_EX_IR(RR_EX_IR),
          .EX_MEM_IR(EX_MEM_IR),
          .MEM_WB_IR(MEM_WB_IR),
          .Sign_Bit(Sign_Bit),
          .IS_IMM_ZERO_LM(IS_IMM_ZERO_LM),
          .IS_IMM_ZERO_SM(IS_IMM_ZERO_SM),
          .MEM_WB_CLR(MEM_WB_CLR),
          .EX_MEM_CLR(EX_MEM_CLR),
          .ID_RR_CLR(ID_RR_CLR),
          .RR_EX_CLR(RR_EX_CLR),
          .IF_ID_CLR(IF_ID_CLR),
          .IF_ID_EN(IF_ID_EN),
          .RF_PC_EN(RF_PC_EN),
          .MUX_PC_SEL(MUX_PC_SEL),
          .is_lm0(is_lm0),
          .is_sm0(is_sm0)
    );
        control_unit_2 C2(
            .clk(CLK),
          .IF_ID_IR(IF_ID_IR),
          .ID_RR_IR(ID_RR_IR),
          .RR_EX_IR(RR_EX_IR),
          .EX_MEM_IR(EX_MEM_IR),
          .MEM_WB_IR(MEM_WB_IR),
          .is_sm1(is_sm1),
          .ID_RR_EN(ID_RR_EN),
          .MUX_SE_SEL(MUX_SE_SEL),
          .SH_EN(SH_EN),
          .MUX_SM_SEL(MUX_SE_SEL)
        );
        control_unit_3 C3(
          .clk(CLK),
          .ID_RR_IR(ID_RR_IR),
          .RR_EX_IR(RR_EX_IR),
          .EX_MEM_IR(EX_MEM_IR),
          .MEM_WB_IR(MEM_WB_IR),
          .prev3carry(prev3carry),
          .prev3zero(prev3zero),
          .Current_Carry( Current_Carry),
          .Current_Zero(Current_Zero),
          .IS_IMM_ZERO_SM(IS_IMM_ZERO_SM),
          .is_lm1(is_lm1),
          .MUX_RF_A3_SEL( MUX_RF_A3_SEL),
          .MUX_RF_D3_SEL( MUX_RF_D3_SEL),
          .RF_D3_EN( RF_D3_EN),
          .MUX_DEST_SEL(MUX_DEST_SEL),
          .MUX_ALU_B_SEL(MUX_ALU_B_SEL),
          .MUX_ALU_A_SEL(MUX_ALU_A_SEL),
          .RR_EX_EN(RR_EX_EN),
          .MUX_LM_SEL(MUX_LM_SEL),
          .is_sm1(is_sm1)
        );
        control_unit_4  C4 (
          .clk(CLK),
          .IF_ID_IR(IF_ID_IR),
          .ID_RR_IR(ID_RR_IR),
          .RR_EX_IR(RR_EX_IR),
          .EX_MEM_IR(EX_MEM_IR),
          .MEM_WB_IR(MEM_WB_IR),
          .Current_Carry( Current_Carry),
          .Current_Zero(Current_Zero),
          .is_lm11(is_lm1),
          .is_lm1(is_lm1),
          .MUX_DEST2_SEL(MUX_DEST2_SEL),
          .ZF_EN(ZF_EN),
          .CF_EN(CF_EN),
          .ALU_OP( ALU_OP)
        );
        control_unit_6 C6(
           .clk(CLK),
          .IF_ID_IR(IF_ID_IR),
          .ID_RR_IR(ID_RR_IR),
          .RR_EX_IR(RR_EX_IR),
          .EX_MEM_IR(EX_MEM_IR),
          .MEM_WB_IR(MEM_WB_IR),
          .MUX_MEMDOUT_SEL( MUX_MEMDOUT_SEL)
        );
        
        update_prev_carry uut(
        .clk(CLK),
        .New_Carry(New_Carry),
        .New_Zero(New_Zero),
        .prev3carry(prev3carry),
        .prev3zero(prev3zero)
        );
    
    
endmodule
