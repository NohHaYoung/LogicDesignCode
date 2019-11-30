//	==================================================
//	Copyright (c) 2019 Sookmyung Women's University.
//	--------------------------------------------------
//	FILE 			: dut.v
//	DEPARTMENT		: EE
//	AUTHOR			: WOONG CHOI
//	EMAIL			: woongchoi@sookmyung.ac.kr
//	--------------------------------------------------
//	RELEASE HISTORY
//	--------------------------------------------------
//	VERSION			DATE
//	0.0			2019-11-18
//	--------------------------------------------------
//	PURPOSE			: Digital Clock
//	==================================================

//	--------------------------------------------------
//	Numerical Controlled Oscillator
//	Hz of o_gen_clk = Clock Hz / num
//	--------------------------------------------------
module	nco(	
		o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	// 50Mhz CLK
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt		<= 32'd0;
		o_gen_clk	<= 1'd0	;
	end else begin
		if(cnt >= i_nco_num/2-1) begin
			cnt 	<= 32'd0;
			o_gen_clk	<= ~o_gen_clk;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule
//	--------------------------------------------------
//	TIMER_COUNTER
//	--------------------------------------------------
module	timer_cnt(
		o_timer_cnt,
		o_max_hit,
		i_max_cnt,
		clk,
		rst_n);

output	[6:0]	o_timer_cnt		;
output		o_max_hit		;

input	[6:0]	i_max_cnt		;
input		clk			;
input		rst_n			;

reg	[6:0]	o_timer_cnt		;
reg		o_max_hit		;
always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_timer_cnt <= 6'd0;
		o_max_hit <= 1'b0;
	end else begin
		if(o_timer_cnt >= i_max_cnt) begin
			o_timer_cnt <= 6'd0;
			o_max_hit <= 1'b1;
		end else begin
			o_timer_cnt <= o_timer_cnt + 1'b1;
			o_max_hit <= 1'b0;
		end
	end
end

endmodule

//	--------------------------------------------------
//	Flexible Numerical Display Decoder
//	--------------------------------------------------
module	fnd_dec(
		o_seg,
		i_num);

output	[6:0]	o_seg		;	// {o_seg_a, o_seg_b, ... , o_seg_g}

input	[3:0]	i_num		;
reg	[6:0]	o_seg		;

always @(i_num) begin 
 	case(i_num) 
 		4'd0:	o_seg = 7'b111_1110; 
 		4'd1:	o_seg = 7'b011_0000; 
 		4'd2:	o_seg = 7'b110_1101; 
 		4'd3:	o_seg = 7'b111_1001; 
 		4'd4:	o_seg = 7'b011_0011; 
 		4'd5:	o_seg = 7'b101_1011; 
 		4'd6:	o_seg = 7'b101_1111; 
 		4'd7:	o_seg = 7'b111_0000; 
 		4'd8:	o_seg = 7'b111_1111; 
 		4'd9:	o_seg = 7'b111_0011; 
		default:o_seg = 7'b000_0000; 
	endcase 
end


endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	double_fig_sep(
		o_left,
		o_right,
		i_double_fig);

output	[3:0]	o_left		;
output	[3:0]	o_right		;

input	[5:0]	i_double_fig	;

assign		o_left	= i_double_fig / 10	;
assign		o_right	= i_double_fig % 10	;

endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	led_disp(
		o_seg,
		o_seg_dp,
		o_seg_enb,
		i_six_digit_seg,
		i_six_dp,
		clk,
		rst_n);

output	[5:0]	o_seg_enb		;
output		o_seg_dp		;
output	[6:0]	o_seg			;

input	[41:0]	i_six_digit_seg		;
input	[5:0]	i_six_dp		;
input		clk			;
input		rst_n			;

wire		gen_clk		;

nco		u_nco(
		.o_gen_clk	( gen_clk	),
		.i_nco_num	( 32'd5000	),
		.clk		( clk		),
		.rst_n		( rst_n		));


reg	[3:0]	cnt_common_node	;

always @(posedge gen_clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_common_node <= 4'd0;
	end else begin
		if(cnt_common_node >= 4'd5) begin
			cnt_common_node <= 4'd0;
		end else begin
			cnt_common_node <= cnt_common_node + 1'b1;
		end
	end
end

reg	[5:0]	o_seg_enb		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg_enb = 6'b111110;
		4'd1:	o_seg_enb = 6'b111101;
		4'd2:	o_seg_enb = 6'b111011;
		4'd3:	o_seg_enb = 6'b110111;
		4'd4:	o_seg_enb = 6'b101111;
		4'd5:	o_seg_enb = 6'b011111;
		default:o_seg_enb = 6'b111111;
	endcase
end

reg		o_seg_dp		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg_dp = i_six_dp[0];
		4'd1:	o_seg_dp = i_six_dp[1];
		4'd2:	o_seg_dp = i_six_dp[2];
		4'd3:	o_seg_dp = i_six_dp[3];
		4'd4:	o_seg_dp = i_six_dp[4];
		4'd5:	o_seg_dp = i_six_dp[5];
		default:o_seg_dp = 1'b0;
	endcase
end

reg	[6:0]	o_seg			;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg = i_six_digit_seg[6:0];
		4'd1:	o_seg = i_six_digit_seg[13:7];
		4'd2:	o_seg = i_six_digit_seg[20:14];
		4'd3:	o_seg = i_six_digit_seg[27:21];
		4'd4:	o_seg = i_six_digit_seg[34:28];
		4'd5:	o_seg = i_six_digit_seg[41:35];
		default:o_seg = 7'b111_1110; // 0 display
	endcase
end

endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hms_cnt(
		o_hms_cnt,
		o_max_hit,
		i_max_cnt,
		clk,
		rst_n);

output	[6:0]	o_hms_cnt		;
output		o_max_hit		;

input	[6:0]	i_max_cnt		;
input		clk			;
input		rst_n			;

reg	[6:0]	o_hms_cnt		;
reg		o_max_hit		;
always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_cnt <= 7'd0;
		o_max_hit <= 1'b0;
	end else begin
		if(o_hms_cnt >= i_max_cnt) begin
			o_hms_cnt <= 7'd0;
			o_max_hit <= 1'b1;
		end else begin
			o_hms_cnt <= o_hms_cnt + 1'b1;
			o_max_hit <= 1'b0;
		end
	end
end

endmodule

module  debounce(
		o_sw,
		i_sw,
		clk);
output		o_sw			;

input		i_sw			;
input		clk			;

reg		dly1_sw			;
always @(posedge clk) begin
	dly1_sw <= i_sw;
end

reg		dly2_sw			;
always @(posedge clk) begin
	dly2_sw <= dly1_sw;
end

assign		o_sw = dly1_sw | ~dly2_sw;

endmodule

//	--------------------------------------------------
//	Clock Controller
//	--------------------------------------------------
module	controller(
		o_mode,
		o_position,
		o_alarm_en,
		o_sec_clk,
		o_min_clk,
		o_hour_clk,
		o_alarm_sec_clk,
		o_alarm_min_clk,
		o_alarm_hour_clk,
		o_timer_secc_clk,
		o_timer_sec_clk,
		o_timer_min_clk,
		o_start,
		o_rst,
		i_max_hit_sec,
		i_max_hit_min,
		i_max_hit_hour,
		i_max_timer_secc,
		i_max_timer_sec,
		i_max_timer_min,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		clk,
		rst_n);

output	[1:0]	o_mode			;
output	[1:0]	o_position		;
output		o_alarm_en		;
output		o_sec_clk		;
output		o_min_clk		;
output		o_hour_clk		;
output		o_alarm_sec_clk		;
output		o_alarm_min_clk		;
output		o_alarm_hour_clk	;
output		o_timer_secc_clk	;
output		o_timer_sec_clk		;
output		o_timer_min_clk		;
output		o_start			;
output		o_rst			;

input		i_max_hit_sec		;
input		i_max_hit_min		;
input		i_max_hit_hour		;
input		i_max_timer_secc	;
input		i_max_timer_sec		;
input		i_max_timer_min		;

input		i_sw0			;
input		i_sw1			;
input		i_sw2			;
input		i_sw3			;

input		clk			;
input		rst_n			;

parameter	MODE_CLOCK	= 3'b000	;
parameter	MODE_SETUP	= 3'b001	;
parameter	MODE_ALARM	= 3'b010	;
parameter	MODE_TIMER	= 3'b011	;
parameter	POS_SEC		= 2'b00		;
parameter	POS_MIN		= 2'b01		;
parameter	POS_HOUR	= 2'b10		;

wire		clk_100hz		;
nco		u0_nco(
		.o_gen_clk	( clk_100hz	),
		.i_nco_num	( 32'd500000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

wire		sw0			;
debounce	u0_debounce(
		.o_sw		( sw0		),
		.i_sw		( i_sw0		),
		.clk		( clk_100hz	));

wire		sw1			;
debounce	u1_debounce(
		.o_sw		( sw1		),
		.i_sw		( i_sw1		),
		.clk		( clk_100hz	));

wire		sw2			;
debounce	u2_debounce(
		.o_sw		( sw2		),
		.i_sw		( i_sw2		),
		.clk		( clk_100hz	));

wire		sw3			;
debounce	u3_debounce(
		.o_sw		( sw3		),
		.i_sw		( i_sw3		),
		.clk		( clk_100hz	));

reg	[1:0]	o_mode			;
always @(posedge sw0 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_mode <= MODE_CLOCK;
	end else begin
		if(o_mode >= MODE_TIMER) begin
			o_mode <= MODE_CLOCK;
		end else begin
			o_mode <= o_mode + 1'b1;
		end
	end
end

reg	[1:0]		o_position	;
always @(posedge sw1 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_position <= POS_SEC;
	end else begin
		if(o_position >= POS_HOUR) begin
			o_position <= POS_SEC;
		end else begin
		o_position <= o_position + 1'b1;
		end
	end
end

reg			o_start		;
always	@(posedge sw1 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_start <= 1'b0;
	end else begin
		o_start <= o_start + 1'b1;
	end
end

reg			o_rst		;
always	@(posedge sw2 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_rst <= 1'b0;
	end else begin
		o_rst <= o_rst + 1'b1;
	end
end

reg		o_alarm_en		;
always @(posedge sw3 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_alarm_en <= 1'b0;
	end else begin
		o_alarm_en <= o_alarm_en + 1'b1;
	end
end

wire		clk_1hz			;
nco		u1_nco(
		.o_gen_clk	( clk_1hz	),
		.i_nco_num	( 32'd50000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg		o_sec_clk		;
reg		o_min_clk		;
reg		o_hour_clk		;
reg		o_alarm_sec_clk		;
reg		o_alarm_min_clk		;
reg		o_alarm_hour_clk	;
reg		o_timer_secc_clk	;
reg		o_timer_sec_clk		;
reg		o_timer_min_clk		;
reg		m_timer_secc		;
reg		m_timer_sec		;
reg		m_timer_min		;
always @(*) begin
	case(o_mode)
		MODE_CLOCK : begin
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
			o_hour_clk = i_max_hit_min;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk = 1'b0;
			o_timer_secc_clk = 1'b0;
			o_timer_sec_clk = 1'b0;
			o_timer_min_clk = 1'b0;
		end
		MODE_SETUP : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = ~sw2;
					o_min_clk = 1'b0;
					o_hour_clk = 1'b0;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = 1'b0;
					o_timer_secc_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
				end
				POS_MIN : begin
					o_sec_clk = 1'b0;
					o_min_clk = ~sw2;
					o_hour_clk = 1'b0;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = 1'b0;
					o_timer_secc_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
				end
				POS_HOUR : begin
					o_sec_clk = 1'b0;
					o_min_clk = 1'b0;
					o_hour_clk = ~sw2;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = 1'b0;
					o_timer_secc_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
				end
			endcase
		end
		MODE_ALARM : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hour_clk = i_max_hit_min;
					o_alarm_sec_clk = ~sw2;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = 1'b0;
					o_timer_secc_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
				end
				POS_MIN : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hour_clk = i_max_hit_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = ~sw2;
					o_alarm_hour_clk = 1'b0;
					o_timer_secc_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
				end
				POS_HOUR : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hour_clk = i_max_hit_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = ~sw2;
					o_timer_secc_clk = 1'b0;
					o_timer_sec_clk = 1'b0;
					o_timer_min_clk = 1'b0;
				end
			endcase
		end
		MODE_TIMER : begin

			if(o_start ==1'b1) begin
			o_timer_secc_clk = clk_100hz;
			o_timer_sec_clk = i_max_timer_secc;
			o_timer_min_clk = i_max_timer_sec;
			m_timer_secc = o_timer_secc_clk;
			m_timer_sec = o_timer_sec_clk;
			m_timer_min = o_timer_min_clk;

			end else if(o_start == 1'b0) begin
			o_timer_secc_clk = m_timer_secc;
			o_timer_sec_clk = m_timer_sec;
			o_timer_min_clk = m_timer_min;
			
			end else if(o_rst != o_rst) begin
			o_timer_secc_clk = 1'b0;
			o_timer_sec_clk = 1'b0;
			o_timer_min_clk = 1'b0;
			end
		end
		default: begin
			o_sec_clk = 1'b0;
			o_min_clk = 1'b0;
			o_hour_clk = 1'b0;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk = 1'b0;
			o_timer_secc_clk = 1'b0;
			o_timer_sec_clk = 1'b0;
			o_timer_min_clk	= 1'b0;
		end
	endcase
end

endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hourminsec(	
		o_sec,
		o_min,
		o_hour,
		o_timer_secc,
		o_timer_sec,
		o_timer_min,
		o_max_hit_sec,
		o_max_hit_min,
		o_max_hit_hour,
		o_max_timer_secc,
		o_max_timer_sec,
		o_max_timer_min,
		o_alarm,
		i_mode,
		i_position,
		i_sec_clk,
		i_min_clk,
		i_hour_clk,
		i_alarm_sec_clk,
		i_alarm_min_clk,
		i_alarm_hour_clk,
		i_alarm_en,
		i_timer_start,
		i_timer_reset,
		i_timer_secc_clk,
		i_timer_sec_clk,
		i_timer_min_clk,
		clk,
		rst_n);

output	[6:0]	o_sec		;
output	[5:0]	o_min		;
output	[5:0]	o_hour		;

output	[6:0]	o_timer_secc	;
output	[5:0]	o_timer_sec	;
output	[5:0]	o_timer_min	;

output		o_max_hit_sec	;
output		o_max_hit_min	;
output		o_max_hit_hour	;
output		o_alarm		;

output		o_max_timer_secc;
output		o_max_timer_sec	;
output		o_max_timer_min	;

input	[1:0]	i_mode		;
input	[1:0]	i_position	;
input		i_sec_clk	;
input		i_min_clk	;
input		i_hour_clk	;
input		i_alarm_sec_clk	;
input		i_alarm_min_clk	;
input		i_alarm_hour_clk;
input		i_alarm_en	;

input		i_timer_start	;
input		i_timer_reset	;

input		i_timer_secc_clk;
input		i_timer_sec_clk	;
input		i_timer_min_clk	;
input		clk		;
input		rst_n		;

parameter	MODE_CLOCK	= 2'b00	;
parameter	MODE_SETUP	= 2'b01	;
parameter	MODE_ALARM	= 2'b10	;
parameter	MODE_TIMER	= 2'b11	;
parameter	POS_SEC		= 2'b00	;
parameter	POS_MIN		= 2'b01	;
parameter	POS_HOUR	= 2'b10	;

//	MODE_CLOCK
wire	[6:0]	sec		;
wire		max_hit_sec	;
hms_cnt		u_hms_cnt_sec(
		.o_hms_cnt	( sec			),
		.o_max_hit	( o_max_hit_sec		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_sec_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	min		;
wire		max_hit_min	;
hms_cnt		u_hms_cnt_min(
		.o_hms_cnt	( min			),
		.o_max_hit	( o_max_hit_min		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_min_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	hour		;
wire		max_hit_hour	;
hms_cnt		u_hms_cnt_hour(
		.o_hms_cnt	( hour			),
		.o_max_hit	( o_max_hit_hour	),
		.i_max_cnt	( 5'd23			),
		.clk		( i_hour_clk		),
		.rst_n		( rst_n			));

//	MODE_ALARM
wire	[5:0]	alarm_sec	;
hms_cnt		u_hms_cnt_alarm_sec(
		.o_hms_cnt	( alarm_sec		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_min	;
hms_cnt		u_hms_cnt_alarm_min(
		.o_hms_cnt	( alarm_min		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_min_clk	),
		.rst_n		( rst_n			));

wire	[4:0]	alarm_hour	;
hms_cnt		u_hms_cnt_alarm_hour(
		.o_hms_cnt	( alarm_hour		),
		.o_max_hit	( 			),
		.i_max_cnt	( 5'd23			),
		.clk		( i_alarm_hour_clk	),
		.rst_n		( rst_n			));
//	MODE TIMER
wire	[6:0]	timer_secc	;
wire		max_timer_secc	;
timer_cnt	u_timer_cnt_secc(
		.o_timer_cnt	( timer_secc		),
		.o_max_hit	( o_max_timer_secc	),
		.i_max_cnt	( 7'd99			),
		.clk		( i_timer_secc_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	timer_sec	;
wire		max_timer_sec	;
timer_cnt	u_timer_cnt_sec(
		.o_timer_cnt	( timer_sec		),
		.o_max_hit	( o_max_timer_sec	),
		.i_max_cnt	( 6'd59			),
		.clk		( i_timer_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	timer_min	;
wire		max_timer_min	;
timer_cnt	u_timer_cnt_min(
		.o_timer_cnt	( timer_min		),
		.o_max_hit	( o_max_timer_min	),
		.i_max_cnt	( 6'd59			),
		.clk		( i_timer_min_clk	),
		.rst_n		( rst_n			));

reg	[6:0]	o_sec		;
reg	[5:0]	o_min		;
reg	[5:0]	o_hour		;
reg	[6:0]	o_timer_secc	;
reg	[5:0]	o_timer_sec	;
reg	[5:0]	o_timer_min	;
reg	[6:0]	m_secc		;
reg	[5:0]	m_sec		;
reg	[5:0]	m_min		;
always @ (*) begin
	case(i_mode)
		MODE_CLOCK: 	begin
			o_sec	= sec;
			o_min	= min;
			o_hour	= hour;
		end
		MODE_SETUP:	begin
			o_sec	= sec;
			o_min	= min;
			o_hour	= hour;
		end
		MODE_ALARM:	begin
			o_sec	= alarm_sec;
			o_min	= alarm_min;
			o_hour	= alarm_hour;
		end
		MODE_TIMER:	begin
			o_timer_secc = timer_secc;
			o_timer_sec = timer_sec;
			o_timer_min = timer_min;
		end
	endcase
end

reg		o_alarm		;
always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		o_alarm <= 1'b0;
	end else begin
		if( (sec == alarm_sec) && (min == alarm_min) && (hour == alarm_hour)) begin
			o_alarm <= 1'b1 & i_alarm_en;
		end else begin
			o_alarm <= o_alarm & i_alarm_en;
		end
	end
end

endmodule

module	buzz(
		o_buzz,
		i_buzz_en,
		clk,
		rst_n);

output		o_buzz		;

input		i_buzz_en	;
input		clk		;
input		rst_n		;

parameter	C = 23889.10867	;
parameter	D = 21282.77228	;
parameter	E = 18960.79666 ;
parameter	F = 17896.60487	;
parameter	G = 15944.06058	;
parameter	A = 14204.54545	;
parameter	B = 12654.81265	;

wire		clk_bit		;
nco	u_nco_bit(	
		.o_gen_clk	( clk_bit	),
		.i_nco_num	( 25000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg	[4:0]	cnt		;
always @ (posedge clk_bit or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt <= 5'd0;
	end else begin
		if(cnt >= 5'd24) begin
			cnt <= 5'd0;
		end else begin
			cnt <= cnt + 1'd1;
		end
	end
end

reg	[31:0]	nco_num		;
always @ (*) begin
	case(cnt)
		5'd00: nco_num = E	;
		5'd01: nco_num = D	;
		5'd02: nco_num = C	;
		5'd03: nco_num = D	;
		5'd04: nco_num = E	;
		5'd05: nco_num = E	;
		5'd06: nco_num = E	;
		5'd07: nco_num = D	;
		5'd08: nco_num = D	;
		5'd09: nco_num = D	;
		5'd10: nco_num = E	;
		5'd11: nco_num = E	;
		5'd12: nco_num = E	;
		5'd13: nco_num = E	;
		5'd14: nco_num = D	;
		5'd15: nco_num = C	;
		5'd16: nco_num = D	;
		5'd17: nco_num = E	;
		5'd18: nco_num = E	;
		5'd19: nco_num = E	;
		5'd20: nco_num = D	;
		5'd21: nco_num = D	;
		5'd22: nco_num = E	;
		5'd23: nco_num = D	;
		5'd24: nco_num = C	;
	endcase
end

wire		buzz		;
nco	u_nco_buzz(	
		.o_gen_clk	( buzz		),
		.i_nco_num	( nco_num	),
		.clk		( clk		),
		.rst_n		( rst_n		));

assign		o_buzz = buzz & i_buzz_en;

endmodule

module	six_digit(
		out_seg,
		i_seg_hms,
		i_seg_timer,
		i_mode);

output	[41:0]	out_seg		;
input	[41:0]	i_seg_hms	;
input	[41:0]	i_seg_timer	;
input	[1:0]	i_mode		;

assign	out_seg = ( i_mode == 2'd3 ) ? i_seg_timer : i_seg_hms	;

endmodule

module	top(
		o_seg_enb,
		o_seg_dp,
		o_seg,
		o_alarm,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		clk,
		rst_n);

output	[5:0]	o_seg_enb	;
output		o_seg_dp	;
output	[6:0]	o_seg		;
output		o_alarm		;

input		i_sw0		;
input		i_sw1		;
input		i_sw2		;
input		i_sw3		;
input		clk		;
input		rst_n		;

wire		alarm_en	;
wire		sec_clk		;
wire		min_clk		;
wire		hour_clk	;
wire		a_sec_clk	;
wire		a_min_clk	;
wire		a_hour_clk	;
wire		max_hit_sec	;
wire		max_hit_min	;
wire		max_hit_hour	;

wire		timer_secc_clk	;
wire		timer_sec_clk	;
wire		timer_min_clk	;
wire		max_timer_secc	;
wire		max_timer_sec	;
wire		max_timer_min	;

wire		alarm		;
wire	[5:0]	min		;
wire	[5:0]	sec		;
wire	[4:0]	hour		;
wire	[1:0]	position	;

wire	[6:0]	timer_secc	;
wire	[5:0]	timer_min	;
wire	[5:0]	timer_sec	;

wire	[1:0]	six_dp		;

controller	u_controller(
			.o_mode			( six_dp	),
			.o_position		( position	),
			.o_alarm_en		( alarm_en	),
			.o_sec_clk		( sec_clk	),
			.o_min_clk		( min_clk	),
			.o_hour_clk		( hour_clk	),
			.o_alarm_sec_clk	( a_sec_clk	),
			.o_alarm_min_clk	( a_min_clk	),
			.o_alarm_hour_clk	( a_hour_clk	),
			.o_timer_secc_clk	( timer_secc_clk),
			.o_timer_sec_clk	( timer_sec_clk	),
			.o_timer_min_clk	( timer_min_clk	),
			.i_max_hit_sec		( max_hit_sec	),
			.i_max_hit_min		( max_hit_min	),
			.i_max_hit_hour		( max_hit_hour	),
			.i_max_timer_secc	( max_timer_secc),
			.i_max_timer_sec	( max_timer_sec	),
			.i_max_timer_min	( max_timer_min	),
			.o_start		( start		),
			.o_rst			( reset		),
			.i_sw0			( i_sw0		),
			.i_sw1			( i_sw1		),
			.i_sw2			( i_sw2		),
			.i_sw3			( i_sw3		),
			.clk			( clk		),
			.rst_n			( rst_n		));

hourminsec	u_hourminsec(	
			.o_sec			( sec		),
			.o_min			( min		),
			.o_hour			( hour		),
			.o_timer_secc		( timer_secc	),
			.o_timer_sec		( timer_sec	),
			.o_timer_min		( timer_min	),
			.o_max_hit_sec		( max_hit_sec	),
			.o_max_hit_min		( max_hit_min	),
			.o_max_hit_hour		( max_hit_hour	),
			.o_max_timer_secc	( max_timer_secc),
			.o_max_timer_sec	( max_timer_sec	),
			.o_max_timer_min	( max_timer_min	),
			.o_alarm		( alarm		),
			.i_mode			( six_dp	),
			.i_position		( position	),
			.i_sec_clk		( sec_clk	),
			.i_min_clk		( min_clk	),
			.i_hour_clk		( hour_clk	),
			.i_alarm_sec_clk	( a_sec_clk	),
			.i_alarm_min_clk	( a_min_clk	),
			.i_alarm_hour_clk	( a_hour_clk	),
			.i_timer_start		( start		),
			.i_timer_reset		( reset		),
			.i_timer_secc_clk	( timer_secc_clk),
			.i_timer_sec_clk	( timer_sec_clk	),
			.i_timer_min_clk	( timer_min_clk	),
			.i_alarm_en		( alarm_en	),
			.clk			( clk		),
			.rst_n			( rst_n		));

wire	[3:0]	sec_left	;
wire	[3:0]	sec_right	;

double_fig_sep	u0_dfs(
			.o_left			( sec_left	),
			.o_right		( sec_right	),
			.i_double_fig		( sec		));

wire	[3:0]	min_left	;
wire	[3:0]	min_right	;

double_fig_sep	u1_dfs(
			.o_left			( min_left	),
			.o_right		( min_right	),
			.i_double_fig		( min		));

wire	[3:0]	hour_left	;
wire	[3:0]	hour_right	;

double_fig_sep	u2_dfs(
			.o_left			( hour_left	),
			.o_right		( hour_right	),
			.i_double_fig		( hour		));

wire	[3:0]	t_secc_left	;
wire	[3:0]	t_secc_right	;

double_fig_sep	u3_dfs(
			.o_left			( t_secc_left	),
			.o_right		( t_secc_right	),
			.i_double_fig		( timer_secc	));

wire	[3:0]	t_sec_left	;
wire	[3:0]	t_sec_right	;

double_fig_sep	u4_dfs(
			.o_left			( t_sec_left	),
			.o_right		( t_sec_right	),
			.i_double_fig		( timer_sec	));

wire	[3:0]	t_min_left	;
wire	[3:0]	t_min_right	;

double_fig_sep	u5_dfs(
			.o_left			( t_min_left	),
			.o_right		( t_min_right	),
			.i_double_fig		( timer_min	));

wire	[6:0]	seg_sec_left	;
wire	[6:0]	seg_sec_right	;

fnd_dec		u0_fnd_dec(
			.o_seg			( seg_sec_left	),
			.i_num			( sec_left	));

fnd_dec		u1_fnd_dec(
			.o_seg			( seg_sec_right	),
			.i_num			( sec_right	));

wire	[6:0]	seg_min_left	;
wire	[6:0]	seg_min_right	;

fnd_dec		u2_fnd_dec(
			.o_seg			( seg_min_left	),
			.i_num			( min_left	));

fnd_dec		u3_fnd_dec(
			.o_seg			( seg_min_right	),
			.i_num			( min_right	));

wire	[6:0]	seg_hour_left	;
wire	[6:0]	seg_hour_right	;

fnd_dec		u4_fnd_dec(
			.o_seg			( seg_hour_left	),
			.i_num			( hour_left	));


fnd_dec		u5_fnd_dec(
			.o_seg			( seg_hour_right),
			.i_num			( hour_right	));

wire	[6:0]	seg_t_secc_left	;
wire	[6:0]	seg_t_secc_right;

fnd_dec		u6_fnd_dec(
			.o_seg			( seg_t_secc_right),
			.i_num			( t_secc_right));

fnd_dec		u7_fnd_dec(
			.o_seg			( seg_t_secc_left),
			.i_num			( t_secc_left	));

wire	[6:0]	seg_t_sec_left	;
wire	[6:0]	seg_t_sec_right	;

fnd_dec		u8_fnd_dec(
			.o_seg			( seg_t_sec_right),
			.i_num			( t_sec_right	));

fnd_dec		u9_fnd_dec(
			.o_seg			( seg_t_sec_left),
			.i_num			( t_sec_left	));

wire	[6:0]	seg_t_min_left	;
wire	[6:0]	seg_t_min_right	;

fnd_dec		u10_fnd_dec(
			.o_seg			( seg_t_min_right),
			.i_num			( t_min_right	));

fnd_dec		u11_fnd_dec(
			.o_seg			( seg_t_min_left),
			.i_num			( t_min_left	));

wire	[41:0]	six_digit_seg	;
wire	[41:0]	six_timer_seg	;

assign		six_digit_seg = { seg_hour_left, seg_hour_right, seg_min_left, seg_min_right, seg_sec_left, seg_sec_right };
assign		six_timer_seg = { seg_t_min_left, seg_t_min_right, seg_t_sec_left, seg_t_sec_right, seg_t_secc_left, seg_t_secc_right} ;

wire	[41:0]	out_seg		;

six_digit	u_six_digit(
			.out_seg		( out_seg	),
			.i_seg_hms		( six_digit_seg	),
			.i_seg_timer		( six_timer_seg	),
			.i_mode			( six_dp	));

led_disp	u_led_disp(
			.o_seg			( o_seg		),
			.o_seg_dp		( o_seg_dp	),
			.o_seg_enb		( o_seg_enb	),
			.i_six_digit_seg	( out_seg	),
			.i_six_dp		( six_dp	),
			.clk			( clk		),
			.rst_n			( rst_n		));

buzz		u_buzz(
			.o_buzz			( o_alarm	),
			.i_buzz_en		( alarm		),
			.clk			( clk		),
			.rst_n			( rst_n		));
endmodule
