module FIFO16_8bit(
    input clk, // clock
    input rst, // reset
    input en, // enable
    input RD, // read signal
    input WR, // write signal
    input [7:0] dataIN, // incoming data
    output reg [7:0] dataOUT, // outgoing data
    output FULL_n, // active low memory full indicator - can't write
    output EMPTY_n // active low memory empty indicator - can't read
    );
    
    reg [7:0] data[0:15]; // FIFO registers - 16 reg of 8-bit each
    reg [3:0] count; // FIFO internal counter
    integer i; // Variable for iteration through 16 regs
    
    assign FULL_n = ~(count == 4'd15); // indicate FULL memory to deny WRITE - active low
    assign EMPTY_n = ~(count == 4'd0); // indicate EMPTY memory to deny READ - active low
    
    always@(posedge clk)
        begin
// if reset
            
            if(rst)
            begin
                count<=4'd0; // counter is initialized/reset to 0
                
                for(i=0; i<=15; i=i+1)
                data[i]<=8'bz; // FIFO regs are cleared
            end
            
//if reset is off
            
            else
            begin
                case({RD,WR})
                // if both read and write are disabled
                2'b00: begin
                        dataOUT<=dataOUT; // previously read data retained
                        
                        for(i=0;i<=14;i=i+1)
                        data[i]<=data[i]; // no data shifts
                        
                        count<=count; // count retained
                       end
                
                // if only write is enabled
                2'b01: begin
                        dataOUT<=dataOUT; // previously read data retained
                        data[count]<=FULL_n&&en?dataIN:data[count]; // data[count] is written dataIN if enabled and not full
                        count<=FULL_n&&en?count+1:count; // count is increased if enabled and not full
                       end
                
                // if only read is enabled
                2'b10: begin
                        dataOUT<=EMPTY_n&&en?data[0]:8'bz; // data[0] is read if enabled and not empty
                        
                        for(i=0;i<=14;i=i+1)
                        data[i]<=EMPTY_n&&en?data[i+1]:data[i]; // data is shifted to lower address if enabled and not empty
                        
                        data[15]<=8'bz; // highest address cleared
                        count<=EMPTY_n&&en?count - 1:count; // count reduced if enabled and not empty
                       end       
                
                // if both read and write are enabled
                2'b11: begin 
                        dataOUT<=EMPTY_n&&en?data[0]:8'bz; // data[0] is read if enabled and not empty
                        
                        for(i=0;i<=14;i=i+1)
                        data[i]<=EMPTY_n&&en?data[i+1]:data[i]; // data is shifted to lower address if enabled and not empty
                        
                        data[15]<=8'bz; // highest address cleared
                        data[count-1]<=FULL_n&&en?dataIN:data[count]; // data[count] is written dataIN if enabled and not full
                        count<=count; // count is increased if enabled and not full
                       end
                
                default: begin
                          dataOUT<=dataOUT;
                          count<=count;
                          
                          for(i=0;i<=14;i=i+1)
                          data[i]<=data[i]; // no data shifts
                         end
                endcase 
            end
        end
endmodule
