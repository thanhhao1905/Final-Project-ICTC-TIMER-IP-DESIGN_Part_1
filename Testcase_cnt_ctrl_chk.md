````verilog
task run_test();
 
	begin
	$display("====== Check_cnt_ctr_chk =====");

	#10;
	$display("\n ------- div_val = 0 ,div_en = 0 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0001, 4'b1111, 4'h0);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0000, 4'b1111);



	#10;
	$display("\n ------- div_val = 0 ,div_en = 1 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0003, 4'b1111, 4'h0);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0002, 4'b1111);


	#10;
	$display("\n ------- div_val = 1 ,div_en = 1 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0103, 4'b1111, 4'h1);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0102, 4'b1111);


	#10;
	$display("\n ------- div_val = 2 ,div_en = 1 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0203, 4'b1111, 4'h2);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0202, 4'b1111);


	#10;
	$display("\n ------- div_val = 3 ,div_en = 1 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0303, 4'b1111, 4'h3);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0302, 4'b1111);


	#10;
	$display("\n ------- div_val = 4 ,div_en = 1 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0403, 4'b1111, 4'h4);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0402, 4'b1111);


	#10;
	$display("\n ------- div_val = 5 ,div_en = 1 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0503, 4'b1111, 4'h5);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0502, 4'b1111);


	#10;
	$display("\n ------- div_val = 6 ,div_en = 1 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0603, 4'b1111, 4'h6);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0602, 4'b1111);


	#10;
	$display("\n ------- div_val = 7 ,div_en = 1 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0703, 4'b1111, 4'h7);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0702, 4'b1111);


	#10;
	$display("\n ------- div_val = 8 ,div_en = 1 -------");
	test_bench.check_timer_count(12'h000, 32'h0000_0803, 4'b1111, 4'h8);
	#10;
	test_bench.apb_write_register(12'h000, 32'h000_0802, 4'b1111);


	
	#100;
	test_bench.sys_rst_n = 1'b0;
       	#100;
       	@(posedge test_bench.sys_clk);
        #1;
        sys_rst_n = 1'b1;

	$display(" Check_cnt_ctr_chk completed\n");
		end
	endtask

