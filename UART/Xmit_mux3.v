module Xmit_mux3(d0,d1,d2,sel,y);

   input d0;
   input d1;
   input d2;
   input [1:0]	     sel;
   output y;   

  assign y = sel[1] ? d2 : (sel[0] ? d1 : d0); 

endmodule
