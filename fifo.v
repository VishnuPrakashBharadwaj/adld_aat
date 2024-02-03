// FIFO module with a depth of 16 words, each 8-bit wide

module fifo(
	input clk,
	input reset,
	input [7:0] data_in,
	input write,
	input read,
	output reg [7:0] data_out,
	output full,
	output empty
);
	// Registers and wires
	reg [3:0] wptr, rptr;
	reg [7:0] mem [0:15];
	
	always @ (posedge clk or negedge reset) begin
		if(!reset) begin
			wptr <= 4'b0;
			rptr <= 4'b0;
		end else begin
			
			if(write && (~full)) begin
				mem[wptr] <= data_in;
				wptr <= wptr + 1'b1;
			end 

			if(read && (~empty)) begin
				data_out <= mem[rptr];
				rptr <= rptr + 1'b1;
			end
		end
	end
	
	// Continuos assignments
	assign full = ((wptr + 1'b1) == rptr);
	assign empty = (wptr == rptr);
endmodule

