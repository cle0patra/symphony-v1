//+------------------------------------------------------------------+
//|                                        Test_CurrentOrderType.mq4 |
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
   
   Print("OrderType for [",Symbol(),"|",vars.stdPeriodToString(Period()),"] -> Order type is ",vars.typeToString(getOrderType(Period())));
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int getOrderType(int stdPeriod){

int testType; string testTypeString = "";
   if(vars.getPtC(stdPeriod)>vars.getPtD(stdPeriod))
      return(OP_BUY);
   else if(vars.getPtC(stdPeriod)<vars.getPtD(stdPeriod))
      return(OP_SELL);
   else return(-1);
   
} 