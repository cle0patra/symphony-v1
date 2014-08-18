//+------------------------------------------------------------------+
//|                                           Symphony_Variables.mq4 |
//|                                                           Luke S |
//|                                                                  |
//|   TODO:
//|     FileWrite class
//|     OrderModify functions
//|     Tests for all classes (make sure Harmonics class grabs vars)
//+------------------------------------------------------------------+
#include "Symphony_Definitions.mqh"
#include "Symphony_Magic.mqh"
#include "Symphony_Definitions.mqh"
#include "OrderReliable.mqh"
#include "Symphony_RiskManagement.mqh"
#include "stdlib.mqh"
#include "stderror.mqh"

string globalID[] = {"PRZ_HIGH", "PRZ_LOW","POINT_X", "POINT_A","POINT_B", "POINT_C", "POINT_D","XA_LEG", 
                     "AB_LEG", "BC_LEG", "CD_LEG", "ZigZagZug","ZigZagZug_Start"};
                     
enum general_definitions
{
   numOfVectors = 13
};

class Harmonics
{
   string zup_version;
   bool verbosity;
   //---> Data array
   double vectors[13][7];
   //---> Structs
   general_definitions gen_def;
   periods schema;
   string symbol;
   bool symbolSet;
   SymphonyDefinitions definitions;
   public:
      //---> Constructors
      Harmonics(){
         this.zup_version="_135";this.verbosity=true;this.symbol=Symbol();this.symbolSet = false;}
      Harmonics(string symbol){
         this.zup_version="_135";this.verbosity=true;this.symbol=symbol;this.symbolSet = false;}
      Harmonics(bool verbosity,string symbol){
         this.verbosity = verbosity;this.symbol=symbol;this.symbolSet = false;}
      
      //------------------------------------------
      // refreshIndicators:
      //    -> Takes parameter sym, will set if symbol 
      //       has not already been set
      //    -> Call in order to update global variables
      //
      //------------------------------------------
      void refreshIndicators(){
         this.refreshIndicators(this.symbol);
      }; 
      void refreshIndicators(string s){
         string sym = s;
         double exbuffer;
         for(int i=schema.periodM1;i<=schema.periodD1;i++){
          int stdPeriod = this.getStdPeriod(i);
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
            stdPeriod = getStdPeriod(i);
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
      
      bool visiblePattern(int period){
         return(this.getPtX(period)==0. &&
            this.getPtA(period)==0. &&
            this.getPtB(period)==0. &&
            this.getPtC(period)==0. &&
            this.getPtD(period)==0.);
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
      void setSymbol(string symb){
         if(!symbolSet) symbolSet = true;
         this.symbol = symb;
      };
      //---------------------
      //  unsetSymbol:
      //    > Unlocks symbol
      //--------------------
      void unsetSymbol(){symbolSet=false;};
      
      //--------------------------------------
      //  getIndex:
      //    > Returns the index (a la period schema)
      //      matching the supplied standard period format (i.e. PERIOD_X)
      //------------------------------------
      int getIndex(int index){
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
       
      int getStdPeriod(int index){
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
      double getPRZHigh(int period){
         int i = this.getIndex(period);
         Print("[Symphony|Vars] vars.getPRZHigh: ",DoubleToString(vectors[this.definitions.get("PRZ_HIGH")][i],Digits),
         " def.get(\"PRZ_HIGH\"):",this.definitions.get("PRZ_HIGH"));return(vectors[this.definitions.get("PRZ_HIGH")][i]);};
      double getPRZLow(int period)    {int i = this.getIndex(period);return(vectors[this.definitions.get("PRZ_LOW")][i]);};
      double getPtX(int period)       {int i = this.getIndex(period);return(vectors[this.definitions.get("POINT_X")][i]);};
      double getPtA(int period)       {int i = this.getIndex(period);return(vectors[this.definitions.get("POINT_A")][i]);};
      double getPtB(int period)       {int i = this.getIndex(period);return(vectors[this.definitions.get("POINT_B")][i]);};
      double getPtC(int period)       {int i = this.getIndex(period);return(vectors[this.definitions.get("POINT_C")][i]);};
      double getPtD(int period)       {int i = this.getIndex(period);return(vectors[this.definitions.get("POINT_D")][i]);};
      double getXA(int period)        {int i = this.getIndex(period);return(vectors[this.definitions.get("XA_LEG")][i]);};
      double getAB(int period)        {int i = this.getIndex(period);return(vectors[this.definitions.get("AB_LEG")][i]);};
      double getBC(int period)        {int i = this.getIndex(period);return(vectors[this.definitions.get("BC_LEG")][i]);};
      double getCD(int period)        {int i = this.getIndex(period);return(vectors[this.definitions.get("CD_LEG")][i]);};
      double getZZ(int period)        {int i = this.getIndex(period);return(vectors[this.definitions.get("ZigZagZug")][i]);};
      double getZZStart(int period)   {int i = this.getIndex(period);return(vectors[this.definitions.get("ZigZagZug_Start")][i]);};
      //----------------------
      //  Type Getter:
      //    -> ORDER_TYPE_BUY if PointD < PointC
      //    -> ORDER_TYPE_SELL if PointD > PointC
      //    -> -1 if there was an inconsistency
      // ... Note: Use switch statements when dealing with order types. Always make sure to return a value which, if the function
      // ... misbehaves, will make order execution impossible.
      //--------------------------------------------------
      
      int getType(int period){
         int i = this.getIndex(period); 
         if(this.getPtD(period)==0. || this.getPtC(period)==0.) 
            return(-1);
         else if(this.getPtC(period)>this.getPtD(period)) 
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
      double getRetracement(int stdPeriod,double retLevel){
         int type = this.getType(stdPeriod);
         double ret = 0;
         switch(type){    
            case ORDER_TYPE_BUY: ret = this.getPtD(stdPeriod)+(retLevel*this.getCD(stdPeriod)); break;
            case ORDER_TYPE_SELL: ret = this.getPtD(stdPeriod)-(retLevel*this.getCD(stdPeriod)); break;
            default: Print("[ Symphony | Variables | Harmonics ] Error fetching retracement for ",
                     this.stdPeriodToString(stdPeriod)," on ",this.symbol," with %Ret = ",
                     DoubleToString(retLevel,3),". Last Error: ",ErrorDescription(GetLastError()));
         }
      };
      
      //--------------------------------------
      //   PRZ StopLoss Policy:
      //    1) ORDER_TYPE_BUY: StopLoss is PRZLow - ATR/6
      //    2) ORDER_TYPE_SELL: StopLoss is PRZHigh + ATR/6
      //---------------------------------------
      
      double getPRZStop(int stdPeriod){
         int type = this.getType(stdPeriod);
         double stop = 0;
         //------- for the rare case when the retracement zone has not formed ahead of the pattern
         if(this.getPRZHigh(stdPeriod)==0. || this.getPRZLow(stdPeriod)==0.){
            Print("[ Symphony | Variables | Harmonics ] PRZHigh or PRZLow does not exits for [",this.symbol,"|",this.stdPeriodToString(stdPeriod),
                  "]. Unable to set stop. Last Error: ",ErrorDescription(GetLastError()));
            return(-1);
         }
         switch(type){
            case ORDER_TYPE_BUY: stop = this.getPRZLow(stdPeriod) - iATR(this.symbol,stdPeriod,14,0)/6; break;
            case ORDER_TYPE_SELL: stop = this.getPRZHigh(stdPeriod) + iATR(this.symbol,stdPeriod,14,0)/6; break;
            default: Print("[ Symphony | Variables | Harmonics ] Unable to calculate initial stop. OrderType: ",
                     this.typeToString(type)," for [",this.symbol,"|",this.stdPeriodToString(stdPeriod),
                     "]. Last Error: ",ErrorDescription(GetLastError()));
         }
         stop = NormalizeDouble(stop,_Digits);
         return(stop);
      };
      //-----------------------
      //  Retracement Differential:
      //    -> Will calculate how far the current price has retraced the CD Leg
      //------------------------
      double getRetracementDiff(int stdPeriod){
         int type = this.getType(stdPeriod); 
         double currDiff,retDiff; 
         switch(type){
            case ORDER_TYPE_BUY: currDiff = this.askOrBid(ORDER_TYPE_BUY) - this.getPtD(stdPeriod); break;
            case ORDER_TYPE_SELL: currDiff = this.getPtD(stdPeriod) - this.askOrBid(ORDER_TYPE_SELL); break;
            default: Print("[ Symphony | Variables | Harmonics ] Unable to calculate retracement differential. OrderType: ",
                     this.typeToString(type)," for [",this.symbol,"|",this.stdPeriodToString(stdPeriod),
                     "]. Last Error: ",ErrorDescription(GetLastError()));
         }
         return(MathAbs(NormalizeDouble( (currDiff/this.getCD(stdPeriod)),_Digits)));
      };
      
      //----------------------------
      //  Helpers:
      //     1) AskOrBid - returns proper opening price
      //     2) AskOrBidClose - returns proper closing price 
      //-----------------------------
      double askOrBid(int type){
         switch(type){
            case ORDER_TYPE_BUY: return(Ask);
            case ORDER_TYPE_SELL: return(Bid);
            default: Print("[ Symphony | Variables | Harmonics ] OrderType undefined. Last Error: ",ErrorDescription(GetLastError())); break;
         }
      };
      double askOrBidClose(int type){
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
      
      void print(){
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
            line = StringConcatenate(line,this.format(this.periodToString(p)),"|");
         }
         Print(line);
         Print("[ Symphony | Variables] Symbol matrix for ",this.symbol);
      };
      
      //----- formatter
      string format(string s){ 
         if(s=="0.00000") return("        0.00         ");
         int sLen = 24;int l = StringLen(s);int p; string fs = "";
         if(l<sLen){
            p = sLen-l; int mid = p/2;int end = p-mid;
            while(mid>0){fs = StringConcatenate(" ",fs); mid--;} //... add begin spaces
            fs = StringConcatenate(fs,s);
            while(end>0){fs = StringConcatenate(fs," "); end--;} //.. add end spaces
         }
         return(fs);
      };
      
      string periodToString(int period){
         switch(period){
               case schema.periodM1: return("PERIOD_M1");
               case schema.periodM5: return("PERIOD_M5");
               case schema.periodM15: return("PERIOD_M15");
               case schema.periodM30: return("PERIOD_M30");
               case schema.periodH1: return("PERIOD_H1");
               case schema.periodH4: return("PERIOD_H4");
               case schema.periodD1: return("PERIOD_D1");
               default: return(StringConcatenate("[ Symphony | Variables | Harmonics ] PERIOD UNDEFINED. periodToString() [",period,"] Error: ",
                                                   ErrorDescription(GetLastError())));
               }
      };
      string stdPeriodToString(int period){
         switch(period){
               case PERIOD_M1: return("PERIOD_M1");
               case PERIOD_M5: return("PERIOD_M5");
               case PERIOD_M15: return("PERIOD_M15");
               case PERIOD_M30: return("PERIOD_M30");
               case PERIOD_H1: return("PERIOD_H1");
               case PERIOD_H4: return("PERIOD_H4");
               case PERIOD_D1: return("PERIOD_D1");
               default: return(StringConcatenate("[ Symphony | Variables | Harmonics ] PERIOD UNDEFINED. stdPeriodToString() [",period,"] Error: ",ErrorDescription(GetLastError())));
         }
               
      };
      string typeToString(int t){
         if(t==ORDER_TYPE_BUY) return("ORDER_TYPE_BUY");
         else if(t==ORDER_TYPE_BUY) return("ORDER_TYPE_SELL");
         else if(t==-1) return("Error_Type");
         else return("No Type");
      };
      //------------------------------------
      // Symphony -> Print Current Retracement
      //   Present the current ratio of price to leg
      //
      //---------------------------------------
      
      void printCurrentRetracement(int period){
         double x = MathAbs(this.askOrBid(this.getType(period))-this.getPtD(period));
         double ret = x/this.getCD(period);
         Print("[ Symphony | Variables | printCurrentRetracement ] For ",this.stdPeriodToString(period)," %",
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


class OrderHandler
{
   int stdPeriod;
   string symbol;
   double stoploss;
   double takeprofit;
   string label;
   int ticket;
   int magic_number;
   SymphonyMagic symphony_magic;
   RiskManager risk_manager;
   Harmonics h;
   double Risk;
   string orderHistoryFile;
   static double spread;
   public:
      //---> Constructors
         //--> Summons:
         //     1) Risk management instance
         //     2) Harmonics instance
      OrderHandler(double stoploss,double takeProfit){
         this.stdPeriod=Period(); this.symbol = Symbol(); this.stoploss = stoploss;
         this.takeprofit = takeProfit; this.Risk = risk_manager.getRisk(); this.ticket = -1;
         
      }
      OrderHandler(int period, string symbol, double stoploss,double takeProfit){
         this.stdPeriod=period; this.symbol = symbol; this.stoploss = stoploss;
         this.takeprofit = takeProfit; this.Risk = risk_manager.getRisk(); this.ticket = -1;
         this.h.setSymbol(symbol);
      }
      //-------------------------
      //   This constructor will hook a trade in progress
      //-----------------------------------
      OrderHandler(int ticket){
         this.ticket = ticket; this.Risk = risk_manager.getRisk();
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)){
            this.stoploss = OrderStopLoss();
            this.takeprofit = OrderTakeProfit();
            this.symbol = OrderSymbol();
         }
         else if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)){
            this.symbol = OrderSymbol();
            double profit = OrderProfit();
            Print("[ Symphony | Order Handler ] Constructor was given a ticket that was already closed on ",this.symbol,". Profit: ",DoubleToString(profit,2));
         }
         else{ Print("[ Symphony | Order Handler ] Error. Ticket: ",this.ticket);}
         this.stdPeriod = symphony_magic.getPeriodByMagicNumber(OrderMagicNumber());
         this.h.setSymbol(this.symbol);
      }
   int order_send(){
      int type;
      if(this.stoploss>this.takeprofit)
         type = ORDER_TYPE_SELL;
      else if(this.stoploss<this.takeprofit)
         type = ORDER_TYPE_BUY;
      else {Print("[ Symphony | OrderHandler ] Encountered a problem with StopLoss: ",DoubleToString(this.stoploss,_Digits),
                 " and TakeProfit: ",DoubleToString(this.takeprofit,_Digits)," on ",this.symbol," | ",h.stdPeriodToString(stdPeriod));
                 return(-1);
                 }
  
      double openAt = h.askOrBid(type);
      double lotSize = risk_manager.positionSize(this.stoploss, this.Risk); 
      this.spread = MarketInfo(this.symbol,MODE_SPREAD);
      this.magic_number = symphony_magic.getMagicNumber(this.stdPeriod,this.symbol);                
      this.ticket = OrderSendReliable(this.symbol,type,lotSize,openAt,spread,this.stoploss,this.takeprofit,
                                      h.stdPeriodToString(this.stdPeriod),this.magic_number,0,Blue);
      Print("(Potential order type) ",h.typeToString(type));
      Print("[ Symphony | Variables | OrderHandler ] Order placed. Risk Reward 1:",DoubleToString(MathAbs(openAt-this.takeprofit)/MathAbs(openAt-this.stoploss),2));
      return(ticket);
   };
   //---------------------------------
   //  order_close:
   //    > Closes order based on ticket. Resets order information if successful,
   //      Prints error if failure.
   //---------------------------------------------
   
   bool order_close(int ticket){
      OrderSelect(ticket,SELECT_BY_TICKET);
      if(OrderCloseReliable(ticket,OrderLots(),h.askOrBidClose(OrderType()),0,Red)){
         OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY);
         Print("[ Symphony | Variables | OrderHandler ] Order closed for ticket #",ticket,". Profit: $",DoubleToString(OrderProfit(),2));
         this.stoploss = 0; this.takeprofit = 0; this.ticket = 0; this.stdPeriod = 0;
         return(true);
      }
      else{
         Print("[ Symphony | Variables | OrderHandler ] Failed to close order for ticket #",ticket,". Last Error: ",ErrorDescription(GetLastError()));
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
         Print("[ Syphony | Variables | OrderHandler ] Invalid lotsToClose: ",DoubleToString(lotsToClose,2)," with order lots = ",DoubleToString(OrderLots(),2));
         return(-1);
      }
      else if(lotsToClose==OrderLots()){
         Print("[ Syphony | Variables | OrderHandler ] Lots to close is equal to OrderLots. Closing anyways.");
         this.order_close(ticket);
      }
      else{ //--> Else if the lots to close are valid
         int magic = OrderMagicNumber();
         int newTicket;
         if(OrderCloseReliable(ticket,OrderLots(),h.askOrBidClose(OrderType()),0,Red)){ 
            newTicket  = this.symphony_magic.getTicketByMagicNumber(magic);
            OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY);
            Print("[ Symphony | Variables | OrderHandler ] Partial closing successful for ticket #",ticket,
                   ". Partial Profit: $",DoubleToString(OrderProfit(),2),". The new ticket is: T#",newTicket);
            //----> Update OrderHandler ticket
            this.ticket = newTicket;
            return(newTicket);
         }
         else{ Print("[ Symphony | Variables | OrderHandler ] Error taking partial profits for T#",ticket,
                     ". LotsToClose: ",DoubleToString(lotsToClose,2)," Last Error: ",ErrorDescription(GetLastError()));
                     return(-1);
         }
      }
   };
   
   //##########################
   //#  SETTER & GETTERS
   //##########################
   void   setOrderHistoryFile(string path) {this.orderHistoryFile = path;};
   void   setStopLoss(double stop)         {this.stoploss = stop;};
   void   setTakeProfit(double tp)         {this.takeprofit=tp;};
   void   setStdPeriod(int stdPeriod)      {this.stdPeriod = stdPeriod;};
   void   setSymbol(string s)              {this.symbol = symbol;};
   void   setLabel(string l)               {this.label = l;};
   
   double getStopLoss()                    {return(this.stoploss);};
   double getTakeProfit()                  {return(this.takeprofit);};
   int    getStdPeriod()                   {return(this.stdPeriod);};
   int    getTicket()                      {return(this.ticket);};
   int    getLabel()                       {return(this.label);};
   int    getMagicNumber()                 {return(this.magic_number);};
   
};

/*

//--------------- More/Less verbosity
extern bool verbosity = true;
//----------------------------------------------------------------------------
//    Global Variables:
//       -> These are the global variables of interest calculated by indicators
//----------------------------------------------------------------------------
//--------------------------------
//   Indicator Policy:
//       1) ZUP v120 ("_120")
//       2) ZUP v135 ("_135")
//--------------------------------

string zup_version = "_135";
//-------------------------------------------------------------
//  Pair Policy:
//       -> sym will be initialized to the current
//          chart's symbol. It can be modified in two ways
//          1) Call to refresh indicators with a specific 
//             pair if setSymbol is false
//          2) Call to setSymbol()
//              a) This method set 'setSymbol' to true.
//       -> If 'symbolSet' is true, all changes to pair will have 
//          to be set using setSymbol(), or unsetSymbol() will have to be called

//-------------------------------------------------------------

//----------------------------------
//  OrderSend:
//
//    Distinct from other functions in several ways:
//       -> Depends on Symphony_Magic and Symphony_RiskManagement
//       -> Independent of global variable "sym"
//
//  Parameter Setting:
//    1) lotSize - Determined dynamically
//    2) Spread is stored
//    3) Magic number set via period and Symbol
//    4) Risk
//----------------------------
//----------------------------------


//---------------------------
// Print Functions:
//    1) print() -> pretty print
//    2) format() -> centers the variable
//    3) periodToString() -> takes index from period schema and returns
//       string representation
//    4) stdPeriodToString() -> Takes standard period and returns
//       string representation
//----------------------------

void vars.print(){
   string line = "|";
   for(int i =0; i<numOfVectors;i++){
      for(int p=0;p<periodIndexLength;p++){
         string zupVar = DoubleToStr(vectors[def.get(globalID[i])][p],5);
         line = StringConcatenate(line,vars.format(zupVar),"|");  
      }
      line = StringConcatenate(line,"   ",globalID[i]);
      Print(line); line = "|";
   }
   for(p=0;p<periodIndexLength;p++){
      line = StringConcatenate(line,vars.format(vars.periodToString(p)),"|");
   }
   Print(line);
   Print("[ Symphony | Variables] Symbol matrix for ",sym);
}

//----- formatter
string vars.format(string s){ 
   if(s=="0.00000") return("        0.00         ");
   int sLen = 19;int l = StringLen(s);int p; string fs = "";
   if(l<sLen){
      p = sLen-l; int mid = p/2;int end = p-mid;
      while(mid>0){fs = StringConcatenate(" ",fs); mid--;} //... add begin spaces
      fs = StringConcatenate(fs,s);
      while(end>0){fs = StringConcatenate(fs," "); end--;} //.. add end spaces
   }
   return(fs);
}

string vars.periodToString(int period){
   if(period==noType) return("noType");
   switch(period){
         case periodM1: return("PERIOD_M1");
         case periodM5: return("PERIOD_M5");
         case periodM15: return("PERIOD_M15");
         case periodM30: return("PERIOD_M30");
         case periodH1: return("PERIOD_H1");
         case periodH4: return("PERIOD_H4");
         case periodD1: return("PERIOD_D1");
         case noType: return("noType");
         default: return(StringConcatenate("[ Variables ] PERIOD UNDEFINED. periodToString() [",period,"] Error: ",ErrorDescription(GetLastError())));
         }
}
string vars.stdPeriodToString(int period){
   if(period==noType) return("noType");
   switch(period){
         case PERIOD_M1: return("PERIOD_M1");
         case PERIOD_M5: return("PERIOD_M5");
         case PERIOD_M15: return("PERIOD_M15");
         case PERIOD_M30: return("PERIOD_M30");
         case PERIOD_H1: return("PERIOD_H1");
         case PERIOD_H4: return("PERIOD_H4");
         case PERIOD_D1: return("PERIOD_D1");
         case noType: return("noType");
         default: return(StringConcatenate("[ Variables ] PERIOD UNDEFINED. stdPeriodToString() [",period,"] Error: ",ErrorDescription(GetLastError())));
   }
         
}
string vars.typeToString(int t){
   if(t==OP_BUY) return("OP_BUY");
   else if(t==OP_SELL) return("OP_SELL");
   else if(t==-1) return("Error_Type");
   else return("No Type");
}
//------------------------------------
// Symphony -> Print Current Retracement
//   Present the current ratio of price to leg
//
//---------------------------------------

void vars.printCurrentRetracement(int period){
   int index = vars.getI(period);
   Print("[ Symphony | Variables | printCurrentRetracement ] For ",vars.stdPeriodToString(period)," %",
          DoubleToStr(vars.currentRetracement(period)*100,2));
}


*/