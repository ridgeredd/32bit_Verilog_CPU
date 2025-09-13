module register_n
  #(parameter WIDTH = 8)
   (reset,clock,enable,D,Q);

   input reset;
   input clock;
   input enable;
   input [WIDTH-1:0] D;
   output reg [WIDTH-1:0] Q;
	
	always @(posedge clock or posedge reset) begin
		if (reset) begin
			Q = 0;
		end
		else if (enable) begin
			Q = D;
		
		end
	end
   
endmodule
