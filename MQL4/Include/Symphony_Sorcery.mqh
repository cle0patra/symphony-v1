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
#include "DeMark.mqh"

//------------------------------
//   TODO:
//      > Hooks for ZigZagZug            - COMPLETE
//      > Algorithm for IDing patterns   - COMPLETE
//          > Work in margin of error    - COMPLETE
//          > Work in perfect pattern    - REJECT
//          > Test:
//              1) ZZZ_POINTS & Hooks    - COMPLETE
//              2) Pattern IDing         - COMPLETE
//      > Add a drawing function         - COMPLETE
//        > For valid patterns           - COMPLETE
//        > For partial patterns         - COMPLETE
//        > For Fibonacci                - COMPLETE
//        > To find the last valid
//          pattern                      - TODO
//      > Work in retracement zones      - COMPLETE
//        > Work in PRZ                  - IN PROGRESS
//        > Fine tune k-means clustering - IN PROGRESS
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


class SymphonySorcery{
   double zzz_points[periodIndexLength][zzz_index_length][sorcery_index_length]; // typically.. 7x5x2
   DeMark * demark;
   period_schema period;
   zzz_schema z_index;
   SymphonyDefinitions * sym_def;
   string sym;
   bool valid_pattern;
   double err_margin;
   public:
      //---------------------------------
      //  Constructor:
      //    @note: Sets symbol, initializes sym_def, and sets zzz_points
      //    @param symbol: Optional. Sets symbol
      //   > Does not set a class variable, sets a global one
      //---------------------------
      SymphonySorcery(string symbol){this.sym = symbol; demark = new DeMark(); this.sym_def = new SymphonyDefinitions(); this.refresh(); this.valid_pattern = False;
                                    err_margin = 0.10;};
      SymphonySorcery()             {this.sym = Symbol(); demark = new DeMark(); this.sym_def = new SymphonyDefinitions(); this.refresh(); this.valid_pattern = False;
                                     err_margin = 0.10;};
       
      //------------------------------
      //  refresh:
      //    @note: Will synchronize points across all instances of SymphonySorcery
      //    @param std_period: Optional. First method will refresh all periods, the second a specific one
      //--------------------------------
       void refresh(){
         for(int i = 0; i< periodIndexLength; i++)
            refresh(this.sym_def.get_standard_period(i));
      };
       void refresh(int std_period){
         double exbuffer = iCustom(sym,std_period,"ZigZagZug.v1.3_Custom",0,0);
         fetch_points(std_period);
         calculate_harmonic_ratios(std_period);
      };
      
      //-----------------------------------
      //  set_error_margin:
      //    @note: error margin for patterns. Default 0.10
      //    @param margin: Desired error margin
      //----------------------------------------
      void set_error_margin(double margin){ this.err_margin = margin; };
      //---------------------------
      //   get_prz:
      //    @param std_period: PERIOD_X format
      //    @param isPartial: Special rules apply for partial patterns
      //          --> price_expansion, external_ret, internal_ret can be used
      //    @return: Proper stop for the pattern
      //    > Based off Fibonacci clustering
      //-----------------------------------
       double get_prz(int std_period)        { return(get_prz(std_period,False));};
       double get_partial_prz(int std_period){ return(get_prz(std_period,True));};
       
      //-----------------------------
      // Getters:
      //-------------------------------
      // get_point:
      //    @param std_period: PERIOD_X
      //    @param period_index: e.g. point_x
      //    > Overloaded (private) method provides some error checking and returns value
      //-------------------------------
       double get_point                 (int std_period,int point_index){ return(this.get_point(std_period,point_index,False));};
       double get_partial_point         (int std_period,int point_index){ return(this.get_point(std_period,point_index,True));};
       double get_retracement           (int std_period,int retracement_index){return(this.get_retracement(std_period,retracement_index,False));};
       double get_partial_retracement   (int std_period,int retracement_index){return(this.get_retracement(std_period,retracement_index,True));};
       double get_leg_retracement       (int std_period, double retracement, int fibonacci_index){ return(get_leg_retracement(std_period,retracement,fibonacci_index,False));};
       double get_partial_leg_retracement(int std_period, double retracement, int fibonacci_index){ return(get_leg_retracement(std_period,retracement,fibonacci_index,True));};
       
       //-------------------------------
       //  get_cd_retracement:
       //     @note: Main usage for taking partial profits
       //     @param std_period: PERIOD_X
       //     @param ret_ratio: Ret % to calculate
       //     @return: Level of retracement 
       //---------------------------------------
       double get_cd_retracement(int std_period, double ret_ratio){
         int type = this.get_order_type(std_period);
         double diff,retracement_value,final_val;
         diff = MathAbs( this.get_point(std_period,point_c) - this.get_point(std_period,point_d) );
         retracement_value = ret_ratio * diff;
         switch(type){
            case ORDER_TYPE_BUY: final_val = this.get_point(std_period,point_d) + retracement_value;
            case ORDER_TYPE_SELL: final_val = this.get_point(std_period,point_d) - retracement_value;
            default: Print("[ SymphonySorcery | GetCDRetracement ] Order type unknown");
         };
         return(final_val);
       }
       //--------------------------
       //   get_order_type:
       //      @param std_period: PERIOD_X
       //      @return: Order type on chart
       //----------------------------------
       int get_order_type(int std_period)         { return(get_order_type(std_period,False));};
       int get_partial_order_type(int std_period) { return(get_order_type(std_period,True));};
      //----------------------------
      //  ask_or_bid(_close):
      //    @param: Order type
      //    @return: Proper chart price depending on order type  
      //-----------------------------
      double ask_or_bid      (int type){ return(ask_or_bid(type,False)); };
      double ask_or_bid_close(int type){ return(ask_or_bid(type,True)); };
      
      
      //-------------------------------
      //  get_datetime:
      //    @note Takes an index from SymphonyDefinitions (e.g. point_a, point_c, etc...)
      //      and returns the datetime value. Must cross reference with iCustom to avoid matching different time with same hi/lo
      //    @param point_index: zzz_schema.point
      //    @param std_period: PERIOD_X format
      //    @return: Datetime of point
      //----------------------------------
      
       datetime get_datetime(int point_index, int std_period){
         int p = sym_def.get_period_index(std_period);
         int z = int(zzz_points_index);
         if(point_index > 4 || point_index < 0) Print("[ Symphony | Sorcery | GetDatetime ] Invalid point index.");
         else{
            for(int i = 0; i < Bars; i++)
               if((High[i] == zzz_points[p][point_index][z] || Low[i] == zzz_points[p][point_index][z]) &&
                   iCustom(sym,std_period,"ZigZagZug.v1.3_Custom",0,i) == zzz_points[p][point_index][z]){ 
                  return(Time[i]);
               } 
         };
         return(NULL);
       };
      //-----------------------------------------------
      //  Pattern Matchers:
      //-----------------------------------------------
      // is_there_pattern, is_there_partial_pattern:
      //      @note: Actual calculations done in private methods. Private method will also set object "valid_pattern" flag
      //      @param std_period: PERIOD_X format
      //      @return: True if there is a pattern/partial on the chart
      //-----------------------------------------------
      bool is_there_pattern        (int std_period){ return(this.is_there_pattern(std_period,False) > -1);};
      bool is_there_partial_pattern(int std_period){ return(this.is_there_pattern(std_period,True) > -1);};
      //-------------------------
      // get_pattern_index:
      //   @param std_period: PERIOD_X format
      //   @return: Valid pattern index if there is one on the period, -1 otherwise
      //-----------------------------------------
      int get_pattern_index        (int std_period){ return(is_there_pattern(std_period,False));};
      int get_partial_pattern_index(int std_period){ return(is_there_pattern(std_period,True));};
      
      //---------------------------
      //  pretty_print:
      //     @note: Print the zzz_points array
      //----------------------------------
      void pretty_print(){
            int p, z, 
                s= int(zzz_points_index);
            string final_string,period_string;
            
            for( p=0; p < int(periodIndexLength); p++)
               final_string = StringConcatenate(final_string,StringFormat("|  p%s   ", string(this.sym_def.period_index_to_string(p)) ));
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
            Print("PrettyPrint: ",sym);
         };
         //---------------------------
         //  pretty_print_retracements:
         //     @note: Print the zzz_points retracements
         //----------------------------------
        void pretty_print_retracements(){
            int r              = int(zzz_retracements_index);
            for(int i = 0; i < int(zzz_index_length); i++){
               string s = retracement_string_builder(i);
               Print(s);
            };
         };
      
   private:
      //---------------------------------------
      //   calculate_harmonic_ratios:
      //       @note: Calculate the retracements using the point_indexes schema
      //       @param std_period: PERIOD_X format
      //       @return: True if the calculation. False if there were empty values in the array
      //-----------------------------------------
      bool calculate_harmonic_ratios(int std_period){
         int p              = sym_def.get_period_index(std_period);
         int r              = int(zzz_retracements_index);
         int z              = int(zzz_points_index);
         
         //---> Check for 0's
         bool null_sweep_flag = False;
         for(int l = 0; l < int(zzz_index_length); l++) if(zzz_points[p][l][z]==0) null_sweep_flag = True;
         //-------------------------------------------------
         // Point schema:
         //   Leg: Point_1: Point_2: Point_3: Point_4
         //--------------------------------------     
         int point_indexes[int(zzz_index_length)][5] = {
            ab_xa,point_a,point_b,point_x,point_a,   // AB/XA
            ad_xa,point_a,point_d,point_x,point_a,   // AD/XA (~CD_XA)
            bc_ab,point_b,point_c,point_a,point_b,   // BC/AB
            cd_ab,point_c,point_d,point_a,point_b,   // CD/AB
            cd_bc,point_c,point_d,point_b,point_c    // CD/BC (Unneeded for major patterns, needed for Fib retracement)
         };
         if(!null_sweep_flag){
            for(int ii=0; ii < int(zzz_index_length); ii++){
               zzz_points[p][ii][r] = 
                  MathAbs( ( zzz_points[p][point_indexes[ii][1]][z] - zzz_points[p][point_indexes[ii][2]][z] ) ) 
                  /
                  MathAbs( ( zzz_points[p][point_indexes[ii][3]][z] - zzz_points[p][point_indexes[ii][4]][z] ) );
            };
         }else{Print("[ SymphonySorcery | CalculateHarmonicRatios ] Failed null sweep. Points array contains some 0's"); return(False);};
         return(True);
      };
      //--------------------------------
      //  fetch_points:
      //    @note: Fish for Globals and store them in zzz_points. 
      //           Sets value to -1 if not found, to avoid divide by zero errors
      //    @param std_period: PERIOD_X format
      //---------------------------------
       void fetch_points(int std_period){
         int z = int(zzz_points_index);
         int p = sym_def.get_period_index(std_period);
         string point_strings[] = {"X","A","B","C","D"};
         for(int i = 0; i < int(zzz_index_length); i++){
            double point        = GlobalVariableGet(StringConcatenate("ZigZagZug_",point_strings[i],sym,std_period));
            zzz_points[p][i][z] = point;
            if(zzz_points[p][i][z] == 0) zzz_points[p][i][z] = -1;
          };
         
      };
      //------------------------------------------------------------
      //   is_there_pattern:
      //      @note: Core algorithm identifying patterns. Compares the retracement relationships between ZZZ points and 
      //             retracement levels. Applies small error margin if need be.
      //      @param std_period: PERIOD_X format
      //      @param partial: Is it a partial pattern?
      //      @return: matched_pattern_index = pattern_schema index of pattern, -1 if none found
      //----------------------------------------------------------------------------
      //- Pattern:      Gartley        Butterfly         Bat          Crab
      // > AB/XA   | 0.618         | 0.786         | 0.382 - 0.500 | 0.382 - 0.618
      // > BC/AB   | 0.382 - 0.886 | 0.382 - 0.886 | 0.382 - 0.886 | 0.382 - 0.886
      // > CD/BC   | 1.270 - 1.618 | 1.618 - 2.618 | 1.618 - 2.618 | 2.240 - 3.618
      // > AD/XA   | 0.786         | 1.270 - 1.618 | 0.886         | 1.618
      //-----------------------------------------------------------------------------
      //   Note: Margin of error will not be added to the ranges
      //----------------------------------------------------------------------------------------------------
      //  Pattern Matchers:
      //       > Method overrides can return 'true' if there is a...
      //          1) Completed pattern AND is_*** is called
      //          2) Partial pattern match AND is_partial_*** is called
      //       > Partial matches do NOT consider Pt D
      //       > General structure repeats, but there are unique ranges for each pattern
      //------------------------------
      
      int is_there_pattern(int std_period,bool partial){
         refresh();
         //----------------
         // closest_match_points => Array to store deviation from each pattern
         //    > Use for error reporting if no patterns match
         //    > Schema:
         //      > A '0' if the particular retracement is in range
         //      > The difference (% wise) if it is not
         //-------------------------------------
         double closest_match_points[4][4];
         //--------------------------------
         //  upper_limits/lower_limtits:
         //    --> Define the retracement ratios to work with
         //--------------------------------------
         double upper_limits[int(pattern_index_length)][4]= 
             {  0.618,0.886,1.618,0.786,       //gartley
                0.786,0.886,2.618,1.618,       //butterfly
                0.618,0.886,3.618,1.618,       //crab
                0.500,0.886,2.618,0.886        //bat
             };
         double lower_limits[int(pattern_index_length)][4] = 
             { 0.618,0.382,1.270,0.786,        //gartley
               0.786,0.382,1.618,1.270,        //butterfly
               0.382,0.382,2.240,1.618,        //crab
               0.382,0.382,1.618,0.886,        //bat
            
            };
         int p        = sym_def.get_period_index(std_period);
         //--------------------------------
         //  Matching algorithm:
         //    > Cycle through the lower and upper retracement bounds of each pattern in parallel
         //       -> If the limits are equal, apply a small range
         //          TODO: Potential optimization factor for range
         //       -> Else make sure they are in the range
         //    > patterns will be put inserted (into limits arrays) in order of index enumeration
         //       -> [ gartley -> butterfly -> crab -> bat ]
         //-----------------------------------------------------
         int matched_pattern_index = -1;
         int match_count = 0;
         //-----> Top Loop conditions (patterns): 
         //        > Look through relevant retracement indexes
         //------------------------------------
         for(int p = 0; 
            (partial == True && p < pattern_index_length && p > gartley) || 
               (partial == False && p <= full_pattern_end_index); 
            p++){
            
            match_count = 0;
            //-----> Nested Loop conditions (retracement levels): 
            //        > Look through first two retracement indexes if partial, else do all
            //------------------------------------
            for(int i = 0; 
               (i < 4 && partial == False) || 
                  (partial == True && i < 2); i++){
                //---> Begin loop  
               int true_pattern_index = p;
               if(p > full_pattern_end_index) true_pattern_index = p - 4; 
               double up_limit          = upper_limits[p][i] + err_margin;
               double down_limit        = upper_limits[p][i] - err_margin;
               double retracement_value = this.get_retracement(std_period,i);
               if(upper_limits[p][i] == lower_limits[p][i]){  //---> If the retracement is not a range, make it one
                  if( retracement_value <= up_limit &&  //------> Try to match, or store the deviation
                      retracement_value >= down_limit){
                      match_count++;
                       
                  }else{
                     closest_match_points[p][i] = MathAbs(retracement_value - upper_limits[p][i]);
                      
                  };
               }else{
                  if( retracement_value <= upper_limits[p][i] && 
                      retracement_value >= lower_limits[p][i]){
                      match_count++;
                   }else{
                     if(retracement_value > upper_limits[p][i]) closest_match_points[p][i] = retracement_value - upper_limits[p][i];
                        else closest_match_points[p][i] = lower_limits[p][i] - retracement_value;
                   };
               };
            };
            if(match_count == 4){ matched_pattern_index = p; break; };
         };
         //-------------------------------------
         //  Deviation Report:
         //    --> If no patterns were found, then report on the one that was the closest
         //--------------------------------------------
         double lowest_avg = -1; int lowest_avg_index = -1;
         if(matched_pattern_index == -1 && partial == False){
            for(int i = 0; i < 4; i++){
               double avg = 0;
               for(int p = 0; p < 4; p++)
                  avg += closest_match_points[i][p];
               avg /= 4;
               if(lowest_avg == -1 || avg < lowest_avg){ lowest_avg = avg; lowest_avg_index = i; };
            };
            /*Print("For [",sym,":",sym_def.standard_period_to_string(std_period),"] Closest Pattern: ",sym_def.pattern_index_to_string(lowest_avg_index),
                  " [",sym_def.retracement_index_to_string(0),":%",DoubleToString(closest_match_points[lowest_avg_index][0]*100,3),"] ",
                  " [",sym_def.retracement_index_to_string(1),":%",DoubleToString(closest_match_points[lowest_avg_index][1]*100,3),"] ",
                  " [",sym_def.retracement_index_to_string(2),":%",DoubleToString(closest_match_points[lowest_avg_index][2]*100,3),"] ",
                  " [",sym_def.retracement_index_to_string(3),":%",DoubleToString(closest_match_points[lowest_avg_index][3]*100,3),"] ");*/
         };
         //----------------------
         // > Set the global "valid_pattern" flag if this is a tradable pattern
         //---------------------------------------------------
         if(matched_pattern_index != -1) valid_pattern = True;
         else valid_pattern = False;
         //Print("[ SYmphony | isTherePattern ] Valid Pattern Index: ",matched_pattern_index);
         return(matched_pattern_index);
         
      };
      //----------------------------
      //  get_point:
      //    @note: Retrieves point from zzz array
      //    @param std_period: PERIOD_X format
      //    @param point_index: From zzz_schema.point_x
      //    @param isPartial: True if partial pattern being searched for. Pushes index forward one, basic bounds checking
      //    @return: ZZZ point desired
      //--------------------------------
      double get_point(int std_period,int point_index, bool isPartial){
         int p = sym_def.get_period_index(std_period); //--> Now its an index
         if(isPartial==True && point_index < point_d){ return(zzz_points[p][point_index+1][int(zzz_points_index)]);}
         else if(isPartial==True && point_index == point_d) {
              Print("[ Symphony | Sorcery | GetPoint ] Error in conversion. Should not call point_d index on partial pattern. point_index: ",point_index," isPartial?: ",isPartial); 
              return(-1);
         }else if(point_index >= point_x && point_index <= point_d){return(zzz_points[p][point_index][int(zzz_points_index)]);}
         else{Print("[ Symphony | Sorcery | GetPoint ] Error in conversion. Point_index: ",point_index," isPartial? ",isPartial); return(-1);};
       };
      //---------------------------
      // get_pattern_string:
      //    @param std_period: PERIOD_x
      //    @return: string for pattern on chart, "None" if there isn't one
      //--------------------------------
       string get_pattern_string        (int std_period){return(SymphonyDefinitions::pattern_index_to_string(this.get_pattern_index(std_period)));};
       string get_partial_pattern_string(int std_period){return( StringConcatenate("Partial ",SymphonyDefinitions::pattern_index_to_string(this.get_partial_pattern_index(std_period))));};
      
      //----------------------------------------------
      //  get_prz:
      //    @note: Calculate all necessary Fibonacci retracements derived from pattern legs. 
      //       Identify top and bottom cluster means, return the appropriate mean (highest if sell, lowest if buy)
      //    @param std_period: PERIOD_X
      //    @param isPartial: Is this pattern a partial pattern
      //                         > If yes, predict the next leg and where the PRZ will land TODO
      //    @return: Appropriate cluster mean to be used as stoploss
      //------------------------------------------------------
      
      double get_prz(int std_period,bool isPartial){
         int z = int(zzz_points_index);
         int p = sym_def.get_period_index(std_period);
         //-------------------------------------
         // Fibonacci Retracement Schema:
         //       internal_ret, leg, ret_val_1, ret_val_2, ret_val_3, ret_vale_4, -1,
         //       external_ret, leg, ret_val_1, ret_val_2, -1       , -1        , -1,
         //    price_expansion, leg, ret_val_1, ret_val_2, ret_val_3, ret_val_4, ret_val_5
         //   price_projection, leg, ret_val_1, ret_val_2, ret_val_3, ret_val_4, -1
         //    > When iterating, negative values will be passed over
         //--------------------------------------
         // Internal Price Retracements:       External Price Retracements:   Price Expansion:                   Price Projection
         //    > Point X -> Point A              > Point B -> Point C           > Point A -> Point B             > Point B -> Point A
         //    > 38.2, 50, 61.8, 78.6%           > 127, 161.8%                  > 61.8, 100, 161.8, 200, 261.8%  > 61.8, 100, 161.8, 200%
         //---------------------------------------------
         double points_reference[int(fibonacci_schema_length)][5] = {
            0.382, 0.500, 0.618, 0.786, -1,    // Internal Price Retracements (fibonacci_schema.internal_ret)
            1.270, 1.618, -1   , -1   , -1,    // External Price Retracements (fibonacci_schema.external_ret)
            0.618, 1.000, 1.618, 2.000, 2.618, // Price Expansion             (fibonacci_schema.price_expansion)
            0.618, 1.000, 1.618, 2.000, -1     // Price Projection            (fibonacci_schema.price_projection)
         };
         double points[ int(fibonacci_retracement_points) ];
         int method_value[ int(fibonacci_retracement_points) ]; //--> For objects
         double retracement_value[ int(fibonacci_retracement_points) ]; //--> For objects
         color method_colors[ int(fibonacci_retracement_points) ] = {
            clrAqua, clrRed, clrDarkGoldenrod, clrDarkSalmon
         };
         //----------------------------
         //  Point Indexing:
         //    > Algorithm:
         //       1) Loop over all Fibonacci retracement method rows in turn
         //       2) Calculate retracement if value > -1
         //       3) Increment insert_index if value > -1
         //          a) If == -1, break out of sub loop
         //-----------------------------------------------
         int insert_index = 0;
         for(int method_index = 0; 
               (isPartial == False && method_index < int(fibonacci_schema_length)) 
            || (isPartial == True && method_index < int(fibonacci_schema_length)-1);
                method_index++){
               for(int val_index = 0; val_index < 5; val_index++){
                  double ret_val = points_reference[method_index][val_index];
                  if(ret_val!=-1){
                     //---- Deal with partial patterns
                     switch(isPartial){
                        case False: points[insert_index] = 
                                          get_leg_retracement( std_period, ret_val, method_index); break;
                        case True:  points[insert_index] = 
                                          get_partial_leg_retracement(std_period, ret_val, method_index ); break;
                     };
                     method_value[insert_index]      = method_index;
                     retracement_value[insert_index] = ret_val;
                     insert_index++;
                  }else if(ret_val == -1){ break;
                  }else{continue;};
               };
         };
         
         //---------------------------------------
         //  Object Creation:
         //    > Generate Objects and their labels
         //    > Vetting:
         //      1) Do not process Fibs below an Ask (Sell), or above a Bid (Buy).
         //      2) Do not process Fibs > 100% extension of highest point in pattern
         //-----------------------------------------------------------
         int order_type        = get_order_type(std_period);
         double low_threshold  = get_lowest_point(std_period)  - get_hilo_diff(std_period); // BUY
         double high_threshold = get_highest_point(std_period) + get_hilo_diff(std_period); // SELL
         int rej_count         = 0;
         
         if(isPartial) ArrayResize(points,11,0);
         for(int i = 0; i< ArraySize(points); i++){
            // Vet the points
            bool test_passed = False;
            switch(isPartial){
                  case False: if( (order_type == ORDER_TYPE_BUY && points[i] < get_point(std_period,point_d) && 
                                   points[i] > low_threshold) ||
                                (order_type == ORDER_TYPE_SELL && points[i] > get_point(std_period,point_d) && 
                                   points[i] < high_threshold )  ){
                                          test_passed = True;
                                          
                               }else{rej_count++;};
                  case True: if( (order_type == ORDER_TYPE_BUY && points[i] < get_point(std_period,point_d) ) || 
                                 (order_type == ORDER_TYPE_SELL && points[i] > get_point(std_period,point_d) ) ){
                                    test_passed = True;
                                 
                                 };
                 
              };
             
             //-------> Object creation if point passed the tests
             if(test_passed){
               string obj_name = StringConcatenate( sym_def.fibonacci_index_to_string(method_value[i]),":",DoubleToString(retracement_value[i],3));
               string obj_text = StringConcatenate("^ ",obj_name," ^");
               string obj_label = StringConcatenate(obj_name,"_Label");
               /*ObjectCreate(0,obj_name,OBJ_HLINE,0,0,points[i]);
               ObjectSet(obj_name,OBJPROP_COLOR,method_colors[ method_value[i] ]);
               ObjectCreate(0,obj_label,OBJ_TEXT,0,Time[1],ObjectGet(obj_name, OBJPROP_PRICE1));
               ObjectSetText(obj_label,obj_text,8,NULL,clrDarkOrange);*/
             };
         };
         //------------------------------------
         //  DEMARK BLOCK
         //----------------------------------
         
         //demark.draw_demark_retracement(get_point(std_period,point_c),std_period);
         
         //-----------------------------------------------
         //  k-Means Cluster:
         //      1) Define initial partition - The two points that are furthest apart
         //         -> Mean vectors are now (first_mean,second_mean), which are the hi/lo points
         //      2) Remaining points are now examined, and placed in the cluster they are closest to a la
         //         -> Euclidean measure [linear distance]
         //         -> The mean vectors (first_mean, second_mean) are recalculated each time a new member is added
         //      3) Repartition
         //          -> Even though all individuals have now been added to their closest cluster, individual points
         //             could still possibly be closer to the opposite cluster. We must find out.
         //----------------------------------------------
             
           ArraySort(points,WHOLE_ARRAY,0,MODE_DESCEND); 
           double first_mean = points[0], second_mean = points[ArraySize(points)-1];
           //Print("First_mean: ",string(first_mean)," Second-mean: ",string(second_mean));
           double first_cluster[1], second_cluster[1];
               first_cluster[0] = first_mean; second_cluster[0] = second_mean;
           int indexes_used[] = {0}; //--> add out first indicies used
               ArrayResize(indexes_used,ArraySize(indexes_used)+1); //--> Tracks what retracements from points have been used (by index)
               indexes_used[ ArraySize(indexes_used)-1 ] = ArraySize(points) - 1;
           bool break_out = False;
           while(!break_out){
               for(int i = 1; i < ArraySize(points)-1; i++){
                  //Print("First_mean: ",DoubleToString(first_mean,_Digits)," Second-mean: ",DoubleToString(second_mean,_Digits),
                  //" 1st-diff: ",DoubleToString(MathAbs(points[i] - first_mean),_Digits)," 2nd-diff: ",DoubleToString(MathAbs(points[i] - second_mean),_Digits));
                  if( MathAbs(points[i] - first_mean) < MathAbs(points[i] - second_mean) ){ //...if closer to first mean
                     first_mean = process_cluster(first_cluster,indexes_used,points[i],i); //... add to cluster, log index, return mean
                  }else{   //...closer to second mean
                     second_mean = process_cluster(second_cluster,indexes_used,points[i],i);
                  };
               };
               //>>>>>>>>>>>>>>>>>>>>>>
               // End initial partition
               //>>>>>>>>>>>>>>>>>>>>>>
               // Begin repartition
               //>>>>>>>>>>>>>>>>>>>>>
               int repartition_limit = 15; //--> This is largely arbitrary
               for(int p = 0; p < repartition_limit; p++){
                  //Print("On repartition iteration #",p+1," FirstMean: ",DoubleToString(first_mean,_Digits)," Second Mean: ",DoubleToString(second_mean,_Digits));
                  for(int i = 0; i < ArraySize(first_cluster); i++){ //...see if first_cluster has any points closer to second_mean
                     if( MathAbs(first_cluster[i] - second_mean) > MathAbs(first_cluster[i] - first_mean)){
                        //Print("Found Repartition on [",p,"] partition iteration. Stripping from first");
                        swap_and_remove(first_cluster,i,second_cluster);
                        first_mean = take_mean(first_cluster);
                        second_mean = take_mean(second_cluster);
                     }else{continue;};
                  };
                  for(int i = 0; i < ArraySize(second_cluster); i++){
                     if(MathAbs(second_cluster[i] - first_mean) > MathAbs(second_cluster[i] - second_mean)){
                        //Print("Found Repartition on [",p,"] partition iteration. Stripping from second. ");
                        swap_and_remove(second_cluster,i,first_cluster);
                        first_mean = take_mean(first_cluster);
                        second_mean = take_mean(second_cluster);
                     }else{continue;};
                  };
               }
               
               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               //  End Repartition
               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               //for(int v = 0; v < ArraySize(first_cluster); v++) Print("FirstCluster[",v,"] = ",DoubleToString(first_cluster[v],_Digits));
               //for(int v = 0; v < ArraySize(second_cluster); v++) Print("SecondCluster[",v,"] = ",DoubleToString(second_cluster[v],_Digits));
               ObjectCreate(0,"FirstMean",OBJ_HLINE,0,0,first_mean);
               ObjectSet("FirstMean",OBJPROP_COLOR,clrPink);
               ObjectCreate(0,"SecondMean",OBJ_HLINE,0,0,second_mean);
               ObjectSet("SecondMean",OBJPROP_COLOR,clrPink);
               break_out = True;  
           };
           //--------------------------------
           // Return lowest mean if buy, highest if sell
           //-------------------------------
           double high_mean = 0, low_mean = 0;
           if(first_mean > second_mean){ high_mean = first_mean; low_mean = second_mean; 
           }else{high_mean = second_mean; low_mean = first_mean;};
           
           if(get_point(std_period,point_c) > get_point(std_period,point_d)) return(low_mean); //buy
           else return(high_mean); // Sell
           
      };
            //---------------------------------
            // Helpers for get_prz: k-mean calculations
            //---------------------------------
            //  take_mean:
            //    @note: Helper. Calculates mean from given array
            //    @param data: Data to average
            //-----------------------------------
            double take_mean(double &data[]){
               double sum = 0;
               for(int i = 0; i < ArraySize(data); i++)
                  sum +=data[i];
               return(sum/ArraySize(data));
            };
           //-----------------------------------------
           //  process_cluster:
           //     @param cluster: Cluster array to resize and process
           //     @param indexes_used: Tracks which indicies from points[] has been used
           //     @param point_at_i: The data point to add to the cluster
           //     @param index: The index to add to indexes_used
           //     @return: new mean of the cluster
           //-----------------------------------------------
           double process_cluster(double &cluster[],int &indexes_used[], double point_at_i, int index){
               ArrayResize(cluster,ArraySize(cluster)+1); //...add and average
               ArrayResize(indexes_used,ArraySize(indexes_used)+1);
               cluster[ ArraySize(cluster) -1 ] = point_at_i; indexes_used[ ArraySize(indexes_used) -1 ] = index;
               return(take_mean(cluster)); //... updated cluster mean
           };
           //----------------------------------------
           //  swap_and_remove:
           //     @note: Must recalculate means after this operation
           //     @param cluster_to_pop: Needs to have a value removed
           //     @param pop_index: Index to strip value from and push to next cluster
           //     @param cluster_to_push: Array to be given new value
           //------------------------------------------------
           
           void swap_and_remove(double &cluster_to_pop[], int pop_index, double &cluster_to_push[]){
               double val = cluster_to_pop[pop_index];
               cluster_to_pop[pop_index] = -1000;
               ArraySort(cluster_to_pop,WHOLE_ARRAY,0,MODE_DESCEND); //---> Push value to back of array
               ArrayResize(cluster_to_pop,ArraySize(cluster_to_pop)-1); //--> Strip
               ArrayResize(cluster_to_push,ArraySize(cluster_to_push)+1);
               cluster_to_push[ ArraySize(cluster_to_push)-1 ] = val;
           };
      
      //-----------------------------
      // Helpers:
      //-------------------------------
      
      //-----------------------------
      // retracement_string_builder:
      //    @note: Constructs and returns string of retracement channel. For pretty_print_ratios
      //    @param retracement_index: From zzz_schema
      //    @return: Formatted string
      //-------------------------------
       string retracement_string_builder(int retracement_index){
         string msg;
         int r      = int(zzz_retracements_index);
         for(int p = 0; p < periodIndexLength; p++){
            msg = StringConcatenate( msg,
               StringFormat("|   %s    ",DoubleToString(zzz_points[p][retracement_index][r],_Digits))
            );
         };
         msg = StringConcatenate(msg,"| ",SymphonyDefinitions::retracement_index_to_string(retracement_index));
         return(msg);
      }
      //---------------------------------
      // get_retracement:
      //    @note: Gets retracement for given index from zzz_schema
      //    @param std_period: PERIOD_X format
      //    @param ret_index: From zzz_schema
      //    @param isPartial: Is partial pattern?
      //    @return: -1 if there was an error, proper retracement from zzz_points otherwise
      //-----------------------------------
       double get_retracement(int std_period,int ret_index, bool isPartial){
         int p = sym_def.get_period_index(std_period);
         int z = int(zzz_retracements_index);
         if(isPartial == True && ret_index < ad_xa){ return(zzz_points[p][ret_index+1][z]); // Retracement for partial pattern
         }else if(isPartial == True && ret_index >= ad_xa){ Print("[ Symphony | Sorcery | getRetracement ] Error getting ",SymphonyDefinitions::retracement_index_to_string(ret_index)," isPartial? ",isPartial); return(-1);
         }else if(ret_index >= zzz_index_length){ Print("[ Symphony | Sorcery | getRetracement ] Index too big"); return(-1);
         }else{return(zzz_points[p][ret_index][z]);}; // Retracement for normal pattern
      };
      //---------------------------------
      // Helpers for get_prz:
      //-----------------------------------
      //  get_leg_retracement:
      //    @note: Calculates given retracement. Allows get_prz to be type agnostic
      //    @param leg_index: Leg to draw from (xa, ab, etc...)
      //    @param retracement: Retracement level
      //    @param std_period: PERIOD_X format
      //    @param fibonacci_index: Some Fibonacci projections draw from the later leg to the earlier, must match
      //    @return: Desired retracement ratio of leg
      //----------------------------------
       double get_leg_retracement(int std_period, double retracement, int fibonacci_index, bool isPartial){
         int p = sym_def.get_period_index(std_period);
         int z = int(zzz_points_index);
         //-----------------------------------------------------------------------------------
         // Methodology (Full Pattern):                Methodology (Partial Pattern):
         //    1) Interal Retracement       --> XA       1) Internal Retracement   --> AB
         //       > BUY  => Subtract from A                 > BUY  => Subtract from B
         //       > SELL => Add to A                        > SELL => Add to B
         //    2) External Retracement      --> BC       2) External Retracement   --> CD
         //       > BUY  => Subtract from C                 > BUY  => Subtract from D
         //       > SELL => Add to C                        > SELL => Add to D
         //    3) Price Expansion           --> AB       3) Price Expansion        --> BC
         //       > BUY  => Subtract from B                 > BUY  => Subtract from C
         //       > SELL => Add to B                        > SELL => Add to C
         //    4) Price Projection          --> AB
         //       > BUY  => Subtract from C
         //       > SELL => Add to C
         //------------------------------------------------------------------------------------
         double diff = -1;
         if(fibonacci_index == internal_ret){ 
            if(!isPartial) diff = MathAbs(zzz_points[p][ point_a ][z] - zzz_points[p][ point_x ][z]);
               else diff = MathAbs(zzz_points[p][ point_b ][z] - zzz_points[p][ point_a ][z]);
         }else if(fibonacci_index == external_ret ){
            if(!isPartial) diff = MathAbs(zzz_points[p][ point_c ][z] - zzz_points[p][ point_b ][z]);
               else diff = MathAbs(zzz_points[p][ point_d ][z] - zzz_points[p][ point_c ][z]);
         }else if(fibonacci_index == price_expansion || fibonacci_index == price_projection){
            if(!isPartial) diff = MathAbs(zzz_points[p][ point_a ][z] - zzz_points[p][ point_b ][z]);
               else diff = MathAbs(zzz_points[p][ point_c ][z] - zzz_points[p][ point_b ][z]);
         }else{Print("[ Symphony | Sorcery | GetRetracement ] Error. Unknown fibonacci_index: ",fibonacci_index); return(-1);};
         
         double ret_val = NormalizeDouble( (diff * retracement), _Digits);
         double result = -1;
         
         int order_type = -1; 
         if(!isPartial) order_type = get_order_type(std_period);
            else order_type = get_partial_order_type(std_period);
         int method_switch = 0;
         if(isPartial){ method_switch = 1; };
         //---> Fib methods
         int fib_techniques[2][int(fibonacci_schema_length)] = {
            internal_ret,external_ret,price_expansion,price_projection,
            internal_ret,external_ret,price_expansion,-1
         };
         //---> Method relevant point
         int fib_rel_point[2][int(fibonacci_schema_length)] = {
            point_a, point_c, point_b, point_c,   // Full pattern
            point_b, point_d, point_c, -1         // Partial pattern
         };
         
         for(int i = 0; (isPartial == False && i < int(fibonacci_schema_length)) 
                     || (isPartial == True && i < int(fibonacci_schema_length)-1); i++){
                     if(fibonacci_index == fib_techniques[method_switch][i]){
                        if(!isPartial){
                           if(order_type == ORDER_TYPE_BUY) result = get_point(std_period, fib_rel_point[method_switch][i] ) - ret_val;
                              else result = get_point(std_period, fib_rel_point[method_switch][i] ) + ret_val;
                        }else{
                           if(order_type == ORDER_TYPE_BUY) result = get_point(std_period, fib_rel_point[method_switch][i] ) + ret_val;
                              else result = get_point(std_period, fib_rel_point[method_switch][i] ) - ret_val;
                        };
                        return(result);
                     }
         };
         return(-1);
      };
      //-------------------------------
      //  get_hilo_difference:
      //    @param std_period: PERIOD_X format
      //    @return: The difference between the highest and lowest point in the pattern
      //----------------------------------
      double get_hilo_diff(int std_period){ return( get_highest_point(std_period) - get_lowest_point(std_period) );};
      //-----------------------------------------
      //  get_lowest_point,get_highest_point:
      //    @param std_period: PERIOD_X format
      //    @return: lowest/highest point in pattern
      //------------------------------------------
      double get_lowest_point(int std_period){ 
            double low = -1;
            for(int i = 0; i < zzz_index_length; i++){
               double point = get_point(std_period,i); 
               if( low == -1 || point < low) low = point;
            };
            return(low);
         };
       double get_highest_point(int std_period){ 
            double high = -1;
            for(int i = 0; i < zzz_index_length; i++){
               double point = get_point(std_period,i);
               if( point > high) high = point;
            };
            return(high);
         };
      //--------------------
      //  in_range:
      //     @return: True if point is not above (buy) or below (sell) Point D
      //-------------------------------
       bool in_range(double point, int std_period){
         int p = sym_def.get_period_index(std_period);
         int z = int(zzz_points_index);
         int type;
         if(zzz_points[p][point_c][z] > zzz_points[p][point_d][z])
            type = ORDER_TYPE_BUY;
         else type = ORDER_TYPE_SELL;
         if(      (point > zzz_points[p][point_d][z] && type == ORDER_TYPE_BUY) ) return(False);
         else if ((point < zzz_points[p][point_d][z] && type == ORDER_TYPE_SELL)) return(False);
         else return(True);
      };
      //---------------------------------
      // End helpers for get_prz:
      //-----------------------------------
      //----------------------------------
      // set_zzz_points:
      //   @note: Fill zzz_array with -1s to avoid divide by zero error
      //------------------------------------------------
      void set_zzz_points(){
         for(int p = 0; p < periodIndexLength; p++)
            for(int z = 0; z < int(zzz_index_length); z++)
               for(int i = 0; i < 2; i++)
                 zzz_points[p][z][i] = -1;
      };
      //------------------------------------
      //  is_row_empty:
      //    @param std_period: Row to check
      //    @return: True if the row is uninitialized
      //------------------------------------
      bool is_row_empty(int std_period){
         int p = this.sym_def.get_period_index(std_period);
         int z = int(zzz_points_index);
         return(zzz_points[p][0][z]==-1);
      };
      //-----------------------------------
      //  get_closest_match:
      //    @note: Will find out which pattern is the closest to the current points
      //    @param std_period: Period to analyze
      //    @return: pattern_schema.pattern
      //-------------------------------------
      int get_closest_match(int std_period){
         return(-1);
      };
      //-------------------------------------
      //  get_order_type:
      //     @param std_period: PERIOD_X format
      //     @return: ORDER_TYPE_BUY, ORDER_TYPE_SELL
      //-------------------------------------
      int get_order_type(int std_period,bool isPartial){
         int p = this.sym_def.get_period_index(std_period);
         int z = int(zzz_points_index);
         if(!isPartial){
            if(zzz_points[p][point_d][z] < zzz_points[p][point_c][z]) return(ORDER_TYPE_BUY);
            else return(ORDER_TYPE_SELL);
         }else{
            if(zzz_points[p][point_d][z] < zzz_points[p][point_c][z]) return(ORDER_TYPE_SELL);
               else return(ORDER_TYPE_BUY);
         };
      };
      //----------------------------------
      //  ask_or_bid:
      //    @param type: Order type
      //    @param close: is this order a closing one?
      //    @return: Proper opening price for trade
      //--------------------------------------
      double ask_or_bid      (int type,bool close){
         switch(type){
            case ORDER_TYPE_BUY: if(!close) return(Ask);
                                    else return(Bid);
            case ORDER_TYPE_SELL: if(!close) return(Bid);
                                    else return(Ask);
            default: Print("[ Symphony | Sorcery | AskOrBid ] OrderType undefined. Last Error: ",ErrorDescription(GetLastError())); 
                     return(-1);
         };
      };
      
      
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
   SymphonySorcery * sorcery;
   string sym;
   SymphonyDefinitions * sym_def;
   public:
      //--------> Constructor
      //    > Set Symbol
      //-----------------------
      SymphonyIllustrator(string symbol){
         this.sym = symbol;   
         this.sorcery = new SymphonySorcery(this.sym); this.refresh();
         this.sym_def = new SymphonyDefinitions();
      };
      SymphonyIllustrator()             {
         this.sym = Symbol(); 
         this.sorcery = new SymphonySorcery(this.sym); this.refresh();
         this.sym_def = new SymphonyDefinitions();
      };
      
      //---------------------------------
      //  get_midtime:
      //    @param first_point: zzz_schema.point
      //    @param second_point: zzz_schema.point
      //    @param std_period: PERIOD_X format
      //    @return: time of the median between two points
      //      to aid in drawing the pattern
      //-------------------------------------
       datetime get_midtime(int first_point_index, int second_point_index, int std_period){
         int p = sym_def.get_period_index(std_period);
         int z = int(zzz_points_index);
         int first_bar_index = -1, second_bar_index = -1;
         
         if( (first_point_index > 4 || first_point_index < 0) || (second_point_index > 4 || second_point_index < 0)) 
            Print("[ Symphony | Illustrator | GetMidtime ] Invalid point index. First Point: ",first_point_index," Second Point:",second_point_index);
         else{
            for(int i = 0; i < Bars; i++){
               if( (High[i] == sorcery.get_point(std_period,second_point_index) || Low[i] == sorcery.get_point(std_period,second_point_index)) 
                    && first_bar_index == -1){
                    ObjectCreate(0,"ssc",OBJ_VLINE,0,Time[i],0);
                  first_bar_index = i;};
               if( (High[i] == sorcery.get_point(std_period,first_point_index) || Low[i] == sorcery.get_point(std_period,first_point_index)) 
                    && second_bar_index == -1)
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
      //------------------------------------
      // draw_pattern:
      //    > Draw REGARDLESS of whether or not there is actually a pattern on the chart
      //    Option 1: Draw Full pattern
      //    Option 2: Draw Partial pattern
      //       a) Overloaded method breaks after first two points have been processed
      //       b) Must push drawing parameters forwards one point because they are 
      //          still called via same schema
      //----------------------------------------------------------
      void draw_pattern        (int std_period){ this.draw_pattern(std_period,False); };
      void draw_partial_pattern(int std_period){ this.draw_pattern(std_period,True); };
      
      //-------------------------------------
      // refresh:
      //   @note: Refreshes sorcery
      //-----------------------------------
      void refresh(){ this.sorcery.refresh(); };
      //-------------------------------------
      // pretty_print:
      //   @note: Refreshes sorcery
      //-----------------------------------
      void pretty_print(){ this.sorcery.pretty_print(); };
      private:
         int get_retracement_index_by_string(string s){
               if     (s == "AB/XA") return(ab_xa);
               else if(s == "AD/XA") return(ad_xa);
               else if(s == "BC/AB") return(bc_ab);
               else if(s == "CD/AB") return(cd_ab);
               else if(s == "CD/BC") return(cd_bc);
               else                  return(-1);
         };
         void draw_pattern        (int std_period,bool partial){
            int p = sym_def.get_period_index(std_period);
            int r = int(zzz_retracements_index);
            
            this.sorcery.refresh(std_period);
            if(sorcery.is_there_pattern(std_period)==true) //--> Also sets "valid_pattern" on a global level
               Print("[ SymphonyIllustrator | Draw Pattern ] There is a tradable pattern on ",this.sym," for ",sym_def.standard_period_to_string(std_period));
            //------------------------------
            // Draw the PRZ, whatever it may be...
            //------------------------------------
            this.sorcery.get_prz(std_period);
            
            //----> Set necessary vars
            datetime x_time = this.sorcery.get_datetime(point_x,std_period);
            datetime a_time = this.sorcery.get_datetime(point_a,std_period);
            datetime b_time = this.sorcery.get_datetime(point_b,std_period);
            datetime c_time = this.sorcery.get_datetime(point_c,std_period);
            datetime d_time = this.sorcery.get_datetime(point_d,std_period);
            double   x = this.sorcery.get_point(std_period,point_x);
            double   a = this.sorcery.get_point(std_period,point_a);
            double   b = this.sorcery.get_point(std_period,point_b);
            double   c = this.sorcery.get_point(std_period,point_c);
            double   d = this.sorcery.get_point(std_period,point_d);
            int pixel_offset = 0;
            datetime first_time,second_time,mid_time;
            double   first_point = 0, second_point = 0,y_dist = 0;
            //---> First to have to match for partial retracement (break if partial=True)
            string   retracements[4] =         {"AB/XA","BC/AB","AD/XA","CD/BC"};
            for(int i = 0; i < ArraySize(retracements); i++){
               if(retracements[i]=="AB/XA"){ // X -> B
                  //---> True levels are NOT those in the following block. 
                  //     Must do so to draw at appropriate points. Push one point ahead
                  if(partial){
                        first_time  = a_time; first_point  = a;
                        second_time = c_time; second_point = c;
                  }else{
                       first_time  = x_time; first_point  = x;
                       second_time = b_time; second_point = b;
                       };
               }else if(retracements[i]=="BC/AB"){ // A -> C
                  if(partial){
                       first_time  = b_time; first_point  = b;
                       second_time = d_time; second_point = d;
                   }else{
                       first_time  = a_time; first_point  = a;
                       second_time = c_time; second_point = c;
                      };
               }else if(retracements[i]=="AD/XA"){ // AD/XA is the true retracement
                 first_time  = x_time; first_point  = x;
                 second_time = d_time; second_point = d;
                }else if(retracements[i]=="CD/BC"){
                 first_time  = b_time; first_point  = b;
                 second_time = d_time; second_point = d;
                }else{};
               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               //  Painting block
               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                color retracement_color = clrYellow;
                if(this.sorcery.is_there_pattern(std_period)) retracement_color = clrGreen; //--> Green if pattern is tradable
                ObjectCreate(0,retracements[i],OBJ_TREND,0,first_time,first_point,second_time,second_point);
                ObjectSet   (retracements[i], OBJPROP_COLOR, retracement_color);
                ObjectSet   (retracements[i], OBJPROP_RAY,   False); // turn into segment
                ObjectSet   (retracements[i], OBJPROP_WIDTH, 3);
                string object_text = StringConcatenate(retracements[i],"_Text");
                int    ret_index   = this.get_retracement_index_by_string(retracements[i]);
                       //y_dist      = ObjectGetValueByTime(0,retracements[i],mid_time);
               //--> Retracement information will be placed in the upper right hand corner 
               ObjectCreate(0,object_text,OBJ_LABEL,0,0,0);
               ObjectSet    (object_text, OBJPROP_CORNER,  1);    // Reference corner
               ObjectSet    (object_text, OBJPROP_XDISTANCE, 0);// X coordinate
               ObjectSet    (object_text, OBJPROP_YDISTANCE, pixel_offset);// Y coordinate
               
               color text_color = clrYellow;
               if(this.sorcery.is_there_pattern(std_period) == True) text_color = clrGreen; //---> Write retracements in green if there is a valid pattern on chart
               
               ObjectSetText(object_text,StringConcatenate(retracements[i],": ",DoubleToString(sorcery.get_point(std_period,ret_index),3)),14,NULL,text_color);
               pixel_offset += 17;
               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               //  End Painting block
               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                //------> Break for partial pattern draw
                if(retracements[i]=="BC/AB" && partial == True) break;
                //------> Break for partial pattern draw
                
               };
            
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            // Draw the ZigZag Lines
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            string zig_zag_lines[4] = {"XA","AB","BC","CD"};
            for(int zz = 0,pp = 0; pp < 8 && zz < ArraySize(zig_zag_lines); zz++,pp+=2){
                  if(zig_zag_lines[zz] == "XA"){
                  first_time  = x_time; first_point  = x;
                  second_time = a_time; second_point = a;
               }else if(zig_zag_lines[zz] == "AB"){
                  first_time  = a_time; first_point  = a;
                  second_time = b_time; second_point = b;
               }else if(zig_zag_lines[zz] == "BC"){
                  first_time  = b_time; first_point  = b;
                  second_time = c_time; second_point = c;
               }else if(zig_zag_lines[zz] == "CD"){
                  first_time  = c_time; first_point  = c;
                  second_time = d_time; second_point = d;
               }else{};
               
               if(partial==True && zig_zag_lines[zz] == "XA"){ continue;
               }else{
                  ObjectCreate(0,zig_zag_lines[zz],OBJ_TREND,0,first_time,first_point,second_time,second_point);
                  ObjectSet   (zig_zag_lines[zz], OBJPROP_COLOR, clrWhite);
                  ObjectSet   (zig_zag_lines[zz], OBJPROP_RAY,   False); // turn into segment
                  ObjectSet   (zig_zag_lines[zz], OBJPROP_WIDTH, 3);
               };
             };  
            
            
      };


};

/*

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
*/