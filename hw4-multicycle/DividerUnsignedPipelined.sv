// Arnuv Batrs (86229518)

`timescale 1ns / 1ns

// quotient = dividend / divisor



module DividerUnsignedPipelined (
    input wire clk, rst, stall,
    input  wire  [31:0] i_dividend,
    input  wire  [31:0] i_divisor,
    output logic [31:0] o_remainder,
    output logic [31:0] o_quotient
);

     genvar i;
    logic [31:0] cdividend [0:32];
    logic [31:0] cremainder [0:32];
    logic [31:0] cquotient [0:32];
    logic [31:0] cdivisor [0:32];

    reg [31:0] r_reg [0:6];
    reg [31:0] q_reg [0:6];
    reg [31:0] divd_reg [0:6];
    reg [31:0] div_reg [0:6];

    logic [31:0] next_r_reg_0;
    logic [31:0] next_q_reg_0;
    logic [31:0] next_divd_reg_0;

    logic [31:0] next_r_reg_1;
    logic [31:0] next_q_reg_1;
    logic [31:0] next_divd_reg_1;

    logic [31:0] next_r_reg_2;
    logic [31:0] next_q_reg_2;
    logic [31:0] next_divd_reg_2;

    logic [31:0] next_r_reg_3;
    logic [31:0] next_q_reg_3;
    logic [31:0] next_divd_reg_3;

    logic [31:0] next_r_reg_4;
    logic [31:0] next_q_reg_4;
    logic [31:0] next_divd_reg_4;

    logic [31:0] next_r_reg_5;
    logic [31:0] next_q_reg_5;
    logic [31:0] next_divd_reg_5;

    logic [31:0] next_r_reg_6;
    logic [31:0] next_q_reg_6;
    logic [31:0] next_divd_reg_6;

    assign cdividend [0] = i_dividend;
    assign cremainder[0] = '0;
    assign cquotient[0] = '0;
    assign cdivisor[0] = i_divisor;

    assign o_remainder = cremainder[32];
    assign o_quotient = cquotient[32];

    generate
        for(i = 0; i < 3; i = i+1) begin : gen_0
            divu_1iter b1 (cdividend[i],
                                cdivisor[0],
                                cremainder[i],
                                cquotient[i],
                                cdividend[i+1],
                                cremainder[i+1],
                                cquotient[i+1]);
        end

    endgenerate

            divu_1iter r0i (cdividend[3],
                                cdivisor[0],
                                cremainder[3],
                                cquotient[3],
                                next_divd_reg_0,
                                next_r_reg_0,
                                next_q_reg_0);

            divu_1iter r0o (divd_reg[0],
                                div_reg[0],
                                r_reg[0],
                                q_reg[0],
                                cdividend[5],
                                cremainder[5],
                                cquotient[5]);




    generate
        for(i = 5; i < 7; i = i+1) begin : gen_1
            divu_1iter b1 (cdividend[i],
                                div_reg[0],
                                cremainder[i],
                                cquotient[i],
                                cdividend[i+1],
                                cremainder[i+1],
                                cquotient[i+1]);
        end

    endgenerate


            divu_1iter r1i (cdividend[7],
                                div_reg[0],
                                cremainder[7],
                                cquotient[7],
                                next_divd_reg_1,
                                next_r_reg_1,
                                next_q_reg_1);


            divu_1iter r1o (divd_reg[1],
                                div_reg[1],
                                r_reg[1],
                                q_reg[1],
                                cdividend[9],
                                cremainder[9],
                                cquotient[9]);




    generate
        for(i = 9; i < 11; i = i+1) begin : gen_2
            divu_1iter b1 (cdividend[i],
                                div_reg[1],
                                cremainder[i],
                                cquotient[i],
                                cdividend[i+1],
                                cremainder[i+1],
                                cquotient[i+1]);
        end

    endgenerate


            divu_1iter r2i (cdividend[11],
                                div_reg[1],
                                cremainder[11],
                                cquotient[11],
                                next_divd_reg_2,
                                next_r_reg_2,
                                next_q_reg_2);


            divu_1iter r2o (divd_reg[2],
                                div_reg[2],
                                r_reg[2],
                                q_reg[2],
                                cdividend[13],
                                cremainder[13],
                                cquotient[13]);




    generate
        for(i = 13; i < 15; i = i+1) begin : gen_3
            divu_1iter b1 (cdividend[i],
                                div_reg[2],
                                cremainder[i],
                                cquotient[i],
                                cdividend[i+1],
                                cremainder[i+1],
                                cquotient[i+1]);
        end

    endgenerate


            divu_1iter r3i (cdividend[15],
                                div_reg[2],
                                cremainder[15],
                                cquotient[15],
                                next_divd_reg_3,
                                next_r_reg_3,
                                next_q_reg_3);


            divu_1iter r3o (divd_reg[3],
                                div_reg[3],
                                r_reg[3],
                                q_reg[3],
                                cdividend[17],
                                cremainder[17],
                                cquotient[17]);




    generate
        for(i = 17; i < 19; i = i+1) begin : gen_4
            divu_1iter b1 (cdividend[i],
                                div_reg[3],
                                cremainder[i],
                                cquotient[i],
                                cdividend[i+1],
                                cremainder[i+1],
                                cquotient[i+1]);
        end

    endgenerate


            divu_1iter r4i (cdividend[19],
                                div_reg[3],
                                cremainder[19],
                                cquotient[19],
                                next_divd_reg_4,
                                next_r_reg_4,
                                next_q_reg_4);


            divu_1iter r4o (divd_reg[4],
                                div_reg[4],
                                r_reg[4],
                                q_reg[4],
                                cdividend[21],
                                cremainder[21],
                                cquotient[21]);




    generate
        for(i = 21; i < 23; i = i+1) begin : gen_5
            divu_1iter b1 (cdividend[i],
                                div_reg[4],
                                cremainder[i],
                                cquotient[i],
                                cdividend[i+1],
                                cremainder[i+1],
                                cquotient[i+1]);
        end

    endgenerate


            divu_1iter r5i (cdividend[23],
                                div_reg[4],
                                cremainder[23],
                                cquotient[23],
                                next_divd_reg_5,
                                next_r_reg_5,
                                next_q_reg_5);


            divu_1iter r5o (divd_reg[5],
                                div_reg[5],
                                r_reg[5],
                                q_reg[5],
                                cdividend[25],
                                cremainder[25],
                                cquotient[25]);




    generate
        for(i = 25; i < 27; i = i+1) begin : gen_6
            divu_1iter b1 (cdividend[i],
                                div_reg[5],
                                cremainder[i],
                                cquotient[i],
                                cdividend[i+1],
                                cremainder[i+1],
                                cquotient[i+1]);
        end

    endgenerate


            divu_1iter r6i (cdividend[27],
                                div_reg[5],
                                cremainder[27],
                                cquotient[27],
                                next_divd_reg_6,
                                next_r_reg_6,
                                next_q_reg_6);


            divu_1iter r6o (divd_reg[6],
                                div_reg[6],
                                r_reg[6],
                                q_reg[6],
                                cdividend[29],
                                cremainder[29],
                                cquotient[29]);




    generate
        for(i = 29; i < 31; i = i+1) begin : gen_7
            divu_1iter b1 (cdividend[i],
                                div_reg[6],
                                cremainder[i],
                                cquotient[i],
                                cdividend[i+1],
                                cremainder[i+1],
                                cquotient[i+1]);
        end

    endgenerate


            divu_1iter r7i (cdividend[31],
                                div_reg[6],
                                cremainder[31],
                                cquotient[31],
                                cdividend[32],
                                cremainder[32],
                                cquotient[32]);





    always_ff @(posedge clk) begin

        if (rst) begin
            for (int j = 0; j < 7; j++) begin
                r_reg[j] <= '0;
                q_reg[j] <= '0;
                div_reg[j] <= '0;
                divd_reg[j] <= '0;
            end
        end

        else begin
        r_reg[0] <= next_r_reg_0;
        q_reg[0] <= next_q_reg_0;
        div_reg[0] <= cdivisor[0];
        divd_reg[0] <= next_divd_reg_0;

        r_reg[1] <= next_r_reg_1;
        q_reg[1] <= next_q_reg_1;
        div_reg[1] <= div_reg[0];
        divd_reg[1] <= next_divd_reg_1;

        r_reg[2] <= next_r_reg_2;
        q_reg[2] <= next_q_reg_2;
        div_reg[2] <= div_reg[1];
        divd_reg[2] <= next_divd_reg_2;

        r_reg[3] <= next_r_reg_3;
        q_reg[3] <= next_q_reg_3;
        div_reg[3] <= div_reg[2];
        divd_reg[3] <= next_divd_reg_3;

        r_reg[4] <= next_r_reg_4;
        q_reg[4] <= next_q_reg_4;
        div_reg[4] <= div_reg[3];
        divd_reg[4] <= next_divd_reg_4;

        r_reg[5] <= next_r_reg_5;
        q_reg[5] <= next_q_reg_5;
        div_reg[5] <= div_reg[4];
        divd_reg[5] <= next_divd_reg_5;

        r_reg[6] <= next_r_reg_6;
        q_reg[6] <= next_q_reg_6;
        div_reg[6] <= div_reg[5];
        divd_reg[6] <= next_divd_reg_6;
        
    end
    end

endmodule



module divu_1iter (
    input  wire  [31:0] i_dividend,
    input  wire  [31:0] i_divisor,
    input  wire  [31:0] i_remainder,
    input  wire  [31:0] i_quotient,
    output logic [31:0] o_dividend,
    output logic [31:0] o_remainder,
    output logic [31:0] o_quotient
);

  // TODO: copy your code from HW2A here
    wire [31:0] rnew;
    assign rnew = i_remainder << 1 | (i_dividend >> 31 & 32'h1);

    wire obit = rnew >= i_divisor;
    assign o_remainder = obit ? (rnew - i_divisor) : rnew;
    assign o_quotient = (i_quotient << 1) | ({{31{1'b0}}, obit});
    assign o_dividend = i_dividend << 1;

endmodule
