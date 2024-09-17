module sa_tx_queue_regs(
input clk,
input we,
input [7:0] cr,
input [56:0] dat_in,
output wire [56:0] dat_out [7:0]
);


// The registers & their connections.
reg [56:0] regs [7:0];
assign dat_out = regs;

// Tracking which register is currently in use.
reg [7:0] used_regs;

initial begin
	used_regs = 0;
end

integer i;
always @ (posedge clk) begin

	// If write enable is set.
	if (we) begin
		// Naive priority encoder.
		case (used_regs)
		8'b0xxxxxxx: regs[0] <= dat_in;
		8'b10xxxxxx: regs[1] <= dat_in;
		8'b110xxxxx: regs[2] <= dat_in;
		8'b1110xxxx: regs[3] <= dat_in;
		8'b11110xxx: regs[4] <= dat_in;
		8'b111110xx: regs[5] <= dat_in;
		8'b1111110x: regs[6] <= dat_in;
		8'b11111110: regs[7] <= dat_in;
		endcase
	end
	
	// If cr isnt 0, then we set the cleared flag on the register we want to empty.
	if (cr != 0) begin
		used_regs = (used_regs & cr) ^ cr;
	end
end

endmodule