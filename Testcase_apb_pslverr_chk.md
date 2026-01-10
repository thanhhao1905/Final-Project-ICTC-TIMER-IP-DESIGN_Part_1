````verilog
task run_test();
   	reg [31:0] read_data;
	integer i;
    begin
  	    $display("=====================================");	
  	    $display("=== Check Pslverr =======");
  	    $display("=====================================");	

	#100;
	test_bench.sys_rst_n = 1'b0;
       	#100;
       	@(posedge test_bench.sys_clk);
        #1;
        test_bench.sys_rst_n = 1'b1;

	$display("\n==== Write div_val >= 9, timer_en = 0, div_en =0 =============="); 
        
        
	for(i = 9; i <16; i = i+1) begin
	$display("\n========== Check at div_val =%d ===========",i); 
	test_bench.check_pslverr(12'h000, 32'h0000_0000, 4'b1111,i);
	
	end
	
	test_bench.apb_write_register(12'h000, 32'h0000_0102, 4'b1111);
	test_bench.apb_write_register(12'h000, 32'h0000_0103, 4'b1111);


	$display("\n==== Write div_en = 1 when timer_en = 1,div_val = 1 =============="); 

	test_bench.check_pslverr(12'h000, 32'h0000_0903, 4'b1111,9);
	test_bench.apb_write_register(12'h000, 32'h0000_0102, 4'b1111);


// div_val <= 8;
	test_bench.apb_write_register(12'h000, 32'h0000_0003, 4'b1111);
	$display("\n==== Write div_val <= 8 ,div_en = 1 when timer_en = 1=============="); 


	for(i = 1; i <9; i = i+1) begin
	$display("\n========== Check at div_val =%d ===========",i); 

	test_bench.check_pslverr(12'h000, 32'h0000_0003, 4'b1111,i);
	
	end

// div_val >= 9;
	test_bench.apb_write_register(12'h000, 32'h0000_0002, 4'b1111);

	$display("\n==== Write div_val >= 9, timer_en = 1, div_en =1 =============="); 

	for(i = 9; i <16; i = i+1) begin
	$display("\n========== Check at div_val =%d ===========",i); 

	test_bench.check_pslverr(12'h000, 32'h0000_0003, 4'b1111,i);
	
	end

    end


endtask
