`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:40:21 AM
// Design Name: 
// Module Name: DataPath
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


module RISCV(input clk, rst,SSDclk,
input [1:0] ledSel,
input [3:0] ssdSel,
output reg [15:0] LED,
output [3:0] Anode,
output [6:0] Seven_Seg_Out

    );
    wire [5:0] Inst_addr;
    wire [31:0] Instruction, RegReadOut1, RegReadOut2, Immediate
    ,ALU_in_2, ALU_Out, RAM_data_out, True_RAM_data_out, Immediate_Shifted, writeData;
    wire Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite;
    wire [1:0] ALUOp;
    wire [3:0] ALUSel;
    integer i;
    wire [31:0] PC_in,Unbranched_PC, Branched_PC, PC_out;
    reg [12:0] Seven_Seg_Num;
    
    wire ZeroFlag, CarryFlag, OverflowFlag, SignFlag;
    wire [4:0] shamt;
    
    

    always@(*) begin
        if (rst==1'b1)
            LED=16'd0;
        case (ledSel)
            2'b00: LED=Instruction[15:0];
            2'b01: LED=Instruction[31:16];
            2'b10: LED={2'b0, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, ALUSel, ZeroFlag,(Branch&ZeroFlag)};
        endcase
        
        case (ssdSel)
            4'b0000: Seven_Seg_Num = PC_in;
            4'b0001: Seven_Seg_Num = Unbranched_PC;
            4'b0010: Seven_Seg_Num = Branched_PC;
            4'b0011: Seven_Seg_Num = PC_out;
            4'b0100: Seven_Seg_Num = RegReadOut1;
            4'b0101: Seven_Seg_Num = RegReadOut2;
            4'b0110: Seven_Seg_Num = writeData;
            4'b0111: Seven_Seg_Num = Immediate;
            4'b1000: Seven_Seg_Num = Immediate_Shifted;
            4'b1001: Seven_Seg_Num = ALU_in_2;
            4'b1010: Seven_Seg_Num = ALU_Out;
            4'b1011: Seven_Seg_Num = RAM_data_out;
        endcase
    end
    
    NBit_Reg #(.N(32)) PC(
    .clk(clk),
    .rst(rst),
    .load(1'b1),
    .D(PC_out),
    .Q(PC_in)
        );
    
    InstMem ROM (.addr (PC_in[9:2]), .data_out(Instruction));
    
    Control_Unit #(.N(32)) CU(
    .Instruction(Instruction),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg), 
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp)
    );
    
     NBit_RegFile #(.N(32)) RF(
    .clk(clk),
    .rst(rst),
    .RegWrite(RegWrite),
    .writeData(writeData),
    .RegRead1(Instruction[19:15]),
    .RegRead2(Instruction[24:20]),
    .WriteAddress(Instruction[11:7]),
    .RegReadOut1(RegReadOut1),
    .RegReadOut2(RegReadOut2)
    );
    
    Immediate_Gen #(.N(32)) Immediate_Generator(
        .Instruction(Instruction),
        .Immediate(Immediate)
    );
    
    NBit_MUX2x1 #(.N(32))MUX_ALU(
        .A(RegReadOut2),
        .B(Immediate),
        .sel(ALUSrc),
        .Y(ALU_in_2)
    );
    
    ALU_Control_Unit #(.N(32)) ALU_CU(
        .Instruction(Instruction),
        .ALUOp(ALUOp),
        .ALUSel(ALUSel)
    );
    
    NBit_ALU #(.N(32)) ALU (
    .A(RegReadOut1),
    .B(ALU_in_2),
    .C(ALU_Out),
    .alufn(ALUSel),
    .ZeroFlag(ZeroFlag),
    .CarryFlag(CarryFlag),
    .OverflowFlag(OverflowFlag),
    .SignFlag(SignFlag)
    );
    
    DataMem RAM
    (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite),
    .addr(ALU_Out), .data_in(RegReadOut2), .data_out(RAM_data_out));
    
    LoadHandler Loader
    (Instruction[`IR_funct3],RAM_data_out,True_RAM_data_out);
    
    NBit_MUX2x1 #(.N(32))MUX_RAM(
        .A(ALU_Out),
        .B(True_RAM_data_out),
        .sel(MemtoReg),
        .Y(writeData)
    );
    
    NBit_Shift_Left_1 #(.N(32)) Shifter
    (
        .X(Immediate),
        .Y(Immediate_Shifted)
    );
    
    RCA #(.N(32))BranchAdderPC (
    .A(Immediate_Shifted),
    .B(PC_in),
    .AddSub(1'b0),
    .S(Branched_PC)
    );
    
    RCA #(.N(32))AdderPC (
    .A(32'd4),
    .B(PC_in),
    .AddSub(1'b0),
    .S(Unbranched_PC)
    );
    
    NBit_MUX2x1 #(.N(32))MUX_PC(
        .A(Unbranched_PC),
        .B(Branched_PC),
        .sel(ZeroFlag&Branch),
        .Y(PC_out)
    );
    
    Four_Digit_Seven_Segment_Driver Driver (
    .clk(SSDclk),
    .rst(rst),
    .num(Seven_Seg_Num),
    .Anode(Anode),
    .LED_out(Seven_Seg_Out)
);
endmodule
