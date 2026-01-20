````verilog
task run_test();
   	reg [31:0] read_data;
	reg [63:0] data_before, data_after;
		

    begin
  	    
            $display("====================================");	
  	    $display("====== Interrupt check ===");
  	    $display("====================================");	
        
	#100;
	test_bench.sys_rst_n = 1'b0;
       	#100;
       	@(posedge test_bench.sys_clk);
        #1;
        test_bench.sys_rst_n = 1'b1;

	$display("\n===== Set value TDR0, TDR1, TIER ,TRC ====="); 
        test_bench.apb_write_register(12'h004, 32'hffff_ffff, 4'b1111);
       	test_bench.apb_write_register(12'h008, 32'hffff_ffff, 4'b1111);
      	test_bench.apb_write_register(12'h014, 32'h0000_0001, 4'b1111);
        test_bench.apb_write_register(12'h000, 32'h0000_0001, 4'b1111);

        repeat(5) @(posedge test_bench.sys_clk);
	#1;

        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------");
			$display(" PASSED: interrupt is asserted. tim_int = %d",test_bench.tim_int );
			$display("--------------------------------------------------------");

        end else begin
			$display("--------------------------------------------------------");
			$display(" FAILED: interrupt does not asserted. tim_int = %d",test_bench.tim_int);
			$display("--------------------------------------------------------");
            test_bench.err = test_bench.err + 1;
        end
        
	repeat(5) @(posedge test_bench.sys_clk);
	#1;

	$display("\n======= Clear Interrupt Enable ======");
	test_bench.apb_write_register(12'h014, 32'h0000_0000, 4'b1111);


        $display("\n======= Check interrupt status is 1 ======");
        test_bench.apb_read_register(12'h018, read_data);
	test_bench.check_result(32'h0000_0001,read_data);

	if (test_bench.dut.register.data6 == 1) begin
		$display("--------------------------------------------------------");
		$display(" PASSED: interrupt status is asserted. interrupt trigger condition = %d",test_bench.dut.register.data6 );
		$display("--------------------------------------------------------");
	end else begin
		$display("--------------------------------------------------------");
		$display(" FAIL: interrupt status does not asserted. interrupt trigger condition = %d",test_bench.dut.register.data6 );
		$display("--------------------------------------------------------");
		test_bench.err = test_bench.err + 1;
	end

	$display("\n======= Check counter while interrupt ======");

	repeat(5) @(posedge test_bench.sys_clk);
	#1;
	data_before = test_bench.dut.register.counter_64bit;
	@(posedge test_bench.sys_clk);
	#1;
	data_after = test_bench.dut.register.counter_64bit;
	if(data_after == data_before +1) begin
		$display("Pass, before = 32'h%h, after = 32'h%h", data_before, data_after);
	end else begin
		$display("Error, before = 32'h%h, after = 32'h%h", data_before, data_after);
		test_bench.err = test_bench.err +1;
	end

	$display("\n======= Clear interrupt status  ======");

	test_bench.apb_write_register(12'h018, 32'h0000_0001, 4'b1111);
        test_bench.apb_read_register(12'h018, read_data);
	test_bench.check_result(32'h0000_0000,read_data);

	if (test_bench.dut.register.data6 == 0) begin
		$display("--------------------------------------------------------");
		$display(" PASSED: interrupt status is cleared. interrupt trigger condition = %d",test_bench.dut.register.data6 );
		$display("--------------------------------------------------------");
	end else begin
		$display("--------------------------------------------------------");
		$display(" Fail: interrupt status does not cleared. interrupt trigger condition = %d",test_bench.dut.register.data6 );
		$display("--------------------------------------------------------");
		test_bench.err = test_bench.err + 1;
	end
	end
endtask
