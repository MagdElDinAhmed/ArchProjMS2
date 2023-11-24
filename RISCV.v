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
    ,ALU_in_2, ALU_Out, RAM_data_out, True_RAM_data_out, Immediate_Shifted, writeData,outputMuxRF,outputMuxRF2,outputMuxRF3;
    wire ActivateBranch,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,MuxRFSel,AUIPCSel, Jump, JALR, loadPC,StallSignal;
    wire [1:0] ALUOp , SaveMethod;
    wire [3:0] ALUSel;
    integer i;
    wire [31:0] PC_in,Unbranched_PC, Branched_PC, PC_out,MuxRF2Out, Actual_Branch_PC;
    reg [12:0] Seven_Seg_Num;
    
    wire ZeroFlag, CarryFlag, OverflowFlag, SignFlag;
    wire[1:0] forwardA,forwardB;
    wire[31:0] forwardOutA,forwardOutB;
    wire[95:0] outputMuxFlush2;
    wire [4:0] shamt;
    wire [9:0] muxOutputFlush3;
    
    
    //Pipeline Wires:
    //IF/ID:
    wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_Unbranched_PC;
    
    //ID/EX:
    
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_Unbranched_PC, ID_EX_Inst;
    wire ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite, ID_EX_AUIPCSel, ID_EX_Jump, ID_EX_JALR;
    wire [1:0] ID_EX_ALUOp, ID_EX_SaveMethod;
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    wire[12:0] muxOutputHDU;
    
    //EX/MEM:
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Unbranched_PC, EX_MEM_Inst; 
    wire EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemtoReg, EX_MEM_MemWrite, EX_MEM_RegWrite, EX_MEM_AUIPCSel, EX_MEM_Jump, EX_MEM_JALR, EX_MEM_ActivateBranch;
    wire [1:0] EX_MEM_SaveMethod;
    wire [4:0] EX_MEM_Rd;
    wire EX_MEM_Zero,EX_MEM_Carry,EX_MEM_Overflow,EX_MEM_Sign;   
    
    //MEM/WB:
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Unbranched_PC;
    wire MEM_WB_MemtoReg,MEM_WB_RegWrite, MEM_WB_AUIPCSel;
    wire [4:0] MEM_WB_Rd;    
    
    
    //Registers:
    //  IF/ID
    NBit_MUX2x1 #(.N(96))MUX_Flush2(  //added to flush  the IF/ID register 
    .A({PC_in,Instruction, Unbranched_PC}),
    .B(96'b0), //nop operation 
    .sel( (ActivateBranch&EX_MEM_Branch) || Jump ), // this is going to be 
    .Y(outputMuxFlush2)
    
    );
    NBit_Reg #(.N(96)) IF_ID(
    .clk(clk),
    .rst(rst),
    .load(~StallSignal),
    .D(outputMuxFlush2),
    .Q({IF_ID_PC,IF_ID_Inst,IF_ID_Unbranched_PC})
        );
    
    //  ID/EX

    
    NBit_MUX2x1 #(.N(13))MUX_Flush1( 
    .A({Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,ALUOp,AUIPCSel,SaveMethod,Jump,JALR}),
    .B(13'b0),
    .sel(StallSignal || ((ActivateBranch&EX_MEM_Branch) || ID_EX_Jump) ), //here it will check if there is a stall OR there is a needed flush due to branching 
    .Y(muxOutputHDU)
    
    );
    
    NBit_Reg #(.N(224)) ID_EX(
    .clk(clk),
    .rst(rst),
    .load(1'b1),
    .D({ muxOutputHDU, IF_ID_PC, outputMuxRF, RegReadOut2,
          Immediate, {IF_ID_Inst[30],IF_ID_Inst[14:12]}, IF_ID_Inst[19:15], IF_ID_Inst[24:20],IF_ID_Inst[11:7], IF_ID_Unbranched_PC, IF_ID_Inst}),
    .Q({ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite, ID_EX_ALUOp,
        ID_EX_AUIPCSel, ID_EX_SaveMethod, ID_EX_Jump, ID_EX_JALR,
        ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,
        ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd, ID_EX_Unbranched_PC, ID_EX_Inst})
        );
    
    
    //  EX/MEM

    
        
    NBit_MUX2x1 #(.N(10))MUX_Flush3( 
    .A({ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_RegWrite, ID_EX_AUIPCSel, ID_EX_Jump, ID_EX_JALR, ID_EX_SaveMethod }),
    .B(10'b0),
    .sel( (ActivateBranch&EX_MEM_Branch) || EX_MEM_Jump ), //here it will check if there is a stall OR there is a needed flush due to branching 
    //here undergoing assumption that 0ing the control signals will not need to 0 anything else as instruction already becomes nop
    .Y(muxOutputFlush3)
    
    );

    
    NBit_Reg #(.N(180)) EX_MEM(
    .clk(clk),
    .rst(rst),
    .load(1'b1),
    .D( { muxOutputFlush3, Actual_Branch_PC, ZeroFlag, CarryFlag, OverflowFlag, SignFlag, ALU_Out,
          forwardOutB, ID_EX_Rd, ActivateBranch, ID_EX_Unbranched_PC, ID_EX_Inst}),
    .Q({EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemtoReg, EX_MEM_MemWrite, EX_MEM_RegWrite, EX_MEM_AUIPCSel, EX_MEM_Jump, EX_MEM_JALR, EX_MEM_SaveMethod, EX_MEM_BranchAddOut, 
        EX_MEM_Zero, EX_MEM_Carry, EX_MEM_Overflow, EX_MEM_Sign,
        EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_ActivateBranch, EX_MEM_Unbranched_PC, EX_MEM_Inst} )
        );
    
    //  MEM/WB

    
    NBit_Reg #(.N(135)) MEM_WB(
    .clk(clk),
    .rst(rst),
    .load(1'b1),
    .D( { EX_MEM_MemtoReg,EX_MEM_RegWrite , True_RAM_data_out, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_AUIPCSel, EX_MEM_Unbranched_PC
           }),
    .Q({MEM_WB_MemtoReg,MEM_WB_RegWrite,MEM_WB_Mem_out, MEM_WB_ALU_out,
        MEM_WB_Rd, MEM_WB_AUIPCSel, MEM_WB_Unbranched_PC} )
        );
    
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
    
    
    reg lockDown;
    initial begin
        lockDown = 1;
    end
    always@(negedge(loadPC)) begin
        lockDown = 0;
    end
    //IF
    
    NBit_MUX2x1 #(.N(32))MUX_PC(
        .A(Unbranched_PC),
        .B(EX_MEM_BranchAddOut),
        .sel(EX_MEM_ActivateBranch&EX_MEM_Branch || EX_MEM_Jump),
        .Y(PC_out)
    );
    
    NBit_Reg #(.N(32)) PC(
    .clk(clk),
    .rst(rst),
    .load((~StallSignal) && lockDown),
    .D(PC_out),
    .Q(PC_in)
        );
        
    RCA #(.N(32))AdderPC (
    .A(32'd4),
    .B(PC_in),
    .AddSub(1'b0),
    .S(Unbranched_PC)
    );
    
    InstMem ROM (.addr (PC_in[9:2]), .data_out(Instruction));
    
    //ID
    Control_Unit #(.N(32)) CU(
    .Instruction(IF_ID_Inst),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg), 
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp),
    .MuxRFSel(MuxRFSel), //Select line for MuxRF1
    .AUIPCSel(AUIPCSel), //this is the Selectline for the MuxRF2
    .SaveMethod(SaveMethod),
    .Jump(Jump),
    .JALR(JALR),
    .loadPC(loadPC)    
    );
    
    
    
     NBit_RegFile #(.N(32)) RF(
    .clk(clk),
    .rst(rst),
    .RegWrite(MEM_WB_RegWrite),
    .writeData(outputMuxRF2),
    .RegRead1(IF_ID_Inst[19:15]),
    .RegRead2(IF_ID_Inst[24:20]),
    .WriteAddress(MEM_WB_Rd),
    .RegReadOut1(RegReadOut1),
    .RegReadOut2(RegReadOut2)
    );

    NBit_MUX2x1 #(.N(32))MUX_RF(
    .A(PC_in),//MAKE THIS THE output of MUXRF2 A=0
    .B(RegReadOut1),// from mem mux to reg  B=1
    .sel(MuxRFSel), //final output here Y should go into 
    .Y(outputMuxRF) //SET this as the output 
    );
    
    Immediate_Gen #(.N(32)) Immediate_Generator(
        .Instruction(IF_ID_Inst),
        .Immediate(Immediate)
    );
    
    //EX
    NBit_MUX4x1 #(.N(32)) MUX_ForwardA(
    .A(ID_EX_RegR1),
    .B(outputMuxRF2),
    .C(EX_MEM_ALU_out),
    .D(0),
    .sel(forwardA),
    .Y(forwardOutA)
    );

    NBit_MUX4x1 #(.N(32)) MUX_ForwardB(
    .A(ID_EX_RegR2),
    .B(outputMuxRF2),
    .C(EX_MEM_ALU_out),
    .D(0),
    .sel(forwardB),
    .Y(forwardOutB)
    );
    
    NBit_MUX2x1 #(.N(32))MUX_ALU(
        .A(forwardOutB),
        .B(ID_EX_Imm),
        .sel(ID_EX_ALUSrc),
        .Y(ALU_in_2)
    );
    
    ALU_Control_Unit #(.N(32)) ALU_CU(
        .Instruction(ID_EX_Inst),
        .ALUOp(ID_EX_ALUOp),
        .ALUSrc(ID_EX_ALUSrc),
        .ALUSel(ALUSel)
    );
    
    NBit_ALU #(.N(32)) ALU (
    .A(forwardOutA),
    .B(ALU_in_2),
    .C(ALU_Out),
    .alufn(ALUSel),
    .ZeroFlag(ZeroFlag),
    .CarryFlag(CarryFlag),
    .OverflowFlag(OverflowFlag),
    .SignFlag(SignFlag)
    );

    shifter Shifter
    (
        .a(ID_EX_Imm),
        .shamt(5'd1),
        .type(2'b01),
        .r(Immediate_Shifted)
    );
    
    
    RCA #(.N(32))BranchAdderPC (
    .A(Immediate_Shifted),
    .B(ID_EX_PC),
    .AddSub(1'b0),
    .S(Branched_PC)
    );
 
     NBit_MUX2x1 #(.N(32))MUX_Branch_Jump(
        .A(Branched_PC),
        .B(ALU_Out),
        .sel(ID_EX_JALR), //CHANGE this to just Branch which is now handled by the Branching control Unit instead of zeroFlag
        .Y(Actual_Branch_PC)
    );
    
    //MEM
    DataMem RAM
    (.clk(clk),
    .MemRead(EX_MEM_MemRead), 
    .MemWrite(EX_MEM_MemWrite),
    .SaveMethod(SaveMethod),
    .addr(EX_MEM_ALU_out),
    .data_in(EX_MEM_RegR2), 
    .data_out(RAM_data_out)
    );

    LoadHandler Loader
    (
    .fun3(Instruction[`IR_funct3]),
    .MemDataOut(RAM_data_out),
    .LoadOut(True_RAM_data_out)
    );    
    
    //WB
    NBit_MUX2x1 #(.N(32))MUX_RAM(
        .A(MEM_WB_ALU_out),
        .B(MEM_WB_Mem_out),
        .sel(MEM_WB_MemtoReg),
        .Y(writeData)
    );

    branchControlUnit #(.N(32)) BranchCU(
    .Instruction(EX_MEM_Inst),
    .ZFlag(EX_MEM_Zero),
    .SFlag(EX_MEM_Sign),
    .VFlag(EX_MEM_Overflow),
    .CFlag(EX_MEM_Carry),
    .Branch(ActivateBranch)
    );

    NBit_MUX2x1 #(.N(32))MUX_RF2( //this is MUX for AUIPC or Branch line into main mux for RF
      .A(writeData),//AUIPC
      .B(MEM_WB_Unbranched_PC),// This is to do with the one coming out PC+4 This in turn will allow for the JAL, JALR instructions to be stored.
      .sel(MEM_WB_AUIPCSel), //
      .Y(outputMuxRF2) //SET this as the output 
    ); //the above selects between the input which is AUIPC or Branch 
    
    HazardDetectionUnit HDU(
    .rs1(IF_ID_Inst[19:15]), //input IF/ID.RegisterRs1
    .rs2(IF_ID_Inst[24:20]),//input IF/ID.RegisterRs2
    .rd(ID_EX_Rd), //input ID/EX.RegisterRd
    .MemRead(ID_EX_MemRead),
    .stall(StallSignal)
    
    ); 
    
    Forward_Unit Forwarding(
        .ID_EX_Rs1(ID_EX_Rs1),
        .ID_EX_Rs2(ID_EX_Rs2),
        .EX_MEM_Rd(EX_MEM_Rd),
        .MEM_WB_Rd(MEM_WB_Rd),
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    
    
    
    
    
    Four_Digit_Seven_Segment_Driver Driver (
    .clk(SSDclk),
    .rst(rst),
    .num(Seven_Seg_Num),
    .Anode(Anode),
    .LED_out(Seven_Seg_Out)
);
endmodule