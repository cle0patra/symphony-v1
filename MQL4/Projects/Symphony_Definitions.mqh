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
      periods period;
      data_definitions define;
      //---------------------------
      // Functions
      //------------------------------
      int getStdPeriod(int index){
         if(index==period.periodM1) return(PERIOD_M1);
         else if(index==period.periodM5) return(PERIOD_M5);
         else if(index==period.periodM15) return(PERIOD_M15);
         else if(index==period.periodM30) return(PERIOD_M30);
         else if(index==period.periodH1) return(PERIOD_H1);
         else if(index==period.periodH4) return(PERIOD_H4);
         else if(index==period.periodD1) return(PERIOD_D1);
         else {
            Print("[ - ][ I ] Unable to grab standard period. Input: ",index); 
            return(-1);
         };
      };
      //----> Return integer representation of ID
      int get(string id){
         if(id=="PRZ_HIGH") return(define.PRZ_HIGH);
         if(id=="PRZ_LOW") return(define.PRZ_LOW);
         if(id=="POINT_X") return(define.POINT_X);
         if(id=="POINT_A") return(define.POINT_A);
         if(id=="POINT_B") return(define.POINT_B);
         if(id=="POINT_C") return(define.POINT_C);
         if(id=="POINT_D") return(define.POINT_D);
         if(id=="XA_LEG") return(define.XA_LEG);
         if(id=="AB_LEG") return(define.AB_LEG);
         if(id=="BC_LEG") return(define.BC_LEG);
         if(id=="CD_LEG") return(define.CD_LEG);
         if(id=="ZigZagZug") return(define.ZigZagZug);
         if(id=="ZigZagZug_Start") return(define.ZigZagZug_Start);
         else return(-1);
      };

};