module MyClockGen (
	input_clk_25MHz,
	clk_proc,
	clk_mem,
	locked
);
	input input_clk_25MHz;
	output wire clk_proc;
	output wire clk_mem;
	output wire locked;
	wire clkfb;
	(* FREQUENCY_PIN_CLKI = "25" *) (* FREQUENCY_PIN_CLKOP = "10" *) (* FREQUENCY_PIN_CLKOS = "10" *) (* ICP_CURRENT = "12" *) (* LPF_RESISTOR = "8" *) (* MFG_ENABLE_FILTEROPAMP = "1" *) (* MFG_GMCREF_SEL = "2" *) EHXPLLL #(
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
		.CLKOP_DIV(60),
		.CLKOP_CPHASE(30),
		.CLKOP_FPHASE(0),
		.CLKOS_ENABLE("ENABLED"),
		.CLKOS_DIV(60),
		.CLKOS_CPHASE(45),
		.CLKOS_FPHASE(0),
		.FEEDBK_PATH("INT_OP"),
		.CLKFB_DIV(2)
	) pll_i(
		.RST(1'b0),
		.STDBY(1'b0),
		.CLKI(input_clk_25MHz),
		.CLKOP(clk_proc),
		.CLKOS(clk_mem),
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
	wire [32:1] sv2v_tmp_B7B25;
	assign sv2v_tmp_B7B25 = 1'sb0;
	always @(*) regs[0] = sv2v_tmp_B7B25;
	always @(*) begin
		if (_sv2v_0)
			;
		rs1_data = regs[rs1];
		rs2_data = regs[rs2];
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
module DatapathMultiCycle (
	clk,
	rst,
	halt,
	pc_to_imem,
	insn_from_imem,
	addr_to_dmem,
	load_data_from_dmem,
	store_data_to_dmem,
	store_we_to_dmem,
	trace_completed_pc,
	trace_completed_insn,
	trace_completed_cycle_status
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	output reg halt;
	output wire [31:0] pc_to_imem;
	input wire [31:0] insn_from_imem;
	output reg [31:0] addr_to_dmem;
	input wire [31:0] load_data_from_dmem;
	output reg [31:0] store_data_to_dmem;
	output reg [3:0] store_we_to_dmem;
	output reg [31:0] trace_completed_pc;
	output reg [31:0] trace_completed_insn;
	output reg [31:0] trace_completed_cycle_status;
	reg [3:0] div_insns;
	wire [6:0] insn_funct7;
	wire [4:0] insn_rs2;
	wire [4:0] insn_rs1;
	wire [2:0] insn_funct3;
	wire [4:0] insn_rd;
	wire [6:0] insn_opcode;
	assign {insn_funct7, insn_rs2, insn_rs1, insn_funct3, insn_rd, insn_opcode} = insn_from_imem;
	wire [11:0] imm_i;
	assign imm_i = insn_from_imem[31:20];
	wire [4:0] imm_shamt = insn_from_imem[24:20];
	wire [11:0] imm_s;
	assign imm_s[11:5] = insn_funct7;
	assign imm_s[4:0] = insn_rd;
	wire [12:0] imm_b;
	assign {imm_b[12], imm_b[10:5]} = insn_funct7;
	assign {imm_b[4:1], imm_b[11]} = insn_rd;
	assign imm_b[0] = 1'b0;
	wire [20:0] imm_j;
	assign {imm_j[20], imm_j[10:1], imm_j[11], imm_j[19:12], imm_j[0]} = {insn_from_imem[31:12], 1'b0};
	wire [31:0] imm_i_sext = {{20 {imm_i[11]}}, imm_i[11:0]};
	wire [31:0] imm_s_sext = {{20 {imm_s[11]}}, imm_s[11:0]};
	wire [31:0] imm_b_sext = {{19 {imm_b[12]}}, imm_b[12:0]};
	wire [31:0] imm_j_sext = {{11 {imm_j[20]}}, imm_j[20:0]};
	localparam [6:0] OpLoad = 7'b0000011;
	localparam [6:0] OpStore = 7'b0100011;
	localparam [6:0] OpBranch = 7'b1100011;
	localparam [6:0] OpJalr = 7'b1100111;
	localparam [6:0] OpMiscMem = 7'b0001111;
	localparam [6:0] OpJal = 7'b1101111;
	localparam [6:0] OpRegImm = 7'b0010011;
	localparam [6:0] OpRegReg = 7'b0110011;
	localparam [6:0] OpEnviron = 7'b1110011;
	localparam [6:0] OpAuipc = 7'b0010111;
	localparam [6:0] OpLui = 7'b0110111;
	wire insn_lui = insn_opcode == OpLui;
	wire insn_auipc = insn_opcode == OpAuipc;
	wire insn_jal = insn_opcode == OpJal;
	wire insn_jalr = insn_opcode == OpJalr;
	wire insn_beq = (insn_opcode == OpBranch) && (insn_from_imem[14:12] == 3'b000);
	wire insn_bne = (insn_opcode == OpBranch) && (insn_from_imem[14:12] == 3'b001);
	wire insn_blt = (insn_opcode == OpBranch) && (insn_from_imem[14:12] == 3'b100);
	wire insn_bge = (insn_opcode == OpBranch) && (insn_from_imem[14:12] == 3'b101);
	wire insn_bltu = (insn_opcode == OpBranch) && (insn_from_imem[14:12] == 3'b110);
	wire insn_bgeu = (insn_opcode == OpBranch) && (insn_from_imem[14:12] == 3'b111);
	wire insn_lb = (insn_opcode == OpLoad) && (insn_from_imem[14:12] == 3'b000);
	wire insn_lh = (insn_opcode == OpLoad) && (insn_from_imem[14:12] == 3'b001);
	wire insn_lw = (insn_opcode == OpLoad) && (insn_from_imem[14:12] == 3'b010);
	wire insn_lbu = (insn_opcode == OpLoad) && (insn_from_imem[14:12] == 3'b100);
	wire insn_lhu = (insn_opcode == OpLoad) && (insn_from_imem[14:12] == 3'b101);
	wire insn_sb = (insn_opcode == OpStore) && (insn_from_imem[14:12] == 3'b000);
	wire insn_sh = (insn_opcode == OpStore) && (insn_from_imem[14:12] == 3'b001);
	wire insn_sw = (insn_opcode == OpStore) && (insn_from_imem[14:12] == 3'b010);
	wire insn_addi = (insn_opcode == OpRegImm) && (insn_from_imem[14:12] == 3'b000);
	wire insn_slti = (insn_opcode == OpRegImm) && (insn_from_imem[14:12] == 3'b010);
	wire insn_sltiu = (insn_opcode == OpRegImm) && (insn_from_imem[14:12] == 3'b011);
	wire insn_xori = (insn_opcode == OpRegImm) && (insn_from_imem[14:12] == 3'b100);
	wire insn_ori = (insn_opcode == OpRegImm) && (insn_from_imem[14:12] == 3'b110);
	wire insn_andi = (insn_opcode == OpRegImm) && (insn_from_imem[14:12] == 3'b111);
	wire insn_slli = ((insn_opcode == OpRegImm) && (insn_from_imem[14:12] == 3'b001)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_srli = ((insn_opcode == OpRegImm) && (insn_from_imem[14:12] == 3'b101)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_srai = ((insn_opcode == OpRegImm) && (insn_from_imem[14:12] == 3'b101)) && (insn_from_imem[31:25] == 7'b0100000);
	wire insn_add = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b000)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_sub = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b000)) && (insn_from_imem[31:25] == 7'b0100000);
	wire insn_sll = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b001)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_slt = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b010)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_sltu = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b011)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_xor = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b100)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_srl = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b101)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_sra = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b101)) && (insn_from_imem[31:25] == 7'b0100000);
	wire insn_or = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b110)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_and = ((insn_opcode == OpRegReg) && (insn_from_imem[14:12] == 3'b111)) && (insn_from_imem[31:25] == 7'd0);
	wire insn_mul = ((insn_opcode == OpRegReg) && (insn_from_imem[31:25] == 7'd1)) && (insn_from_imem[14:12] == 3'b000);
	wire insn_mulh = ((insn_opcode == OpRegReg) && (insn_from_imem[31:25] == 7'd1)) && (insn_from_imem[14:12] == 3'b001);
	wire insn_mulhsu = ((insn_opcode == OpRegReg) && (insn_from_imem[31:25] == 7'd1)) && (insn_from_imem[14:12] == 3'b010);
	wire insn_mulhu = ((insn_opcode == OpRegReg) && (insn_from_imem[31:25] == 7'd1)) && (insn_from_imem[14:12] == 3'b011);
	wire insn_div = ((insn_opcode == OpRegReg) && (insn_from_imem[31:25] == 7'd1)) && (insn_from_imem[14:12] == 3'b100);
	wire insn_divu = ((insn_opcode == OpRegReg) && (insn_from_imem[31:25] == 7'd1)) && (insn_from_imem[14:12] == 3'b101);
	wire insn_rem = ((insn_opcode == OpRegReg) && (insn_from_imem[31:25] == 7'd1)) && (insn_from_imem[14:12] == 3'b110);
	wire insn_remu = ((insn_opcode == OpRegReg) && (insn_from_imem[31:25] == 7'd1)) && (insn_from_imem[14:12] == 3'b111);
	wire div_insn = ((insn_div | insn_divu) | insn_rem) | insn_remu;
	wire insn_ecall = (insn_opcode == OpEnviron) && (insn_from_imem[31:7] == 25'd0);
	wire insn_fence = insn_opcode == OpMiscMem;
	wire is_stall = div_insn && (div_insns != 4'd8);
	reg [31:0] pcNext;
	reg [31:0] pcCurrent;
	always @(posedge clk)
		if (rst)
			pcCurrent <= 32'd0;
		else
			pcCurrent <= (is_stall ? pcCurrent : pcNext);
	assign pc_to_imem = pcCurrent;
	reg [31:0] cycles_current;
	reg [31:0] num_insns_current;
	always @(posedge clk)
		if (rst) begin
			cycles_current <= 0;
			num_insns_current <= 0;
		end
		else begin
			cycles_current <= cycles_current + 1;
			if (!rst && !is_stall)
				num_insns_current <= num_insns_current + 1;
		end
	wire [31:0] rs1_data;
	wire [31:0] rs2_data;
	reg [31:0] output_d;
	reg we;
	RegFile rf(
		.clk(clk),
		.rst(rst),
		.we(we),
		.rd(insn_rd),
		.rd_data(output_d),
		.rs1(insn_rs1),
		.rs2(insn_rs2),
		.rs1_data(rs1_data),
		.rs2_data(rs2_data)
	);
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
	wire [4:0] dest;
	reg [7:0] selected_byte;
	reg [1:0] load_byte_offset;
	reg [31:0] load_addr;
	reg [63:0] large_mul;
	always @(*) begin
		if (_sv2v_0)
			;
		illegal_insn = 1'b0;
		we = 1'b0;
		output_d = 1'sb0;
		halt = 1'b0;
		pcNext = pcCurrent + 4;
		cla_b = 1'sb0;
		cla_cin = 1'sb0;
		selected_byte = 8'b00000000;
		addr_to_dmem = 1'sb0;
		load_addr = 1'sb0;
		load_byte_offset = 1'sb0;
		store_we_to_dmem = 4'b0000;
		store_data_to_dmem = 1'sb0;
		large_mul = 1'sb0;
		div_b_input = 1'sb0;
		div_a_input = 1'sb0;
		trace_completed_pc = pcCurrent;
		trace_completed_insn = insn_from_imem;
		trace_completed_cycle_status = (is_stall ? 32'd2 : 32'd1);
		case (insn_opcode)
			OpLui: begin
				output_d = {insn_from_imem[31:12], 12'b000000000000};
				we = 1;
			end
			OpRegImm: begin
				we = 1;
				if (insn_addi) begin
					cla_b = imm_i_sext;
					cla_cin = 0;
					output_d = cla_sum;
				end
				else if (insn_slti)
					output_d = {31'b0000000000000000000000000000000, $signed(rs1_data) < $signed(imm_i_sext)};
				else if (insn_sltiu)
					output_d = {31'b0000000000000000000000000000000, rs1_data < imm_i_sext};
				else if (insn_xori)
					output_d = rs1_data ^ imm_i_sext;
				else if (insn_ori)
					output_d = rs1_data | imm_i_sext;
				else if (insn_andi)
					output_d = rs1_data & imm_i_sext;
				else if (insn_slli)
					output_d = rs1_data << imm_shamt;
				else if (insn_srli)
					output_d = rs1_data >> imm_shamt;
				else if (insn_srai)
					output_d = $signed(rs1_data) >>> imm_shamt;
				else
					illegal_insn = 1'b1;
			end
			OpRegReg: begin
				we = (div_insn ? 0 : 1);
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
					else if (insn_div) begin
						we = div_insns == 4'd8;
						if (rs2_data[31])
							div_b_input = ~rs2_data + 1;
						else
							div_b_input = rs2_data;
						if (rs1_data[31])
							div_a_input = ~rs1_data + 1;
						else
							div_a_input = rs1_data;
						if (|rs2_data)
							output_d = (rs1_data[31] == rs2_data[31] ? div_q : ~div_q + 1);
						else
							output_d = 32'hffffffff;
					end
					else if (insn_divu) begin
						we = div_insns == 4'd8;
						div_b_input = rs2_data;
						div_a_input = rs1_data;
						if (|rs2_data)
							output_d = div_q;
						else
							output_d = 32'hffffffff;
					end
					else if (insn_rem) begin
						we = div_insns == 4'd8;
						if (rs2_data[31])
							div_b_input = ~rs2_data + 1;
						else
							div_b_input = rs2_data;
						if (rs1_data[31])
							div_a_input = ~rs1_data + 1;
						else
							div_a_input = rs1_data;
						output_d = (rs1_data[31] ? ~div_rem + 1 : div_rem);
						if (rs2_data == 32'b00000000000000000000000000000000)
							output_d = rs1_data;
					end
					else if (insn_remu) begin
						we = div_insns == 4'd8;
						div_b_input = rs2_data;
						div_a_input = rs1_data;
						output_d = div_rem;
						if (rs2_data == 32'b00000000000000000000000000000000)
							output_d = rs1_data;
					end
					else
						illegal_insn = 1'b1;
				end
				else
					illegal_insn = 1'b1;
			end
			OpLoad: begin
				we = 1'sb1;
				load_addr = rs1_data + imm_i_sext;
				load_byte_offset = load_addr[1:0];
				addr_to_dmem = {load_addr[31:2], 2'b00};
				case (load_byte_offset)
					2'b00: selected_byte = load_data_from_dmem[7:0];
					2'b01: selected_byte = load_data_from_dmem[15:8];
					2'b10: selected_byte = load_data_from_dmem[23:16];
					2'b11: selected_byte = load_data_from_dmem[31:24];
					default: selected_byte = 8'b00000000;
				endcase
				if (insn_lb)
					output_d = {{24 {selected_byte[7]}}, selected_byte};
				else if (insn_lh) begin
					if (load_addr[1:0] == 2'b00)
						output_d = {{16 {load_data_from_dmem[15]}}, load_data_from_dmem[15:0]};
					else if (load_addr[1:0] == 2'b10)
						output_d = {{16 {load_data_from_dmem[31]}}, load_data_from_dmem[31:16]};
				end
				else if (insn_lw)
					output_d = load_data_from_dmem;
				else if (insn_lbu)
					output_d = {24'b000000000000000000000000, selected_byte};
				else if (insn_lhu) begin
					if (load_addr[1:0] == 2'b00)
						output_d = {16'b0000000000000000, load_data_from_dmem[15:0]};
					else if (load_addr[1:0] == 2'b10)
						output_d = {16'b0000000000000000, load_data_from_dmem[31:16]};
				end
			end
			OpStore: begin
				we = 1'b0;
				load_addr = rs1_data + imm_s_sext;
				addr_to_dmem = {load_addr[31:2], 2'b00};
				if (insn_sb) begin
					if (load_addr[1:0] == 2'b00) begin
						store_we_to_dmem = 4'b0001;
						store_data_to_dmem = {24'b000000000000000000000000, rs2_data[7:0]};
					end
					else if (load_addr[1:0] == 2'b01) begin
						store_we_to_dmem = 4'b0010;
						store_data_to_dmem = {16'b0000000000000000, rs2_data[7:0], 8'b00000000};
					end
					else if (load_addr[1:0] == 2'b10) begin
						store_we_to_dmem = 4'b0100;
						store_data_to_dmem = {8'b00000000, rs2_data[7:0], 16'b0000000000000000};
					end
					else if (load_addr[1:0] == 2'b11) begin
						store_we_to_dmem = 4'b1000;
						store_data_to_dmem = {rs2_data[7:0], 24'b000000000000000000000000};
					end
					else
						illegal_insn = 1'b1;
				end
				else if (insn_sh) begin
					if (load_addr[1:0] == 2'b00) begin
						store_we_to_dmem = 4'b0011;
						store_data_to_dmem = {16'b0000000000000000, rs2_data[15:0]};
					end
					else if (load_addr[1:0] == 2'b10) begin
						store_we_to_dmem = 4'b1100;
						store_data_to_dmem = {rs2_data[15:0], 16'b0000000000000000};
					end
				end
				else if (insn_sw) begin
					store_we_to_dmem = 4'b1111;
					store_data_to_dmem = rs2_data;
				end
			end
			OpBranch: begin
				we = 1'b0;
				if (insn_beq && (rs1_data == rs2_data))
					pcNext = pcCurrent + imm_b_sext;
				else if (insn_bne && (rs1_data != rs2_data))
					pcNext = pcCurrent + imm_b_sext;
				else if (insn_blt && ($signed(rs1_data) < $signed(rs2_data)))
					pcNext = pcCurrent + imm_b_sext;
				else if (insn_bge && ($signed(rs1_data) >= $signed(rs2_data)))
					pcNext = pcCurrent + imm_b_sext;
				else if (insn_bltu && (rs1_data < rs2_data))
					pcNext = pcCurrent + imm_b_sext;
				else if (insn_bgeu && (rs1_data >= rs2_data))
					pcNext = pcCurrent + imm_b_sext;
			end
			OpJal: begin
				we = 1;
				output_d = pcCurrent + 4;
				pcNext = pcCurrent + imm_j_sext;
			end
			OpJalr: begin
				we = 1;
				output_d = pcCurrent + 4;
				pcNext = (rs1_data + imm_i_sext) & ~32'h00000001;
			end
			OpAuipc: begin
				we = 1;
				output_d = pcCurrent + (insn_from_imem[31:12] << 12);
			end
			OpEnviron:
				if (insn_ecall)
					halt = 1'b1;
				else
					halt = 1'b0;
			default: illegal_insn = 1'b1;
		endcase
	end
	always @(posedge clk)
		if (rst)
			div_insns <= 0;
		else if (div_insn) begin
			if (div_insns == 4'd8)
				div_insns <= 0;
			else
				div_insns <= div_insns + 1;
		end
		else
			div_insns <= 0;
	initial _sv2v_0 = 0;
endmodule
module MemorySingleCycle (
	rst,
	clock_mem,
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
	input wire clock_mem;
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
	always @(posedge clock_mem)
		if (rst)
			;
		else
			insn_from_imem <= mem_array[{pc_to_imem[AddrMsb:AddrLsb]}];
	always @(negedge clock_mem)
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
module SystemResourceCheck (
	external_clk_25MHz,
	btn,
	led
);
	input wire external_clk_25MHz;
	input wire [6:0] btn;
	output wire [7:0] led;
	wire clk_proc;
	wire clk_mem;
	wire clk_locked;
	MyClockGen clock_gen(
		.input_clk_25MHz(external_clk_25MHz),
		.clk_proc(clk_proc),
		.clk_mem(clk_mem),
		.locked(clk_locked)
	);
	wire [31:0] pc_to_imem;
	wire [31:0] insn_from_imem;
	wire [31:0] mem_data_addr;
	wire [31:0] mem_data_loaded_value;
	wire [31:0] mem_data_to_write;
	wire [3:0] mem_data_we;
	MemorySingleCycle #(.NUM_WORDS(128)) memory(
		.rst(!clk_locked),
		.clock_mem(clk_mem),
		.pc_to_imem(pc_to_imem),
		.insn_from_imem(insn_from_imem),
		.addr_to_dmem(mem_data_addr),
		.load_data_from_dmem(mem_data_loaded_value),
		.store_data_to_dmem(mem_data_to_write),
		.store_we_to_dmem(mem_data_we)
	);
	DatapathMultiCycle datapath(
		.clk(clk_proc),
		.rst(!clk_locked),
		.pc_to_imem(pc_to_imem),
		.insn_from_imem(insn_from_imem),
		.addr_to_dmem(mem_data_addr),
		.store_data_to_dmem(mem_data_to_write),
		.store_we_to_dmem(mem_data_we),
		.load_data_from_dmem(mem_data_loaded_value),
		.halt(led[0])
	);
endmodule