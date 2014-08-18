//+------------------------------------------------------------------+
//|                                             Test_WriteToFile.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""
#include <Symphony_Variables.mqh>
#include <Symphony_Magic.mqh>
extern string file = "Symphony_OrderHistory.csv";
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   sym = Symbol();
   symphony.writeTradeToFile(-1);
//----
   return(0);
  }
//+------------------------------------------------------------------+

//----------- Cloned from Symphony_v1
//----------------------------------
//   symphony.writeToFile:
//      -> Output trade data into a csv file for future reference
//      -> Will obtain order information through ticket number
//      Order:
//          1) Ticket, Open price, Symbol, type, period, Stop Loss, Take Profit, Lots, magic number, open time
//
//
//-----------------------------------
/*
void symphony.writeToFile(int ticket,string file){
   int handle; string log = StringConcatenate(ticket,";");
   // ---- Open the file as write only
   handle=FileOpen(file,FILE_CSV|FILE_READ|FILE_WRITE,";");
   //----- Error check
   if(handle<1) Print("[Symphony|E] File ",file," not found, the last error is ", GetLastError());
   if(ticket>-1){
      OrderSelect(ticket,SELECT_BY_TICKET); string strPeriod = vars.stdPeriodToString(magic.getPeriod(OrderMagicNumber()));
      log = StringConcatenate("\n",log,DoubleToStr(OrderOpenPrice(),Digits),";",Symbol(),";",vars.typeToString(OrderType()),";",strPeriod,";",DoubleToStr(OrderStopLoss(),Digits),";",DoubleToStr(OrderTakeProfit(),Digits),";",DoubleToStr(OrderLots(),2),";",
            DoubleToStr(OrderMagicNumber(),0),";",TimeToStr(OrderOpenTime(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));
   }
   else{
      log = "\nTest Write to file";
   }
   FileSeek(handle,0,SEEK_END);
   int s = FileWrite(handle,log); 
   if(s<0){
       if(verbosity) Print("[Symphony|E] Failed to write to ",file," for ticket ",ticket,". Last Error: ",ErrorDescription(GetLastError())); 
   }
   else Print("[Symphony|S] Successfully wrote ",ticket," to ",file," on [",sym,"|",strPeriod,"]");     
}

*/
void symphony.writeTradeToFile(int ticket){
   string strPeriod = "";
   if(ticket>0){
      OrderSelect(ticket,SELECT_BY_TICKET); 
      strPeriod = vars.stdPeriodToString(magic.getPeriod(OrderMagicNumber()));
   }
   else{
      if(verbosity)
         Print(" [ Symphony ] Invalid ticket: ",ticket," Last Error: ",ErrorDescription(GetLastError()));
   }
      /// ------ Write to trades.csv -----
   int Handle = FileOpen(file,FILE_CSV|FILE_READ|FILE_WRITE,";");//File opening
      if(Handle==-1)                      // File opening fails
       {
         Print("[ Symphony ] Unable to open file. Last Error: ",ErrorDescription(GetLastError()));
         return;                          // Exir start()      
       }
      else{
         FileSeek(Handle, 0, SEEK_END);
         int err = FileWrite(Handle,TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS),OrderOpenPrice(),OrderTicket(),strPeriod);
         if(err<0) Print("File could not be written, last error has code: ",ErrorDescription(GetLastError())); else Print("File opened and written to successfully.");
         FileClose(Handle);
         }
   
}