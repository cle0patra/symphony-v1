//+------------------------------------------------------------------+
//|                                          findCurrentPatterns.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""
#include <Symphony_Variables.mqh>
#include <Symphony_Definitions.mqh>
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
  //---- Search Policy
  //    1) True - Search only major pairs
  //    2) False - Search all pairs
  
  bool onlyMajors = true;
//----
    string syms[] = {"EURUSD","GBPUSD","USDJPY",
                     "USDCHF","AUDUSD","USDCAD", 
                     "EURCHF","EURGBP","EURAUD", // symbols with USD as 
                     "EURJPY","GBPNZD","GBPAUD","AUDNZD", // conversion pair's counter currency
                     "EURNZD","EURNZD","USDHKD"
                     "GBPJPY","CHFJPY","USDCZK" // symbols with USD as 
                    "GBPCHF","EURCAD","AUDCAD", // conversion pair's base currency
                    "AUDJPY","CADJPY","NZDJPY",
                    "GBPCAD","EURSEK","EURNOK",
                    "AUDCHF","EURPLN","EURCZK",
                    "EURDKK","GBPSEK","NOKJPY",
                    "SEKJPY","SGDJPY","HKDJPY",
                    "ZARJPY","EURTRY","NZDCHF",
                    "CADCHF","NZDCAD","CHFSEK",
                    "CHFNOK","EURHUF","USDTRY",
                    "USDZAR","USDMXN","USDSEK",
                    "USDPLN","USDHUF","USDDKK",
                    "USDSGD","USDRUB","USDNOK",
                    };
   string messages[55];
   
   int limit;
   if(onlyMajors)
      limit = 6;
   else limit = ArraySize(syms);
   int msgCnt = 0; string msg = "";
   for(int i=0;i<limit;i++){
      vars.refreshIndicators(syms[i]);
      for(int p=0;p<7;p++){
         int stdPeriod = vars.getStdPeriod(p);
         if(vars.getZZ(stdPeriod)==vars.getPtD(stdPeriod)){
            if(msg=="") 
               msg = StringConcatenate("Found a setup for ",syms[i]," for period(s) ",vars.periodToString(p));
            else msg = StringConcatenate(msg,", ",vars.periodToString(p));
          }
            
      }
      //----- if we found some patterns, add to message block
      if(msg!=""){
         messages[msgCnt] = msg; 
         msg = ""; msgCnt++;
      }
            
   }
   //-------- Print found patterns
   if(messages[0]=="") 
      Print("No patterns found");
   for(int m=0;m<msgCnt;m++)
      Alert(messages[m]);
//----
   return(0);
  }
//+------------------------------------------------------------------+


bool inRange(int stdPeriod){
   switch(vars.getType(stdPeriod)){
      case OP_BUY: if(Close[0]>vars.getPRZLow(stdPeriod) && Close[0]<vars.getRetracement(stdPeriod,0.236)) return(true);
                   else return(false);
      case OP_SELL: if(Close[0]<vars.getPRZHigh(stdPeriod) && Close[0]>vars.getRetracement(stdPeriod,0.236)) return(true);
                   else return(false);
      default: return(false);
   }
}