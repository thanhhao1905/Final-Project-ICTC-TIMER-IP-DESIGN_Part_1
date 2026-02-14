task run_test();
reg [31:0]  read_data;
begin
	$display("=========================================");
	$display("=== Check APB Multi-access  ====");
	$display("=========================================");	
        
        
	//multiple APB access 
	$display("multiple APB access");
	$display("write TDR0 & write TDR1");
	@(posedge test_bench.sys_clk);
	#1;
     
	test_bench.tim_psel = 1;
	test_bench.tim_pwrite = 1;
	test_bench.tim_penable = 0;
	test_bench.tim_paddr = 12'h004;
	test_bench.tim_pwdata = 32'h3333_3333;
	test_bench.tim_pstrb = 4'hffff;

	@(posedge test_bench.sys_clk);
	#1;
	test_bench.tim_penable = 1 ; 

	wait( tim_pready == 1); 
	@(posedge test_bench.sys_clk);
	#1;

	test_bench.tim_psel = 1;
	test_bench.tim_pwrite = 1;
	test_bench.tim_penable = 0;
	test_bench.tim_paddr = 12'h008;
	test_bench.tim_pwdata = 32'h5555_5555;
	test_bench.tim_pstrb = 4'hffff;


	@(posedge test_bench.sys_clk);
	#1;
	test_bench.tim_penable = 1 ; 

	wait( tim_pready == 1); 
	@(posedge test_bench.sys_clk);
	#1;

	test_bench.tim_psel = 0;
	test_bench.tim_pwrite = 0;
	test_bench.tim_penable = 0;
	test_bench.tim_paddr = 12'h000;
	test_bench.tim_pwdata = 32'h0;
	test_bench.tim_pstrb = 4'h0;


	//normal read
	$display("normal read");
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'h3333_3333, read_data);

	test_bench.apb_read_register(12'h008, read_data);
	test_bench.check_result(32'h5555_5555, read_data);
        
	//normal write
	$display("normal write");
	test_bench.apb_write_register(12'h004, 32'h1111_1111, 4'b1111);
	test_bench.apb_write_register(12'h008, 32'h2222_2222, 4'b1111);
       
	//multiple read
	$display("multiple read");
	@(posedge test_bench.sys_clk);
	#1;
	test_bench.tim_psel = 1;
	test_bench.tim_paddr = 12'h004;
	@(posedge test_bench.sys_clk);
	#1;
	test_bench.tim_penable = 1 ; 

	wait( tim_pready == 1); 
	#1;
	read_data = tim_prdata;
	test_bench.check_result(32'h1111_1111,read_data);
        
	@(posedge test_bench.sys_clk);
	#1;
	test_bench.tim_penable = 0 ; 
	test_bench.tim_paddr = 12'h008;
	@(posedge test_bench.sys_clk);
	#1;
	test_bench.tim_penable = 1 ; 
	wait( tim_pready == 1); 
	#1;
	read_data = tim_prdata;
	test_bench.check_result(32'h2222_2222,read_data);

	@(posedge test_bench.sys_clk);
	#1;
	test_bench.tim_psel = 0;
	test_bench.tim_penable = 0 ; 
	test_bench.tim_paddr = 12'h000;
        
        
    end


endtask
