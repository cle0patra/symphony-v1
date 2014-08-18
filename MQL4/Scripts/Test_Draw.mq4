//+------------------------------------------------------------------+
//|                                                    Test_Draw.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#include "../Include/Symphony_Sorcery.mq4"
#include "../Include/DeMark.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Print(Symbol());
   SymphonyIllustrator * illustrator;
   SymphonySorcery * sorcery;
   sorcery     = new SymphonySorcery(Symbol());     sorcery.refresh();
   illustrator = new SymphonyIllustrator(Symbol()); illustrator.refresh();
   illustrator.pretty_print();
   illustrator.draw_pattern(Period());
   DeMark * demark;
   demark = new DeMark(Symbol());
   demark.draw_demark_retracement(sorcery.get_point(Period(),point_c),Period());
   sorcery.get_prz(Period());
  }
//+------------------------------------------------------------------+
