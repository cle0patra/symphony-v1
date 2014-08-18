//+------------------------------------------------------------------+
//|                                          Harmonic Definition.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""


#define noType 808
//--------------------- HA_PATTERN

#define AGGRESSIVE 9001
#define CONSERVATIVE 9002

//--------------------- Gartly Patterns

#define Gartley 4001
#define Bat 4002
#define Butterfly 4003
#define Crab 4004
#define Shark 4005
#define ABC 4006
#define Total 4007
#define anABCD 4008
#define BlackSwan 4009
#define WhiteSwan 4010
#define NenStar 4011
#define aDragon 4012
#define Cypher 4013
#define a4PointContinuation 4014
#define a3Drives 4015
#define Navarro 4016
#define a121 4017
#define Leonardo 4018

#define DeepCrab 4019
#define Henry 4020
#define a50 4021
#define Partizan 4022

#define numberOfPatternDefinitions 21

#define PerfectGartley 5001
#define PerfectBat 5002
#define PerfectButterfly 5003
#define PerfectCrab 5004
#define PerfectABCD 5005

//----------------------- Vector Retracement Names
#define PDLA1272_120 600 
#define PDLA1618_120 601
#define PDLA2_120 602
#define PDLA2618_120 603
#define PDLA3618_120 604
#define PDLA4236_120 605
#define PDLC786_120 606
#define PDLC886_120 607
#define PDLC1272_120 608
#define PDLC1618_120 609
#define PDLC2_120 610
#define PDLC2618_120 611
#define PDLC3618_120 612
#define PDLC4236_120 613
#define PDLA1272_135 614
#define PDLA1618_135 615
#define PDLA2_135 616
#define PDLA2618_135 617
#define PDLA3618_135 618
#define PDLA4236_135 619
#define PDLC786_135 620
#define PDLC886_135 621
#define PDLC1272_135 622
#define PDLC1618_135 623
#define PDLC2_135 624
#define PDLC2618_135 625
#define PDLC3618_135 626
#define PDLC4236_135 627

#define vectorDefCount 28
#define defaultVectorRet 318
string vecRetName[vectorDefCount] = {"PDLA1272_120","PDLA1618_120","PDLA2_120","PDLA2618_120","PDLA3618_120","PDLA4618_120","PDLC786_120","PDLC886_120","PDLC1272_120",
                                    "PDLC1618_135","PDLC2_120","PDLC2618_120","PDLC3618_120","PDLC4236_120","PDLA1272_135","PDLA1618_135","PDLA2_135","PDLA2618_135",
                                    "PDLA3618_135","PDLA4618_135","PDLC786_135","PDLC886_135","PDLC1272_135",
                                    "PDLC1618_135","PDLC2_135","PDLC2618_135","PDLC3618_135","PDLC4236_135","default"};
                                    
int vecRetID[vectorDefCount]    = {600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,defaultVectorRet};
/*
"Gartley",    "Bat",    "Shark 2",   "Nen STAR",   "TOTAL 1", // Ãğóïïà 1
"Butterfly",   "Crab",   "Shark 1",   "CYPHER",     "TOTAL 2", // Ãğóïïà 2
"A Butterfly", "A Crab", "A Shark 1", "A CYPHER",   "TOTAL 3", // Ãğóïïà 3
"A Gartley",   "A Bat",  "A Shark 2", "A Nen STAR", "TOTAL 4", // Ãğóïïà 4
"TOTAL+++",                                                       // TOTAL
"max Gartley","max Bat","max Butterfly"}; //120


{"Gartley",       "Bat",         "A alt Shark",        "A Nen STAR",   "Butterfly 113",
"Butterfly",      "Crab",        "A Shark",            "new A Cypher", "LEONARDO",   
"A Butterfly",    "A Crab",      "Shark",              "new Cypher",
"A Gartley",      "A Bat",       "alt Shark",          "Nen STAR",
"alt Bat",        "Deep Crab",   "Black swan",          "121",
"max Bat",        "max Gartley", "max Butterfly",       "A 121",
"WHITE SWAN",     "Navarro 200", "3 drives",            "A 3 drives",
"TOTAL 1",        "TOTAL 2",     "TOTAL 3", "TOTAL 4", "TOTAL ***"}; //135

*/
//-------------------- General Sentiments


#define bullishBias 101
#define bullish 101
#define bull 101
#define buy 101
#define bearishBias 102
#define bearish 102
#define bear 102
#define sell 102
#define volatile 103


string patternNames[numberOfPatternDefinitions] = {"Gartley","Bat","Butterfly","Crab","Shark","A-B-C","TOTAL","AB=CD","Black swan",
                                                   "WHITE SWAN","Nen STAR","Dragon","CYPHER","4-Point Continuation","3 drives","Navarro",
                                                   "121","LEONARDO","Deep Crab","Henry","5-0","Partizan"};
int patternID[numberOfPatternDefinitions] ={4001,4002,4003,4004,4005,4006,4007,4008,4009,4010,4011,4012,4013,4014,4015,4016,4017,4018,4019,4020,4021,4022};                                                  

int getPattern(string pattern){
   if(pattern=="PerfectCrab") return(PerfectCrab);
   else if(pattern=="PerfectButterfly") return(PerfectButterfly);
   else if(pattern=="PerfectBat") return(PerfectBat);
   else if(pattern=="PerfectGartley") return(PerfectGartley);
   else if(pattern=="DeepCrab") return(DeepCrab);
   else if(pattern=="PerfectABCD") return(PerfectABCD);
   
   string bias, harmonicPattern;
   string harmonicPatternInfo = pattern;
   int infoLength;
   infoLength = StringLen(pattern);
   if(infoLength>7) bias = StringSubstr(pattern,0,7);
   for(int i = 0; i<ArraySize(patternNames);i++){
      if(StringFind(pattern,patternNames[i],0)>-1) return(patternID[i]);
   }
   return(-1);  
}

string patternToString(double patternId){
   switch(patternId){
      case 5001: return("Perfect Gartley");
      case 5002: return("Perfect Bat");
      case 5003: return("Perfect Butterfly");
      case 5004: return("Perfect Crab");
      case 5005: return("Perfect AB=CD");
      case 4019: return("Deep Crab");
   }
   for(int i=0;i<ArraySize(patternID);i++){
      if(patternId==patternID[i]) return(patternNames[i]);
   }
   return(EMPTY_VALUE);
}

bool isPatternPerfect(int patternID){
   if(StringSubstr(DoubleToStr(patternID,0),0,1) == "5") return(true);
      else return(false);
}

int getVecRetID(string retID){
   if(retID == "default") return(defaultVectorRet);
   for(int i = 0; i<ArraySize(vecRetID);i++)
      if(retID == vecRetName[i]) return(vecRetID[i]);
   return(-1);
}
string vecRetToString(int retID){
   if(retID == defaultVectorRet) return("Default");
   for(int i = 0; i<ArraySize(vecRetID);i++)
      if(retID == vecRetID[i]) return(vecRetName[i]);
   return(-1);
}