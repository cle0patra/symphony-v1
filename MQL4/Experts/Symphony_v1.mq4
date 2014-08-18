//+------------------------------------------------------------------+
//|                                                  Symphony_v1.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""
#include <Symphony_Variables.mqh>
#include <OrderReliable.mqh>
#include <Symphony_RiskManagement.mqh>
#include <Symphony_Magic.mqh>
#include <stdlib.mqh>
#include <stderror.mqh> 

//----------------------
//  Risk Policy:
//    -> %Risk per each trade
//----------------------

double Risk = 0.02;

//------------------------
// File Operations:
//    -> File name to be written to. Will contain details of the trade.
//------------------------

string orderHistoryFile = "Symphony_OrderHistory.csv";
string logFile = "Symphony_Log.csv";

//-----------------------
// Verbosity:
//    -> Toggle verbosity level
//-----------------------

//bool verbosity = true;

//--------- New bar?
bool newBar;
//-----> current ticket
int ticket = -1;
//-----------------------
// DEBUG_FRAMEWORK:
//    1) Repaint Container
//       -> Holds a baseline of relevant points at order open 
//--------------------------
      //----> Original points
double ogPtC,ogPtD,ogPRZHigh,ogPRZLow;

//----------------------------------------------------
//  PERIOD_X:
//    -> Period of interest, not necessarily in frame
//----------------------------------------------
int stdPeriod = 0;

//+-----------------------------------------------------------
//|  Initialization:
//|    -> Check for open orders on load
//|-----------------------------------------------------------

int init(){
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
         ticket = OrderTicket();
   }
   return(0);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//|  Flow:                                                           |
//|    1) Refresh all indicators on each new bar.                    |
//|    2) Check to see if there are open orders on our Symbol
//|       a) If there are, make sure all have been written to file 
//|       b) If there are not, analyze the chart to determine opening
//|          i) Open if: Current, in range of retracement, and all 
//|             data points (PRZ_HIGH/LOW, PointD, CurrentZZ, etc...)
//|             are present.
//+------------------------------------------------------------------+
int start()
  {
//----
   //----- DEBUG will also use new bar condition
   newBar = symphony.newBar();
   if(newBar)
      vars.refreshIndicators(Symbol());
   //------------------------------
   //  Order open policy: 
   //     1) Descending (Search highest to lowest timeframes)
   //     2) Pattern must be current (as defined by ZZ)
   //     3) Current price must be above/below relevant PRZ and above/below relevant retracement
   //     
   //    ###############################
   //
   // ..... Begin order open block.....
   //    -> Orders should be constrained by their SL/TP levels, so close 
   //       block is unnecessary (for now)
   //-----------------------------------
   if(ticket==-1){
      for(int p=periodD1; (p>=periodM15 && ticket==-1) ;p--){ // ... while we have not opened an order and we have periods left, then loop
         stdPeriod = vars.getStdPeriod(p);
         // ... if the pattern is current
         if(symphony.isCurrent(stdPeriod)){
            if(vars.visiblePattern(stdPeriod)){ //... and the PRZ exists -> In some cases pattern forms w/o PRZ present
               if(symphony.inRange(stdPeriod)){ //... and is between the relevant PRZ edge and partial retracement level
                  //--------------------------------------------------
                  //  Parameter:
                  //    1) StopLoss - PRZ range extended with ATR
                  //    2) TakeProfit - Point C
                  //    ... ordersend will do the rest
                  //--------------------------------------------------
                     //---> Calculate stoploss and take profit
                  double stopLoss = vars.getPRZStop(stdPeriod);
                  double takeProfit = vars.getPtC(stdPeriod);
                  int type = vars.getType(stdPeriod);
                     //----> Send order
                  ticket = vars.ordersend(Symbol(),stdPeriod,stopLoss,takeProfit,Risk,orderHistoryFile);
                  //---------------------------------------------------------
                  //  DEBUG_FRAMEWORK:
                  //    1) symphony.consistencyCheck 
                  //          -> provide information regarding consistencies/inconsistencies 
                  //             with order parameters
                  //    2) symphony.setRepaintBaseline
                  //          -> Contains repaints, writes to log file if any repaints are detected
                  //----------------------------------------------------------
                  symphony.consistencyCheck(stopLoss,takeProfit,vars.askOrBid(type),type,stdPeriod);
                  symphony.setRepaintBaseline(vars.getPtC(stdPeriod), vars.getPtD(stdPeriod), vars.getPRZHigh(stdPeriod),vars.getPRZLow(stdPeriod));
              } //--> Close inRange block
            } //--> Close PRZ block
            //--- for PRZ (?=0) block -> Condition 2
            else
               symphony.checkPRZ(stdPeriod);
               
            //---- end PRZ block
         } //--> Close condition 1
         
            //--> If no order was opened and we desire verbosity, print best guess as to why order was unopened
            if(ticket==0 && verbosity==true)
               Print(symphony.whyNoOrder(stdPeriod));
            
      }
   }
   //-----------------------------------
   // ..... Close order open block.....
   //-----------------------------------
   
   //-----------------------------------
   // TRADE_MONITOR:
   //    -> If ticket is no longer open, write information
   //       to file 
   //       -> Done after order close so we can write profit with the ticket
   //    -> Writes to OrderLog after ticket has been closed. 
   // TODO: XML formatted. No good reason.
   //-----------------------------------
   
   if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)){
      symphony.writeTradeToFile(ticket);
      ticket = -1; // Trade closed, so nullify ticket
   }
   //------------------------------
   //   DEBUG_FRAMEWORK:
   //     -> Repaint container
   //------------------------------
   if(newBar)
       //symphony.containRepaints(vars.getPtC(stdPeriod),vars.getPtD(stdPeriod),vars.getPRZHigh(stdPeriod),vars.getPRZLow(stdPeriod));
   //----
   return(0);
  }
//+------------------------------------------------------------------+

//------------------------
//   inRange:
//    -> Current price must be above PRZLow if it is a buy, or vice versa if short
//    -> Current price must be below 23.6% retracement and vice versa
//--------------------------

bool symphony.inRange(int stdPeriod){
   static bool retNotify = false;
   switch(vars.getType(stdPeriod)){
      case OP_BUY: if(vars.askOrBid(OP_BUY)>vars.getPRZLow(stdPeriod) && vars.askOrBid(OP_BUY)<vars.getRetracement(stdPeriod,0.236)) return(true);
                   break;
      case OP_SELL: if(vars.askOrBid(OP_SELL)<vars.getPRZHigh(stdPeriod) && vars.askOrBid(OP_SELL)>vars.getRetracement(stdPeriod,0.236)) return(true);
                   break;
      default: return(false);
   }
   //------------------------------------
   // -> If verbosity is desired, elaborate on why retracement check failed.
   //-------------------------------------
   
   if(verbosity && Period()==stdPeriod){
      double acDiff = 0, rDiff = vars.getRetracementDiff(stdPeriod);
      acDiff = MathAbs(rDiff-0.236); acDiff*=100; rDiff*=100;
      //------ Prints only one notice
      if(retNotify==false){
         Print("[Symphony|",sym,"|",vars.stdPeriodToString(stdPeriod),"] Retracement was out of range by %",DoubleToStr(acDiff,1), 
       ". Actual retracement was: %",DoubleToStr(rDiff,5));
         retNotify=true;
     }
   }
   return(false);
}

//------------------------------------------------------------------------------
//    symphony.isCurrent()
//       -> Will determine if the chart pattern is viable
//       Policy:
//          -> If Current ZigZag is equal to the current Point D, 
//             the pattern is current
//          -> Adjust for marginal differences. We will use a 5 pip error allowance.
//       -> Print error details if function fails
//-------------------------------------------------------------------------------

bool symphony.isCurrent(int stdPeriod){
   double differential = 5*Point; //... default differential
   double ptDiff = MathAbs(vars.getZZ(stdPeriod)-vars.getPtD(stdPeriod));
   if(ptDiff<=differential) 
      return(true);
   else{
      if(verbosity) 
         if(Period()==stdPeriod) 
            if(newBar)
               Print("[Symphony|E] ZigZag and Point D were not the same for [",sym,"|",vars.stdPeriodToString(stdPeriod),
                     "]. Differential [",DoubleToStr(ptDiff,Digits)," Point D: ",DoubleToStr(vars.getPtD(stdPeriod),Digits),
                     " : ZZZ: ",DoubleToStr(vars.getZZ(stdPeriod),Digits));
      return(false);
   }
}
//----------------------------------
//   symphony.writeTradeToFile:
//      -> Output trade data into a csv file for future reference
//      -> Will obtain order information through ticket number
//      Order:
//          1) Ticket, Open price, Symbol, type, period, Stop Loss, Take Profit, Lots, magic number, open time
//-----------------------------------

void symphony.writeTradeToFile(int ticket){
   string strPeriod = "";
   //----> Get period by ticket
   if(ticket>0){
      OrderSelect(ticket,SELECT_BY_TICKET); 
      strPeriod = vars.stdPeriodToString(magic.getPeriod(OrderMagicNumber()));
   }
   else{   //--> Invalid ticket
      if(verbosity)
         Print(" [ Symphony ] Invalid ticket: ",ticket," Last Error: ",ErrorDescription(GetLastError()));
   }
   //-----> Trade information to write
   //---------> Open time, open price, ticket, order period :: profit will be written to the line in separate function
   string info = StringConcatenate(OrderTicket(),TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS),OrderOpenPrice(),strPeriod,OrderProfit(),vars.typeToString(OrderType()));
   /// ------ Write to Sumphony_OrderHistory.csv -----
   symphony.writeToFile(orderHistoryFile,info);
}

//----------------------------
//   Write to file:
//      -> Write specified string to specified file 
//      -> Helper for writeTradeToFile
//----------------------------

void symphony.writeToFile(string info, string file){
   int Handle = FileOpen(file,FILE_CSV|FILE_READ|FILE_WRITE,";");//File opening
   if(Handle==-1){                    // Failed file opening
     Print("[ Symphony ] Unable to open file. Last Error: ",ErrorDescription(GetLastError()));
     return;                          // Exir start()      
   }
   else{
     FileSeek(Handle, 0, SEEK_END);   // append to the end
     int err = FileWrite(Handle,info);
     if(err<0) 
      Print("File could not be written, last error has code: ",ErrorDescription(GetLastError())); 
     else Print("File opened and written to successfully.");
     FileClose(Handle);
   }
}
//------ Check for new Bar            
bool symphony.newBar(){
   static datetime New_Time=0;
   if(New_Time!=Time[0]){
   New_Time=Time[0];
   return(true);}
return(false);}


//##################################################
//
//    DEBUG_FRAMEWORK:
//       1) symphony.consistencyCheck
//          Checks:
//             a) Do the stopLoss and takeProfit make sense for the order?
//             b) Is there actually a current chart pattern?
//             c) If there is a current chart pattern, is the type correct? Are the stops correct?
//       2) symphony.repaintContainer
//          Tracks:
//             -> Changes in baseline pattern (first pattern registered on chart)
//                -> I.e. repaints
//
//##################################################

void symphony.consistencyCheck(double stopLoss, double takeProfit, double openPrice, int type, int stdPeriod){
   //.... Current pattern check
   int testType; string testTypeString = "";
   if(vars.getPtC(stdPeriod)>vars.getPtD(stdPeriod))
      testType = OP_BUY;
   else if(vars.getPtC(stdPeriod)<vars.getPtD(stdPeriod))
      testType = OP_SELL;
   else testType = -1;
   
   //... print inputs
   Print("[Symphony | DEBUG] on [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),"] which is this chart? ",Period()==stdPeriod," Inputs -> [SL : ",
         DoubleToStr(stopLoss,Digits),"| TP : ",DoubleToStr(takeProfit,Digits)," | openPrice : ",DoubleToStr(openPrice,Digits)," | orderType : ",
         vars.typeToString(type)," | RelevantPeriod : ",vars.stdPeriodToString(stdPeriod)."]");
   //---> Type test
   if(testType!=-1){
      if(testType==vars.getType(stdPeriod))
         testTypeString = StringConcatenate("[Symphony | DEBUG] Correctly assigned order type for pattern on [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),"] as ",vars.typeToString(testType));
      else testTypeString = StringConcatenate("[Symphony | DEBUG] Type mismatch for [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),
                            "] => Got ",vars.typeToString(vars.getType(stdPeriod))," when test reads ",vars.typeToString(testType));
   }
   else testTypeString = StringConcatenate("[Symphony | DEBUG] Error type order",vars.getType(testType)," on [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),"]");
   
   string riskManString = "";
   switch(testType){
      case OP_BUY: if(stopLoss>openPrice){
                     riskManString = StringConcatenate("[Symphony | DEBUG] Stoploss incorrectly placed for order on [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),"]");
                   }
                   if(takeProfit<openPrice){ 
                     riskManString = StringConcatenate(riskManString,"[Symphony | DEBUG] Takeprofit incorrectly placed for order on [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),"]");
                  }
     case OP_SELL: if(stopLoss<openPrice){
                     riskManString = StringConcatenate("[Symphony | DEBUG] Stoploss incorrectly placed for order on [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),"]");
                   }
                   if(takeProfit>openPrice){ 
                     riskManString = StringConcatenate(riskManString,"[Symphony | DEBUG] Takeprofit incorrectly placed for order on [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),"]");
                  }
     default: break;
   }
   Print(riskManString);
}

//-----------------------
//  Baseline:
//    -> Holds relevant points of the first registered pattern
//-------------------------------------------

void symphony.setRepaintBaseline(double ptC, double ptD, double przHigh, double przLow){ogPtC=ptC;ptD=ogPtD;przHigh=ogPRZHigh;przLow=ogPRZLow;}

//---------------------------
// REPAINT_CONTAINER:
//    -> Notify when a new pattern has been registered on the chart
//----------------------------------

void symphony.containRepaints(double ptC, double ptD, double przHigh, double przLow){
   if(ogPtC==0. || ptD==0. || przHigh==0. || przLow==0.){
      //--> Original pattern points have not been recorded if there was no last error.
      int last_error = GetLastError();
      if(verbosity && last_error!=ERR_NO_ERROR) 
         Print("[Symphony] REPAINT_ERROR: Empty values on [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),"] Last Error: ",ErrorDescription(last_error));
      
      }
   else if(ogPtC!=ptC || ptD!=ogPtD || przHigh!=ogPRZHigh || przLow!=ogPRZLow){
      string rp = StringConcatenate("[ Symphony | REPAINT_CONTAINMENT ] New Points [Point C: ",DoubleToStr(ptC,Digits),"|Point D: ",DoubleToStr(ptD,Digits),"|PRZ_High: ",DoubleToStr(przHigh,Digits),"|PRZ_Low: ",DoubleToStr(przLow,Digits),"] @ ",TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS));
      symphony.writeToFile(logFile,rp);
   }
}

//-------------------------------------
//   ERROR_CORRECTION:
//     For Symphony main order loop
//     -> Prints infomation as to why order opening failed, 
//        as well as information on particulars
//-------------------------------------

//---------------------------------------
//  symphony.whyNoOrder
//    -> Returns string with reason for no order opening
//-------------------------------------

string symphony.whyNoOrder(int stdPeriod){
   string whyNoOrder = StringConcatenate("[ Symphony | Main Loop ] Order for ",vars.stdPeriodToString(stdPeriod)," not opened because: ");
   if(!symphony.isCurrent(stdPeriod))
      whyNoOrder = StringConcatenate(whyNoOrder,"order is not current");
   else if(!vars.visiblePattern(stdPeriod))
      whyNoOrder = StringConcatenate(whyNoOrder,"order is not current or there is no visible pattern");
   else if(!symphony.inRange(stdPeriod))
     whyNoOrder = StringConcatenate(whyNoOrder,"order is out of range");
   else
     whyNoOrder = StringConcatenate(whyNoOrder,"cannot identify fault.");
   return(whyNoOrder);
}

void symphony.checkPRZ(int stdPeriod){
   if(vars.getPRZHigh(stdPeriod)==0.) 
      if(verbosity && Period()==stdPeriod ) 
           Print("[ Symphony|E ] No PRZ_HIGH for [",sym,"|",vars.stdPeriodToString(stdPeriod),"]");
   if(vars.getPRZLow(stdPeriod)==0.) 
      if(verbosity && Period()==stdPeriod) 
           Print("[ Symphony|E ] No PRZ_LOW for [",sym,"|",vars.stdPeriodToString(stdPeriod),"]");
   if(vars.getPRZHigh(stdPeriod)!=0. && vars.getPRZLow(stdPeriod)!=0.)
      if(verbosity && Period()==stdPeriod)
         Print("[ Symphony|E ] Order tripped PRZ condition, but there were zones visible on the chart for [",Symbol(),"|",vars.stdPeriodToString(stdPeriod),"]");
   
}


