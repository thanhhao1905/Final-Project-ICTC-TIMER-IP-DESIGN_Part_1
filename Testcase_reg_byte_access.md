````verilog
task run_test();
   reg [31:0] read_data;
    begin
  	    
        $display("====================================");	
  	    $display("=== check byte access ===");
  	    $display("====================================");	
        
    $display("\n------- TCR Check -------");
	$display("========== Access Byte 0 ==========");
    test_bench.apb_write_register(12'h000, 32'h0000_0802, 4'b0001);
	test_bench.apb_read_register(12'h000, read_data);
	test_bench.check_result(32'h0000_0102, read_data);


	$display("========== Access Byte 1 ==========");
    test_bench.apb_write_register(12'h000, 32'h0000_0503, 4'b0010);
	test_bench.apb_read_register(12'h000, read_data);
	test_bench.check_result(32'h0000_0502, read_data);


	$display("========== Access Byte 2 ==========");
    test_bench.apb_write_register(12'h000, 32'h0000_0503, 4'b0100);
	test_bench.apb_read_register(12'h000, read_data);
	test_bench.check_result(32'h0000_0502, read_data);


    $display("========== Access Byte 3 ==========");
    test_bench.apb_write_register(12'h000, 32'h0000_0803, 4'b1000);
	test_bench.apb_read_register(12'h000, read_data);
	test_bench.check_result(32'h0000_0502, read_data);
  

 	$display("\n------- TDR0 Check -------");
	$display("========== Access Byte 0 ==========");
    test_bench.apb_write_register(12'h004, 32'h0000_0802, 4'b0001);
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'h0000_0002, read_data);


	$display("========== Access Byte 1 ==========");
    test_bench.apb_write_register(12'h004, 32'h0000_0503, 4'b0010);
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'h0000_0502, read_data);


	$display("========== Access Byte 2 ==========");
    test_bench.apb_write_register(12'h004, 32'hffff_ffff, 4'b0100);
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'h00ff_0502, read_data);


    $display("========== Access Byte 3 ==========");
    test_bench.apb_write_register(12'h004, 32'haaaa_0803, 4'b1000);
	test_bench.apb_read_register(12'h004, read_data);
	test_bench.check_result(32'haaff_0502, read_data);



	$display("\n------- TDR1 Check -------");
	$display("========== Access Byte 0 ==========");
    test_bench.apb_write_register(12'h008, 32'h0000_0802, 4'b0001);
	test_bench.apb_read_register(12'h008, read_data);
	test_bench.check_result(32'h0000_0002, read_data);


	$display("========== Access Byte 1 ==========");
    test_bench.apb_write_register(12'h008, 32'h0000_0503, 4'b0010);
	test_bench.apb_read_register(12'h008, read_data);
	test_bench.check_result(32'h0000_0502, read_data);


	$display("========== Access Byte 2 ==========");
    test_bench.apb_write_register(12'h008, 32'hffff_ffff, 4'b0100);
	test_bench.apb_read_register(12'h008, read_data);
	test_bench.check_result(32'h00ff_0502, read_data);


    $display("========== Access Byte 3 ==========");
    test_bench.apb_write_register(12'h008, 32'haaaa_0803, 4'b1000);
	test_bench.apb_read_register(12'h008, read_data);
	test_bench.check_result(32'haaff_0502, read_data);



	$display("\n------- TCMP0 Check -------");
	$display("========== Access Byte 0 ==========");
    test_bench.apb_write_register(12'h00C, 32'h1111_1111, 4'b0001);
	test_bench.apb_read_register(12'h00C, read_data);
	test_bench.check_result(32'hffff_ff11, read_data);


	$display("========== Access Byte 1 ==========");
    test_bench.apb_write_register(12'h00C, 32'hffff_ffff, 4'b0010);
	test_bench.apb_read_register(12'h00C, read_data);
	test_bench.check_result(32'hffff_ff11, read_data);


	$display("========== Access Byte 2 ==========");
    test_bench.apb_write_register(12'h00C, 32'haaaa_aaaa, 4'b0100);
	test_bench.apb_read_register(12'h00C, read_data);
	test_bench.check_result(32'hffaa_ff11, read_data);


    $display("========== Access Byte 3 ==========");
    test_bench.apb_write_register(12'h00C, 32'h0505_0505, 4'b1000);
	test_bench.apb_read_register(12'h00C, read_data);
	test_bench.check_result(32'h05aa_ff11, read_data);


	
	$display("\n------- TCMP1 Check -------");
	$display("========== Access Byte 0 ==========");
    test_bench.apb_write_register(12'h010, 32'h1111_1111, 4'b0001);
	test_bench.apb_read_register(12'h010, read_data);
	test_bench.check_result(32'hffff_ff11, read_data);


	$display("========== Access Byte 1 ==========");
    test_bench.apb_write_register(12'h010, 32'hffff_ffff, 4'b0010);
	test_bench.apb_read_register(12'h010, read_data);
	test_bench.check_result(32'hffff_ff11, read_data);


	$display("========== Access Byte 2 ==========");
    test_bench.apb_write_register(12'h010, 32'haaaa_aaaa, 4'b0100);
	test_bench.apb_read_register(12'h010, read_data);
	test_bench.check_result(32'hffaa_ff11, read_data);


    $display("========== Access Byte 3 ==========");
    test_bench.apb_write_register(12'h010, 32'h0505_0505, 4'b1000);
	test_bench.apb_read_register(12'h010, read_data);
	test_bench.check_result(32'h05aa_ff11, read_data);



	$display("\n------- TIER Check -------");
	$display("========== Access Byte 0 ==========");
    test_bench.apb_write_register(12'h014, 32'h1111_1111, 4'b0001);
	test_bench.apb_read_register(12'h014, read_data);
	test_bench.check_result(32'h0000_0001, read_data);


	$display("========== Access Byte 1 ==========");
    test_bench.apb_write_register(12'h014, 32'hffff_ffff, 4'b0010);
	test_bench.apb_read_register(12'h014, read_data);
	test_bench.check_result(32'h0000_0001, read_data);


	$display("========== Access Byte 2 ==========");
    test_bench.apb_write_register(12'h014, 32'haaaa_aaaa, 4'b0100);
	test_bench.apb_read_register(12'h014, read_data);
	test_bench.check_result(32'h0000_0001, read_data);


    $display("========== Access Byte 3 ==========");
    test_bench.apb_write_register(12'h014, 32'h0505_0505, 4'b1000);
	test_bench.apb_read_register(12'h014, read_data);
	test_bench.check_result(32'h0000_0001, read_data);



	$display("\n------- TISR Check -------");
	$display("========== Access Byte 0 ==========");
    test_bench.apb_write_register(12'h018, 32'h1111_1111, 4'b0001);
	test_bench.apb_read_register(12'h018, read_data);
	test_bench.check_result(32'h0000_0000, read_data);


	$display("========== Access Byte 1 ==========");
    test_bench.apb_write_register(12'h018, 32'hffff_ffff, 4'b0010);
	test_bench.apb_read_register(12'h018, read_data);
	test_bench.check_result(32'h0000_0000, read_data);


	$display("========== Access Byte 2 ==========");
    test_bench.apb_write_register(12'h018, 32'haaaa_aaaa, 4'b0100);
	test_bench.apb_read_register(12'h018, read_data);
	test_bench.check_result(32'h0000_0000, read_data);


    $display("========== Access Byte 3 ==========");
    test_bench.apb_write_register(12'h018, 32'h0505_0505, 4'b1000);
	test_bench.apb_read_register(12'h018, read_data);
	test_bench.check_result(32'h0000_0000, read_data);


	$display("\n------- THCSR Check -------");
	$display("========== Access Byte 0 ==========");
    test_bench.apb_write_register(12'h01C, 32'h1111_1111, 4'b0001);
	test_bench.apb_read_register(12'h01C, read_data);
	test_bench.check_result(32'h0000_0001, read_data);


	$display("========== Access Byte 1 ==========");
    test_bench.apb_write_register(12'h01C, 32'hffff_ffff, 4'b0010);
	test_bench.apb_read_register(12'h01C, read_data);
	test_bench.check_result(32'h0000_0001, read_data);


	$display("========== Access Byte 2 ==========");
    test_bench.apb_write_register(12'h01C, 32'haaaa_aaaa, 4'b0100);
	test_bench.apb_read_register(12'h01C, read_data);
	test_bench.check_result(32'h0000_0001, read_data);


    $display("========== Access Byte 3 ==========");
    test_bench.apb_write_register(12'h01C, 32'h0505_0505, 4'b1000);
	test_bench.apb_read_register(12'h01C, read_data);
	test_bench.check_result(32'h0000_0001, read_data);


   	#100;
	test_bench.sys_rst_n = 1'b0;
    #100;
    @(posedge test_bench.sys_clk);
    #1;
    sys_rst_n = 1'b1;

    $display(" check byte access completed\n");
    end
endtask
