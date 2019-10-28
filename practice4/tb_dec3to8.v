module tb_decoder	;

reg	[2:0]	in		;
reg		en		;

wire	[7:0]	out1		;
wire	[7:0]	out2		;

dec3to8_shift	dut0(	.in	( in	),
			.en	( en	),
			.out	( out1	));

dec3to8_case	dut1(	.in	( in	),
			.en	( en	),
			.out	( out2	));

initial begin
	$display("=====================================================");
	$display("	en	in	 out_shift	out_case");
	$display("=====================================================");
	#(50)	{en, in} = $random(); #(50)	$display("	%b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = $random(); #(50)	$display("	%b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = $random(); #(50)	$display("	%b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = $random(); #(50)	$display("	%b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = $random(); #(50)	$display("	%b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = $random(); #(50)	$display("	%b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = $random(); #(50)	$display("	%b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	$finish;
end
endmodule
