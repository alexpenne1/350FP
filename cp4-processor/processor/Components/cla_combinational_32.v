module cla_combinational_32(P, G, c0, cout);

	input [7:0] P, G; // Comes from 8 cla_4's.
	input c0; // likely 0.
	output [7:0] cout; // c4, c8, c12, c16, c20, c24, c28, c32. These go back to cla_4's.
	
	// c4
	wire w40;
	and w40and(w40, P[0], c0);
	or cout4(cout[0], G[0], w40);
	
	// c8
	wire w80, w81;
	and w80and(w80, P[1], P[0], c0);
	and w81and(w81, P[1], G[0]);
	or cout8(cout[1], G[1], w80, w81);
	
	// c12
	wire w120, w121, w122;
	and w120and(w120, P[2], P[1], P[0], c0);
	and w121and(w121, P[2], P[1], G[0]);
	and w122and(w122, P[2], G[1]);
	or cout12(cout[2], G[2], w120, w121, w122);
	
	// c16
	wire w160, w161, w162, w163;
	and w160and(w160, P[3], P[2], P[1], P[0], c0);
	and w161and(w161, P[3], P[2], P[1], G[0]);
	and w162and(w162, P[3], P[2], G[1]);
	and w163and(w163, P[3], G[2]);
	or cout16(cout[3], G[3], w160, w161, w162, w163);
	
	// c20
	wire w200, w201, w202, w203, w204;
	and w200and(w200, P[4], P[3], P[2], P[1], P[0], c0);
	and w201and(w201, P[4], P[3], P[2], P[1], G[0]);
	and w202and(w202, P[4], P[3], P[2], G[1]);
	and w203and(w203, P[4], P[3], G[2]);
	and w204and(w204, P[4], G[3]);
	or cout20(cout[4], G[4], w200, w201, w202, w203, w204);
	
	// c24
	wire w240, w241, w242, w243, w244, w245;
	and w240and(w240, P[5], P[4], P[3], P[2], P[1], P[0], c0);
	and w241and(w241, P[5], P[4], P[3], P[2], P[1], G[0]);
	and w242and(w242, P[5], P[4], P[3], P[2], G[1]);
	and w243and(w243, P[5], P[4], P[3], G[2]);
	and w244and(w244, P[5], P[4], G[3]);
	and w245and(w245, P[5], G[4]);
	or cout24(cout[5], G[5], w240, w241, w242, w243, w244, w245);
	
	// c28
	wire w280, w281, w282, w283, w284, w285, w286;
	and w280and(w280, P[6], P[5], P[4], P[3], P[2], P[1], P[0], c0);
	and w281and(w281, P[6], P[5], P[4], P[3], P[2], P[1], G[0]);
	and w282and(w282, P[6], P[5], P[4], P[3], P[2], G[1]);
	and w283and(w283, P[6], P[5], P[4], P[3], G[2]);
	and w284and(w284, P[6], P[5], P[4], G[3]);
	and w285and(w285, P[6], P[5], G[4]);
	and w286and(w286, P[6], G[5]);
	or cout28(cout[6], G[6], w280, w281, w282, w283, w284, w285, w286);
	
	// c32
	wire w320, w321, w322, w323, w324, w325, w326, w327;
	and w320and(w320, P[7], P[6], P[5], P[4], P[3], P[2], P[1], P[0], c0);
	and w321and(w321, P[7], P[6], P[5], P[4], P[3], P[2], P[1], G[0]);
	and w322and(w322, P[7], P[6], P[5], P[4], P[3], P[2], G[1]);
	and w323and(w323, P[7], P[6], P[5], P[4], P[3], G[2]);
	and w324and(w324, P[7], P[6], P[5], P[4], G[3]);
	and w325and(w325, P[7], P[6], P[5], G[4]);
	and w326and(w326, P[7], P[6], G[5]);
	and w327and(w327, P[7], G[6]);
	or cout32(cout[7], G[7], w320, w321, w322, w323, w324, w325, w326, w327);
	
	
	
	

endmodule