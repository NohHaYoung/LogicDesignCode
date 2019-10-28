module	tb_bnb;

wire		q_block		;
wire		q_nonblock	;

reg		d		;
reg		clk		;

initial		clk = 1'b1	;
always	#(50)	clk = ~clk	;

block		dut0(	.q	( q_block	),
			.d	( d		),
			.clk	( clk		));

nonblock	dut1(	.q	( q_nonblock	),
			.d	( d		),
			.clk	( clk		));

initial begin
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;
#(50)	{d} = $random()	;

$finish;
end
endmodule
