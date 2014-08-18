//+------------------------------------------------------------------+
//|                                                   PlaceOrder.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#include "../Include/Symphony_Sorcery.mq4"
#include "../Include/Symphony_RiskManagement.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   double risk_level  = 0.02;
   
   SymphonySorcery * sorcery;
   SymphonyIllustrator * painter;
   SymphonyRiskManager * risk_manager;
   risk_manager = new SymphonyRiskManager();
   painter = new SymphonyIllustrator();
   sorcery = new SymphonySorcery();
   sorcery.refresh();
   painter.refresh();
   painter.draw_pattern(Period());
   
   double stop_loss = sorcery.get_prz(Period());
   double take_profit = sorcery.get_point(Period(),point_c);
   double lots = risk_manager.position_size(stop_loss,risk_level);
   int order_type = sorcery.get_order_type(Period());
   Print("[ Order Placed ] Placed order on ",Symbol()," ",SymphonyDefinitions::standard_period_to_string(Period()),
         " With StopLoss: ",DoubleToString(stop_loss,_Digits)," TakeProfit: ",DoubleToString(stop_loss,_Digits),
         " Lots: ",DoubleToString(lots,2));
   OrderSend(Symbol(),order_type,lots,sorcery.ask_or_bid(order_type),0,stop_loss,take_profit);
  }
//+------------------------------------------------------------------+
