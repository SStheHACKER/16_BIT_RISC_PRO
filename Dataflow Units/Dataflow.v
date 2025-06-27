`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 16:45:58
// Design Name: 
// Module Name: Dataflow
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

module Dataflow (
    input ZF_EN, CF_EN, RF_D3_EN, RF_PC_EN, SH_EN, IF_ID_EN, ID_RR_EN, RR_EX_EN, EX_MEM_EN, MEM_WB_EN, MEM_WR_EN,
    input MUX_SM_SEL, MUX_LM_SEL, MUX_SE_SEL, 
    input MUX_RF_A3_SEL,MUX_RF_D3_SEL, MUX_MEMDOUT_SEL, MUX_DEST2_SEL,
    input [1:0] MUX_DEST_SEL, MUX_PC_SEL,
    input [2:0] MUX_ALU_B_SEL, MUX_ALU_A_SEL,
    input [3:0] ALU_OP,
    input CLK,
    input wire IF_ID_CLR, ID_RR_CLR, RR_EX_CLR, EX_MEM_CLR, MEM_WB_CLR,
    output Current_Zero_OUT, Current_Carry_OUT, Sign_Bit,
    output wire IS_IMM_ZERO_SM, New_Zero_OUT, New_Carry_OUT, IS_IMM_ZERO_LM,
    
    output wire [15:0] IF_ID_IR,ID_RR_IR,RR_EX_IR,EX_MEM_IR,MEM_WB_IR,
    
    output wire [15:0] Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7
);

wire [15:0] STG1_PC, STG1_IM_DATA, STG1_PC2, STG1_MUX_OUT;

wire [15:0] STG2_PC, STG2_PC2, STG2_IR, STG2_SE_IMM_6, STG2_SE_IMM_9;
wire [15:0] STG2_SE_IMM, STG2_SE_IMM_2, STG2_SE_IMM_3, STG2_PC_2xIMM;
wire [2:0] STG2_RA_ADD, STG2_RB_ADD, STG2_RC_ADD, RF_A3_OUT;
wire [8:0] STG2_IMM_9;
wire [5:0] STG2_IMM_6;

wire [15:0] STG3_PC, STG3_PC_2, STG3_PC_2xIMM, STG3_SE_IMM_2,STG3_SM_IMM, STG3_SE_IMM_3,STG3_RA, STG3_RB, STG3_ALU_A , STG3_ALU_B;     
wire [2:0] STG3_PENC, STG3_RA_ADD, STG3_RB_ADD, STG3_RC_ADD;

wire [15:0] STG4_PC_2, STG4_PC_2xIMM, STG4_ALU_A, STG4_ALU_B, STG4_ALU_C;
wire [15:0] STG4_RA, STG4_LM_IMM;
wire [15:0] STG4_PENC, STG4_DEST_2;

wire [15:0] STG5_ALU_C, STG5_DOUT, STG5_PC_2, STG5_RA, STG5_RB;
wire [15:0] STG6_PC_2, STG6_MUX_OP, STG6_DOUT, STG6_ALU_C;

wire [2:0] STG3_DEST, STG6_DEST, STG4_DEST, STG5_DES;

wire [15:0] RF_D3_INP;

wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
wire Current_Zero = 1'b0;
wire Current_Carry = 1'b0;
wire New_Carry = 1'b0;
wire New_Zero = 1'b0;

wire [15:0] STG3_IR,STG4_IR,STG5_IR,STG6_IR ;

// Instruction Memory
Instruction_memory IM (
    .clk(CLK),
    .IM_DATA(STG1_IM_DATA),
    .address(STG1_PC)
);

// ALU2
ALU23 ALU2 (
    .input1(STG1_PC),
    .input2(16'b0000000000000010),
    .ALU_out(STG1_PC2)
);

// MUX_4_to_1 (16-bit)
mux_IF_4 MUX41_16bit (
    .ALU_2C(STG1_PC2),
    .ALU3_C(STG4_PC_2xIMM),
    .RB_RR_EX(STG3_RB),  // for JLR
    .ALU1_C(STG4_ALU_C),
    .S(MUX_PC_SEL),
    .Op(STG1_MUX_OUT)
);

// IF-ID
IF_ID IF_ID_inst (
    .clk(CLK),
    .IF_ID_EN(IF_ID_EN),
    .IF_ID_CLR(IF_ID_CLR),
    .PC_IN(STG1_PC),
    .PC_2_IN(STG1_PC2),
    .IM_DATA_IN(STG1_IM_DATA),
    .RA_ADD(STG2_RA_ADD),
    .RB_ADD(STG2_RB_ADD),
    .RC_ADD(STG2_RC_ADD),
    .IMM_6(STG2_IMM_6),
    .IMM_9(STG2_IMM_9),
    .PC_OUT(STG2_PC),
    .PC_2_OUT(STG2_PC2),
    .IM_DATA_OUT(STG2_IR)
);

// SE6
sign_ext_6 sign_ext_6_inst (
    .SE_IN(STG2_IMM_6),
    .SE_OUT(STG2_SE_IMM_6)
);

// SE9
sign_ext_9 sign_ext_9_inst (
    .SE_IN(STG2_IMM_9),
    .SE_OUT(STG2_SE_IMM_9)
);

// SE_MUX
MUX_2_to_1_16bit SE_MUX_inst (
    .A0(STG2_SE_IMM_6),
    .A1(STG2_SE_IMM_9),
    .S(MUX_SE_SEL),
    .Op(STG2_SE_IMM)
);

// Shifter
shifter_multiplybytwo SHIFTER_inst (
    .shift_in(STG2_SE_IMM),
    .shift_out(STG2_SE_IMM_2),
    .SH_EN(SH_EN)
);

// SM_MUX
MUX_2_to_1_16bit SM_MUX_inst (
    .A0(STG2_SE_IMM_2),
    .A1(STG3_SM_IMM),
    .S(MUX_SM_SEL),
    .Op(STG2_SE_IMM_3)
);

// ALU3
ALU23 ALU3_inst (
    .input1(STG2_SE_IMM_2),
    .input2(STG2_PC),
    .ALU_out(STG2_PC_2xIMM)
);

// ID-RR
ID_RR ID_RR_inst (
    .clk(CLK),
    .ID_RR_EN(ID_RR_EN),
    .ID_RR_CLR(ID_RR_CLR),
    .RB_ADD_IN(STG2_RB_ADD),
    .RC_ADD_IN(STG2_RC_ADD),
    .RA_ADD_IN(STG2_RA_ADD),
    .PC_2_IN(STG2_PC2),
    .PC_2xIMM_IN(STG2_PC_2xIMM),
    .IR_IN(STG2_IR),
    .IMM_SE(STG2_SE_IMM_3),
    .RA_ADD_OUT(STG3_RA_ADD),
    .RB_ADD_OUT(STG3_RB_ADD),
    .RC_ADD_OUT(STG3_RC_ADD),
    .PC_2xIMM_OUT(STG3_PC_2xIMM),
    .PC_2_OUT(STG3_PC_2),
    .SE_2xIMM(STG3_SE_IMM_2),
    .IR_OUT(STG3_IR)
);

// LMSM
LMSM LMSM_inst (
    .IMM_IN(STG3_SE_IMM_2),
    .PENC_OP(STG3_PENC),
    .IMM_OP(STG3_SM_IMM),
    .IS_IMM_ZERO(IS_IMM_ZERO_SM)
);

// DEST_MUX
MUX_3_to_1_3bit DEST_MUX_inst (
    .A0(STG3_RC_ADD),
    .A1(STG3_RB_ADD),
    .A2(STG3_RA_ADD),
    .S(MUX_DEST_SEL),
    .Op(STG3_DEST)
);

// Register File
Register_File RF_inst (
    .RF_A1(STG3_RA_ADD),
    .RF_A2(STG3_RB_ADD),
    .RF_A3(RF_A3_OUT),
    .RF_D1(STG3_RA),
    .RF_D2(STG3_RB),
    .RF_D3(RF_D3_INP),
    .RF_PC_R(STG1_PC),
    .RF_PC_W(STG1_MUX_OUT),
    .RF_D3_EN(RF_D3_EN),
    .PC_EN(RF_PC_EN),
    .clk(CLK),
    .Reg0(r0),
    .Reg1(r1),
    .Reg2(r2),
    .Reg3(r3),
    .Reg4(r4),
    .Reg5(r5),
    .Reg6(r6),
    .Reg7(r7)
);

// RF_A3_MUX
MUX_2_to_1_3bit RF_A3_MUX_inst (
    .A0(STG6_DEST),
    .A1(STG3_PENC),
    .S(MUX_RF_A3_SEL),
    .Op(RF_A3_OUT)
);

// ALU_A_MUX
MUX_6_to_1 ALU_A_MUX_inst (
    .A0(STG3_RA),
    .A1(STG3_RB),
    .A2(STG4_ALU_C),
    .A3(STG5_DOUT),
    .A4(STG5_ALU_C),
    .A5(STG6_MUX_OP),
    .S(MUX_ALU_A_SEL),
    .Op(STG3_ALU_A)
);

// LM_MUX
MUX_2_to_1_16bit LM_MUX_inst (
    .A0(STG3_SE_IMM_2),
    .A1(STG4_LM_IMM),
    .S(MUX_LM_SEL),
    .Op(STG3_SE_IMM_3)
);

// ALU_B_MUX
MUX_6_to_1 ALU_B_MUX_inst (
    .A0(STG3_RB),
    .A1(STG3_SE_IMM_3),
    .A2(STG4_ALU_C),
    .A3(STG5_DOUT),
    .A4(STG5_ALU_C),
    .A5(STG6_MUX_OP),
    .S(MUX_ALU_B_SEL),
    .Op(STG3_ALU_B)
);

// RR_EX
RR_EX RR_EX_inst (
    .clk(CLK),
    .RR_EX_EN(RR_EX_EN),
    .RR_EX_CLR(RR_EX_CLR),
    .DEST_IN(STG3_DEST),
    .ALU_A_MUX_IN(STG3_ALU_A),
    .ALU_B_MUX_IN(STG3_ALU_B),
    .RA_IN(STG3_RA),
    .PC_2xIMM_IN(STG3_PC_2xIMM),
    .PC_2_IN(STG3_PC_2),
    .IR_IN(STG3_IR),
    .DEST_OUT(STG4_DEST),
    .RA_OUT(STG4_RA),
    .ALU_A_MUX_OUT(STG4_ALU_A),
    .ALU_B_MUX_OUT(STG4_ALU_B),
    .PC_2xIMM_OUT(STG4_PC_2xIMM),
    .PC_2_OUT(STG4_PC_2),
    .IR_OUT(STG4_IR)
);

// DEST2_MUX
MUX_2_to_1_3bit DEST_2_MUX (
    .A0(STG4_DEST),
    .A1(STG4_PENC),
    .S(MUX_DEST2_SEL),
    .Op(STG4_DEST_2)
);

// C FLAG (Current Carry Flag)
Register_1 C_FLAG (
    .DIN(New_Carry),
    .DOUT(Current_Carry),
    .CLK(CLK),
    .WE(CF_EN)
);

// Z FLAG (Current Zero Flag)
Register_1 Z_FLAG (
    .DIN(New_Zero),
    .DOUT(Current_Zero),
    .CLK(CLK),
    .WE(ZF_EN)
);

// ALU
ALU ALU1 (
    .ALU_A(STG4_ALU_A),
    .ALU_B(STG4_ALU_B),
    .ALU_OP(ALU_OP),
    .ALU_C(STG4_ALU_C),
    .ALU_Z(Current_Zero),
    .ALU_C1(Current_Carry),
    .ALU_Carry(New_Carry),
    .ALU_Zero(New_Zero),
    .clk(CLK)
);

// LMSM
LMSM LMSM_2 (
    .IMM_IN(STG4_ALU_B),
    .PENC_OP(STG4_PENC),
    .IMM_OP(STG4_LM_IMM),
    .IS_IMM_ZERO(IS_IMM_ZERO_LM)
);

// EX-MEM pipeline register
EX_MEM EX_MEM (
    .clk(CLK),
    .EX_MEM_EN(EX_MEM_EN),
    .EX_MEM_CLR(EX_MEM_CLR),
    .DEST_IN(STG4_DEST_2),
    .RA_IN(STG4_RA),
    .ALU_C_IN(STG4_ALU_C),
    .PC_2_IN(STG4_PC_2),
    .IR_IN(STG4_IR),
    .DEST_OUT(STG5_DEST),
    .RA_OUT(STG5_RA),
    .ALU_C_OUT(STG5_ALU_C),
    .PC_2_OUT(STG5_PC_2),
    .IR_OUT(STG5_IR)
);

// Data Memory
Data_mem Data_Memory (
    .clk(CLK),
    .Enable(MEM_WR_EN),
    .Mem_add(STG5_ALU_C),
    .Din(STG5_RA),
    .Dout(STG5_DOUT)
);

// MEM-WB pipeline register
MEM_WB MEMxWB (
    .clk(CLK),
    .MEM_WB_EN(MEM_WB_EN),
    .MEM_WB_CLR(MEM_WB_CLR),
    .DEST_IN(STG5_DEST),
    .ALU_C_IN(STG5_ALU_C),
    .D_OUT_IN(STG5_DOUT),
    .PC_2_IN(STG5_PC_2),
    .IR_IN(STG5_IR),
    .PC_2_OUT(STG6_PC_2),
    .D_OUT_OUT(STG6_DOUT),
    .ALU_C_OUT(STG6_ALU_C),
    .DEST_OUT(STG6_DEST),
    .IR_OUT(STG6_IR)
);

// WB MUX: selects between data memory output and ALU output
MUX_2_to_1_16bit WBxMUX (
    .A0(STG6_DOUT),          // Data memory output
    .A1(STG6_ALU_C),         // ALU output
    .S(MUX_MEMDOUT_SEL),     // Select signal
    .Op(STG6_MUX_OP)         // MUX output
);

// RF_D3 MUX: selects between MUX output and PC+2
MUX_2_to_1_16bit RF_D3_MUX (
    .A0(STG6_MUX_OP),        // MUX output from WB stage
    .A1(STG6_PC_2),          // PC+2 value
    .S(MUX_RF_D3_SEL),       // Select signal
    .Op(RF_D3_INP)           // MUX output for RF D3 input
);


   assign Current_Zero_OUT = Current_Zero;
assign Current_Carry_OUT = Current_Carry;
assign New_Zero_OUT = New_Zero;
assign New_Carry_OUT = New_Carry;
assign Sign_Bit = STG4_ALU_C[0];

assign IF_ID_IR = STG2_IR;
assign ID_RR_IR = STG3_IR;
assign RR_EX_IR = STG4_IR;
assign EX_MEM_IR = STG5_IR;
assign MEM_WB_IR = STG6_IR;
    
    assign Reg0 = r0;
    assign Reg1 = r1;
    assign Reg2 = r2;
    assign Reg3 = r3;
    assign Reg4 = r4;
    assign Reg5 = r5;
    assign Reg6 = r6;
    assign Reg7 = r7;

endmodule
