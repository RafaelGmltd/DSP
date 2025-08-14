`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2024 10:15:37 PM
// Design Name: 
// Module Name: fir_moving_avg_filter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module fir_moving_avg_filter
#(
	parameter AVE_DATA_NUM = 5'd8,
	parameter AVE_DATA_BIT = 5'd3
)
(
	input              reset_n,
	input              clk,
	input      [15 :0] noisy,
	output reg [15 :0] filtered_scaled,
	output reg [15 :0] noisy_scaled
);


reg [15:0] data_reg [AVE_DATA_NUM-1:0];
reg [7 :0] temp_i;

always @ (posedge clk or negedge reset_n)
if(!reset_n)
	for (temp_i=0; temp_i<AVE_DATA_NUM; temp_i=temp_i+1)
		data_reg[temp_i] <= 'd0;
else
begin
	data_reg[0] <= noisy;
	for (temp_i=0; temp_i<AVE_DATA_NUM-1; temp_i=temp_i+1)
		data_reg[temp_i+1] <= data_reg[temp_i];
end
reg [15:0] sum;

always @ (posedge clk or negedge reset_n)
if (!reset_n)
	sum <= 'd0;
else
	sum <= sum + noisy - data_reg[AVE_DATA_NUM-1]; //Change the oldest data to the latest input data

//assign filtered_scaled = sum << AVE_DATA_BIT;  //Shift 3 to the right is equivalent to ÷8

always @(posedge clk)
  begin
    noisy_scaled    <= noisy;
    filtered_scaled <= sum ;
  end 

endmodule