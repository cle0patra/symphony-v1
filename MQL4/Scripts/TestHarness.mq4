//+------------------------------------------------------------------+
//|                                                  TestHarness.mq4 |
//|                                                           Luke S |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "../Include/Symphony_Tests.mq4"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   SymphonyTests * tests;
   tests = new SymphonyTests(Symbol());
   Print("[ TestHarness | SymphonyTests | TestOne ] Pass?: ",string(tests.test_two())," on ",Symbol());
  }
//+------------------------------------------------------------------+
