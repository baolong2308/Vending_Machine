`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 09:09:36 PM
// Design Name: 
// Module Name: tb_vending_machiness2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module tb_vending_machiness2;

// Khai báo các tín hi?u ?? k?t n?i v?i mô-?un chính
reg clk;
reg button_pay;
reg button_view;
reg button_select;
reg button_reset;
reg switch_admin;
reg  [7:0] switchs;
wire [3:0] seven_segment1;
wire [3:0] seven_segment2;
wire [3:0] seven_segment3;
wire [3:0] seven_segment4;
wire led;

// Kh?i t?o mô-?un vending_machine
vending_machiness2 uut (
    .clk(clk),
    .button_pay(button_pay),
    .button_view(button_view),
    .button_select(button_select),
    .button_reset(button_reset),
    .switch_admin(switch_admin),
    .switchs(switchs),
    .seven_segment1(seven_segment1),
    .seven_segment2(seven_segment2),
    .seven_segment3(seven_segment3),
    .seven_segment4(seven_segment4),
    .led(led)
);

// T?o xung nh?p
always #5 clk = ~clk;

initial begin
    // Kh?i t?o tín hi?u
    clk = 0;
    button_view = 1;
    button_select = 1;
    switchs = 7'b0000000;
    button_reset = 1;
    // Gi?i phóng reset sau m?t th?i gian ng?n
    
    // Mô ph?ng m?t chu?i hành ??ng c?a ng??i dùng

    // 1. Xem s?n ph?m
    #20 button_view = 0;
    #10 button_view = 1;
    
    #20 button_view = 0;
    #10 button_view = 1;
    
    #20 button_view = 0;
    #10 button_view = 1;
    
    
    #20 button_view = 0;
    #10 button_view = 1;
    
    #20 button_view = 0;
    #10 button_view = 1;
    
    #20 button_view = 0;
    #10 button_view = 1;
    

    #20 button_select = 0;
    #10 button_select = 1;
    
    switchs = 7'b0000001; 
    
    #20 button_select = 0;
    #10 button_select = 1;     
    
    switchs = 7'b0000101; 
    
    #20 button_select = 0;
    #10 button_select = 1;
    
    switchs = 7'b1111111; 
    
    #20 button_select = 0;
    #10 button_select = 1;
    
     #20 button_select = 0;
    #10 button_select = 1;
    
     #20 button_view = 1;
    #10 button_view = 0;
    
    #20 button_view = 1;
    #10 button_view = 0;
    
    #20 button_view = 1;
    #10 button_view = 0;
    
//      #20 button_admin = 0;
//      #10 button_admin = 1;
        
//        switch = 1; 
        
//    #20 button_select = 0;
//    #10 button_select = 1;
        
//         switch0 = 0; 
//         switch1 = 0;
              
//    #20 button_select = 0;
//    #10 button_select = 1;   
         
//         switch0 = 1; 
//         switch1 = 1;
         
//     #20 button_select = 0;
//    #10 button_select = 1;  
    
//    #20 button_admin = 0;
//      #10 button_admin = 1;
      
//          #20 button_view = 0;
//    #10 button_view = 1;
    
//    #20 button_view = 0;
//    #10 button_view = 1;
    
//    #20 button_view = 0;
//    #10 button_view = 1;
    #100 $finish;
end

endmodule

