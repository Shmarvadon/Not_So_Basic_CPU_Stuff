module memory(
input clk,
input [15:0] addr,
inout [31:0] data,
input we,
input cs);

reg[31:0] mem_arr [65536:0];

assign data = !we & cs ? mem_arr[addr] : 'hz;

always @(posedge clk) begin
	
	if (we & cs) mem_arr[addr] <= data;
	
end
endmodule
