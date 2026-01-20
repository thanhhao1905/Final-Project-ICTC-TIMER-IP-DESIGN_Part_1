````verilog
task run_test();
    begin
		$display("======== check_apb_pready ==========");

	#100;
	test_bench.sys_rst_n = 1'b0;
       	#100;
       	@(posedge test_bench.sys_clk);
        #1;
        test_bench.sys_rst_n = 1'b1;


		#10;
		test_bench.check_pready(12'h000, 32'h0000_0003, 4'b1111, 1'b0, 1'b1);

		#10;
		test_bench.check_pready(12'h004, 32'h0000_0003, 4'b1111, 1'b1, 1'b1);

		#10;
		test_bench.check_pready(12'h008, 32'h0000_0005, 4'b1111, 1'b0, 1'b1);

		#10;
		test_bench.check_pready(12'h00C, 32'h0000_0002, 4'b1111, 1'b1, 1'b1);

		#10;
		test_bench.check_pready(12'h010, 32'h5A5A_5A5A, 4'b1111, 1'b0, 1'b1);


		#20;
		$display("Test pready completed\n");

	#100;
	test_bench.sys_rst_n = 1'b0;
       	#100;
       	@(posedge test_bench.sys_clk);
        #1;
        test_bench.sys_rst_n = 1'b1;
    end


    endtask


