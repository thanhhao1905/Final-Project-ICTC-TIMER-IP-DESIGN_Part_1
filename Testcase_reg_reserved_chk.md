````verilog
task run_test();
   
    reg [31:0] read_data;   
    begin
  	    
            $display("====================================");	
  	    $display("==== Check Reserved =====");
  	    $display("====================================");	

					
			$display("------- Random Address -------");
			test_bench.apb_write_register(12'h015, 32'h0000_1234, 4'b1111);
			test_bench.apb_read_register(12'h015, read_data);
			test_bench.check_result(32'h0000_0000, read_data);

			test_bench.apb_write_register(12'haaa, 32'hffff_ffff, 4'b1111);
			test_bench.apb_read_register(12'haaa, read_data);
			test_bench.check_result(32'h0000_0000,read_data);

			test_bench.apb_write_register(12'h567, 32'h5555_5555, 4'b1111);
			test_bench.apb_read_register(12'h567, read_data);
			test_bench.check_result(32'h0000_0000,read_data);

			test_bench.apb_write_register(12'h111, 32'hAAAA_AAAA, 4'b1111);
			test_bench.apb_read_register(12'h111, read_data);
			test_bench.check_result(32'h0000_0000,read_data);

			test_bench.apb_write_register(12'hfff, 32'h0000_0500, 4'b1111);
			test_bench.apb_read_register(12'hfff, read_data);
			test_bench.check_result(32'h00000_0000,read_data);


			#100;
			test_bench.sys_rst_n = 1'b0;
       	 		#100;
       	 		@(posedge test_bench.sys_clk);
        		#1;
        		sys_rst_n = 1'b1;

			$display(" Check Reserved completed\n");


    end
endtask
