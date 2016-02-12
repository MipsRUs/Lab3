
module rom2_tb;
  logic[31:0] input1;
  wire[31:0] dataOut1;
  rom2 L1     (.addr(input1),
                 .dataOut(dataOut1));
  initial begin
  input1 = 32'b00000000000000000000000000000000;
  #10;
  input1 = 32'b00000000000000000000000000000100;
  #10;
  input1 = 32'b00000000000000000000000000001000;
  #10;
  input1 = 32'b00000000000000000000000000001100;
  end
 endmodule 
