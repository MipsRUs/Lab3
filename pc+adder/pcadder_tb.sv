/***************************************************************/
// Copyright MIPS_R_US 2016 - All Rights Reserved 
// 
// File: processor_tb.sv
// Team: MIPS_R_US
// Members:
//		Stefan Cao (ID# 79267250)
//		Ting-Yi Huang (ID# 58106363)
//		Nehme Saikali (ID# 89201494)
//		Linda Vang (ID# 71434490)
//
// Description:
//		This is test bench for the processor
//
// History:
//		Date		Update Description		Developer
//	------------	-------------------		------------
//	1/23/2016		Created					TH, NS, LV, SC
//
/***************************************************************/

module pcadder_tb;
	
  timeunit 1ns;

  logic clk;
  logic rst;
  
pcadder L1(
          .clk(clk)
         ,.rst(rst)
         );

/*always begin
	#5 clk = 1;
	#5 clk = 0;
end
*/


initial begin

	rst = 1;
	#10 clk = 1;
	#10 clk = 0;
	#10 clk = 1;
	#10 clk = 0;
	rst = 0;
	#10 clk = 1;
	#10 clk = 0;
	#10 clk = 1;
	#10 clk = 0;
	#10 clk = 1;
	#10 clk = 0;
	#10 clk = 1;
	#10 clk = 0;
	rst = 1;
	#10 clk = 1;
	#10 clk = 0;
	#10 clk = 1;
	#10 clk = 0;
	#10 clk = 1;
	rst = 0;
	#10 clk = 0;
	#10 clk = 1;
	#10 clk = 0;
	//$finish

end
endmodule
    
