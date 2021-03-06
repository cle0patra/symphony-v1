//+------------------------------------------------------------------+
//|                                                       DeMark.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property strict
#include "Symphony_Definitions.mqh"
class DeMark
{
   string sym;
   SymphonyDefinitions * sym_def;
   //--------------------------------
   // get_demark_retracement:
   //    > Will calculate TD Retracement (Demark) using Point C (typically) as the reference high/low
   //      > Will incorporate partial 
   //    > References for price projection
   //       > Reference high/low:
   //          -> For arbitrary high, find the last bar that matched that high, reference low is
   //             the lowest point between the two. Vice versa for arbitrary low.
   //       1) Anticipation of a down move subsequent to a rally (Bullish harmonic pattern - provide reference high)
   //          a) Calculate the difference between reference high and reference low
   //          b) Multiply number by 0.382 and 0.618
   //          c) Subtract result from reference high
   //             -> TD Magnet Price is the close of the reference low bar
   //       2) Anticipation of a rally subsequent to a down move (Bearish harmonic pattern - provide reference low)
   //          a) Calculate the difference between reference high and reference low
   //          b) Multiply number by 0.382 and 0.618
   //          c) Add result ot reference low
   //             -> TD Magnet Price is the close of the reference high bar
   //
   //-----------------------------------------
   public: 
      //----------> Constructors
      DeMark(string symbol){ this.sym = symbol; this.sym_def = new SymphonyDefinitions();};
      DeMark()             { this.sym = Symbol(); this.sym_def = new SymphonyDefinitions();};
      
      //-------------------------------
      // draw_demark_retracement:
      //    > Draw Retracements (38.2,61.8,MagnetPrice) on chart
      //--------------------------------------------
      void draw_demark_retracement(double ref_high_or_low, int std_period){ this.demark_retracement(ref_high_or_low,std_period,True); };
      //------------------------------
      // get_demark_retracement:
      //   > Parse string from demark_retracement
      //   > Schema:
      //       { 0.382 : 0, 0.618 : 1, demark_schema.td_magnet_price : 2 }
      //       > Index relates to string array 'results'
      //-------------------------------------------------
      double get_demark_retracement( double ret_val,double ref_high_or_low, int std_period){
         string demark_info_string = get_demark_retracement(ref_high_or_low,std_period,False);
         double ret_382 = -1, ret_618 = -1, td_magnet_price = -1;
         string result[]; double ret_value = -1;
         StringSplit(demark_info_string,",",result);
         if      ( ret_val == 0.382){           return(StringToDouble(result[0]));
         }else if( ret_val == 0.618){           return(StringToDouble(result[1]));
         }else if( ret_val == td_magnet_price){ return(StringToDouble(result[1]));
         }else{ Print("[ DeMark | GetDemarkRetracement ] Invalid ret_val: ",ret_val); return(-1);};
      }
      string demark_retracement(double ref_high_or_low,int std_period, bool draw_pattern){
         //--> ID is high or low? Bar index?
         int type = -1;
         int first_ref_index = -1, sentinel_ref_index = -1, middle_ref_index = -1;
         double ref_diff;
         double first_ref       = ref_high_or_low, middle_ref = 0;
         double TD_Magnet_Price = 0;
         double ret382_val      = -1,      ret618_val = -1;
         bool final_op_flag     = False;
         
         for(int i = 0; i < iBars(this.sym,std_period); i++){
            //---> If no values have been set, find the first corresponding value and store index
            if(first_ref_index == -1 && sentinel_ref_index==-1){
               if    (iHigh(this.sym,std_period,i) == first_ref){
                  first_ref_index = i;
                  type            = ORDER_TYPE_BUY;
               }
               else if(iLow(this.sym,std_period,i) == first_ref){
                  first_ref_index = i;
                  type            = ORDER_TYPE_SELL;
               }
             }
            //---> After IDing first ref, find the second at an equal level
            else if(first_ref_index!=-1 && sentinel_ref_index==-1){
            
               //##############
               //# SUB-LOOP: Find the sentinel ref
               //##############
               
               for(int s = first_ref_index + 1; s < Bars; s++){
                  switch(type){
                     case ORDER_TYPE_BUY:  if(iHigh(this.sym,std_period,s) >= first_ref) sentinel_ref_index = s; break;
                     case ORDER_TYPE_SELL: if(iLow(this.sym,std_period,s)  <= first_ref) sentinel_ref_index = s; break;
                     default: Print("[ DeMark | GetDemarkRetracement ] Type error."); break;
                  };
                  if(sentinel_ref_index != -1) break;
               };
            }
            else if(first_ref_index!=-1 && sentinel_ref_index!=-1 && final_op_flag == False){
            
               //##############
               //# SUB-LOOP: Find the extrema within the bounds
               //##############
               
               for(int o = first_ref_index + 1; o < sentinel_ref_index; o++){
                  switch(type){
                     case ORDER_TYPE_BUY:  
                           if(iLow(this.sym,std_period,o)  <= middle_ref || middle_ref == 0){
                              middle_ref_index = o;
                              middle_ref       = iLow(this.sym,std_period,o);
                              TD_Magnet_Price  = iClose(this.sym,std_period,o);
                           }
                            break;
                     case ORDER_TYPE_SELL: 
                           if(iHigh(this.sym,std_period,o)  >= middle_ref || middle_ref == 0){ 
                              middle_ref_index = o;
                              middle_ref       = iHigh(this.sym,std_period,o);
                              TD_Magnet_Price  = iClose(this.sym,std_period,o);
                           }
                            break;
                     default: Print("[ DeMark | GetDemarkRetracement ] Type error."); break;
                  };
               };
                final_op_flag = True;
            }
            else if(final_op_flag){
               ref_diff = MathAbs(middle_ref - first_ref);
               switch(type){
                  case ORDER_TYPE_BUY: ret382_val = first_ref - (0.382 * ref_diff);
                                       ret618_val = first_ref - (0.618 * ref_diff);
                                       break;
                  case ORDER_TYPE_SELL: ret382_val = first_ref + (0.382 * ref_diff);
                                        ret618_val = first_ref + (0.618 * ref_diff);
                                        break;
                  default: break;                                        
               };
            };
                
         };
         if(draw_pattern){
            int pixel_height = 0;
           // string refs[3] = {"First Ref
            /*ObjectCreate(0,"First Ref",OBJ_VLINE,0,iTime(this.sym,std_period,first_ref_index),0);
            ObjectSet("First Ref",OBJPROP_COLOR,clrBlue);
            ObjectCreate(0,"Boundary Ref",OBJ_VLINE,0,iTime(this.sym,std_period,sentinel_ref_index),0);
            ObjectSet("Boundary Ref",OBJPROP_COLOR,clrBlue);
            ObjectCreate(0,"Pivot Ref",OBJ_VLINE,0,iTime(this.sym,std_period,middle_ref_index),0);
            ObjectSet("Pivot Ref",OBJPROP_COLOR,clrBlue);
            ObjectCreate(0,"Reference1",OBJ_HLINE,0,0,first_ref);
            ObjectCreate(0,"Reference2",OBJ_HLINE,0,0,middle_ref);*/
            
            //--> Draw retracements and magnet prices
            ObjectCreate(0,"Ret_382",OBJ_HLINE,0,0,ret382_val);
            ObjectSet("Ret_382",OBJPROP_COLOR,clrDarkOrange);
            ObjectCreate(0,"Ret_618",OBJ_HLINE,0,0,ret618_val);
            ObjectSet("Ret_618",OBJPROP_COLOR,clrDarkOrange);;
            ObjectCreate(0,"TD_MAGNET_PRICE",OBJ_HLINE,0,0,TD_Magnet_Price);
            ObjectSet("TD_MAGNET_PRICE",OBJPROP_COLOR,clrDarkOrange);
            //------------> Set 38.2% and 61.8% Labels
            string retracements[3] = {"Ret_382","Ret_618","TD_MAGNET_PRICE"};
            for(int i = 0; i< ArraySize(retracements); i++){
               string name = StringConcatenate(retracements[i],"_Label");
               string projection_info_string = "";
               double data = 0;
               if(retracements[i]      == "Ret_382")  projection_info_string = StringConcatenate("^    DeMark 38.2%: ",DoubleToString(ret382_val,MarketInfo(this.sym,MODE_DIGITS))," ^");
               else if(retracements[i] == "Ret_618")  projection_info_string = StringConcatenate("^    DeMark 61.8%: ",DoubleToString(ret618_val,MarketInfo(this.sym,MODE_DIGITS))," ^");
               else                                   projection_info_string = StringConcatenate("^ TD Magnet Price: ",DoubleToString(TD_Magnet_Price,MarketInfo(this.sym,MODE_DIGITS))," ^");
               ObjectCreate(0,name,OBJ_TEXT,0,Time[1],ObjectGet(retracements[i], OBJPROP_PRICE1));
               ObjectSetText(name,projection_info_string,10,NULL,clrDarkOrange);
                  
            };
          }; 
          //>>>>>> End Drawing block
         //-------> String to return: "ret_382,ret_618,TD_Magnet_Price"
         //          > Can parse via function call
         //--------------------------------------
         string info_string = StringConcatenate(
            DoubleToString(ret382_val, MarketInfo(this.sym,MODE_DIGITS)),",",
            DoubleToString(ret618_val, MarketInfo(this.sym,MODE_DIGITS)),",",                  
            DoubleToString(TD_Magnet_Price,MarketInfo(this.sym,MODE_DIGITS)));                  
         Print("[ DeMark | CalculateDMRet ] Info String [%38.2:%61.8:TD_Mag] - ",info_string," Type: ",sym_def.type_to_string(type));
         
         return(info_string);
      };
      //----> End Demark Retracement    

   //-------------------------------------------------
   // Waldo Patterns:
   //---------------------------------------------
   
   static bool is_there_bullish_waldo(int std_period){
      
      //--> Waldo Pattern 2
      //if(High[1] > High[2] && Close[1] > Close[2] && Close[1] > Close[3] && Close[1] > Close[4] && Close[1] > Close[5])
      return(True);
   };



};