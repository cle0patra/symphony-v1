//+------------------------------------------------------------------+
//|                                           Symphony_TestOrder.mq4 |
//|                                                           Luke S |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#include <Symphony_Variables.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   vars.refreshIndicators(Symbol());
   ObjectCreate(0,"StopLoss",OBJ_HLINE,0,vars.getPRZStop(Period()));
  }
//+------------------------------------------------------------------+
