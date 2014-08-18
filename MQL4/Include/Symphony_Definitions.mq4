//+------------------------------------------------------------------+
//|                                         Symphony_Definitions.mqh |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+

//-----------------------------------
//  Definition Schema:
//   > Holds reference indices for variours parameters
//       1) Points X,A,B,C,D
//       2) Legs XA,AB,BC,CD --> Length
//       3) ZigZag start and end
//   > Defaults:
//      -> {808,0,1,2,3,4,5,6,7,8,9,10,11,12,0,1,2,3,4,5,6}
//----------------------------------------

void OnTrade(){

}
struct data_definitions
{     
      int noType, PRZ_HIGH, PRZ_LOW, POINT_X,POINT_A,POINT_B,POINT_C,
                  POINT_D,XA_LEG,AB_LEG,BC_LEG,CD_LEG,
                  ZigZagZug,ZigZagZug_Start;
      //---> Constructor
      data_definitions() {noType=808;PRZ_HIGH=0;PRZ_LOW=1;POINT_X=2;POINT_A=3;POINT_B=4;
                     POINT_C=5;POINT_D=6;XA_LEG=7;AB_LEG=8;BC_LEG=9;CD_LEG=10;
                     ZigZagZug=11;ZigZagZug_Start=12;}
};

enum zzz_indicies{
      // Points => For zzz_points dimension
      point_x = 0,
      point_a = 1,
      point_b = 2,
      point_c = 3,
      point_d = 4,
      // retracement ratios => For zzz_retracements dimension
      ab_xa      = 0,
      ad_xa      = 1, //-> Point D retracement of the XA wave
      bc_ab      = 2,
      cd_ab      = 3,
      cd_bc      = 4,
      zzz_index_length = 5,
      
      //=> Legs
      xa = 0,
      ab = 1,
      bc = 2,
      cd = 3, 
      
      zzz_number_of_points = 0,
      zzz_retracements     = 1,
      zzz_legs             = 4,
      sorcery_index_length = 2
   };
//----------------------------------
// PERIOD_SCHEMA:
//   > Indicies for periods in array of harmonic
//     patterns in array
//-------------------------------------
enum periods
{
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


//---------------------------------------
//  SymphonyDefinitions:
//   > Class for easing the data retrieval by translating
//     calls for data using standard period format (PERIOD_X)
//     with custom period schema
//-----------------------------------------

class SymphonyDefinitions
{
   public:
      static periods;
      static data_definitions;
      //---------------------------
      // Functions
      //------------------------------
      static int get_period(int std_period){
         if      (std_period==PERIOD_M1)   return(periodM1);
         else if (std_period==PERIOD_M5)   return(periodM5);
         else if (std_period==PERIOD_M15)  return(periodM15);
         else if (std_period==PERIOD_M30)  return(periodM30);
         else if (std_period==PERIOD_H1)   return(periodH1);
         else if (std_period==PERIOD_H4)   return(periodH4);
         else if (std_period==PERIOD_D1)   return(periodD1);
         else {
            Print("[ - ][ I ] Unable to grab standard period. Input: ",string(std_period)); 
            return(-1);
         };
      };
      static int get_standard_period(int index){
         if      (index==periodM1)   return(PERIOD_M1);
         else if (index==periodM5)   return(PERIOD_M5);
         else if (index==periodM15)  return(PERIOD_M15);
         else if (index==periodM30)  return(PERIOD_M30);
         else if (index==periodH1)   return(PERIOD_H1);
         else if (index==periodH4)   return(PERIOD_H4);
         else if (index==periodD1)   return(PERIOD_D1);
         else {
            Print("[ - ][ I ] Unable to grab standard period. Input: ",string(index)); 
            return(-1);
         };
      };
      static string get_period_as_string(int index){
         if      (index==periodM1)   return("PER_M1");
         else if (index==periodM5)   return("PER_M5");
         else if (index==periodM15)  return("PER_M15");
         else if (index==periodM30)  return("PER_M30");
         else if (index==periodH1)   return("PER_H1");
         else if (index==periodH4)   return("PER_H4");
         else if (index==periodD1)   return("PER_D1");
         else {
         
            Print("[ - ][ I ] Unable to grab standard period. Input: ",string(index)); 
            return(-1);
         };
      };
      static string get_standard_period_as_string(int index){
         if      (index==PERIOD_M1)   return("PER_M1");
         else if (index==PERIOD_M5)   return("PER_M5");
         else if (index==PERIOD_M15)  return("PER_M15");
         else if (index==PERIOD_M30)  return("PER_M30");
         else if (index==PERIOD_H1)   return("PER_H1");
         else if (index==PERIOD_H4)   return("PER_H4");
         else if (index==PERIOD_D1)   return("PER_D1");
         else {
            Print("[ - ][ I ] Unable to grab standard period. Input: ",string(index)); 
            return(-1);
         };
      };
      //----> Return integer representation of ID
      static int get(string id){
         if(id=="PRZ_HIGH") return(data_definitions::PRZ_HIGH);
         if(id=="PRZ_LOW") return(data_definitions::PRZ_LOW);
         if(id=="POINT_X") return(data_definitions::POINT_X);
         if(id=="POINT_A") return(data_definitions::POINT_A);
         if(id=="POINT_B") return(data_definitions::POINT_B);
         if(id=="POINT_C") return(data_definitions::POINT_C);
         if(id=="POINT_D") return(data_definitions::POINT_D);
         if(id=="XA_LEG")  return(data_definitions::XA_LEG);
         if(id=="AB_LEG")  return(data_definitions::AB_LEG);
         if(id=="BC_LEG")  return(data_definitions::BC_LEG);
         if(id=="CD_LEG")  return(data_definitions::CD_LEG);
         if(id=="ZigZagZug") return(data_definitions::ZigZagZug);
         if(id=="ZigZagZug_Start") return(data_definitions::ZigZagZug_Start);
         else return(-1);
      };

};


class SymphonyStrings
{
   
   periods schema;
   public:
      string period_to_string(int period){
            switch(period){
                  case schema.periodM1:  return("PERIOD_M1");
                  case schema.periodM5:  return("PERIOD_M5");
                  case schema.periodM15: return("PERIOD_M15");
                  case schema.periodM30: return("PERIOD_M30");
                  case schema.periodH1:  return("PERIOD_H1");
                  case schema.periodH4:  return("PERIOD_H4");
                  case schema.periodD1:  return("PERIOD_D1");
                  default:{ string info;
                           info = StringConcatenate(info,"[ Symphony | Strings ] PERIOD UNDEFINED. periodToString() [",period,"] Error: ",GetLastError());
                           return(info);
                           };
                  }
         };
         string standard_period_to_string(int period){
            switch(period){
                  case PERIOD_M1: return("PERIOD_M1");
                  case PERIOD_M5: return("PERIOD_M5");
                  case PERIOD_M15: return("PERIOD_M15");
                  case PERIOD_M30: return("PERIOD_M30");
                  case PERIOD_H1: return("PERIOD_H1");
                  case PERIOD_H4: return("PERIOD_H4");
                  case PERIOD_D1: return("PERIOD_D1");
                  default: {string info;
                           info = StringConcatenate(info,"[ Symphony | Strings ] PERIOD UNDEFINED. stdPeriodToString() [",period,"] Error: ",GetLastError());
                           return(info);};
            }
                  
         };
         string type_to_string(int t){
            if(t==ORDER_TYPE_BUY) return("ORDER_TYPE_BUY");
            else if(t==ORDER_TYPE_BUY) return("ORDER_TYPE_SELL");
            else if(t==-1) return("Error_Type");
            else return("No Type");
         };
};