`timescale 1ns / 1ps
module RAM #( parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 12, DEPTH = 4096) (
    input wire                     clk,
    input wire                     wEn,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0]    dataIn,
    output reg [DATA_WIDTH-1:0]    dataOut = 0);
    
    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];
    
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            MemoryArray[i] <= 0;
        end
        /* Pauli XA */
        MemoryArray[1002] <= 32'd4096; /*1*/
        MemoryArray[1007] <= 32'd4096;
        MemoryArray[1008] <= 32'd4096;
        MemoryArray[1013] <= 32'd4096;
        
        /* Pauli YA */
        MemoryArray[1102] <= 32'd4294963200; /*-1*/
        MemoryArray[1107] <= 32'd4294963200;
        MemoryArray[1108] <= 32'd4096;
        MemoryArray[1113] <= 32'd4096;
        
        /* Pauli ZA */
        MemoryArray[1200] <= 32'd4096;
        MemoryArray[1205] <= 32'd4096;
        MemoryArray[1210] <= 32'd4294963200;
        MemoryArray[1215] <= 32'd4294963200;
        
        /* HA */
        MemoryArray[1300] <= 32'd2896; /*1/sqrt2*/
        MemoryArray[1302] <= 32'd2896;
        MemoryArray[1305] <= 32'd2896;
        MemoryArray[1307] <= 32'd2896;
        MemoryArray[1308] <= 32'd2896;
        MemoryArray[1310] <= 32'd4294964400; /*-1/sqrt2*/
        MemoryArray[1313] <= 32'd2896;
        MemoryArray[1315] <= 32'd4294964400;
        
        
        
        // if(MEMFILE > 0) begin
        //     $readmemh(MEMFILE, MemoryArray);
        // end
    end
    
    always @(posedge clk) begin
        if(wEn) begin
            MemoryArray[addr] <= dataIn;
        end else begin
            dataOut <= MemoryArray[addr];
        end
    end
endmodule
