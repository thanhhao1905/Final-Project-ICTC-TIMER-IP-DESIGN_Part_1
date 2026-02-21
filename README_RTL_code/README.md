# Final-Project-ICTC _ TIMER-IP-DESIGN
The timer module features a high-resolution 64-bit counter supporting both free-running and periodic modes. A configurable prescaler allows flexible timing from high-frequency to long-duration applications, while the integrated APB interface ensures easy integration with ARM-based systems and complex digital designs.

**📌 For Part 2 (Physical Design from RTL to GDSII), please visit:** https://github.com/thanhhao1905/Timer_IP_PD_Flow_Part_2

**You can download the project documentation and my thesis report from the link below for reference:** https://drive.google.com/file/d/1qffMK9t-yx1JG5t6B6mj55Ywmq2DlfkS/view?usp=sharing

````verilog

module timer_top
(
	input wire sys_clk,
	input wire sys_rst_n,
	input wire tim_psel,
	input wire tim_pwrite,
	input wire tim_penable,
	input wire [11:0] tim_paddr,
	input wire [31:0] tim_pwdata,
	input wire [3:0] tim_pstrb,
	input wire dbg_mode,
	output wire [31:0] tim_prdata,
	output wire tim_pready,
	output wire tim_pslverr,
	output wire tim_int
);

	wire wr_en_w, rd_en_w, pready_w_w, pslverr_w_w;
	wire [31:0] wdata_w;
	wire [11:0] addr_w;
	wire [3:0] wstrb_w;
	wire [31:0] rdata_w;
	wire [31:0] data0_out_w;
	
	assign tim_pslverr = pslverr_w_w;

	apb_slave apb
(
	.psel(tim_psel),
	.pwrite(tim_pwrite),
	.penable(tim_penable),
	.pwdata(tim_pwdata),
	.paddr(tim_paddr),
	.pstrb(tim_pstrb),
	.pready_w(pready_w_w),
	.rdata(rdata_w),
	.data0_out(data0_out_w),
	.addr(addr_w),
	.wr_en(wr_en_w),
	.rd_en(rd_en_w),
	.wdata(wdata_w),
	.wstrb(wstrb_w),
	.pready(tim_pready),
	.prdata(tim_prdata),
	.pslverr(pslverr_w_w)
);

	
	reg_module register
(
	.clk(sys_clk),
	.rst_n(sys_rst_n),
	.wr_en(wr_en_w),
	.rd_en(rd_en_w),
	.addr(addr_w),
	.wdata(wdata_w),
	.wstrb(wstrb_w),
	.debug_mode(dbg_mode),
	.pready_w(pready_w_w),
	.rdata(rdata_w),
	.data0_out(data0_out_w),
	.pslverr(pslverr_w_w),
	.timer_int(tim_int)
);

endmodule



module apb_slave
(
	input wire psel,
	input wire pwrite,
	input wire penable,
	input wire [31:0]pwdata,
	input wire [11:0]paddr,
	input wire [3:0]pstrb,
	input wire pready_w,
	input wire [31:0]rdata,
	input wire [31:0]data0_out,
	output reg [11:0]addr,
	output reg wr_en,
	output reg rd_en,
	output reg [31:0]wdata,
	output reg [3:0]wstrb,
	output reg pready,
	output reg [31:0]prdata,
	output reg pslverr
);
	reg pslverr_w;

always @(*) begin

	wr_en   = psel && penable && pwrite && !pready_w;
	rd_en   = psel && penable && !pwrite && !pready_w;

	addr    = paddr;
	wdata   = pwdata;
	wstrb   = pstrb;
	pready  = pready_w;
	pslverr = pslverr_w;
	prdata  = rdata;
end

always @(*) begin
	pslverr_w =1'b0;
	if(psel && penable && pwrite && (paddr == 12'h000) && pstrb[1] ) begin
		if(data0_out[0]) begin
			if( (pwdata[1] != data0_out[1]) || (pwdata[11:8] >= 4'd9) || (pwdata[11:8] != data0_out[11:8]) ) begin
			pslverr_w =1'b1;
			end
		end else if (pwdata [11:8] >= 4'd9) begin
			pslverr_w =1'b1;
		end
	end
end

endmodule



module reg_module
(
	input wire clk,
	input wire rst_n,
	input wire wr_en,
	input wire rd_en,
	input wire [11:0] addr,
	input wire [31:0] wdata,
	input wire [3:0] wstrb,
	input wire debug_mode,
	input wire pslverr,
	output reg pready_w,
	output reg [31:0] rdata,
	output wire [31:0] data0_out,
	output reg timer_int
);

	reg [31:0] data0, data1, data2, data3, data4, data5, data6, data7;
	wire [31:0] data0_next, data1_next, data2_next, data3_next, data4_next, data5_next, data7_next;
	reg [7:0] int_cnt;
	reg pslverr_w;
	reg [31:0] data0_d;
	reg count_en;
	reg thcr_halt_reg;

	wire [7:0] int_cnt_pre;
	wire [7:0] int_cnt_0;
	wire [63:0] counter_64bit;
	wire count_en_pre, cnt_rst, thcr_halt_reg_pre;
	wire tri_condition;

	
	
	assign data0_out = data0;
	
//============= NEXT STATE LOGIC FOR REGISTER =====================

//==================== TCR =======================
	assign data0_next[7:0] = (wr_en && (addr == 12'h000) && wstrb[0]) ? {6'b0, wdata[1:0]} : data0[7:0];
	assign data0_next[15:8] = (wr_en && (addr == 12'h000) && wstrb[1]) ? {4'b0, wdata[11:8]} : data0[15:8];
	assign data0_next[23:16] = 8'h0;
	assign data0_next[31:24] = 8'h0;

//==================== TDR0 =======================
	assign data1_next[7:0] = (wr_en && (addr == 12'h004) && wstrb[0]) ? wdata[7:0] : counter_64bit[7:0];
	assign data1_next[15:8] = (wr_en && (addr == 12'h004) && wstrb[1]) ? wdata[15:8] :  counter_64bit[15:8];
	assign data1_next[23:16] =(wr_en && (addr == 12'h004) && wstrb[2]) ? wdata[23:16] :  counter_64bit[23:16];
	assign data1_next[31:24] =(wr_en && (addr == 12'h004) && wstrb[3]) ? wdata[31:24] :  counter_64bit[31:24];

//==================== TDR1 =======================
	assign data2_next[7:0] = (wr_en && (addr == 12'h008) && wstrb[0]) ? wdata[7:0] : counter_64bit[39:32];
	assign data2_next[15:8] = (wr_en && (addr == 12'h008) && wstrb[1]) ? wdata[15:8] :  counter_64bit[47:40];
	assign data2_next[23:16] =(wr_en && (addr == 12'h008) && wstrb[2]) ? wdata[23:16] :  counter_64bit[55:48];
	assign data2_next[31:24] =(wr_en && (addr == 12'h008) && wstrb[3]) ? wdata[31:24] :  counter_64bit[63:56];

//==================== TCMP0 =======================
	assign data3_next[7:0] = (wr_en && (addr == 12'h00C) && wstrb[0]) ? wdata[7:0] : data3[7:0];
	assign data3_next[15:8] = (wr_en && (addr == 12'h00C) && wstrb[1]) ? wdata[15:8] : data3[15:8];
	assign data3_next[23:16] = (wr_en && (addr == 12'h00C) && wstrb[2]) ? wdata[23:16] : data3[23:16];
	assign data3_next[31:24] = (wr_en && (addr == 12'h00C) && wstrb[3]) ? wdata[31:24] : data3[31:24];


//==================== TCMP1 =======================
	assign data4_next[7:0] = (wr_en && (addr == 12'h010) && wstrb[0]) ? wdata[7:0] : data4[7:0];
	assign data4_next[15:8] = (wr_en && (addr == 12'h010) && wstrb[1]) ? wdata[15:8] : data4[15:8];
	assign data4_next[23:16] = (wr_en && (addr == 12'h010) && wstrb[2]) ? wdata[23:16] : data4[23:16];
	assign data4_next[31:24] = (wr_en && (addr == 12'h010) && wstrb[3]) ? wdata[31:24] : data4[31:24];


//==================== TIER =======================
	assign data5_next[7:0] = (wr_en && (addr == 12'h014) && wstrb[0]) ? {7'h0, wdata[0]} : data5[7:0];
	assign data5_next[15:8] = 8'h0;
	assign data5_next[23:16] = 8'h0;
	assign data5_next[31:24] = 8'h0;


//==================== THCSR =======================
	assign data7_next[7:0] = (wr_en && (addr == 12'h01C) && wstrb[0]) ?
  {6'h0, thcr_halt_reg_pre ,wdata[0]} : {data7[7:2],thcr_halt_reg_pre,data7[0]};
	assign data7_next[15:8] = 8'h0;
	assign data7_next[23:16] = 8'h0;
	assign data7_next[31:24] = 8'h0;




// ==================================================
// PREADY CONTROL - DELAY 1 CYCLE
// ==================================================

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			pready_w <= 1'b0;
	
		end else begin
			pready_w <= (wr_en || rd_en) ? 1'b1 : 1'b0;
		end
	end


// ==================================================
// REGISTER UPDATE
// ==================================================

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			data0 <= {20'h0, 4'b0001, 8'b0};
			data1 <= 32'h0000_0000;
			data2 <= 32'h0000_0000;
			data3 <= 32'hFFFF_FFFF;
			data4 <= 32'hFFFF_FFFF;
			data5 <= 32'h0000_0000;
			data6 <= 32'h0000_0000;
			data7 <= 32'h0000_0000;
			data0_d <= 32'h0000_0000;

		end else begin
			data0_d <= data0;

			if(!data0[0] && data0_d[0]) begin
				data1 <= 32'h0000_0000;
				data2 <= 32'h0000_0000;		
			end else begin
				data0 <= pslverr_w ? data0 : data0_next;
				data1 <= data1_next;
				data2 <= data2_next;
				data3 <= data3_next;
				data4 <= data4_next;
				data5 <= data5_next;
				data7 <= data7_next;
			end
		end
	end


// ==================================================
// READ LOGIC
// ==================================================

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			rdata <= 32'h0000_0000;
		end else begin
			rdata <= 32'h0000_0000;

		if (rd_en) begin
			case(addr)
				12'h000 : rdata <= data0;
				12'h004 : rdata <= data1;
				12'h008 : rdata <= data2;
				12'h00C : rdata <= data3;
				12'h010 : rdata <= data4;
				12'h014 : rdata <= data5;
				12'h018 : rdata <= data6;
				12'h01C : rdata <= data7;
				default : rdata <= 32'h0;
			endcase
			end
		end
	end



// ==================================================
// TIMER CLOCK DIVIDER LOGIC
// ==================================================

	assign cnt_rst = !data0[0] || !data0[1] || (int_cnt == ((1 << data0[11:8]) - 1));

	assign count_en_pre = thcr_halt_reg ? 1'b0 : (
		(!data0[1] && data0[0]) || (data0[11:8] != 0 && data0[1] && data0[0] && (int_cnt == ((1 << data0[11:8]) - 1))) 
		|| (data0[11:8] == 0 && data0[1] && data0[0]));

	assign int_cnt_0 = cnt_rst ? 8'h0 : int_cnt +1;
	assign int_cnt_pre = thcr_halt_reg ? int_cnt : int_cnt_0;

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			int_cnt <= 8'h0;
			count_en <= 1'b0;
		end else begin
			int_cnt <= int_cnt_pre;
			count_en <= count_en_pre;
		end
	end

	assign counter_64bit = count_en ? {data2, data1} +1 : {data2, data1}; 

// ==================================================
// COMPARE LOGIC && INTERRUPT OUTPUT
// ==================================================

	always@(*) begin
		pslverr_w = pslverr;
		timer_int = data5[0] && data6[0];
	end

	assign tri_condition = (data3 == data1) && (data4 == data2);


// ==================================================
// INTERRUPT STATUS REGISTER (data6[0])
// ==================================================
	always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data6[0] <= 1'b0;
	end else begin
		if(tri_condition) begin
			data6[0] <= 1'b1;
		end else if(wr_en && (addr == 12'h018) && wstrb[0] && wdata[0] && data6[0]) begin
			data6[0] <= 1'b0;
			end
		end
	end



// ==================================================
// HALT CONTROL IN DEBUG MODE
// ==================================================
	assign thcr_halt_reg_pre = debug_mode && data7_next[0];

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			thcr_halt_reg <= 1'b0;
		end else begin
			thcr_halt_reg <= thcr_halt_reg_pre;
		end
	end

endmodule

````
