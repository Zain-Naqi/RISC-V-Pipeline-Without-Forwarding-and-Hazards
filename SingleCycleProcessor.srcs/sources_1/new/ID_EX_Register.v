`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 01:33:00 PM
// Design Name: 
// Module Name: ID_EX_Register
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


module ID_EX_Register(
    input clk,
    input Branch,
    input MemRead, 
    input MemtoReg, 
    input MemWrite, 
    input ALUSrc, 
    input RegWrite,
    input [1:0] ALUOp, 
    input [63:0] PC,
    input [63:0] ReadData1, 
    input [63:0] ReadData2, 
    input [63:0] Imm_generated,
    input [4:0] RD,
    input [3:0] funct_in,
     
    output reg Branch_Out, 
    output reg MemRead_Out, 
    output reg MemtoReg_Out, 
    output reg MemWrite_Out, 
    output reg ALUSrc_Out, 
    output reg RegWrite_Out,
    output reg [1:0] ALUOp_Out, 
    output reg [63:0] PC_Out,
    output reg [63:0] ReadData1_Out, 
    output reg [63:0] ReadData2_Out, 
    output reg [63:0] Imm_generated_Out,
    output reg [4:0] RD_Out,
    output reg [3:0] funct_in_Out
    );
    
always @(posedge clk) begin
    Branch_Out = Branch;
    MemRead_Out = MemRead;
    MemtoReg_Out = MemtoReg;
    MemWrite_Out = MemWrite;
    ALUSrc_Out = ALUSrc;
    RegWrite_Out = RegWrite;
    ALUOp_Out = ALUOp;
    PC_Out = PC;
    ReadData1_Out = ReadData1;
    ReadData2_Out  = ReadData2;
    Imm_generated_Out = Imm_generated;
    RD_Out = RD;
    funct_in_Out = funct_in;
end

endmodule

