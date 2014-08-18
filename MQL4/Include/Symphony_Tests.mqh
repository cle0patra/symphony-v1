//+------------------------------------------------------------------+
//|                                               Symphony_Tests.mqh |
//|                                                           Luke S |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Luke S"



#include "Symphony_Definitions.mqh"
#include "Symphony_Strings.mqh"
#include "Symphony_Magic.mqh"
#include "Symphony_Harmonics.mqh"
#include "Symphony_FileHandler.mqh"
#include "Symphony_RiskManagement.mq4"
#include "stdlib.mqh"
#include "stderror.mqh"


class SymphonyTests
{





};

class SymphonyHarmonicsTests : public SymphonyTests
{
   SymphonyHarmonics harmonics;
   //----------------------------------
   //  TODO:
   //     > Create function that highlights current pattern
   //       > FOR LATER: Will redraw when a repaint is processed and redraw PRZ/PtD in a lighter shade
   //  TESTS:
   //     > OrderHandler
   //       > First, process normal order
   //       > ID viable pattern and place order
   //     > FileHandler
   //       > Can write to file
   //       > Can check for an existing ticket in file
   //         > Can ovewrite this line if we need to add additional information (like partial close profit)...maybe unnecessary
   //---------------------------------------
   public:
      bool test_one(){
         harmonics.refresh_indicators();
         double ptD = harmonics.get_point_D(Period());
         double ptC = harmonics.get_point_C(Period());
         ObjectCreate(0,"Point D_Level",OBJ_HLINE,0,TimeCurrent(),ptD);
         ObjectCreate(0,"Point C_Level",OBJ_HLINE,0,TimeCurrent(),ptC);
      }
      
};

class SymphonyOrderHandlerTests
{
   SymphonyOrderHandler * order_handler;
   SymphonyHarmonics symphony_harmonics;
   public:
      bool test_one(){
         order_handler = new SymphonyOrderHandler(symphony_harmonics.get_PRZ_stop(Period()),symphony_harmonics.get_point_D(Period()));
         order_handler.order_send();
         Print("StopLoss: ",DoubleToString(order_handler.get_stoploss(),_Digits)," Take Profit: ",DoubleToString(order_handler.get_takeprofit(),_Digits));
         return(true);
      };
}; 