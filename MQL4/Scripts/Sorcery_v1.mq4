//+------------------------------------------------------------------+
//|                                                   Sorcery_v1.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

//-----------------------------------
//  Loop over all point
//     > Define ALL retracement requirements and XOR them
//       > Calculate ALL retracement values points and
//          
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   /*
   struct PatternDefinitions{
      ABCD      = 100;
      Gartly    = 101;
      Butterfly = 102;
      Crab      = 103;
      
   }*/
   struct PatternSchema{
      //---------------------------------------------------------
      //  Metrics:
      //       1) AB/XA => %AB_Leg retracement of XA_Leg (Gartley, Bat, Butterfly, Crab
      //       2) CD/XA => %CD_Leg retracement of XA_Leg (Gartley, Bat, Butterfly      
      //       3) BC/AB => %BC_Leg retracement of AB_Leg (Gartley, Bat, Butterfly, Crab
      //       4) CD/AB => %CD_Leg projection  of AB_Leg (Gartley, Bat, Butterfly, Crab [AB=CD]
      //       5) CD/BC => %CD_Leg projection  of BC_Leg (Gartley, Bat, Butterfly, Crab
      //      
      //--------------------------------------------------------------
   };
   double points[5]       = {1.23432, 1.23334, 1.23400, 1.23399, 1.23450};
   double retracements[5] = {0, 0, 0, 0, 0};
   calculate_harmonic_ratios(points, retracements);
   for(int i = 0; i< ArraySize(retracements); i++) Print(DoubleToString(retracements[i],_Digits));
  }
//+------------------------------------------------------------------+

//--------------------------------
//  Description:
//     > Calculate all necessary harmonic ratios regardless
//       of whether or not the pattern explicitly needs it for calculation
//     > Necessary ratios outlined in PatternSchema comments
//     > Function assumes points[0] = Point X, points[1] = Point A, etc...
//---------------------------------
void calculate_harmonic_ratios(double& points[5],double &retracements[5]){
   retracements[0] = MathAbs( ( points[1]-points[2] ) ) / MathAbs( ( points[0] - points[1] ) ); // AB/XA
   retracements[1] = MathAbs( ( points[3]-points[4] ) ) / MathAbs( ( points[0] - points[1] ) ); // CD/XA
   retracements[2] = MathAbs( ( points[2]-points[3] ) ) / MathAbs( ( points[1] - points[2] ) ); // BC/AB
   retracements[3] = MathAbs( ( points[3]-points[4] ) ) / MathAbs( ( points[1] - points[2] ) ); // CD/AB
   retracements[4] = MathAbs( ( points[3]-points[4] ) ) / MathAbs( ( points[2] - points[3] ) ); // CD/BC
                     
};