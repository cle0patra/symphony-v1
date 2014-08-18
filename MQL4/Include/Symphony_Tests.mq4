//+------------------------------------------------------------------+
//|                                               Symphony_Tests.mqh |
//|                                                           Luke S |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Luke S"



#include "Symphony_Sorcery.mq4"
#include "stdlib.mqh"
#include "stderror.mqh"


class SymphonyTests
{
   SymphonyChord * chord;
   SymphonySorcery * sorcery;
   SymphonyChord * chords[2];
   string symbol;
   
   public:
      SymphonyTests( string symbol){ 
         this.symbol = symbol; 
         this.chord = new SymphonyChord(symbol); 
         this.sorcery = new SymphonySorcery();
         string majors[2] = {"EURUSD","AUDUSD"};
         for(int i = 0; i < ArraySize(chords); i++) 
            chords[i] = new SymphonyChord(majors[i]);
      };
      SymphonyTests(){ 
         this.symbol = symbol; 
         this.chord = new SymphonyChord(Symbol());
         this.sorcery = new SymphonySorcery();
         string majors[2] = {"EURUSD","AUDUSD"};
         for(int i = 0; i < ArraySize(chords); i++) 
            chords[i] = new SymphonyChord(majors[i]);
      };
      //-----------------------------
      // test_one:
      //   @note: TEST - SymphonyChord initialization
      //   @return: True if operation is a success
      //------------------------------------------
      bool test_one(){
         
         this.chord.find_patterns();
         Print("[ SymphonyTests | TestOne ] Is there pattern on current chart? ",string(this.sorcery.is_there_pattern(Period())));
         return(True);
      };
      //------------------------
      // test_two:
      //    @note: scan symbols with array of chords
      //--------------------------------
      bool test_two(){
         SymphonyIllustrator * illustrator;
         SymphonySorcery * sorcery;
         sorcery     = new SymphonySorcery(Symbol());     sorcery.refresh(Period());
         illustrator = new SymphonyIllustrator(Symbol()); illustrator.refresh();
         illustrator.pretty_print();
         illustrator.draw_pattern(Period());
         double prz = sorcery.get_prz(Period());
         return(True);
      }



};

class SymphonyHarmonicsTests : public SymphonyTests
{
   SymphonySorcery harmonics;
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
      
}; 