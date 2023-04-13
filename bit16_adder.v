module top(clk, rst, signature, finish);
	input clk, rst;
	output wire finish;
	output wire [16:0] signature;
	wire LFSR_load;
	wire MISR_load;
	wire [15:0] adder_in;
	wire [16:0] adder_out;
	
controller ctrl(.clk(clk), .rst(rst), .LFSR_load(LFSR_load), .MISR_load(MISR_load), .finish(finish));

LFSR lfsr(.clk(clk), .rst(rst), .load(LFSR_load), .data_in(1'b1), .data_out(adder_in));
	
Adder adder(.A(adder_in), .B({adder_in[0],adder_in[15:1]}), .sum(adder_out[15:0]), .CI(1'b0), .CO(adder_out[16]));

MISR misr(.clk(clk), .rst(rst), .load(MISR_load), .data_in(adder_out), .data_out(signature));
 
endmodule

module Adder (A, B, sum, CI, CO);
	input [15:0] A, B;
	output [15:0] sum;
	input CI;
	output CO;
	reg [15:0] sum;
	reg CO;
	always @(A or B) begin
		{CO,sum[15:0]} = A + B;
	end
endmodule

module LFSR(clk, rst, load, data_in, data_out);
	input clk, rst, load, data_in;
	output reg [15:0] data_out;
	always @(posedge clk or posedge rst)
		if(rst)begin
			data_out <= 15'd0;
		end
		else begin
			data_out[0] <= (load)? data_in : data_out[1] ^ data_out[5];
			data_out[1] <= data_out[0] ^ data_out[4];
			data_out[2] <= data_out[1];
			data_out[3] <= data_out[2];
			data_out[4] <= data_out[3];
			data_out[5] <= data_out[4];
			data_out[6] <= data_out[5];
			data_out[15] <= data_out[6];
			data_out[14] <= data_out[4];
			data_out[13] <= data_out[3];
			data_out[12] <= data_out[2];
			data_out[11] <= data_out[5];
			data_out[10] <= data_out[0];
			data_out[9]  <= data_out[1];
			data_out[8]  <= data_out[4];
			data_out[7]  <= data_out[3];
		end
		
		 

endmodule

module MISR(clk, rst, load, data_in, data_out);

	input clk, rst, load;
	input [16:0] data_in;
	output reg [16:0] data_out;

	always @(posedge clk or posedge rst)
		if(rst)begin
			data_out <= 17'd0;
		end
	
		else if(~load)begin
			data_out <= 17'd2; // initial value = 2
		end
		else begin
			data_out[0] <= data_in[0] ^ data_out[16];
			data_out[1] <= data_in[1] ^ data_out[0];
			data_out[2] <= data_in[2] ^ data_out[1];
			data_out[3] <= data_in[3] ^ data_out[2];
			data_out[4] <= data_in[4] ^ data_out[3];
			data_out[5] <= data_in[5] ^ data_out[4];
			data_out[6] <= data_in[6] ^ data_out[5];
			data_out[7] <= data_in[7] ^ data_out[6];
			data_out[8] <= data_in[8] ^ data_out[7];
			data_out[9] <= data_in[9] ^ data_out[8];
			data_out[10] <= data_in[10] ^ data_out[9];
			data_out[11] <= data_in[11] ^ data_out[10];
			data_out[12] <= data_in[12] ^ data_out[11];
			data_out[13] <= data_in[13] ^ data_out[12];
			data_out[14] <= data_in[14] ^ data_out[13] ^ data_out[16];
			data_out[15] <= data_in[15] ^ data_out[14];
			data_out[16] <= data_in[16] ^ data_out[15];
		end
endmodule	

module controller(clk, rst, LFSR_load, MISR_load, finish);
	parameter START = 3'd0;
	parameter L_LOAD = 3'd1;
	parameter TEST = 3'd2;
	parameter LAST_M = 3'd3;
	parameter FINISH = 3'd4;

	input clk, rst;
	output wire LFSR_load, MISR_load, finish;

	reg [2:0] current_state;
	reg [2:0] next_state;
	reg [4:0] count;

	assign LFSR_load = (current_state == L_LOAD);
	assign MISR_load = (current_state == TEST) | (current_state == LAST_M);
	assign finish = (current_state == FINISH);

	always @(posedge clk or posedge rst)
		if(rst)
			count <= 6'd0;
		else
			count <= count + 6'd1;

	always @(posedge clk or posedge rst)
		if(rst)
			current_state <= START;
		else
			current_state <= next_state;

	always @(*)
		case(current_state)
			START: next_state = L_LOAD;
			L_LOAD: next_state = (count == 6'd7) ? TEST : L_LOAD;
			TEST: next_state = (count == 6'd31) ? LAST_M : TEST;
			LAST_M: next_state = FINISH;
			FINISH: next_state = FINISH;
			default: next_state = START;
		endcase
endmodule
		
	