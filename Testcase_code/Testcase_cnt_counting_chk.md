
````verilog
task run_test();
	reg [31:0] read_data;
	integer i;
    begin
  	    
            $display("===============================================================");	
  	    $display("====== Check counter couting  =================");
  	    $display("===============================================================");


	$display("===== Set counter_64bit =====");
     	test_bench.apb_write_register(12'h004, 32'hffff_fff0, 4'b1111);
     	test_bench.apb_write_register(12'h008, 32'hffff_ffff, 4'b1111);

	$display("===== Check timer_en =1, timer_en = 0 =====");
	test_bench.apb_write_register(12'h000, 32'h0000_0001, 4'b1111);
	  #1
    	$display(" cnt value: 64'h%h",test_bench.dut.register.counter_64bit);
    	$display("===== Wait finish 15 cycles =====");
	repeat(14)@(posedge test_bench.sys_clk); 
  	 #1
    	if(test_bench.dut.register.counter_64bit == 64'hffff_ffff_ffff_ffff) 
	 $display("PASS: Counter reach 64'hffff_ffff_ffff_ffff");
	 else 
	 $display("Fail: Counter not reach 64'hffff_ffff_ffff_ffff");


	$display("===== Clear TCR =====");
	test_bench.apb_write_register(12'h000, 32'h0000_0000, 4'b1111);
	#1;



	$display("===== Set counter_64bit =====");
     	test_bench.apb_write_register(12'h004, 32'hffff_fff0, 4'b1111);
     	test_bench.apb_write_register(12'h008, 32'hffff_ffff, 4'b1111);

	$display("===== Check timer_en =1, timer_en = 1, div_val = 0 =====");
	test_bench.apb_write_register(12'h000, 32'h0000_0003, 4'b1111);
	 #1
    	$display(" cnt value: 64'h%h",test_bench.dut.register.counter_64bit);
    	$display("===== Wait finish 15 cycles =====");
	repeat(14)@(posedge test_bench.sys_clk); 
  	 #1
    	if(test_bench.dut.register.counter_64bit == 64'hffff_ffff_ffff_ffff) 
	 $display("PASS: Counter reach 64'hffff_ffff_ffff_ffff");
	 else 
	 $display("Fail: Counter not reach 64'hffff_ffff_ffff_ffff");
	
	$display("===== Clear TCR =====");
	test_bench.apb_write_register(12'h000, 32'h0000_0002, 4'b1111);
	#1;



	for (i =1 ;i <9; i =i+1) begin
	$display("===== Set counter_64bit =====");
     	test_bench.apb_write_register(12'h004, 32'hffff_fff0, 4'b1111);
     	test_bench.apb_write_register(12'h008, 32'hffff_ffff, 4'b1111);


	$display("===== Check timer_en =1, timer_en = 1, div_val = %d =====", i);
	test_bench.apb_write_register_div_val(12'h000, 32'h0000_0003, 4'b1111, i);
	#1;
    	$display(" cnt value: 64'h%h",test_bench.dut.register.counter_64bit);
    	$display("===== Wait finish 15 cycles =====");
	repeat(((1<<i))*15-1)@(posedge test_bench.sys_clk); 
  	 #1
    	if(test_bench.dut.register.counter_64bit == 64'hffff_ffff_ffff_ffff) 
	 $display("PASS: Counter reach 64'hffff_ffff_ffff_ffff");
	 else 
	 $display("Fail: Counter not reach 64'hffff_ffff_ffff_ffff");
	
	$display("===== Clear TCR =====");
	test_bench.apb_write_register_div_val(12'h000, 32'h0000_0002, 4'b1111, i);
	#10;
	end

	for (i =1 ;i <9; i =i+1) begin
	$display("===== Set counter_64bit =====");
     	test_bench.apb_write_register(12'h004, 32'hffff_ffff, 4'b1111);
     	test_bench.apb_write_register(12'h008, 32'hffff_ffff, 4'b1111);


	$display("===== Check timer_en =1, timer_en = 1, div_val = %d =====", i);
	test_bench.apb_write_register_div_val(12'h000, 32'h0000_0003, 4'b1111, i);
	#1;
    	$display(" cnt value: 64'h%h",test_bench.dut.register.counter_64bit);
    	$display("===== Wait finish max cycles =====");
	repeat(2**i -1)@(posedge test_bench.sys_clk); 
  	 #1
    	if(test_bench.dut.register.counter_64bit == 64'h0000_0000_0000_0000) 
	 $display("PASS: Counter reach 64'h0000_0000_0000_0000");
	 else begin
	 $display("Fail: Counter not reach 64'h0000_0000_0000_0000");
	 test_bench.err = test_bench.err +1;
	end

	$display("===== Clear TCR =====");
	test_bench.apb_write_register_div_val(12'h000, 32'h0000_0002, 4'b1111, i);
	#10;

	end
	
     end
endtask
