module prv32_ALU(
	input   wire [31:0] a, b, //inputs
	input   wire [4:0]  shamt, //defines how many bits to shift
	output  reg  [31:0] r, //register output
	output  wire        cf, zf, vf, sf, //carry flag, zero flag, overflow flag, and sign flag respctively
	input   wire [3:0]  alufn //alu function
);

    wire [31:0] add, sub, op_b; //op_b is the inversion of b, idk what sub is though
    wire cfa, cfs; //what even are these????
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b); //a-b or a+b depending on the lsb of the alufn
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf); //^ means xor
    
    wire[31:0] sh;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh)); //this does shifty business
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            4'b00_00 : r = add;
            4'b00_01 : r = add;
            4'b00_11 : r = b;
            // logic
            4'b01_00:  r = a | b;
            4'b01_01:  r = a & b;
            4'b01_11:  r = a ^ b;
            // shift
            4'b10_00:  r=sh;
            4'b10_01:  r=sh;
            4'b10_10:  r=sh;
            // slt & sltu
            4'b11_01:  r = {31'b0,(sf != vf)}; 
            4'b11_11:  r = {31'b0,(~cf)};            	
        endcase
    end
endmodule