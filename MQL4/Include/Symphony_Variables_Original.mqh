//+------------------------------------------------------------------+
//|                                           Symphony_Variables.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""
#include <stdlib.mqh>
#include <Symphony_Definitions.mqh>
#include <Symphony_Magic.mqh>
#include <OrderReliable.mqh>
#include <Symphony_RiskManagement.mqh>
#define numOfVectors 13 // for loops

//---------------- period schema
#define periodM1 0 
#define periodM5 1
#define periodM15 2
#define periodM30 3
#define periodH1 4
#define periodH4 5
#define periodD1 6

//---------------- for Loops

#define periodIndexLength 7

double vectors[numOfVectors][periodIndexLength];

//--------------- More/Less verbosity
extern bool verbosity = true;
//----------------------------------------------------------------------------
//    Global Variables:
//       -> These are the global variables of interest calculated by indicators
//----------------------------------------------------------------------------
string globalID[] = {"PRZ_HIGH", "PRZ_LOW","POINT_X", "POINT_A","POINT_B", "POINT_C", "POINT_D","XA_LEG", 
                     "AB_LEG", "BC_LEG", "CD_LEG", "ZigZagZug","ZigZagZug_Start"};
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
string sym = "";
bool symbolSet = false;

void vars.setSymbol(string symb){
   if(!symbolSet) symbolSet = true;
   sym = symb;
}
void vars.unsetSymbol(){symbolSet=false;}


//------------------------------------------
// refreshIndicators:
//    -> Takes parameter sym, will set if symbol 
//       has not already been set
//    -> Call in order to update global variables
//
//------------------------------------------ 
void vars.refreshIndicators(string s){
   if(s=="") sym = Symbol();
   if(!symbolSet) sym = s;
   
   double exbuffer;
   for(int i=periodM1;i<=periodD1;i++){
    int stdPeriod = vars.getStdPeriod(i);
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
   
   for(i = 0;i<periodIndexLength;i++){
      stdPeriod = vars.getStdPeriod(i);
      for(int p=0;p<numOfVectors;p++){ //... globalID[p] = ZUP parameter
         if(globalID[p]=="ZigZagZug" || globalID[p]=="ZigZagZug_Start")
            vectors[def.get(globalID[p])][i] = GlobalVariableGet(StringConcatenate(globalID[p],sym,stdPeriod));
         else vectors[def.get(globalID[p])][i] = GlobalVariableGet(StringConcatenate(globalID[p],zup_version,sym,stdPeriod));
         }
   }
}


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
int vars.ordersend(string symbol, int stdPeriod, double stopLoss, double takeProfit,double Risk,string orderHistoryFile){
  int type = vars.getType(stdPeriod);
  
  double openAt = vars.askOrBid(type);
  double lotSize = risk.positionSize(stopLoss, Risk); 
  static double spread; spread = MarketInfo(symbol,MODE_SPREAD);
  int magic = magic.getMagicNumber(stdPeriod,symbol);                
  int ticket = OrderSendReliable(Symbol(),type,lotSize,openAt,spread,stopLoss,takeProfit,vars.stdPeriodToString(stdPeriod),magic,0,Blue);
  Print("(Potential order type) ",vars.typeToString(type));
  Print("[ Symphony | Variables ] Order placed. Risk Reward 1:",DoubleToStr(MathAbs(openAt-takeProfit)/MathAbs(openAt-stopLoss),2));
  return(ticket);
}


//-----------------------------------
// Getters:
//     1) PRZ_HIGH
//     2) PRZ_LOW 
//     3) POINT_X
//     4) POINT_A
//     5) POINT_B 
//     6) POINT_C 
//     7) POINT_D
//     8) XA_LEG
//     9) AB_LEG
//     10) BC_LEG
//     11) CD_LEG
//     12) ZigZagZug
//     13) ZigZagZug_Start
//-----------------------------------

double vars.getPRZHigh(int period){Print("[Symphony|Vars] vars.getPRZHigh: ",DoubleToStr(vectors[def.get("PRZ_HIGH")][i],Digits)," def.get(\"PRZ_HIGH\"):",def.get("PRZ_HIGH"));int i = vars.getI(period);return(vectors[def.get("PRZ_HIGH")][i]);}
double vars.getPRZLow(int period){int i = vars.getI(period);return(vectors[def.get("PRZ_LOW")][i]);}
double vars.getPtX(int period){int i = vars.getI(period);return(vectors[def.get("POINT_X")][i]);}
double vars.getPtA(int period){int i = vars.getI(period);return(vectors[def.get("POINT_A")][i]);}
double vars.getPtB(int period){int i = vars.getI(period);return(vectors[def.get("POINT_B")][i]);}
double vars.getPtC(int period){int i = vars.getI(period);return(vectors[def.get("POINT_C")][i]);}
double vars.getPtD(int period){int i = vars.getI(period);return(vectors[def.get("POINT_D")][i]);}
double vars.getXA(int period){int i = vars.getI(period);return(vectors[def.get("XA_LEG")][i]);}
double vars.getAB(int period){int i = vars.getI(period);return(vectors[def.get("AB_LEG")][i]);}
double vars.getBC(int period){int i = vars.getI(period);return(vectors[def.get("BC_LEG")][i]);}
double vars.getCD(int period){int i = vars.getI(period);return(vectors[def.get("CD_LEG")][i]);}
double vars.getZZ(int period){int i = vars.getI(period);return(vectors[def.get("ZigZagZug")][i]);}
double vars.getZZStart(int period){int i = vars.getI(period);return(vectors[def.get("ZigZagZug_Start")][i]);}

//-----------------------------------------
//  Visible Pattern
//    -> Returns true if there is a pattern anywhere on the chart
//       (the matrix)
//----------------------------------------

bool vars.visiblePattern(int period){
   return(vars.getPtX(period)==0. &&
      vars.getPtA(period)==0. &&
      vars.getPtB(period)==0. &&
      vars.getPtC(period)==0. &&
      vars.getPtD(period)==0.);
}
//----------------------
//  Type Getter:
//    -> OP_BUY if PointD < PointC
//    -> OP_SELL if PointD > PointC
//    -> -1 if there was an inconsistency
// ... Note: Use switch statements when dealing with order types. Always make sure to return a value which, if the function
// ... misbehaves, will make order execution impossible.
//--------------------------------------------------

int vars.getType(int period){int i = vars.getI(period); if(vars.getPtD(period)==0. || vars.getPtC(period)==0.) return(-1);
   else if(vars.getPtC(period)>vars.getPtD(period)) return(OP_BUY); else return(OP_SELL);}

//-----------------------------------
//  Fibonacci Retracement:
//    -> Will first determine ordertype by calling vars.getType()
//    -> Retracement level should be provided with an arithmetic decimal (e.g. 23.6% retracement = .236)
//    -> Returns retracement value of CD Leg
//---------------------------------------
double vars.getRetracement(int stdPeriod,double retLevel){
   int type = vars.getType(stdPeriod);
   double ret = 0;
   switch(type){    
      case OP_BUY: ret = vars.getPtD(stdPeriod)+(retLevel*vars.getCD(stdPeriod)); break;
      case OP_SELL: ret = vars.getPtD(stdPeriod)-(retLevel*vars.getCD(stdPeriod)); break;
      default: Print("[S_Vars|W] Error fetching retracement for ",vars.stdPeriodToString(stdPeriod)," on ",sym," with %Ret = ",DoubleToStr(retLevel,3),". Last Error: ",ErrorDescription(GetLastError()));
   }
}

//--------------------------------------
//   PRZ StopLoss Policy:
//    1) OP_BUY: StopLoss is PRZLow - ATR/6
//    2) OP_SELL: StopLoss is PRZHigh + ATR/6
//---------------------------------------

double vars.getPRZStop(int stdPeriod){
   int type = vars.getType(stdPeriod);
   double stop = 0;
   //------- for the rare case when the retracement zone has not formed ahead of the pattern
   if(vars.getPRZHigh(stdPeriod)==0. || vars.getPRZLow(stdPeriod)==0.){
      Print("[S_Vars][W] PRZHigh or PRZLow does not exits for [",sym,"|",vars.stdPeriodToString(stdPeriod),"]. Unable to set stop. Last Error: ",ErrorDescription(GetLastError()));
      return(-1);
   }
   switch(type){
      case OP_BUY: stop = vars.getPRZLow(stdPeriod) - iATR(sym,stdPeriod,14,0)/6; break;
      case OP_SELL: stop = vars.getPRZHigh(stdPeriod) + iATR(sym,stdPeriod,14,0)/6; break;
      default: Print("[S_Vars|W] Unable to calculate initial stop. OrderType: ",vars.typeToString(type)," for [",sym,"|",vars.stdPeriodToString(stdPeriod),"]. Last Error: ",ErrorDescription(GetLastError()));
   }
   stop = NormalizeDouble(stop,MarketInfo(sym,MODE_DIGITS));
   return(stop);
}

//-----------------------
//  Retracement Differential:
//    -> Will calculate how far the current price has retraced the CD Leg
//------------------------
double vars.getRetracementDiff(int stdPeriod){
   int type = vars.getType(stdPeriod); double currDiff,retDiff; 
   switch(type){
      case OP_BUY: currDiff = vars.askOrBid(OP_BUY) - vars.getPtD(stdPeriod); break;
      case OP_SELL: currDiff = vars.getPtD(stdPeriod) - vars.askOrBid(OP_SELL); break;
      default: Print("[S_Vars|W] Unable to calculate retracement differential. OrderType: ",
               vars.typeToString(type)," for [",sym,"|",vars.stdPeriodToString(stdPeriod),
               "]. Last Error: ",ErrorDescription(GetLastError()));
   }
   return(MathAbs(NormalizeDouble( (currDiff/vars.getCD(stdPeriod)),MarketInfo(sym,MODE_DIGITS))));
}

//-------------------------
//   Current Retracement:
//      -> Returns how far the current price 
//         has traveled along the CD leg
//      -> ([(Current Ask/Bid)- Point D]/CD)
//----------------------

double vars.currentRetracement(int period){
   double ratio = vars.askOrBid(vars.getType(period))-vars.getPtD(period)/vars.getCD(period);
   if(verbosity){ 
      if(ratio>1.) Print("[ Symphony | Variables | currentRetracement = OUT_OF_RANGE ] ",vars.typeToString(vars.getType(period)),
                                 " pattern out of range on [",sym,"|",vars.stdPeriodToString(period),"].");
      else Print("[ Symphony | Variables | currentRetracement = IN_RANGE@[%",DoubleToStr(ratio*100,2),"] ",vars.typeToString(vars.getType(period)),
                                 " there is an incomplete(<100%) pattern on the chart for [",
                                 sym,"|",vars.stdPeriodToString(period),"].");
   }
   return( vars.askOrBid(vars.getType(period))-vars.getPtD(period)/vars.getCD(period));
}
//--------------------------------------
//  Dynamic Array:
//     -> Will be indexed according to period schema
//     -> Updates and calls to the table will be ordered by built ins (i.e. PERIOD_X)
//------------------------------------
int vars.getI(int index){
   switch(index){
       case PERIOD_M1: return(periodM1);
      case PERIOD_M5: return(periodM5);
      case PERIOD_M15: return(periodM15);
      case PERIOD_M30: return(periodM30);
      case PERIOD_H1: return(periodH1);
      case PERIOD_H4: return(periodH4);
      case PERIOD_D1: return(periodD1);
      default: if(verbosity && GetLastError()!=0 && GetLastError()!=4002) Print("[ Variables ][ I ] Unable to grab indexed period  for vars.getI(",index,"). LastError: ",ErrorDescription(GetLastError())); return(-1);
   }
}
 //------------- inverse of the above
int vars.getStdPeriod(int index){
   switch(index){
      case periodM1: return(PERIOD_M1);
      case periodM5: return(PERIOD_M5);
      case periodM15: return(PERIOD_M15);
      case periodM30: return(PERIOD_M30);
      case periodH1: return(PERIOD_H1);
      case periodH4: return(PERIOD_H4);
      case periodD1: return(PERIOD_D1);
      default: if(verbosity) Print("[ - ][ I ] Unable to grab standard period. Input: ",index,". LastError: ",ErrorDescription(GetLastError())); return(-1);
   }
}


//----------------------------
//  Helpers:
//     1) AskOrBid - returns proper opening price
//     2) AskOrBidClose - returns proper closing price 
//-----------------------------
double vars.askOrBid(int type){
   RefreshRates();
   switch(type){
      case OP_BUY: return(Ask);
      case OP_SELL: return(Bid);
      default: Print("[ Variables ][EA] OrderType undefined. Last Error: ",ErrorDescription(GetLastError())); break;
   }
}
double vars.askOrBidClose(int type){
   RefreshRates();
   switch(type){
      case OP_BUY: return(Bid);
      case OP_SELL: return(Ask);
      default: Print("[ Variables ][EA] OrderType undefined. Last Error: ",ErrorDescription(GetLastError())); break;
   }
}
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


