//+------------------------------------------------------------------+
//|                                         MagicNumberManagment.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""

#define NUMBER_OF_MN_SYMBOLS 58
#include <stdlib.mqh>
#include <stderror.mqh> 
#include <Symphony_Definitions.mqh>
int Limit = 1000;

string magicID[] = {"EURUSD","AUDUSD","NZDUSD",
                     "USDJPY","USDCHF","GBPUSD",
                     "USDCAD","USDSGD","USDTRY",
                     "USDSEK","USDMXN","USDZAR",
                     "USDNOK","USDDKK","USDXAU",
                     "USDXAG","USDPLN","USDHKD",
                     "USDRUB","USDHUF","CHFNOK",
                     "EURCHF","EURGBP","EURAUD", // symbols with USD as 
                     "GBPNZD","GBPAUD","AUDNZD", // conversion pair's counter currency
                     "EURNZD","EURNZD","EURJPY",
                    "GBPJPY","CHFJPY","EURHUF",// symbols with USD as 
                    "GBPCHF","EURCAD","AUDCAD", // conversion pair's base currency
                    "AUDJPY","CADJPY","NZDJPY",
                    "GBPCAD","EURSEK","EURNOK",
                    "AUDCHF","EURPLN","EURCZK",
                    "EURDKK","GBPSEK","NOKJPY",
                    "SEKJPY","SGDJPY","HKDJPY",
                    "ZARJPY","EURTRY","NZDCHF",
                    "CADCHF","NZDCAD","CHFSEK",
                    "USOil"};
   string magicVal[] = {"1001","1002","1003","1004", //needs support for noncurrencies
                    "1005","1006","1007","1008",
                    "1009","1010","1011","1012",
                    "1013","1014","1015","1016",
                    "1017","1018","1019","1020",
                    "1021","1022","1023","1024",
                    "1025","1026","1027","1028",
                    "1029","1030","1031","1032",
                    "1033","1034","1035","1036",
                    "1037","1038","1039","1040",
                    "1041","1042","1043","1044",
                    "1045","1046","1047","1048",
                    "1049","1050","1051","1052",
                    "1053","1054","1055","1056",
                    "1057","1058"};

//--------------------------------
//   Expert Settings Policy: 
//      -> expertName = Name of the expert to be demarced in the magic number. Can be changed with setter
//          By default, latest version of Symphony expert
//---------------------------------

string expertName = "Symphony_v1";
void magic.setExpertName(string expert){expertName = expert;}
//---------------------------------------------------
//
//                       Usage:
//   1) Period in standard format (PERIOD_X)
//   2) Symbol to be traded on     
//
//---------------------------------------------------           
int magic.getMagicNumber(int period, string symbol){
   int Period_ID;
   switch(period)
    {
        case PERIOD_MN1: Period_ID = 9; break;
        case PERIOD_W1:  Period_ID = 8; break;
        case PERIOD_D1:  Period_ID = 7; break;
        case PERIOD_H4:  Period_ID = 6; break;
        case PERIOD_H1:  Period_ID = 5; break;
        case PERIOD_M30: Period_ID = 4; break;
        case PERIOD_M15: Period_ID = 3; break;
        case PERIOD_M5:  Period_ID = 2; break;
        case PERIOD_M1:  Period_ID = 1; break;
    }
    //.... magicNum += PeriodID
   string magicNum = StringConcatenate("",(Period_ID*10));
   
   //--------------
   // Cardinal Policy:
   //  -> Charts can have up to 4 orders with unique magic numbers
   //  -> Modify if more are needed
   //-------------------
   int magicNumber = 0;
   for(int i=0;i<NUMBER_OF_MN_SYMBOLS;i++){
      //one is a tag used to identify different orders on the same chart. Will be changed if there are other orders open
      if(symbol==magicID[i]) 
         magicNum = StringConcatenate(magicNum,magicVal[i],"1"); 
   }
   if(StringLen(magicNum)==7){
      for(int q=0; q<OrdersTotal();q++){
         OrderSelect(q,SELECT_BY_POS,MODE_TRADES);
         if(magicNum==DoubleToStr(OrderMagicNumber(),0)){
            magicNum = StringConcatenate(StringSubstr(magicNum,0,6),"2");
            }
         else if(DoubleToStr(OrderMagicNumber(),0) == StringConcatenate(StringSubstr(magicNum,0,6),"2")){
            magicNum = StringConcatenate(StringSubstr(magicNum,0,6),"3");
         }
         else if(DoubleToStr(OrderMagicNumber(),0) == StringConcatenate(StringSubstr(magicNum,0,6),"3")){
            magicNum = StringConcatenate(StringSubstr(magicNum,0,6),"4");
         }
      }
      
      //-------------------------------------
      //----- Notify User of duplicate orders
      //      -> If StringLen(magicNum) = 7 => magicNum = PeriodID[2]+SymbolID[4]+OrderNumberID[1]
      //-------------------------------------
      if(StringSubstr(magicNum,6,1)=="1" && StringLen(magicNum)==7){
         Print("[+][M#] Assigned magic number successfully. [",symbol,"|M#:",magicNum,"].");   
      }
      else if(StringLen(magicNum)==7){
         Print("[+][M#] Assigned magic number successfully. [",symbol,"|M#:",magicNum,"]. Number of orders detected, including current: ",StringSubstr(magicNum,6,1));
      }
      else{
         Print("[ - ][M#] Error assigning magic number: ",ErrorDescription(GetLastError()),". Result: ",magicNum);
      }
      
      magicNumber = StrToInteger(magicNum);
      GlobalVariableSet(StringConcatenate(expertName,Symbol(),Period(),StringSubstr(magicNum,6,1)),magicNumber); 
      // -------- Global Variable is grabbed using the name of your expert,symbol,period,and order number on chart (in that order), 
      //---------- Expert advisors not using global variables from other experts should not use the expertID with getters, instead provide a NULL string (or "")
      //---------- 
      return(magicNumber);
      }
   else{
      Print("[M#][ - ] Magic number not assigned for input parameters [",symbol,"|",period,"|",expertName,"] . Check parameters. [LastError|M#] [",ErrorDescription(GetLastError()),"|",magicNum,"]");
      return(-1);
      }   
}

//------------------------------------
//   Magic.Getters:
//      1) magic.getBySymbol - Retrieve magic number for the 
//                             first order open on given symbol.
//                             Else, return -1
//      2) magic.getTicket - Retrieve ticket corresponding to magic number
//      3) magic.getByMagicNumber - Retrieve symbol corresponding to magic number
//      4) magic.getPeriod - retrieve period by magic number
//--------------------------------------------------
int magic.getMagicBySymbol(string symbol){
   for(int i=0;i<=NUMBER_OF_MN_SYMBOLS;i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES); if(OrderSymbol()==symbol) return(OrderMagicNumber());} return(-1);}
int magic.getTicket(int magicNumber){
   for(int i = 0; i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);if(OrderMagicNumber()==magicNumber) return(OrderTicket()); else continue;}
   if(GetLastError()==4105) return(-1); else Print("[M#][ - ] Could not find magicNumber. Last Error: ",GetLastError()); return(-1);}
string magic.getSymbol(int magicNumber){
   string test = StringConcatenate("",magicNumber); test = StringSubstr(test,2,4);
   for(int i=0; i<NUMBER_OF_MN_SYMBOLS; i++) if(test==magicVal[i]) return(magicID[i]);}
int magic.getPeriod(int magicNumber){
   string period = StringConcatenate("",magicNumber); period = StringSubstr(period,0,2);int periodSwitch = StrToInteger(period);
   switch(periodSwitch){
        case 90: return(PERIOD_MN1);
        case 80: return(PERIOD_W1);
        case 70: return(PERIOD_D1);
        case 60: return(PERIOD_H4);
        case 50: return(PERIOD_H1);  
        case 40: return(PERIOD_M30); 
        case 30: return(PERIOD_M15); 
        case 20: return(PERIOD_M5);  
        case 10: return(PERIOD_M1);
        default: Print("[M#][ - ] Could not determine period. InputPeriod: ",periodSwitch,". Last Error: ",ErrorDescription(GetLastError())); return(-1);
    }
}


//------------ Fill expert name with your unique ErpertID if yo are using GlobalVariables to communicate across experts, else provide NULL

//------------used for checking open orders-----

bool magic.isThereOpenOrder(string symbol, int period, string expertID){
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==symbol && magic.getPeriod(OrderMagicNumber())==period){
         if(expertID==""){
            return(true);
            }
         else{ 
            if(!GlobalVariableCheck(StringConcatenate(expertID,symbol,period,"1"))){
               //----- if there is no relevant open order, all anterior variables will be deleted from memory. Just to add some extra consistancy.
               GlobalVariableDel(StringConcatenate(expertID,symbol,period,"2"));
               GlobalVariableDel(StringConcatenate(expertID,symbol,period,"3"));
               GlobalVariableDel(StringConcatenate(expertID,symbol,period,"4"));
               return(false);
            }
            else{
               return(true);
             }
         
         }
      }
   
   }
   return(false);
}

bool isThereOpenOrderForSymbol(string symbol,string expertID){
   
      for(int i=0;i<OrdersTotal();i++){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==symbol){
            if(expertID!=""){
               for(int c= 0;c<8;c++){
                  if(GlobalVariableCheck(StringConcatenate(expertID,symbol,def.getStdPeriod(c),"1"))) return(true);
                  }
               return(false);
            }
          else{
            return(true);
            }
       }
     }
    return(false);
   
   
}
bool isThereHistoricalOrderMatch(int ticket){
   datetime currentOpen;
   OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
   currentOpen=OrderOpenTime();
   for(int i=0;i<OrdersHistoryTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderCloseTime()==currentOpen) return(true);
   }
   return(false);
}

int getHistoricalOrderTicket(int magicNumber){
   int ticket,histTicket = -1;
   datetime currentOpen;
   ticket = magic.getTicket(magicNumber);
   OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
   currentOpen = OrderOpenTime();
   for(int i=0;i<OrdersHistoryTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderCloseTime()==currentOpen) histTicket = OrderTicket();
   }
   return(histTicket);

}
int magic.getOpenOrders(int period,string symbol,string expertName){
   int count = 0;
   if(GlobalVariableCheck(StringConcatenate(expertName,symbol,period,"0"))==false && expertName!=""){
      GlobalVariableDel(StringConcatenate(expertName,symbol,period,"1"));
      GlobalVariableDel(StringConcatenate(expertName,symbol,period,"2"));
      GlobalVariableDel(StringConcatenate(expertName,symbol,period,"3"));
      return(0);
      }
   else{
      for(int l = 0;l<OrdersTotal();l++){
         OrderSelect(l,SELECT_BY_POS,MODE_TRADES);
         if(magic.getSymbol(OrderMagicNumber())==symbol && magic.getPeriod(OrderMagicNumber())==period){
            switch(StrToDouble(StringSubstr(DoubleToStr(OrderMagicNumber(),0),6,1))){
               case 1: count = 1; break;
               case 2: count = 2; break;
               case 3: count = 3; break;
               case 4: count = 4; break;
               default: Print("[ - ][M#] Error, could not identify order count [",symbol,"|",period,"]. Last Error: ",ErrorDescription(GetLastError())); 
                        return(-1);
            }   
         
         }
         
      }
   }
   return(count);
}


int getTypeByMagicNumber(int magicNumber){
   if(OrderSelect(magic.getTicket(magicNumber),SELECT_BY_TICKET)) return(OrderType()); else return(-1);
}

int getMagicNumberByTicket(int ticket){
   for(int y=0;y<OrdersTotal();y++){
      if(OrderSelect(y,SELECT_BY_TICKET,MODE_TRADES))
         return(OrderMagicNumber());
   }
   for(y=0;y<OrdersHistoryTotal();y++){
      if(OrderSelect(y,SELECT_BY_TICKET,MODE_HISTORY))
         return(OrderMagicNumber());
   }
   return(-1);
}

double getBreakEvenStopByMagicNumber(int magicNumber){
   double breakevenstop;
   OrderSelect(magic.getSymbol(magicNumber),SELECT_BY_TICKET);
   switch(OrderType()){
      case 0: breakevenstop = OrderOpenPrice()+(MarketInfo(magic.getSymbol(magicNumber),MODE_SPREAD)/MathPow(10,MarketInfo(magic.getSymbol(magicNumber),MODE_DIGITS)));
              NormalizeDouble(breakevenstop, MarketInfo(magic.getSymbol(magicNumber),MODE_DIGITS));
              return(breakevenstop);
      case 1: breakevenstop = OrderOpenPrice()-(MarketInfo(magic.getSymbol(magicNumber),MODE_SPREAD)/MathPow(10,MarketInfo(magic.getSymbol(magicNumber),MODE_DIGITS)));
              NormalizeDouble(breakevenstop, MarketInfo(magic.getSymbol(magicNumber),MODE_DIGITS));
              return(breakevenstop);
      default: Print("[M#][ - ] OrderType unidentified. Last Error: ",ErrorDescription(GetLastError())); return(0);
   }
}

//--------------------------------------------
//
//             Global Variable Functions
//
//--------------------------------------------


