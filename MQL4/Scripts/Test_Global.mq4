//+------------------------------------------------------------------+
//|                                                  Test_Global.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#include "../Include/Symphony_Sorcery.mq4"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   SymphonySorcery::refresh();
   SymphonySorcery::pretty_print();
   SymphonySorcery::get_prz(Period());
  }
//+------------------------------------------------------------------+
