module garage_occupancy_top(
	input clk,
	input a,
	input b,
	input c,
	input d,
	input reset,
	output [3:0] an,
	output [6:0] seg);


	parameter zero = 4'b0000;
	wire clk_out;
	wire increment;
	wire decrement;
	wire [3:0] mux_out;
	wire [1:0] counter_out;
	wire [3:0] ones, tens, hundreds;
	wire [7:0] car_count;
	wire a_deb, b_deb, c_deb, d_deb;
	
	debounce A(clk, a, a_deb);
	
	debounce B(clk, b, b_deb);	
	
	debounce C(clk, c, c_deb);	
	
	debounce D(clk, d, d_deb);	
	
	binary_to_BCD u0(car_count, ones, tens, hundreds);
	
	mux4to1 u1(ones, tens, hundreds, zero, counter_out, mux_out);
	
	slowclock u2(clk, clk_out);
	
	my_counter u3(clk_out, counter_out);
	
	decoder2to4 u4(counter_out, an);
	
	bcd7seg u5(mux_out, seg);
	
	counter u6(clk, reset, increment, decrement, car_count);
	
	FSM enter_fsm(clk, reset, a_deb, b_deb, increment);
	
	FSM exit_fsm(clk, reset, c_deb, d_deb, decrement);		
	
endmodule