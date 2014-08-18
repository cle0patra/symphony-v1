//+------------------------------------------------------------------+
//|                                             Symphony_Strings.mqh |
//|                                                           Luke S |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#include "Symphony_Definitions.mqh"

//---------------------------
//  SymphonyStrings
//   > Class for pretty printing
//---------------------------

class SymphonyStrings
{
   
   period_schema schema;
   public:
      string period_to_string(int period){
            switch(period){
                  case schema.periodM1: return("PERIOD_M1");
                  case schema.periodM5: return("PERIOD_M5");
                  case schema.periodM15: return("PERIOD_M15");
                  case schema.periodM30: return("PERIOD_M30");
                  case schema.periodH1: return("PERIOD_H1");
                  case schema.periodH4: return("PERIOD_H4");
                  case schema.periodD1: return("PERIOD_D1");
                  default:{ string info;
                           info = StringConcatenate(info,"[ Symphony | Strings ] PERIOD UNDEFINED. periodToString() [",period,"] Error: ",GetLastError());
                           return(info);
                           };
                  }
         };
         string standard_period_to_string(int period){
            switch(period){
                  case PERIOD_M1: return("PERIOD_M1");
                  case PERIOD_M5: return("PERIOD_M5");
                  case PERIOD_M15: return("PERIOD_M15");
                  case PERIOD_M30: return("PERIOD_M30");
                  case PERIOD_H1: return("PERIOD_H1");
                  case PERIOD_H4: return("PERIOD_H4");
                  case PERIOD_D1: return("PERIOD_D1");
                  default: {string info;
                           info = StringConcatenate(info,"[ Symphony | Strings ] PERIOD UNDEFINED. stdPeriodToString() [",period,"] Error: ",GetLastError());
                           return(info);};
            }
                  
         };
         string type_to_string(int t){
            if(t==ORDER_TYPE_BUY) return("ORDER_TYPE_BUY");
            else if(t==ORDER_TYPE_BUY) return("ORDER_TYPE_SELL");
            else if(t==-1) return("Error_Type");
            else return("No Type");
         };
};