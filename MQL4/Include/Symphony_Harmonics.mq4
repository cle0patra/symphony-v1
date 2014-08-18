//+------------------------------------------------------------------+
//|                                           Symphony_Variables.mq4 |
//|                                                           Luke S |
//|                                                                  |
//|   TODO:
//|     OrderModify functions
//+------------------------------------------------------------------+
#include "Symphony_Definitions.mqh"
#include "Symphony_Strings.mqh"
#include "Symphony_Magic.mq4"
#include "Symphony_RiskManagement.mqh"
#include "stdlib.mqh"
#include "stderror.mqh"

void OnInit(){

};

string globalID[] = {"PRZ_HIGH", "PRZ_LOW","POINT_X", "POINT_A","POINT_B", "POINT_C", "POINT_D","XA_LEG", 
                     "AB_LEG", "BC_LEG", "CD_LEG", "ZigZagZug","ZigZagZug_Start"};
                     
enum general_definitions
{
   numOfVectors = 13
};

class SymphonyHarmonics
{
   string zup_version;
   bool verbosity;
   //---> Data array
   double vectors[13][7];
   //---> Structs
   general_definitions gen_def;
   periods schema;
   SymphonyStrings strings;
   string symbol;
   bool symbolSet;
   SymphonyDefinitions definitions;
   public:
      //---> Constructors
      SymphonyHarmonics(){
         this.zup_version="_135";this.verbosity=true;this.symbol=Symbol();this.symbolSet = false;}
      SymphonyHarmonics(string symbol){
         this.zup_version="_135";this.verbosity=true;this.symbol=symbol;this.symbolSet = false;}
      SymphonyHarmonics(bool verbosity,string symbol){
         this.verbosity = verbosity;this.symbol=symbol;this.symbolSet = false;}
      
      //------------------------------------------
      // refreshIndicators:
      //    -> Takes parameter sym, will set if symbol 
      //       has not already been set
      //    -> Call in order to update global variables
      //
      //------------------------------------------
      void refresh_indicators(){
         this.refresh_indicators(this.symbol);
      }; 
      void refresh_indicators(string s){
         string sym = s;
         double exbuffer;
         for(int i=schema.periodM1;i<=schema.periodD1;i++){
          int stdPeriod = this.get_standard_period(i);
            double exBuffer;
            //--------------- These three custom indicators accept one parameter (lookback) and refresh/create necessary global variables
            switch(i){
               //---- For ZigZagZug, Buffer 0 is ZigZag Point
               case periodM1: exbuffer = iCustom(sym,stdPeriod,"ZUP _v135a PP_Custom",50,0,0); //greater lookback for smaller timeframes
               case periodM5: exbuffer = iCustom(sym,stdPeriod,"ZUP _v135a PP_Custom",50,0,0); 
               default: exBuffer = iCustom(sym,stdPeriod,"ZUP _v135a PP_Custom",25,0,0);
               }
               exbuffer = iCustom(sym,stdPeriod,"ZigZagZug.v1.1_Custom",0,0);
            }
         //------------------------------------
         //  Update Loop
         //------------------------------------
         for(i = 0;i<schema.periodIndexLength;i++){
            stdPeriod = this.get_standard_period(i);
            for(int p=0;p<gen_def.numOfVectors;p++){ //... globalID[p] = ZUP parameter
               if(globalID[p]=="ZigZagZug" || globalID[p]=="ZigZagZug_Start")
                  vectors[this.definitions.get(globalID[p])][i] = GlobalVariableGet(StringConcatenate(globalID[p],sym,stdPeriod));
               else vectors[this.definitions.get(globalID[p])][i] = GlobalVariableGet(StringConcatenate(globalID[p],this.zup_version,sym,stdPeriod));
               }
         }
      };
      //----> End refreshIndicators
      
      //-----------------------------------------
      //  Visible Pattern
      //    -> Returns true if there is a pattern anywhere on the chart
      //       (the matrix)
      //----------------------------------------
      
      bool visible_pattern(int period){
         return(this.get_point_X(period)==0. &&
            this.get_point_A(period)==0. &&
            this.get_point_B(period)==0. &&
            this.get_point_C(period)==0. &&
            this.get_point_D(period)==0.);
      };
      //###############################
      //#    BEGIN SETTERS & GETTERS
      //##############################
      
      //----------------------
      //  setSymbol:
      //    > Locks symbol so we can only call indicators with
      //      specified pair
      //    > call unsetSymbol to allow the symbol to be changed
      //-------------------------
      void set_symbol(string symb){
         if(!symbolSet) symbolSet = true;
         this.symbol = symb;
      };
      //---------------------
      //  unsetSymbol:
      //    > Unlocks symbol
      //--------------------
      void unset_symbol(){symbolSet=false;};
      
      //--------------------------------------
      //  get_index:
      //    > Returns the index (a la period schema)
      //      matching the supplied standard period format (i.e. PERIOD_X)
      //------------------------------------
      int get_index(int index){
         switch(index){
             case PERIOD_M1: return(schema.periodM1);
            case PERIOD_M5: return(schema.periodM5);
            case PERIOD_M15: return(schema.periodM15);
            case PERIOD_M30: return(schema.periodM30);
            case PERIOD_H1: return(schema.periodH1);
            case PERIOD_H4: return(schema.periodH4);
            case PERIOD_D1: return(schema.periodD1);
            default: if(verbosity && GetLastError()!=0 && GetLastError()!=4002) 
                  Print("[ Symphony | Variables | Harmonics ] Unable to grab indexed period  for vars.getI(",index,"). LastError: ",
                   ErrorDescription(GetLastError())); return(-1);
         }
      };
       //--------------------------------------
       //  getStdPeriod:
       //    > Return built-in period value from period
       //      schema input
       //------------------------------
       
      int get_standard_period(int index){
         switch(index){
            case schema.periodM1: return(PERIOD_M1);
            case schema.periodM5: return(PERIOD_M5);
            case schema.periodM15: return(PERIOD_M15);
            case schema.periodM30: return(PERIOD_M30);
            case schema.periodH1: return(PERIOD_H1);
            case schema.periodH4: return(PERIOD_H4);
            case schema.periodD1: return(PERIOD_D1);
            default: if(verbosity) Print("[ Symphony | Variables | Harmonics ] Unable to grab standard period. Input: ",
                                    index,". LastError: ",ErrorDescription(GetLastError())); return(-1);
         }
      };
      //------------------------------
      //  Data Point getters
      //------------------------------
      double get_PRZ_high(int period){
         int i = this.get_index(period);
         Print("[Symphony|Vars] vars.getPRZHigh: ",DoubleToString(vectors[this.definitions.get("PRZ_HIGH")][i],Digits),
         " def.get(\"PRZ_HIGH\"):",this.definitions.get("PRZ_HIGH"));return(vectors[this.definitions.get("PRZ_HIGH")][i]);};
      double get_PRZ_low(int period)       {int i = this.get_index(period);return(vectors[this.definitions.get("PRZ_LOW")][i]);};
      double get_point_X(int period)       {int i = this.get_index(period);return(vectors[this.definitions.get("POINT_X")][i]);};
      double get_point_A(int period)       {int i = this.get_index(period);return(vectors[this.definitions.get("POINT_A")][i]);};
      double get_point_B(int period)       {int i = this.get_index(period);return(vectors[this.definitions.get("POINT_B")][i]);};
      double get_point_C(int period)       {int i = this.get_index(period);return(vectors[this.definitions.get("POINT_C")][i]);};
      double get_point_D(int period)       {int i = this.get_index(period);return(vectors[this.definitions.get("POINT_D")][i]);};
      double get_XA(int period)            {int i = this.get_index(period);return(vectors[this.definitions.get("XA_LEG")][i]);};
      double get_AB(int period)            {int i = this.get_index(period);return(vectors[this.definitions.get("AB_LEG")][i]);};
      double get_BC(int period)            {int i = this.get_index(period);return(vectors[this.definitions.get("BC_LEG")][i]);};
      double get_CD(int period)            {int i = this.get_index(period);return(vectors[this.definitions.get("CD_LEG")][i]);};
      double get_ZZ(int period)            {int i = this.get_index(period);return(vectors[this.definitions.get("ZigZagZug")][i]);};
      double get_ZZ_start(int period)      {int i = this.get_index(period);return(vectors[this.definitions.get("ZigZagZug_Start")][i]);};
      //----------------------
      //  Type Getter:
      //    -> ORDER_TYPE_BUY if PointD < PointC
      //    -> ORDER_TYPE_SELL if PointD > PointC
      //    -> -1 if there was an inconsistency
      // ... Note: Use switch statements when dealing with order types. Always make sure to return a value which, if the function
      // ... misbehaves, will make order execution impossible.
      //--------------------------------------------------
      
      int get_type(int period){
         int i = this.get_index(period); 
         if(this.get_point_D(period)==0. || this.get_point_C(period)==0.) 
            return(-1);
         else if(this.get_point_C(period)>this.get_point_D(period)) 
            return(ORDER_TYPE_BUY); 
         else return(ORDER_TYPE_SELL);
       };
      
      //-----------------------------------
      //  Fibonacci Retracement:
      //    -> Will first determine ordertype by calling vars.getType()
      //    -> Retracement level should be provided with an arithmetic decimal 
      //       (e.g. 23.6% retracement = .236)
      //    -> Returns retracement value of CD Leg
      //---------------------------------------
      double get_retracement(int stdPeriod,double retLevel){
         int type = this.get_type(stdPeriod);
         double ret = 0;
         switch(type){    
            case ORDER_TYPE_BUY: ret = this.get_point_D(stdPeriod)+(retLevel*this.get_CD(stdPeriod)); break;
            case ORDER_TYPE_SELL: ret = this.get_point_D(stdPeriod)-(retLevel*this.get_CD(stdPeriod)); break;
            default: Print("[ Symphony | Variables | Harmonics ] Error fetching retracement for ",
                     this.strings.standard_period_to_string(stdPeriod)," on ",this.symbol," with %Ret = ",
                     DoubleToString(retLevel,3),". Last Error: ",ErrorDescription(GetLastError()));
         }
      };
      
      //--------------------------------------
      //   PRZ StopLoss Policy:
      //    1) ORDER_TYPE_BUY: StopLoss is PRZLow - ATR/6
      //    2) ORDER_TYPE_SELL: StopLoss is PRZHigh + ATR/6
      //---------------------------------------
      
      double get_PRZ_stop(int stdPeriod){
         int type = this.get_type(stdPeriod);
         double stop = 0;
         //------- for the rare case when the retracement zone has not formed ahead of the pattern
         if(this.get_PRZ_high(stdPeriod)==0. || this.get_PRZ_low(stdPeriod)==0.){
            Print("[ Symphony | Variables | Harmonics ] PRZHigh or PRZLow does not exits for [",this.symbol,"|",this.strings.standard_period_to_string(stdPeriod),
                  "]. Unable to set stop. Last Error: ",ErrorDescription(GetLastError()));
            return(-1);
         }
         switch(type){
            case ORDER_TYPE_BUY: stop = this.get_PRZ_low(stdPeriod) - iATR(this.symbol,stdPeriod,14,0)/6; break;
            case ORDER_TYPE_SELL: stop = this.get_PRZ_high(stdPeriod) + iATR(this.symbol,stdPeriod,14,0)/6; break;
            default: Print("[ Symphony | Variables | Harmonics ] Unable to calculate initial stop. OrderType: ",
                     this.strings.type_to_string(type)," for [",this.symbol,"|",this.strings.standard_period_to_string(stdPeriod),
                     "]. Last Error: ",ErrorDescription(GetLastError()));
         }
         stop = NormalizeDouble(stop,_Digits);
         return(stop);
      };
      //-----------------------
      //  Retracement Differential:
      //    -> Will calculate how far the current price has retraced the CD Leg
      //------------------------
      double get_retracement_difference(int stdPeriod){
         int type = this.get_type(stdPeriod); 
         double currDiff,retDiff; 
         switch(type){
            case ORDER_TYPE_BUY: currDiff = this.ask_or_bid(ORDER_TYPE_BUY) - this.get_point_D(stdPeriod); break;
            case ORDER_TYPE_SELL: currDiff = this.get_point_D(stdPeriod) - this.ask_or_bid(ORDER_TYPE_SELL); break;
            default: Print("[ Symphony | Variables | Harmonics ] Unable to calculate retracement differential. OrderType: ",
                     this.strings.type_to_string(type)," for [",this.symbol,"|",this.strings.standard_period_to_string(stdPeriod),
                     "]. Last Error: ",ErrorDescription(GetLastError()));
         }
         return(MathAbs(NormalizeDouble( (currDiff/this.get_CD(stdPeriod)),_Digits)));
      };
      
      //----------------------------
      //  Helpers:
      //     1) AskOrBid - returns proper opening price
      //     2) AskOrBidClose - returns proper closing price 
      //-----------------------------
      double ask_or_bid(int type){
         switch(type){
            case ORDER_TYPE_BUY: return(Ask);
            case ORDER_TYPE_SELL: return(Bid);
            default: Print("[ Symphony | Variables | Harmonics ] OrderType undefined. Last Error: ",ErrorDescription(GetLastError())); break;
         }
      };
      double ask_or_bid_close(int type){
         RefreshRates();
         switch(type){
            case ORDER_TYPE_BUY: return(Bid);
            case ORDER_TYPE_SELL: return(Ask);
            default: Print("[ Symphony | Variables | Harmonics ] OrderType undefined. Last Error: ",ErrorDescription(GetLastError())); break;
         }
      };
      //#################################
      //#   END GETTERS & SETTERS
      //#################################
      //---------------------------
      // Print Functions:
      //    1) print() -> pretty print
      //    2) format() -> centers the variable
      //    3) periodToString() -> takes index from period schema and returns
      //       string representation
      //    4) stdPeriodToString() -> Takes standard period and returns
      //       string representation
      //----------------------------
      
      void pretty_print(){
         string line = "|";
         for(int i =0; i<this.gen_def.numOfVectors;i++){
            for(int p=0;p<schema.periodIndexLength;p++){
               string zupVar = DoubleToString(vectors[this.definitions.get(globalID[i])][p],_Digits);
               line = StringConcatenate(line,this.format(zupVar),"|");  
            }
            line = StringConcatenate(line,"   ",globalID[i]);
            Print(line); line = "|";
         }
         for(p=0;p<periodIndexLength;p++){
            line = StringConcatenate(line,"   ",this.strings.period_to_string(p),"   |");
         }
         Print(line);
         Print("[ Symphony | Variables] Symbol matrix for ",this.symbol);
      };
      
      //----- formatter
      string format(string s){ 
         if(s=="0.00000") return("        0.00         ");
         int sLen = 20;int l = StringLen(s);int p; string fs = "";
         if(l<sLen){
            p = sLen-l; int mid = p/2;int end = p-mid;
            while(mid>0){fs = StringConcatenate(" ",fs); mid--;} //... add begin spaces
            fs = StringConcatenate(fs,s);
            while(end>0){fs = StringConcatenate(fs," "); end--;} //.. add end spaces
         }
         return(fs);
      };
      
      //------------------------------------
      // Symphony -> Print Current Retracement
      //   Present the current ratio of price to leg
      //
      //---------------------------------------
      
      void print_current_retracement(int period){
         double x = MathAbs(this.ask_or_bid(this.get_type(period))-this.get_point_D(period));
         double ret = x/this.get_CD(period);
         Print("[ Symphony | Variables | printCurrentRetracement ] For ",this.strings.standard_period_to_string(period)," %",
                DoubleToString(ret*100,2));
      };

};


//------------------------------------
//   Order Handler:
//     > One instance per open ticket
//     > General Purpose:
//       1) Execute basic Order operations
//       2) provide information about the trade
//          -> Specialized handlers will handle more fine grained control
//     > Harmonic handler will inherit from this class
//       and act as a specialized handler
//--------------------------------------------


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
   SymphonyHarmonics h;
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

