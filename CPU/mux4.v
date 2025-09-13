module mux4
  #(parameter WIDTH = 8)
   (d0,d1,d2,d3,sel,y);

   input [WIDTH-1:0] d0;
   input [WIDTH-1:0] d1;
   input [WIDTH-1:0] d2;
   input [WIDTH-1:0] d3;
   input [1:0]	     sel;
   output [WIDTH-1:0] y;
	wire [WIDTH-1:0] wire1;
	wire [WIDTH-1:0] wire2;
	
	assign wire1 = sel[0] ? d1 : d0;
	assign wire2 = sel[0] ? d3 : d2;
	assign y = sel[1] ? wire2 : wire1;


 

endmodule
