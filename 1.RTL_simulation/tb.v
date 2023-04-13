`timescale 1ns/100ps
`define CYCLE     1.0    // Modify your clock period here
`define End_CYCLE 200      // Modify cycle times once your design need more cycle times!  

module BIST_Adder16_tb;

initial begin
	$fsdbDumpfile("../BIST_Adder16_func.fsdb");
	$fsdbDumpvars;
end

reg  clk;
reg  rst;
wire finish;
wire [16:0] signature;

top top(.clk(clk), .rst(rst), .signature(signature), .finish(finish));


initial begin
clk = 1'b0; rst = 1'b0;
#(`CYCLE) rst = 1'b1;
#(`CYCLE) rst = 1'b0;
wait(finish)
#(`CYCLE) 
$finish; 
end

always begin
#(`CYCLE/2) clk = ~clk;
end


initial begin
 #(`CYCLE * `End_CYCLE);
 $display("-----------------------------------------------------\n");
 $display("Error!!! Somethings' wrong with your code ...!\n");
 $display("Perhaps you can adjust the bigger value of End_CYCLE and then run the simulation again!");
 $display("-------------------------FAIL------------------------\n");
 $display("-----------------------------------------------------\n");
 $finish;
end

endmodule

