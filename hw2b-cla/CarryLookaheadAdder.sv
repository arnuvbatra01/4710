`timescale 1ns / 1ps

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a | b;
endmodule

/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits internally would generate a carry-out (independent of cin)
 * @param pout whether these 4 bits internally would propagate an incoming carry from cin
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);

      reg [2:0] cout_temp;

   // TODO: your code here
   
   assign pout = &pin;
   assign gout = gin[3] | (gin[2] & pin[3]) | (gin[1] & pin[2] & pin[3]) | (gin[0] & pin[1] & pin[2] & pin[3]);

   assign cout_temp[0] = gin[0] | pin[0] & cin;
   assign cout_temp[1] = gin[1] | cin & pin[0] & pin[1] | gin[0] & pin[1];
   assign cout_temp[2] = gin[2] | cin & pin[0] & pin[1] & pin[2] | gin[0] & pin[1] & pin[2] | gin[1] & pin[2];

   assign cout = cout_temp;

endmodule

/** Same as gp4 but for an 8-bit window instead */
module gp8(input wire [7:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [6:0] cout);

   // TODO: your code here

   assign pout = &pin;
   assign gout = gin[7] 
   | (gin[6] & pin[7])
   | (gin[5] & pin[6] & pin[7])
   | (gin[4] & pin[5] & pin[6] & pin[7])
   | (gin[3] & pin[4] & pin[5] & pin[6] & pin[7])
   | (gin[2] & pin[3] & pin[4] & pin[5] & pin[6] & pin[7])
   | (gin[1] & pin[2] & pin[3] & pin[4] & pin[5] & pin[6] & pin[7])
   | (gin[0] & pin[1] & pin[2] & pin[3] & pin[4] & pin[5] & pin[6] & pin[7]);

assign cout[0] = gin[0] | (pin[0] & cin);

assign cout[1] = gin[1] | (pin[1] & gin[0]) | (pin[1] & pin[0] & cin);

assign cout[2] = gin[2] | (pin[2] & gin[1]) | (pin[2] & pin[1] & gin[0]) | 
                    (pin[2] & pin[1] & pin[0] & cin);

assign cout[3] = gin[3] | (pin[3] & gin[2]) | (pin[3] & pin[2] & gin[1]) | 
                    (pin[3] & pin[2] & pin[1] & gin[0]) | 
                    (pin[3] & pin[2] & pin[1] & pin[0] & cin);

assign cout[4] = gin[4] | (pin[4] & gin[3]) | (pin[4] & pin[3] & gin[2]) | 
                    (pin[4] & pin[3] & pin[2] & gin[1]) | 
                    (pin[4] & pin[3] & pin[2] & pin[1] & gin[0]) | 
                    (pin[4] & pin[3] & pin[2] & pin[1] & pin[0] & cin);

assign cout[5] = gin[5] | (pin[5] & gin[4]) | (pin[5] & pin[4] & gin[3]) | 
                    (pin[5] & pin[4] & pin[3] & gin[2]) | 
                    (pin[5] & pin[4] & pin[3] & pin[2] & gin[1]) | 
                    (pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & gin[0]) | 
                    (pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & pin[0] & cin);

assign cout[6] = gin[6] | (pin[6] & gin[5]) | (pin[6] & pin[5] & gin[4]) | 
                    (pin[6] & pin[5] & pin[4] & gin[3]) | 
                    (pin[6] & pin[5] & pin[4] & pin[3] & gin[2]) | 
                    (pin[6] & pin[5] & pin[4] & pin[3] & pin[2] & gin[1]) | 
                    (pin[6] & pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & gin[0]) | 
                    (pin[6] & pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & pin[0] & cin);



endmodule

module CarryLookaheadAdder
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);

   // TODO: your code here

   reg [31:0] gens, props;
   reg [31:0] carrys;
   assign carrys[0] = cin;
   logic pout0, pout1, pout2, pout3;
   logic gout0, gout1, gout2, gout3;
   genvar i;
   genvar j;

   for (i = 0; i < 32; i+= 1) begin
      gp1 x (a[i], b[i], gens[i], props[i]);

   end

   gp8 one (gens[7:0], props[7:0], cin, gout0, pout0, carrys[7:1]);
   gp8 two (gens[15:8], props[15:8], (gout0 | cin & pout0), gout1, pout1, carrys[15:9]);
   gp8 three (gens[23:16], props[23:16], (gout1 | cin & pout0 & pout1 | gout0 & pout1), gout2, pout2, carrys[23:17]);
   /* verilator lint_off PINNOCONNECT */
   gp8 four (gens[31:24], props[31:24], (gout2 | cin & pout0 & pout1 & pout2 | gout0 & pout1 & pout2 | gout1 & pout2), , , carrys[31:25]);

   assign carrys [8] = (gout0 | cin & pout0);
   assign carrys [16] = (gout1 | cin & pout0 & pout1 | gout0 & pout1);
   assign carrys [24] = (gout2 | cin & pout0 & pout1 & pout2 | gout0 & pout1 & pout2 | gout1 & pout2);
   //assign carrys [31] = 

   for (j= 0; j < 32; j+= 1) begin
   fulladder f (carrys[j], a[j], b[j], sum[j], );
   /* verilator lint_on PINNOCONNECT */
   end



endmodule




module halfadder(input wire  a,
                 input wire  b,
                 output wire s,
                 output wire cout);
   assign s = a ^ b;
   assign cout = a & b;
endmodule

/* A 1-bit full adder adds three 1-bit numbers (a, b, carry-in) and produces a 2-bit
 * result (as sum and carry-out) */
module fulladder(input wire  cin,
                 input wire  a,
                 input wire  b,
                 output wire s,
                 output wire cout);
   wire s_tmp, cout_tmp1, cout_tmp2;
   halfadder h0(.a(a), .b(b), .s(s_tmp), .cout(cout_tmp1));
   halfadder h1(.a(s_tmp), .b(cin), .s(s), .cout(cout_tmp2));
   assign cout = cout_tmp1 | cout_tmp2;
endmodule
