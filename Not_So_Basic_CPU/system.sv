module system(input clk);

wire [15:0] mem_addr;
wire [31:0] mem_dat;
wire mem_we;
wire mem_cs;

memory mem(clk, mem_addr, mem_dat, mem_we, mem_cs);

wire [31:0] ip_dat [3:0];
wire [15:0] ip_addr [3:0];
wire [5:0] ip_req_trans [3:0];
wire [3:0] ip_trans_id [3:0];

system_agent sa(clk, mem_cs, mem_we, mem_addr, mem_dat, ip_dat, ip_addr, ip_req_trans, ip_trans_id);


initial begin
	ip_req_trans[0] = 6'b100100;
end
endmodule