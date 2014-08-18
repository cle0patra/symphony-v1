//+------------------------------------------------------------------+
//|                                         Symphony_Definitions.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""

#define noType 808
//--------------------- HA_PATTERN

#define AGGRESSIVE 9001
#define CONSERVATIVE 9002

//---------------------- For Symphony_Variables

#define PRZ_HIGH 0
#define PRZ_LOW 1
#define POINT_X 2
#define POINT_A 3
#define POINT_B 4
#define POINT_C 5
#define POINT_D 6
#define XA_LEG 7
#define AB_LEG 8
#define BC_LEG 9
#define CD_LEG 10
#define ZigZagZug 11
#define ZigZagZug_Start 12  

//---------------- period schema
#define periodM1 0 
#define periodM5 1
#define periodM15 2
#define periodM30 3
#define periodH1 4
#define periodH4 5
#define periodD1 6
 
//--------------------------------
//   For pair policy
//   1) Majors:
//      -> EURUSD, USDJPY, GPDUSD, USDCHF
//---------------------------------

string majors[] = {"EURUSD","USDJPY","GPDUSD","USDCHF"};
//---------------------------------------
//     For Symphony_Variables
//-----------------------------------------

int globalIndex[] = {PRZ_HIGH, PRZ_LOW,POINT_X, POINT_A,POINT_B, POINT_C, POINT_D,
                       XA_LEG, AB_LEG, BC_LEG, CD_LEG, ZigZagZug,ZigZagZug_Start};

                
int def.get(string id){
   if(id=="PRZ_HIGH") return(PRZ_HIGH);
   if(id=="PRZ_LOW") return(PRZ_LOW);
   if(id=="POINT_X") return(POINT_X);
   if(id=="POINT_A") return(POINT_A);
   if(id=="POINT_B") return(POINT_B);
   if(id=="POINT_C") return(POINT_C);
   if(id=="POINT_D") return(POINT_D);
   if(id=="XA_LEG") return(XA_LEG);
   if(id=="AB_LEG") return(AB_LEG);
   if(id=="BC_LEG") return(BC_LEG);
   if(id=="CD_LEG") return(CD_LEG);
   if(id=="ZigZagZug") return(ZigZagZug);
   if(id=="ZigZagZug_Start") return(ZigZagZug_Start);
}

int def.getStdPeriod(int index){
   switch(index){
      case periodM1: return(PERIOD_M1);
      case periodM5: return(PERIOD_M5);
      case periodM15: return(PERIOD_M15);
      case periodM30: return(PERIOD_M30);
      case periodH1: return(PERIOD_H1);
      case periodH4: return(PERIOD_H4);
      case periodD1: return(PERIOD_D1);
      default: Print("[ - ][ I ] Unable to grab standard period. Input: ",index); return(-1);
   }
}

class SymphonyDefinitions:
{
   public:
      int PRZ_HIGH = 0;
      int PRZ_LOW = 1;
      int POINT_X = 2;
      int POINT_A = 3;
      int POINT_B = 4;
      int POINT_C = 5;
      int POINT_D = 6;
      int XA_LEG = 7;
      int AB_LEG = 8;
      int BC_LEG = 9;
      int CD_LEG = 10;
      int ZigZagZug = 11;
      int ZigZagZug_Start = 12;  
      //---------------- period schema
      int periodM1 = 0;
      int periodM5 = 1;
      int periodM15 = 2;
      int periodM30 = 3;
      int periodH1 = 4;
      int periodH4 = 5;
      int periodD1 = 6;
      //---------------------------
      // Functions
      //------------------------------
      int getStdPeriod(int index){
         switch(index){
            case periodM1: return(PERIOD_M1);
            case periodM5: return(PERIOD_M5);
            case periodM15: return(PERIOD_M15);
            case periodM30: return(PERIOD_M30);
            case periodH1: return(PERIOD_H1);
            case periodH4: return(PERIOD_H4);
            case periodD1: return(PERIOD_D1);
            default: Print("[ - ][ I ] Unable to grab standard period. Input: ",index); return(-1);
         }
      };
      //----> Return integer representation of ID
      int get(string id){
         if(id=="PRZ_HIGH") return(PRZ_HIGH);
         if(id=="PRZ_LOW") return(PRZ_LOW);
         if(id=="POINT_X") return(POINT_X);
         if(id=="POINT_A") return(POINT_A);
         if(id=="POINT_B") return(POINT_B);
         if(id=="POINT_C") return(POINT_C);
         if(id=="POINT_D") return(POINT_D);
         if(id=="XA_LEG") return(XA_LEG);
         if(id=="AB_LEG") return(AB_LEG);
         if(id=="BC_LEG") return(BC_LEG);
         if(id=="CD_LEG") return(CD_LEG);
         if(id=="ZigZagZug") return(ZigZagZug);
         if(id=="ZigZagZug_Start") return(ZigZagZug_Start);
      };

}