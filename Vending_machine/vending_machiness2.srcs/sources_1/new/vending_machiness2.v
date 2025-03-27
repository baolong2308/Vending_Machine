`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 07:03:21 PM
// Design Name: 
// Module Name: vending_machiness2
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


module vending_machiness2(
    input  clk,
    input  button_pay, 
    input  button_view, 
    input  button_select, 
    input  button_reset,
    input  switch_admin,
    input  [7:0 ]switchs,  
    output reg [3:0] seven_segment1, 
    output reg [3:0] seven_segment2,
    output reg [3:0] seven_segment3,
    output reg [3:0] seven_segment4,
    output reg led                    
);
    
    
    wire [2:0] selected_id;
    wire [2:0] selected_quantity;
     
    wire [2:0] id_for_update;
    wire [2:0] new_quantity;
    wire [7:0] new_price; 
    
    wire valid_id;
    wire valid_quantity;
    wire [7:0] total_price;  
    wire [7:0] total_money;
    wire enough_money_flag;
    wire [7:0] remaining_money;
    
    reg [2:0] product_inventory [0:7];
    reg [4:0] product_price [0:7];
    reg [12:0] state;
    reg [2:0] current_product; 
    reg [31:0] delay_counter;  
    reg [12:0]temp_state;
    
    localparam IDLE = 13'b1000000000000;
    localparam SELECT_ID = 13'b0100000000000;
    localparam SELECT_QUANTITY = 13'b0010000000000;
    localparam CHECK_ID = 13'b0001000000000;
    localparam CHECK_QUANTITY = 13'b0000100000000;
    localparam CALCULATE = 13'b0000010000000;
    localparam PAYMENT = 13'b0000001000000;
    localparam DELIVERY = 13'b0000000100000;
    localparam ERROR = 13'b0000000010000;   
    localparam ADMIN_UPDATE_ID = 13'b0000000001000; 
    localparam ADMIN_UPDATE_QUANTITY = 13'b0000000000100;
    localparam ADMIN_UPDATE_PRICE = 13'b0000000000010;
    localparam INSERT_MONEY = 13'b0000000000001;    
    
//        function [6:0] seven_segment_encode;
//        input [3:0] value;
//        case (value)
//            4'd0: seven_segment_encode = 7'b1000000;  // S? 0
//            4'd1: seven_segment_encode = 7'b1111001;  // S? 1
//            4'd2: seven_segment_encode = 7'b0100100;  // S? 2
//            4'd3: seven_segment_encode = 7'b0110000;  // S? 3
//            4'd4: seven_segment_encode = 7'b0011001;  // S? 4
//            4'd5: seven_segment_encode = 7'b0010010;  // S? 5
//            4'd6: seven_segment_encode = 7'b0000010;  // S? 6
//            4'd7: seven_segment_encode = 7'b1111000;  // S? 7
//            4'd8: seven_segment_encode = 7'b0000000;  // S? 8
//            4'd9: seven_segment_encode = 7'b0010000;  // S? 9
//            default: seven_segment_encode = 7'b0001110; // T?t LED
//        endcase
//    endfunction
    
    initial begin
        product_inventory[3'b000] = 3'd5;
        product_inventory[3'b001] = 3'd5;
        product_inventory[3'b010] = 3'd5;
        product_inventory[3'b011] = 3'd5;
        product_inventory[3'b100] = 3'd5;
        product_inventory[3'b101] = 3'd5;
        product_inventory[3'b110] = 3'd5;
        product_inventory[3'b111] = 3'd5;
          
        product_price[3'b000] = 5'd10;
        product_price[3'b001] = 5'd10; 
        product_price[3'b010] = 5'd10; 
        product_price[3'b011] = 5'd10; 
        product_price[3'b100] = 5'd10; 
        product_price[3'b101] = 5'd10;
        product_price[3'b110] = 5'd10; 
        product_price[3'b111] = 5'd10; 
        
        current_product = 3'b000;  
        state = IDLE;
        delay_counter = 0;
    end
    
    
    input_moduless2 input_handle_id(.clk(clk), .switchs(switchs[2:0]),
    .enable(SELECT_ID[11]),
    .id_or_quantity(selected_id)
    );
    
    input_moduless2 input_handle_quantity(.clk(clk), .switchs(switchs[2:0]),
    .enable(SELECT_QUANTITY[10]), 
    .id_or_quantity(selected_quantity)
    );
    
     input_moduless2 input_handle_admin_update_id(.clk(clk), .switchs(switchs[2:0]),
    .enable(ADMIN_UPDATE_ID[3]), 
    .id_or_quantity(id_for_update)
    );
    
    input_moduless2 input_handle_admin_update_quantity(.clk(clk), .switchs(switchs[2:0]),
    .enable(ADMIN_UPDATE_QUANTITY[2]), 
    .id_or_quantity(new_quantity)
    );
    
    
    check_moduless2 check(.selected_id(selected_id), 
                       .selected_quantity(selected_quantity),
                       .inventory_id(product_inventory[selected_id]),
                       .valid_id(valid_id),
                       .valid_quantity(valid_quantity));
                       
     calculate_moduless2 calculate(.selected_quantity(selected_quantity),
                               .price_id(product_price[selected_id]),
                               .total_price(total_price));
                               
     insert_money_moduless2 insert_money_payment(.clk(clk), .switchs(switchs),
     .enable(INSERT_MONEY[0]),
     .user_money_or_new_price(total_money)
     );
     
      insert_money_moduless2 insert_money_admin_update_price(.clk(clk), .switchs(switchs),
     .enable(ADMIN_UPDATE_PRICE[1]),
     .user_money_or_new_price(new_price)
     );
     
    payment_moduless2 payment(.clk(clk), .total_price(total_price),
    .total_money(total_money),
    .enough_money_flag(enough_money_flag),
    .remaining_money(remaining_money)
    );                         
     
//    reg button_view_prev;
//    reg button_select_prev;
//    reg button_pay_prev;
//    reg button_reset_prev; 
    always@(posedge clk or negedge button_reset) begin
        if(!button_reset) begin    
        state <= IDLE;
        current_product <= 3'b000;
        end
    end
    
    
    

    always @(posedge clk ) begin
//        button_view_prev <= button_view;
//        button_select_prev <= button_select;
//        button_pay_prev <= button_pay;
//        button_reset_prev <= button_reset;
            //temp_state <= state;
            case(state)
                IDLE: begin
                    led <= 1'b0;
//                    seven_segment1 <= seven_segment_encode(current_product);
//                    seven_segment2 <= seven_segment_encode(product_inventory[current_product]);
//                    seven_segment3 <= seven_segment_encode(product_price[current_product] / 10);  
//                    seven_segment4 <= seven_segment_encode(product_price[current_product] % 10); 

                    seven_segment1 <= current_product;
                    seven_segment2 <= product_inventory[current_product];
                    seven_segment3 <= product_price[current_product] / 4'd10;  
                    seven_segment4 <= product_price[current_product] % 4'd10; 
                
                    if ( !button_view) begin
                        current_product <= current_product + 1;
                        if (current_product == 3'b111) begin
                            current_product <= 3'b000;  
                        end
                    end
                    
                    if ( !button_select) begin
                        state <= SELECT_ID;  
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                end
                
                SELECT_ID: begin
//                    seven_segment1 <= seven_segment_encode(4'd0);
//                    seven_segment2 <= seven_segment_encode(4'd0);
//                    seven_segment3 <= seven_segment_encode(4'd0);  
//                    seven_segment4 <= seven_segment_encode(selected_id);

                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= selected_id; 
                    
                    if ( !button_select) begin
                        state <= CHECK_ID;  
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                end
                
                CHECK_ID: begin
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= selected_id;
                    if (valid_id) begin
                        state <= SELECT_QUANTITY;  
                    end else begin
                        state <= ERROR;  
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                end
                
                 SELECT_QUANTITY: begin
//                    seven_segment1 <= seven_segment_encode(4'd0);
//                    seven_segment2 <= seven_segment_encode(4'd0);
//                    seven_segment3 <= seven_segment_encode(4'd0);  
//                    seven_segment4 <= seven_segment_encode(selected_quantity);

                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= selected_quantity; 
                    
                    if ( !button_select) begin
                        state <= CHECK_QUANTITY;  
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                end       
                        
                
                    
                 CHECK_QUANTITY: begin
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= selected_quantity; 
                    if(valid_quantity) begin
                        state <= CALCULATE;
                    end else begin
                        state <= ERROR;
                    end
                 
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                end
                CALCULATE: begin
//                    seven_segment1 <= seven_segment_encode(4'd0);
//                    seven_segment2 <= seven_segment_encode(4'd0);
//                    seven_segment3 <= seven_segment_encode(total_price / 10);  
//                    seven_segment4 <= seven_segment_encode(total_price % 10);  

                    seven_segment1 <= 4'd0;
                    seven_segment2 <= total_price / 100;
                    seven_segment3 <= (total_price % 100) / 10;  
                    seven_segment4 <= total_price % 10; 
                    
                    if( !button_select) begin
                    state <= INSERT_MONEY;
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                    
                end
                INSERT_MONEY: begin
//                    seven_segment1 <= seven_segment_encode(4'd0);
//                    seven_segment2 <= seven_segment_encode(4'd0);
//                    seven_segment3 <= seven_segment_encode(total_money / 10);  
//                    seven_segment4 <= seven_segment_encode(total_money % 10);  
             
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= total_money / 100;
                    seven_segment3 <= (total_money % 100) / 10;  
                    seven_segment4 <= total_money % 10; 
                    
                    if( !button_pay) begin
                    state <= PAYMENT;
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                    
                    end
                PAYMENT: begin
                
                    if (enough_money_flag) begin
                        state <= DELIVERY; 
                    end
                    else begin
                        state <= ERROR;
                    end
                    
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                end
                
                DELIVERY: begin
                        led <= 1'b1;
//                        seven_segment1 <= seven_segment_encode(4'd0);
//                        seven_segment2 <= seven_segment_encode(4'd0);
//                        seven_segment3 <= seven_segment_encode(remaining_money / 10);
//                        seven_segment4 <= seven_segment_encode(remaining_money % 10); 

                    seven_segment1 <= 4'd0;
                    seven_segment2 <= remaining_money / 100;
                    seven_segment3 <= (remaining_money % 100) / 10;  
                    seven_segment4 <= remaining_money % 10;  
                        
                        if (delay_counter < 500000000) begin
                            delay_counter <= delay_counter + 1;
                            end
                        else begin
                            product_inventory[selected_id] <= product_inventory[selected_id] - selected_quantity; 
                            state <=IDLE;
                            led <= 1'b0;
                            delay_counter <= 0;
                            current_product <= 3'b000; 
                        end 
                     if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                end
                ERROR: begin
                        seven_segment1 <= 4'd9; // F
                        seven_segment2 <= 4'd9; // F
                        seven_segment3 <= 4'd9; // F
                        seven_segment4 <= 4'd9; // F
                        
                        if (delay_counter < 500000000) begin
                            delay_counter <= delay_counter + 1;
                            end
                        else begin
                            state <=IDLE;
                            delay_counter <= 0;
                            current_product <= 3'b000; 
                        end 
                    if(switch_admin) begin
                        state <= ADMIN_UPDATE_ID;
                    end
                end
                ADMIN_UPDATE_ID: begin
                        led <= 1'b1;
//                        seven_segment1 <= seven_segment_encode(4'd0); 
//                        seven_segment2 <= seven_segment_encode(4'd0); 
//                        seven_segment3 <= seven_segment_encode(4'd0); 
//                        seven_segment4 <= seven_segment_encode(id_for_update); 
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= id_for_update;
       
                        if( !button_select) begin
                                state <= ADMIN_UPDATE_QUANTITY;
                        end
                        
                        if(!switch_admin)begin
                            state <= IDLE;
                            led <= 1'b0;
                        end
                end
                 ADMIN_UPDATE_QUANTITY: begin
                        led <= 1'b1;
//                        seven_segment1 <= seven_segment_encode(4'd0); 
//                        seven_segment2 <= seven_segment_encode(4'd0); 
//                        seven_segment3 <= seven_segment_encode(4'd0); 
//                        seven_segment4 <= seven_segment_encode(new_quantity); 
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= 4'd0;  
                    seven_segment4 <= new_quantity;
       
                        if( !button_select) begin
                                product_inventory[id_for_update] <= new_quantity;
                                state <= ADMIN_UPDATE_PRICE;
                        end
                        
                        if(!switch_admin)begin
                            state <= IDLE;
                            led <= 1'b0;
                        end
                end
                 ADMIN_UPDATE_PRICE: begin
                        led <= 1'b1;
//                        seven_segment1 <= seven_segment_encode(4'd0); 
//                        seven_segment2 <= seven_segment_encode(4'd0); 
//                        seven_segment3 <= seven_segment_encode(new_price / 10); 
//                        seven_segment4 <= seven_segment_encode(new_price % 10); 
                    seven_segment1 <= 4'd0;
                    seven_segment2 <= 4'd0;
                    seven_segment3 <= new_price / 10;  
                    seven_segment4 <= new_price % 10;
       
                        if( !button_select) begin
                                product_price[id_for_update] <= new_price;
                                state <= ADMIN_UPDATE_ID;
                        end
                        
                        if(!switch_admin)begin
                           
                            led <= 1'b0;
                            current_product <= 3'b000;
                            state <= IDLE;
                        end
                end
                default: state <= IDLE;
            endcase
        end
endmodule