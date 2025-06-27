`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2025 18:28:04
// Design Name: 
// Module Name: integration
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


module CPU(
    input wire clk,
    output wire output_dummy,
    output wire [15:0] Reg0,
    output wire [15:0] Reg1,
    output wire [15:0] Reg2,
    output wire [15:0] Reg3,
    output wire [15:0] Reg4,
    output wire [15:0] Reg5,
    output wire [15:0] Reg6,
    output wire [15:0] Reg7,
    output wire Current_Zero_OUT,
    output wire Current_Carry_OUT
    );
    
    // Single-bit signals
    wire current_carry_s, current_zero_s, new_zero_s, new_carry_s, Sign_Bit_s;
    wire IS_IMM_ZERO_LM_s, IS_IMM_ZERO_SM_s;
    wire ZF_EN_s, CF_EN_s, RF_D3_EN_s, RF_PC_EN_s, SH_EN_s;
    wire IF_ID_EN_s, ID_RR_EN_s, RR_EX_EN_s, EX_MEM_EN_s, MEM_WB_EN_s, MEM_WR_EN_s;
    
    // Single-bit multiplexer select signals
    wire MUX_SE_SEL_s, MUX_RF_D3_SEL_s, MUX_MEMDOUT_SEL_s;
    wire MUX_LM_SEL_s, MUX_SM_SEL_s, MUX_DEST2_SEL_s, MUX_RF_A3_SEL_s;
    
    // 16-bit signals
    wire [15:0] IF_ID_IR_s, ID_RR_IR_s, RR_EX_IR_s, EX_MEM_IR_s, MEM_WB_IR_s;
    wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
    
    // Single-bit clear signals
    wire IF_ID_CLR_s, ID_RR_CLR_s, RR_EX_CLR_s, EX_MEM_CLR_s, MEM_WB_CLR_s;
    
    // 2-bit multiplexer select signals
    wire [1:0] MUX_PC_SEL_s, MUX_DEST_SEL_s;
    
    // 3-bit multiplexer select signals
    wire [2:0] MUX_ALU_B_SEL_s, MUX_ALU_A_SEL_s;
    
    // 4-bit ALU operation signal
    wire [3:0] ALU_OP_s;
    
    Dataflow DP (
    .CLK(clk),
    .Current_Zero_OUT(current_zero_s),
    .Current_Carry_OUT(current_carry_s),
    .New_Carry_OUT(new_carry_s),
    .New_Zero_OUT(new_zero_s),
    .Sign_Bit(Sign_Bit_s),
    .IS_IMM_ZERO_LM(IS_IMM_ZERO_LM_s),
    .IS_IMM_ZERO_SM(IS_IMM_ZERO_SM_s),
    .ZF_EN(ZF_EN_s),
    .CF_EN(CF_EN_s),
    .RF_D3_EN(RF_D3_EN_s),
    .RF_PC_EN(RF_PC_EN_s),
    .SH_EN(SH_EN_s),
    .IF_ID_EN(IF_ID_EN_s),
    .ID_RR_EN(ID_RR_EN_s),
    .RR_EX_EN(RR_EX_EN_s),
    .EX_MEM_EN(EX_MEM_EN_s),
    .MEM_WB_EN(MEM_WB_EN_s),
    .IF_ID_CLR(IF_ID_CLR_s),
    .ID_RR_CLR(ID_RR_CLR_s),
    .RR_EX_CLR(RR_EX_CLR_s),
    .EX_MEM_CLR(EX_MEM_CLR_s),
    .MEM_WB_CLR(MEM_WB_CLR_s),
    .IF_ID_IR(IF_ID_IR_s),
    .ID_RR_IR(ID_RR_IR_s),
    .RR_EX_IR(RR_EX_IR_s),
    .EX_MEM_IR(EX_MEM_IR_s),
    .MEM_WB_IR(MEM_WB_IR_s),
    .MEM_WR_EN(MEM_WR_EN_s),
    .MUX_SE_SEL(MUX_SE_SEL_s),
    .MUX_RF_D3_SEL(MUX_RF_D3_SEL_s),
    .MUX_MEMDOUT_SEL(MUX_MEMDOUT_SEL_s),
    .MUX_LM_SEL(MUX_LM_SEL_s),
    .MUX_SM_SEL(MUX_SM_SEL_s),
    .MUX_DEST2_SEL(MUX_DEST2_SEL_s),
    .MUX_RF_A3_SEL(MUX_RF_A3_SEL_s),
    .MUX_PC_SEL(MUX_PC_SEL_s),
    .MUX_DEST_SEL(MUX_DEST_SEL_s),
    .MUX_ALU_B_SEL(MUX_ALU_B_SEL_s),
    .MUX_ALU_A_SEL(MUX_ALU_A_SEL_s),
    .ALU_OP(ALU_OP_s),
    .Reg0(r0),
    .Reg1(r1),
    .Reg2(r2),
    .Reg3(r3),
    .Reg4(r4),
    .Reg5(r5),
    .Reg6(r6),
    .Reg7(r7)
);

    Control_Unit Ctrl (
    .CLK(clk),
    .Current_Zero(current_zero_s),
    .Current_Carry(current_carry_s),
    .New_Carry(new_carry_s),
    .New_Zero(new_zero_s),
    .Sign_Bit(Sign_Bit_s),
    .IS_IMM_ZERO_LM(IS_IMM_ZERO_LM_s),
    .IS_IMM_ZERO_SM(IS_IMM_ZERO_SM_s),
    .ZF_EN(ZF_EN_s),
    .CF_EN(CF_EN_s),
    .RF_D3_EN(RF_D3_EN_s),
    .RF_PC_EN(RF_PC_EN_s),
    .SH_EN(SH_EN_s),
    .IF_ID_EN(IF_ID_EN_s),
    .ID_RR_EN(ID_RR_EN_s),
    .RR_EX_EN(RR_EX_EN_s),
    .EX_MEM_EN(EX_MEM_EN_s),
    .MEM_WB_EN(MEM_WB_EN_s),
    .IF_ID_CLR(IF_ID_CLR_s),
    .ID_RR_CLR(ID_RR_CLR_s),
    .RR_EX_CLR(RR_EX_CLR_s),
    .EX_MEM_CLR(EX_MEM_CLR_s),
    .MEM_WB_CLR(MEM_WB_CLR_s),
    .IF_ID_IR(IF_ID_IR_s),
    .ID_RR_IR(ID_RR_IR_s),
    .RR_EX_IR(RR_EX_IR_s),
    .EX_MEM_IR(EX_MEM_IR_s),
    .MEM_WB_IR(MEM_WB_IR_s),
    .MEM_WR_EN(MEM_WR_EN_s),
    .MUX_SE_SEL(MUX_SE_SEL_s),
    .MUX_RF_D3_SEL(MUX_RF_D3_SEL_s),
    .MUX_MEMDOUT_SEL(MUX_MEMDOUT_SEL_s),
    .MUX_LM_SEL(MUX_LM_SEL_s),
    .MUX_SM_SEL(MUX_SM_SEL_s),
    .MUX_DEST2_SEL(MUX_DEST2_SEL_s),
    .MUX_RF_A3_SEL(MUX_RF_A3_SEL_s),
    .MUX_PC_SEL(MUX_PC_SEL_s),
    .MUX_DEST_SEL(MUX_DEST_SEL_s),
    .MUX_ALU_B_SEL(MUX_ALU_B_SEL_s),
    .MUX_ALU_A_SEL(MUX_ALU_A_SEL_s),
    .ALU_OP(ALU_OP_s)
);

assign Reg0 = r0;
assign Reg1 = r1;
assign Reg2 = r2;
assign Reg3 = r3;
assign Reg4 = r4;
assign Reg5 = r5;
assign Reg6 = r6;
assign Reg7 = r7;
assign Current_Zero_OUT = current_zero_s;
assign Current_Carry_OUT = current_carry_s;


endmodule
