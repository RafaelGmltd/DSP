module my_fir
#(parameter F=10)
(
input logic                clk,
input logic                rst,
input logic signed  [15:0] filter_in,
output logic signed [31:0] filter_out
    );
//
logic signed [15:0] shift_regs [0:16];
logic signed [15:0] coes       [0:16];
logic signed [31:0] mults      [0:16];
logic signed [31:0] psum       [0: 3];
logic signed [31:0] sum;

//shift_regs
always@(posedge clk,posedge rst)
  if(rst)
    for(int i=0;i<=16;i++)
     shift_regs[i]<=0;
  else
  begin
     shift_regs[0]<=filter_in;
     for(int i=0;i<16;i++)
       shift_regs[i+1]<=shift_regs[i];
  end
//coes
assign coes[0]= -17;
assign coes[1]=  62;
assign coes[2]=  456;
assign coes[3]=  1482;
assign coes[4]=  3367;
assign coes[5]=  6013;
assign coes[6]=  8880;
assign coes[7]=  11129;
assign coes[8]=  11983;
assign coes[9]=  11129;
assign coes[10]= 8880;
assign coes[11]= 6013;
assign coes[12]= 3367;
assign coes[13]= 1482;
assign coes[14]= 456;
assign coes[15]= 62;
assign coes[16]= -17;

//mults
always@(posedge clk,posedge rst)
  if(rst)
    for(int i=0;i<=16;i++)
      mults[i]<=0;
  else
  begin
    for(int i=0;i<=16;i++)
      mults[i]<=coes[i]*shift_regs[i]; 
  end

//psum
always@(posedge clk,posedge rst)
  if(rst)
     for(int i=0;i<4;i++)
       psum[i]<=0;
  else
       for(int i=0;i<4;i++)
        psum[i]<=mults[4*i]+mults[4*i+1]+mults[4*i+2]+mults[4*i+3];

//sum
always@(posedge clk,posedge rst)
  if(rst)
     sum<=0;
  else
    sum<=psum[0]+psum[1]+psum[2]+psum[3]+mults[16];
//
assign filter_out=(sum>>>F);
endmodule