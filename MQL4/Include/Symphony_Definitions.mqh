//+------------------------------------------------------------------+
//|                                         Symphony_Definitions.mqh |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+

//###################################
//
// Symphony_Definitions:
//    > This library is meant to be standalone.
//
//###################################
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// Pattern Schema:
//   > For tracking patterns in SymphonySorcery
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

enum pattern_schema{
   gartley   = 0,
   butterfly = 1,
   crab      = 2,
   bat       = 3,
   full_pattern_end_index = 3,
   partial_gartley   = 4,
   partial_butterfly = 5,
   partial_crab      = 6,
   partial_bat       = 7,
   partial_pattern_end_index = 7,
   
   pattern_index_length = 8

};
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//  ZZZ Schema:
//    > For tracking data points in SymphonySorcery.zzz_points array
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

enum zzz_schema{
      // Points => For zzz_points dimension
      point_x = 0,
      point_a = 1,
      point_b = 2,
      point_c = 3,
      point_d = 4,
      // retracement ratios => For zzz_retracements dimension
      ab_xa      = 0,
      bc_ab      = 1,
      cd_bc      = 2,
      ad_xa      = 3, //-> Point D retracement of the XA wave
      cd_ab      = 4, //--> Unnecessary for patterns, but perhaps for fibonacci
      zzz_index_length = 5,
      
      //=> Legs
      xa = 0,
      ab = 1,
      bc = 2,
      cd = 3, 
      
      zzz_retracements_index = 1,
      zzz_points_index       = 0,
      zzz_number_of_legs     = 4,
      sorcery_index_length = 2
   };
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// PERIOD_SCHEMA:
//   > Indicies for periods in array of harmonic
//     patterns in array
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum period_schema{
      periodM1  = 0,
      periodM5  = 1,
      periodM15 = 2,
      periodM30 = 3,
      periodH1  = 4,
      periodH4  = 5,
      periodD1  = 6,
      periodIndexLength = 7
};
//string majors[] = {"EURUSD","USDJPY","GPDUSD","USDCHF"};

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//  Fibonacci Schema:
//    > For Fibonacci retracement value indexing
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum fibonacci_schema{
     //-- Retracement type
     internal_ret      = 0,
     external_ret      = 1,
     price_expansion   = 2,
     price_projection  = 3,
     //demark_projection = 4,
     //---> First column in method row
     //     leg, ret_val_1, ret_val_2, etc...
     leg_index       = 0,
     
     fibonacci_schema_length = 4,
     fibonacci_retracement_points = 15
};

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//  Demark Schema:
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

enum demark_schema{
   //--------> TD_Magnet_Price index
   td_magnet_price = 777
};

//--------------------------
// Arrays:
//   > For cleanliness and lookup simplification
//--------------------------
int period_schema_indexes[7]      = {periodM1, periodM5, periodM15, periodM30, periodH1, periodH4, periodD1};
int standard_periods[7]           = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
string pattern_strings[4]         = {"Gartley","Bat","Butterfly","Crab"};
string partial_pattern_strings[4] = {"PartialGartley","PartialBat","PartialButterfly","PartialCrab"};
string all_pattern_strings[8]     = {"Gartley","Bat","Butterfly","Crab","PartialGartley","PartialBat","PartialButterfly","PartialCrab"};
int pattern_indexes[4]            = {gartley,bat,butterfly,crab};
int partial_pattern_indexes[4]    = {partial_gartley,partial_bat,partial_butterfly,partial_crab};
int all_pattern_indexes[8]        = {gartley,bat,butterfly,crab,partial_gartley,partial_bat,partial_butterfly,partial_crab};
int order_types[6]                = {ORDER_TYPE_BUY,ORDER_TYPE_SELL,ORDER_TYPE_BUY_LIMIT,ORDER_TYPE_BUY_STOP,ORDER_TYPE_SELL_LIMIT,ORDER_TYPE_SELL_STOP};
string order_types_strings[6]     = {"BUY","SELL","BUY_LIMIT","BUY_STOP","SELL_LIMIT","SELL_STOP"};
string standard_period_strings[7] = {"PER_M1", "PER_M5", "PER_M15", "PER_M30", "PER_H1", "PER_H4", "PER_D1"};
string point_strings[9]           = {"point_x","point_a","point_b","point_c","point_d","xa","ab","bc","cd"};
int point_values[9]               = {point_x,point_a,point_b,point_c,point_d,xa,ab,bc,cd};
string retracement_strings[5]     = {"AB/XA","BC/AB","CD/AB","AD/XA","CD/BC"};
int retracement_indexes[5]        = {ab_xa,bc_ab,cd_ab,ad_xa,cd_bc};
int fibonacci_indexes[4]          = {internal_ret,external_ret,price_expansion,price_projection};
string fibonacci_method_strings[4]= {"InternalRetracement","ExternalRetracement","PriceExpansion","PriceProjection"};
     
//---------------------------------------
//  SymphonyDefinitions:
//   > Class for easing the data retrieval by translating
//     calls for data using standard period format (PERIOD_X)
//     with custom period schema
//-----------------------------------------         
class SymphonyDefinitions
{
   
   public:
      //---------------------------
      // get_period_index:
      //    @param std_period: PERIOD_X format
      //    @return: The proper period index for data calls
      //------------------------------
      static int get_period_index(int std_period)    { return(match_for_int(std_period,standard_periods,period_schema_indexes,"GetPeriodIndex"));};
      //---------------------------
      // get_standard_period:
      //    @param schema_index: period_schema.periodX format
      //    @return: The matching PERIOD_X constant representation
      //------------------------------
      static int get_standard_period(int schema_index){ return(match_for_int(schema_index,period_schema_indexes,standard_periods,"GetStandardPeriod"));};
      //---------------------------
      // period_index_to_string:
      //    @param schema_index: period_schema.periodX format
      //    @return: The matching PER_X string representation
      //------------------------------
      static string period_index_to_string(int schema_index){return(match_for_string(schema_index,period_schema_indexes,standard_period_strings,"GetPeriodIndexAsString"));};
      //---------------------------
      // point_leg_index_to_string:
      //    @param point_or_leg_schema_id: period_schema.periodX format
      //    @return: The matching PER_X string representation
      //------------------------------
      static int point_leg_index_to_string(string point_or_leg_schema_id){return(match_for_string(point_or_leg_schema_id,point_values,point_strings,"GetPointLegIndexString"));};
      //---------------------------
      // retracement_index_to_string:
      //    @param ret_index: zzz_schema.ret_id
      //    @return: The matching PER_X string representation
      //------------------------------
      static string retracement_index_to_string(int ret_index){ return(match_for_string(ret_index,retracement_indexes,retracement_strings,"GetRetracementIndexAsString"));};  
     //--------------------------
     // pattern_index_to_string:
     //    @param pattern_index: pattern_schema.pattern
     //    @return: String representation of pattern
     //---------------------------------
     static string pattern_index_to_string(int pattern_index){ return(match_for_string(pattern_index,all_pattern_indexes,all_pattern_strings,"GetPatternIndexAsString"));};
     //--------------------------
     // fibonacci_index_to_string:
     //    @param pattern_index: pattern_schema.pattern
     //    @return: String representation of pattern
     //---------------------------------
     static string fibonacci_index_to_string(int method_index){ return(match_for_string(method_index,fibonacci_indexes,fibonacci_method_strings,"GetPatternIndexAsString"));};
     //--------------------------
     // partial_pattern_index_to_string:
     //    @param pattern_index: pattern_schema.pattern
     //    @return: String representation of pattern
     //---------------------------------
     static string partial_pattern_index_to_string(int pattern_index){ return(match_for_string(pattern_index,partial_pattern_indexes,partial_pattern_strings,"GetPatternIndexAsString"));};
     //--------------------------
     // standard_period_to_string:
     //    @param std_period: PERIOD_X
     //    @return: String representation of period
     //---------------------------------
     static string standard_period_to_string(int std_period){ return(match_for_string(std_period,standard_periods,standard_period_strings,"StandardPeriodToString"));};
     //--------------------------
     // type_to_string:
     //    @param order_type: ORDER_TYPE_X
     //    @return: String representation of order type
     //---------------------------------
     static string type_to_string(int order_type){ return(match_for_string(order_type,order_types,order_types_strings,"TypeToString"));};
     //------------------------------------
     // bool_to_string:
     //    @param val: True or False
     //    @return: True -> Yes, False -> No
     //------------------------------------------
     static string bool_to_string(bool val){ if(val==True) return("Yes"); else return("No");};
    private:
      //--------------------------------
      //  match_for_int, match_for_string, match_string:
      //    @note: Helper functions for lookups.
      //           match_for_int => (int[],int[]), match_for_string => (int[],string[]), match_string (string[],int[])
      //    @param match_parameter: Parameter to match in lookup array
      //    @param lookup_array: Array to look for value. Should be one of those defined in class
      //    @param value_array: Array holding values to return for matches
      //    @param function_name: Name of the function calling the match method. For tracebacks.
      //    @return: Matched value in value_array[], or -1. If -1, print information
      //             
      //----------------------------------------------------
      static int match_for_int(int match_parameter, const int & lookup_array[],const int & value_array[],string function_name){
         for(int i = 0; i < ArraySize(lookup_array); i++) if(match_parameter == lookup_array[i]) return(value_array[i]); 
         return(print_err_pass(match_parameter,function_name));
      }; 
      static string match_for_string(int match_parameter, const int & lookup_array[],const string & value_array[], string function_name){
         for(int i = 0; i < ArraySize(lookup_array); i++) if(match_parameter == lookup_array[i]) return(value_array[i]); 
         return(print_err_pass(match_parameter,function_name));
      };
      static string match_string(string match_parameter, const string & lookup_array[],const int & value_array[], string function_name){
         for(int i = 0; i < ArraySize(lookup_array); i++) if(match_parameter == lookup_array[i]) return(value_array[i]); 
         return(print_err_pass_string(match_parameter,function_name));
      };
     
      
          
};
