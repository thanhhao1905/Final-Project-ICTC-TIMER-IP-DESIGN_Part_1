````verilog
task run_test();
   	reg [31:0] read_data;
    begin
  	    $display("=====================================");	
  	    $display("=== Check : APB Un-aligned ===");
  	    $display("=====================================");	
        
        //normal APB 
        test_bench.apb_write_register(12'h004, 32'hAAAA_AAAA, 4'b1111);
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'hAAAA_AAAA, read_data);


        //un-aligned
        $display("\n=========== un-aligned ==========");
	$display("write & read at address: 12'h005");
        test_bench.apb_write_register(12'h005, 32'hAAAA_AAAA, 4'b1111);
	test_bench.apb_read_register(12'h005, read_data);
	test_bench.check_result(32'h0000_0000, read_data);
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'hAAAA_AAAA, read_data);


        //un-aligned
	$display("write & read at address: 12'h006");
        test_bench.apb_write_register(12'h006, 32'h3333_5555, 4'b1111);
	test_bench.apb_read_register(12'h006, read_data);
	test_bench.check_result(32'h0000_0000, read_data);
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'hAAAA_AAAA, read_data);

        //un-aligned
	$display("write & read at address: 12'h007");
        test_bench.apb_write_register(12'h007, 32'h2222_2222, 4'b1111);
	test_bench.apb_read_register(12'h007, read_data);
	test_bench.check_result(32'h0000_0000, read_data);
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'hAAAA_AAAA, read_data);

    end


endtask
