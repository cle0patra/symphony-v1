//+------------------------------------------------------------------+
//|                                         Symphony_FileHandler.mqh |
//|                                                           Luke S |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      "http://www.mql5.com"
#include "stdlib.mqh"
#include "stderror.mqh"
#include "Symphony_Harmonics.mq4"
#include "Symphony_Magic.mq4"

class SymphonyFileHandler
{
   string file_name;
   int Handle;
   string info;
   SymphonyHarmonics h;
   SymphonyMagic symphony_magic;
   SymphonyStrings strings;
   public:
      SymphonyFileHandler(string file){
         this.set_handle(file);
      };
      SymphonyFileHandler(string file, string info){
         this.set_handle(file);
         this.info = info;
      };
      //----------------------------------
      //  setHandle:
      //     @param file - Path to file that FileHandler will manage
      //     > Will set the file handle. If the file opening fails, print why
      //--------------------------------------
      void set_handle(string file){
         int Handle = FileOpen(file,FILE_CSV|FILE_READ|FILE_WRITE,",");//File opening
         if(Handle==-1) Print("[ Symphony | FileHandler | Constructor ] Unable to open file ",file,". Last Error: ",
                              ErrorDescription(GetLastError())); 
         this.Handle = Handle;
         this.file_name = file;
      }
      //----------------------------------
      //   writeTradeToFile:
      //      -> Output trade data into a csv file for future reference
      //      -> Will obtain order information through ticket number
      //      Order:
      //          1) Ticket, Open price, Symbol, type, period, Stop Loss, Take Profit, Lots, magic number, open time
      //-----------------------------------
      void write_trade_to_file(int ticket){
         string strPeriod = "";
         //----> Get period by ticket
         if(ticket>0){
            OrderSelect(ticket,SELECT_BY_TICKET); 
            strPeriod = strings.standard_period_to_string(this.symphony_magic.get_period_by_magic_number(OrderMagicNumber()));
         }
         else{   //--> Invalid ticket
               Print(" [ Symphony | FileHander | WriteTradeToFile ] Invalid ticket: ",ticket,
                     " Last Error: ",ErrorDescription(GetLastError()));
         }
         //-----> Trade information to write
         //---------> Open time, open price, ticket, order period :: profit will be written to the line in separate function
         string info = StringConcatenate(OrderTicket(),TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS),OrderOpenPrice(),strPeriod,OrderProfit(),this.strings.type_to_string(OrderType()));
         /// ------ Write to Sumphony_OrderHistory.csv -----
         this.write_to_file(info);
      }
      //----------------------------------------
      //   write_to_file:
      //      > will write the provided information to the file
      //        specified by 'Handle' in the instance
      //---------------------------------------------
      void write_to_file(string info){
         FileSeek(this.Handle, 0, SEEK_END);   // append to the end
         int err = FileWrite(Handle,info);
         if(err<0) 
            Print("[ Symphony | FileHandler | WriteToFile ] File could not be written, last error has code: ",ErrorDescription(GetLastError())); 
         else Print("[ Symphony | FileHandler | WriteToFile ] File opened and written to successfully.");
         FileClose(this.Handle);
      };
        
};