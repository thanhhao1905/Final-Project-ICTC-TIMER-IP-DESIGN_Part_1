````verilog
task run_test();
    reg [31:0]  read_data;
    begin
  	    
        $display("====================================");	
  	$display("====== Test One Hot Check ====");
  	$display("====================================");	
        
        
        test_bench.apb_write_register(12'h000, 32'h1111_1813, 4'hf);
    	test_bench.apb_write_register(12'h004, 32'h3333_3333, 4'hf);
    	test_bench.apb_write_register(12'h008, 32'hAAAA_AAAA, 4'hf);
    	test_bench.apb_write_register(12'h00C, 32'hffff_ffff, 4'hf);
    	test_bench.apb_write_register(12'h010, 32'h5555_5555, 4'hf);
    	test_bench.apb_write_register(12'h014, 32'h0101_1010, 4'hf);
    	test_bench.apb_write_register(12'h018, 32'h0505_0505, 4'hf);
    	test_bench.apb_write_register(12'h01C, 32'hffff_ffff, 4'hf);
        
        test_bench.apb_read_register(12'h000, read_data);
	test_bench.check_result(32'h0000_0803,read_data);

	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'h3333_3333,read_data);

	test_bench.apb_read_register(12'h008, read_data);
	test_bench.check_result(32'hAAAA_AAAA, read_data);

	test_bench.apb_read_register(12'h00C, read_data);
	test_bench.check_result(32'hffff_ffff,read_data);

	test_bench.apb_read_register(12'h010, read_data);
	test_bench.check_result(32'h5555_5555,read_data);

	test_bench.apb_read_register(12'h014, read_data);
	test_bench.check_result(32'h0000_0000,read_data);

	test_bench.apb_read_register(12'h018, read_data);
	test_bench.check_result(32'h0000_0000, read_data);

	test_bench.apb_read_register(12'h01C, read_data);
	test_bench.check_result(32'h0000_0001,read_data);

   	#100;
	test_bench.sys_rst_n = 1'b0;
       	#100;
       	@(posedge test_bench.sys_clk);
        #1;
        sys_rst_n = 1'b1;

        $display(" Test One Hot Check completed\n");

    end
endtask
