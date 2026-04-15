module MyClockGen (
	input_clk_25MHz,
	clk_proc,
	locked
);
	input input_clk_25MHz;
	output wire clk_proc;
	output wire locked;
	wire clkfb;
	(* FREQUENCY_PIN_CLKI = "25" *) (* FREQUENCY_PIN_CLKOP = "20" *) (* ICP_CURRENT = "12" *) (* LPF_RESISTOR = "8" *) (* MFG_ENABLE_FILTEROPAMP = "1" *) (* MFG_GMCREF_SEL = "2" *) EHXPLLL #(
		.PLLRST_ENA("DISABLED"),
		.INTFB_WAKE("DISABLED"),
		.STDBY_ENABLE("DISABLED"),
		.DPHASE_SOURCE("DISABLED"),
		.OUTDIVIDER_MUXA("DIVA"),
		.OUTDIVIDER_MUXB("DIVB"),
		.OUTDIVIDER_MUXC("DIVC"),
		.OUTDIVIDER_MUXD("DIVD"),
		.CLKI_DIV(5),
		.CLKOP_ENABLE("ENABLED"),
		.CLKOP_DIV(30),
		.CLKOP_CPHASE(15),
		.CLKOP_FPHASE(0),
		.FEEDBK_PATH("INT_OP"),
		.CLKFB_DIV(4)
	) pll_i(
		.RST(1'b0),
		.STDBY(1'b0),
		.CLKI(input_clk_25MHz),
		.CLKOP(clk_proc),
		.CLKFB(clkfb),
		.CLKINTFB(clkfb),
		.PHASESEL0(1'b0),
		.PHASESEL1(1'b0),
		.PHASEDIR(1'b1),
		.PHASESTEP(1'b1),
		.PHASELOADREG(1'b1),
		.PLLWAKESYNC(1'b0),
		.ENCLKOP(1'b0),
		.LOCK(locked)
	);
endmodule
module gp1 (
	a,
	b,
	g,
	p
);
	input wire a;
	input wire b;
	output wire g;
	output wire p;
	assign g = a & b;
	assign p = a | b;
endmodule
module gp8 (
	gin,
	pin,
	cin,
	gout,
	pout,
	cout
);
	input wire [7:0] gin;
	input wire [7:0] pin;
	input wire cin;
	output wire gout;
	output wire pout;
	output wire [6:0] cout;
	assign pout = &pin;
	assign gout = ((((((gin[7] | (gin[6] & pin[7])) | ((gin[5] & pin[6]) & pin[7])) | (((gin[4] & pin[5]) & pin[6]) & pin[7])) | ((((gin[3] & pin[4]) & pin[5]) & pin[6]) & pin[7])) | (((((gin[2] & pin[3]) & pin[4]) & pin[5]) & pin[6]) & pin[7])) | ((((((gin[1] & pin[2]) & pin[3]) & pin[4]) & pin[5]) & pin[6]) & pin[7])) | (((((((gin[0] & pin[1]) & pin[2]) & pin[3]) & pin[4]) & pin[5]) & pin[6]) & pin[7]);
	assign cout[0] = gin[0] | (pin[0] & cin);
	assign cout[1] = (gin[1] | (pin[1] & gin[0])) | ((pin[1] & pin[0]) & cin);
	assign cout[2] = ((gin[2] | (pin[2] & gin[1])) | ((pin[2] & pin[1]) & gin[0])) | (((pin[2] & pin[1]) & pin[0]) & cin);
	assign cout[3] = (((gin[3] | (pin[3] & gin[2])) | ((pin[3] & pin[2]) & gin[1])) | (((pin[3] & pin[2]) & pin[1]) & gin[0])) | ((((pin[3] & pin[2]) & pin[1]) & pin[0]) & cin);
	assign cout[4] = ((((gin[4] | (pin[4] & gin[3])) | ((pin[4] & pin[3]) & gin[2])) | (((pin[4] & pin[3]) & pin[2]) & gin[1])) | ((((pin[4] & pin[3]) & pin[2]) & pin[1]) & gin[0])) | (((((pin[4] & pin[3]) & pin[2]) & pin[1]) & pin[0]) & cin);
	assign cout[5] = (((((gin[5] | (pin[5] & gin[4])) | ((pin[5] & pin[4]) & gin[3])) | (((pin[5] & pin[4]) & pin[3]) & gin[2])) | ((((pin[5] & pin[4]) & pin[3]) & pin[2]) & gin[1])) | (((((pin[5] & pin[4]) & pin[3]) & pin[2]) & pin[1]) & gin[0])) | ((((((pin[5] & pin[4]) & pin[3]) & pin[2]) & pin[1]) & pin[0]) & cin);
	assign cout[6] = ((((((gin[6] | (pin[6] & gin[5])) | ((pin[6] & pin[5]) & gin[4])) | (((pin[6] & pin[5]) & pin[4]) & gin[3])) | ((((pin[6] & pin[5]) & pin[4]) & pin[3]) & gin[2])) | (((((pin[6] & pin[5]) & pin[4]) & pin[3]) & pin[2]) & gin[1])) | ((((((pin[6] & pin[5]) & pin[4]) & pin[3]) & pin[2]) & pin[1]) & gin[0])) | (((((((pin[6] & pin[5]) & pin[4]) & pin[3]) & pin[2]) & pin[1]) & pin[0]) & cin);
endmodule
module CarryLookaheadAdder (
	a,
	b,
	cin,
	sum
);
	input wire [31:0] a;
	input wire [31:0] b;
	input wire cin;
	output wire [31:0] sum;
	reg [31:0] gens;
	reg [31:0] props;
	reg [31:0] carrys;
	wire [1:1] sv2v_tmp_219DD;
	assign sv2v_tmp_219DD = cin;
	always @(*) carrys[0] = sv2v_tmp_219DD;
	wire pout0;
	wire pout1;
	wire pout2;
	wire pout3;
	wire gout0;
	wire gout1;
	wire gout2;
	wire gout3;
	genvar _gv_i_1;
	genvar _gv_j_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < 32; _gv_i_1 = _gv_i_1 + 1) begin : genblk1
			localparam i = _gv_i_1;
			wire [1:1] sv2v_tmp_x_g;
			always @(*) gens[i] = sv2v_tmp_x_g;
			wire [1:1] sv2v_tmp_x_p;
			always @(*) props[i] = sv2v_tmp_x_p;
			gp1 x(
				.a(a[i]),
				.b(b[i]),
				.g(sv2v_tmp_x_g),
				.p(sv2v_tmp_x_p)
			);
		end
	endgenerate
	wire [7:1] sv2v_tmp_one_cout;
	always @(*) carrys[7:1] = sv2v_tmp_one_cout;
	gp8 one(
		.gin(gens[7:0]),
		.pin(props[7:0]),
		.cin(cin),
		.gout(gout0),
		.pout(pout0),
		.cout(sv2v_tmp_one_cout)
	);
	wire [7:1] sv2v_tmp_two_cout;
	always @(*) carrys[15:9] = sv2v_tmp_two_cout;
	gp8 two(
		.gin(gens[15:8]),
		.pin(props[15:8]),
		.cin(gout0 | (cin & pout0)),
		.gout(gout1),
		.pout(pout1),
		.cout(sv2v_tmp_two_cout)
	);
	wire [7:1] sv2v_tmp_three_cout;
	always @(*) carrys[23:17] = sv2v_tmp_three_cout;
	gp8 three(
		.gin(gens[23:16]),
		.pin(props[23:16]),
		.cin((gout1 | ((cin & pout0) & pout1)) | (gout0 & pout1)),
		.gout(gout2),
		.pout(pout2),
		.cout(sv2v_tmp_three_cout)
	);
	wire [7:1] sv2v_tmp_four_cout;
	always @(*) carrys[31:25] = sv2v_tmp_four_cout;
	gp8 four(
		.gin(gens[31:24]),
		.pin(props[31:24]),
		.cin(((gout2 | (((cin & pout0) & pout1) & pout2)) | ((gout0 & pout1) & pout2)) | (gout1 & pout2)),
		.gout(),
		.pout(),
		.cout(sv2v_tmp_four_cout)
	);
	wire [1:1] sv2v_tmp_8ECF7;
	assign sv2v_tmp_8ECF7 = gout0 | (cin & pout0);
	always @(*) carrys[8] = sv2v_tmp_8ECF7;
	wire [1:1] sv2v_tmp_C3F0C;
	assign sv2v_tmp_C3F0C = (gout1 | ((cin & pout0) & pout1)) | (gout0 & pout1);
	always @(*) carrys[16] = sv2v_tmp_C3F0C;
	wire [1:1] sv2v_tmp_382C8;
	assign sv2v_tmp_382C8 = ((gout2 | (((cin & pout0) & pout1) & pout2)) | ((gout0 & pout1) & pout2)) | (gout1 & pout2);
	always @(*) carrys[24] = sv2v_tmp_382C8;
	generate
		for (_gv_j_1 = 0; _gv_j_1 < 32; _gv_j_1 = _gv_j_1 + 1) begin : genblk2
			localparam j = _gv_j_1;
			fulladder f(
				.cin(carrys[j]),
				.a(a[j]),
				.b(b[j]),
				.s(sum[j]),
				.cout()
			);
		end
	endgenerate
endmodule
module halfadder (
	a,
	b,
	s,
	cout
);
	input wire a;
	input wire b;
	output wire s;
	output wire cout;
	assign s = a ^ b;
	assign cout = a & b;
endmodule
module fulladder (
	cin,
	a,
	b,
	s,
	cout
);
	input wire cin;
	input wire a;
	input wire b;
	output wire s;
	output wire cout;
	wire s_tmp;
	wire cout_tmp1;
	wire cout_tmp2;
	halfadder h0(
		.a(a),
		.b(b),
		.s(s_tmp),
		.cout(cout_tmp1)
	);
	halfadder h1(
		.a(s_tmp),
		.b(cin),
		.s(s),
		.cout(cout_tmp2)
	);
	assign cout = cout_tmp1 | cout_tmp2;
endmodule
module DividerUnsignedPipelined (
	clk,
	rst,
	stall,
	i_dividend,
	i_divisor,
	o_remainder,
	o_quotient
);
	input wire clk;
	input wire rst;
	input wire stall;
	input wire [31:0] i_dividend;
	input wire [31:0] i_divisor;
	output wire [31:0] o_remainder;
	output wire [31:0] o_quotient;
	genvar _gv_i_2;
	wire [31:0] cdividend [0:32];
	wire [31:0] cremainder [0:32];
	wire [31:0] cquotient [0:32];
	wire [31:0] cdivisor [0:32];
	reg [31:0] r_reg [0:6];
	reg [31:0] q_reg [0:6];
	reg [31:0] divd_reg [0:6];
	reg [31:0] div_reg [0:6];
	wire [31:0] next_r_reg_0;
	wire [31:0] next_q_reg_0;
	wire [31:0] next_divd_reg_0;
	wire [31:0] next_r_reg_1;
	wire [31:0] next_q_reg_1;
	wire [31:0] next_divd_reg_1;
	wire [31:0] next_r_reg_2;
	wire [31:0] next_q_reg_2;
	wire [31:0] next_divd_reg_2;
	wire [31:0] next_r_reg_3;
	wire [31:0] next_q_reg_3;
	wire [31:0] next_divd_reg_3;
	wire [31:0] next_r_reg_4;
	wire [31:0] next_q_reg_4;
	wire [31:0] next_divd_reg_4;
	wire [31:0] next_r_reg_5;
	wire [31:0] next_q_reg_5;
	wire [31:0] next_divd_reg_5;
	wire [31:0] next_r_reg_6;
	wire [31:0] next_q_reg_6;
	wire [31:0] next_divd_reg_6;
	assign cdividend[0] = i_dividend;
	assign cremainder[0] = 1'sb0;
	assign cquotient[0] = 1'sb0;
	assign cdivisor[0] = i_divisor;
	assign o_remainder = cremainder[32];
	assign o_quotient = cquotient[32];
	generate
		for (_gv_i_2 = 0; _gv_i_2 < 3; _gv_i_2 = _gv_i_2 + 1) begin : gen_0
			localparam i = _gv_i_2;
			divu_1iter b1(
				.i_dividend(cdividend[i]),
				.i_divisor(cdivisor[0]),
				.i_remainder(cremainder[i]),
				.i_quotient(cquotient[i]),
				.o_dividend(cdividend[i + 1]),
				.o_remainder(cremainder[i + 1]),
				.o_quotient(cquotient[i + 1])
			);
		end
	endgenerate
	divu_1iter r0i(
		.i_dividend(cdividend[3]),
		.i_divisor(cdivisor[0]),
		.i_remainder(cremainder[3]),
		.i_quotient(cquotient[3]),
		.o_dividend(next_divd_reg_0),
		.o_remainder(next_r_reg_0),
		.o_quotient(next_q_reg_0)
	);
	divu_1iter r0o(
		.i_dividend(divd_reg[0]),
		.i_divisor(div_reg[0]),
		.i_remainder(r_reg[0]),
		.i_quotient(q_reg[0]),
		.o_dividend(cdividend[5]),
		.o_remainder(cremainder[5]),
		.o_quotient(cquotient[5])
	);
	generate
		for (_gv_i_2 = 5; _gv_i_2 < 7; _gv_i_2 = _gv_i_2 + 1) begin : gen_1
			localparam i = _gv_i_2;
			divu_1iter b1(
				.i_dividend(cdividend[i]),
				.i_divisor(div_reg[0]),
				.i_remainder(cremainder[i]),
				.i_quotient(cquotient[i]),
				.o_dividend(cdividend[i + 1]),
				.o_remainder(cremainder[i + 1]),
				.o_quotient(cquotient[i + 1])
			);
		end
	endgenerate
	divu_1iter r1i(
		.i_dividend(cdividend[7]),
		.i_divisor(div_reg[0]),
		.i_remainder(cremainder[7]),
		.i_quotient(cquotient[7]),
		.o_dividend(next_divd_reg_1),
		.o_remainder(next_r_reg_1),
		.o_quotient(next_q_reg_1)
	);
	divu_1iter r1o(
		.i_dividend(divd_reg[1]),
		.i_divisor(div_reg[1]),
		.i_remainder(r_reg[1]),
		.i_quotient(q_reg[1]),
		.o_dividend(cdividend[9]),
		.o_remainder(cremainder[9]),
		.o_quotient(cquotient[9])
	);
	generate
		for (_gv_i_2 = 9; _gv_i_2 < 11; _gv_i_2 = _gv_i_2 + 1) begin : gen_2
			localparam i = _gv_i_2;
			divu_1iter b1(
				.i_dividend(cdividend[i]),
				.i_divisor(div_reg[1]),
				.i_remainder(cremainder[i]),
				.i_quotient(cquotient[i]),
				.o_dividend(cdividend[i + 1]),
				.o_remainder(cremainder[i + 1]),
				.o_quotient(cquotient[i + 1])
			);
		end
	endgenerate
	divu_1iter r2i(
		.i_dividend(cdividend[11]),
		.i_divisor(div_reg[1]),
		.i_remainder(cremainder[11]),
		.i_quotient(cquotient[11]),
		.o_dividend(next_divd_reg_2),
		.o_remainder(next_r_reg_2),
		.o_quotient(next_q_reg_2)
	);
	divu_1iter r2o(
		.i_dividend(divd_reg[2]),
		.i_divisor(div_reg[2]),
		.i_remainder(r_reg[2]),
		.i_quotient(q_reg[2]),
		.o_dividend(cdividend[13]),
		.o_remainder(cremainder[13]),
		.o_quotient(cquotient[13])
	);
	generate
		for (_gv_i_2 = 13; _gv_i_2 < 15; _gv_i_2 = _gv_i_2 + 1) begin : gen_3
			localparam i = _gv_i_2;
			divu_1iter b1(
				.i_dividend(cdividend[i]),
				.i_divisor(div_reg[2]),
				.i_remainder(cremainder[i]),
				.i_quotient(cquotient[i]),
				.o_dividend(cdividend[i + 1]),
				.o_remainder(cremainder[i + 1]),
				.o_quotient(cquotient[i + 1])
			);
		end
	endgenerate
	divu_1iter r3i(
		.i_dividend(cdividend[15]),
		.i_divisor(div_reg[2]),
		.i_remainder(cremainder[15]),
		.i_quotient(cquotient[15]),
		.o_dividend(next_divd_reg_3),
		.o_remainder(next_r_reg_3),
		.o_quotient(next_q_reg_3)
	);
	divu_1iter r3o(
		.i_dividend(divd_reg[3]),
		.i_divisor(div_reg[3]),
		.i_remainder(r_reg[3]),
		.i_quotient(q_reg[3]),
		.o_dividend(cdividend[17]),
		.o_remainder(cremainder[17]),
		.o_quotient(cquotient[17])
	);
	generate
		for (_gv_i_2 = 17; _gv_i_2 < 19; _gv_i_2 = _gv_i_2 + 1) begin : gen_4
			localparam i = _gv_i_2;
			divu_1iter b1(
				.i_dividend(cdividend[i]),
				.i_divisor(div_reg[3]),
				.i_remainder(cremainder[i]),
				.i_quotient(cquotient[i]),
				.o_dividend(cdividend[i + 1]),
				.o_remainder(cremainder[i + 1]),
				.o_quotient(cquotient[i + 1])
			);
		end
	endgenerate
	divu_1iter r4i(
		.i_dividend(cdividend[19]),
		.i_divisor(div_reg[3]),
		.i_remainder(cremainder[19]),
		.i_quotient(cquotient[19]),
		.o_dividend(next_divd_reg_4),
		.o_remainder(next_r_reg_4),
		.o_quotient(next_q_reg_4)
	);
	divu_1iter r4o(
		.i_dividend(divd_reg[4]),
		.i_divisor(div_reg[4]),
		.i_remainder(r_reg[4]),
		.i_quotient(q_reg[4]),
		.o_dividend(cdividend[21]),
		.o_remainder(cremainder[21]),
		.o_quotient(cquotient[21])
	);
	generate
		for (_gv_i_2 = 21; _gv_i_2 < 23; _gv_i_2 = _gv_i_2 + 1) begin : gen_5
			localparam i = _gv_i_2;
			divu_1iter b1(
				.i_dividend(cdividend[i]),
				.i_divisor(div_reg[4]),
				.i_remainder(cremainder[i]),
				.i_quotient(cquotient[i]),
				.o_dividend(cdividend[i + 1]),
				.o_remainder(cremainder[i + 1]),
				.o_quotient(cquotient[i + 1])
			);
		end
	endgenerate
	divu_1iter r5i(
		.i_dividend(cdividend[23]),
		.i_divisor(div_reg[4]),
		.i_remainder(cremainder[23]),
		.i_quotient(cquotient[23]),
		.o_dividend(next_divd_reg_5),
		.o_remainder(next_r_reg_5),
		.o_quotient(next_q_reg_5)
	);
	divu_1iter r5o(
		.i_dividend(divd_reg[5]),
		.i_divisor(div_reg[5]),
		.i_remainder(r_reg[5]),
		.i_quotient(q_reg[5]),
		.o_dividend(cdividend[25]),
		.o_remainder(cremainder[25]),
		.o_quotient(cquotient[25])
	);
	generate
		for (_gv_i_2 = 25; _gv_i_2 < 27; _gv_i_2 = _gv_i_2 + 1) begin : gen_6
			localparam i = _gv_i_2;
			divu_1iter b1(
				.i_dividend(cdividend[i]),
				.i_divisor(div_reg[5]),
				.i_remainder(cremainder[i]),
				.i_quotient(cquotient[i]),
				.o_dividend(cdividend[i + 1]),
				.o_remainder(cremainder[i + 1]),
				.o_quotient(cquotient[i + 1])
			);
		end
	endgenerate
	divu_1iter r6i(
		.i_dividend(cdividend[27]),
		.i_divisor(div_reg[5]),
		.i_remainder(cremainder[27]),
		.i_quotient(cquotient[27]),
		.o_dividend(next_divd_reg_6),
		.o_remainder(next_r_reg_6),
		.o_quotient(next_q_reg_6)
	);
	divu_1iter r6o(
		.i_dividend(divd_reg[6]),
		.i_divisor(div_reg[6]),
		.i_remainder(r_reg[6]),
		.i_quotient(q_reg[6]),
		.o_dividend(cdividend[29]),
		.o_remainder(cremainder[29]),
		.o_quotient(cquotient[29])
	);
	generate
		for (_gv_i_2 = 29; _gv_i_2 < 31; _gv_i_2 = _gv_i_2 + 1) begin : gen_7
			localparam i = _gv_i_2;
			divu_1iter b1(
				.i_dividend(cdividend[i]),
				.i_divisor(div_reg[6]),
				.i_remainder(cremainder[i]),
				.i_quotient(cquotient[i]),
				.o_dividend(cdividend[i + 1]),
				.o_remainder(cremainder[i + 1]),
				.o_quotient(cquotient[i + 1])
			);
		end
	endgenerate
	divu_1iter r7i(
		.i_dividend(cdividend[31]),
		.i_divisor(div_reg[6]),
		.i_remainder(cremainder[31]),
		.i_quotient(cquotient[31]),
		.o_dividend(cdividend[32]),
		.o_remainder(cremainder[32]),
		.o_quotient(cquotient[32])
	);
	always @(posedge clk)
		if (rst) begin : sv2v_autoblock_1
			reg signed [31:0] j;
			for (j = 0; j < 7; j = j + 1)
				begin
					r_reg[j] <= 1'sb0;
					q_reg[j] <= 1'sb0;
					div_reg[j] <= 1'sb0;
					divd_reg[j] <= 1'sb0;
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
endmodule
module divu_1iter (
	i_dividend,
	i_divisor,
	i_remainder,
	i_quotient,
	o_dividend,
	o_remainder,
	o_quotient
);
	input wire [31:0] i_dividend;
	input wire [31:0] i_divisor;
	input wire [31:0] i_remainder;
	input wire [31:0] i_quotient;
	output wire [31:0] o_dividend;
	output wire [31:0] o_remainder;
	output wire [31:0] o_quotient;
	wire [31:0] rnew;
	assign rnew = (i_remainder << 1) | ((i_dividend >> 31) & 32'h00000001);
	wire obit = rnew >= i_divisor;
	assign o_remainder = (obit ? rnew - i_divisor : rnew);
	assign o_quotient = (i_quotient << 1) | {{31 {1'b0}}, obit};
	assign o_dividend = i_dividend << 1;
endmodule
module Disasm (
	insn,
	disasm
);
	parameter signed [7:0] PREFIX = "D";
	input wire [31:0] insn;
	output wire [255:0] disasm;
endmodule
module RegFile (
	rd,
	rd_data,
	rs1,
	rs1_data,
	rs2,
	rs2_data,
	clk,
	we,
	rst
);
	reg _sv2v_0;
	input wire [4:0] rd;
	input wire [31:0] rd_data;
	input wire [4:0] rs1;
	output reg [31:0] rs1_data;
	input wire [4:0] rs2;
	output reg [31:0] rs2_data;
	input wire clk;
	input wire we;
	input wire rst;
	localparam signed [31:0] NumRegs = 32;
	reg [31:0] regs [0:31];
	always @(*) begin
		if (_sv2v_0)
			;
		if ((((rs1 == rd) && we) && (rd != 0)) && (rs2 == rd)) begin
			rs1_data = rd_data;
			rs2_data = rd_data;
		end
		else if (((rs1 == rd) && we) && (rd != {5 {1'sb0}})) begin
			rs1_data = rd_data;
			rs2_data = regs[rs2];
		end
		else if (((rs2 == rd) && we) && (rd != {5 {1'sb0}})) begin
			rs2_data = rd_data;
			rs1_data = regs[rs1];
		end
		else begin
			rs1_data = regs[rs1];
			rs2_data = regs[rs2];
		end
	end
	always @(posedge clk)
		if (rst) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < NumRegs; i = i + 1)
				regs[i] <= 1'sb0;
		end
		else if (we && |rd)
			regs[rd] <= rd_data;
	initial _sv2v_0 = 0;
endmodule
module DatapathPipelined (
	clk,
	rst,
	pc_to_imem,
	insn_from_imem,
	addr_to_dmem,
	load_data_from_dmem,
	store_data_to_dmem,
	store_we_to_dmem,
	halt,
	trace_completed_pc,
	trace_completed_insn,
	trace_completed_cycle_status
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	output wire [31:0] pc_to_imem;
	input wire [31:0] insn_from_imem;
	output wire [31:0] addr_to_dmem;
	input wire [31:0] load_data_from_dmem;
	output reg [31:0] store_data_to_dmem;
	output reg [3:0] store_we_to_dmem;
	output reg halt;
	output wire [31:0] trace_completed_pc;
	output wire [31:0] trace_completed_insn;
	output wire [31:0] trace_completed_cycle_status;
	reg [31:0] cycles_current;
	always @(posedge clk)
		if (rst)
			cycles_current <= 0;
		else
			cycles_current <= cycles_current + 1;
	reg [31:0] f_pc_current;
	wire [31:0] f_insn;
	reg [31:0] f_cycle_status;
	reg [31:0] branch_pc;
	reg branch_taken;
	reg [6:0] div_valid;
	reg [169:0] execute_state;
	wire e_is_div = ((((execute_state[112:106] == 7'b0110011) && (execute_state[137:131] == 7'd1)) && (execute_state[120] == 1'b1)) && (execute_state[105-:32] != 32'd2)) && (execute_state[105-:32] != 32'd4);
	wire e_is_valid = ((execute_state[137-:32] != 0) && (execute_state[105-:32] != 32'd4)) && (execute_state[105-:32] != 32'd2);
	wire e_non_div_stall = (e_is_valid && !e_is_div) && |div_valid;
	reg div_dep_stall;
	localparam [6:0] OpStore = 7'b0100011;
	reg [95:0] decode_state;
	wire [6:0] d_insn_opcode = decode_state[38:32];
	localparam [6:0] OpLoad = 7'b0000011;
	wire d_is_load = execute_state[112:106] == OpLoad;
	localparam [6:0] OpBranch = 7'b1100011;
	localparam [6:0] OpJalr = 7'b1100111;
	localparam [6:0] OpRegImm = 7'b0010011;
	localparam [6:0] OpRegReg = 7'b0110011;
	wire d_reads_rs1 = (((((d_insn_opcode == OpLoad) || (d_insn_opcode == OpStore)) || (d_insn_opcode == OpBranch)) || (d_insn_opcode == OpJalr)) || (d_insn_opcode == OpRegImm)) || (d_insn_opcode == OpRegReg);
	wire d_reads_rs2 = ((d_insn_opcode == OpStore) || (d_insn_opcode == OpBranch)) || (d_insn_opcode == OpRegReg);
	wire [4:0] d_rs1 = decode_state[51:47];
	wire [4:0] d_rs2 = decode_state[56:52];
	wire [4:0] e_rd = execute_state[117:113];
	wire load_stall = (d_is_load && (e_rd != 0)) && ((d_reads_rs1 && (e_rd == d_rs1)) || ((d_reads_rs2 && (e_rd == d_rs2)) && (d_insn_opcode != OpStore)));
	wire overall_stall = (load_stall || div_dep_stall) || e_non_div_stall;
	always @(posedge clk)
		if (rst) begin
			f_pc_current <= 32'd0;
			f_cycle_status <= 32'd1;
		end
		else if (branch_taken && !e_non_div_stall) begin
			f_cycle_status <= 32'd1;
			f_pc_current <= branch_pc;
		end
		else if (overall_stall)
			f_pc_current <= f_pc_current;
		else begin
			f_cycle_status <= 32'd1;
			f_pc_current <= f_pc_current + 4;
		end
	assign pc_to_imem = f_pc_current;
	assign f_insn = insn_from_imem;
	wire [255:0] f_disasm;
	Disasm #(.PREFIX("F")) disasm_0fetch(
		.insn(f_insn),
		.disasm(f_disasm)
	);
	wire [31:0] d_pc_current;
	wire [31:0] d_insn;
	wire [31:0] d_cycle_status;
	wire is_stall;
	wire [3:0] div_insns;
	assign d_pc_current = decode_state[95-:32];
	assign d_insn = decode_state[63-:32];
	wire d_insn_div = ((d_insn_opcode == OpRegReg) && (d_insn[31:25] == 7'd1)) && (d_insn[14:12] == 3'b100);
	wire d_insn_divu = ((d_insn_opcode == OpRegReg) && (d_insn[31:25] == 7'd1)) && (d_insn[14:12] == 3'b101);
	wire d_insn_rem = ((d_insn_opcode == OpRegReg) && (d_insn[31:25] == 7'd1)) && (d_insn[14:12] == 3'b110);
	wire d_insn_remu = ((d_insn_opcode == OpRegReg) && (d_insn[31:25] == 7'd1)) && (d_insn[14:12] == 3'b111);
	wire [31:0] e_insn = execute_state[137-:32];
	wire [6:0] insn_opcode = execute_state[112:106];
	wire insn_div = ((insn_opcode == OpRegReg) && (e_insn[31:25] == 7'd1)) && (e_insn[14:12] == 3'b100);
	wire insn_divu = ((insn_opcode == OpRegReg) && (e_insn[31:25] == 7'd1)) && (e_insn[14:12] == 3'b101);
	wire insn_rem = ((insn_opcode == OpRegReg) && (e_insn[31:25] == 7'd1)) && (e_insn[14:12] == 3'b110);
	wire insn_remu = ((insn_opcode == OpRegReg) && (e_insn[31:25] == 7'd1)) && (e_insn[14:12] == 3'b111);
	wire d_div_insn = ((insn_div | insn_divu) | insn_rem) | insn_remu;
	reg [98:0] div_pipe [6:0];
	always @(*) begin
		if (_sv2v_0)
			;
		div_dep_stall = 1'b0;
		if ((e_is_div && (e_rd != 0)) && ((d_rs1 == e_rd) || (d_rs2 == e_rd)))
			div_dep_stall = 1'b1;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 6; i = i + 1)
				if ((div_valid[i] && (div_pipe[i][46:42] != 0)) && ((d_rs1 == div_pipe[i][46:42]) || (d_rs2 == div_pipe[i][46:42])))
					div_dep_stall = 1'b1;
		end
	end
	always @(posedge clk)
		if (rst)
			decode_state <= 96'h000000000000000000000004;
		else if (branch_taken && !e_non_div_stall)
			decode_state <= 96'h000000000000000000000008;
		else if (overall_stall)
			decode_state <= decode_state;
		else
			decode_state <= {f_pc_current, f_insn, f_cycle_status};
	wire [255:0] d_disasm;
	Disasm #(.PREFIX("D")) disasm_1decode(
		.insn(decode_state[63-:32]),
		.disasm(d_disasm)
	);
	wire [31:0] d_reg1;
	wire [31:0] d_reg2;
	reg [165:0] wb_state;
	wire [31:0] w_data = (wb_state[108:102] == OpLoad ? wb_state[69-:32] : wb_state[37-:32]);
	reg [4:0] w_rd;
	RegFile rf(
		.clk(clk),
		.rst(rst),
		.rs1_data(d_reg1),
		.rs2_data(d_reg2),
		.rs1(d_rs1),
		.rs2(d_rs2),
		.we(wb_state[0]),
		.rd(w_rd),
		.rd_data(w_data)
	);
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	always @(posedge clk)
		if (rst)
			execute_state <= 170'h0000000000000000000000010000000000000000000;
		else if (e_non_div_stall)
			execute_state <= execute_state;
		else if (load_stall)
			execute_state <= 170'h0000000000000000000000040000000000000000000;
		else if (branch_taken)
			execute_state <= 170'h0000000000000000000000020000000000000000000;
		else if (div_dep_stall)
			execute_state <= 170'h0000000000000000000000008000000000000000000;
		else
			execute_state <= {sv2v_cast_32(decode_state[95-:32]), d_insn, sv2v_cast_32(decode_state[31-:32]), d_reg1, d_reg2, d_rs1, d_rs2};
	wire [255:0] e_disasm;
	Disasm #(.PREFIX("X")) disasm_2exeucute(
		.insn(execute_state[137-:32]),
		.disasm(e_disasm)
	);
	wire [31:0] e_pc_current;
	wire e_wb;
	reg [31:0] output_d;
	wire [2:0] e_funct3 = execute_state[120:118];
	wire [6:0] e_funct7 = execute_state[137:131];
	wire [11:0] e_imm_i = execute_state[137:126];
	wire [4:0] e_imm_shamt = execute_state[130:126];
	wire [11:0] e_imm_s;
	assign e_imm_s[11:5] = execute_state[137:131];
	assign e_imm_s[4:0] = execute_state[117:113];
	wire [12:0] e_imm_b;
	assign {e_imm_b[12], e_imm_b[10:5]} = execute_state[137:131];
	assign {e_imm_b[4:1], e_imm_b[11]} = execute_state[117:113];
	assign e_imm_b[0] = 1'b0;
	wire [20:0] e_imm_j;
	assign {e_imm_j[20], e_imm_j[10:1], e_imm_j[11], e_imm_j[19:12], e_imm_j[0]} = {execute_state[137:118], 1'b0};
	wire [31:0] e_imm_u = {execute_state[137:118], 12'b000000000000};
	wire [31:0] e_imm_i_sext = {{20 {e_imm_i[11]}}, e_imm_i[11:0]};
	wire [31:0] e_imm_s_sext = {{20 {e_imm_s[11]}}, e_imm_s[11:0]};
	wire [31:0] e_imm_b_sext = {{19 {e_imm_b[12]}}, e_imm_b[12:0]};
	wire [31:0] e_imm_j_sext = {{11 {e_imm_j[20]}}, e_imm_j[20:0]};
	localparam [6:0] OpMiscMem = 7'b0001111;
	localparam [6:0] OpJal = 7'b1101111;
	localparam [6:0] OpEnviron = 7'b1110011;
	localparam [6:0] OpAuipc = 7'b0010111;
	localparam [6:0] OpLui = 7'b0110111;
	wire insn_lui = insn_opcode == OpLui;
	wire insn_auipc = insn_opcode == OpAuipc;
	wire insn_jal = insn_opcode == OpJal;
	wire insn_jalr = insn_opcode == OpJalr;
	wire insn_beq = (insn_opcode == OpBranch) && (e_insn[14:12] == 3'b000);
	wire insn_bne = (insn_opcode == OpBranch) && (e_insn[14:12] == 3'b001);
	wire insn_blt = (insn_opcode == OpBranch) && (e_insn[14:12] == 3'b100);
	wire insn_bge = (insn_opcode == OpBranch) && (e_insn[14:12] == 3'b101);
	wire insn_bltu = (insn_opcode == OpBranch) && (e_insn[14:12] == 3'b110);
	wire insn_bgeu = (insn_opcode == OpBranch) && (e_insn[14:12] == 3'b111);
	wire insn_lb = (insn_opcode == OpLoad) && (e_insn[14:12] == 3'b000);
	wire insn_lh = (insn_opcode == OpLoad) && (e_insn[14:12] == 3'b001);
	wire insn_lw = (insn_opcode == OpLoad) && (e_insn[14:12] == 3'b010);
	wire insn_lbu = (insn_opcode == OpLoad) && (e_insn[14:12] == 3'b100);
	wire insn_lhu = (insn_opcode == OpLoad) && (e_insn[14:12] == 3'b101);
	wire insn_sb = (insn_opcode == OpStore) && (e_insn[14:12] == 3'b000);
	wire insn_sh = (insn_opcode == OpStore) && (e_insn[14:12] == 3'b001);
	wire insn_sw = (insn_opcode == OpStore) && (e_insn[14:12] == 3'b010);
	wire insn_addi = (insn_opcode == OpRegImm) && (e_insn[14:12] == 3'b000);
	wire insn_slti = (insn_opcode == OpRegImm) && (e_insn[14:12] == 3'b010);
	wire insn_sltiu = (insn_opcode == OpRegImm) && (e_insn[14:12] == 3'b011);
	wire insn_xori = (insn_opcode == OpRegImm) && (e_insn[14:12] == 3'b100);
	wire insn_ori = (insn_opcode == OpRegImm) && (e_insn[14:12] == 3'b110);
	wire insn_andi = (insn_opcode == OpRegImm) && (e_insn[14:12] == 3'b111);
	wire insn_slli = ((insn_opcode == OpRegImm) && (e_insn[14:12] == 3'b001)) && (e_insn[31:25] == 7'd0);
	wire insn_srli = ((insn_opcode == OpRegImm) && (e_insn[14:12] == 3'b101)) && (e_insn[31:25] == 7'd0);
	wire insn_srai = ((insn_opcode == OpRegImm) && (e_insn[14:12] == 3'b101)) && (e_insn[31:25] == 7'b0100000);
	wire insn_add = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b000)) && (e_insn[31:25] == 7'd0);
	wire insn_sub = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b000)) && (e_insn[31:25] == 7'b0100000);
	wire insn_sll = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b001)) && (e_insn[31:25] == 7'd0);
	wire insn_slt = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b010)) && (e_insn[31:25] == 7'd0);
	wire insn_sltu = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b011)) && (e_insn[31:25] == 7'd0);
	wire insn_xor = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b100)) && (e_insn[31:25] == 7'd0);
	wire insn_srl = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b101)) && (e_insn[31:25] == 7'd0);
	wire insn_sra = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b101)) && (e_insn[31:25] == 7'b0100000);
	wire insn_or = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b110)) && (e_insn[31:25] == 7'd0);
	wire insn_and = ((insn_opcode == OpRegReg) && (e_insn[14:12] == 3'b111)) && (e_insn[31:25] == 7'd0);
	wire insn_mul = ((insn_opcode == OpRegReg) && (e_insn[31:25] == 7'd1)) && (e_insn[14:12] == 3'b000);
	wire insn_mulh = ((insn_opcode == OpRegReg) && (e_insn[31:25] == 7'd1)) && (e_insn[14:12] == 3'b001);
	wire insn_mulhsu = ((insn_opcode == OpRegReg) && (e_insn[31:25] == 7'd1)) && (e_insn[14:12] == 3'b010);
	wire insn_mulhu = ((insn_opcode == OpRegReg) && (e_insn[31:25] == 7'd1)) && (e_insn[14:12] == 3'b011);
	wire div_insn = ((insn_div | insn_divu) | insn_rem) | insn_remu;
	wire [4:0] e_rs1 = execute_state[125:121];
	wire [4:0] e_rs2 = execute_state[130:126];
	wire insn_ecall = (insn_opcode == OpEnviron) && (e_insn[31:7] == 25'd0);
	wire insn_fence = insn_opcode == OpMiscMem;
	reg [31:0] rs1_data;
	reg [31:0] rs2_data;
	reg [31:0] cla_b;
	wire [31:0] cla_sum;
	reg cla_cin;
	wire [31:0] div_rem;
	wire [31:0] div_q;
	reg [31:0] div_b_input;
	reg [31:0] div_a_input;
	CarryLookaheadAdder cla(
		.a(rs1_data),
		.b(cla_b),
		.cin(cla_cin),
		.sum(cla_sum)
	);
	DividerUnsignedPipelined div(
		.clk(clk),
		.rst(rst),
		.stall(0),
		.i_dividend(div_a_input),
		.i_divisor(div_b_input),
		.o_remainder(div_rem),
		.o_quotient(div_q)
	);
	reg illegal_insn;
	reg we;
	wire [4:0] dest;
	reg [31:0] load_addr;
	reg [63:0] large_mul;
	reg [175:0] memory_state;
	always @(*) begin : sv2v_autoblock_2
		reg e_reads_rs1;
		reg e_reads_rs2;
		if (_sv2v_0)
			;
		e_reads_rs1 = (((((insn_opcode == OpLoad) || (insn_opcode == OpStore)) || (insn_opcode == OpBranch)) || (insn_opcode == OpJalr)) || (insn_opcode == OpRegImm)) || (insn_opcode == OpRegReg);
		e_reads_rs2 = ((insn_opcode == OpStore) || (insn_opcode == OpBranch)) || (insn_opcode == OpRegReg);
		if (((e_reads_rs1 && memory_state[10]) && (execute_state[9-:5] != 0)) && (execute_state[9-:5] == memory_state[15-:5]))
			rs1_data = memory_state[79-:32];
		else if (((e_reads_rs1 && wb_state[0]) && (execute_state[9-:5] != 0)) && (execute_state[9-:5] == wb_state[5-:5]))
			rs1_data = w_data;
		else
			rs1_data = execute_state[73-:32];
		if (((e_reads_rs2 && memory_state[10]) && (execute_state[4-:5] != 0)) && (execute_state[4-:5] == memory_state[15-:5]))
			rs2_data = memory_state[79-:32];
		else if (((e_reads_rs2 && wb_state[0]) && (execute_state[4-:5] != 0)) && (execute_state[4-:5] == wb_state[5-:5]))
			rs2_data = w_data;
		else
			rs2_data = execute_state[41-:32];
	end
	always @(*) begin
		if (_sv2v_0)
			;
		illegal_insn = 1'b0;
		we = 1'b0;
		output_d = 1'sb0;
		cla_b = 1'sb0;
		cla_cin = 1'sb0;
		load_addr = 1'sb0;
		large_mul = 1'sb0;
		div_b_input = 1'sb0;
		div_a_input = 1'sb0;
		branch_taken = 1'sb0;
		branch_pc = 1'sb0;
		case (insn_opcode)
			OpLui: begin
				output_d = {execute_state[137:118], 12'b000000000000};
				we = 1;
			end
			OpRegImm: begin
				we = 1;
				if (insn_addi) begin
					cla_b = e_imm_i_sext;
					cla_cin = 0;
					output_d = cla_sum;
				end
				else if (insn_slti)
					output_d = {31'b0000000000000000000000000000000, $signed(rs1_data) < $signed(e_imm_i_sext)};
				else if (insn_sltiu)
					output_d = {31'b0000000000000000000000000000000, rs1_data < e_imm_i_sext};
				else if (insn_xori)
					output_d = rs1_data ^ e_imm_i_sext;
				else if (insn_ori)
					output_d = rs1_data | e_imm_i_sext;
				else if (insn_andi)
					output_d = rs1_data & e_imm_i_sext;
				else if (insn_slli)
					output_d = rs1_data << e_imm_shamt;
				else if (insn_srli)
					output_d = rs1_data >> e_imm_shamt;
				else if (insn_srai)
					output_d = $signed(rs1_data) >>> e_imm_shamt;
				else
					illegal_insn = 1'b1;
			end
			OpRegReg: begin
				we = 1;
				if (insn_add) begin
					cla_b = rs2_data;
					cla_cin = 0;
					output_d = cla_sum;
				end
				else if (insn_sub) begin
					cla_b = ~rs2_data;
					cla_cin = 1;
					output_d = cla_sum;
				end
				else if (insn_sll)
					output_d = rs1_data << rs2_data[4:0];
				else if (insn_slt)
					output_d = {31'b0000000000000000000000000000000, $signed(rs1_data) < $signed(rs2_data)};
				else if (insn_sltu)
					output_d = {31'b0000000000000000000000000000000, rs1_data < rs2_data};
				else if (insn_xor)
					output_d = rs1_data ^ rs2_data;
				else if (insn_srl)
					output_d = rs1_data >> rs2_data[4:0];
				else if (insn_sra)
					output_d = $signed(rs1_data) >>> rs2_data[4:0];
				else if (insn_or)
					output_d = rs1_data | rs2_data;
				else if (insn_and)
					output_d = rs1_data & rs2_data;
				else if (((((((insn_mul | insn_mulh) | insn_mulhsu) | insn_mulhu) | insn_div) | insn_divu) | insn_rem) | insn_remu) begin
					if (insn_mul) begin
						large_mul = $signed(rs1_data) * $signed(rs2_data);
						output_d = large_mul[31:0];
					end
					else if (insn_mulh) begin
						large_mul = $signed(rs1_data) * $signed(rs2_data);
						output_d = large_mul[63:32];
					end
					else if (insn_mulhsu) begin
						large_mul = $signed(rs1_data) * $signed({1'b0, rs2_data});
						output_d = large_mul[63:32];
					end
					else if (insn_mulhu) begin
						large_mul = {1'b0, rs1_data} * {1'b0, rs2_data};
						output_d = large_mul[63:32];
					end
					else if (((insn_div || insn_divu) || insn_rem) || insn_remu) begin
						we = 1'b0;
						if (rs2_data[31] && (insn_div || insn_rem))
							div_b_input = ~rs2_data + 1;
						else
							div_b_input = rs2_data;
						if (rs1_data[31] && (insn_div || insn_rem))
							div_a_input = ~rs1_data + 1;
						else
							div_a_input = rs1_data;
					end
					else
						illegal_insn = 1'b1;
				end
				else
					illegal_insn = 1'b1;
			end
			OpBranch: begin
				we = 1'b0;
				branch_taken = 0;
				branch_pc = 1'sb0;
				if (insn_beq && (rs1_data == rs2_data)) begin
					branch_pc = execute_state[169-:32] + e_imm_b_sext;
					branch_taken = 1;
				end
				else if (insn_bne && (rs1_data != rs2_data)) begin
					branch_pc = execute_state[169-:32] + e_imm_b_sext;
					branch_taken = 1;
				end
				else if (insn_blt && ($signed(rs1_data) < $signed(rs2_data))) begin
					branch_pc = execute_state[169-:32] + e_imm_b_sext;
					branch_taken = 1;
				end
				else if (insn_bge && ($signed(rs1_data) >= $signed(rs2_data))) begin
					branch_pc = execute_state[169-:32] + e_imm_b_sext;
					branch_taken = 1;
				end
				else if (insn_bltu && (rs1_data < rs2_data)) begin
					branch_pc = execute_state[169-:32] + e_imm_b_sext;
					branch_taken = 1;
				end
				else if (insn_bgeu && (rs1_data >= rs2_data)) begin
					branch_pc = execute_state[169-:32] + e_imm_b_sext;
					branch_taken = 1;
				end
			end
			OpJalr: begin
				we = 1'b1;
				output_d = execute_state[169-:32] + 4;
				branch_pc = (rs1_data + e_imm_i_sext) & ~32'b00000000000000000000000000000001;
				branch_taken = 1;
			end
			OpJal: begin
				we = 1'b1;
				output_d = execute_state[169-:32] + 4;
				branch_pc = execute_state[169-:32] + e_imm_j_sext;
				branch_taken = 1;
			end
			OpAuipc: begin
				we = 1'b1;
				output_d = execute_state[169-:32] + e_imm_u;
			end
			OpLoad: begin
				we = 1'b1;
				output_d = rs1_data + e_imm_i_sext;
			end
			OpStore: begin
				we = 1'b0;
				output_d = rs1_data + e_imm_s_sext;
			end
			default: illegal_insn = 1'b1;
		endcase
	end
	always @(posedge clk)
		if (rst)
			div_valid <= 7'b0000000;
		else begin
			begin : sv2v_autoblock_3
				reg signed [31:0] i;
				for (i = 0; i < 6; i = i + 1)
					begin
						div_valid[i + 1] <= div_valid[i];
						div_pipe[i + 1] <= div_pipe[i];
					end
			end
			if (e_is_div) begin
				div_valid[0] <= 1'b1;
				div_pipe[0] <= {sv2v_cast_32(execute_state[169-:32]), sv2v_cast_32(execute_state[137-:32]), (rs1_data[31] != rs2_data[31]) && (execute_state[120:118] == 3'b100), rs1_data[31] && (execute_state[120:118] == 3'b110), rs2_data == 32'sd0, rs1_data};
			end
			else
				div_valid[0] <= 1'b0;
		end
	wire [31:0] m_pc_current;
	wire [31:0] m_insn = memory_state[143-:32];
	reg m_we = memory_state[10];
	wire [31:0] m_output;
	wire m_re;
	wire [6:0] m_insn_opcode = m_insn[6:0];
	wire d_insn_lb = (m_insn_opcode == OpLoad) && (m_insn[14:12] == 3'b000);
	wire d_insn_lh = (m_insn_opcode == OpLoad) && (m_insn[14:12] == 3'b001);
	wire d_insn_lw = (m_insn_opcode == OpLoad) && (m_insn[14:12] == 3'b010);
	wire d_insn_lbu = (m_insn_opcode == OpLoad) && (m_insn[14:12] == 3'b100);
	wire d_insn_lhu = (m_insn_opcode == OpLoad) && (m_insn[14:12] == 3'b101);
	wire d_insn_sb = (m_insn_opcode == OpStore) && (m_insn[14:12] == 3'b000);
	wire d_insn_sh = (m_insn_opcode == OpStore) && (m_insn[14:12] == 3'b001);
	wire d_insn_sw = (m_insn_opcode == OpStore) && (m_insn[14:12] == 3'b010);
	wire [1:0] load_byte_offset = memory_state[49:48];
	reg [7:0] selected_byte;
	reg [31:0] m_data;
	assign addr_to_dmem = memory_state[79-:32] & 32'h0000fffc;
	wire wm_bypass_active = ((wb_state[108:102] == OpLoad) && (wb_state[5-:5] == memory_state[4-:5])) && (memory_state[4-:5] != 0);
	wire [31:0] m_store_data = (wm_bypass_active ? w_data : memory_state[47-:32]);
	always @(*) begin
		if (_sv2v_0)
			;
		case (load_byte_offset)
			2'b00: selected_byte = load_data_from_dmem[7:0];
			2'b01: selected_byte = load_data_from_dmem[15:8];
			2'b10: selected_byte = load_data_from_dmem[23:16];
			2'b11: selected_byte = load_data_from_dmem[31:24];
			default: selected_byte = 8'b00000000;
		endcase
		store_data_to_dmem = 1'sb0;
		store_we_to_dmem = 1'sb0;
		m_data = 1'sb0;
		if (d_insn_lb)
			m_data = {{24 {selected_byte[7]}}, selected_byte};
		else if (d_insn_lh) begin
			if (load_byte_offset == 2'b00)
				m_data = {{16 {load_data_from_dmem[15]}}, load_data_from_dmem[15:0]};
			else if (load_byte_offset == 2'b10)
				m_data = {{16 {load_data_from_dmem[31]}}, load_data_from_dmem[31:16]};
		end
		else if (d_insn_lw)
			m_data = load_data_from_dmem;
		else if (d_insn_lbu)
			m_data = {24'b000000000000000000000000, selected_byte};
		else if (d_insn_lhu) begin
			if (load_byte_offset == 2'b00)
				m_data = {16'b0000000000000000, load_data_from_dmem[15:0]};
			else if (load_byte_offset == 2'b10)
				m_data = {16'b0000000000000000, load_data_from_dmem[31:16]};
		end
		else if (d_insn_sb) begin
			if (memory_state[49:48] == 2'b00) begin
				store_we_to_dmem = 4'b0001;
				store_data_to_dmem = {24'b000000000000000000000000, m_store_data[7:0]};
			end
			else if (memory_state[49:48] == 2'b01) begin
				store_we_to_dmem = 4'b0010;
				store_data_to_dmem = {16'b0000000000000000, m_store_data[7:0], 8'b00000000};
			end
			else if (memory_state[49:48] == 2'b10) begin
				store_we_to_dmem = 4'b0100;
				store_data_to_dmem = {8'b00000000, m_store_data[7:0], 16'b0000000000000000};
			end
			else if (memory_state[49:48] == 2'b11) begin
				store_we_to_dmem = 4'b1000;
				store_data_to_dmem = {m_store_data[7:0], 24'b000000000000000000000000};
			end
		end
		else if (d_insn_sh) begin
			if (load_byte_offset == 2'b00) begin
				store_we_to_dmem = 4'b0011;
				store_data_to_dmem = {16'b0000000000000000, m_store_data[15:0]};
			end
			else if (load_byte_offset == 2'b10) begin
				store_we_to_dmem = 4'b1100;
				store_data_to_dmem = {m_store_data[15:0], 16'b0000000000000000};
			end
		end
		else if (d_insn_sw) begin
			store_we_to_dmem = 4'b1111;
			store_data_to_dmem = m_store_data;
		end
	end
	reg [31:0] final_div_result;
	always @(*) begin
		if (_sv2v_0)
			;
		final_div_result = 0;
		if (div_pipe[6][49:47] == 3'b100)
			final_div_result = (div_pipe[6][32] ? 32'hffffffff : (div_pipe[6][34] ? ~div_q + 1 : div_q));
		else if (div_pipe[6][49:47] == 3'b101)
			final_div_result = (div_pipe[6][32] ? 32'hffffffff : div_q);
		else if (div_pipe[6][49:47] == 3'b110)
			final_div_result = (div_pipe[6][32] ? div_pipe[6][31-:32] : (div_pipe[6][33] ? ~div_rem + 1 : div_rem));
		else if (div_pipe[6][49:47] == 3'b111)
			final_div_result = (div_pipe[6][32] ? div_pipe[6][31-:32] : div_rem);
	end
	function automatic [4:0] sv2v_cast_5;
		input reg [4:0] inp;
		sv2v_cast_5 = inp;
	endfunction
	always @(posedge clk)
		if (rst)
			memory_state <= 176'h00000000000000000000000400000000000000000000;
		else if (div_valid[6])
			memory_state <= {sv2v_cast_32(div_pipe[6][98-:32]), sv2v_cast_32(div_pipe[6][66-:32]), 32'd1, final_div_result, 32'd0, div_pipe[6][46:42], 11'h400};
		else if (e_non_div_stall || e_is_div)
			memory_state <= 176'h00000000000000000000000200000000000000000000;
		else
			memory_state <= {sv2v_cast_32(execute_state[169-:32]), sv2v_cast_32(execute_state[137-:32]), sv2v_cast_32(execute_state[105-:32]), output_d, rs2_data, e_rd, we, sv2v_cast_5(execute_state[9-:5]), sv2v_cast_5(execute_state[4-:5])};
	wire [255:0] m_disasm;
	Disasm #(.PREFIX("M")) disasm_3memory(
		.insn(memory_state[143-:32]),
		.disasm(m_disasm)
	);
	wire [31:0] w_pc_current;
	wire [31:0] w_insn;
	wire [6:0] wb_insn_opcode = wb_state[108:102];
	wire wb_insn_ecall = (wb_insn_opcode == OpEnviron) && (wb_state[133:109] == 25'd0);
	always @(posedge clk)
		if (rst)
			wb_state <= 166'h000000000000000000000001000000000000000000;
		else
			wb_state <= {sv2v_cast_32(memory_state[175-:32]), sv2v_cast_32(memory_state[143-:32]), sv2v_cast_32(memory_state[111-:32]), m_data, sv2v_cast_32(memory_state[79-:32]), sv2v_cast_5(memory_state[15-:5]), memory_state[10]};
	wire [255:0] wb_disasm;
	Disasm #(.PREFIX("W")) disasm_4wb(
		.insn(wb_state[133-:32]),
		.disasm(wb_disasm)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		w_rd = wb_state[5-:5];
		if (wb_insn_ecall && (wb_state[101-:32] == 32'd1))
			halt = 1'b1;
		else
			halt = 1'b0;
	end
	assign trace_completed_cycle_status = wb_state[101-:32];
	assign trace_completed_pc = (wb_state[101-:32] == 32'd1 ? wb_state[165-:32] : 0);
	assign trace_completed_insn = (wb_state[101-:32] == 32'd1 ? wb_state[133-:32] : 0);
	initial _sv2v_0 = 0;
endmodule
module MemorySingleCycle (
	rst,
	clk,
	pc_to_imem,
	insn_from_imem,
	addr_to_dmem,
	load_data_from_dmem,
	store_data_to_dmem,
	store_we_to_dmem
);
	reg _sv2v_0;
	parameter signed [31:0] NUM_WORDS = 512;
	input wire rst;
	input wire clk;
	input wire [31:0] pc_to_imem;
	output reg [31:0] insn_from_imem;
	input wire [31:0] addr_to_dmem;
	output reg [31:0] load_data_from_dmem;
	input wire [31:0] store_data_to_dmem;
	input wire [3:0] store_we_to_dmem;
	reg [31:0] mem_array [0:NUM_WORDS - 1];
	initial $readmemh("mem_initial_contents.hex", mem_array);
	always @(*)
		if (_sv2v_0)
			;
	localparam signed [31:0] AddrMsb = $clog2(NUM_WORDS) + 1;
	localparam signed [31:0] AddrLsb = 2;
	always @(negedge clk)
		if (rst)
			;
		else
			insn_from_imem <= mem_array[{pc_to_imem[AddrMsb:AddrLsb]}];
	always @(negedge clk)
		if (rst)
			;
		else begin
			if (store_we_to_dmem[0])
				mem_array[addr_to_dmem[AddrMsb:AddrLsb]][7:0] <= store_data_to_dmem[7:0];
			if (store_we_to_dmem[1])
				mem_array[addr_to_dmem[AddrMsb:AddrLsb]][15:8] <= store_data_to_dmem[15:8];
			if (store_we_to_dmem[2])
				mem_array[addr_to_dmem[AddrMsb:AddrLsb]][23:16] <= store_data_to_dmem[23:16];
			if (store_we_to_dmem[3])
				mem_array[addr_to_dmem[AddrMsb:AddrLsb]][31:24] <= store_data_to_dmem[31:24];
			load_data_from_dmem <= mem_array[{addr_to_dmem[AddrMsb:AddrLsb]}];
		end
	initial _sv2v_0 = 0;
endmodule
`default_nettype none
module txuartlite (
	i_clk,
	i_reset,
	i_wr,
	i_data,
	o_uart_tx,
	o_busy
);
	parameter [4:0] TIMING_BITS = 5'd24;
	localparam TB = TIMING_BITS;
	parameter [TB - 1:0] CLOCKS_PER_BAUD = 217;
	input wire i_clk;
	input wire i_reset;
	input wire i_wr;
	input wire [7:0] i_data;
	output reg o_uart_tx;
	output wire o_busy;
	localparam [3:0] TXUL_BIT_ZERO = 4'h0;
	localparam [3:0] TXUL_STOP = 4'h8;
	localparam [3:0] TXUL_IDLE = 4'hf;
	reg [TB - 1:0] baud_counter;
	reg [3:0] state;
	reg [7:0] lcl_data;
	reg r_busy;
	reg zero_baud_counter;
	initial r_busy = 1'b1;
	initial state = TXUL_IDLE;
	always @(posedge i_clk)
		if (i_reset) begin
			r_busy <= 1'b1;
			state <= TXUL_IDLE;
		end
		else if (!zero_baud_counter)
			r_busy <= 1'b1;
		else if (state > TXUL_STOP) begin
			state <= TXUL_IDLE;
			r_busy <= 1'b0;
			if (i_wr && !r_busy) begin
				r_busy <= 1'b1;
				state <= TXUL_BIT_ZERO;
			end
		end
		else begin
			r_busy <= 1'b1;
			if (state <= TXUL_STOP)
				state <= state + 1'b1;
			else
				state <= TXUL_IDLE;
		end
	assign o_busy = r_busy;
	initial lcl_data = 8'hff;
	always @(posedge i_clk)
		if (i_reset)
			lcl_data <= 8'hff;
		else if (i_wr && !r_busy)
			lcl_data <= i_data;
		else if (zero_baud_counter)
			lcl_data <= {1'b1, lcl_data[7:1]};
	initial o_uart_tx = 1'b1;
	always @(posedge i_clk)
		if (i_reset)
			o_uart_tx <= 1'b1;
		else if (i_wr && !r_busy)
			o_uart_tx <= 1'b0;
		else if (zero_baud_counter)
			o_uart_tx <= lcl_data[0];
	initial zero_baud_counter = 1'b1;
	initial baud_counter = 0;
	always @(posedge i_clk)
		if (i_reset) begin
			zero_baud_counter <= 1'b1;
			baud_counter <= 0;
		end
		else begin
			zero_baud_counter <= baud_counter == 1;
			if (state == TXUL_IDLE) begin
				baud_counter <= 0;
				zero_baud_counter <= 1'b1;
				if (i_wr && !r_busy) begin
					baud_counter <= CLOCKS_PER_BAUD - 1'b1;
					zero_baud_counter <= 1'b0;
				end
			end
			else if (!zero_baud_counter)
				baud_counter <= baud_counter - 1'b1;
			else if (state > TXUL_STOP) begin
				baud_counter <= 0;
				zero_baud_counter <= 1'b1;
			end
			else if (state == TXUL_STOP)
				baud_counter <= CLOCKS_PER_BAUD - 2;
			else
				baud_counter <= CLOCKS_PER_BAUD - 1'b1;
		end
endmodule
`default_nettype none
module rxuartlite (
	i_clk,
	i_reset,
	i_uart_rx,
	o_wr,
	o_data
);
	parameter TIMER_BITS = 10;
	parameter [TIMER_BITS - 1:0] CLOCKS_PER_BAUD = 217;
	localparam TB = TIMER_BITS;
	localparam [3:0] RXUL_BIT_ZERO = 4'h0;
	localparam [3:0] RXUL_BIT_ONE = 4'h1;
	localparam [3:0] RXUL_BIT_TWO = 4'h2;
	localparam [3:0] RXUL_BIT_THREE = 4'h3;
	localparam [3:0] RXUL_BIT_FOUR = 4'h4;
	localparam [3:0] RXUL_BIT_FIVE = 4'h5;
	localparam [3:0] RXUL_BIT_SIX = 4'h6;
	localparam [3:0] RXUL_BIT_SEVEN = 4'h7;
	localparam [3:0] RXUL_STOP = 4'h8;
	localparam [3:0] RXUL_WAIT = 4'h9;
	localparam [3:0] RXUL_IDLE = 4'hf;
	input wire i_clk;
	input wire i_reset;
	input wire i_uart_rx;
	output reg o_wr;
	output reg [7:0] o_data;
	wire [TB - 1:0] half_baud;
	reg [3:0] state;
	assign half_baud = {1'b0, CLOCKS_PER_BAUD[TB - 1:1]};
	reg [TB - 1:0] baud_counter;
	reg zero_baud_counter;
	reg q_uart;
	reg qq_uart;
	reg ck_uart;
	reg [TB - 1:0] chg_counter;
	reg half_baud_time;
	reg [7:0] data_reg;
	initial q_uart = 1'b1;
	initial qq_uart = 1'b1;
	initial ck_uart = 1'b1;
	always @(posedge i_clk)
		if (i_reset)
			{ck_uart, qq_uart, q_uart} <= 3'b111;
		else
			{ck_uart, qq_uart, q_uart} <= {qq_uart, q_uart, i_uart_rx};
	initial chg_counter = {TB {1'b1}};
	always @(posedge i_clk)
		if (i_reset)
			chg_counter <= {TB {1'b1}};
		else if (qq_uart != ck_uart)
			chg_counter <= 0;
		else if (chg_counter != {TB {1'b1}})
			chg_counter <= chg_counter + 1;
	initial half_baud_time = 0;
	always @(posedge i_clk)
		if (i_reset)
			half_baud_time <= 0;
		else
			half_baud_time <= !ck_uart && (chg_counter >= (half_baud - (1'b1 + 1'b1)));
	initial state = RXUL_IDLE;
	always @(posedge i_clk)
		if (i_reset)
			state <= RXUL_IDLE;
		else if (state == RXUL_IDLE) begin
			state <= RXUL_IDLE;
			if (!ck_uart && half_baud_time)
				state <= RXUL_BIT_ZERO;
		end
		else if ((state >= RXUL_WAIT) && ck_uart)
			state <= RXUL_IDLE;
		else if (zero_baud_counter) begin
			if (state <= RXUL_STOP)
				state <= state + 1;
		end
	always @(posedge i_clk)
		if (zero_baud_counter && (state != RXUL_STOP))
			data_reg <= {qq_uart, data_reg[7:1]};
	initial o_wr = 1'b0;
	initial o_data = 8'h00;
	always @(posedge i_clk)
		if (i_reset) begin
			o_wr <= 1'b0;
			o_data <= 8'h00;
		end
		else if ((zero_baud_counter && (state == RXUL_STOP)) && ck_uart) begin
			o_wr <= 1'b1;
			o_data <= data_reg;
		end
		else
			o_wr <= 1'b0;
	initial baud_counter = 0;
	always @(posedge i_clk)
		if (i_reset)
			baud_counter <= 0;
		else if (((state == RXUL_IDLE) && !ck_uart) && half_baud_time)
			baud_counter <= CLOCKS_PER_BAUD - 1'b1;
		else if (state == RXUL_WAIT)
			baud_counter <= 0;
		else if (zero_baud_counter && (state < RXUL_STOP))
			baud_counter <= CLOCKS_PER_BAUD - 1'b1;
		else if (!zero_baud_counter)
			baud_counter <= baud_counter - 1'b1;
	initial zero_baud_counter = 1'b1;
	always @(posedge i_clk)
		if (i_reset)
			zero_baud_counter <= 1'b1;
		else if (((state == RXUL_IDLE) && !ck_uart) && half_baud_time)
			zero_baud_counter <= 1'b0;
		else if (state == RXUL_WAIT)
			zero_baud_counter <= 1'b1;
		else if (zero_baud_counter && (state < RXUL_STOP))
			zero_baud_counter <= 1'b0;
		else if (baud_counter == 1)
			zero_baud_counter <= 1'b1;
endmodule
module SystemDemo (
	external_clk_25MHz,
	ftdi_txd,
	btn,
	led,
	ftdi_rxd,
	wifi_gpio0
);
	input external_clk_25MHz;
	input ftdi_txd;
	input [6:0] btn;
	output wire [7:0] led;
	output wire ftdi_rxd;
	output wire wifi_gpio0;
	localparam signed [31:0] MmapOutput = 32'hff001000;
	localparam signed [31:0] MmapInput = 32'hff002000;
	wire clk_proc;
	wire clk_locked;
	MyClockGen clock_gen(
		.input_clk_25MHz(external_clk_25MHz),
		.clk_proc(clk_proc),
		.locked(clk_locked)
	);
	wire [7:0] rx_data;
	wire rx_ready;
	wire [7:0] data2cpu_uart;
	wire [7:0] data2cpu_cpu;
	assign data2cpu_uart = (rx_ready ? rx_data : 8'h00);
	assign led = data2cpu_cpu;
	wire [7:0] tx_data;
	wire tx_ready;
	wire tx_busy;
	wire [7:0] data2uart_cpu;
	wire [7:0] data2uart_uart;
	assign tx_ready = !tx_busy;
	assign tx_data = data2uart_uart;
	rxuartlite uart_receive(
		.i_clk(external_clk_25MHz),
		.i_reset(1'b0),
		.i_uart_rx(ftdi_txd),
		.o_wr(rx_ready),
		.o_data(rx_data)
	);
	wire [31:0] mem_data_addr;
	wire [31:0] mem_data_to_write;
	wire [3:0] mem_data_we;
	DP16KD #(
		.DATA_WIDTH_A(9),
		.DATA_WIDTH_B(9),
		.REGMODE_A("NOREG"),
		.REGMODE_B("NOREG"),
		.RESETMODE("SYNC"),
		.ASYNC_RESET_RELEASE("SYNC"),
		.WRITEMODE_A("NORMAL"),
		.WRITEMODE_B("NORMAL")
	) uart2cpu(
		.ADA13(1'b0),
		.ADA12(1'b0),
		.ADA11(1'b0),
		.ADA10(1'b0),
		.ADA9(1'b0),
		.ADA8(1'b0),
		.ADA7(1'b0),
		.ADA6(1'b0),
		.ADA5(1'b0),
		.ADA4(1'b0),
		.ADA3(1'b0),
		.ADA2(1'b0),
		.ADA1(1'b0),
		.ADA0(1'b0),
		.DIA8(1'b0),
		.DIA7(data2cpu_uart[7]),
		.DIA6(data2cpu_uart[6]),
		.DIA5(data2cpu_uart[5]),
		.DIA4(data2cpu_uart[4]),
		.DIA3(data2cpu_uart[3]),
		.DIA2(data2cpu_uart[2]),
		.DIA1(data2cpu_uart[1]),
		.DIA0(data2cpu_uart[0]),
		.CEA(1'b1),
		.OCEA(1'b1),
		.CLKA(external_clk_25MHz),
		.WEA(rx_ready),
		.RSTA(1'b0),
		.ADB13(1'b0),
		.ADB12(1'b0),
		.ADB11(1'b0),
		.ADB10(1'b0),
		.ADB9(1'b0),
		.ADB8(1'b0),
		.ADB7(1'b0),
		.ADB6(1'b0),
		.ADB5(1'b0),
		.ADB4(1'b0),
		.ADB3(1'b0),
		.ADB2(1'b0),
		.ADB1(1'b0),
		.ADB0(1'b0),
		.DIB8(1'b0),
		.DIB7(mem_data_to_write[7]),
		.DIB6(mem_data_to_write[6]),
		.DIB5(mem_data_to_write[5]),
		.DIB4(mem_data_to_write[4]),
		.DIB3(mem_data_to_write[3]),
		.DIB2(mem_data_to_write[2]),
		.DIB1(mem_data_to_write[1]),
		.DIB0(mem_data_to_write[0]),
		.DOB8(),
		.DOB7(data2cpu_cpu[7]),
		.DOB6(data2cpu_cpu[6]),
		.DOB5(data2cpu_cpu[5]),
		.DOB4(data2cpu_cpu[4]),
		.DOB3(data2cpu_cpu[3]),
		.DOB2(data2cpu_cpu[2]),
		.DOB1(data2cpu_cpu[1]),
		.DOB0(data2cpu_cpu[0]),
		.CEB(1'b1),
		.OCEB(1'b1),
		.CLKB(clk_proc),
		.WEB((mem_data_addr == MmapInput) && |mem_data_we),
		.RSTB(1'b0)
	);
	txuartlite uart_transmit(
		.i_clk(external_clk_25MHz),
		.i_reset(1'b0),
		.i_wr(tx_ready),
		.i_data(tx_data),
		.o_uart_tx(ftdi_rxd),
		.o_busy(tx_busy)
	);
	DP16KD #(
		.DATA_WIDTH_A(9),
		.DATA_WIDTH_B(9),
		.REGMODE_A("NOREG"),
		.REGMODE_B("NOREG"),
		.RESETMODE("SYNC"),
		.ASYNC_RESET_RELEASE("SYNC"),
		.WRITEMODE_A("NORMAL"),
		.WRITEMODE_B("NORMAL")
	) cpu2uart(
		.ADA13(1'b0),
		.ADA12(1'b0),
		.ADA11(1'b0),
		.ADA10(1'b0),
		.ADA9(1'b0),
		.ADA8(1'b0),
		.ADA7(1'b0),
		.ADA6(1'b0),
		.ADA5(1'b0),
		.ADA4(1'b0),
		.ADA3(1'b0),
		.ADA2(1'b0),
		.ADA1(1'b0),
		.ADA0(1'b0),
		.DIA8(1'b0),
		.DIA7(data2uart_cpu[7]),
		.DIA6(data2uart_cpu[6]),
		.DIA5(data2uart_cpu[5]),
		.DIA4(data2uart_cpu[4]),
		.DIA3(data2uart_cpu[3]),
		.DIA2(data2uart_cpu[2]),
		.DIA1(data2uart_cpu[1]),
		.DIA0(data2uart_cpu[0]),
		.CEA(1'b1),
		.OCEA(1'b1),
		.CLKA(clk_proc),
		.WEA((mem_data_addr == MmapOutput) && |mem_data_we),
		.RSTA(1'b0),
		.ADB13(1'b0),
		.ADB12(1'b0),
		.ADB11(1'b0),
		.ADB10(1'b0),
		.ADB9(1'b0),
		.ADB8(1'b0),
		.ADB7(1'b0),
		.ADB6(1'b0),
		.ADB5(1'b0),
		.ADB4(1'b0),
		.ADB3(1'b0),
		.ADB2(1'b0),
		.ADB1(1'b0),
		.ADB0(1'b0),
		.DOB8(),
		.DOB7(data2uart_uart[7]),
		.DOB6(data2uart_uart[6]),
		.DOB5(data2uart_uart[5]),
		.DOB4(data2uart_uart[4]),
		.DOB3(data2uart_uart[3]),
		.DOB2(data2uart_uart[2]),
		.DOB1(data2uart_uart[1]),
		.DOB0(data2uart_uart[0]),
		.CEB(1'b1),
		.OCEB(1'b1),
		.CLKB(external_clk_25MHz),
		.WEB(1'b0),
		.RSTB(1'b0)
	);
	wire [31:0] pc_to_imem;
	wire [31:0] insn_from_imem;
	wire [31:0] mem_data_loaded_value;
	wire [31:0] trace_completed_pc;
	wire [31:0] trace_completed_insn;
	wire [31:0] trace_completed_cycle_status;
	assign data2uart_cpu = mem_data_to_write[7:0];
	MemorySingleCycle #(.NUM_WORDS(1024)) memory(
		.rst(!clk_locked),
		.clk(clk_proc),
		.pc_to_imem(pc_to_imem),
		.insn_from_imem(insn_from_imem),
		.addr_to_dmem(mem_data_addr),
		.load_data_from_dmem(mem_data_loaded_value),
		.store_data_to_dmem(mem_data_to_write),
		.store_we_to_dmem((mem_data_addr == MmapOutput ? 4'd0 : mem_data_we))
	);
	DatapathPipelined datapath(
		.clk(clk_proc),
		.rst(!clk_locked),
		.pc_to_imem(pc_to_imem),
		.insn_from_imem(insn_from_imem),
		.addr_to_dmem(mem_data_addr),
		.store_data_to_dmem(mem_data_to_write),
		.store_we_to_dmem(mem_data_we),
		.load_data_from_dmem((mem_data_addr == MmapInput ? {24'd0, data2cpu_cpu} : mem_data_loaded_value)),
		.halt(),
		.trace_completed_pc(trace_completed_pc),
		.trace_completed_insn(trace_completed_insn),
		.trace_completed_cycle_status(trace_completed_cycle_status)
	);
endmodule