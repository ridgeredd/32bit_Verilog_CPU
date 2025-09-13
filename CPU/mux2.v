module mux2
  #(parameter WIDTH = 8)
   (d0,d1,sel,y);

   input [WIDTH-1:0] d0;
   input [WIDTH-1:0] d1;
   input 	     sel;
   output [WIDTH-1:0] y;
	
	genvar i;
	generate
		for (i = 0; i < WIDTH; i = i + 1) begin : gen_block
			
			assign y[i] = (~sel & d0[i]) | (sel & d1[i]);
		
		end
	endgenerate
	
	
   
endmodule
