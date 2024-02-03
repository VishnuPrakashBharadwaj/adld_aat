module FIFObuffer_tb;

 reg clk;
 reg rst;
 reg en;
 reg RD;
 reg WR;
 reg [7:0] dataIN;

 wire [7:0] dataOUT;
 wire FULL_n;
 wire EMPTY_n;

 FIFO16_8bit dut (.clk(clk),.rst(rst),.en(en),.RD(RD),.WR(WR),.dataIN(dataIN),.dataOUT(dataOUT),.FULL_n(FULL_n),.EMPTY_n(EMPTY_n));

 initial
    begin
        clk  = 1'b0;
        dataIN  = 8'd0;
        RD  = 1'b0;
        WR  = 1'b0;
        en  = 1'b0;
        rst  = 1'b1;
    #20;        
        en  = 1'b1;
        rst  = 1'b1;
    #20;
        rst  = 1'b0;
        WR  = 1'b1;
    #20;
        dataIN  = 8'd1;
    #10;
        dataIN  = 8'd2;
    #10;
        dataIN  = 8'd3;
    #10;
        dataIN  = 8'd4;
    #20;
        WR = 1'b0;
        RD = 1'b1;
    #3;
        dataIN = 8'd5;
    #7;
        WR = 1'b1;
    #10;
        dataIN = 8'd6;
    #10;
        dataIN = 8'd7;
    #12;
        WR = 1'b0;       
    #100 $finish;
    end 

always #5 clk = ~clk;    

initial
    begin
    $dumpfile("FIFO_buff.vcd");
    $dumpvars;
    end

endmodule
