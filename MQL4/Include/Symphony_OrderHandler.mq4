//+------------------------------------------------------------------+
//|                                    Symphony_OrderHandler.mq4.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property strict
#include "Symphony_Definitions.mq4"
#include "Symphony_Strings.mq4"
#include "Symphony_Magic.mq4"
#include "Symphony_RiskManagement.mq4"
#include "Symphony_Sorcery.mq4"
#include "stdlib.mqh"
#include "stderror.mqh"

class SymphonyOrderHandler
{
   int stdPeriod;
   string symbol;
   double stoploss;
   double takeprofit;
   string label;
   int ticket;
   int magic_number;
   SymphonyMagic symphony_magic;
   SymphonyStrings strings;
   SymphonyRiskManager risk_manager;
   SymphonySorcery h;
   double Risk;
   string orderHistoryFile;
   static double spread;
   public:
      //---> Constructors
         //--> Summons:
         //     1) Risk management instance
         //     2) Harmonics instance
      SymphonyOrderHandler(double stoploss,double takeProfit){
         this.stdPeriod  = Period();     this.symbol = Symbol();                 this.stoploss = stoploss;
         this.takeprofit = takeProfit;   this.Risk   = risk_manager.get_risk();  this.ticket   = -1;
         
      }
      SymphonyOrderHandler(int period, string symbol, double stoploss,double takeProfit){
         this.stdPeriod  =   period;          this.symbol = symbol;                  this.stoploss = stoploss;
         this.takeprofit = takeProfit;        this.Risk   = risk_manager.get_risk(); this.ticket   = -1;
         this.h.set_symbol(symbol);
      }
      //-------------------------
      //   This constructor will hook a trade in progress
      //-----------------------------------
      SymphonyOrderHandler(int ticket){
         this.ticket = ticket; this.Risk = risk_manager.get_risk();
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)){
            this.stoploss = OrderStopLoss();
            this.takeprofit = OrderTakeProfit();
            this.symbol = OrderSymbol();
         }
         else if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)){
            this.symbol = OrderSymbol();
            double profit = OrderProfit();
            Print("[ Symphony | Order Handler | Constructor[ticket] ] Constructor was given a ticket that was already closed on ",
                  this.symbol,". Profit: ",DoubleToString(profit,2));
         }
         else{ Print("[ Symphony | Order Handler ] Error. Ticket: ",this.ticket);}
         this.stdPeriod = this.symphony_magic.get_period_by_magic_number(OrderMagicNumber());
         this.h.set_symbol(this.symbol);
      }
   int order_send(){
      int type;
      if(this.stoploss>this.takeprofit)
         type = ORDER_TYPE_SELL;
      else if(this.stoploss<this.takeprofit)
         type = ORDER_TYPE_BUY;
      else {Print("[ Symphony | OrderHandler | OrderSend ] Encountered a problem with StopLoss: ",DoubleToString(this.stoploss,_Digits),
                 " and TakeProfit: ",DoubleToString(this.takeprofit,_Digits)," on ",this.symbol," | ",
                 strings.standard_period_to_string(stdPeriod));
                 return(-1);
                 }
  
      double openAt      = h.ask_or_bid(type);
      double lotSize     = risk_manager.position_size(this.stoploss, this.Risk); 
      this.spread        = MarketInfo(this.symbol,MODE_SPREAD);
      this.magic_number  = symphony_magic.get_magic_number(this.stdPeriod,this.symbol);                
      this.ticket        = OrderSend(this.symbol,type,lotSize,openAt,spread,this.stoploss,this.takeprofit,
                                      strings.standard_period_to_string(this.stdPeriod),this.magic_number,0,Blue);
      Print("(Potential order type) ",strings.type_to_string(type));
      Print("[ Symphony | Variables | OrderHandler | OrderSend ] Order placed. Risk Reward 1:",DoubleToString(MathAbs(openAt-this.takeprofit)/MathAbs(openAt-this.stoploss),2));
      return(this.ticket);
   };
   //---------------------------------
   //  order_close:
   //    > Closes order based on ticket. Resets order information if successful,
   //      Prints error if failure.
   //---------------------------------------------
   
   bool order_close(int ticket){
      OrderSelect(ticket,SELECT_BY_TICKET);
      if(OrderClose(ticket,OrderLots(),h.ask_or_bid_close(OrderType()),0,Red)){
         OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY);
         Print("[ Symphony | Variables | OrderHandler | OrderClose ] Order closed for ticket #",ticket,
               ". Profit: $",DoubleToString(OrderProfit(),2));
         this.stoploss = 0; this.takeprofit = 0; this.ticket = 0; this.stdPeriod = 0;
         return(true);
      }
      else{
         Print("[ Symphony | Variables | OrderHandler | OrderClose ] Failed to close order for ticket #",
               ticket,". Last Error: ",ErrorDescription(GetLastError()));
         return(false);
      }
   };
   //---------------------------------
   //  order_partial_close:
   //    @param ticket - order to partially close
   //    @param lotsToClose - order portion to close.
   //    @return newTicket - identifier of the new ticket.
   //    > Will not need a specified closing price, this condition should be triggered elsewhere.
   //      This being said, order will be closed at the relevant price (Ask or Bid)
   //      Prints error if failure.
   //---------------------------------------------
   int order_partial_close(int ticket,double lotsToClose){
      //----> Validation
      OrderSelect(ticket,SELECT_BY_TICKET);
      if(lotsToClose>OrderLots()){
         Print("[ Syphony | Variables | OrderHandler | OrderPartialClose ] Invalid lotsToClose: ",DoubleToString(lotsToClose,2)," with order lots = ",DoubleToString(OrderLots(),2));
         return(-1);
      }
      else if(lotsToClose==OrderLots()){
         Print("[ Syphony | Variables | OrderHandler | OrderPartialClose ] Lots to close is equal to OrderLots. Closing anyways.");
         this.order_close(ticket);
      }
      else{ //--> Else if the lots to close are valid
         int magic = OrderMagicNumber();
         int newTicket;
         if(OrderClose(ticket,OrderLots(),h.ask_or_bid_close(OrderType()),0,Red)){ 
            newTicket  = this.symphony_magic.get_ticket_by_magic_number(magic);
            OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY);
            Print("[ Symphony | Variables | OrderHandler | OrderPartialClose ] Partial closing successful for ticket #",ticket,
                   ". Partial Profit: $",DoubleToString(OrderProfit(),2),". The new ticket is: T#",newTicket);
            //----> Update OrderHandler ticket
            this.ticket = newTicket;
            return(newTicket);
         }
         else{ Print("[ Symphony | Variables | OrderHandler | OrderPartialClose ] Error taking partial profits for T#",ticket,
                     ". LotsToClose: ",DoubleToString(lotsToClose,2)," Last Error: ",ErrorDescription(GetLastError()));
                     return(-1);
         }
      }
   };
   
   //##########################
   //#  SETTER & GETTERS
   //##########################
   void   set_order_history_file(string path) {this.orderHistoryFile = path;};
   void   set_stoploss(double stop)           {this.stoploss = stop;};
   void   set_takeprofit(double tp)           {this.takeprofit=tp;};
   void   set_standard_period(int stdPeriod)  {this.stdPeriod = stdPeriod;};
   void   set_symbol(string s)                {this.symbol = symbol;};
   void   set_label(string l)                 {this.label = l;};
   
   double get_stoploss()                      {return(this.stoploss);};
   double get_takeprofit()                    {return(this.takeprofit);};
   int    get_standard_period()               {return(this.stdPeriod);};
   int    get_ticket()                        {return(this.ticket);};
   int    get_label()                         {return(this.label);};
   int    get_magic_number()                  {return(this.magic_number);};
   
};