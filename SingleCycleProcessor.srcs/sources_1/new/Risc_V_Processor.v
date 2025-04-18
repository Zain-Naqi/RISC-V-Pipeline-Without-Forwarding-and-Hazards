`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 11:00:19 PM
// Design Name: 
// Module Name: RISC_V_Processor
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


module RISC_V_Processor (
    input clk,
    input reset
    );
    
    wire [63:0] PC_In, PC_Out, PC_Adder_Out, 
                PC_Imm_Adder_Out, Imm_Data, Imm_Data_LeftShift,
                WriteData, ReadData1, ReadData2,
                ALU_Input_b, ALU_Result, DM_Output;
                
    wire [31:0] Instruction;
    wire [6:0] opcode, funct7;
    wire [4:0] rd, rs1, rs2;
    wire [3:0] Operation;
    wire [2:0] funct3;
    wire Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, zero, Cin, Less, PC_Mux_Src;
    wire [1:0] ALUOp;
    
    // IF/ID Register Outputs:
    wire [63:0] IF_ID_PC_Out;
    wire [31:0] IF_ID_Instruction;
    
    // ID/Ex Register Outputs:
    wire ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite;
    wire [1:0] ID_EX_ALUOp;
    wire [63:0] ID_EX_PC_Out, ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_Imm_Data;
    wire [4:0] ID_EX_rd;
    wire [3:0] ID_EX_Funct;
    
    // EX/MEM Outputs:
    wire EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemtoReg, EX_MEM_MemWrite, EX_MEM_RegWrite, EX_MEM_Zero, EX_MEM_Less;
    wire [4:0] EX_MEM_rd;
    wire [2:0] EX_MEM_Funct3;
    wire [63:0] EX_MEM_PC_Shifted_Out, EX_MEM_ALU_Result, EX_MEM_ReadData2;
    
    
    // MEM/WB Outputs:
    wire MEM_WB_MemtoReg, MEM_WB_RegWrite;
    wire [63:0] MEM_WB_ALU_Result , MEM_WB_Read_Data;
    wire [4:0] MEM_WB_rd;
    
    // Mux that decides between next instruction or branched instruction:
    Mux PC_Mux(
        PC_Adder_Out, 
        EX_MEM_PC_Shifted_Out, 
//        ((EX_MEM_Branch & EX_MEM_Less & (EX_MEM_Funct3 == 3'b100)) | 
//        (EX_MEM_Branch & ((EX_MEM_Zero & (EX_MEM_Funct3 == 3'b000)) | 
//        ((!EX_MEM_Less) & (EX_MEM_Funct3 == 3'b101))))),
        PC_Mux_Src,          
        PC_In
        );
    
    // PC:
    Program_Counter PC(clk, reset, PC_In, PC_Out);
    
    // PC Adder (which adds 4):
    Adder Adder_1(PC_Out, 64'd4, PC_Adder_Out);
    
    // Instruction Memory:
    Instruction_Memory IM(PC_Out, Instruction);
    
    //IF/ID Register:
    IF_ID_Register IF_ID(clk, PC_Out, Instruction, IF_ID_PC_Out, IF_ID_Instruction);
    
    // Instruction Parser
    Instruction_Parser IP(IF_ID_Instruction, opcode, rd, funct3, rs1, rs2, funct7);
    
    // Immediate Data Extractor:
    Imm_Data_Extractor IDE(IF_ID_Instruction, Imm_Data);
    
    // Control Unit:
    Control_Unit CU(opcode, ALUOp, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite);
    
    // Register File:
    Register_File RF(WriteData, rs1, rs2, MEM_WB_rd, MEM_WB_RegWrite, clk, reset, ReadData1, ReadData2);
    
    // ID/EX Register:
    ID_EX_Register ID_EX(clk, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, 
    ALUOp, IF_ID_PC_Out, ReadData1, ReadData2, Imm_Data, rd, {IF_ID_Instruction[30], funct3},
    ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite, 
    ID_EX_ALUOp, ID_EX_PC_Out, ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_Imm_Data, ID_EX_rd,
    ID_EX_Funct);
    
    // ALU Control:
    ALU_Control AC(ID_EX_ALUOp, ID_EX_Funct, Operation);
    
    // Control Unit and ALU Control:
//    top_control control(opcode, {Instruction[30], funct3}, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, Operation);
    
    // Adder that adds immediate value to PC in case of branches:
    assign Imm_Data_LeftShift = ID_EX_Imm_Data << 1;
    Adder Adder_2(ID_EX_PC_Out, Imm_Data_LeftShift, PC_Imm_Adder_Out);
    
    // ALU Mux (Decides between immediate and rs2):
    Mux ALU_Mux(ID_EX_ReadData2, ID_EX_Imm_Data, ID_EX_ALUSrc, ALU_Input_b);
    
    // ALU:
    ALU_64_bit ALU(ID_EX_ReadData1, ALU_Input_b, Cin, Operation, Cout, zero, Less, ALU_Result);
    
    // EX/MEM Register
    EX_MEM_Register EX_MEM(clk, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, 
    ID_EX_RegWrite, zero, Less, ID_EX_rd, PC_Imm_Adder_Out, ALU_Result, ID_EX_ReadData2, ID_EX_Funct[2:0],
    EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemtoReg, EX_MEM_MemWrite, EX_MEM_RegWrite, 
    EX_MEM_Zero, EX_MEM_Less, EX_MEM_rd, EX_MEM_PC_Shifted_Out, EX_MEM_ALU_Result, 
    EX_MEM_ReadData2, EX_MEM_Funct3);
    
    assign PC_Mux_Src = ((EX_MEM_Branch & EX_MEM_Less & (EX_MEM_Funct3 == 3'b100)) | 
    (EX_MEM_Branch & ((EX_MEM_Zero & (EX_MEM_Funct3 == 3'b000)) | 
    ((!EX_MEM_Less) & (EX_MEM_Funct3 == 3'b101)))));
    
    // Data Memory:
    Data_Memory DM(EX_MEM_ALU_Result, EX_MEM_ReadData2, clk, EX_MEM_MemWrite, EX_MEM_MemRead, 
    DM_Output);
    
    // MEM/WB Register
    MEM_WB_Register MEM_WB(clk, EX_MEM_MemtoReg, EX_MEM_RegWrite, EX_MEM_ALU_Result, 
    EX_MEM_ReadData2, EX_MEM_rd, MEM_WB_MemtoReg, MEM_WB_RegWrite, MEM_WB_ALU_Result, 
    MEM_WB_Read_Data, MEM_WB_rd);
    
    // Write Back Mux:
    Mux WB_Mux(MEM_WB_ALU_Result, MEM_WB_Read_Data, MEM_WB_MemtoReg, WriteData);
        
endmodule

