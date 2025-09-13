module mux3
  #(parameter WIDTH = 8)
   (d0,d1,d2,sel,y);

   input [WIDTH-1:0] d0;
   input [WIDTH-1:0] d1;
   input [WIDTH-1:0] d2;
   input [1:0]	     sel;
   output [WIDTH-1:0] y; 
	//wire [WIDTH-1.0] wire1;

	genvar i;
	generate
		for (i = 0; i < WIDTH; i = i + 1) begin : gen_block
			
			//assign wire1[i] <= sel[0] ? d1[i] : d0[i];
			assign y[i] = sel[1] ? d2[i] : (sel[0] ? d1[i] : d0[i]);
			
		
		end
	endgenerate	

endmodule
