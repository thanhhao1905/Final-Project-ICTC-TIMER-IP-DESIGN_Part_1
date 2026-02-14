module test_bench;
	
	reg sys_clk;
	reg sys_rst_n;

	reg tim_psel;
	reg tim_pwrite;
	reg tim_penable;
	reg [11:0] tim_paddr;
	reg [31:0] tim_pwdata;
	reg [3:0] tim_pstrb;
	reg dbg_mode;
	integer err;

	wire [31:0] tim_prdata;
	wire tim_pready;
	wire tim_pslverr;
	wire tim_int;

	timer_top dut (
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.tim_psel(tim_psel),
		.tim_pwrite(tim_pwrite),
		.tim_penable(tim_penable),
		.tim_paddr(tim_paddr),
		.tim_pwdata(tim_pwdata),
		.tim_pstrb(tim_pstrb),
		.dbg_mode(dbg_mode),
		.tim_prdata(tim_prdata),
		.tim_pready(tim_pready),
		.tim_pslverr(tim_pslverr),
		.tim_int(tim_int)
	);

	`include "run_test.v"
  	
   	 initial begin 
  	   sys_clk = 0;
  	   forever #25 sys_clk = ~sys_clk;
  	 end


	initial begin
		
		$display("\n");
		$display("========================================");
		$display("	Timer Top Testbench	");
		$display("========================================");

		initialize();
		err = 0;
		#100;
        	run_test();
		#100;
		if(err == 0 )
       			 $display("\nTest_result PASSED");
   		 else 
       			 $display("\nTest_result FAILED");
		#100;
		$finish;
	end

	task initialize;
		begin	
					
			sys_rst_n = 0;
			#30;
			sys_rst_n = 1;
			#10; 

			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			tim_pwdata = 32'h0;
			tim_pstrb = 4'h0;
			dbg_mode = 0;

			#20;
		end
	endtask

	
	task apb_write_register;	

		input [11:0] address;
		input [31:0] data;
		input [3:0] strobe;
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = 1;
			tim_pwrite = 1;
			tim_penable = 0;
			tim_paddr = address;
			tim_pwdata = data;
			tim_pstrb = strobe;

			@(posedge sys_clk);
			#1;
			tim_penable = 1;

			wait(tim_pready == 1);
			@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			tim_pwdata = 32'h0;
			tim_pstrb = 4'h0;
			#10;
		end
	endtask



	task apb_write_register_div_val;	

		input [11:0] address;
		input [31:0] data;
		input [3:0] strobe;
		input [3:0] i;
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = 1;
			tim_pwrite = 1;
			tim_penable = 0;
			tim_paddr = address;
			tim_pwdata = {20'h0,i,6'h0,data[1:0]};
			tim_pstrb = strobe;

			@(posedge sys_clk);
			#1;
			tim_penable = 1;

			wait(tim_pready == 1);
			@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			tim_pwdata = 32'h0;
			tim_pstrb = 4'h0;
			#10;
		end
	endtask


	task apb_write_register_err;	

		input [11:0] address;
		input [31:0] data;
		input [3:0] strobe;
		input penable;
		input psel;
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = psel;
			tim_pwrite = 1;
			tim_penable = 0;
			tim_paddr = address;
			tim_pwdata = data;
			tim_pstrb = strobe;

			@(posedge sys_clk);
			#1;
			tim_penable = penable;
			$display("write data : 32'h%h with wrong protocol",data); 


		//	wait(tim_pready == 1);
			repeat(5)@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			tim_pwdata = 32'h0;
			tim_pstrb = 4'h0;
			#10;
		end
	endtask


	task apb_read_register;
		input [11:0] address;
		output [31:0] read_data;
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = 1;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = address;

			@(posedge sys_clk);
			#1;
			tim_penable = 1;

			wait (tim_pready == 1);
			#1;
			read_data = tim_prdata;

			@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			#10;
		end
	endtask

	task apb_read_register_err;
		input [11:0] address;
		output [31:0] read_data;
		input penable;
		input psel;
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = psel;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = address;

			@(posedge sys_clk);
			#1;
			tim_penable = penable;
			$display("read data with wrong protocol"); 


		//	wait (tim_pready == 1);
			#1;
			read_data = tim_prdata;

			repeat(5)@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			#10;
		end
	endtask


	task check_result;
		input [31:0] expected;
		input [31:0] actual;
		begin
			if(expected == actual) begin
				$display("pass: expected = 32'h%h, actual = 32'h%h",expected, actual);
			end else begin
				$display("error: expected = 32'h%h, actual = 32'h%h",expected, actual);
				err = err +1;
			end
		end
	endtask

	task check_signal;
		input expected;
		input actual;
		begin
		if(expected == actual) begin
				$display("pass: expected = %h, actual = %h",expected, actual);
			end else begin
				$display("error: expected = %h, actual = %h",expected, actual);
				err = err +1;
			end
		end
	endtask

	task check_pslverr;	

		input [11:0] address;
		input [31:0] data;
		input [3:0] strobe;
		input [3:0] i;
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = 1;
			tim_pwrite = 1;
			tim_penable = 0;
			tim_paddr = address;
			tim_pwdata = {20'h0,i,6'h0,data[1],data[0]};
			tim_pstrb = strobe;

			@(posedge sys_clk);
			#1;
			tim_penable = 1;
			#1;
			if(tim_pslverr == 1 )begin
		$display("--------------------------------------------------------");
		$display(" PASSED: tim_pslverr is asserted. tim_pslverr = %d",tim_pslverr);
		$display("--------------------------------------------------------");
	end else begin
		$display("--------------------------------------------------------");
		$display(" FAIL: tim_pslverr does not asserted. tim_pslverr = %d",tim_pslverr );
		$display("--------------------------------------------------------");
		err = err + 1;
        end

			wait(tim_pready == 1);
			@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			tim_pwdata = 32'h0;
			tim_pstrb = 4'h0;
			#10;
		end
	endtask

	
	task check_pready;	

		input [11:0] address;
		input [31:0] data;
		input [3:0] strobe;
		input write;
		input signal;
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = 1;
			tim_pwrite = write;
			tim_penable = 0;
			tim_paddr = address;
			tim_pwdata = data;
			tim_pstrb = strobe;

			@(posedge sys_clk);
			#1;
			tim_penable = 1;

			@(posedge sys_clk);
			#1;
			check_signal(signal ,tim_pready);


			@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			tim_pwdata = 32'h0;
			tim_pstrb = 4'h0;
			#10;
		end
	endtask



	task check_timer_count;	

		input [11:0] address;
		input [31:0] data;
		input [3:0] strobe;
		input [3:0] n;

		reg [63:0] data_before, data_after;
		
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = 1;
			tim_pwrite = 1;
			tim_penable = 0;
			tim_paddr = address;
			tim_pwdata = data;
			tim_pstrb = strobe;

			@(posedge sys_clk);
			#1;
			tim_penable = 1;

			wait(tim_pready == 1);

			#1;
			repeat(2**n)@(posedge sys_clk);
			#1;
			data_before = dut.register.counter_64bit;

			@(posedge sys_clk);
			#1;
			repeat(2**n)@(posedge sys_clk);
			data_after = dut.register.counter_64bit;
			#1;

			if(data_after == data_before +1) begin
			$display("Pass, before = 32'h%h, after = 32'h%h", data_before, data_after);
			end else begin
			$display("Error, before = 32'h%h, after = 32'h%h", data_before, data_after);
			err = err +1;
			end

			#1;
			data_before = data_after; 
			repeat(2**n)@(posedge sys_clk);
			data_after = dut.register.counter_64bit;
			#1;
			if(data_after == data_before +1) begin
			$display("Pass, before = 32'h%h, after = 32'h%h", data_before, data_after);
			end else begin
			$display("Error, before = 32'h%h, after = 32'h%h", data_before, data_after);
			end


			@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			tim_pwdata = 32'h0;
			tim_pstrb = 4'h0;
			data_after = 0;
			data_before = 0;
			#10;
		end
	endtask


	task check_int;	

		input [11:0] address;
		input [31:0] data;
		input [3:0] strobe;
		input signal;
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = 1;
			tim_pwrite = 1;
			tim_penable = 0;
			tim_paddr = address;
			tim_pwdata = data;
			tim_pstrb = strobe;

			@(posedge sys_clk);
			#1;
			tim_penable = 1;

			wait(tim_pready == 1);
			repeat(16)@(posedge sys_clk);
			#1;

			check_signal(signal ,tim_pready);
			check_signal(signal, dut.register.data6[0]);


			@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			tim_pwdata = 32'h0;
			tim_pstrb = 4'h0;
			#10;
		end
	endtask

	task check_halt_reg;	

		input [11:0] address;
		input [31:0] data;
		input [3:0] strobe;
		input signal;
		input [31:0] read_data;
		begin
			@(posedge sys_clk);
			#1;
			tim_psel = 1;
			tim_pwrite = 1;
			tim_penable = 0;
			tim_paddr = address;
			tim_pwdata = data;
			tim_pstrb = strobe;

			@(posedge sys_clk);
			#1;
			tim_penable = 1;

			@(posedge sys_clk);
			#1;
			if(read_data +1 == dut.register.data1) begin
			$display("Pass, before = %h, after = %h", read_data, dut.register.data1);
			end else begin
			$display("Error, before =%h, after =%h", read_data, dut.register.data1 );
			end
			#1;

			check_signal(signal ,dut.register.data7[0]);
			check_signal(signal, dut.register.data7[1]);


			@(posedge sys_clk);
			#1;
			tim_psel = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_paddr = 12'h0;
			tim_pwdata = 32'h0;
			tim_pstrb = 4'h0;
			#10;
		end
	endtask
endmodule


