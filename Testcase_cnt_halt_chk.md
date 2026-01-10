````verilog
task run_test();
    reg [31:0] read_data;
    reg [63:0] data_before, data_after;

    begin

    	#100;
	test_bench.sys_rst_n = 1'b0;
       	#100;
       	@(posedge test_bench.sys_clk);
        #1;
        test_bench.sys_rst_n = 1'b1;


  	    
           $display("====================================");	
  	    $display("====== Check: Cnt Halt Check ====");
  	    $display("====================================");	

        $display("\n====== No Debug mode ==========");
	$display("\n====== Check hatl_req = 1, hatl_status = 0 ==========");
       
        test_bench.dbg_mode = 0;
	test_bench.apb_write_register(12'h01C, 32'h0000_0001, 4'b1111);
	test_bench.apb_write_register(12'h000, 32'h0000_0001, 4'b1111);


	if(test_bench.dut.register.data7[0] == 1 )begin
		$display("--------------------------------------------------------");
		$display(" PASSED: halt_req is asserted. halt_req= %d",test_bench.dut.register.data7[0]);
		$display("--------------------------------------------------------");
	end else begin
		$display("--------------------------------------------------------");
		$display(" FAIL: halt_req does not asserted. halt_req= %d",test_bench.dut.register.data7[0]);
		$display("--------------------------------------------------------");
		test_bench.err = test_bench.err + 1;
        end

//	Check hatl_status = 0 
	test_bench.apb_read_register(12'h01C, read_data);
	test_bench.check_result(32'h0000_0001, read_data);

	if(test_bench.dut.register.thcr_halt_reg_pre == 0 )begin
		$display("--------------------------------------------------------");
		$display(" PASSED: halt_status does not asserted. halt_status= %d",test_bench.dut.register.thcr_halt_reg_pre );
		$display("--------------------------------------------------------");
	end else begin
		$display("--------------------------------------------------------");
		$display(" FAIL: halt_status is asserted. halt_status= %d",test_bench.dut.register.thcr_halt_reg_pre );
		$display("--------------------------------------------------------");
		test_bench.err = test_bench.err + 1;
        end


	$display("\n======= Check counter while non hatl ======");

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

	test_bench.apb_write_register(12'h000, 32'h0000_0000, 4'b1111);
	test_bench.apb_write_register(12'h01C, 32'h0000_0000, 4'b1111);



// Test hatl mode
 	$display("\n====== Assert Debug mode ==========");
	$display("\n====== Check hatl_req = 1, hatl_status = 1 ==========");
       
       	test_bench.apb_write_register(12'h000, 32'h0000_0303, 4'b1111);
	repeat(24) @(posedge test_bench.sys_clk);
     
     	test_bench.dbg_mode = 1;
	test_bench.apb_write_register(12'h01C, 32'h0000_0001, 4'b1111);
	
	if(test_bench.dut.register.data7[0] == 1 )begin
		$display("--------------------------------------------------------");
		$display(" PASSED: halt_req is asserted. halt_req= %d",test_bench.dut.register.data7[0]);
		$display("--------------------------------------------------------");
	end else begin
		$display("--------------------------------------------------------");
		$display(" FAIL: halt_req does not asserted. halt_req= %d",test_bench.dut.register.data7[0]);
		$display("--------------------------------------------------------");
		test_bench.err = test_bench.err + 1;
        end

//	Check hatl_status = 1 
	test_bench.apb_read_register(12'h01C, read_data);
	test_bench.check_result(32'h0000_0003, read_data);

	if(test_bench.dut.register.thcr_halt_reg_pre  == 1 )begin
		$display("--------------------------------------------------------");
		$display(" PASSED: halt_status is asserted. halt_status= %d",test_bench.dut.register.thcr_halt_reg_pre );
		$display("--------------------------------------------------------");
	end else begin
		$display("--------------------------------------------------------");
		$display(" FAIL: halt_status does not asserted. halt_status= %d",test_bench.dut.register.thcr_halt_reg_pre );
		$display("--------------------------------------------------------");
		test_bench.err = test_bench.err + 1;
        end


	$display("\n======= Check counter while hatl ======");

	repeat(25) @(posedge test_bench.sys_clk);
	#1;
	data_before = test_bench.dut.register.counter_64bit;
	repeat(20) @(posedge test_bench.sys_clk);
	#1;
	data_after = test_bench.dut.register.counter_64bit;
	if(data_after == data_before ) begin
		$display("Pass, before = 32'h%h, after = 32'h%h", data_before, data_after);
	end else begin
		$display("Error, before = 32'h%h, after = 32'h%h", data_before, data_after);
		test_bench.err = test_bench.err +1;
	end

	$display("\n======= Check counter after clear hatl ======");
	test_bench.apb_write_register(12'h01C, 32'h0000_0000, 4'b1111);
	test_bench.dbg_mode = 0;


	repeat((2**3)-1) @(posedge test_bench.sys_clk);

	data_after = test_bench.dut.register.counter_64bit;
	if(data_after == data_before +1 ) begin
		$display("Pass, before = 32'h%h, after = 32'h%h, counter correct", data_before, data_after);
	end else begin
		$display("Error, before = 32'h%h, after = 32'h%h counter wrong", data_before, data_after);
		test_bench.err = test_bench.err +1;
	end
	@(posedge test_bench.sys_clk);
	
	test_bench.apb_write_register(12'h000, 32'h0000_0302, 4'b1111);
	test_bench.apb_write_register(12'h000, 32'h0000_0303, 4'b1111);

	repeat(25) @(posedge test_bench.sys_clk);
	$display("\n======= Check change value TRC while hatl ======");
	test_bench.dbg_mode = 1;
	test_bench.apb_write_register(12'h01C, 32'h0000_0001, 4'b1111);
	test_bench.apb_write_register(12'h000, 32'h0000_0302, 4'b1111);
	test_bench.apb_write_register(12'h000, 32'h0000_0002, 4'b1111);
	test_bench.apb_write_register(12'h000, 32'h0000_0103, 4'b1111);
	
	#100;
	test_bench.sys_rst_n = 1'b0;
       	#100;
       	@(posedge test_bench.sys_clk);
        #1;
        test_bench.sys_rst_n = 1'b1;
    end
endtask
