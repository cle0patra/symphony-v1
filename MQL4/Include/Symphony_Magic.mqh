//+------------------------------------------------------------------+
//|                                         MagicNumberManagment.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""
#include "stdlib.mqh"
#include "stderror.mqh"

//----------------------------------
//  SYMBOL_ID:
//    > Structure tying an element constant (the symbol) to its
//      ID number
//--------------------------------------


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
                    

struct symbol_id
{
   int EURUSD,AUDUSD,NZDUSD,USDJPY,USDCHF,GBPUSD,USDCAD,
       USDSGD,USDTRY,USDSEK,USDMXN,USDZAR,USDNOK,USDDKK,
       USDXAU,USDXAG,USDPLN,USDHKD,USDRUB,USDHUF,CHFNOK,
       EURCHF,EURGBP,EURAUD,GBPNZD,GBPAUD,AUDNZD,
       EURNZD,EURJPY,GBPJPY,CHFJPY,EURHUF,GBPCHF,EURCAD,
       AUDCAD,AUDJPY,CADJPY,NZDJPY,GBPCAD,EURSEK,EURNOK,
       AUDCHF,EURPLN,EURCZK,EURDKK,GBPSEK,NOKJPY,SEKJPY,
       SGDJPY,HKDJPY,ZARJPY,EURTRY,NZDCHF,CADCHF,NZDCAD,
       CHFSEK,USOil;
   int numberOfSymbols;
   symbol_id() {EURUSD=1001;AUDUSD=1002;NZDUSD=1003;USDJPY=1004;
                 USDCHF=1005;GBPUSD=1006;USDCAD=1007;USDSGD=1008;
                 USDTRY=1009;USDSEK=1010;USDMXN=1011;USDZAR=1012;
                 USDNOK=1013;USDDKK=1014;USDXAU=1015;USDXAG=1016;
                 USDPLN=1017;USDHKD=1018;USDRUB=1019;USDHUF=1020;
                 CHFNOK=1021;EURCHF=1022;EURGBP=1023;EURAUD=1024;
                 GBPNZD=1025;GBPAUD=1026;AUDNZD=1027;
                 EURNZD=1029;EURJPY=1030;GBPJPY=1031;CHFJPY=1032;
                 EURHUF=1033;GBPCHF=1034;EURCAD=1035;AUDCAD=1036;
                 AUDJPY=1037;CADJPY=1038;NZDJPY=1039;GBPCAD=1040;
                 EURSEK=1041;EURNOK=1042;AUDCHF=1043;EURPLN=1044;
                 EURCZK=1045;EURDKK=1046;GBPSEK=1047;NOKJPY=1048;
                 SEKJPY=1049;SGDJPY=1050;HKDJPY=1051;ZARJPY=1052;
                 EURTRY=1053;NZDCHF=1054;CADCHF=1055;NZDCAD=1056;
                 CHFSEK=1057;USOil=1058;
                 numberOfSymbols = 57;}
};
//--------------------------------------
//  SYMPHONY_MAGIC:
//    > Class containing all necessary functions for magic numbers
//    > High Level:
//       i) Set a magic number such that each order can be identified
//          individually
//      ii) Magic number will contain information about the order (e.g. period, symbol, etc)
//     iii) Certain information can be returned by simply specifying the magic number
//    > TODO:
//       1) Better support for multiple orders on one chart
//       2) Work in expert name to magic number
//----------------------------------------------

class SymphonyMagic
{
   string expertName;
   //-------> Symbol schema
   symbol_id sID;
   public:
      //+--> Constructor
      SymphonyMagic() { this.expertName = "Symphony_v1";}
      //-------> Expert advisor name
      void set_expert_name(string expert){this.expertName = expert;};
      
      //#############################
      //   Function Block:
      //#############################
      
      //---------------------
      //  getMagicNumber:
      //    > Get magic number for order openingUsage:
      //    > Usage:
      //       1) Period in standard format (PERIOD_X)
      //       2) Symbol to be traded on
      //    > Policy:
      //       1) CARDINAL_POLICY:
      //          a) Charts can have up to 4 orders with unique magic numbers
      //          b) Modify if more are needed    
      //------------------------------------
      int get_magic_number(int period, string symbol){
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
         string magicNum;
         magicNum = StringConcatenate(magicNum,"",(Period_ID*10)); //.... magicNum += PeriodID
         int magicNumber = 0;
         for(int i=0;i<sID.numberOfSymbols;i++){
            //one is a tag used to identify different orders on the same chart. Will be changed if there are other orders open
            if(symbol==magicID[i]) 
               magicNum = StringConcatenate(magicNum,magicVal[i],"1"); 
         }
         if(StringLen(magicNum)==7){
            for(int q=0; q<OrdersTotal();q++){
               if(OrderSelect(q,SELECT_BY_POS,MODE_TRADES)){
                  if(magicNum==DoubleToStr(OrderMagicNumber(),0))
                     magicNum = StringConcatenate(StringSubstr(magicNum,0,6),"2");
                  else if(DoubleToStr(OrderMagicNumber(),0) == StringConcatenate(StringSubstr(magicNum,0,6),"2"))
                     magicNum = StringConcatenate(StringSubstr(magicNum,0,6),"3");
                  else if(DoubleToStr(OrderMagicNumber(),0) == StringConcatenate(StringSubstr(magicNum,0,6),"3"))
                     magicNum = StringConcatenate(StringSubstr(magicNum,0,6),"4");
               }
               else{Print("[ Symphony | Magic ] Unable to select order ",q);}
            }
            
            //-------------------------------------
            //----- Notify User of duplicate orders
            //      -> If StringLen(magicNum) = 7 => magicNum = PeriodID[2]+SymbolID[4]+OrderNumberID[1]
            //-------------------------------------
            if(StringSubstr(magicNum,6,1)=="1" && StringLen(magicNum)==7)
               Print("[ Symphony | Magic] Assigned magic number successfully. [",symbol,"|M#:",magicNum,"].");  
            else if(StringLen(magicNum)==7)
               Print("[ Symphony | Magic] Assigned magic number successfully. [",symbol,"|M#:",magicNum,"]. Number of orders detected, including current: ",StringSubstr(magicNum,6,1));
            else
               Print("[ Symphony | Magic] Error assigning magic number: ",GetLastError(),". Result: ",magicNum);            
            magicNumber = StrToInteger(magicNum);
            GlobalVariableSet(StringConcatenate(expertName,Symbol(),Period(),StringSubstr(magicNum,6,1)),magicNumber); 
            // -------- Global Variable is grabbed using the name of your expert,symbol,period,and order number on chart (in that order), 
            //---------- Expert advisors not using global variables from other experts should not use the expertID with getters, instead provide a NULL string (or "")
            //---------- 
            return(magicNumber);
            }
         else{
            Print("[ Symphony | Magic | GetMagicNumber ] Magic number not assigned for input parameters [",symbol,"|",period,"|",expertName,"] . Check parameters. [LastError|M#] [",GetLastError(),"|",magicNum,"]");
            return(-1);
            }   
      };
      
      //########################
      //#   GETTERS:
      //########################
      
      //---------------------------
      //  getBySymbol:
      //    > Retrieve magic number for the first 
      //      order open on given symbol. Else, return -1.
      //-----------------------------------
      int get_magic_by_symbol(string symbol){
         for(int i=0;i<=sID.numberOfSymbols;i++){
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               if(OrderSymbol()==symbol) 
                  return(OrderMagicNumber());
             } 
         return(-1);
      };
      //-------------------------------------
      //  getTicket:
      //   > Retrieve ticket corresponding to magic number
      //----------------------------------------
      int get_ticket_by_magic_number(int magicNumber){
            for(int i = 0; i<OrdersTotal();i++){
               if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                  if(OrderMagicNumber()==magicNumber) 
                     return(OrderTicket()); 
               continue;
            }
            if(GetLastError()==4105) 
               return(-1); 
            else Print("[ Symphony | Magic ] Could not find magicNumber. Input magic number: ",magicNumber,
                        " Last Error: ",GetLastError()); return(-1);
      };
      //------------------------------------------
      //  get_symbol_by_magic_number:
      //    > Retrieve symbol corresponding to magic number
      //-------------------------------------------
      string get_symbol_by_magic_number(int magicNumber){
         string test = StringConcatenate("",magicNumber); 
         test = StringSubstr(test,2,4);
         for(int i=0; i<sID.numberOfSymbols; i++) 
            if(test==magicVal[i]) 
               return(magicID[i]);
         return("");
      };
      //------------------------------------------
      //  get_period_by_magic_number:
      //    > Retrieve period corresponding to magic number
      //-------------------------------------------
      int get_period_by_magic_number(int magicNumber){
            string period = StringConcatenate("",magicNumber); 
            period = StringSubstr(period,0,2);
            int periodSwitch = StrToInteger(period);
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
                 default: Print("[ Symphony | Magic | GetPeriodByMagic# ] Could not determine period. InputPeriod, magicNumber: ",
                                 periodSwitch,", ",magicNumber,". Last Error: ",GetLastError()); 
                                 return(-1);
             }
      };
      //------------------------------------------
      //  get_type_by_magic_number:
      //    > Returns order type based on magic number
      //-------------------------------------------
      int get_type_by_magic_number(int magicNumber){
            if(OrderSelect(this.get_ticket_by_magic_number(magicNumber),SELECT_BY_TICKET)) 
                  return(OrderType()); else return(-1);
      };
      //-----------------------------------------
      //  get_lots_by_magic_number:
      //    @param magic_number: Magic number
      //    @return: Current order size of ticket
      //-------------------------------------------
      int get_lots_by_magic_number(int magic_number){
         int ticket = this.get_ticket_by_magic_number(magic_number);
         OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
         return(OrderLots());
      };
      //-----------------------------------------
      //  get_lots_by_ticket:
      //    @param magic_number: Magic number
      //    @return: Current order size of ticket
      //-------------------------------------------
      int get_lots_by_ticket(int ticket){
         OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
         return(OrderLots());
      };
      //------------------------------------------
      //  get_magic_number_by_ticket:
      //    > Returns ticket from magic number
      //-------------------------------------------
      int get_magic_number_by_ticket(int ticket){
         int y = 0;
         for(y=0;y<OrdersTotal();y++){
            if(OrderSelect(y,SELECT_BY_TICKET,MODE_TRADES))
               return(OrderMagicNumber());
         }
         for(y=0;y<OrdersHistoryTotal();y++){
            if(OrderSelect(y,SELECT_BY_TICKET,MODE_HISTORY))
               return(OrderMagicNumber());
         }
         return(-1);
      };
      //------------------------------------------
      //  get_breakeven_stop_by_magic_number:
      //    > Returns stoploss based on magic number
      //    > Can take a pre-recorded spread, or will use current spread instead
      //-------------------------------------------
      double get_breakeven_stop_by_magic_number(int magicNumber){
         return(this.get_breakeven_stop_by_magic_number(magicNumber,-1));
      }
      double get_breakeven_stop_by_magic_number(int magicNumber,double spread){
         double breakevenstop;
         int ticket            = this.get_ticket_by_magic_number(magicNumber);
         string symbol         = this.get_symbol_by_magic_number(magicNumber);
         double sy_spread;
         
         if(spread==-1) sy_spread = MarketInfo(symbol,MODE_SPREAD);
           else sy_spread = spread;
         if(OrderSelect(ticket,SELECT_BY_TICKET)){
            switch(OrderType()){
               case 0: breakevenstop = OrderOpenPrice()+(sy_spread/MathPow(10,MarketInfo(symbol,MODE_DIGITS)));
                       NormalizeDouble(breakevenstop, MarketInfo(symbol,MODE_DIGITS));
                       return(breakevenstop);
               case 1: breakevenstop = OrderOpenPrice()-(sy_spread/MathPow(10,MarketInfo(symbol,MODE_DIGITS)));
                       NormalizeDouble(breakevenstop, MarketInfo(symbol,MODE_DIGITS));
                       return(breakevenstop);
               default: Print("[ Symphony | Magic ] OrderType unidentified. OrderType: ",OrderType(),". MagicNumber: ",magicNumber,
                              " Last Error: ",GetLastError()); 
                              return(0);
            };
         }
         else this.report_selection_fail(ticket);
         return(-1);
      };
      
      //##############################
      //#   HIGH LEVEL FUNCTIONS
      //#############################
      
      //------------------------------------------
      //  is_there_open_order:
      //    > Determines whether there is an order on the
      //      chart using magic numbers
      //-------------------------------------------
      bool is_there_open_order(string symbol, int period, string expertID){
         for(int i=0;i<OrdersTotal();i++){
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
               if(OrderSymbol()==symbol && this.get_period_by_magic_number(OrderMagicNumber())==period){
                  if(expertID=="")
                     return(true);
                  else{ 
                     if(!GlobalVariableCheck(StringConcatenate(expertID,symbol,period,"1"))){
                        //----- if there is no relevant open order, all anterior variables will be deleted from memory. Just to add some extra consistancy.
                        GlobalVariableDel(StringConcatenate(expertID,symbol,period,"2"));
                        GlobalVariableDel(StringConcatenate(expertID,symbol,period,"3"));
                        GlobalVariableDel(StringConcatenate(expertID,symbol,period,"4"));
                        return(false);
                     }
                     else
                        return(true);
                  }
               }
            }
             else this.report_selection_fail(i);
         }
         return(false);
      };
      //------------------------------------------
      //  is_there_historical_order_match:
      //    > returns true if the provided TICKET has been
      //      partially close (compare orderclose and orderopen
      //      times
      //-------------------------------------------
      bool is_there_historical_order_match(int ticket){
         datetime currentOpen;
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)){
            currentOpen=OrderOpenTime();
            for(int i=0;i<OrdersHistoryTotal();i++){
               OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
               if(OrderCloseTime()==currentOpen) return(true);
            }
         }
         else this.report_selection_fail(ticket);
         return(false);
      };
      //------------------------------------------
      //  get_historical_order_ticket:
      //    > Can be located by ticket or by magic number
      //-------------------------------------------
      int get_historical_order_ticket_by_ticket(int ticket){
         OrderSelect(ticket,SELECT_BY_TICKET);
         return(get_historical_order_ticket_by_magic_number(OrderMagicNumber()));
      }
      int get_historical_order_ticket_by_magic_number(int magicNumber){
            int ticket,histTicket = -1;
            datetime currentOpen;
            ticket = this.get_ticket_by_magic_number(magicNumber);
            OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
            currentOpen = OrderOpenTime();
            for(int i=0;i<OrdersHistoryTotal();i++){
               OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
               if(OrderCloseTime()==currentOpen) histTicket = OrderTicket();
            }
            return(histTicket);
      };
      
      //-------------------------
      // Helpers
      //----------------------
      
      //----------------------
      // report_selection_fail
      //   > Print information about the attempted selection,
      //     and attempt to determine why
      //   > If the number is low, then it was a positional 
      //     index and that was the reason for failure
      //--------------------------
      void report_selection_fail(int ticket){
          string message  = "[ SymphonyMagic | SelectionFail ]";
          if(ticket<OrdersTotal()) message = StringConcatenate(message," Magic Error: Failed to select ticket from positional index. LastError: ",ErrorDescription(GetLastError()));
          else{
             bool in_history = False;
             bool current    = False;
             if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) current = True;
             else if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)) in_history = True;
             else message = StringConcatenate(message," Magic Error: Invalid ticket. Trade does not exist. LastError: ",ErrorDescription(GetLastError()));
             
             if(current) StringAdd(message," Magic Error: Tried to select from historical pool.");
             else if(in_history){
               OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY);
               double profit    = OrderProfit();
               int close_time   = OrderCloseTime();
               bool was_partial = False;
               string was_partial_msg;
               for(int i=0; i<OrdersTotal(); i++){
                  OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
                  if(close_time==OrderCloseTime()) was_partial = True;
               }
               if(was_partial) was_partial_msg = "Yes";
               else was_partial_msg = "No";
               message = StringConcatenate(message," Magic Error: Tried to select from current pool. Profit: ",DoubleToString(profit,2),
                                           " Close Time: ",TimeToString(close_time,TIME_DATE|TIME_MINUTES)," Was partial close? ",was_partial_msg);
             };
         };
         Print(message);
      };
      
};


/*
//------------------------------------
//   Magic.Getters:
//      
//      4) magic.getPeriod - retrieve period by magic number
//--------------------------------------------------




//------------ Fill expert name with your unique ErpertID if yo are using GlobalVariables to communicate across experts, else provide NULL

//------------used for checking open orders-----


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
               default: Print("[ - ][M#] Error, could not identify order count [",symbol,"|",period,"]. Last Error: ",GetLastError()); 
                        return(-1);
            }   
         
         }
         
      }
   }
   return(count);
}




//--------------------------------------------
//
//             Global Variable Functions
//
//--------------------------------------------
*/


/*
class MagicID
{
   string magicID[57];
   int magicVal[];
   public:
      MagicID() {this.magicID = {"EURUSD","AUDUSD","NZDUSD",
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
                    magicVal[] = {"1001","1002","1003","1004", //needs support for noncurrencies
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
                    "1057","1058"};}
};*/