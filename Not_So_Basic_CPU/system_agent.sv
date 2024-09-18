module system_agent(
// clock input
input clk,


// Memory interface stuff.
output cs,
output we,
output [15:0] addr,
inout [31:0] data,

// IP interfacing stuff.
output [31:0] ip_dat [3:0],			// 32 bit data field.
input [15:0] ip_addr [3:0],		// 16 bit address field.
input [5:0]  ip_req_trans [3:0],	// 1 bit to request transaction, 1 bit to set read / write, 4 bits for priority.
output [3:0] ip_trans_id [3:0]	// 4 bit transaction ID which is returned to the IP block.

);

// Wires & regs for queue shift register.
reg [56:0] tx_queue_inp;
wire [56:0] tx_queue_oup [7:0];
reg tx_inp_en;
reg [7:0] tx_queue_clear_reg;

// Shift register to hold the queued transactions.
sa_tx_queue_regs queue(clk, tx_inp_en, tx_queue_clear_reg, tx_queue_inp, tx_queue_oup);
/*
	0:3 - TX IP owner
	4:7 - TX ID
	8		- TX type
	9:40	- Data
	41:56 - Address
*/

reg [3:0] next_tx_id;

initial begin
	next_tx_id = 0;
end



/* 		Find the highest priority request. 		*/




reg [1:0] highest_pri_tran;


/* 		combinatorial logic for choosing which IP to queue up for transaction. 		*/
always @ (*) begin


highest_pri_tran = ((ip_req_trans[0][5:2] > ip_req_trans[1][5:2]) ? ((ip_req_trans[2][5:2] > ip_req_trans[0][5:2]) ? ((ip_req_trans[3][5:2] > ip_req_trans[2][5:2]) ? 3 : 2) : 0): 1);

	// If there is at least 1 pending request, grab the most important one from the priority decoder & prep it for input to queue.
	if (ip_req_trans[0][0] | ip_req_trans[1][0] | ip_req_trans[2][0] | ip_req_trans[3][0] == 1) begin
		tx_queue_inp[3:0] <= highest_pri_tran;
		tx_queue_inp[7:4] <= next_tx_id;
		tx_queue_inp[8] <= ip_req_trans[highest_pri_tran][1];
		tx_queue_inp[40:9] <= ip_dat[highest_pri_tran];
		tx_queue_inp[56:41] <= ip_addr[highest_pri_tran];
		tx_inp_en <= 1;
	end
	else begin
		tx_inp_en <= 0;
	end
end


/* 		Clocked logic for SA		 */
always @(posedge clk) begin

	// If we have an IP wanting to shift stuff in then
	if (tx_inp_en == 1)	next_tx_id <= next_tx_id + 1;
end

/*
	I need a queue that holds both data & address
	need to impliment some form of checking the queue when new requests come in
	
	1. A new IO request gets queued.
	2. Once at front of queue it gets executed.
	3. Once done the requesting IP is notified via a signal.
	
	
	Only allow one IP to submit a request per clock.
	Each IP will submit a priority along with their request to help judge priority.
	Each IP will be informed on the next cycle as to if request has been submitted.
	If the request isnt submitted then the IP should repeat the request next cycle.
	
	Each request consists of an address, data (if write), transaction type, priority.
	The transaction is assigned an ID which is relayed back to the IP block.
	Reply consists of a tx_complete signal & transaction ID along with data (if read op).
	
	Once the request is completed the IP is notified and MUST be ready to recieve the result on the next clock.
*/


endmodule