`timescale 1ns / 1ns

// registers are 32 bits in RV32
`define REG_SIZE 31:0

// insns are 32 bits in RV32IM
`define INSN_SIZE 31:0

// RV opcodes are 7 bits
`define OPCODE_SIZE 6:0

`ifndef DIVIDER_STAGES
`define DIVIDER_STAGES 8
`endif

`ifndef SYNTHESIS
`include "../hw3-singlecycle/RvDisassembler.sv"
`endif
`include "../hw2b-cla/CarryLookaheadAdder.sv"
`include "../hw4-multicycle/DividerUnsignedPipelined.sv"
`include "../hw3-singlecycle/cycle_status.sv"

module Disasm #(
    byte PREFIX = "D"
) (
    input wire [31:0] insn,
    output wire [(8*32)-1:0] disasm
);
`ifndef SYNTHESIS
  // this code is only for simulation, not synthesis
  string disasm_string;
  always_comb begin
    disasm_string = rv_disasm(insn);
  end
  // HACK: get disasm_string to appear in GtkWave, which can apparently show only wire/logic. Also,
  // string needs to be reversed to render correctly.
  genvar i;
  for (i = 3; i < 32; i = i + 1) begin : gen_disasm
    assign disasm[((i+1-3)*8)-1-:8] = disasm_string[31-i];
  end
  assign disasm[255-:8] = PREFIX;
  assign disasm[247-:8] = ":";
  assign disasm[239-:8] = " ";
`endif
endmodule

module RegFile (
    input logic [4:0] rd,
    input logic [`REG_SIZE] rd_data,
    input logic [4:0] rs1,
    output logic [`REG_SIZE] rs1_data,
    input logic [4:0] rs2,
    output logic [`REG_SIZE] rs2_data,

    input logic clk,
    input logic we,
    input logic rst
);
  localparam int NumRegs = 32;
  logic [`REG_SIZE] regs[NumRegs];

  // TODO: your code here
  //read port
 always_comb begin

  //forward rs1 simultaneous access 
  if (rs1 == rd && we && rd != 0 && rs2 == rd) begin
    rs1_data = rd_data;
    rs2_data = rd_data;
  end

  else if (rs1 == rd && we && rd != '0) begin
    rs1_data = rd_data;
    rs2_data = regs[rs2];
  end
  else if (rs2 == rd && we && rd != '0) begin
    rs2_data = rd_data;
    rs1_data = regs[rs1];
  end
  else begin
    rs1_data = regs[rs1];
    rs2_data = regs[rs2];
  end
 
 end

 //write

 always_ff @ (posedge clk) begin
 if(rst) begin
 for(int i = 0; i < NumRegs; i++) begin
 regs[i] <= '0;
 end
 end
 else if (we && |rd) begin
 regs[rd] <= rd_data;
 end

 end

endmodule

/** state at the start of Decode stage */
typedef struct packed {
  logic [`REG_SIZE] pc;
  logic [`INSN_SIZE] insn;
  cycle_status_e cycle_status;
} stage_decode_t;

typedef struct packed {
  logic [`REG_SIZE] pc;
  logic [`INSN_SIZE] insn;
  cycle_status_e cycle_status;
  logic [`REG_SIZE] reg_a;
  logic [`REG_SIZE] reg_b;
  logic [4:0] rega_add;
  logic [4:0] regb_add;

} stage_execute_t;

typedef struct packed {
  logic [`REG_SIZE] pc;
  logic [`INSN_SIZE] insn;
  cycle_status_e cycle_status;
  logic [`REG_SIZE] alu_output;
  logic [`REG_SIZE] reg_b;
  logic [4:0] wb_reg_addr;
  logic reg_we;
  logic [4:0] rega_add;
  logic [4:0] regb_add;
} stage_mem_t;

typedef struct packed {
  logic [`REG_SIZE] pc;
  logic [`INSN_SIZE] insn;
  cycle_status_e cycle_status;
  logic [`REG_SIZE] mem_output;
  logic [`REG_SIZE] alu_output;
  logic [4:0] wb_reg_addr;
  logic reg_we;
} stage_wb_t;

module DatapathPipelined (
    input wire clk,
    input wire rst,
    output logic [`REG_SIZE] pc_to_imem,
    input wire [`INSN_SIZE] insn_from_imem,
    // dmem is read/write
    output logic [`REG_SIZE] addr_to_dmem,
    input wire [`REG_SIZE] load_data_from_dmem,
    output logic [`REG_SIZE] store_data_to_dmem,
    output logic [3:0] store_we_to_dmem,

    output logic halt,

    // The PC of the insn currently in Writeback. 0 if not a valid insn.
    output logic [`REG_SIZE] trace_completed_pc,
    // The bits of the insn currently in Writeback. 0 if not a valid insn.
    output logic [`INSN_SIZE] trace_completed_insn,
    // The status of the insn (or stall) currently in Writeback. See the cycle_status.sv file for valid values.
    output cycle_status_e trace_completed_cycle_status
);

  // cycle counter, not really part of any stage but useful for orienting within GtkWave
  // do not rename this as the testbench uses this value
  logic [`REG_SIZE] cycles_current;
  always_ff @(posedge clk) begin
    if (rst) begin
      cycles_current <= 0;
    end else begin
      cycles_current <= cycles_current + 1;
    end
  end

  /***************/
  /* FETCH STAGE */
  /***************/

  logic [`REG_SIZE] f_pc_current;
  wire [`REG_SIZE] f_insn;
  cycle_status_e f_cycle_status;

  // program counter
  always_ff @(posedge clk) begin
    if (rst) begin
      f_pc_current <= 32'd0;
      // NB: use CYCLE_NO_STALL since this is the value that will persist after the last reset cycle
      f_cycle_status <= CYCLE_NO_STALL;
    end 
    else if (load_stall) begin
      f_pc_current = f_pc_current; //hold and repeat
    end
    else begin
      f_cycle_status <= CYCLE_NO_STALL;
      f_pc_current <= (branch_taken) ? branch_pc: f_pc_current + 4;
    end
  end
  // send PC to imem
  assign pc_to_imem = f_pc_current;
  assign f_insn = insn_from_imem;

  // Here's how to disassemble an insn into a string you can view in GtkWave.
  // Use PREFIX to provide a 1-character tag to identify which stage the insn comes from.
  wire [255:0] f_disasm;
  Disasm #(
      .PREFIX("F")
  ) disasm_0fetch (
      .insn  (f_insn),
      .disasm(f_disasm)
  );

  /****************/
  /* DECODE STAGE */
  /****************/

  logic [`REG_SIZE] d_pc_current;
  wire [`REG_SIZE] d_insn;
  cycle_status_e d_cycle_status;
  logic is_stall;
  logic [3:0] div_insns;

  assign d_pc_current = decode_state.pc;
  assign d_insn = decode_state.insn;

  wire [6:0] d_insn_opcode = decode_state.insn[6:0];

  wire d_insn_div = d_insn_opcode == OpRegReg && d_insn[31:25] == 7'd1 && d_insn[14:12] == 3'b100;
  wire d_insn_divu = d_insn_opcode == OpRegReg && d_insn[31:25] == 7'd1 && d_insn[14:12] == 3'b101;
  wire d_insn_rem = d_insn_opcode == OpRegReg && d_insn[31:25] == 7'd1 && d_insn[14:12] == 3'b110;
  wire d_insn_remu = d_insn_opcode == OpRegReg && d_insn[31:25] == 7'd1 && d_insn[14:12] == 3'b111;

  wire [4:0] d_rs1 = decode_state.insn[19:15]; // which registers we are reading from
  wire [4:0] d_rs2 = decode_state.insn[24:20];

  wire d_div_insn = insn_div | insn_divu | insn_rem | insn_remu;

  

  //// STALLING ////

  // 1-cycle load use stall

  wire is_load = execute_state.insn[6:0] == OpLoad;
  
  wire load_stall = is_load &&  (
    (e_insn[11:7] == d_rs1 && d_rs1 != 0) || 
    (e_insn[11:7] == d_rs2 && d_rs2 != 0));
  

  // multi-cycle (possible) div stall

  /*
  always_comb begin
    if (d_div_insn == 1'b1 && prev_div)
    begin
        // stall
        is_stall = 1'b1;
    end
  end
  */

  

  // this shows how to package up state in a `struct packed`, and how to pass it between stages
  stage_decode_t decode_state;

  always_ff @(posedge clk) begin
    if (rst) begin
      decode_state <= '{
        pc: 0,
        insn: 0,
        cycle_status: CYCLE_RESET
      };
    end
    else if (branch_taken) begin
      decode_state <= '{
        pc: 0,
        insn: 0,
        cycle_status: CYCLE_TAKEN_BRANCH
      };
    end 
    else if (load_stall) begin
      decode_state <= decode_state;
    end
    else begin
        decode_state <= '{
          pc: f_pc_current,
          insn: f_insn,
          cycle_status: f_cycle_status
        };
      
    end
  end

  wire [255:0] d_disasm;
  Disasm #(
      .PREFIX("D")
  ) disasm_1decode (
      .insn  (decode_state.insn),
      .disasm(d_disasm)
  );

//write the comb logic for Decode stage



RegFile rf (
  .clk(clk),
  .rst(rst),
  .rs1_data(d_reg1),
  .rs2_data(d_reg2),
  .rs1(d_rs1),
  .rs2(d_rs2),

  //happens from Writeback
  .we(wb_state.reg_we),
  .rd(w_rd),
  .rd_data(w_data)
);

wire [`REG_SIZE] d_reg1, d_reg2;

//get immediates and sign extend

  /****************/
  /*   EXECUTE STAGE   */
  /****************/

    stage_execute_t execute_state;
    always_ff @(posedge clk) begin
    if (rst) begin
      execute_state <= '{
        pc: 0,
        insn: 0,
        cycle_status: CYCLE_RESET,
        reg_a: 0,
        reg_b: 0,
        rega_add: 0,
        regb_add: 0
      };
    end
    else if (branch_taken) begin
      execute_state <= '{
        pc: 0,
        insn: 0,
        cycle_status: CYCLE_TAKEN_BRANCH,
        reg_a: 0,
        reg_b: 0,
        rega_add: 0,
        regb_add: 0
      };
      
    end
    else if (load_stall) begin
      execute_state <= '{
        pc: 0,
        insn: 0,
        cycle_status: CYCLE_LOAD2USE,
        reg_a: 0,
        reg_b: 0,
        rega_add: 0,
        regb_add: 0
      }; 
    end
    else begin
        execute_state <= '{
          pc: decode_state.pc,
          insn: d_insn,
          cycle_status: decode_state.cycle_status,
          reg_a: d_reg1,
          reg_b: d_reg2,
          rega_add: d_rs1,
          regb_add: d_rs2
        };
      end
    end
  wire [255:0] e_disasm;
  Disasm #(
      .PREFIX("X")
  ) disasm_2exeucute (
      .insn  (execute_state.insn),
      .disasm(e_disasm)
  );



  logic [`REG_SIZE] e_pc_current;
  wire [`REG_SIZE] e_insn = execute_state.insn;
  logic e_wb;
  logic [`REG_SIZE] output_d;
  

wire [6:0] insn_opcode = execute_state.insn[6:0];
wire [4:0] e_rd = execute_state.insn[11:7];
wire [2:0] e_funct3 = execute_state.insn[14:12];
wire [6:0] e_funct7 = execute_state.insn[31:25];

// I - immediates and loads
wire [11:0] e_imm_i = execute_state.insn[31:20];
wire [4:0]  e_imm_shamt = execute_state.insn[24:20];

// S - stores
wire [11:0] e_imm_s;
assign e_imm_s[11:5] = execute_state.insn[31:25];
assign e_imm_s[4:0]  = execute_state.insn[11:7];

// B - conditionals
wire [12:0] e_imm_b;
assign {e_imm_b[12], e_imm_b[10:5]} = execute_state.insn[31:25];
assign {e_imm_b[4:1], e_imm_b[11]}  = execute_state.insn[11:7];
assign e_imm_b[0] = 1'b0;

// J - unconditional jumps
wire [20:0] e_imm_j;
assign {e_imm_j[20], e_imm_j[10:1], e_imm_j[11], e_imm_j[19:12], e_imm_j[0]} = {execute_state.insn[31:12], 1'b0};

// U - upper immediates
wire [`REG_SIZE] e_imm_u = {execute_state.insn[31:12], 12'b0};

// Sign-extended versions
wire [`REG_SIZE] e_imm_i_sext = {{20{e_imm_i[11]}}, e_imm_i[11:0]};
wire [`REG_SIZE] e_imm_s_sext = {{20{e_imm_s[11]}}, e_imm_s[11:0]};
wire [`REG_SIZE] e_imm_b_sext = {{19{e_imm_b[12]}}, e_imm_b[12:0]};
wire [`REG_SIZE] e_imm_j_sext = {{11{e_imm_j[20]}}, e_imm_j[20:0]};


 // opcodes - see section 19 of RiscV spec
 localparam bit [`OPCODE_SIZE] OpLoad = 7'b00_000_11;
 localparam bit [`OPCODE_SIZE] OpStore = 7'b01_000_11;
 localparam bit [`OPCODE_SIZE] OpBranch = 7'b11_000_11;
 localparam bit [`OPCODE_SIZE] OpJalr = 7'b11_001_11;
 localparam bit [`OPCODE_SIZE] OpMiscMem = 7'b00_011_11;
 localparam bit [`OPCODE_SIZE] OpJal = 7'b11_011_11;

 localparam bit [`OPCODE_SIZE] OpRegImm = 7'b00_100_11;
 localparam bit [`OPCODE_SIZE] OpRegReg = 7'b01_100_11;
 localparam bit [`OPCODE_SIZE] OpEnviron = 7'b11_100_11;

 localparam bit [`OPCODE_SIZE] OpAuipc = 7'b00_101_11;
 localparam bit [`OPCODE_SIZE] OpLui = 7'b01_101_11;

 wire insn_lui = insn_opcode == OpLui;
 wire insn_auipc = insn_opcode == OpAuipc;
 wire insn_jal = insn_opcode == OpJal;
 wire insn_jalr = insn_opcode == OpJalr;

 wire insn_beq = insn_opcode == OpBranch && e_insn[14:12] == 3'b000;
 wire insn_bne = insn_opcode == OpBranch && e_insn[14:12] == 3'b001;
 wire insn_blt = insn_opcode == OpBranch && e_insn[14:12] == 3'b100;
 wire insn_bge = insn_opcode == OpBranch && e_insn[14:12] == 3'b101;
 wire insn_bltu = insn_opcode == OpBranch && e_insn[14:12] == 3'b110;
 wire insn_bgeu = insn_opcode == OpBranch && e_insn[14:12] == 3'b111;

 wire insn_lb = insn_opcode == OpLoad && e_insn[14:12] == 3'b000;
 wire insn_lh = insn_opcode == OpLoad && e_insn[14:12] == 3'b001;
 wire insn_lw = insn_opcode == OpLoad && e_insn[14:12] == 3'b010;
 wire insn_lbu = insn_opcode == OpLoad && e_insn[14:12] == 3'b100;
 wire insn_lhu = insn_opcode == OpLoad && e_insn[14:12] == 3'b101;

 wire insn_sb = insn_opcode == OpStore && e_insn[14:12] == 3'b000;
 wire insn_sh = insn_opcode == OpStore && e_insn[14:12] == 3'b001;
 wire insn_sw = insn_opcode == OpStore && e_insn[14:12] == 3'b010;

 wire insn_addi = insn_opcode == OpRegImm && e_insn[14:12] == 3'b000;
 wire insn_slti = insn_opcode == OpRegImm && e_insn[14:12] == 3'b010;
 wire insn_sltiu = insn_opcode == OpRegImm && e_insn[14:12] == 3'b011;
 wire insn_xori = insn_opcode == OpRegImm && e_insn[14:12] == 3'b100;
 wire insn_ori = insn_opcode == OpRegImm && e_insn[14:12] == 3'b110;
 wire insn_andi = insn_opcode == OpRegImm && e_insn[14:12] == 3'b111;

 wire insn_slli = insn_opcode == OpRegImm && e_insn[14:12] == 3'b001 && e_insn[31:25] == 7'd0;
 wire insn_srli = insn_opcode == OpRegImm && e_insn[14:12] == 3'b101 && e_insn[31:25] == 7'd0;
 wire insn_srai = insn_opcode == OpRegImm && e_insn[14:12] == 3'b101 && e_insn[31:25] == 7'b0100000;

 wire insn_add = insn_opcode == OpRegReg && e_insn[14:12] == 3'b000 && e_insn[31:25] == 7'd0;
 wire insn_sub = insn_opcode == OpRegReg && e_insn[14:12] == 3'b000 && e_insn[31:25] == 7'b0100000;
 wire insn_sll = insn_opcode == OpRegReg && e_insn[14:12] == 3'b001 && e_insn[31:25] == 7'd0;
 wire insn_slt = insn_opcode == OpRegReg && e_insn[14:12] == 3'b010 && e_insn[31:25] == 7'd0;
 wire insn_sltu = insn_opcode == OpRegReg && e_insn[14:12] == 3'b011 && e_insn[31:25] == 7'd0;
 wire insn_xor = insn_opcode == OpRegReg && e_insn[14:12] == 3'b100 && e_insn[31:25] == 7'd0;
 wire insn_srl = insn_opcode == OpRegReg && e_insn[14:12] == 3'b101 && e_insn[31:25] == 7'd0;
 wire insn_sra = insn_opcode == OpRegReg && e_insn[14:12] == 3'b101 && e_insn[31:25] == 7'b0100000;
 wire insn_or = insn_opcode == OpRegReg && e_insn[14:12] == 3'b110 && e_insn[31:25] == 7'd0;
 wire insn_and = insn_opcode == OpRegReg && e_insn[14:12] == 3'b111 && e_insn[31:25] == 7'd0;

 wire insn_mul = insn_opcode == OpRegReg && e_insn[31:25] == 7'd1 && e_insn[14:12] == 3'b000;
 wire insn_mulh = insn_opcode == OpRegReg && e_insn[31:25] == 7'd1 && e_insn[14:12] == 3'b001;
 wire insn_mulhsu = insn_opcode == OpRegReg && e_insn[31:25] == 7'd1 && e_insn[14:12] == 3'b010;
 wire insn_mulhu = insn_opcode == OpRegReg && e_insn[31:25] == 7'd1 && e_insn[14:12] == 3'b011;
 wire insn_div = insn_opcode == OpRegReg && e_insn[31:25] == 7'd1 && e_insn[14:12] == 3'b100;
 wire insn_divu = insn_opcode == OpRegReg && e_insn[31:25] == 7'd1 && e_insn[14:12] == 3'b101;
 wire insn_rem = insn_opcode == OpRegReg && e_insn[31:25] == 7'd1 && e_insn[14:12] == 3'b110;
 wire insn_remu = insn_opcode == OpRegReg && e_insn[31:25] == 7'd1 && e_insn[14:12] == 3'b111;

 wire div_insn = insn_div | insn_divu | insn_rem | insn_remu;
 
 wire [4:0] e_rs1    = execute_state.insn[19:15];
 wire [4:0] e_rs2    = execute_state.insn[24:20];

 wire insn_ecall = insn_opcode == OpEnviron && e_insn[31:7] == 25'd0;
 wire insn_fence = insn_opcode == OpMiscMem;


/* 


ALU


*/

/*
 wire is_stall = div_insn && (div_insns != 4'd8);
 logic [`REG_SIZE] pcNext; 
 execute_state.pc = decode_state.pc;
 always @(posedge clk) begin
 if (rst) begin
 execute_state.pc <= 32'd0;
 end else begin
execute_state.pc <= is_stall ? execute_state.pc : pcNext;
 end
 end
 assign pc_to_imem = execute_state.pc;
 */

 // cycle/execute_state.insn counters

 /*
 logic [`REG_SIZE] cycles_current, num_insns_current;
 always @(posedge clk) begin
 if (rst) begin
 cycles_current <= 0;
 num_insns_current <= 0;
 end else begin
 cycles_current <= cycles_current + 1;
 if (!rst && !is_stall) begin
 num_insns_current <= num_insns_current + 1;
 end
 end
 end

 */


 logic [`REG_SIZE] rs1_data;
 logic [`REG_SIZE] rs2_data;

  logic [`REG_SIZE] cla_b;
  logic [`REG_SIZE] cla_sum;
  logic cla_cin;
  logic [`REG_SIZE] div_rem;
  logic [`REG_SIZE] div_q;
  logic [31:0] div_b_input;
  logic [31:0] div_a_input;



  CarryLookaheadAdder cla (
    rs1_data, cla_b, (cla_cin), cla_sum
 );

 DividerUnsignedPipelined div (clk, rst, 0, div_a_input, div_b_input, div_rem, div_q);

 logic illegal_insn;
 logic we;
 logic [4:0] dest;
 logic [31:0] load_addr;
 logic [63:0] large_mul;
 logic branch_taken;
 logic [`REG_SIZE] branch_pc;


always_comb begin
  //::::::: MX FORWARDING:::::

  

    if (memory_state.reg_we && execute_state.rega_add != 0 && execute_state.rega_add == memory_state.wb_reg_addr) begin
    // forward from memory, don't check WB  
      rs1_data = memory_state.alu_output;
    end
    else if (wb_state.reg_we && execute_state.rega_add != 0 && execute_state.rega_add == wb_state.wb_reg_addr) begin
    // forward from WB 
      rs1_data = w_data;
    end
    else begin
      rs1_data = execute_state.reg_a;
    end
  
    //assign rs2 data
    if (memory_state.reg_we && execute_state.regb_add != 0 && execute_state.regb_add == memory_state.wb_reg_addr) begin
    // forward from memory, don't check WB  
      rs2_data = memory_state.alu_output;
    end
    else if (wb_state.reg_we && execute_state.regb_add != 0 && execute_state.regb_add == wb_state.wb_reg_addr) begin
    // forward from WB 
      rs2_data = w_data;
    end
    else begin
      rs2_data = execute_state.reg_b;
    end
    
end


 always_comb begin
 illegal_insn = 1'b0;
 we = 1'b0;
 output_d = '0;
 //pcNext = execute_state.pc + 4;
 cla_b = '0;
 cla_cin = '0;
 load_addr = '0;
 large_mul = '0;
 div_b_input = '0;
 div_a_input = '0;
 branch_taken = '0;
 branch_pc = '0;

 

 case (insn_opcode)
 OpLui: begin
 output_d = {execute_state.insn[31:12], 12'b0};
 we = 1;
 end
 OpRegImm: begin
 we = 1;
 if (insn_addi) begin
  cla_b = e_imm_i_sext;
  cla_cin = 0;
  output_d = cla_sum;
   end
 else if (insn_slti) begin
 output_d = {31'b0, ($signed(rs1_data) < $signed(e_imm_i_sext))};
 end
 else if (insn_sltiu) begin
 output_d = {31'b0, (rs1_data < e_imm_i_sext)};
 end
 else if (insn_xori) begin
 output_d = rs1_data ^ e_imm_i_sext;
 end
 else if (insn_ori) begin
 output_d = rs1_data | e_imm_i_sext;
 end
 else if (insn_andi) begin
 output_d = rs1_data & e_imm_i_sext;
 end
 else if (insn_slli) begin
 output_d = rs1_data << e_imm_shamt;
 end
 else if (insn_srli) begin
 output_d = rs1_data >> e_imm_shamt;
 end
 else if (insn_srai) begin
 output_d = $signed(rs1_data) >>> e_imm_shamt;
 end
 else begin
 illegal_insn = 1'b1;
 end
 end

 OpRegReg: begin
 we = 1;
 if (insn_add) begin
  cla_b = rs2_data;
  cla_cin = 0;
  output_d = cla_sum;
 end
 else if (insn_sub) begin
  cla_b = ~(rs2_data);
  cla_cin = 1;
  output_d = cla_sum;
 end
 else if (insn_sll) begin
 output_d = rs1_data << rs2_data[4:0];
 end
 else if (insn_slt) begin
 output_d = {31'b0, ($signed(rs1_data) < $signed(rs2_data))};
 end
 else if (insn_sltu) begin
 output_d = {31'b0, (rs1_data < rs2_data)};
 end
 else if (insn_xor) begin
 output_d = rs1_data ^ rs2_data;
 end
 else if (insn_srl) begin
 output_d = rs1_data >> rs2_data[4:0];
 end
 else if (insn_sra) begin
 output_d = $signed(rs1_data) >>> rs2_data[4:0];
 end
 else if (insn_or) begin
 output_d = rs1_data | rs2_data;
 end
 else if (insn_and) begin
 output_d = rs1_data & rs2_data;
 end
 else if (insn_mul | insn_mulh | insn_mulhsu | insn_mulhu | insn_div | insn_divu | insn_rem | insn_remu) begin
  
  if (insn_mul) begin
    large_mul = $signed(rs1_data) * $signed(rs2_data);
    output_d = large_mul[31:0];
  end
  else if (insn_mulh) begin
    large_mul = (($signed(rs1_data) * $signed(rs2_data)));
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



  end
  else illegal_insn = 1'b1;

  // TO DO: Pipelined Division

 end
 else begin
 illegal_insn = 1'b1;
 end
 end


OpBranch: begin
 we = 1'b0;
branch_taken = 0;
branch_pc = '0;
 if(insn_beq && rs1_data == rs2_data) begin
  branch_pc = execute_state.pc + e_imm_b_sext;
  branch_taken = 1;
  end
  else if(insn_bne && rs1_data != rs2_data) begin
   branch_pc = execute_state.pc + e_imm_b_sext;
   branch_taken = 1;
  end
  else if(insn_blt && $signed(rs1_data) < $signed(rs2_data)) begin
   branch_pc = execute_state.pc + e_imm_b_sext;
   branch_taken = 1;
  end
  else if(insn_bge && $signed(rs1_data) >= $signed(rs2_data)) begin
   branch_pc = execute_state.pc + e_imm_b_sext;
   branch_taken = 1;
  end
  else if(insn_bltu && rs1_data < rs2_data) begin
   branch_pc = execute_state.pc + e_imm_b_sext;
   branch_taken = 1;
  end
  else if(insn_bgeu && rs1_data >= rs2_data) begin
   branch_pc = execute_state.pc + e_imm_b_sext;
   branch_taken = 1;
  end

 end

 OpJalr: begin
  we = 1'b1; 
  output_d = execute_state.pc + 4;
  branch_pc = (rs1_data + e_imm_i_sext) & 32'b1;
  branch_taken = 1;
  
 end

 OpJal: begin
  we = 1'b1;
  output_d = execute_state.pc + 4;
  branch_pc = execute_state.pc + e_imm_i_sext;
  branch_taken = 1;
 end

 OpAuipc: begin
  we = 1'b1;
  output_d = execute_state.pc + e_imm_u;
 end

 OpLoad: begin
  we = 1'b1;
  output_d = rs1_data + e_imm_i_sext; //compute the address and pass it
 end

 OpStore: begin
  we = 1'b0;
  output_d = rs1_data + e_imm_i_sext; //compute the address and pass it
 end

 default: begin
 illegal_insn = 1'b1;
 end
 endcase

 end

`ifndef SYNTHESIS
  always @(posedge clk) begin
    if (!rst) begin
      $display("=== CYCLE %0d ===", cycles_current);
      $display("  FETCH:   pc=%h  insn=%h", f_pc_current, f_insn);
      $display("  DECODE:  pc=%h  insn=%h  status=%0d", decode_state.pc, decode_state.insn, decode_state.cycle_status);
      $display("  EXECUTE: pc=%h  insn=%h  status=%0d  rega=%0d  regb=%0d  reg_a=%h  reg_b=%h",
               execute_state.pc, execute_state.insn, execute_state.cycle_status,
               execute_state.rega_add, execute_state.regb_add, execute_state.reg_a, execute_state.reg_b);
      $display("    FWD-> rs1_data=%h  rs2_data=%h", rs1_data, rs2_data);
      $display("    BRN-> insn_bne=%0b  branch_taken=%0b  branch_pc=%h  we=%0b  output_d=%h",
               insn_bne, branch_taken, branch_pc, we, output_d);
      $display("    MX?-> mem.we=%0b  mem.wb_addr=%0d  mem.alu=%h",
               memory_state.reg_we, memory_state.wb_reg_addr, memory_state.alu_output);
      $display("    WX?-> wb.we=%0b  wb.wb_addr=%0d  w_data=%h",
               wb_state.reg_we, wb_state.wb_reg_addr, w_data);
      $display("  MEMORY:  pc=%h  insn=%h  we=%0b  wb_addr=%0d  alu=%h",
               memory_state.pc, memory_state.insn, memory_state.reg_we, memory_state.wb_reg_addr, memory_state.alu_output);
      $display("  WB:      pc=%h  insn=%h  we=%0b  wb_addr=%0d  alu=%h",
               wb_state.pc, wb_state.insn, wb_state.reg_we, wb_state.wb_reg_addr, wb_state.alu_output);
      $display("  RF[1]=%h  rf.we=%0b  rf.rd=%0d  rf.rd_data=%h",
               rf.regs[1], wb_state.reg_we, w_rd, w_data);
      $display("");
    end
  end
`endif
  
  /* 

    MEMORY

  */


  logic [`REG_SIZE] m_pc_current;
  wire [`REG_SIZE] m_insn = memory_state.insn;
  logic m_we = memory_state.reg_we;
  logic [`REG_SIZE] m_output;
  logic m_re;
  wire [6:0] m_insn_opcode = m_insn[6:0];

   wire d_insn_lb = m_insn_opcode == OpLoad && m_insn[14:12] == 3'b000;
   wire d_insn_lh = m_insn_opcode == OpLoad && m_insn[14:12] == 3'b001;
   wire d_insn_lw = m_insn_opcode == OpLoad && m_insn[14:12] == 3'b010;
   wire d_insn_lbu = m_insn_opcode == OpLoad && m_insn[14:12] == 3'b100;
   wire d_insn_lhu = m_insn_opcode == OpLoad && m_insn[14:12] == 3'b101;

   wire d_insn_sb = m_insn_opcode == OpStore && m_insn[14:12] == 3'b000;
   wire d_insn_sh = m_insn_opcode == OpStore && m_insn[14:12] == 3'b001;
   wire d_insn_sw = m_insn_opcode == OpStore && m_insn[14:12] == 3'b010;


   
   logic [1:0] load_byte_offset = memory_state.alu_output[1:0];
   logic [7:0] selected_byte;
   logic [31:0] m_data;
   assign addr_to_dmem = memory_state.alu_output & 32'hFFFC;


  // TO DO: Store to/load from memory


  always_comb begin

  case (load_byte_offset)
        2'b00: selected_byte = load_data_from_dmem[7:0];
        2'b01: selected_byte = load_data_from_dmem[15:8];
        2'b10: selected_byte = load_data_from_dmem[23:16];
        2'b11: selected_byte = load_data_from_dmem[31:24];
        default: selected_byte = 8'b0;
  endcase

  store_data_to_dmem = '0;
  store_we_to_dmem = '0;
  m_data = '0;

 if (d_insn_lb) begin
  m_data = {{24{selected_byte[7]}}, selected_byte};
 end
 else if (d_insn_lh) begin
  // case here for 2-byte selection

  if (load_byte_offset == 2'b00) begin
    m_data = {{16{load_data_from_dmem[15]}}, load_data_from_dmem[15:0]};
  end
  else if (load_byte_offset == 2'b10) begin
    m_data = {{16{load_data_from_dmem[31]}}, load_data_from_dmem[31:16]};
  end
 end

else if (d_insn_lw) begin
  m_data = load_data_from_dmem;
end

else if (d_insn_lbu) begin
  m_data = {24'b0, selected_byte};
end
else if (d_insn_lhu) begin

    if (load_byte_offset == 2'b00) begin
    m_data = {16'b0, load_data_from_dmem[15:0]};
  end
  else if (load_byte_offset == 2'b10) begin
    m_data = {16'b0, load_data_from_dmem[31:16]};
  end

end

// Store Logic 

else if (d_insn_sb) begin

    if (memory_state.alu_output[1:0] == 2'b00) begin
      store_we_to_dmem = 4'b1;
      store_data_to_dmem = {24'b0, memory_state.reg_b[7:0]};
    end
    else if (memory_state.alu_output[1:0] == 2'b01) begin
      store_we_to_dmem = 4'b10;
      store_data_to_dmem = {{16'b0, memory_state.reg_b[7:0]} , 8'b0};
    end
    else if (memory_state.alu_output[1:0] == 2'b10) begin
      store_we_to_dmem = 4'b100;
      store_data_to_dmem = {{8'b0, memory_state.reg_b[7:0]} , 16'b0};
    end
    else if (memory_state.alu_output[1:0] == 2'b11) begin
      store_we_to_dmem = 4'b1000;
      store_data_to_dmem = {memory_state.reg_b[7:0], 24'b0};
    end
    else begin end

  end

  else if (d_insn_sh) begin

    if (load_byte_offset == 2'b00) begin
      store_we_to_dmem = 4'b0011;
      store_data_to_dmem = {16'b0, memory_state.reg_b[15:0]};
    end
    else if (load_byte_offset == 2'b10) begin
      store_we_to_dmem = 4'b1100;
      store_data_to_dmem = {memory_state.reg_b[15:0] , 16'b0};
    end

  end

  else if (d_insn_sw) begin
    store_we_to_dmem = 4'b1111;
    store_data_to_dmem = memory_state.reg_b;
  end
 end


  // this shows how to package up state in a `struct packed`, and how to pass it between stages
  stage_mem_t memory_state;
  always_ff @(posedge clk) begin
    if (rst) begin
      memory_state <= '{
          default: 0,
          cycle_status : CYCLE_RESET

      };
    end 
    else if (wb_state.insn[6:0] == OpLoad && memory_state.insn[6:0] == OpStore && wb_state.wb_reg_addr == memory_state.regb_add) begin
      memory_state <= '{
        pc: execute_state.pc,
        insn: execute_state.insn,
        cycle_status: execute_state.cycle_status,
        reg_we: we,
        wb_reg_addr: e_rd,
        reg_b : wb_state.mem_output,
        alu_output : output_d,
        rega_add : execute_state.rega_add,
        regb_add : execute_state.regb_add
      };
    end
    else begin
        memory_state <= '{
         pc: execute_state.pc,
        insn: execute_state.insn,
        cycle_status: execute_state.cycle_status,
        reg_we: we,
        wb_reg_addr: e_rd,
        reg_b : execute_state.reg_b,
        alu_output : output_d,
        rega_add : execute_state.rega_add,
        regb_add : execute_state.regb_add
        };
    end
  end
  wire [255:0] m_disasm;
  Disasm #(
      .PREFIX("M")
  ) disasm_3memory (
      .insn  (memory_state.insn),
      .disasm(m_disasm)
  );



  

  /* 

    WRITE BACK

  */


  logic [`REG_SIZE] w_pc_current;
  wire [`REG_SIZE] w_insn;
  wire wb_insn_ecall = wb_insn_opcode == OpEnviron && wb_state.insn[31:7] == 25'd0;
  wire [6:0] wb_insn_opcode = wb_state.insn[6:0];

    
  // this shows how to package up state in a `struct packed`, and how to pass it between stages
  stage_wb_t wb_state;
  always_ff @(posedge clk) begin
    if (rst) begin
      wb_state <= '{
          default: 0,
          cycle_status: CYCLE_RESET

      };
    end else begin
      begin
        wb_state <= '{
         pc: memory_state.pc,
        insn: memory_state.insn,
        cycle_status: memory_state.cycle_status,
        reg_we: memory_state.reg_we,
        wb_reg_addr: memory_state.wb_reg_addr,
        alu_output:  memory_state.alu_output,
        mem_output: m_data
        
        
        };
      end
    end
  end
  wire [255:0] wb_disasm;
  Disasm #(
      .PREFIX("W")
  ) disasm_4wb (
      .insn  (wb_state.insn),
      .disasm(wb_disasm)
  );

logic [`REG_SIZE] w_data;
logic [4:0] w_rd;

always_comb begin
  w_data = wb_state.alu_output;
  w_rd = wb_state.wb_reg_addr;

  if (wb_insn_ecall && wb_state.cycle_status == CYCLE_NO_STALL) begin
    halt = 1'b1;
  end
  else 
    halt = 1'b0;
end

assign trace_completed_cycle_status = wb_state.cycle_status;
assign trace_completed_pc = (wb_state.cycle_status == CYCLE_NO_STALL) ? wb_state.pc : 0;
assign trace_completed_insn = (wb_state.cycle_status == CYCLE_NO_STALL) ? wb_state.insn : 0;

  
  


  // TODO: your code here, though you will also need to modify some of the code above
  // TODO: the testbench requires that your register file instance is named `rf`

endmodule

module MemorySingleCycle #(
    parameter int NUM_WORDS = 512
) (
    // rst for both imem and dmem
    input wire rst,

    // clock for both imem and dmem. The memory reads/writes on @(negedge clk)
    input wire clk,

    // must always be aligned to a 4B boundary
    input wire [`REG_SIZE] pc_to_imem,

    // the value at memory location pc_to_imem
    output logic [`REG_SIZE] insn_from_imem,

    // must always be aligned to a 4B boundary
    input wire [`REG_SIZE] addr_to_dmem,

    // the value at memory location addr_to_dmem
    output logic [`REG_SIZE] load_data_from_dmem,

    // the value to be written to addr_to_dmem, controlled by store_we_to_dmem
    input wire [`REG_SIZE] store_data_to_dmem,

    // Each bit determines whether to write the corresponding byte of store_data_to_dmem to memory location addr_to_dmem.
    // E.g., 4'b1111 will write 4 bytes. 4'b0001 will write only the least-significant byte.
    input wire [3:0] store_we_to_dmem
);

  // memory is arranged as an array of 4B words
  logic [`REG_SIZE] mem_array[NUM_WORDS];

`ifdef SYNTHESIS
  initial begin
    $readmemh("mem_initial_contents.hex", mem_array);
  end
`endif

  always_comb begin
    // memory addresses should always be 4B-aligned
    assert (pc_to_imem[1:0] == 2'b00);
    assert (addr_to_dmem[1:0] == 2'b00);
  end

  localparam int AddrMsb = $clog2(NUM_WORDS) + 1;
  localparam int AddrLsb = 2;

  always @(negedge clk) begin
    if (rst) begin
    end else begin
      insn_from_imem <= mem_array[{pc_to_imem[AddrMsb:AddrLsb]}];
    end
  end

  always @(negedge clk) begin
    if (rst) begin
    end else begin
      if (store_we_to_dmem[0]) begin
        mem_array[addr_to_dmem[AddrMsb:AddrLsb]][7:0] <= store_data_to_dmem[7:0];
      end
      if (store_we_to_dmem[1]) begin
        mem_array[addr_to_dmem[AddrMsb:AddrLsb]][15:8] <= store_data_to_dmem[15:8];
      end
      if (store_we_to_dmem[2]) begin
        mem_array[addr_to_dmem[AddrMsb:AddrLsb]][23:16] <= store_data_to_dmem[23:16];
      end
      if (store_we_to_dmem[3]) begin
        mem_array[addr_to_dmem[AddrMsb:AddrLsb]][31:24] <= store_data_to_dmem[31:24];
      end
      // dmem is "read-first": read returns value before the write
      load_data_from_dmem <= mem_array[{addr_to_dmem[AddrMsb:AddrLsb]}];
    end
  end
endmodule

/* This design has just one clock for both processor and memory. */
module Processor (
    input  wire  clk,
    input  wire  rst,
    output logic halt,
    output wire [`REG_SIZE] trace_completed_pc,
    output wire [`INSN_SIZE] trace_completed_insn,
    output cycle_status_e trace_completed_cycle_status
);

  wire [`INSN_SIZE] insn_from_imem;
  wire [`REG_SIZE] pc_to_imem, mem_data_addr, mem_data_loaded_value, mem_data_to_write;
  wire [3:0] mem_data_we;

  // This wire is set by cocotb to the name of the currently-running test, to make it easier
  // to see what is going on in the waveforms.
  wire [(8*32)-1:0] test_case;

  MemorySingleCycle #(
      .NUM_WORDS(8192)
  ) memory (
      .rst                (rst),
      .clk                (clk),
      // imem is read-only
      .pc_to_imem         (pc_to_imem),
      .insn_from_imem     (insn_from_imem),
      // dmem is read-write
      .addr_to_dmem       (mem_data_addr),
      .load_data_from_dmem(mem_data_loaded_value),
      .store_data_to_dmem (mem_data_to_write),
      .store_we_to_dmem   (mem_data_we)
  );

  DatapathPipelined datapath (
      .clk(clk),
      .rst(rst),
      .pc_to_imem(pc_to_imem),
      .insn_from_imem(insn_from_imem),
      .addr_to_dmem(mem_data_addr),
      .store_data_to_dmem(mem_data_to_write),
      .store_we_to_dmem(mem_data_we),
      .load_data_from_dmem(mem_data_loaded_value),
      .halt(halt),
      .trace_completed_pc(trace_completed_pc),
      .trace_completed_insn(trace_completed_insn),
      .trace_completed_cycle_status(trace_completed_cycle_status)
  );

endmodule
