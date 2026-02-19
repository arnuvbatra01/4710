/* Arnuv Batra (86229518) & Abhay Agarwal (23574020)*/

`timescale 1ns / 1ns

// quotient = dividend / divisor

module DividerUnsigned (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);

    // TODO: your code here
    genvar i;
    wire [31:0] cdividend [0:32];
    wire [31:0] cremainder [0:32];
    wire [31:0] cquotient [0:32];

    assign cdividend [0] = i_dividend;
    assign cremainder[0] = '0;
    assign cquotient[0] = '0;
    
    


    generate
        for(i = 0; i < 32; i = i+1) begin
            DividerOneIter b1 (cdividend[i],
                                i_divisor,
                                cremainder[i],
                                cquotient[i],
                                cdividend[i+1],
                                cremainder[i+1],
                                cquotient[i+1]);
        end

    endgenerate
    assign o_remainder = cremainder[32];
    assign o_quotient = cquotient[32];


endmodule


module DividerOneIter (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    input  wire [31:0] i_remainder,
    input  wire [31:0] i_quotient,
    output wire [31:0] o_dividend,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
  /*
    for (int i = 0; i < 32; i++) {
        remainder = (remainder << 1) | ((dividend >> 31) & 0x1);
        if (remainder < divisor) {
            quotient = (quotient << 1);
        } else {
            quotient = (quotient << 1) | 0x1;
            remainder = remainder - divisor;
        }
        dividend = dividend << 1;
    }
    */

    // TODO: your code here

    wire [31:0] rnew;
    assign rnew = i_remainder << 1 | (i_dividend >> 31 & 32'h1);

    wire obit = rnew >= i_divisor;
    assign o_remainder = obit ? (rnew - i_divisor) : rnew;
    assign o_quotient = (i_quotient << 1) | ({{31{1'b0}}, obit});
    assign o_dividend = i_dividend << 1;
endmodule
