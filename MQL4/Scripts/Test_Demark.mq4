//+------------------------------------------------------------------+
//|                                                  Test_Demark.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#include "../Include/Symphony_Sorcery.mq4"
#include "../Include/Demark.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   SymphonySorcery::refresh(Period());
   double pt_c = SymphonySorcery::get_point_D(Period());
   double dm = DeMark::get_demark_retracement(pt_c);
  }
//+------------------------------------------------------------------+
