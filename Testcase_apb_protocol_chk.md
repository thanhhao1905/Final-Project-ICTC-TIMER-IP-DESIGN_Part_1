````verilog
task run_test();
    	reg [31:0] read_data;
	begin
  	    err = 0;
            $display("=====================================");	
  	    $display("=== Check APB Protocol ====");
  	    $display("=====================================");	
        
        //normal APB 
	$display("\nNormal APB "); 
	test_bench.apb_write_register(12'h004, 32'hffff_ffff, 4'b1111);
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'hffff_ffff,read_data);

	//write wrong protocol
	$display("\nPenable does not assert & Psel assert"); 
	test_bench.apb_write_register_err(12'h004, 32'h5555_5555, 4'b1111, 0,1);
	//read wrong protocol 
	test_bench.apb_read_register_err(12'h004, read_data,0,1);
	test_bench.check_result(32'h0000_0000,read_data);

	//read right protocol 
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'hffff_ffff,read_data);


	//write wrong protocol
	$display("\nPsel does not assert & Penable assert"); 
	test_bench.apb_write_register_err(12'h004, 32'h3333_3333, 4'b1111, 1,0);
	//read wrong protocol
	test_bench.apb_read_register_err(12'h004, read_data,1,0);
	test_bench.check_result(32'h0000_0000,read_data);

	//read right protocol 
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'hffff_ffff,read_data);


        end


endtask
