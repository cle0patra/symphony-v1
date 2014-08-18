//+------------------------------------------------------------------+
//|                                      PrintCurrentRetracement.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""

#include <Symphony_Variables.mqh>
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   vars.refreshIndicators(Symbol());
   vars.printCurrentRetracement(Period());
//----
   return(0);
  }
//+------------------------------------------------------------------+