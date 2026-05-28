module tb_good_mux;

reg i0,i1,sel;
wire y;

good_mux uut (
.i0(i0),
.i1(i1),
.sel(sel),
.y(y)
);

initial begin

$dumpfile("tb_good_mux.vcd");
$dumpvars(0,tb_good_mux);

i0=0; i1=0; sel=0;
#10;

i0=0; i1=1; sel=0;
#10;

i0=1; i1=0; sel=1;
#10;

i0=1; i1=1; sel=1;
#10;

$finish;

end

endmodule
