// =======================================================
//-- This is a 2-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_2_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_2" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [1:0] send_control;
	reg    [1-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 2-1)
			counter <= 0; else counter <= counter+1;
	reg [1-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 2 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[1:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_2_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_2" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [1:0] send_control /* synthesis syn_cpm_control=1 */;
	input [2-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [1-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[1:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_2_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_2" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [1:0] receive_control; //fastclk and counter
	reg    [1-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [1-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[1:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_2_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_2" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [1:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [1:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [2-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [1-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[1:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[1:1] <= receive_control[1:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_2_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_2" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 3-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_3_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_3" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [2:0] send_control;
	reg    [2-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 3-1)
			counter <= 0; else counter <= counter+1;
	reg [2-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 3 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[2:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_3_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_3" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [2:0] send_control /* synthesis syn_cpm_control=1 */;
	input [3-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [2-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[2:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_3_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_3" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [2:0] receive_control; //fastclk and counter
	reg    [2-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [2-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[2:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_3_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_3" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [2:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [2:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [3-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [2-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[2:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[2:1] <= receive_control[2:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_3_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_3" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 4-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_4_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_4" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [2:0] send_control;
	reg    [2-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 4-1)
			counter <= 0; else counter <= counter+1;
	reg [2-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 4 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[2:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_4_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_4" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [2:0] send_control /* synthesis syn_cpm_control=1 */;
	input [4-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [2-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[2:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_4_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_4" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [2:0] receive_control; //fastclk and counter
	reg    [2-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [2-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[2:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_4_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_4" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [2:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [2:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [4-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [2-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[2:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[2:1] <= receive_control[2:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_4_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_4" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 5-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_5_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_5" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [3:0] send_control;
	reg    [3-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 5-1)
			counter <= 0; else counter <= counter+1;
	reg [3-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 5 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[3:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_5_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_5" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [3:0] send_control /* synthesis syn_cpm_control=1 */;
	input [5-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [3-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[3:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_5_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_5" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [3:0] receive_control; //fastclk and counter
	reg    [3-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [3-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[3:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_5_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_5" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [3:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [3:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [5-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [3-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[3:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[3:1] <= receive_control[3:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_5_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_5" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 6-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_6_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_6" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [3:0] send_control;
	reg    [3-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 6-1)
			counter <= 0; else counter <= counter+1;
	reg [3-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 6 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[3:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_6_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_6" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [3:0] send_control /* synthesis syn_cpm_control=1 */;
	input [6-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [3-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[3:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_6_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_6" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [3:0] receive_control; //fastclk and counter
	reg    [3-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [3-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[3:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_6_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_6" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [3:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [3:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [6-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [3-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[3:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[3:1] <= receive_control[3:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_6_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_6" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 7-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_7_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_7" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [3:0] send_control;
	reg    [3-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 7-1)
			counter <= 0; else counter <= counter+1;
	reg [3-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 7 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[3:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_7_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_7" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [3:0] send_control /* synthesis syn_cpm_control=1 */;
	input [7-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [3-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[3:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_7_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_7" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [3:0] receive_control; //fastclk and counter
	reg    [3-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [3-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[3:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_7_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_7" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [3:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [3:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [7-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [3-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[3:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[3:1] <= receive_control[3:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_7_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_7" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 8-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_8_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_8" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [3:0] send_control;
	reg    [3-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 8-1)
			counter <= 0; else counter <= counter+1;
	reg [3-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 8 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[3:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_8_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_8" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [3:0] send_control /* synthesis syn_cpm_control=1 */;
	input [8-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [3-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[3:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_8_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_8" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [3:0] receive_control; //fastclk and counter
	reg    [3-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [3-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[3:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_8_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_8" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [3:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [3:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [8-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [3-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[3:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[3:1] <= receive_control[3:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_8_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_8" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 9-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_9_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_9" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [4:0] send_control;
	reg    [4-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 9-1)
			counter <= 0; else counter <= counter+1;
	reg [4-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 9 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[4:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_9_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_9" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [4:0] send_control /* synthesis syn_cpm_control=1 */;
	input [9-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [4-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[4:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_9_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_9" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [4:0] receive_control; //fastclk and counter
	reg    [4-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [4-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[4:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_9_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_9" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [4:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [4:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [9-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [4-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[4:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[4:1] <= receive_control[4:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_9_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_9" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 10-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_10_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_10" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [4:0] send_control;
	reg    [4-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 10-1)
			counter <= 0; else counter <= counter+1;
	reg [4-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 10 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[4:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_10_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_10" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [4:0] send_control /* synthesis syn_cpm_control=1 */;
	input [10-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [4-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[4:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_10_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_10" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [4:0] receive_control; //fastclk and counter
	reg    [4-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [4-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[4:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_10_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_10" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [4:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [4:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [10-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [4-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[4:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[4:1] <= receive_control[4:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_10_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_10" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 11-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_11_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_11" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [4:0] send_control;
	reg    [4-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 11-1)
			counter <= 0; else counter <= counter+1;
	reg [4-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 11 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[4:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_11_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_11" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [4:0] send_control /* synthesis syn_cpm_control=1 */;
	input [11-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [4-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[4:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_11_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_11" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [4:0] receive_control; //fastclk and counter
	reg    [4-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [4-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[4:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_11_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_11" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [4:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [4:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [11-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [4-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[4:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[4:1] <= receive_control[4:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_11_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_11" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 12-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_12_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_12" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [4:0] send_control;
	reg    [4-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 12-1)
			counter <= 0; else counter <= counter+1;
	reg [4-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 12 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[4:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_12_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_12" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [4:0] send_control /* synthesis syn_cpm_control=1 */;
	input [12-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [4-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[4:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_12_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_12" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [4:0] receive_control; //fastclk and counter
	reg    [4-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [4-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[4:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_12_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_12" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [4:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [4:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [12-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [4-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[4:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[4:1] <= receive_control[4:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_12_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_12" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 13-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_13_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_13" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [4:0] send_control;
	reg    [4-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 13-1)
			counter <= 0; else counter <= counter+1;
	reg [4-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 13 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[4:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_13_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_13" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [4:0] send_control /* synthesis syn_cpm_control=1 */;
	input [13-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [4-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[4:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_13_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_13" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [4:0] receive_control; //fastclk and counter
	reg    [4-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [4-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[4:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_13_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_13" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [4:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [4:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [13-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [4-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[4:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[4:1] <= receive_control[4:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_13_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_13" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 14-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_14_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_14" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [4:0] send_control;
	reg    [4-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 14-1)
			counter <= 0; else counter <= counter+1;
	reg [4-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 14 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[4:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_14_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_14" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [4:0] send_control /* synthesis syn_cpm_control=1 */;
	input [14-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [4-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[4:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_14_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_14" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [4:0] receive_control; //fastclk and counter
	reg    [4-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [4-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[4:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_14_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_14" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [4:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [4:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [14-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [4-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[4:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[4:1] <= receive_control[4:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_14_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_14" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 15-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_15_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_15" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [4:0] send_control;
	reg    [4-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 15-1)
			counter <= 0; else counter <= counter+1;
	reg [4-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 15 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[4:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_15_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_15" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [4:0] send_control /* synthesis syn_cpm_control=1 */;
	input [15-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [4-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[4:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_15_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_15" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [4:0] receive_control; //fastclk and counter
	reg    [4-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [4-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[4:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_15_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_15" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [4:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [4:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [15-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [4-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[4:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[4:1] <= receive_control[4:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_15_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_15" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 16-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_16_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_16" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [4:0] send_control;
	reg    [4-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 16-1)
			counter <= 0; else counter <= counter+1;
	reg [4-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 16 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[4:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_16_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_16" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [4:0] send_control /* synthesis syn_cpm_control=1 */;
	input [16-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [4-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[4:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_16_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_16" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [4:0] receive_control; //fastclk and counter
	reg    [4-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [4-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[4:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_16_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_16" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [4:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [4:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [16-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [4-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[4:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[4:1] <= receive_control[4:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_16_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_16" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 17-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_17_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_17" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [5:0] send_control;
	reg    [5-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 17-1)
			counter <= 0; else counter <= counter+1;
	reg [5-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 17 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[5:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_17_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_17" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [5:0] send_control /* synthesis syn_cpm_control=1 */;
	input [17-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [5-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[5:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_17_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_17" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [5:0] receive_control; //fastclk and counter
	reg    [5-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [5-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[5:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_17_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_17" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [5:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [5:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [17-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [5-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[5:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[5:1] <= receive_control[5:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_17_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_17" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 18-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_18_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_18" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [5:0] send_control;
	reg    [5-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 18-1)
			counter <= 0; else counter <= counter+1;
	reg [5-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 18 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[5:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_18_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_18" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [5:0] send_control /* synthesis syn_cpm_control=1 */;
	input [18-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [5-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[5:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_18_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_18" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [5:0] receive_control; //fastclk and counter
	reg    [5-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [5-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[5:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_18_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_18" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [5:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [5:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [18-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [5-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[5:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[5:1] <= receive_control[5:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_18_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_18" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 19-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_19_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_19" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [5:0] send_control;
	reg    [5-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 19-1)
			counter <= 0; else counter <= counter+1;
	reg [5-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 19 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[5:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_19_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_19" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [5:0] send_control /* synthesis syn_cpm_control=1 */;
	input [19-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [5-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[5:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_19_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_19" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [5:0] receive_control; //fastclk and counter
	reg    [5-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [5-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[5:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_19_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_19" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [5:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [5:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [19-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [5-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[5:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[5:1] <= receive_control[5:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_19_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_19" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 20-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_20_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_20" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [5:0] send_control;
	reg    [5-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 20-1)
			counter <= 0; else counter <= counter+1;
	reg [5-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 20 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[5:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_20_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_20" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [5:0] send_control /* synthesis syn_cpm_control=1 */;
	input [20-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [5-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[5:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_20_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_20" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [5:0] receive_control; //fastclk and counter
	reg    [5-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [5-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[5:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_20_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_20" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [5:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [5:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [20-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [5-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[5:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[5:1] <= receive_control[5:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_20_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_20" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 24-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_24_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_24" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [5:0] send_control;
	reg    [5-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 24-1)
			counter <= 0; else counter <= counter+1;
	reg [5-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 24 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[5:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_24_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_24" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [5:0] send_control /* synthesis syn_cpm_control=1 */;
	input [24-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [5-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[5:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_24_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_24" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [5:0] receive_control; //fastclk and counter
	reg    [5-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [5-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[5:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_24_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_24" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [5:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [5:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [24-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [5-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[5:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[5:1] <= receive_control[5:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_24_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_24" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 28-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_28_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_28" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [5:0] send_control;
	reg    [5-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 28-1)
			counter <= 0; else counter <= counter+1;
	reg [5-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 28 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[5:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_28_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_28" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [5:0] send_control /* synthesis syn_cpm_control=1 */;
	input [28-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [5-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[5:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_28_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_28" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [5:0] receive_control; //fastclk and counter
	reg    [5-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [5-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[5:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_28_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_28" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [5:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [5:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [28-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [5-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[5:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[5:1] <= receive_control[5:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_28_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_28" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a 32-input Asynchronous CPM module
//------------------------ 
//-- SEND CONTROL MODULE--
//------------------------
module ACPM_32_send_control_ver (fast_clk, send_control, cpm_sync)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_32" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd_onchip_control" */;
	input  fast_clk; // fastclk input
	output cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	output [5:0] send_control;
	reg    [5-1:0] counter;
	wire   fastclk;
	`ifndef synthesis
	initial begin
		counter = 'd0;
	end
	`endif //`ifndef synthesis
	assign fastclk = fast_clk;
	always @(posedge fastclk)
		if (counter >= 32-1)
			counter <= 0; else counter <= counter+1;
	reg [5-1:0] send_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		send_control_reg <= counter;
	end

	reg cpm_sync;
	always @(posedge fastclk) 
		cpm_sync <= (counter == 32 - 2) ? 1'b1 : 1'b0;
	assign send_control[0] = fastclk;
	assign send_control[5:1] = send_control_reg;
endmodule

//-----------------------
//--  SEND DATA MODULE --
//-----------------------
module ACPM_32_send_ver(send_control, data_in, cpm_data)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_preserve=1 
	syn_cpm_type="ACPM_32" 
	syn_cpm_pipe_stages=0 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" */;
	input [5:0] send_control /* synthesis syn_cpm_control=1 */;
	input [32-1:0] data_in;
	output reg cpm_data  /* synthesis syn_useenables=0 syn_useioff=force */ ;
	wire   [5-1:0] counter;
	wire   fastclk;
	assign fastclk = send_control[0];
	assign counter = send_control[5:1];
	always @(posedge fastclk)
		cpm_data <= data_in[counter];
endmodule

//-----------------------------
//--  RECEIVE CONTROL MODULE --
//-----------------------------
module ACPM_32_receive_control_ver(fast_clk, cpm_sync, receive_control)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_32" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv_onchip_control" */;
	input fast_clk; //fastclk
	input cpm_sync /* synthesis syn_cpm_srcontrol=1 */;
	reg cpm_sync_reg;
	output [5:0] receive_control; //fastclk and counter
	reg    [5-1:0] counter;
	wire   fastclk;
	assign fastclk = fast_clk;
	always @(posedge fastclk) begin
		cpm_sync_reg <= cpm_sync;
		if (cpm_sync_reg) counter <= 0; else counter <= counter + 1;
	end
	reg [5-1:0] receive_control_reg /* synthesis syn_cpm_allow_replication=1 */;
	always @(posedge fastclk) begin
		receive_control_reg <= counter;
	end
	assign receive_control[0] = fastclk;
	assign receive_control[5:1] = receive_control_reg;
endmodule

//---------------------------
//--  RECEIVE DATA MODULE  --
//---------------------------
module ACPM_32_receive_ver(receive_control, cpm_data, data_out)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard" 
	syn_cpm_type="ACPM_32" 
	syn_cpm_pipe_stages=1 
	syn_asynchronous_cpm=1 
	syn_reduce_controlset_size=2 
	syn_implement="cpmrcv" */;
	input [5:0] receive_control /* synthesis syn_cpm_control=1 */;
	reg   [5:1] receive_control_r;
	input cpm_data; 
	reg   cpm_data_reg /* synthesis syn_useenables=0 syn_useioff=force */; 
	output reg [32-1:0] data_out  /* synthesis syn_useenables=0 */;
	wire       [5-1:0] counter;
	wire   fastclk;

	assign fastclk = receive_control[0];
	assign counter = receive_control_r[5:1];
	always @(posedge fastclk) begin
		cpm_data_reg <= cpm_data;
		data_out[counter] <= cpm_data_reg;
		receive_control_r[5:1] <= receive_control[5:1];
	end
endmodule

//------------------------------
//--  OFFCHIP FASTCLK MODULE  --
//------------------------------
`timescale 1ps/1ps
module ACPM_32_offchip_control_ver(fast_clk)
	/* synthesis 
	syn_cpm_internal=1 
	syn_hier="hard"
	syn_cpm_type="ACPM_32" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrsc_offchip_control" 
	syn_black_box */;
	parameter CLK_DELAY_PS = 0; // Assuming zero phase delay
	parameter CLK_PERIOD_PS = 2000; // 2ns fast clock period
	output reg fast_clk = 0; // fastclk

	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	initial begin
		fast_clk = 1'b0;
		#(CLK_DELAY_PS) fast_clk = 1'b1;
		forever begin
			#(CLK_HALF_PERIOD_PS) fast_clk = ~fast_clk;
		end
	end
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_4_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_4" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 4;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [2-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_4_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_4" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 4;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [2-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_8_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_8" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 8;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [3-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_8_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_8" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 8;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [3-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_12_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_12" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 12;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [4-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_12_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_12" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 12;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [4-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_16_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_16" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 16;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [4-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_16_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_16" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 16;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [4-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_20_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_20" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 20;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_20_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_20" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 20;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_24_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_24" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 24;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_24_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_24" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 24;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_28_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_28" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 28;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_28_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_28" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 28;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_32_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_32" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 32;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_32_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_32" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 32;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_36_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_36" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 36;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_36_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_36" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 36;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_40_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_40" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 40;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_40_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_40" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 40;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_44_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_44" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 44;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_44_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_44" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 44;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_48_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_48" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 48;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_48_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_48" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 48;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_52_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_52" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 52;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_52_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_52" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 52;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_56_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_56" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 56;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_56_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_56" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 56;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_60_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_60" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 60;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_60_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_60" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 60;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_64_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_64" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 64;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_64_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_64" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 64;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_68_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_68" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 68;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_68_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_68" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 68;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_72_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_72" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 72;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_72_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_72" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 72;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_76_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_76" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 76;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_76_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_76" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 76;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_80_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_80" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 80;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_80_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_80" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 80;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_84_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_84" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 84;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_84_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_84" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 84;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_88_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_88" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 88;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_88_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_88" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 88;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_92_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_92" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 92;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_92_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_92" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 92;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_96_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_96" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 96;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_96_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_96" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 96;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_100_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_100" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 100;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_100_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_100" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 100;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_104_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_104" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 104;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_104_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_104" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 104;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_108_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_108" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 108;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_108_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_108" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 108;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_112_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_112" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 112;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_112_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_112" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 112;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_120_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_120" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 120;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_120_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_120" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 120;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_128_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_128" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 128;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_128_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_128" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 128;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_160_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_160" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 160;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_160_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_160" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 160;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_192_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_192" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 192;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_192_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_192" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 192;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_224_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_224" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 224;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_224_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_224" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 224;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_256_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_256" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 256;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_256_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_256" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 256;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_7_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_7" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 7;
	parameter PARITY_WIDTH = 1;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [3-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_7_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_7" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 7;
	parameter PARITY_WIDTH = 1;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [3-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_11_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_11" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 11;
	parameter PARITY_WIDTH = 1;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [4-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_11_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_11" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 11;
	parameter PARITY_WIDTH = 1;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [4-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_15_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_15" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 15;
	parameter PARITY_WIDTH = 1;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [4-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_15_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_15" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 15;
	parameter PARITY_WIDTH = 1;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [4-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_18_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_18" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 18;
	parameter PARITY_WIDTH = 2;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_18_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_18" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 18;
	parameter PARITY_WIDTH = 2;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_22_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_22" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 22;
	parameter PARITY_WIDTH = 2;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_22_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_22" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 22;
	parameter PARITY_WIDTH = 2;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_26_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_26" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 26;
	parameter PARITY_WIDTH = 2;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_26_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_26" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 26;
	parameter PARITY_WIDTH = 2;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_30_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_30" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 30;
	parameter PARITY_WIDTH = 2;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_30_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_30" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 30;
	parameter PARITY_WIDTH = 2;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [5-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_33_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_33" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 33;
	parameter PARITY_WIDTH = 3;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_33_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_33" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 33;
	parameter PARITY_WIDTH = 3;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_37_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_37" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 37;
	parameter PARITY_WIDTH = 3;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_37_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_37" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 37;
	parameter PARITY_WIDTH = 3;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_41_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_41" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 41;
	parameter PARITY_WIDTH = 3;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_41_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_41" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 41;
	parameter PARITY_WIDTH = 3;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_45_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_45" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 45;
	parameter PARITY_WIDTH = 3;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_45_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_45" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 45;
	parameter PARITY_WIDTH = 3;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_48_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_48" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 48;
	parameter PARITY_WIDTH = 4;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_48_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_48" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 48;
	parameter PARITY_WIDTH = 4;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_52_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_52" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 52;
	parameter PARITY_WIDTH = 4;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_52_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_52" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 52;
	parameter PARITY_WIDTH = 4;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_56_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_56" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 56;
	parameter PARITY_WIDTH = 4;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_56_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_56" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 56;
	parameter PARITY_WIDTH = 4;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_60_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_60" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 60;
	parameter PARITY_WIDTH = 4;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_60_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_60" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 60;
	parameter PARITY_WIDTH = 4;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [6-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_63_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_63" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 63;
	parameter PARITY_WIDTH = 5;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_63_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_63" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 63;
	parameter PARITY_WIDTH = 5;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_67_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_67" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 67;
	parameter PARITY_WIDTH = 5;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_67_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_67" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 67;
	parameter PARITY_WIDTH = 5;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_71_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_71" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 71;
	parameter PARITY_WIDTH = 5;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_71_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_71" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 71;
	parameter PARITY_WIDTH = 5;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_75_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_75" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 75;
	parameter PARITY_WIDTH = 5;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_75_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_75" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 75;
	parameter PARITY_WIDTH = 5;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_78_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_78" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 78;
	parameter PARITY_WIDTH = 6;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_78_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_78" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 78;
	parameter PARITY_WIDTH = 6;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_82_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_82" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 82;
	parameter PARITY_WIDTH = 6;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_82_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_82" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 82;
	parameter PARITY_WIDTH = 6;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_86_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_86" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 86;
	parameter PARITY_WIDTH = 6;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_86_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_86" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 86;
	parameter PARITY_WIDTH = 6;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_90_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_90" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 90;
	parameter PARITY_WIDTH = 6;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_90_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_90" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 90;
	parameter PARITY_WIDTH = 6;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_93_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_93" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 93;
	parameter PARITY_WIDTH = 7;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_93_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_93" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 93;
	parameter PARITY_WIDTH = 7;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_97_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_97" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 97;
	parameter PARITY_WIDTH = 7;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_97_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_97" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 97;
	parameter PARITY_WIDTH = 7;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_101_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_101" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 101;
	parameter PARITY_WIDTH = 7;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_101_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_101" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 101;
	parameter PARITY_WIDTH = 7;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_105_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_105" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 105;
	parameter PARITY_WIDTH = 7;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_105_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_105" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 105;
	parameter PARITY_WIDTH = 7;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_112_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_112" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 112;
	parameter PARITY_WIDTH = 8;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_112_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_112" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 112;
	parameter PARITY_WIDTH = 8;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_120_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_120" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 120;
	parameter PARITY_WIDTH = 8;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_120_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_120" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 120;
	parameter PARITY_WIDTH = 8;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [7-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_150_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_150" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 150;
	parameter PARITY_WIDTH = 10;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_150_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_150" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 150;
	parameter PARITY_WIDTH = 10;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_180_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_180" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 180;
	parameter PARITY_WIDTH = 12;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_180_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_180" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 180;
	parameter PARITY_WIDTH = 12;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_210_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_210" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 210;
	parameter PARITY_WIDTH = 14;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_210_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_210" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 210;
	parameter PARITY_WIDTH = 14;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_240_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_240" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 240;
	parameter PARITY_WIDTH = 16;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output			cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_240_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_240" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 240;
	parameter PARITY_WIDTH = 16;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

`ifndef __HSTDM_SIM_OFF_CHIP_CLOCK_GEN_V
`define __HSTDM_SIM_OFF_CHIP_CLOCK_GEN_V 1
`ifndef synthesis
// for simulation;
`timescale 1ps/1ps
module HSTDM_SIM_offchip_clock_gen (fast_clk, fast_clk_N)/* synthesis syn_black_box */;
	parameter CLK_PERIOD_PS = 1000;
	output fast_clk, fast_clk_N;
	reg fast_clk;
	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	assign fast_clk_N = !fast_clk;
	initial begin
		fast_clk =0;
	end
	always begin
		#(CLK_HALF_PERIOD_PS) fast_clk = !fast_clk ;
	end
	`endif //`ifndef synthesis
endmodule

// for simulation;
`timescale 1ps/1ps
module HSTDM_GCLK0_100_offchip_clock_gen (fast_clk, fast_clk_N)/* synthesis syn_black_box */;
	parameter CLK_PERIOD_PS = 10000;
	output fast_clk, fast_clk_N;
	reg fast_clk;
	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	assign fast_clk_N = !fast_clk;
	initial begin
		fast_clk =0;
	end
	always begin
		#(CLK_HALF_PERIOD_PS) fast_clk = !fast_clk ;
	end
	`endif //`ifndef synthesis
endmodule

// for simulation;
`timescale 1ps/1ps
module HSTDM_GCLK0_200_offchip_clock_gen (fast_clk, fast_clk_N)/* synthesis syn_black_box */;
	parameter CLK_PERIOD_PS = 5000;
	output fast_clk, fast_clk_N;
	reg fast_clk;
	`ifndef synthesis
	localparam CLK_HALF_PERIOD_PS = CLK_PERIOD_PS/2.0;
	assign fast_clk_N = !fast_clk;
	initial begin
		fast_clk =0;
	end
	always begin
		#(CLK_HALF_PERIOD_PS) fast_clk = !fast_clk ;
	end
	`endif //`ifndef synthesis
endmodule

`endif //`ifndef synthesis
`endif //__HSTDM_SIM_OFF_CHIP_CLOCK_GEN_V


/*****************************************************/
module HSTDM_ERD_MGT_256_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_MGT_256_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 256;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output	cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_MGT_256_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_MGT_256_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 256;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_MGT_512_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_MGT_512_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 512;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output	cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [9-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_MGT_512_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_MGT_512_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 512;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [9-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_ERD_MGT_1024_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_ERD_MGT_1024_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 1024;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output	cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [10-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_ERD_MGT_1024_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_ERD_MGT_1024_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 1024;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [10-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

// =======================================================
//-- This is a HAPS-100 Y-MGTDM module
// =======================================================
/*****************************************************/
module HSTDM_MGT_64_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_MGT_64_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 64;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output	cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_MGT_64_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_MGT_64_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 64;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

module HSTDM_MGT_128_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_MGT_128_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 128;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output	cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_MGT_128_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_MGT_128_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 128;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

module HSTDM_MGT_256_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_MGT_256_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 256;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output	cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_MGT_256_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_MGT_256_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 256;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [8-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_MGT_512_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_MGT_512_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 512;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output	cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [9-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_MGT_512_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_MGT_512_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 512;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [9-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule

/*****************************************************/
module HSTDM_MGT_1024_send_ver (send_control, data_in, cpm_data)
	/* synthesis 
	syn_hier="hard"
	syn_preserve=1
	syn_cpm_type="HSTDM_MGT_1024_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmsnd" 
	syn_black_box */;

	parameter USER_DATAWIDTH = 1024;
	parameter PARITY_WIDTH = 0;

	input	[USER_DATAWIDTH-1:0]	data_in;
	input	send_control /* synthesis syn_cpm_control=1 */;
	output	cpm_data;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [10-1:0] counter;
	reg cpm_data_reg;
	initial counter = 0; // for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		cpm_data_reg <= data_in[counter];
	end
	assign cpm_data = cpm_data_reg;
	`endif //`ifndef synthesis
endmodule

module HSTDM_MGT_1024_receive_ver  (receive_control, cpm_data, data_out)
	/* synthesis 
	syn_hier="hard"
	syn_cpm_type="HSTDM_MGT_1024_v" 
	syn_asynchronous_cpm=1 
	syn_implement="cpmrcv" 
	syn_black_box */; 

	parameter USER_DATAWIDTH = 1024;
	parameter PARITY_WIDTH = 0;

	input	receive_control /* synthesis syn_cpm_control=1 */;
	input	cpm_data;
	output	[USER_DATAWIDTH-1:0]	data_out;

	`ifndef synthesis
	wire fast_clk = HSTDM_SIM_offchip_clock_gen_inst.fast_clk;
	reg [10-1:0] counter;
	reg [USER_DATAWIDTH-1:0] data_out_reg;
	initial counter = USER_DATAWIDTH-1;// for post partition simulation, no sync signal
	always @(posedge fast_clk) begin
		if(counter>=USER_DATAWIDTH-1) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	always @(posedge fast_clk) begin
		data_out_reg[counter] <= cpm_data;
	end
	assign data_out[USER_DATAWIDTH-1:0] = data_out_reg[USER_DATAWIDTH-1:0];
	`endif //`ifndef synthesis
endmodule


// =======================================================
//-- This is a 4-input Asynchronous MDTDM module
// =======================================================
//------------------------
//--  MDTMD SEND MODULE --
//------------------------
module MDTDM_4_send(fast_clk, tx_data, mdtdm_data)
    /* synthesis 
    haps_ip_type="mdtdm_tx" 
    syn_hier="hard" 
    syn_preserve=1 
    syn_cpm_type="MDTDM_4" 
    syn_implement="cpmsnd" */;
    parameter RATIO     = 4;
    parameter CTRLWIDTH = 2;

    input             fast_clk; // fastclk input
    input [RATIO-1:0] tx_data;
    output            mdtdm_data/* synthesis syn_useenables=0 */;

    reg [CTRLWIDTH-1:0] counter = 0;
    `ifndef synthesis
    initial begin
        counter = 'd0;
    end
    `endif //`ifndef synthesis

    wire fastclk;
    assign fastclk = fast_clk;
    // control
    always @(posedge fastclk) begin
        if (counter >= RATIO - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // send
    assign  mdtdm_data = tx_data[counter];
endmodule

//-----------------------------
//--  MDTDM RECEIVE MODULE   --
//-----------------------------
module MDTDM_4_receive(fast_clk, rx_data, mdtdm_data)
    /* synthesis 
    haps_ip_type="mdtdm_rx" 
    syn_hier="hard" 
    syn_preserve=1 
    syn_cpm_type="MDTDM_4" 
    syn_implement="cpmrcv" */;
    parameter RATIO     = 4;
    parameter CTRLWIDTH = 2;

    input                  fast_clk; //fastclk
    input                  mdtdm_data;
    output reg [RATIO-1:0] rx_data/* synthesis syn_useenables=0 */;

    reg [CTRLWIDTH-1:0] counter = 0;
    `ifndef synthesis
    initial begin
        counter = 'd0;
    end
    `endif //`ifndef synthesis

    wire   fastclk;
    assign fastclk = fast_clk;
    // control
    always @(posedge fastclk) begin
        if (counter >= RATIO - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // receive
    always @(posedge fastclk) begin
        rx_data[counter] <= mdtdm_data;
    end
endmodule

// =======================================================
//-- This is a 16-input Asynchronous MDTDM module
// =======================================================
//------------------------
//--  MDTMD SEND MODULE --
//------------------------
module MDTDM_16_send(fast_clk, tx_data, mdtdm_data)
    /* synthesis 
    haps_ip_type="mdtdm_tx" 
    syn_hier="hard" 
    syn_preserve=1 
    syn_cpm_type="MDTDM_16" 
    syn_implement="cpmsnd" */;
    parameter RATIO     = 16;
    parameter CTRLWIDTH = 4;

    input             fast_clk; // fastclk input
    input [RATIO-1:0] tx_data;
    output            mdtdm_data/* synthesis syn_useenables=0 */;

    reg [CTRLWIDTH-1:0] counter = 0;
    `ifndef synthesis
    initial begin
        counter = 'd0;
    end
    `endif //`ifndef synthesis

    wire fastclk;
    assign fastclk = fast_clk;
    // control
    always @(posedge fastclk) begin
        if (counter >= RATIO - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // send
    assign  mdtdm_data = tx_data[counter];
endmodule

//-----------------------------
//--  MDTDM RECEIVE MODULE   --
//-----------------------------
module MDTDM_16_receive(fast_clk, rx_data, mdtdm_data)
    /* synthesis 
    haps_ip_type="mdtdm_rx" 
    syn_hier="hard" 
    syn_preserve=1 
    syn_cpm_type="MDTDM_16" 
    syn_implement="cpmrcv" */;
    parameter RATIO     = 16;
    parameter CTRLWIDTH = 4;

    input                  fast_clk; //fastclk
    input                  mdtdm_data;
    output reg [RATIO-1:0] rx_data/* synthesis syn_useenables=0 */;

    reg [CTRLWIDTH-1:0] counter = 0;
    `ifndef synthesis
    initial begin
        counter = 'd0;
    end
    `endif //`ifndef synthesis

    wire   fastclk;
    assign fastclk = fast_clk;
    // control
    always @(posedge fastclk) begin
        if (counter >= RATIO - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // receive
    always @(posedge fastclk) begin
        rx_data[counter] <= mdtdm_data;
    end
endmodule

//-----------------------------
//--  MDTDM CLOCK MODULE   --
//-----------------------------
module MDTDM_clk(O,I)
	/* synthesis 
	haps_ip_type="mdtdm_clk"
	syn_hier="hard" 
	syn_preserve=1 
    syn_cpm_type="MDTDM_clk" 
    syn_implement="cpmclk" */;
	output O;
	input I;

	wire umr_reset, ce;

	// connect to umr_reset - invert to get ce
	syn_hyper_connect mdtdm_umr_reset(umr_reset);
	defparam mdtdm_umr_reset.tag = "umr_reset";
	defparam mdtdm_umr_reset.mustconnect = 1;
	defparam mdtdm_umr_reset.dflt= 0;
	assign ce = ~umr_reset;

	// bufgce to sync mdtdm counters
	BUFGCE BUFGCE_inst (.O(O),.CE(ce),.I(I)); 

endmodule

// dummy top for c_ver 
module tdm_dummy_top(out);
	output out;

	assign out = 0;
endmodule	
