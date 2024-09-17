`timescale 1ns / 100ps

module testbench;

reg clk;

initial begin
	clk = 0;
end

always begin
	#10 clk <= ~clk;
end

system sys(clk);

endmodule