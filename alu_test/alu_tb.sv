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

module alu_tb;

  logic ref_clk;
  logic reset;
  
processor L1(
          .Func_in(Func_in)
         ,.A_in(A_in)
         ,.B_in(B_in)
         ,.O_out(O_out)
         ,.Branch_out(Branch_out)
         );



initial begin

    A_in = 32b'00000000000000000000000000000001;
    B_in = 32b'00000000000000000000000000000011;
    
    #2 Func_in = 6b'000000;
    #2 Func_in = 6b'000010;

    #2 Func_in = 6b'000011;

    #2 Func_in = 6b'000100;

    #2 Func_in = 6b'000110;

    #2 Func_in = 6b'000111;

	$finish;

end
endmodule
    
