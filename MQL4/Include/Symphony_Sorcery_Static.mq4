//+------------------------------------------------------------------+
//|                                             Symphony_Sorcery.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property strict
#include "Symphony_Definitions.mqh"
#include "Symphony_Magic.mqh"
#include "Symphony_RiskManagement.mqh"

string sym;
double zzz_points[periodIndexLength][zzz_index_length][sorcery_index_length]; // typically.. 7x5x2
double err_margin;
//------------------------------
//   TODO:
//      > Hooks for ZigZagZug            - COMPLETE
//      > Algorithm for IDing patterns   - COMPLETE
//          > Work in margin of error    - COMPLETE
//          > Work in perfect pattern    - REJECT
//          > Test:
//              1) ZZZ_POINTS & Hooks    - COMPLETE
//              2) Pattern IDing         - COMPLETE
//      > Add a drawing function         - TODO
//        > For valid patterns           - TODO
//      > Work in retracement zones      - COMPLETE
//      > Add retracements definitions   - COMPLETE
//        to Symphony_Definitions
//      > Three dimensional array for 
//        select currenies.              - REJECT
//        > Correlation engine ?         - TODO
//
//   QUESTIONS:
//      > Does a new point on ZZZ get registered as a High/Low point
//        initially, or a Point?
//      > 

//--------------------------------------------

//--------------------------------
// Note:
//    > OnInit first needs to call the indicator to place global variables
//       memory and then needs to call the relevant accessors in the class
//-------------------------------------------------------

void OnTimer(){
   SymphonySorcery::refresh();
      
};
//--------------------------------
//  Description:
//     > Calculate all necessary harmonic ratios regardless
//       of whether or not the pattern explicitly needs it for calculation
//     > Necessary ratios outlined in PatternSchema comments
//     > Function assumes points[0] = Point X, points[1] = Point A, etc...
//    TODO: refine get_prz
//---------------------------------

class SymphonySorcery{
   periods period;
   zzz_indicies z_index;
   SymphonyDefinitions def;
   public:
      //----Constructor
      //   > Does not set a class variable, sets a global one
      //---------------------------
      SymphonySorcery(string s){sym = s; };
      SymphonySorcery(){ sym = Symbol();};
      static void pretty_print(){
            int p, z, 
                s= int(zzz_number_of_points);
            string final_string,period_string;
            
            for( p=0; p < int(periodIndexLength); p++)
               final_string = StringConcatenate(final_string,StringFormat("|  p%s   ", string(SymphonyDefinitions::get_period_as_string(p)) ));
            Print(period_string);
            
            for(z = point_x; z <= point_d; z++){
               string point_string = "";
               for( p=0; p < periodIndexLength; p++){
                  point_string = StringConcatenate( point_string,
                                    StringFormat(
                                          "|   %s   ",DoubleToString(zzz_points[p][z][s],_Digits) ));  
               };
               Print(point_string);
               
            };
         };
       static void pretty_print_retracements(){
            int r              = int(zzz_retracements);
            for(int i = 0; i < int(zzz_index_length); i++){
               string s = retracement_string_builder(i);
               Print(s);
            };
         };
      
      //------------------------------
      //  refresh:
      //    > Will synchronize points across all instances of SymphonySorcery
      //    > First method will refresh all periods, the second a specific one
      //--------------------------------
      static void refresh(){
         for(int i = 0; i< periodIndexLength; i++)
            refresh(SymphonyDefinitions::get_standard_period(i));
      }
      static void refresh(int std_period){
         double exbuffer = iCustom(sym,std_period,"ZigZagZug.v1.3_Custom",0,0);
         fetch_points(std_period);
         calculate_harmonic_ratios(std_period);
      };
      
      //---------------------------
      //   get_prz:
      //    @return: Proper stop for the pattern
      //    > Based off Fibonacci clustering
      //-----------------------------------
      
      static double get_prz(int std_period){
         int z = int(zzz_number_of_points);
         int p = SymphonyDefinitions::get_period(std_period);
         double points[11];
         //---------------------------
         // Internal Price Retracements:
         //    > Point X -> Point A
         //    > 38.2, 50, 61.8, 78.6%
         //-----------------------------
         points[0] = get_retracement( int(xa), 0.382, std_period);
         points[1] = get_retracement( int(xa), 0.500, std_period);
         points[2] = get_retracement( int(xa), 0.618, std_period);
         points[3] = get_retracement( int(xa), 0.786, std_period);
         //---------------------------
         //   External Price Retracements:
         //     > Point B -> Point C
         //     > 127, 161.8%
         //----------------------------
         points[4] = get_retracement( int(bc), 1.270, std_period);
         points[5] = get_retracement( int(bc), 1.618, std_period);
         //--------------------------------
         //  Price Expansion:
         //     > Point A -> Point B
         //     > 61.8, 100, 161.8, 200, 261.8%
         //------------------------------
         points[6]  = get_retracement( int(ab), 0.618, std_period);
         points[7]  = get_retracement( int(ab), 1.000, std_period);
         points[8]  = get_retracement( int(ab), 1.618, std_period);
         points[9]  = get_retracement( int(ab), 2.000, std_period);
         points[10] = get_retracement( int(ab), 2.618, std_period);
         
         
         if(zzz_points[p][point_c][z] > zzz_points[p][point_d][z])
            ArraySort(points,WHOLE_ARRAY,0,MODE_ASCEND);
         else ArraySort(points,WHOLE_ARRAY,0,MODE_DESCEND);
         
         double lowest_range = 1000000;
         double average_of_range;
         int range_index_start; //---> For coloring the selected lines later
         for(int start_index = 0, end_index = 1;
             end_index < ArraySize(points)        ;
             start_index++,end_index++           ){
               //---> Skip points not in range
               if(!in_range(points[start_index],std_period)) continue;
               //---> Find the three levels closest together, take the average
               else {
                  double range = MathAbs( points[start_index] - points[end_index]);
                  if(range < lowest_range){
                     lowest_range     = range;
                     average_of_range = (points[start_index] + points[start_index+1] +  points[end_index]) / 3;
                     average_of_range = NormalizeDouble(average_of_range,_Digits);
                     range_index_start = start_index;
                  }
               };
         };
         
         //---> Draw on the chart
         for(int o = 0; o< ArraySize(points); o++){
            if(!in_range(points[o],std_period))  continue;
            else{
               ObjectCreate(0,string(o),OBJ_HLINE,0,0,points[o]);
               if(o >= range_index_start && o <= range_index_start+2)
                  ObjectSet(string(o),OBJPROP_COLOR,clrAqua);
            };
         };
         //----> Draw the StopLoss line a different color
         ObjectCreate(0,"PRZ_STOP",OBJ_HLINE,0,0,average_of_range);
         ObjectSet("PRZ_STOP",OBJPROP_COLOR,clrYellow);
         return(average_of_range);
      };
      
      //--------------------
      //  in_range:
      //     > Helper for get_prz
      //     @return: True if point is not above (buy) or below (sell) Point D
      //-------------------------------
      static bool in_range(double point, int std_period){
         int p = SymphonyDefinitions::get_period(std_period);
         int z = int(zzz_number_of_points);
         int type;
         if(zzz_points[p][point_c][z] > zzz_points[p][point_d][z])
            type = ORDER_TYPE_BUY;
         else type = ORDER_TYPE_SELL;
         if(      (point > zzz_points[p][point_d][z] && type == ORDER_TYPE_BUY) ) return(False);
         else if ((point < zzz_points[p][point_d][z] && type == ORDER_TYPE_SELL)) return(False);
         else return(True);
      
      };
      //-------------------------------
      // Getters
      //-------------------------------
      static double get_point_X(int std_period)       {int i = SymphonyDefinitions::get_period(std_period);
                                                return(zzz_points[i][point_x][int(zzz_number_of_points)]);};
      static double get_point_A(int std_period)       {int i = SymphonyDefinitions::get_period(std_period);
                                                return(zzz_points[i][point_a][int(zzz_number_of_points)]);};
      static double get_point_B(int std_period)       {int i = SymphonyDefinitions::get_period(std_period);
                                                return(zzz_points[i][point_b][int(zzz_number_of_points)]);};
      static double get_point_C(int std_period)       {int i = SymphonyDefinitions::get_period(std_period);
                                                return(zzz_points[i][point_c][int(zzz_number_of_points)]);};
      static double get_point_D(int std_period)       {int i = SymphonyDefinitions::get_period(std_period);
                                                return(zzz_points[i][point_d][int(zzz_number_of_points)]);}; 
      //----------------------------
      //  Helpers:
      //     1) AskOrBid - returns proper opening price
      //     2) AskOrBidClose - returns proper closing price 
      //-----------------------------
      double ask_or_bid(int type){
         switch(type){
            case ORDER_TYPE_BUY: return(Ask);
            case ORDER_TYPE_SELL: return(Bid);
            default:   Print("[ Symphony | Variables | Harmonics ] OrderType undefined. Last Error: ",ErrorDescription(GetLastError())); 
                     return(-1);
         }
      };
      double ask_or_bid_close(int type){
         RefreshRates();
         switch(type){
            case ORDER_TYPE_BUY: return(Bid);
            case ORDER_TYPE_SELL: return(Ask);
            default: Print("[ Symphony | Variables | Harmonics ] OrderType undefined. Last Error: ",ErrorDescription(GetLastError())); 
                     return(-1);
         }
      };
   private:
      static void calculate_harmonic_ratios(int std_period){
         int p              = SymphonyDefinitions::get_period(std_period);
         int r              = int(zzz_retracements);
         int z              = int(zzz_number_of_points);
         int z_index_length = int(zzz_index_length);
         
         double points[int(zzz_index_length)] = {};
         for(int i =0; i < z_index_length; i++)
            points[i] = zzz_points[p][i][z];
         //---> Check for 0's
         bool null_sweep_flag = False;
         for(int l = 0; l < ArraySize(points); l++) if(points[l]==0) null_sweep_flag = True;
         if(!null_sweep_flag){
            zzz_points[p][ab_xa][r] = MathAbs( ( points[1]-points[2] ) ) / MathAbs( ( points[0] - points[1] ) ); // AB/XA
            zzz_points[p][ad_xa][r] = MathAbs( ( points[1]-points[4] ) ) / MathAbs( ( points[0] - points[1] ) ); // CD/XA => AD/XA
            zzz_points[p][bc_ab][r] = MathAbs( ( points[2]-points[3] ) ) / MathAbs( ( points[1] - points[2] ) ); // BC/AB
            zzz_points[p][cd_ab][r] = MathAbs( ( points[3]-points[4] ) ) / MathAbs( ( points[1] - points[2] ) ); // CD/AB
            zzz_points[p][cd_bc][r] = MathAbs( ( points[3]-points[4] ) ) / MathAbs( ( points[2] - points[3] ) ); // CD/BC
         }
         else Print("[ SymphonySorcery | CalculateHarmonicRatios ] Failed null sweep. Points array contains some 0's");
      };
      //--------------------------------
      //  fetch_points:
      //    > Fish for Globals and store them in array
      //---------------------------------
      static void fetch_points(int std_period){
         int z = int(zzz_number_of_points);
         int p = SymphonyDefinitions::get_period(std_period);
         
         string point_strings[] = {"X","A","B","C","D"};
         for(int i = 0; i < int(zzz_index_length); i++){
            double point        = GlobalVariableGet(StringConcatenate("ZigZagZug_",point_strings[i],sym,std_period));
            zzz_points[p][i][z] = point;
          }
            
      };
      //----------------------------------
      //  is_there_pattern:
      //    > True if there is a full pattern on the chart
      //-----------------------------------
      static bool is_there_pattern        (int std_period){return(is_there_pattern(std_period,False));};
      static bool is_there_partial_pattern(int std_period){return(is_there_pattern(std_period,False));};
      static bool is_there_pattern        (int std_period,bool partial){
         err_margin = 0.08;
         //----------------------------------------------------------------------------
         //- Pattern:      Gartley        Butterfly         Bat          Crab
         // > AB/XA   | 0.618         | 0.786         | 0.382 - 0.500 | 0.382 - 0.618
         // > BC/AB   | 0.382 - 0.886 | 0.382 - 0.886 | 0.382 - 0.886 | 0.382 - 0.886
         // > CD/BC   | 1.270 - 1.618 | 1.618 - 2.618 | 1.618 - 2.618 | 2.240 - 3.618
         // > AD/XA   | 0.786         | 1.270 - 1.618 | 0.886         | 1.618
         //-----------------------------------------------------------------------------
         //   Note: Margin of error will not be added to the ranges
         //-----------------------------------------------------------------------------
         
         bool matched = False;
         switch(partial){
            case False: if(is_gartley(std_period) || is_butterfly(std_period) || 
                          is_bat(std_period) || is_crab(std_period)){
                           matched = True;
                           }
                        break;
            case True: if(is_partial_gartley(std_period) || is_partial_butterfly(std_period) || 
                          is_partial_bat(std_period) || is_partial_crab(std_period)){
                           matched = True;
                           }
                       break;
         };
         if(matched) Print("[ Symphony | Sorcery | Pattern Matcher ] Found a ",get_partial_pattern_string(std_period)," on ",sym," for period ",SymphonyDefinitions::get_standard_period_as_string(std_period));
         return(matched);
      };
      //------------------------------
      //  Pattern Matchers:
      //       > Method overrides can return 'true' if there is a...
      //          1) Completed pattern AND is_*** is called
      //          2) Partial pattern match AND is_partial_*** is called
      //       > Partial matches do NOT consider Pt D
      //       > General structure repeats, but there are unique ranges for each pattern
      //------------------------------
      // Gartley matcher
      //--------------------------------
      
      static bool is_gartley         (int std_period){ return(is_gartley(std_period,False));};
      static bool is_partial_gartley (int std_period){ return(is_gartley(std_period,True));};
      static bool is_gartley         (int std_period,bool partial){
         bool matched = False;
         int p              = SymphonyDefinitions::get_period(std_period);
         int r              = int(zzz_retracements);
         
         for(int i = 0; i < 4 && matched == False; i++){ switch(i){
               case 0: if( zzz_points[p][ab_xa][r] <= 0.618 + err_margin && zzz_points[p][ab_xa][r] >= 0.618 - err_margin ) continue; else break;
               case 1: if( zzz_points[p][bc_ab][r] >= 0.382              && zzz_points[p][bc_ab][r] <= 0.886 ){             
                           if(partial) matched = True; break;
                       } else break;              
               case 2: if( zzz_points[p][cd_bc][r] >= 1.270              && zzz_points[p][cd_bc][r] <= 1.618 )              continue; else break;
               case 3: if( zzz_points[p][ad_xa][r] <= 0.786 + err_margin && zzz_points[p][ab_xa][r] >= 0.786 - err_margin ) matched = True; else break;
            }; };
         return(matched);
      };
      //------------------------------
      // Butterfly matcher
      //--------------------------------
      static bool is_butterfly         (int std_period){ return(is_gartley(std_period,False));};
      static bool is_partial_butterfly (int std_period){ return(is_gartley(std_period,True));};
      static bool is_butterfly         (int std_period,bool partial){
         bool matched = False;
         int p              = SymphonyDefinitions::get_period(std_period);
         int r              = int(zzz_retracements);
         for(int i = 0;i < 4 && matched == False; i++){ switch(i){
               case 0: if( zzz_points[p][ab_xa][r] <= 0.786 + err_margin && zzz_points[p][ab_xa][r] >= 0.786 - err_margin ) continue; else break;
               case 1: if( zzz_points[p][bc_ab][r] >= 0.382              && zzz_points[p][bc_ab][r] <= 0.886 ){             
                           if(partial) matched = True; break;
                       } else break;                            
               case 2: if( zzz_points[p][cd_bc][r] >= 1.618              && zzz_points[p][cd_bc][r] <= 2.618 )              continue; else break;
               case 3: if( zzz_points[p][ad_xa][r] >= 1.270              && zzz_points[p][ad_xa][r] <= 1.618 ) matched = True; else break;
            }; };
         return(matched);
      };
      //------------------------------
      // Bat matcher
      //--------------------------------
      static bool is_bat         (int std_period){ return(is_gartley(std_period,False));};
      static bool is_partial_bat (int std_period){ return(is_gartley(std_period,True));};
      static bool is_bat         (int std_period,bool partial){
         bool matched = False;
         int p              = SymphonyDefinitions::get_period(std_period);
         int r              = int(zzz_retracements);
         for(int i = 0;i < 4 && matched == False; i++){ switch(i){
               case 0: if( zzz_points[p][ab_xa][r] >= 0.382              && zzz_points[p][ab_xa][r] <= 0.500 ) continue; else break;
               case 1: if( zzz_points[p][bc_ab][r] >= 0.382              && zzz_points[p][bc_ab][r] <= 0.886 ){             
                           if(partial) matched = True; break;
                       } else break;                            
               case 2: if( zzz_points[p][cd_bc][r] >= 1.618              && zzz_points[p][cd_bc][r] <= 2.618 )              continue; else break;
               case 3: if( zzz_points[p][ad_xa][r] <= 0.886 + err_margin && zzz_points[p][ad_xa][r] >= 0.886 - err_margin ) matched = True; else break;
            }; };
         return(matched);
      };
      //------------------------------
      // Crab matcher
      //--------------------------------
      static bool is_crab         (int std_period){ return(is_gartley(std_period,False));};
      static bool is_partial_crab (int std_period){ return(is_gartley(std_period,True));};
      static bool is_crab         (int std_period,bool partial){
         bool matched = False;
         int p              = SymphonyDefinitions::get_period(std_period);
         int r              = int(zzz_retracements);
         for(int i = 0;i < 4 && matched == False; i++){ switch(i){
               case 0: if( zzz_points[p][ab_xa][r] >= 0.382              && zzz_points[p][ab_xa][r] <= 0.618 ) continue; else break;
               case 1: if( zzz_points[p][bc_ab][r] >= 0.382              && zzz_points[p][bc_ab][r] <= 0.886 ){             
                           if(partial) matched = True; break;
                       } else break;                                         
               case 2: if( zzz_points[p][cd_bc][r] >= 2.240              && zzz_points[p][cd_bc][r] <= 3.618 )              continue; else break;
               case 3: if( zzz_points[p][ad_xa][r] <= 1.618 + err_margin && zzz_points[p][ad_xa][r] >= 1.618 - err_margin ) matched = True; else break;
            }; };
         return(matched);
      };
      //---------------------------
      // get_pattern_string
      //    @return: string for pattern on chart, "None" if there isn't one
      //--------------------------------
      static string get_pattern_string        (int std_period){return(get_pattern_string(std_period,False));};
      static string get_partial_pattern_string(int std_period){return(get_pattern_string(std_period,True));};
      static string get_pattern_string(int std_period,bool partial){
         switch(partial){
            case False: if     (is_bat(std_period))       return("Bat");
                        else if(is_butterfly(std_period)) return("Butterfly");
                        else if(is_gartley(std_period))   return("Gartley");
                        else if(is_crab(std_period))      return("Crab");
                        else                              return("None");
            case True:  if     (is_partial_bat(std_period))       return("Bat");
                        else if(is_partial_butterfly(std_period)) return("Butterfly");
                        else if(is_partial_gartley(std_period))   return("Gartley");
                        else if(is_partial_crab(std_period))      return("Crab");
                        else                                      return("None");
            default:    return("None");
            };
      };
      //-----------------------------
      // Helpers:
      //-------------------------------
      
      //-----------------------------
      // retracement_string_builder:
      //    > Constructs and returns string of retracement channel
      //    > For pretty_print_ratios
      //-------------------------------
      
      static string retracement_string_builder(int retracement_index){
         string msg;
         int r      = int(zzz_retracements);
         for(int p = 0; p < periodIndexLength; p++){
            msg = StringConcatenate( msg,
               StringFormat("|   %s    ",DoubleToString(zzz_points[p][retracement_index][r],_Digits))
            );
         };
         msg = StringConcatenate(msg,"| ",SymphonyDefinitions::get_retracement_index_as_string(retracement_index));
         return(msg);
      }
      //-----------------------------------
      //  get_retracement:
      //    > helper for get_prz
      //    > Calculates given retracement. Allows get_prz to be type agnostic
      //----------------------------------
      static double get_retracement(int leg_index, double retracement, int std_period){
         int z = int(zzz_number_of_points);
         int p = SymphonyDefinitions::get_period(std_period);
         int rel_point_index; // For subtracting the retrcement val (e.g. point_a, point_b, etc...)
         
         double diff;
         switch(leg_index){
            case xa: diff = MathAbs(zzz_points[p][point_x][z] - zzz_points[p][point_a][z]); 
                     rel_point_index = point_a; break;
            case ab: diff = MathAbs(zzz_points[p][point_a][z] - zzz_points[p][point_b][z]);
                     rel_point_index = point_b; break; // --> This will be an expansion
            case bc: diff = MathAbs(zzz_points[p][point_b][z] - zzz_points[p][point_c][z]);
                     rel_point_index = point_c; break;
            default: break;
         };
         double ret_val = NormalizeDouble( (diff * retracement), _Digits);
         double v;
         if(zzz_points[p][point_c][z] > zzz_points[p][point_d][z]) v = zzz_points[p][rel_point_index][z] - ret_val; // BUY
         else v = zzz_points[p][rel_point_index][z] - ret_val;; //SELL
         
         return(v);
      };
      //-------------------------------
      //  get_datetime:
      //    > Takes an index from SymphonyDefinitions (e.g. point_a, point_c, etc...)
      //      and returns the datetime value
      //----------------------------------
      
      static datetime get_datetime(int point_index, int std_period){
         int p = SymphonyDefinitions::get_period(std_period);
         int z = int(zzz_number_of_points);
         if(point_index > 4 || point_index < 0) Print("[ Symphony | Sorcery | GetDatetime ] Invalid point index.");
         else{
            for(int i = 0; i < Bars; i++)
               if(High[i] == zzz_points[p][point_index][z] || Low[i] == zzz_points[p][point_index][z]) return(Time[i]);
         };
         return(NULL);
      };
      
      
};






class SymphonyOrderHandler
{
   int stdPeriod;
   string symbol;
   double stoploss;
   double takeprofit;
   string label;
   int ticket;
   int magic_number;
   SymphonyMagic symphony_magic;
   SymphonyStrings strings;
   SymphonyRiskManager risk_manager;
   SymphonySorcery h;
   double Risk;
   string orderHistoryFile;
   double spread;
   public:
      //---> Constructors
         //--> Summons:
         //     1) Risk management instance
         //     2) Harmonics instance
      SymphonyOrderHandler(double stoploss,double takeProfit){
         this.stdPeriod  = Period();     this.symbol = Symbol();                 this.stoploss = stoploss;
         this.takeprofit = takeProfit;   this.Risk   = risk_manager.get_risk();  this.ticket   = -1;
         
      }
      SymphonyOrderHandler(int period, string symbol, double stoploss,double takeProfit){ 
         //NOTE: No reason to provide symbol...for now
         this.stdPeriod  =   period;          this.symbol = symbol;                  this.stoploss = stoploss;
         this.takeprofit = takeProfit;        this.Risk   = risk_manager.get_risk(); this.ticket   = -1;
         //this.h.set_symbol(symbol);
      }
      //-------------------------
      //   This constructor will hook a trade in progress
      //-----------------------------------
      SymphonyOrderHandler(int ticket){
         this.ticket = ticket; this.Risk = risk_manager.get_risk();
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)){
            this.stoploss   = OrderStopLoss();
            this.takeprofit = OrderTakeProfit();
            this.symbol     = OrderSymbol();
         }
         else if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)){
            this.symbol   = OrderSymbol();
            double profit = OrderProfit();
            Print("[ Symphony | Order Handler | Constructor[ticket] ] Constructor was given a ticket that was already closed on ",
                  this.symbol,". Profit: $",DoubleToString(profit,2));
         }
         else{ Print("[ Symphony | Order Handler ] Error. Ticket: ",this.ticket);}
         this.stdPeriod = this.symphony_magic.get_period_by_magic_number(OrderMagicNumber());
         //this.h.set_symbol(this.symbol);
      }
   int order_send(){
      int type;
      if(this.stoploss>this.takeprofit)
         type = ORDER_TYPE_SELL;
      else if(this.stoploss<this.takeprofit)
         type = ORDER_TYPE_BUY;
      else {Print("[ Symphony | OrderHandler | OrderSend ] Encountered a problem with StopLoss: ",DoubleToString(this.stoploss,_Digits),
                 " and TakeProfit: ",DoubleToString(this.takeprofit,_Digits)," on ",this.symbol," | ",
                 strings.standard_period_to_string(stdPeriod));
                 return(-1);
                 }
  
      double openAt      = h.ask_or_bid(type);
      double lotSize     = risk_manager.position_size(this.stoploss, this.Risk); 
      this.spread        = MarketInfo(this.symbol,MODE_SPREAD);
      this.magic_number  = symphony_magic.get_magic_number(this.stdPeriod,this.symbol);                
      this.ticket        = OrderSend(this.symbol,type,lotSize,openAt,spread,this.stoploss,this.takeprofit,
                                      strings.standard_period_to_string(this.stdPeriod),this.magic_number,0,Blue);
      
      if(this.ticket!=-1) Print("[ Symphony | Variables | OrderHandler | OrderSend ] Order placed. Risk Reward 1:",DoubleToString(MathAbs(openAt-this.takeprofit)/MathAbs(openAt-this.stoploss),2));
      else Print("[ Symphony | Variables | OrderHandler | OrderSend ] Failed to place order. Last Error: ",ErrorDescription(GetLastError()));
      return(this.ticket);
   };
   //---------------------------------
   //  order_close:
   //    > Closes order based on ticket. Resets order information if successful,
   //      Prints error if failure.
   //---------------------------------------------
   
   bool order_close(int ticket){
      OrderSelect(ticket,SELECT_BY_TICKET);
      if(OrderClose(ticket,OrderLots(),h.ask_or_bid_close(OrderType()),0,Red)){
         OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY);
         Print("[ Symphony | Variables | OrderHandler | OrderClose ] Order closed for ticket #",ticket,
               ". Profit: $",DoubleToString(OrderProfit(),2));
         this.stoploss = 0; this.takeprofit = 0; this.ticket = 0; this.stdPeriod = 0;
         return(true);
      }
      else{
         Print("[ Symphony | Variables | OrderHandler | OrderClose ] Failed to close order for ticket #",
               ticket,". Last Error: ",ErrorDescription(GetLastError()));
         return(false);
      }
   };
   //---------------------------------
   //  order_partial_close:
   //    @param ticket - order to partially close
   //    @param lotsToClose - order portion to close.
   //    @return newTicket - identifier of the new ticket.
   //    > Will not need a specified closing price, this condition should be triggered elsewhere.
   //      This being said, order will be closed at the relevant price (Ask or Bid)
   //      Prints error if failure.
   //---------------------------------------------
   int order_partial_close(int ticket,double lotsToClose){
      //----> Validation
      if(OrderSelect(ticket,SELECT_BY_TICKET)){
         if(lotsToClose>OrderLots()){
            Print("[ Syphony | Variables | OrderHandler | OrderPartialClose ] Invalid lotsToClose: ",DoubleToString(lotsToClose,2)," with order lots = ",DoubleToString(OrderLots(),2));
            return(-1);
         }
         else if(lotsToClose==OrderLots()){
            Print("[ Syphony | Variables | OrderHandler | OrderPartialClose ] Lots to close is equal to OrderLots. Closing anyways.");
            this.order_close(ticket);
            return(0);
         }
         else{ //--> Else if the lots to close are valid
            int magic = OrderMagicNumber();
            int newTicket;
            if(OrderClose(ticket,OrderLots(),h.ask_or_bid_close(OrderType()),0,Red)){ 
               newTicket  = this.symphony_magic.get_ticket_by_magic_number(magic);
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)){
                  Print("[ Symphony | Variables | OrderHandler | OrderPartialClose ] Partial closing successful for ticket #",ticket,
                         ". Partial Profit: $",DoubleToString(OrderProfit(),2),". The new ticket is: T#",newTicket);
                  //----> Update OrderHandler ticket
                  this.ticket = newTicket;
                  return(newTicket);
                  }
               //--> Unable to select order
               else{return(-1);}
            }
            else{ Print("[ Symphony | Variables | OrderHandler | OrderPartialClose ] Error taking partial profits for T#",ticket,
                        ". LotsToClose: ",DoubleToString(lotsToClose,2)," Last Error: ",ErrorDescription(GetLastError()));
                        return(-1);
            }
         }
      }
      else{
         Print("[ Symphony | Variables | OrderHandler | OrderPartialClose ] Error Selecting ticket # ",ticket);
         return(-1);
         }
   };
   
   //##########################
   //#  SETTER & GETTERS
   //##########################
   void   set_order_history_file(string path) {this.orderHistoryFile = path;};
   void   set_stoploss(double stop)           {this.stoploss = stop;};
   void   set_takeprofit(double tp)           {this.takeprofit=tp;};
   void   set_standard_period(int std_period) {this.stdPeriod = std_period;};
   void   set_symbol(string s)                {this.symbol = symbol;};
   void   set_label(string l)                 {this.label = l;};
   
   double get_stoploss()                      {return(this.stoploss);};
   double get_takeprofit()                    {return(this.takeprofit);};
   int    get_standard_period()               {return(this.stdPeriod);};
   int    get_ticket()                        {return(this.ticket);};
   int    get_label()                         {return(int(this.label));};
   int    get_magic_number()                  {return(this.magic_number);};
   
};

//#######################################
//#
//# SymphonyIllustrator:
//#   > The goal of this class is to provide a standalone visualization of
//#     current patterns
//#   > Only depends on the global array zzz_points
//#
//#######################################


class SymphonyIllustrator{
   
   public:
      //---------------------------------
      //  get_midtime:
      //    > Returns time of the median between two points
      //      to aid in drawing the pattern
      //-------------------------------------
      static datetime get_midtime(int first_point, int second_point, int std_period){
         int p = SymphonyDefinitions::get_period(std_period);
         int z = int(zzz_number_of_points);
         int first_bar_index = -1, second_bar_index = -1;
         
         if( (first_point > 4 || first_point < 0) || (second_point > 4 || second_point < 0)) 
            Print("[ Symphony | Illustrator | GetMidtime ] Invalid point index.");
         else{
            for(int i = 0; i < Bars; i++){
               if( (High[i] == zzz_points[p][first_point][z] || Low[i] == zzz_points[p][first_point][z]) && first_bar_index == -1)
                  first_bar_index = i;
               if( (High[i] == zzz_points[p][second_point][z] || Low[i] == zzz_points[p][second_point][z]) && second_bar_index == -1)
                  second_bar_index = i;
            };
         };
         int index_diff = first_bar_index - second_bar_index;
         int lead_index = 0;
         if(first_bar_index < second_bar_index) lead_index = first_bar_index;
            else lead_index = second_bar_index;
         int mid_index = lead_index + (index_diff / 2);
         return(Time[mid_index]);
      };


};