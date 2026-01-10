
	````verilog
	task run_test;
		reg [31:0] read_data;
		begin
			$display("====== Check_register_write_read =====");
			
			$display("------- TCR Check -------");
			test_bench.apb_write_register(12'h000, 32'h0000_0000, 4'b1111);
			test_bench.apb_read_register(12'h000, read_data);
			test_bench.check_result(32'h0000_0000, read_data);

			test_bench.apb_write_register(12'h000, 32'hffff_ffff, 4'b1111);
			test_bench.apb_read_register(12'h000, read_data);
			test_bench.check_result(32'h0000_0000,read_data);

			test_bench.apb_write_register(12'h000, 32'h5555_5555, 4'b1111);
			test_bench.apb_read_register(12'h000, read_data);
			test_bench.check_result(32'h0000_0501,read_data);

			test_bench.apb_write_register(12'h000, 32'hAAAA_AAAA, 4'b1111);
			test_bench.apb_read_register(12'h000, read_data);
			test_bench.check_result(32'h0000_0501,read_data);

			test_bench.apb_write_register(12'h000, 32'h0000_0500, 4'b1111);
			test_bench.apb_read_register(12'h000, read_data);
			test_bench.check_result(32'h00000_0500,read_data);



			$display("------- TDR0 -------");
			test_bench.apb_write_register(12'h004, 32'h0000_0000, 4'b1111);
			test_bench.apb_read_register(12'h004, read_data);
			test_bench.check_result(32'h0000_0000, read_data);

			test_bench.apb_write_register(12'h004, 32'hffff_ffff, 4'b1111);
			test_bench.apb_read_register(12'h004, read_data);
			test_bench.check_result(32'hffff_ffff,read_data);

			test_bench.apb_write_register(12'h004, 32'h5555_5555, 4'b1111);
			test_bench.apb_read_register(12'h004, read_data);
			test_bench.check_result(32'h5555_5555,read_data);

			test_bench.apb_write_register(12'h004, 32'hAAAA_AAAA, 4'b1111);
			test_bench.apb_read_register(12'h004, read_data);
			test_bench.check_result(32'hAAAA_AAAA, read_data);

			test_bench.apb_write_register(12'h004, 32'h3333_3333, 4'b1111);
			test_bench.apb_read_register(12'h004, read_data);
			test_bench.check_result(32'h3333_3333,read_data);


			$display("------- TDR1 -------");
			test_bench.apb_write_register(12'h008, 32'h0000_0000, 4'b1111);
			test_bench.apb_read_register(12'h008, read_data);
			test_bench.check_result(32'h0000_0000, read_data);

			test_bench.apb_write_register(12'h008, 32'hffff_ffff, 4'b1111);
			test_bench.apb_read_register(12'h008, read_data);
			test_bench.check_result(32'hffff_ffff,read_data);

			test_bench.apb_write_register(12'h008, 32'h5555_5555, 4'b1111);
			test_bench.apb_read_register(12'h008, read_data);
			test_bench.check_result(32'h5555_5555,read_data);

			test_bench.apb_write_register(12'h008, 32'hAAAA_AAAA, 4'b1111);
			test_bench.apb_read_register(12'h008, read_data);
			test_bench.check_result(32'hAAAA_AAAA, read_data);

			test_bench.apb_write_register(12'h008, 32'h3333_3333, 4'b1111);
			test_bench.apb_read_register(12'h008, read_data);
			test_bench.check_result(32'h3333_3333,read_data);

			$display("------- TCMP0 -------");
			test_bench.apb_write_register(12'h00C, 32'h0000_0000, 4'b1111);
			test_bench.apb_read_register(12'h00C, read_data);
			test_bench.check_result(32'h0000_0000, read_data);

			test_bench.apb_write_register(12'h00C, 32'hffff_ffff, 4'b1111);
			test_bench.apb_read_register(12'h00C, read_data);
			test_bench.check_result(32'hffff_ffff,read_data);

			test_bench.apb_write_register(12'h00C, 32'h5555_5555, 4'b1111);
			test_bench.apb_read_register(12'h00C, read_data);
			test_bench.check_result(32'h5555_5555,read_data);

			test_bench.apb_write_register(12'h00C, 32'hAAAA_AAAA, 4'b1111);
			test_bench.apb_read_register(12'h00C, read_data);
			test_bench.check_result(32'hAAAA_AAAA, read_data);

			test_bench.apb_write_register(12'h00C, 32'h3333_333a, 4'b1111);
			test_bench.apb_read_register(12'h00C, read_data);
			test_bench.check_result(32'h3333_333a,read_data);

			$display("------- TCMP1 -------");
			test_bench.apb_write_register(12'h010, 32'h0000_0000, 4'b1111);
			test_bench.apb_read_register(12'h010, read_data);
			test_bench.check_result(32'h0000_0000, read_data);

			test_bench.apb_write_register(12'h010, 32'hffff_ffff, 4'b1111);
			test_bench.apb_read_register(12'h010, read_data);
			test_bench.check_result(32'hffff_ffff,read_data);

			test_bench.apb_write_register(12'h010, 32'h5555_5555, 4'b1111);
			test_bench.apb_read_register(12'h010, read_data);
			test_bench.check_result(32'h5555_5555,read_data);

			test_bench.apb_write_register(12'h010, 32'hAAAA_AAAA, 4'b1111);
			test_bench.apb_read_register(12'h010, read_data);
			test_bench.check_result(32'hAAAA_AAAA, read_data);

			test_bench.apb_write_register(12'h010, 32'h3333_3333, 4'b1111);
			test_bench.apb_read_register(12'h010, read_data);
			test_bench.check_result(32'h3333_3333,read_data);

			$display("------- TIER -------");
			test_bench.apb_write_register(12'h014, 32'h0000_0000, 4'b1111);
			test_bench.apb_read_register(12'h014, read_data);
			test_bench.check_result(32'h0000_0000, read_data);

			test_bench.apb_write_register(12'h014, 32'hffff_ffff, 4'b1111);
			test_bench.apb_read_register(12'h014, read_data);
			test_bench.check_result(32'h0000_0001,read_data);

			test_bench.apb_write_register(12'h014, 32'h5555_5555, 4'b1111);
			test_bench.apb_read_register(12'h014, read_data);
			test_bench.check_result(32'h0000_0001,read_data);

			test_bench.apb_write_register(12'h014, 32'hAAAA_AAAA, 4'b1111);
			test_bench.apb_read_register(12'h014, read_data);
			test_bench.check_result(32'h0000_0000,read_data);

			test_bench.apb_write_register(12'h014, 32'h3333_3333, 4'b1111);
			test_bench.apb_read_register(12'h014, read_data);
			test_bench.check_result(32'h0000_0001,read_data);


			$display("------- TISR -------");
			test_bench.apb_write_register(12'h018, 32'h0000_0000, 4'b1111);
			test_bench.apb_read_register(12'h018, read_data);
			test_bench.check_result(32'h0000_0000, read_data);

			test_bench.apb_write_register(12'h018, 32'hffff_ffff, 4'b1111);
			test_bench.apb_read_register(12'h018, read_data);
			test_bench.check_result(32'h0000_0000,read_data);

			test_bench.apb_write_register(12'h018, 32'h5555_5555, 4'b1111);
			test_bench.apb_read_register(12'h018, read_data);
			test_bench.check_result(32'h0000_0000,read_data);

			test_bench.apb_write_register(12'h018, 32'hAAAA_AAAA, 4'b1111);
			test_bench.apb_read_register(12'h018, read_data);
			test_bench.check_result(32'h0000_0000,read_data);

			test_bench.apb_write_register(12'h018, 32'h3333_3333, 4'b1111);
			test_bench.apb_read_register(12'h018, read_data);
			test_bench.check_result(32'h0000_0000,read_data);


			$display("------- THCSR -------");
			test_bench.apb_write_register(12'h01C, 32'h0000_0000, 4'b1111);
			test_bench.apb_read_register(12'h01C, read_data);
			test_bench.check_result(32'h0000_0000, read_data);

			test_bench.apb_write_register(12'h01C, 32'hffff_ffff, 4'b1111);
			test_bench.apb_read_register(12'h01C, read_data);
			test_bench.check_result(32'h0000_0001,read_data);

			test_bench.apb_write_register(12'h01C, 32'h5555_5555, 4'b1111);
			test_bench.apb_read_register(12'h01C, read_data);
			test_bench.check_result(32'h0000_0001,read_data);

			test_bench.apb_write_register(12'h01C, 32'hAAAA_AAAA, 4'b1111);
			test_bench.apb_read_register(12'h01C, read_data);
			test_bench.check_result(32'h0000_0000,read_data);

			test_bench.apb_write_register(12'h01C, 32'h3333_3333, 4'b1111);
			test_bench.apb_read_register(12'h01C, read_data);
			test_bench.check_result(32'h0000_0001,read_data);

			#100;
			test_bench.sys_rst_n = 1'b0;
       	 		#100;
       	 		@(posedge test_bench.sys_clk);
        		#1;
        		test_bench.sys_rst_n = 1'b1;

			$display(" Check_register_write_read completed\n");
		end
	endtask

