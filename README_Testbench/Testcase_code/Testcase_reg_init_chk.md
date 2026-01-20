````verilog
task run_test();
    reg [31:0]  read_data;
    begin
  	    
		$display("====================================");	
  	    $display("==== reg_init_chk ===");
  	    $display("====================================");	
        
		$display("------- TCR -------"); 
		test_bench.apb_read_register(12'h000, read_data);
		test_bench.check_result(32'h0000_0100, read_data);


		$display("------- TDR0 -------");
		test_bench.apb_read_register(12'h004, read_data);
		test_bench.check_result(32'h0000_0000, read_data);
   
            	$display("------- TDR1 -------");
		test_bench.apb_read_register(12'h008, read_data);
		test_bench.check_result(32'h0000_0000, read_data);   

            	$display("------- TCMP0 -------");
		test_bench.apb_read_register(12'h00C, read_data);
		test_bench.check_result(32'hffff_ffff, read_data);

            	$display("------- TCMP1 -------");
		test_bench.apb_read_register(12'h010, read_data);
		test_bench.check_result(32'hffff_ffff, read_data);

          	$display("------- TIER -------");
		test_bench.apb_read_register(12'h014, read_data);
		test_bench.check_result(32'h0000_0000, read_data);

		$display("------- TISR -------");
		test_bench.apb_read_register(12'h018, read_data);
		test_bench.check_result(32'h0000_0000, read_data);

		$display("------- THCSR -------");
		test_bench.apb_read_register(12'h01C, read_data);
		test_bench.check_result(32'h0000_0000, read_data);

   		#100;
		test_bench.sys_rst_n = 1'b0;
       	 	#100;
       	 	@(posedge test_bench.sys_clk);
        	#1;
        	sys_rst_n = 1'b1;

                $display(" reg_init_chk completed\n");

     end       
    endtask


