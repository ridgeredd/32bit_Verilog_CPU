module sign_extend
  #(parameter WIDTH = 8, SIGNS = 24)
  (a,SignExt);

   input [WIDTH-1:0] a;
   output [31:0] SignExt;
	
	assign SignExt = {{SIGNS{a[WIDTH-1]}}, a};

endmodule
