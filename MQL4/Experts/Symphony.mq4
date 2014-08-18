//+------------------------------------------------------------------+
//|                                                     Symphony.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#include "../Include/Symphony_Sorcery.mqh"
#include "../Include/Symphony_OrderHandler.mqh"
#include "../Include/Symphony_Magic.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int tradeable_periods[4] = {PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4};
//------------------------------------
//   TODO:
//    > Work in Trade functionality  -  TODO
//       > Backtest                  -  TODO
//       > Set partial profit level  -  TODO
//         > Backtest                -  TODO
//    > Different colors for non-
//      optimal setups               -  TODO
//    > More verbose dashboard       -  TODO
//    > Write to file functionality  -  TODO
//    > Set up data for backtest     -  TODO
//    > LIVE TEST                    -  TODO
//
//
//
//
//
//----------------------------------------
SymphonySorcery * sorcery;
SymphonyIllustrator * painter;
SymphonyOrderHandler * order_handler;
SymphonyDefinitions * def;
SymphonyMagic * magic;
int active_period       = -1; // Period on which there is an active trade
int active_ticket       = -1; // Active ticket
int active_magic_number = -1; // Active magic # for active ticket (gives a lot of information about ticket)



int OnInit()
  {
//---
   sorcery = new SymphonySorcery();
   painter = new SymphonyIllustrator();
   magic   = new SymphonyMagic();
   def     = new SymphonyDefinitions();
   sorcery.refresh();
   
   //-----------------------------------------
   //    If there is an open order for the chart:
   //       1) Identify period and change chart
   //       2) Initialize the order handler
   //-------------------------------------------
   active_ticket = get_active_ticket(Symbol());
   if( active_ticket != -1){
      OrderSelect(active_ticket,SELECT_BY_TICKET);
      active_magic_number = OrderMagicNumber();
      active_period       = magic.get_period_by_magic_number(active_magic_number);
      ChartSetSymbolPeriod(ChartID(),Symbol(),active_period);
      order_handler = new SymphonyOrderHandler(active_ticket);
   }
   
   
   painter.draw_pattern(Period());
   EventSetTimer( 10 * 60 ); // Every ten minutes, generate an event
//---
   return(INIT_SUCCEEDED);
  }
//------------------------------------------------------------
//  Expert Timer Function
//------------------------------------------------------------
//   1) Process the pattern on the chart for a variety of error margins
void OnTimer(){
   double test_margins[5] = {0.1,0.15,0.2,0.35,0.5};
   
   bool pat_found = False;
   for(int p = 0; p < ArraySize(tradeable_periods); p++){
      for(int i = 0; i< ArraySize(test_margins); i++){
         sorcery.set_error_margin(test_margins[i]);
         if(sorcery.is_there_pattern(tradeable_periods[p])){
            Print("[ Symphony | OnTimer ] Found a valid pattern for ErrorMargin: %",DoubleToString(test_margins[i],2),
                  " On [ ",Symbol()," | ",def.standard_period_to_string(tradeable_periods[p]),"]");
            pat_found = True;
         }
      }
   }
   sorcery.set_error_margin(0.10); // Set margin back to default
   if(pat_found == False) Print("[ Symphony | OnTimer ] Found no patterns for any error margin on [",Symbol(),"]");

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
   sorcery.refresh();
   painter.draw_pattern(Period());
   
   
   //---------------------------------
   // SENTINEL
   //   BLOCK
   //-------------------------------------
   //  ... Keeps a running tab on the order. Reports Profit/Loss as it happens ...
   // Logic: If active_ticket is not -1, but get_active_ticket returns -1 we know the order was close recently
   
   if( active_ticket != -1 && get_active_ticket(Symbol()) == -1 ){
      double profit, partial_profit;
      int hist_ticket;
      hist_ticket = magic.get_historical_order_ticket_by_ticket(active_ticket);
      if( hist_ticket != -1){
         OrderSelect(hist_ticket,SELECT_BY_TICKET,MODE_HISTORY);
         partial_profit = OrderProfit();
      }
      OrderSelect(active_ticket,SELECT_BY_TICKET,MODE_HISTORY);
      profit = OrderProfit();
      Print("Total Profit: $",DoubleToString(profit + partial_profit,2));
      Print("[ Symphony | Sentinel ] Detected order closing. Partial Profit: $",DoubleToString(partial_profit,2),
             " Second Profit: $",DoubleToString(profit,2));
   }
   //---------------------------------------
   //  NEW 
   //     ORDER
   //        BLOCK
   //------------------------------------------   
   active_ticket = get_active_ticket(Symbol());
   //----> If there are no active trades....
   if( active_ticket == -1 ){
      // ... then find any valid patterns on tradeable periods (global)
      
      
      for( int i = 0; i < ArraySize(tradeable_periods); i++){
         if(sorcery.is_there_pattern( tradeable_periods[i] )){
            active_period = tradeable_periods[i];
            //--> If there is a pattern found, cycle through lower timeframes to see if the pattern matches.
            //       If so, change active_period to that of the lowest possible timeframe
            if( i != 0 ){
               
               for( int p = i - 1; p >= 0; p--) 
                  if(sorcery.is_there_pattern( tradeable_periods[p] ) )
                     active_period = tradeable_periods[p];
            }
            break;
         };
      };
      
      //------------------------------------
      //  Order Placement Block
      //-------------------------------------
      //... If there is a valid pattern on a tradeable period, place the order ...
      if( active_period != -1 ){
         double sl           = sorcery.get_prz(active_period);
         double tp           = sorcery.get_point(active_period,point_d);
         order_handler       = new SymphonyOrderHandler(sl,tp);
         active_ticket       = order_handler.order_send();
         active_magic_number = order_handler.get_magic_number();
         
         ChartSetSymbolPeriod(ChartID(),Symbol(),active_period);
      }
   
   //---------------------------------------
   //  OPEN 
   //     ORDER
   //        BLOCK
   //------------------------------------------   
   }else{ // If there is an open order
      double partial_retracement_level = sorcery.get_cd_retracement(active_period,0.26);
      
      //-------------------------------------------
      //  Partial Profit Block
      //--------------------------------------------
      //---- ... if this order has not yet taken partial profits, and there are enough lots to take partial profits ...
      
      double order_lots = magic.get_lots_by_ticket(active_ticket);
      if( magic.is_there_historical_order_match(active_ticket) == False && 
          order_lots > 0.01                   
         ){
         //----> Close partial lots if at the right level and set active_ticket to be the new ticket. 
         switch(sorcery.get_order_type(active_period)){
            case ORDER_TYPE_BUY: if( sorcery.ask_or_bid_close(ORDER_TYPE_BUY) >=  partial_retracement_level )
                                    active_ticket = order_handler.order_partial_close(active_ticket,get_lots_to_close(order_lots));
                                  
                                  break;
            case ORDER_TYPE_SELL: if( sorcery.ask_or_bid_close(ORDER_TYPE_SELL) <=  partial_retracement_level )
                                    active_ticket = order_handler.order_partial_close(active_ticket,get_lots_to_close(order_lots));
                                  break;
            default: Print("[ Symphony ] Error identifying order type on [",Symbol()," | ",
                           def.standard_period_to_string(active_period)," ] Last Error: ",ErrorDescription(GetLastError()));
         };
         //---> Set the stoploss to be breakeven from this point forward
         order_handler.order_set_breakeven_stop(active_ticket);
      };
   };
   //>>>>>>>>>>>>>>>>>>>>>>>>>>
   // Illustration Block
   //>>>>>>>>>>>>>>>>>>>>>>>>>>
   
   
   painter.draw_pattern(Period());
   
  }
//+------------------------------------------------------------------+

//#################################
//  FUNCTIONS
//#################################

//---------------------------
// get_active_ticket:
//    @note: For finding active trades on current chart
//    @param symbol: Symbol to look for active trades
//    @return: Ticket if one is found for symbol, -1 otherwise
//----------------------------------------
int get_active_ticket(string symbol){
   int t = -1;
   for( int i = 0; i < OrdersTotal(); i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if( OrderSymbol() == symbol ){
         if( t == -1 ) t = OrderTicket();
         else Print("[ Symphony ] Found multiple open orders for ",symbol);
      };
   };
   if( t == -1 ){ active_magic_number = -1; active_period = -1; } // Make sure other active variables are synced
   return(t);
};

//-------------------------------
// get_lots_to_close:
//    @param lots: Order lots
//    @return: Arbitrary lots to close
//--------------------------------

double get_lots_to_close(double base_lots){
   if     ( base_lots == 0.01 ) return(0.0);
   else if( base_lots == 0.02 ) return(0.01);
   else return( NormalizeDouble( base_lots / 3, 2 ) );
};
