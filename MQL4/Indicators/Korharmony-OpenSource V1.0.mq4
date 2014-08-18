#property copyright "Original & Final Release of Korharmony - Poland, Europe -  OpenSource Version 1.0"
#property link      "N/A"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Black
#property indicator_color2 Black
#property indicator_color3 Black

#import "user32.dll"
   int GetWindowDC(int a0);
   int ReleaseDC(int a0, int a1);
   bool GetWindowRect(int a0, int& a1[]);
   int GetClientRect(int a0, int& a1[]);
#import "gdi32.dll"
   int GetPixel(int a0, int a1, int a2);
#import

string gsa_76[50000][2];
string gsa_80[50000][2];
string gsa_84[50000][2];
string gsa_unused_88[50000][2];
double g_ibuf_92[];
double g_ibuf_96[];
double g_ibuf_100[];
int g_index_104;
int g_index_108;
int g_index_112;
int gi_unused_120 = 0;
double gd_124 = 0.0;
double gd_132 = 0.0;
double gd_140 = 0.0;
double gd_148 = 0.0;
int gi_unused_156 = 50;
string gsa_160[30] = {"ABCD", "I ABCD", "I+T ABCD", "Gartley", "Butterfly", "Crab", "Bat", "SHS", "3Drives", "5-0", "One2One", "E One2One", "S One2One", "Triangle", "Diagonal", "Fibo382", "Fibo500", "Fibo618", "Fibo786", "Fibo886"};
int gia_164[30];
extern string separator1 = "************************ Main Params ***";
extern int iextRefreshRate = 4;
extern int iextMaxBars = 5000;
extern int iextHL_MinSwing = 0;
int gi_188 = 5;
int gi_192 = 150;
extern int iextMaxZZPointsUsed = 13;
extern bool bextShowHistoryPatterns = FALSE;
extern bool bextCheckMultiZigzags = TRUE;
extern double dextHL_MultiZZMinSwingRange = 0.5;
extern int iextHL_MultiZZMinSwingNum = 12;
extern string separator2 = "************************ Calculation deltas ***";
extern double dextMaxDeviation = 0.1;
extern double dextFiboDeviation = 0.5;
extern double dextMaxSHSPriceDeviation = 0.3;
extern double dextMaxSHSTimeDeviation = 0.3;
extern double dextMaxCorrDeviation = 0.1;
extern double dextMaxOne2OneDeviation = 0.1;
extern double dextMaxTriangleDeviation = 0.05;
extern string separator3 = "************************ What to draw ***";
extern bool bextDrawZZLine = TRUE;
extern bool bextDrawZZRelations = FALSE;
extern bool bextDrawZZPoints = TRUE;
extern bool bextDrawProjectionLines = TRUE;
extern bool bextDrawRelationLines = FALSE;
extern bool bextDrawPatternDim = TRUE;
extern bool bextDrawDetailedPatternDim = TRUE;
extern bool bextDrawPatternDescr = TRUE;
extern bool bextDrawRectangle = FALSE;
extern bool bextDrawPRZ = TRUE;
extern int iextDescrFontSize = 14;
extern string separator4 = "******************** Patterns ON/OFF ***";
extern bool bextFibo = TRUE;
extern bool bextFibo382 = TRUE;
extern bool bextFibo500 = TRUE;
extern bool bextFibo618 = TRUE;
extern bool bextFibo786 = TRUE;
extern bool bextFibo886 = TRUE;
extern string FiboLevelsStr = "0.236; 0.382; 0.500; 0.618; 0.707; 0.786; 0.862; 0.886; 1.00; 1.127; 1.382; 1.414; 1.618; 2.236; 2.618; 3.142; 3.618; 4.236; 5.00;";
double gda_376[30];
int gi_380;
extern string FiboExtRetLevelsStr = "1.13; 1.272; 1.500; 1.618; 1.912; 2.000; 2.058; 2.236; 2.618; 3.618; 4.236; ";
double gda_392[30];
int gi_396;
extern string FiboIntRetLevelsStr = "0.146; 0.186; 0.236; 0.300; 0.382; 0.447; 0.486; 0.500; 0.564; 0.618; 0.685; 0.786; 0.886; 1.00; ";
double gda_408[30];
int gi_412;
extern string FiboProjLevelsStr = "0.236; 0.382; 0.500; 0.618; 0.786; 1.000; 1.272; 1.500; 1.618; 2.00; 2.236; 2.618; 4.236; ";
double gda_424[30];
int gi_428;
extern string FiboAPPProjLevelsStr = "0.500; 0.618; 0.685; 0.786; 0.886; 1.000; 1.130; 1.272; 1.500; 1.618; 2.00; 2.236; 2.618; 3.618; 4.236; ";
double gda_440[30];
int gi_444;
extern bool bextABCD = TRUE;
extern bool bextI_ABCD = TRUE;
extern bool bextIT_ABCD = TRUE;
extern bool bextWXY = FALSE;
extern bool bextGartley = TRUE;
extern bool bextIdealGartleyOnly = FALSE;
extern bool bextButterfly = TRUE;
extern bool bextIdealButterflyOnly = FALSE;
extern bool bextCrab = TRUE;
extern bool bextIdealCrabOnly = FALSE;
extern bool bextBat = TRUE;
extern bool bextIdealBatOnly = FALSE;
extern bool bextBatman = TRUE;
extern bool bextSHS = FALSE;
extern bool bextI_SHS = TRUE;
extern bool bext3Drives = TRUE;
extern bool bext5_0 = TRUE;
extern bool bextEmergingPatterns =TRUE;
extern double dextEmergingPatternPerc = 0.7;
bool gi_528 = FALSE;
extern bool bextOne2One = TRUE;
extern bool bextEOne2One = TRUE;
extern bool bextSOne2One = TRUE;
extern bool bextOne2OneFibo = FALSE;
bool gi_548 = FALSE;
bool gi_552 = FALSE;
bool gi_556 = FALSE;
bool gi_560 = FALSE;
bool gi_564 = FALSE;
double gd_568 = 100.0;
double gd_576 = 0.5;
double gd_584 = 100.0;
double gd_592 = 0.5;
double gda_600[8];
double gda_604[8];
int gi_608 = 255;
int gi_612 = 16711680;
int gi_616 = 65535;
int gi_620 = 16777215;
extern string separator5 = "*********************** Alerts ON/OFF ***";
extern bool bextMT4AlertON = FALSE;
extern bool bextMT4EmailON = FALSE;
extern bool bextAlertInvalidatedPatterns = FALSE;
extern string separator6 = "***************** Sound Alarms ON/OFF ***";
extern bool bextSoundAlertON = FALSE;
extern string sextInfoPatternSoundFile = "news.wav";
extern string separator7 = "***************** Save as GIF ON/OFF ***";
extern bool bextScreenshotPatternsON = FALSE;
extern string sextSaveImageDestinationDir = "korHarmonics/";
extern string separator8 = "***************** Signal Monitoring ON/OFF ***";
extern bool bextSigMonitonitoringON = FALSE;
extern string sextSigMonitoringDir = "korSigMon/";
extern string separator8a = "***************** Signal Web Monitoring ON/OFF ***";
extern bool bextSigWebMonitonitoringON = FALSE;
extern string sextSigWebMonitoringDir = "korSigWebMon/";
extern string separator9 = "************************ Patterns colors ***";
extern color cextFiboDescColor = Blue;
extern color cextABCDBullishColor = Blue;
extern color cextABCDBearishColor = DeepPink;
extern color cextABCDDescColor = Blue;
extern color cextWXYColor = Pink;
extern color cextGartleyBullishColor = SeaGreen;
extern color cextGartleyBearishColor = C'0xDD,0x00,0x2D';
extern color cextGartleyDescColor = Blue;
extern color cextButterflyBullishColor = Green;
extern color cextButterflyBearishColor = Red;
extern color cextButterflyDescColor = Blue;
extern color cextCrabBullishColor = GreenYellow;
extern color cextCrabBearishColor = C'0xEC,0x51,0x78';
extern color cextCrabDescColor = Blue;
extern color cextBatBullishColor = DarkGreen;
extern color cextBatBearishColor = C'0x80,0x00,0x0A';
extern color cextBatDescColor = Blue;
extern color cextBatmanBullishColor = White;
extern color cextBatmanBearishColor = White;
extern color cextBatmanDescColor = Blue;
extern color cextSHSBullishColor = Pink;
extern color cextSHSBearishColor = Pink;
extern color cextSHSDescColor = Red;
extern color cext3Drives1BullishColor = C'0x00,0x00,0x64';
extern color cext3Drives2BullishColor = C'0x2F,0x00,0x51';
extern color cext3Drives1BearishColor = C'0x7D,0x00,0x00';
extern color cext3Drives2BearishColor = C'0x48,0x00,0x00';
extern color cext3DrivesDescColor = Red;
extern color cext5_0BullishColor = MediumSpringGreen;
extern color cext5_0BearishColor = Red;
extern color cext5_0DescColor = Red;
extern color cextCorrBullishColor = LimeGreen;
extern color cextCorrBearishColor = Salmon;
extern color cextCorrDescColor = Red;
extern color cextTriangleBullishColor = DimGray;
extern color cextTriangleBearishColor = Tomato;
extern color cextITriangleBullishColor = DarkSlateBlue;
extern color cextITriangleBearishColor = Crimson;
extern color cextNITriangleBullishColor = Blue;
extern color cextNITriangleBearishColor = Red;
extern color cextTriangleDescColor = White;
extern color cextDiagonalColor = White;
extern color cextDiagonalDescColor = White;
extern color cextEmergingBullishColor = Yellow;
extern color cextEmergingBearishColor = DarkOrange;
extern color cextOne2OneBullishColor = Salmon;
extern color cextOne2OneCorrBullishColor = Red;
extern color cextOne2OneBearishColor = Salmon;
extern color cextOne2OneCorrBearishColor = Red;
extern color cextSOne2OneCorrBullishColor = Brown;
extern color cextSOne2OneCorrBearishColor = Brown;
int gi_936 = 16776960;
int gi_940 = 3937500;
extern color cextRectangleColor = Orange;
extern color cextPatternDimColor = Yellow;
int gi_952 = 3;
int gi_956 = 3;
int gi_960 = 3;
int gi_964 = 5;
int gi_968 = 1;
int gi_972 = 5;
int gi_976 = 3;
int gi_980 = 1;
int gi_984 = 4;
int gi_988 = 3;
extern string separator10 = "************************ ZZ lines colors ***";
extern color cextZZLineColor = DarkViolet;
extern color cextZZRelLineColor = Indigo;
extern string separator11 = "************************ Other Colors ***";
extern color extBackgroundColor = Black;
extern color extTextColor = White;
extern color cextRelationLine = C'0x15,0x22,0x22';
extern string separator12 = "************************ MinSwing defaults file ***";
extern string sextMinSwingDefaultsFile = "korHarmonics/korHarmonics_MinSwingDefaults.txt";
int gia_unused_1044[100];
int gia_unused_1048[100];
int gia_1052[90];
int gia_1056[90];
string gsa_1060[90][2] = {"No pattern", "No pattern",
   "ABCD Bullish", "ABCDBu",
   "ABCD Bearish", "ABCDBe",
   "I+ABCD Bullish", "IABCDBu",
   "I+ABCD Bearish", "IABCDBe",
   "I+T+ABCD Bullish", "ITABCDBu",
   "I+T+ABCD Bearish", "ITABCDBe",
   "Gartley Bullish", "GaBu",
   "Gartley Bearish", "GaBe",
   "Butterfly Bullish", "BuBu",
   "Butterfly Bearish", "BuBe",
   "Crab Bullish", "CrBu",
   "Crab Bearish", "CrBe",
   "Bat Bullish", "BaBu",
   "Bat Bearish", "BaBe",
   "Emerging Gartley Bullish", "EmGaBu",
   "Emerging Gartley Bearish", "EmGaBe",
   "Emerging Butterfly Bullish", "EmBuBu",
   "Emerging Butterfly Bearish", "EmBuBe",
   "Emerging Crab Bullish", "EmCrBu",
   "Emerging Crab Bearish", "EmCrBe",
   "Emerging Bat Bullish", "EmBaBu",
   "Emerging Bat Bearish", "EmBaBe",
   "3Drives Bullish", "3DBu",
   "3Drives Bearish", "3DBe",
   "5-0 Bullish", "50Bu",
   "5-0 Bearish", "50Be",
   "Batman Bullish", "BnBu",
   "Batman Bearish", "BnBe",
   "SHS Bullish", "SHSBu",
   "SHS Bearish", "SHSBe",
   "I+SHS Bullish", "ISHSBu",
   "I+SHS Bearish", "ISHSBe",
   "One2One Bullish", "O2OBu",
   "One2One Bearish", "O2OBe",
   "Emerging One2One Bullish", "EmO2OBu",
   "Emerging One2One Bearish", "EmO2OBe",
   "EnhOne2One Bullish", "EO2OBu",
   "EnhOne2One Bearish", "EO2OBe",
   "Emerging EnhOne2One Bullish", "EmEO2OBu",
   "Emerging EnhOne2One Bearish", "EmEO2OBe",
   "S One2One Bullish", "SO2OBu",
   "S One2One Bearish", "SO2OBe",
   "Emerging S One2One Bullish", "EmSO2OBu",
   "Emerging S One2One Bearish", "EmSO2OBe",
   "Camel Run Bullish", "CaRuBu",
   "Camel Run Bearish", "CaRuBe",
   "Camel Break Bullish", "CaBrBu",
   "Camel Break Bearish", "CaBrBe",
   "Camel Flat Bullish", "CaFlBu",
   "Camel Flat Bearish", "CaFlBe",
   "Camel Unreg Bullish", "CaUnBu",
   "Camel Unreg Bearish", "CaUnBe",
   "VibrPrice+Time", "ViPT",
   "VibrPrice", "ViP",
   "VibrTime", "ViT",
   "Triangle Bullish", "TrBu",
   "Triangle Bearish", "TrBe",
   "DiaTriangle Bullish", "DiaTrBu",
   "DiaTriangle Bearish", "DiaTrBe",
   "I+Triangle", "ITrBu",
   "I+Triangle", "ITrBe",
   "NI+Triangle", "NITrBu",
   "NI+Triangle", "NITrBe",
   "WXY Bullish", "WXYBu",
   "WXY Bearish", "WXYBe",
   "Fibo Bullish", "FiboBu",
   "Fibo Bearish", "FiboBe",
   "Fibo382 Bullish", "Fibo382Bu",
   "Fibo382 Bearish", "Fibo382Be",
   "Fibo500 Bullish", "Fibo500Bu",
   "Fibo500 Bearish", "Fibo500Be",
   "Fibo618 Bullish", "Fibo618Bu",
   "Fibo618 Bearish", "Fibo618Be",
   "Fibo786 Bullish", "Fibo786Bu",
   "Fibo786 Bearish", "Fibo786Be",
   "Fibo886 Bullish", "Fibo886Bu",
   "Fibo886 Bearish", "Fibo886Be"};
string gsa_1064[300][11];
bool gi_unused_1068 = FALSE;
int g_index_1072;
int g_time_1076 = 0;
int g_datetime_1080 = 0;
int gi_1084;
bool gi_1088 = FALSE;
extern bool bextRelationAngleRotate = FALSE;

int HL_CleanArrays() {
   for (int l_index_0 = 0; l_index_0 <= 50000; l_index_0++) {
      gsa_76[l_index_0][0] = 0;
      gsa_76[l_index_0][1] = 0;
      gsa_80[l_index_0][0] = 0;
      gsa_80[l_index_0][1] = 0;
      gsa_84[l_index_0][0] = 0;
      gsa_84[l_index_0][1] = 0;
   }
   return (0);
}

void HL_Calculate(int ai_0, int ai_4, int ai_unused_8, int ai_12) {
   double l_low_40;
   double l_high_48;
   int li_56 = -1;
   gi_unused_120 = 0;
   g_index_104 = 0;
   g_index_108 = 0;
   g_index_112 = 0;
   int li_60 = ai_0;
   int li_16 = li_60;
   double l_low_24 = Low[li_60];
   int li_20 = li_60;
   double l_high_32 = High[li_60];
   DrawPriceArrow(li_16, Time[li_16], l_low_24, Lime, "Buy");
   DrawPriceArrow(li_20, Time[li_20], l_high_32, Lime, "Sell");
   for (int li_64 = li_60; li_64 >= 0; li_64--) {
      l_low_40 = Low[li_64];
      l_high_48 = High[li_64];
      if (l_high_48 - l_low_24 > ai_12 * Point && li_56 == -1 || li_56 == 1) {
         gsa_80[g_index_104][0] = TimeToStr(Time[li_16], TIME_DATE|TIME_SECONDS);
         gsa_80[g_index_104][1] = DoubleToStr(l_low_24, 4);
         g_index_104++;
         gsa_84[g_index_112][0] = TimeToStr(Time[li_16], TIME_DATE|TIME_SECONDS);
         gsa_84[g_index_112][1] = DoubleToStr(l_low_24, 4);
         g_index_112++;
         l_low_24 = l_low_40;
         li_16 = li_64;
         l_high_32 = l_high_48;
         li_20 = li_64;
         if (li_56 == -1) gi_unused_120 = 1;
         li_56 = 0;
      } else {
         if (l_high_32 - l_low_40 > ai_12 * Point && li_56 == -1 || li_56 == 0) {
            gsa_76[g_index_108][0] = TimeToStr(Time[li_20], TIME_DATE|TIME_SECONDS);
            gsa_76[g_index_108][1] = DoubleToStr(l_high_32, 4);
            g_index_108++;
            gsa_84[g_index_112][0] = TimeToStr(Time[li_20], TIME_DATE|TIME_SECONDS);
            gsa_84[g_index_112][1] = DoubleToStr(l_high_32, 4);
            g_index_112++;
            l_high_32 = l_high_48;
            li_20 = li_64;
            l_low_24 = l_low_40;
            li_16 = li_64;
            if (li_56 == -1) gi_unused_120 = -1;
            li_56 = 1;
         }
      }
      if (l_low_40 < l_low_24) {
         l_low_24 = l_low_40;
         li_16 = li_64;
      }
      if (l_high_48 > l_high_32) {
         l_high_32 = l_high_48;
         li_20 = li_64;
      }
   }
   if (li_56 == 1) {
      gsa_84[g_index_112][0] = TimeToStr(Time[li_16], TIME_DATE|TIME_SECONDS);
      gsa_84[g_index_112][1] = DoubleToStr(l_low_24, 4);
      g_index_112++;
   } else {
      if (li_56 == 0) {
         gsa_84[g_index_112][0] = TimeToStr(Time[li_20], TIME_DATE|TIME_SECONDS);
         gsa_84[g_index_112][1] = DoubleToStr(l_high_32, 4);
         g_index_112++;
      }
   }
   if (ai_4 <= g_index_112) {
   }
}

void DrawPriceArrow(int ai_0, int a_datetime_4, double a_price_8, color a_color_16, string as_20) {
   string l_name_28 = "ZZ_START_" + "arraw_" + as_20 + ai_0;
   ObjectDelete(l_name_28);
   ObjectCreate(l_name_28, OBJ_ARROW, 0, a_datetime_4, a_price_8);
   ObjectSet(l_name_28, OBJPROP_WIDTH, 5);
   if (as_20 == "Buy") ObjectSet(l_name_28, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
   else
      if (as_20 == "Sell") ObjectSet(l_name_28, OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
   ObjectSet(l_name_28, OBJPROP_COLOR, a_color_16);
}

void HL_InitZZLine(color a_color_0) {
   SetIndexStyle(0, DRAW_SECTION, STYLE_SOLID, 1, a_color_0);
   SetIndexLabel(0, "ZZLine");
   SetIndexBuffer(0, g_ibuf_92);
   SetIndexEmptyValue(0, 0.0);
}

void HL_InitZZRelLine(color a_color_0) {
   SetIndexStyle(1, DRAW_SECTION, STYLE_DOT, 1, a_color_0);
   SetIndexStyle(2, DRAW_SECTION, STYLE_DOT, 1, a_color_0);
   SetIndexLabel(1, "ZZRelLine1");
   SetIndexLabel(2, "ZZRelLine2");
   SetIndexBuffer(1, g_ibuf_96);
   SetIndexBuffer(2, g_ibuf_100);
   SetIndexEmptyValue(1, 0.0);
   SetIndexEmptyValue(2, 0.0);
}

void HL_DrawZZline_ZigZag() {
   int l_shift_4;
   ArrayInitialize(g_ibuf_92, 0.0);
   for (int l_index_0 = 0; l_index_0 < g_index_112; l_index_0++) {
      l_shift_4 = iBarShift(Symbol(), Period(), StrToTime(gsa_84[l_index_0][0]));
      g_ibuf_92[l_shift_4] = StrToDouble(gsa_84[l_index_0][1]);
   }
}

void HL_DrawZZrelline_ZigZag() {
   int l_shift_4;
   ArrayInitialize(g_ibuf_96, 0.0);
   ArrayInitialize(g_ibuf_100, 0.0);
   for (int li_0 = 0; li_0 < g_index_112; li_0 += 2) {
      l_shift_4 = iBarShift(Symbol(), Period(), StrToTime(gsa_84[li_0][0]));
      g_ibuf_96[l_shift_4] = StrToDouble(gsa_84[li_0][1]);
   }
   for (li_0 = 1; li_0 < g_index_112; li_0 += 2) {
      l_shift_4 = iBarShift(Symbol(), Period(), StrToTime(gsa_84[li_0][0]));
      g_ibuf_100[l_shift_4] = StrToDouble(gsa_84[li_0][1]);
   }
}

void HL_DrawZZRelationsDesc(int ai_0, double ad_4, color a_color_12) {
   double l_str2dbl_16;
   double l_str2dbl_24;
   double l_str2dbl_32;
   int l_str2time_40;
   int l_str2time_44;
   int l_str2time_48;
   int l_shift_52;
   int l_shift_56;
   int l_shift_60;
   string l_text_64;
   string l_name_72;
   int li_80;
   double ld_84;
   string ls_96;
   for (int li_92 = g_index_112 - 2 - ai_0; li_92 < g_index_112 - 2; li_92++) {
      l_str2time_40 = StrToTime(gsa_84[li_92][0]);
      l_str2dbl_16 = StrToDouble(gsa_84[li_92][1]);
      l_str2time_44 = StrToTime(gsa_84[li_92 + 1][0]);
      l_str2dbl_24 = StrToDouble(gsa_84[li_92 + 1][1]);
      l_str2time_48 = StrToTime(gsa_84[li_92 + 2][0]);
      l_str2dbl_32 = StrToDouble(gsa_84[li_92 + 2][1]);
      l_shift_52 = iBarShift(Symbol(), Period(), l_str2time_40);
      l_shift_56 = iBarShift(Symbol(), Period(), l_str2time_44);
      l_shift_60 = iBarShift(Symbol(), Period(), l_str2time_48);
      li_80 = l_shift_52 - l_shift_60;
      if (l_str2dbl_24 - l_str2dbl_16 != 0.0) {
         ld_84 = (l_str2dbl_24 - l_str2dbl_32) / (l_str2dbl_24 - l_str2dbl_16);
         ls_96 = "";
         if (ld_84 >= (1 - ad_4) / 2.0 && ld_84 <= (ad_4 + 1.0) / 2.0) ls_96 = "38.2%";
         else {
            if (ld_84 >= (1 - ad_4) / 2.0 && ld_84 <= (ad_4 + 1.0) / 2.0) ls_96 = "50.0%";
            else {
               if (ld_84 >= 0.618 * (1 - ad_4) && ld_84 <= 0.618 * (ad_4 + 1.0)) ls_96 = "61.8%";
               else {
                  if (ld_84 >= 0.786 * (1 - ad_4) && ld_84 <= 0.786 * (ad_4 + 1.0)) ls_96 = "78.6%";
                  else {
                     if (ld_84 >= 0.886 * (1 - ad_4) && ld_84 <= 0.886 * (ad_4 + 1.0)) ls_96 = "88.6%";
                     else {
                        if (ld_84 >= 1.0 * (1 - ad_4) && ld_84 <= 1.0 * (ad_4 + 1.0)) ls_96 = "100.0%";
                        else {
                           if (ld_84 >= 1.27 * (1 - ad_4) && ld_84 <= 1.27 * (ad_4 + 1.0)) ls_96 = "127.2%";
                           else {
                              if (ld_84 >= 1.618 * (1 - ad_4) && ld_84 <= 1.618 * (ad_4 + 1.0)) ls_96 = "161.8%";
                              else {
                                 if (ld_84 >= 2.618 * (1 - ad_4) && ld_84 <= 2.618 * (ad_4 + 1.0)) ls_96 = "261.8%";
                                 else
                                    if (ld_84 >= 3.618 * (1 - ad_4) && ld_84 <= 3.618 * (ad_4 + 1.0)) ls_96 = "361.8%";
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         l_name_72 = "HAR_O_" + "pricetime_linedesc_" + TimeToStr(l_str2time_40, TIME_DATE|TIME_MINUTES);
         ObjectDelete(l_name_72);
         ObjectCreate(l_name_72, OBJ_TEXT, 0, l_str2time_40 + (l_str2time_48 - l_str2time_40) / 3, l_str2dbl_16 + (l_str2dbl_32 - l_str2dbl_16) / 3.0, 0, 0);
         if (ls_96 != "") {
            l_text_64 = ls_96 + " , " + li_80;
            ObjectSetText(l_name_72, l_text_64, 9, "Arial", a_color_12);
         } else {
            l_text_64 = DoubleToStr(100.0 * ld_84, 1) + "% , " + li_80;
            ObjectSetText(l_name_72, l_text_64, 7, "Arial", a_color_12);
         }
      }
   }
}

void HL_DrawZZPoints(int ai_unused_0) {
   string l_name_8;
   string l_text_16;
   for (int l_index_4 = 0; l_index_4 < g_index_112; l_index_4++) {
      l_text_16 = l_index_4;
      l_name_8 = "ZZ_POINT_" + l_index_4 + "_" + gsa_84[l_index_4][0];
      ObjectDelete(l_name_8);
      ObjectCreate(l_name_8, OBJ_TEXT, 0, StrToTime(gsa_84[l_index_4][0]), StrToDouble(gsa_84[l_index_4][1]));
      ObjectSetText(l_name_8, l_text_16, 9, "Arial", White);
   }
}

string PeriodDesc(int ai_0) {
   switch (ai_0) {
   case 1:
      return ("M1");
   case 5:
      return ("M5");
   case 15:
      return ("M15");
   case 30:
      return ("M30");
   case 60:
      return ("H1");
   case 240:
      return ("H4");
   case 1440:
      return ("D1");
   case 10080:
      return ("W1");
   case 43200:
      return ("MN");
   }
   return ("Unknown Period");
}

int PeriodTimeDelta(int ai_0) {
   switch (ai_0) {
   case 1:
      return (0);
   case 5:
      return (0);
   case 15:
      return (10);
   case 30:
      return (20);
   case 60:
      return (30);
   case 240:
      return (40);
   case 1440:
      return (50);
   case 10080:
      return (60);
   case 43200:
      return (70);
   }
   return (0);
}

int InitInputFile(string a_name_0) {
   int l_file_8 = FileOpen(a_name_0, FILE_CSV|FILE_READ, ';');
   if (l_file_8 == -1 || FileSize(l_file_8) == 0) {
      Print("WARNING: File ", a_name_0, " not found, the last error is ", GetLastError());
      return (-1);
   }
   return (l_file_8);
}

int CloseFile(int a_file_0) {
   if (a_file_0 != -1) FileClose(a_file_0);
   return (0);
}

void UpdateScale() {
   gd_124 = WindowPriceMax();
   gd_132 = WindowPriceMin();
   gd_140 = gd_124 - gd_132;
   gd_148 = gd_140 / Point;
}

void ShowIndicatorInfo(string as_0, string as_8, string as_16, color a_color_24, int a_window_28, int a_corner_32) {
   string l_name_36 = as_0 + as_8;
   ObjectDelete(l_name_36);
   ObjectCreate(l_name_36, OBJ_LABEL, a_window_28, 0, 0);
   ObjectSet(l_name_36, OBJPROP_XDISTANCE, 4);
   ObjectSet(l_name_36, OBJPROP_YDISTANCE, 12);
   ObjectSet(l_name_36, OBJPROP_CORNER, a_corner_32);
   ObjectSetText(l_name_36, as_0 + " " + as_8 + as_16 + " " + "", 8, "Arial", a_color_24);
}

string DateTimeReformat(string as_0) {
   string ls_8;
   string ls_ret_16 = "";
   as_0 = " " + as_0;
   int l_str_len_24 = StringLen(as_0);
   for (int li_28 = 0; li_28 < l_str_len_24; li_28++) {
      ls_8 = StringSetChar(ls_8, 0, StringGetChar(as_0, li_28));
      if (ls_8 != ":" && ls_8 != " " && ls_8 != ".") ls_ret_16 = ls_ret_16 + ls_8;
   }
   return (ls_ret_16);
}

int DropObjects(string as_0) {
   string l_name_8;
   bool l_bool_28;
   int l_error_32;
   int l_objs_total_16 = ObjectsTotal();
   int li_24 = 0;
   for (int l_count_20 = 0; l_count_20 < l_objs_total_16; l_count_20++) {
      l_name_8 = ObjectName(li_24);
      if (StringFind(l_name_8, as_0) >= 0) {
         l_bool_28 = ObjectDelete(l_name_8);
         if (l_bool_28 == FALSE) {
            l_error_32 = GetLastError();
            Alert("ERROR,res:::::::::", l_error_32);
         }
      } else li_24++;
   }
   return (0);
}

int ParseInputString2Doubles(string as_0, double &ada_8[]) {
   int li_16;
   int l_index_20 = 0;
   int li_12 = 0;
   for (int li_24 = 0; li_24 < StringLen(as_0); li_24++) {
      if (StringGetChar(as_0, li_24) == ';') {
         li_16 = li_24;
         ada_8[l_index_20] = StrToDouble(StringSubstr(as_0, li_12, li_16 - li_12));
         l_index_20++;
         if (l_index_20 == 30) return (l_index_20);
         li_12 = li_24 + 1;
      }
   }
   return (l_index_20);
}

int WindowYPixels() {
   int lia_0[4];
   int li_4 = WindowHandle(Symbol(), Period());
   if (li_4 > 0) GetClientRect(li_4, lia_0);
   return (lia_0[3]);
}

void SIGMON_FoundPatterns_Reset() {
   for (int l_index_0 = 0; l_index_0 < 30; l_index_0++) gia_164[l_index_0] = 99;
}

void SIGMON_FoundPatterns_Set(int ai_0, int ai_4) {
   gia_164[ai_0] = ai_4;
}

void SIGMON_FoundPatterns_Save(string a_name_0) {
   string ls_12;
   int l_file_8 = FileOpen(a_name_0, FILE_CSV|FILE_WRITE, ';');
   if (l_file_8 >= 1) {
      FileWrite(l_file_8, "001;" + TimeCurrent());
      for (int l_index_20 = 0; l_index_20 < 30; l_index_20++) {
         ls_12 = l_index_20 + ";" + gia_164[l_index_20];
         FileWrite(l_file_8, ls_12);
      }
      if (l_file_8 != -1) FileClose(l_file_8);
   }
}

void SIGMON_FoundPatterns_FileDelete(string a_name_0) {
   FileDelete(a_name_0);
}

void init() {
   ShowIndicatorInfo("", " ", "", extTextColor, 0, 2);
   if (iextHL_MinSwing == 0) {
      LoadMinSwingDefaults(sextMinSwingDefaultsFile);
      iextHL_MinSwing = DefaultMinSwing();
      if (iextHL_MinSwing == -1) {
         Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "Default iextHL_MinSwing values are not defined for this instrument. Please specify in the txt configuration file. Exiting...");
         return;
      }
   }
   gda_600[0] = gd_568 / 8.0;
   gda_600[1] = gd_568 / 4.0;
   gda_600[2] = gd_568 / 3.0;
   gda_600[3] = gd_568 / 2.0;
   gda_600[4] = gd_568 / 1.5;
   gda_600[5] = 0.75 * gd_568;
   gda_600[6] = 0.875 * gd_568;
   gda_600[7] = 1.0 * gd_568;
   gda_604[0] = gd_584 / 8.0;
   gda_604[1] = gd_584 / 4.0;
   gda_604[2] = gd_584 / 3.0;
   gda_604[3] = gd_584 / 2.0;
   gda_604[4] = gd_584 / 1.5;
   gda_604[5] = 0.75 * gd_584;
   gda_604[6] = 0.875 * gd_584;
   gda_604[7] = 1.0 * gd_584;
   HL_InitZZLine(cextZZLineColor);
   HL_InitZZRelLine(cextZZRelLineColor);
   if (iextMaxBars > 50000) {
      Alert("ERROR:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "Specified iextMaxBars number:", iextMaxBars, " in not supported, allowed:[0,", 50000, "] ...changing to max value...");
      iextMaxBars = 50000;
   }
   if (iextMaxZZPointsUsed < 6) {
      Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "Setting iextMaxZZPointsUsed to minimum =", 6, " required for harmonic analysis.");
      iextMaxZZPointsUsed = 6;
   }
   HAR_FoundPatterns_Init();
   if (bextSigMonitonitoringON == TRUE) {
      SIGMON_FoundPatterns_Reset();
      SIGMON_FoundPatterns_Save(sextSigMonitoringDir + "korHarmonicsSig" + "_" + Symbol() + "_" + PeriodDesc(Period()) + ".csv");
   }
   HL_CleanArrays();
   if (dextHL_MultiZZMinSwingRange < 0.0) {
      dextHL_MultiZZMinSwingRange = 0.0;
      Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "dextHL_MultiZZMinSwingRange should be in the [0,0.9] range. Will use 0.");
   } else {
      if (dextHL_MultiZZMinSwingRange > 0.9) {
         dextHL_MultiZZMinSwingRange = 0.9;
         Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "dextHL_MultiZZMinSwingRange should be in the [0,0.9] range. Will use 0.9.");
      }
   }
   gi_1084 = PeriodTimeDelta(Period());
   gi_380 = ParseInputString2Doubles(FiboLevelsStr, gda_376);
   if (bextDrawPRZ) {
      gi_412 = ParseInputString2Doubles(FiboIntRetLevelsStr, gda_408);
      gi_396 = ParseInputString2Doubles(FiboExtRetLevelsStr, gda_392);
      gi_428 = ParseInputString2Doubles(FiboProjLevelsStr, gda_424);
      gi_444 = ParseInputString2Doubles(FiboAPPProjLevelsStr, gda_440);
   }
   gi_1088 = TRUE;
}

void deinit() {
   Comment("");
   DropObjects("korHarmonics" + "6.7.9e ");
   DropObjects("ZZ_START_");
   DropObjects("ZZ_POINT_");
   DropObjects("ZZ_LINE_");
   DropObjects("HAR_O_");
   DropObjects("HAR_S_");
   if (bextSigMonitonitoringON == TRUE) SIGMON_FoundPatterns_FileDelete(sextSigMonitoringDir + "korHarmonicsSig" + "_" + Symbol() + "_" + PeriodDesc(Period()) + ".csv");
}

void start() {
   if (Time[0] > g_time_1076 || TimeCurrent() > g_datetime_1080 + iextRefreshRate) {
      g_time_1076 = Time[0];
      g_datetime_1080 = TimeCurrent();
      if (gi_1088 == TRUE) {
         if(gi_1088 == True) {
            UpdateScale();
            HL_CleanArrays();
            HL_Calculate(iextMaxBars, iextMaxZZPointsUsed, gi_192, iextHL_MinSwing);
            HAR_FoundPatterns_ShowSettings();
            if (iextMaxZZPointsUsed > g_index_112 - 2) iextMaxZZPointsUsed = g_index_112 - 2;
            HAR_FoundPatterns_Reset();
            DropObjects("ZZ_POINT_");
            DropObjects("ZZ_LINE_");
            DropObjects("HAR_O_");
            if (bextDrawZZLine) HL_DrawZZline_ZigZag();
            if (bextDrawZZPoints) HL_DrawZZPoints(extTextColor);
            if (bextShowHistoryPatterns) {
               if (bextDrawZZRelations) {
                  HL_DrawZZrelline_ZigZag();
                  HL_DrawZZRelationsDesc(g_index_112 - 1, dextMaxDeviation, extTextColor);
               }
               if (bextCheckMultiZigzags) {
                  for (int li_0 = iextHL_MinSwing - dextHL_MultiZZMinSwingRange * iextHL_MinSwing; li_0 <= iextHL_MinSwing + dextHL_MultiZZMinSwingRange * iextHL_MinSwing; li_0 += iextHL_MinSwing / iextHL_MultiZZMinSwingNum) {
                     HL_Calculate(iextMaxBars, iextMaxZZPointsUsed, gi_192, li_0);
                     HAR_HarmonicPatternsAnalysis(g_index_112);
                  }
               } else HAR_HarmonicPatternsAnalysis(g_index_112);
            } else {
               if (bextDrawZZRelations) {
                  HL_DrawZZrelline_ZigZag();
                  HL_DrawZZRelationsDesc(iextMaxZZPointsUsed, dextMaxDeviation, extTextColor);
               }
               if (bextCheckMultiZigzags) {
                  for (li_0 = iextHL_MinSwing - dextHL_MultiZZMinSwingRange * iextHL_MinSwing; li_0 <= iextHL_MinSwing + dextHL_MultiZZMinSwingRange * iextHL_MinSwing; li_0 += iextHL_MinSwing / iextHL_MultiZZMinSwingNum) {
                     HL_Calculate(iextMaxBars, iextMaxZZPointsUsed, gi_192, li_0);
                     HAR_HarmonicPatternsAnalysis(iextMaxZZPointsUsed);
                  }
               } else HAR_HarmonicPatternsAnalysis(iextMaxZZPointsUsed);
            }
            if (HAR_FoundPatterns_IsChanged() == 1) {
               HAR_FoundPatterns_ShowPatterns();
               if (bextMT4AlertON && bextShowHistoryPatterns == FALSE) HAR_FoundPatterns_Alert(0);
               if (bextMT4EmailON && bextShowHistoryPatterns == FALSE) HAR_FoundPatterns_Alert(4);
               if (bextSoundAlertON) PlaySound(sextInfoPatternSoundFile);
               if (bextScreenshotPatternsON == TRUE && bextShowHistoryPatterns == FALSE) ScreenshotNewObjects();
               if (bextScreenshotPatternsON == TRUE && bextShowHistoryPatterns == FALSE) ScreenshotLostObjects();
               if (bextSigWebMonitonitoringON == TRUE && bextShowHistoryPatterns == FALSE) SigWebMonitoring();
               if (bextSigMonitonitoringON == TRUE) SIGMON_FoundPatterns_Save(sextSigMonitoringDir + "korHarmonicsSig" + "_" + Symbol() + "_" + PeriodDesc(Period()) + ".csv");
               HAR_FoundPatterns_StoreCurr();
            }
         }
      }
   }
}

void HAR_HarmonicPatternsAnalysis(int ai_0) {
   double l_str2dbl_4;
   double l_str2dbl_12;
   double l_str2dbl_20;
   double l_str2dbl_28;
   double l_str2dbl_36;
   double l_str2dbl_44;
   double l_str2dbl_52;
   double l_str2dbl_60;
   double l_str2dbl_68;
   int l_str2time_108;
   int l_str2time_112;
   int l_str2time_116;
   int l_str2time_120;
   int l_str2time_124;
   int l_str2time_128;
   int l_str2time_132;
   int l_str2time_136;
   int l_str2time_140;
   int li_160;
   int li_168;
   int li_172;
   bool li_176;
   double l_str2dbl_200;
   double l_str2dbl_208;
   if (bextFibo || bextFibo382 || bextFibo500 || bextFibo618 || bextFibo786 || bextFibo886) {
      if (bextShowHistoryPatterns == FALSE) li_172 = 5;
      else li_172 = ai_0;
      for (int li_164 = g_index_112 - li_172; li_164 <= g_index_112 - 3; li_164++) {
         l_str2time_112 = StrToTime(gsa_84[li_164][0]);
         l_str2dbl_12 = StrToDouble(gsa_84[li_164][1]);
         l_str2time_116 = StrToTime(gsa_84[li_164 + 1][0]);
         l_str2dbl_20 = StrToDouble(gsa_84[li_164 + 1][1]);
         l_str2time_120 = StrToTime(gsa_84[li_164 + 2][0]);
         l_str2dbl_28 = StrToDouble(gsa_84[li_164 + 2][1]);
         if (bextFibo) {
            li_160 = Is_Pattern_Fibo(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, dextFiboDeviation);
            if (li_160 > 0) Draw_Pattern_Fibo(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28);
         }
         if (bextFibo382) {
            li_160 = Is_Pattern_FiboExact(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, 0.382, dextFiboDeviation);
            if (li_160 > 0) Draw_Pattern_Fibo(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28);
         }
         if (bextFibo500) {
            li_160 = Is_Pattern_FiboExact(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, 0.5, dextFiboDeviation);
            if (li_160 > 0) Draw_Pattern_Fibo(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28);
         }
         if (bextFibo618) {
            li_160 = Is_Pattern_FiboExact(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, 0.618, dextFiboDeviation);
            if (li_160 > 0) Draw_Pattern_Fibo(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28);
         }
         if (bextFibo786) {
            li_160 = Is_Pattern_FiboExact(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, 0.786, dextFiboDeviation);
            if (li_160 > 0) Draw_Pattern_Fibo(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28);
         }
         if (bextFibo886) {
            li_160 = Is_Pattern_FiboExact(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, 0.886, dextFiboDeviation);
            if (li_160 > 0) Draw_Pattern_Fibo(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28);
         }
      }
   }
   if (bextABCD || bextI_ABCD || bextIT_ABCD || bextBatman || bextWXY) {
      if (bextShowHistoryPatterns == FALSE) li_168 = 4;
      else li_168 = ai_0;
      for (li_164 = g_index_112 - li_168; li_164 <= g_index_112 - 4; li_164++) {
         l_str2time_112 = StrToTime(gsa_84[li_164][0]);
         l_str2dbl_12 = StrToDouble(gsa_84[li_164][1]);
         l_str2time_116 = StrToTime(gsa_84[li_164 + 1][0]);
         l_str2dbl_20 = StrToDouble(gsa_84[li_164 + 1][1]);
         l_str2time_120 = StrToTime(gsa_84[li_164 + 2][0]);
         l_str2dbl_28 = StrToDouble(gsa_84[li_164 + 2][1]);
         l_str2time_124 = StrToTime(gsa_84[li_164 + 3][0]);
         l_str2dbl_36 = StrToDouble(gsa_84[li_164 + 3][1]);
         li_160 = Is_Pattern_ABCD(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, dextMaxDeviation);
         if (li_160 > 0) Draw_Pattern_ABCD(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36);
         li_160 = Is_Pattern_Batman(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36);
         if (li_160 > 0) Draw_Pattern_Batman(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36);
         li_160 = Is_Pattern_WXY(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, dextMaxDeviation);
         if (li_160 > 0) Draw_Pattern_WXY(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36);
      }
   }
   for (li_164 = g_index_112 - ai_0; li_164 <= g_index_112 - 5; li_164++) {
      l_str2time_112 = StrToTime(gsa_84[li_164][0]);
      l_str2dbl_12 = StrToDouble(gsa_84[li_164][1]);
      l_str2time_116 = StrToTime(gsa_84[li_164 + 1][0]);
      l_str2dbl_20 = StrToDouble(gsa_84[li_164 + 1][1]);
      l_str2time_120 = StrToTime(gsa_84[li_164 + 2][0]);
      l_str2dbl_28 = StrToDouble(gsa_84[li_164 + 2][1]);
      l_str2time_124 = StrToTime(gsa_84[li_164 + 3][0]);
      l_str2dbl_36 = StrToDouble(gsa_84[li_164 + 3][1]);
      l_str2time_128 = StrToTime(gsa_84[li_164 + 4][0]);
      l_str2dbl_44 = StrToDouble(gsa_84[li_164 + 4][1]);
      if (li_164 != g_index_112 - 5) li_176 = FALSE;
      else {
         if (bextEmergingPatterns) li_176 = TRUE;
         else li_176 = FALSE;
      }
      li_160 = Is_MultiDimPattern(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, dextMaxDeviation, li_176);
      if (li_160 > 0) Draw_MultiDimPattern(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, dextMaxDeviation);
   }
   for (li_164 = g_index_112 - ai_0; li_164 <= g_index_112 - 7; li_164++) {
      l_str2time_136 = StrToTime(gsa_84[li_164][0]);
      l_str2dbl_60 = StrToDouble(gsa_84[li_164][1]);
      l_str2time_140 = StrToTime(gsa_84[li_164 + 1][0]);
      l_str2dbl_68 = StrToDouble(gsa_84[li_164 + 1][1]);
      for (int l_count_180 = 0; l_count_180 <= 1; l_count_180++) {
         if (li_164 + 1 + 1 + l_count_180 * 2 < g_index_112) {
            l_str2time_112 = StrToTime(gsa_84[li_164 + 1 + 1 + l_count_180 * 2][0]);
            l_str2dbl_12 = StrToDouble(gsa_84[li_164 + 1 + 1 + l_count_180 * 2][1]);
            if (l_count_180 == 1) {
               l_str2dbl_200 = StrToDouble(gsa_84[li_164 + 1 + 1][1]);
               l_str2dbl_208 = StrToDouble(gsa_84[li_164 + 1 + 2][1]);
               if ((l_str2dbl_68 < l_str2dbl_200 && l_str2dbl_68 < l_str2dbl_208 && l_str2dbl_12 > l_str2dbl_200 && l_str2dbl_12 > l_str2dbl_208 && l_str2dbl_200 > l_str2dbl_208) ||
                  (l_str2dbl_68 > l_str2dbl_200 && l_str2dbl_68 > l_str2dbl_208 && l_str2dbl_12 < l_str2dbl_200 && l_str2dbl_12 < l_str2dbl_208 && l_str2dbl_200 < l_str2dbl_208) == FALSE) continue;
            }
            for (int l_count_184 = 0; l_count_184 <= 1; l_count_184++) {
               if (li_164 + 1 + (l_count_180 * 2 + 1) + 1 + l_count_184 * 2 < g_index_112) {
                  l_str2time_116 = StrToTime(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + 1 + l_count_184 * 2][0]);
                  l_str2dbl_20 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + 1 + l_count_184 * 2][1]);
                  if (l_count_184 == 1) {
                     l_str2dbl_200 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + 1][1]);
                     l_str2dbl_208 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + 2][1]);
                     if ((l_str2dbl_20 < l_str2dbl_200 && l_str2dbl_20 < l_str2dbl_208 && l_str2dbl_12 > l_str2dbl_200 && l_str2dbl_12 > l_str2dbl_208 && l_str2dbl_200 < l_str2dbl_208) ||
                        (l_str2dbl_20 > l_str2dbl_200 && l_str2dbl_20 > l_str2dbl_208 && l_str2dbl_12 < l_str2dbl_200 && l_str2dbl_12 < l_str2dbl_208 && l_str2dbl_200 > l_str2dbl_208) == FALSE) continue;
                  }
                  for (int l_count_188 = 0; l_count_188 <= 1; l_count_188++) {
                     if (li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) < g_index_112) {
                        l_str2time_120 = StrToTime(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1)][0]);
                        l_str2dbl_28 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1)][1]);
                        if (l_count_188 == 1) {
                           l_str2dbl_200 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + 1][1]);
                           l_str2dbl_208 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + 2][1]);
                           if ((l_str2dbl_28 < l_str2dbl_200 && l_str2dbl_28 < l_str2dbl_208 && l_str2dbl_20 > l_str2dbl_200 && l_str2dbl_20 > l_str2dbl_208 && l_str2dbl_200 < l_str2dbl_208) ||
                              (l_str2dbl_28 > l_str2dbl_200 && l_str2dbl_28 > l_str2dbl_208 && l_str2dbl_20 < l_str2dbl_200 && l_str2dbl_20 < l_str2dbl_208 && l_str2dbl_200 > l_str2dbl_208) == FALSE) continue;
                        }
                        for (int l_count_192 = 0; l_count_192 <= 1; l_count_192++) {
                           if (li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + (l_count_192 * 2 + 1) < g_index_112) {
                              l_str2time_124 = StrToTime(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + (l_count_192 * 2 + 1)][0]);
                              l_str2dbl_36 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + (l_count_192 * 2 + 1)][1]);
                              if (l_count_192 == 1) {
                                 l_str2dbl_200 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + 1][1]);
                                 l_str2dbl_208 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + 2][1]);
                                 if ((l_str2dbl_36 < l_str2dbl_200 && l_str2dbl_36 < l_str2dbl_208 && l_str2dbl_28 > l_str2dbl_200 && l_str2dbl_28 > l_str2dbl_208 && l_str2dbl_200 < l_str2dbl_208) ||
                                    (l_str2dbl_36 > l_str2dbl_200 && l_str2dbl_36 > l_str2dbl_208 && l_str2dbl_28 < l_str2dbl_200 && l_str2dbl_28 < l_str2dbl_208 && l_str2dbl_200 > l_str2dbl_208) == FALSE) continue;
                              }
                              for (int l_count_196 = 0; l_count_196 <= 1; l_count_196++) {
                                 if (li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + (l_count_192 * 2 + 1) + (l_count_196 * 2 + 1) < g_index_112) {
                                    l_str2time_128 = StrToTime(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + (l_count_192 * 2 + 1) + (l_count_196 * 2 + 1)][0]);
                                    l_str2dbl_44 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + (l_count_192 * 2 + 1) + (l_count_196 * 2 + 1)][1]);
                                    if (l_count_196 == 1) {
                                       l_str2dbl_200 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + (l_count_192 * 2 + 1) + 1][1]);
                                       l_str2dbl_208 = StrToDouble(gsa_84[li_164 + 1 + (l_count_180 * 2 + 1) + (l_count_184 * 2 + 1) + (l_count_188 * 2 + 1) + (l_count_192 * 2 + 1) + 2][1]);
                                       if ((l_str2dbl_44 < l_str2dbl_200 && l_str2dbl_44 < l_str2dbl_208 && l_str2dbl_36 > l_str2dbl_200 && l_str2dbl_36 > l_str2dbl_208 && l_str2dbl_200 < l_str2dbl_208) ||
                                          (l_str2dbl_44 > l_str2dbl_200 && l_str2dbl_44 > l_str2dbl_208 && l_str2dbl_36 < l_str2dbl_200 && l_str2dbl_36 < l_str2dbl_208 && l_str2dbl_200 > l_str2dbl_208) == FALSE) continue;
                                    }
                                    li_160 = Is_TriangleC1(l_str2time_136, l_str2dbl_60, l_str2time_140, l_str2dbl_68, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, dextMaxTriangleDeviation);
                                    if (li_160 > 0) Draw_Triangle(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44);
                                    li_160 = Is_IConTriangle(l_str2time_136, l_str2dbl_60, l_str2time_140, l_str2dbl_68, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, dextMaxTriangleDeviation);
                                    if (li_160 > 0) Draw_Triangle(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44);
                                    li_160 = Is_NIConTriangle(l_str2time_136, l_str2dbl_60, l_str2time_140, l_str2dbl_68, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, dextMaxTriangleDeviation);
                                    if (li_160 > 0) Draw_Triangle(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44);
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   for (li_164 = g_index_112 - ai_0; li_164 <= g_index_112 - 6; li_164++) {
      l_str2time_108 = StrToTime(gsa_84[li_164][0]);
      l_str2dbl_4 = StrToDouble(gsa_84[li_164][1]);
      l_str2time_112 = StrToTime(gsa_84[li_164 + 1][0]);
      l_str2dbl_12 = StrToDouble(gsa_84[li_164 + 1][1]);
      l_str2time_116 = StrToTime(gsa_84[li_164 + 2][0]);
      l_str2dbl_20 = StrToDouble(gsa_84[li_164 + 2][1]);
      l_str2time_120 = StrToTime(gsa_84[li_164 + 3][0]);
      l_str2dbl_28 = StrToDouble(gsa_84[li_164 + 3][1]);
      l_str2time_124 = StrToTime(gsa_84[li_164 + 4][0]);
      l_str2dbl_36 = StrToDouble(gsa_84[li_164 + 4][1]);
      l_str2time_128 = StrToTime(gsa_84[li_164 + 5][0]);
      l_str2dbl_44 = StrToDouble(gsa_84[li_164 + 5][1]);
      li_160 = Is_DiaTriangle(l_str2time_108, l_str2dbl_4, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, dextMaxTriangleDeviation);
      if (li_160 > 0) Draw_DiaTriangle(li_160, l_str2time_108, l_str2dbl_4, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44);
   }
   for (li_164 = g_index_112 - ai_0; li_164 <= g_index_112 - 6; li_164++) {
      l_str2time_112 = StrToTime(gsa_84[li_164][0]);
      l_str2dbl_12 = StrToDouble(gsa_84[li_164][1]);
      l_str2time_116 = StrToTime(gsa_84[li_164 + 1][0]);
      l_str2dbl_20 = StrToDouble(gsa_84[li_164 + 1][1]);
      l_str2time_120 = StrToTime(gsa_84[li_164 + 2][0]);
      l_str2dbl_28 = StrToDouble(gsa_84[li_164 + 2][1]);
      l_str2time_124 = StrToTime(gsa_84[li_164 + 3][0]);
      l_str2dbl_36 = StrToDouble(gsa_84[li_164 + 3][1]);
      l_str2time_128 = StrToTime(gsa_84[li_164 + 4][0]);
      l_str2dbl_44 = StrToDouble(gsa_84[li_164 + 4][1]);
      l_str2time_132 = StrToTime(gsa_84[li_164 + 5][0]);
      l_str2dbl_52 = StrToDouble(gsa_84[li_164 + 5][1]);
      li_160 = Is_SHSPattern(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, l_str2time_132, l_str2dbl_52, dextMaxSHSPriceDeviation, dextMaxSHSTimeDeviation);
      if (li_160 > 0) Draw_Pattern_SHS(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, l_str2time_132, l_str2dbl_52);
      li_160 = Is_3DrivesPattern(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, l_str2time_132, l_str2dbl_52, dextMaxDeviation);
      if (li_160 > 0) Draw_Pattern_3Drives(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, l_str2time_132, l_str2dbl_52);
      li_160 = Is_5_0Pattern(l_str2dbl_12, l_str2dbl_20, l_str2dbl_28, l_str2dbl_36, l_str2dbl_44, l_str2dbl_52, dextMaxDeviation);
      if (li_160 > 0) Draw_Pattern_5_0(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44, l_str2time_132, l_str2dbl_52);
   }
   if (gi_528 || bextOne2One || bextEOne2One || bextSOne2One) {
      for (li_164 = g_index_112 - ai_0; li_164 <= g_index_112 - 5; li_164++) {
         l_str2time_112 = StrToTime(gsa_84[li_164][0]);
         l_str2dbl_12 = StrToDouble(gsa_84[li_164][1]);
         l_str2time_116 = StrToTime(gsa_84[li_164 + 1][0]);
         l_str2dbl_20 = StrToDouble(gsa_84[li_164 + 1][1]);
         l_str2time_120 = StrToTime(gsa_84[li_164 + 2][0]);
         l_str2dbl_28 = StrToDouble(gsa_84[li_164 + 2][1]);
         l_str2time_124 = StrToTime(gsa_84[li_164 + 3][0]);
         l_str2dbl_36 = StrToDouble(gsa_84[li_164 + 3][1]);
         l_str2time_128 = StrToTime(gsa_84[li_164 + 4][0]);
         l_str2dbl_44 = StrToDouble(gsa_84[li_164 + 4][1]);
         if (li_164 != g_index_112 - 5) li_176 = FALSE;
         else {
            if (bextEmergingPatterns) li_176 = TRUE;
            else li_176 = FALSE;
         }
         li_160 = Is_OmarPattern(l_str2dbl_12, l_str2dbl_20, l_str2dbl_28, l_str2dbl_36, l_str2dbl_44, dextMaxCorrDeviation);
         if (li_160 > 0) Draw_OmarPattern(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44);
         li_160 = Is_EOne2OnePattern(l_str2dbl_12, l_str2dbl_20, l_str2dbl_28, l_str2dbl_36, l_str2dbl_44, dextMaxOne2OneDeviation, li_176);
         if (li_160 > 0) Draw_EOne2OnePattern(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, l_str2time_120, l_str2dbl_28, l_str2time_124, l_str2dbl_36, l_str2time_128, l_str2dbl_44);
      }
   }
   if (gi_564) {
      for (li_164 = g_index_112 - ai_0; li_164 <= g_index_112 - 2; li_164++) {
         l_str2time_112 = StrToTime(gsa_84[li_164][0]);
         l_str2dbl_12 = StrToDouble(gsa_84[li_164][1]);
         l_str2time_116 = StrToTime(gsa_84[li_164 + 1][0]);
         l_str2dbl_20 = StrToDouble(gsa_84[li_164 + 1][1]);
         li_160 = Is_VibrationPattern(l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20, gd_576, gd_592);
         if (li_160 > 0) Draw_VibrationPattern(li_160, l_str2time_112, l_str2dbl_12, l_str2time_116, l_str2dbl_20);
      }
   }
}

int Is_Pattern_ABCD(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, double ad_48) {
   if (ad_4 - ad_16 == 0.0) return (0);
   double ld_56 = (ad_28 - ad_16) / (ad_4 - ad_16);
   int li_64 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_24);
   int li_68 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_36);
   if (bextIT_ABCD && MathAbs(ad_40 - ad_28) >= MathAbs(ad_16 - ad_4) * (1.0 - ad_48) && MathAbs(ad_40 - ad_28) <= MathAbs(ad_16 - ad_4) * (ad_48 + 1.0) && ld_56 >= 0.618 * (1 - ad_48) &&
      ld_56 <= 0.786 * (ad_48 + 1.0) && (li_64 >= li_68 * (1.0 - ad_48) && li_64 <= li_68 * (ad_48 + 1.0))) {
      if (ad_4 > ad_16) {
         HAR_FoundPatterns_Increase(5);
         SIGMON_FoundPatterns_Set(2, 1);
         return (5);
      }
      if (ad_4 < ad_16) {
         HAR_FoundPatterns_Increase(6);
         SIGMON_FoundPatterns_Set(2, -1);
         return (6);
      }
   } else {
      if (bextI_ABCD && MathAbs(ad_40 - ad_28) > MathAbs(ad_16 - ad_4) * (1.0 - ad_48) && MathAbs(ad_40 - ad_28) < MathAbs(ad_16 - ad_4) * (ad_48 + 1.0) && ld_56 >= 0.618 * (1 - ad_48) &&
         ld_56 <= 0.786 * (ad_48 + 1.0)) {
         if (ad_4 > ad_16) {
            HAR_FoundPatterns_Increase(3);
            SIGMON_FoundPatterns_Set(1, 1);
            return (3);
         }
         if (ad_4 >= ad_16) return (0);
         HAR_FoundPatterns_Increase(4);
         SIGMON_FoundPatterns_Set(1, -1);
         return (4);
      }
      if (bextABCD && MathAbs(ad_40 - ad_28) > MathAbs(ad_16 - ad_4) * (1.0 - ad_48) && MathAbs(ad_40 - ad_28) < MathAbs(ad_16 - ad_4) * (ad_48 + 1.0)) {
         if (ad_4 > ad_16) {
            HAR_FoundPatterns_Increase(1);
            SIGMON_FoundPatterns_Set(0, 1);
            return (1);
         }
         if (ad_4 >= ad_16) return (0);
         HAR_FoundPatterns_Increase(2);
         SIGMON_FoundPatterns_Set(0, -1);
         return (2);
      }
      return (0);
   }
   return (0);
}

int Is_Pattern_WXY(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, double ad_48) {
   if (ad_4 - ad_16 == 0.0 || ad_28 - ad_16 == 0.0) return (0);
   double ld_56 = (ad_28 - ad_16) / (ad_4 - ad_16);
   double ld_64 = (ad_28 - ad_40) / (ad_28 - ad_16);
   int li_72 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_24);
   int li_76 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_36);
   if (bextWXY && (ld_56 >= (1 - ad_48) / 2.0 && ld_56 <= (ad_48 + 1.0) / 2.0 && ld_64 >= 1.618 * (1 - ad_48) && ld_64 <= 1.618 * (ad_48 + 1.0)) || (ld_56 >= 0.618 * (1 - ad_48) &&
      ld_56 <= 0.618 * (ad_48 + 1.0) && ld_64 >= 1.618 * (1 - ad_48) && ld_64 <= 1.618 * (ad_48 + 1.0)) || (ld_56 >= (1 - ad_48) / 2.0 && ld_56 <= (ad_48 + 1.0) / 2.0 && ld_64 >= 2.618 * (1 - ad_48) && ld_64 <= 2.618 * (ad_48 +
      1.0)) || (ld_56 >= 0.618 * (1 - ad_48) && ld_56 <= 0.618 * (ad_48 + 1.0) && ld_64 >= 2.618 * (1 - ad_48) && ld_64 <= 2.618 * (ad_48 + 1.0)) && (li_76 >= 1.0 * li_72 * (1.0 - ad_48) &&
      li_76 <= 1.0 * li_72 * (ad_48 + 1.0) || li_76 >= 1.618 * li_72 * (1.0 - ad_48) && li_76 <= 1.618 * li_76 * (ad_48 + 1.0))) {
      if (ad_4 > ad_16) {
         HAR_FoundPatterns_Increase(64);
         SIGMON_FoundPatterns_Set(25, 1);
         return (64);
      }
      if (ad_4 < ad_16) {
         HAR_FoundPatterns_Increase(65);
         SIGMON_FoundPatterns_Set(25, -1);
         return (65);
      }
   } else return (0);
   return (0);
}

int Is_Pattern_Batman(int ai_unused_0, double ad_4, int ai_unused_12, double ad_16, int ai_unused_24, double ad_28, int ai_unused_36, double ad_40) {
   if (ad_4 - ad_16 == 0.0 || ad_28 - ad_16 == 0.0) return (0);
   double ld_48 = (ad_28 - ad_16) / (ad_4 - ad_16);
   double ld_56 = (ad_28 - ad_40) / (ad_28 - ad_16);
   if (bextBatman && ld_48 >= 1.0 && ld_48 <= 1.27 && ld_56 >= 0.73 && ld_56 <= 1.27) {
      if (ad_4 > ad_16 && ad_28 >= ad_4 && ad_28 > ad_16 && ad_40 < ad_4 && ad_40 < ad_28) {
         HAR_FoundPatterns_Increase(27);
         SIGMON_FoundPatterns_Set(26, 1);
         return (27);
      }
      if (!(ad_4 < ad_16 && ad_28 <= ad_4 && ad_28 < ad_16 && ad_40 > ad_4 && ad_40 > ad_28)) return (0);
      HAR_FoundPatterns_Increase(28);
      SIGMON_FoundPatterns_Set(26, -1);
      return (28);
   }
   return (0);
}

int Is_MultiDimPattern(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, double ad_60, int ai_68) {
   if (ad_16 - ad_4 == 0.0 || ad_40 - ad_28 == 0.0 || ad_16 - ad_28 == 0.0) return (0);
   double ld_72 = (ad_16 - ad_28) / (ad_16 - ad_4);
   double ld_80 = (ad_16 - ad_52) / (ad_16 - ad_4);
   double ld_88 = (ad_40 - ad_52) / (ad_40 - ad_28);
   double ld_96 = (ad_40 - ad_28) / (ad_16 - ad_28);
   double ld_104 = MathAbs(ad_28 - ad_16);
   double ld_112 = MathAbs(ad_52 - ad_40);
   double ld_120 = MathAbs(ad_4 - ad_16);
   int li_128 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_48);
   int li_132 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_48);
   int li_136 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_24);
   int li_140 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_12);
   int li_144 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_24);
   int li_148 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_152 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   if ((bextGartley && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 0.786 * (1 - ad_60) && ld_80 <= 0.786 * (ad_60 + 1.0) && ld_88 >= 1.272 * (1 - ad_60) &&
      ld_88 <= 1.618 * (ad_60 + 1.0) && ld_72 >= 0.618 * (1 - ad_60) && ld_72 <= 0.618 * (ad_60 + 1.0) && (ld_104 >= ld_112 * (1 - ad_60) && ld_104 <= ld_112 * (ad_60 +
      1.0)) && (li_128 >= 0.618 * li_140 * (1 - ad_60) && li_128 <= 2.618 * li_140 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_152 > 1))) || (bextGartley && bextIdealGartleyOnly == FALSE &&
      ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 0.577 * (1 - ad_60) && ld_80 <= 0.786 * (ad_60 + 1.0) && ld_88 >= 1.272 * (1 - ad_60) && ld_88 <= 2.2236 * (ad_60 +
      1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.618 * (ad_60 + 1.0) && (li_144 >= li_152 / 2.0 * (1 - ad_60) && li_144 <= 1.618 * li_152 * (ad_60 + 1.0)) || (li_152 >= li_144 / 2.0 * (1 - ad_60) && li_152 <= 1.618 * li_144 * (ad_60 +
      1.0)) && (li_128 >= 0.618 * li_140 * (1 - ad_60) && li_128 <= 2.618 * li_140 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_152 > 1)))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 > ad_4) {
         HAR_FoundPatterns_Increase(7);
         SIGMON_FoundPatterns_Set(3, 1);
         return (7);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 < ad_4) {
         HAR_FoundPatterns_Increase(8);
         SIGMON_FoundPatterns_Set(3, -1);
         return (8);
      }
   }
   if ((bextButterfly && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 1.27 * (1 - ad_60) && ld_80 <= 1.618 * (ad_60 + 1.0) && ld_88 >= 1.618 * (1 - ad_60) &&
      ld_88 <= 2.618 * (ad_60 + 1.0) && ld_72 >= 0.786 * (1 - ad_60) && ld_72 <= 0.786 * (ad_60 + 1.0) && (ld_112 >= 1.0 * ld_104 * (1 - ad_60) && ld_112 <= 1.0 * ld_104 * (ad_60 +
      1.0)) && (li_132 >= 0.618 * li_136 * (1 - ad_60) && li_132 <= 2.618 * li_136 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1))) || (bextButterfly &&
      bextIdealButterflyOnly == FALSE && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 1.27 * (1 - ad_60) && ld_80 <= 1.618 * (ad_60 + 1.0) && ld_88 >= 1.618 * (1 - ad_60) && ld_88 <= 2.618 * (ad_60 +
      1.0) && ld_72 >= 0.618 * (1 - ad_60) && ld_72 <= 0.786 * (ad_60 + 1.0) && (ld_112 >= 1.0 * ld_104 * (1 - ad_60) && ld_112 <= 1.618 * ld_104 * (ad_60 + 1.0)))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 < ad_4) {
         HAR_FoundPatterns_Increase(9);
         SIGMON_FoundPatterns_Set(4, 1);
         return (9);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 > ad_4) {
         HAR_FoundPatterns_Increase(10);
         SIGMON_FoundPatterns_Set(4, -1);
         return (10);
      }
   } else {
      if ((bextCrab && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 1.272 * (1 - ad_60) && ld_80 <= 1.618 * (ad_60 + 1.0) && ld_88 >= 2.24 * (1 - ad_60) &&
         ld_88 <= 3.618 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.618 * (ad_60 + 1.0) && (li_132 >= 0.618 * li_136 * (1 - ad_60) && li_132 <= 2.618 * li_136 * (ad_60 +
         1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1))) || (bextCrab && bextIdealCrabOnly == FALSE && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 +
         1.0) && ld_80 >= 1.272 * (1 - ad_60) && ld_80 <= 1.618 * (ad_60 + 1.0) && ld_88 >= 2.24 * (1 - ad_60) && ld_88 <= 3.618 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 &&
         ld_72 <= 0.886 * (ad_60 + 1.0) && (li_132 >= 0.618 * li_136 * (1 - ad_60) && li_132 <= 1.618 * li_136 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 &&
         li_152 > 1)))) {
         if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 < ad_4) {
            HAR_FoundPatterns_Increase(11);
            SIGMON_FoundPatterns_Set(5, 1);
            return (11);
         }
         if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 > ad_4) {
            HAR_FoundPatterns_Increase(12);
            SIGMON_FoundPatterns_Set(5, -1);
            return (12);
         }
      }
      if ((bextBat && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 0.886 * (1 - ad_60) && ld_80 <= 0.886 * (ad_60 + 1.0) && ld_88 >= 1.618 * (1 - ad_60) &&
         ld_88 <= 2.618 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= (ad_60 + 1.0) / 2.0 && (ld_112 >= 1.27 * ld_104 * (1 - ad_60) && ld_112 <= 1.618 * ld_104 * (ad_60 +
         1.0)) && (li_128 >= 0.618 * li_140 * (1 - ad_60) && li_128 <= 2.618 * li_140 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1))) || (bextBat &&
         bextIdealBatOnly == FALSE && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 0.886 * (1 - ad_60) && ld_80 <= 0.886 * (ad_60 + 1.0) && ld_88 >= 1.618 * (1 - ad_60) && ld_88 <= 2.618 * (ad_60 +
         1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.577 * (ad_60 + 1.0) && (li_128 >= 0.618 * li_140 * (1 - ad_60) && li_128 <= 2.618 * li_140 * (ad_60 + 1.0) && (li_140 > 1 &&
         li_144 > 1 && li_148 > 1 && li_152 > 1)))) {
         if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 > ad_4) {
            HAR_FoundPatterns_Increase(13);
            SIGMON_FoundPatterns_Set(6, 1);
            return (13);
         }
         if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 < ad_4) {
            HAR_FoundPatterns_Increase(14);
            SIGMON_FoundPatterns_Set(6, -1);
            return (14);
         }
      }
   }
   if ((bextIdealGartleyOnly && ai_68 && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= 0.618 * (1 - ad_60) && ld_72 <= 0.618 * (ad_60 + 1.0) &&
      ld_88 >= 1.27 * dextEmergingPatternPerc * (1 - ad_60) && ld_88 <= 1.618 * (ad_60 + 1.0) && (ld_80 >= 0.786 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 0.786 * (ad_60 +
      1.0)) && (ld_112 >= dextEmergingPatternPerc * ld_104 * (1 - ad_60) && ld_112 <= ld_104 * (ad_60 + 1.0)) && (li_128 >= 0.618 * (dextEmergingPatternPerc * li_140) * (1 - ad_60) &&
      li_128 <= 2.618 * li_140 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1)) && MathAbs(ad_40 - High[0]) >= dextEmergingPatternPerc * ld_104 * (1 - ad_60) &&
      MathAbs(ad_40 - High[0]) <= ld_104 * (ad_60 + 1.0)) || (bextGartley && ai_68 && bextIdealGartleyOnly == FALSE && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 +
      1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.618 * (ad_60 + 1.0) && ld_88 >= 1.27 * dextEmergingPatternPerc * (1 - ad_60) && ld_88 <= 2.2236 * (ad_60 + 1.0) &&
      (ld_80 >= 0.577 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 0.786 * (ad_60 + 1.0)) && (li_128 >= 0.618 * (dextEmergingPatternPerc * li_140) * (1 - ad_60) &&
      li_128 <= 2.618 * li_140 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1)) && MathAbs(ad_40 - High[0]) >= dextEmergingPatternPerc * ld_104 * (1 - ad_60) &&
      MathAbs(ad_40 - High[0]) <= ld_104 * (ad_60 + 1.0))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 > ad_4 && ad_52 <= ad_28) {
         HAR_FoundPatterns_Increase(15);
         SIGMON_FoundPatterns_Set(3, 2);
         return (15);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 < ad_4 && ad_52 >= ad_28) {
         HAR_FoundPatterns_Increase(16);
         SIGMON_FoundPatterns_Set(3, -2);
         return (16);
      }
   }
   if ((bextIdealButterflyOnly && ai_68 && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= 0.786 * (1 - ad_60) && ld_72 <= 0.786 * (ad_60 + 1.0) &&
      ld_88 >= 1.618 * dextEmergingPatternPerc * (1 - ad_60) && ld_88 <= 2.618 * (ad_60 + 1.0) && (ld_80 >= 1.27 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 1.618 * (ad_60 +
      1.0)) && (ld_112 >= 1.0 * (dextEmergingPatternPerc * ld_104) * (1 - ad_60) && ld_112 <= 1.0 * ld_104 * (ad_60 + 1.0)) && (li_132 >= 0.618 * (dextEmergingPatternPerc * li_136) * (1 - ad_60) &&
      li_132 <= 2.618 * li_136 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1)) && MathAbs(ad_40 - High[0]) >= 1.0 * (dextEmergingPatternPerc * ld_104) * (1 - ad_60) &&
      MathAbs(ad_40 - High[0]) <= 1.0 * ld_104 * (ad_60 + 1.0)) || (bextButterfly && ai_68 && bextIdealGartleyOnly == FALSE && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 +
      1.0) && ld_72 >= 0.618 * (1 - ad_60) && ld_72 <= 0.786 * (ad_60 + 1.0) && ld_88 >= 1.618 * dextEmergingPatternPerc * (1 - ad_60) && ld_88 <= 2.618 * (ad_60 + 1.0) &&
      (ld_80 >= 1.27 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 1.618 * (ad_60 + 1.0)) && (ld_112 >= 1.0 * (dextEmergingPatternPerc * ld_104) * (1 - ad_60) && ld_112 <= 1.618 * ld_104 * (ad_60 +
      1.0)) && (li_132 >= 0.618 * (dextEmergingPatternPerc * li_136) * (1 - ad_60) && li_132 <= 2.618 * li_136 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1)) && MathAbs(ad_40 - High[0]) >= 1.0 * (dextEmergingPatternPerc * ld_104) * (1 - ad_60) && MathAbs(ad_40 - High[0]) <= 1.618 * ld_104 * (ad_60 +
      1.0))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 < ad_4) {
         HAR_FoundPatterns_Increase(17);
         SIGMON_FoundPatterns_Set(4, 2);
         return (17);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 > ad_4) {
         HAR_FoundPatterns_Increase(18);
         SIGMON_FoundPatterns_Set(4, -2);
         return (18);
      }
   }
   if (bextCrab && ai_68 && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.618 * (ad_60 + 1.0) && ld_88 >= 2.24 * dextEmergingPatternPerc * (1 - ad_60) &&
      ld_88 <= 3.618 * (ad_60 + 1.0) && (ld_80 >= 1.272 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 1.618 * (ad_60 + 1.0)) && (li_132 >= 0.618 * (dextEmergingPatternPerc * li_136) * (1 - ad_60) &&
      li_132 <= 1.618 * li_136 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1)) && MathAbs(ad_16 - High[0]) >= 1.272 * (dextEmergingPatternPerc * ld_120) * (1 - ad_60) &&
      MathAbs(ad_16 - High[0]) <= 1.618 * ld_120 * (ad_60 + 1.0)) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 < ad_4) {
         HAR_FoundPatterns_Increase(19);
         SIGMON_FoundPatterns_Set(5, 2);
         return (19);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 > ad_4) {
         HAR_FoundPatterns_Increase(20);
         SIGMON_FoundPatterns_Set(5, -2);
         return (20);
      }
   }
   if ((bextBat && bextIdealBatOnly && ai_68 && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= (ad_60 + 1.0) / 2.0 &&
      ld_88 >= 1.618 * dextEmergingPatternPerc * (1 - ad_60) && ld_88 <= 2.618 * (ad_60 + 1.0) && (ld_80 >= 0.886 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 0.886 * (ad_60 +
      1.0)) && (ld_112 >= 1.27 * (dextEmergingPatternPerc * ld_104) * (1 - ad_60) && ld_112 <= 1.618 * ld_104 * (ad_60 + 1.0)) && (li_128 >= 0.618 * (dextEmergingPatternPerc * li_140) * (1 - ad_60) &&
      li_128 <= 1.618 * li_140 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1))) || (bextBat && ai_68 && bextIdealGartleyOnly == FALSE && ld_96 >= (1 - ad_60) / 2.0 &&
      ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.577 * (ad_60 + 1.0) && ld_88 >= 1.618 * dextEmergingPatternPerc * (1 - ad_60) && ld_88 <= 2.618 * (ad_60 +
      1.0) && (ld_80 >= 0.886 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 0.886 * (ad_60 + 1.0)) && (ld_112 >= 1.27 * (dextEmergingPatternPerc * ld_104) * (1 - ad_60) && ld_112 <= 1.618 * ld_104 * (ad_60 +
      1.0)) && (li_128 >= 0.618 * (dextEmergingPatternPerc * li_140) * (1 - ad_60) && li_128 <= 1.618 * li_140 * (ad_60 + 1.0) && (li_140 > 1 && li_144 > 1 && li_148 > 1 && li_152 > 1)))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 > ad_4 && ad_52 < ad_28) {
         HAR_FoundPatterns_Increase(21);
         SIGMON_FoundPatterns_Set(6, 2);
         return (21);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 < ad_4 && ad_52 > ad_28) {
         HAR_FoundPatterns_Increase(22);
         SIGMON_FoundPatterns_Set(6, -2);
         return (22);
      }
   }
   return (0);
}

int Is_SHSPattern(int ai_unused_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, double ad_72, double ad_80) {
   if (ad_28 - ad_40 == 0.0) return (0);
   double ld_88 = (ad_52 - ad_40) / (ad_28 - ad_40);
   double ld_96 = MathAbs(ad_28 - ad_16);
   double ld_104 = MathAbs(ad_64 - ad_52);
   double ld_112 = MathAbs(ad_40 - ad_28);
   double ld_120 = MathAbs(ad_40 - ad_52);
   int li_128 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_24);
   int li_132 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   int li_136 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_140 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   if (bextI_SHS) {
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_40 < ad_52 && ad_40 < ad_64 && ad_52 > ad_64 && ld_96 > ld_104 * (1 - ad_72) &&
         ld_96 < ld_104 * (ad_72 + 1.0) && li_128 > li_132 * (1 - ad_80) && li_128 < li_132 * (ad_80 + 1.0) && ld_112 > ld_120 * (1 - ad_72) && ld_112 < ld_120 * (ad_72 + 1.0) && li_136 > li_140 * (1 - ad_80) && li_136 < li_140 * (ad_80 +
         1.0)) {
         HAR_FoundPatterns_Increase(31);
         SIGMON_FoundPatterns_Set(7, 1);
         return (31);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_40 > ad_52 && ad_40 > ad_64 && ad_52 < ad_64 && ld_96 > ld_104 * (1 - ad_72) &&
         ld_96 < ld_104 * (ad_72 + 1.0) && li_128 > li_132 * (1 - ad_80) && li_128 < li_132 * (ad_80 + 1.0) && ld_112 > ld_120 * (1 - ad_72) && ld_112 < ld_120 * (ad_72 + 1.0) && li_136 > li_140 * (1 - ad_80) && li_136 < li_140 * (ad_80 +
         1.0)) {
         HAR_FoundPatterns_Increase(32);
         SIGMON_FoundPatterns_Set(7, -1);
         return (32);
      }
   }
   if (bextSHS) {
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_40 < ad_52 && ad_40 < ad_64 && ad_52 > ad_64 && ld_96 > ld_104 * (1 - ad_72) &&
         ld_96 < ld_104 * (ad_72 + 1.0) && ld_112 > ld_120 * (1 - ad_72) && ld_112 < ld_120 * (ad_72 + 1.0)) {
         HAR_FoundPatterns_Increase(29);
         SIGMON_FoundPatterns_Set(7, 1);
         return (29);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_40 > ad_52 && ad_40 > ad_64 && ad_52 < ad_64 && ld_96 > ld_104 * (1 - ad_72) &&
         ld_96 < ld_104 * (ad_72 + 1.0) && ld_112 > ld_120 * (1 - ad_72) && ld_112 < ld_120 * (ad_72 + 1.0)) {
         HAR_FoundPatterns_Increase(30);
         SIGMON_FoundPatterns_Set(7, -1);
         return (30);
      }
   }
   return (0);
}

int Is_3DrivesPattern(int ai_unused_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, double ad_72) {
   if (ad_16 - ad_28 == 0.0 || ad_40 - ad_52 == 0.0 || ad_16 - ad_4 == 0.0 || ad_40 - ad_28 == 0.0) return (0);
   double ld_80 = MathAbs((ad_40 - ad_28) / (ad_16 - ad_28));
   double ld_88 = MathAbs((ad_64 - ad_52) / (ad_40 - ad_52));
   double ld_96 = MathAbs((ad_16 - ad_28) / (ad_16 - ad_4));
   double ld_104 = MathAbs((ad_40 - ad_52) / (ad_40 - ad_28));
   double ld_112 = MathAbs(ad_28 - ad_16);
   double ld_120 = MathAbs(ad_40 - ad_52);
   int li_128 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_24);
   int li_132 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   int li_136 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_140 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   if (bext3Drives) {
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_40 < ad_52 && ad_40 > ad_64 && ad_52 > ad_64 && (ld_80 >= 1.27 * (1 - ad_72) &&
         ld_80 <= 1.27 * (ad_72 + 1.0) && (ld_88 >= 1.27 * (1 - ad_72) && ld_88 <= 1.27 * (ad_72 + 1.0))) || (ld_80 >= 1.618 * (1 - ad_72) && ld_80 <= 1.618 * (ad_72 + 1.0) && (ld_88 >= 1.618 * (1 - ad_72) && ld_88 <= 1.618 * (ad_72 +
         1.0))) && ld_104 >= 0.618 * (1 - ad_72) && ld_104 <= 0.786 * (ad_72 + 1.0) && (li_128 >= 0.786 * li_132 * (1 - ad_72) && li_128 <= 1.272 * li_132 * (ad_72 + 1.0)) &&
         (li_136 >= 0.786 * li_140 * (1 - ad_72) && li_136 <= 1.272 * li_140 * (ad_72 + 1.0))) {
         HAR_FoundPatterns_Increase(23);
         SIGMON_FoundPatterns_Set(8, 1);
         return (23);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_40 > ad_52 && ad_40 < ad_64 && ad_52 < ad_64 && (ld_80 >= 1.27 * (1 - ad_72) &&
         ld_80 <= 1.27 * (ad_72 + 1.0) && (ld_88 >= 1.27 * (1 - ad_72) && ld_88 <= 1.27 * (ad_72 + 1.0))) || (ld_80 >= 1.618 * (1 - ad_72) && ld_80 <= 1.618 * (ad_72 + 1.0) && (ld_88 >= 1.618 * (1 - ad_72) && ld_88 <= 1.618 * (ad_72 +
         1.0))) && ld_104 >= 0.618 * (1 - ad_72) && ld_104 <= 0.786 * (ad_72 + 1.0) && (li_128 >= 0.786 * li_132 * (1 - ad_72) && li_128 <= 1.272 * li_132 * (ad_72 + 1.0)) &&
         (li_136 >= 0.786 * li_140 * (1 - ad_72) && li_136 <= 1.272 * li_140 * (ad_72 + 1.0))) {
         HAR_FoundPatterns_Increase(24);
         SIGMON_FoundPatterns_Set(8, -1);
         return (24);
      }
   }
   return (0);
}

int Is_5_0Pattern(double ad_0, double ad_8, double ad_16, double ad_24, double ad_32, double ad_40, double ad_48) {
   if (ad_8 - ad_16 == 0.0 || ad_16 - ad_24 == 0.0 || ad_24 - ad_32 == 0.0) return (0);
   double ld_56 = MathAbs((ad_24 - ad_16) / (ad_8 - ad_16));
   double ld_64 = MathAbs((ad_32 - ad_24) / (ad_16 - ad_24));
   double ld_72 = MathAbs((ad_40 - ad_32) / (ad_24 - ad_32));
   double ld_80 = MathAbs(ad_24 - ad_16);
   double ld_88 = MathAbs(ad_40 - ad_32);
   if (bext5_0) {
      if (ad_0 > ad_8 && ad_16 > ad_8 && ad_16 > ad_24 && ad_32 > ad_16 && ad_32 > ad_24 && ad_32 > ad_40 && (ld_56 >= 1.13 * (1 - ad_48) && ld_56 <= 1.618 * (ad_48 + 1.0)) &&
         (ld_64 >= 1.618 * (1 - ad_48) && ld_64 <= 2.24 * (ad_48 + 1.0)) && (ld_72 >= (1 - ad_48) / 2.0 && ld_72 <= (ad_48 + 1.0) / 2.0) && (ld_80 >= ld_88 * (1 - ad_48) &&
         ld_80 <= ld_88 * (ad_48 + 1.0))) {
         HAR_FoundPatterns_Increase(25);
         SIGMON_FoundPatterns_Set(9, 1);
         return (25);
      }
      if (ad_0 < ad_8 && ad_16 < ad_8 && ad_16 < ad_24 && ad_32 < ad_16 && ad_32 < ad_24 && ad_32 < ad_40 && (ld_56 >= 1.13 * (1 - ad_48) && ld_56 <= 1.618 * (ad_48 + 1.0)) &&
         (ld_64 >= 1.618 * (1 - ad_48) && ld_64 <= 2.24 * (ad_48 + 1.0)) && (ld_72 >= (1 - ad_48) / 2.0 && ld_72 <= (ad_48 + 1.0) / 2.0) && (ld_80 >= ld_88 * (1 - ad_48) &&
         ld_80 <= ld_88 * (ad_48 + 1.0))) {
         HAR_FoundPatterns_Increase(26);
         SIGMON_FoundPatterns_Set(9, -1);
         return (26);
      }
   }
   return (0);
}

int Is_TriangleC1(int ai_unused_0, double ad_4, int ai_unused_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, int ai_72, double ad_76, double ad_unused_84) {
   if (ad_28 == ad_40 || ad_64 == ad_52 || ad_64 == ad_28 || ad_16 == ad_28 || ad_40 == ad_52) return (0);
   double ld_92 = MathAbs((ad_52 - ad_40) / (ad_28 - ad_40));
   double ld_100 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_52));
   double ld_108 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_28));
   double ld_116 = MathAbs((ad_40 - ad_28) / (ad_16 - ad_28));
   double ld_124 = MathAbs((ad_64 - ad_52) / (ad_40 - ad_52));
   double ld_132 = MathAbs(ad_16 - ad_28);
   double ld_140 = MathAbs(ad_40 - ad_28);
   double ld_148 = MathAbs(ad_52 - ad_40);
   double ld_156 = MathAbs(ad_64 - ad_52);
   double ld_164 = MathAbs(ad_76 - ad_64);
   int li_172 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_176 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   int li_180 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   int li_184 = iBarShift(Symbol(), Period(), ai_60) - iBarShift(Symbol(), Period(), ai_72);
   if (gi_548) {
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_28 < ad_40 && ad_40 > ad_52 && ad_52 < ad_64 && ad_64 > ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.15 && ld_124 >= 0.5 &&
         ld_100 >= 0.5 && ld_124 <= 1.0 && ld_108 <= 1.0 && ld_100 <= 1.272 && ld_116 <= 2.618) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(56);
         SIGMON_FoundPatterns_Set(13, -1);
         return (56);
      }
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_28 > ad_40 && ad_40 < ad_52 && ad_52 > ad_64 && ad_64 < ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.15 && ld_124 >= 0.5 &&
         ld_100 >= 0.5 && ld_124 <= 1.0 && ld_108 <= 1.0 && ld_100 <= 1.272 && ld_116 <= 2.618) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(57);
         SIGMON_FoundPatterns_Set(13, -1);
         return (57);
      }
   }
   return (0);
}

int Is_IConTriangle(int ai_unused_0, double ad_4, int ai_unused_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, int ai_72, double ad_76, double ad_unused_84) {
   if (ad_28 == ad_40 || ad_64 == ad_52 || ad_64 == ad_28 || ad_16 == ad_28 || ad_40 == ad_52) return (0);
   double ld_92 = MathAbs((ad_52 - ad_40) / (ad_28 - ad_40));
   double ld_100 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_52));
   double ld_108 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_28));
   double ld_116 = MathAbs((ad_40 - ad_28) / (ad_16 - ad_28));
   double ld_124 = MathAbs((ad_64 - ad_52) / (ad_40 - ad_52));
   double ld_132 = MathAbs(ad_40 - ad_28);
   double ld_140 = MathAbs(ad_16 - ad_28);
   double ld_148 = MathAbs(ad_52 - ad_40);
   double ld_156 = MathAbs(ad_64 - ad_52);
   double ld_164 = MathAbs(ad_76 - ad_64);
   int li_172 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_176 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   int li_180 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   int li_184 = iBarShift(Symbol(), Period(), ai_60) - iBarShift(Symbol(), Period(), ai_72);
   if (gi_552) {
      if (ad_4 < ad_16 && ad_16 > ad_28 && ad_28 < ad_40 && ad_40 > ad_52 && ad_52 < ad_64 && ad_64 > ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.382 && ld_124 >= 0.5 && ld_124 <= 1.08 &&
         ld_100 >= 0.25 && ld_100 <= 1.1 && ld_116 <= 1.08 && ld_116 >= 0.49 && ld_140 > ld_148 || ld_140 > ld_156 || ld_140 > ld_164 || ld_132 > ld_148 || ld_132 > ld_156 ||
         ld_132 > ld_164) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(60);
         SIGMON_FoundPatterns_Set(13, -1);
         return (60);
      }
      if (ad_4 > ad_16 && ad_16 < ad_28 && ad_28 > ad_40 && ad_40 < ad_52 && ad_52 > ad_64 && ad_64 < ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.382 && ld_124 >= 0.5 && ld_124 <= 1.08 &&
         ld_100 >= 0.25 && ld_100 <= 1.1 && ld_116 <= 1.08 && ld_116 >= 0.49 && ld_140 > ld_148 || ld_140 > ld_156 || ld_140 > ld_164 || ld_132 > ld_148 || ld_132 > ld_156 ||
         ld_132 > ld_164) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(61);
         SIGMON_FoundPatterns_Set(13, -1);
         return (61);
      }
   }
   return (0);
}

int Is_NIConTriangle(int ai_unused_0, double ad_4, int ai_unused_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, int ai_72, double ad_76, double ad_unused_84) {
   if (ad_28 == ad_40 || ad_64 == ad_52 || ad_64 == ad_28 || ad_16 == ad_28 || ad_40 == ad_52) return (0);
   double ld_92 = MathAbs((ad_52 - ad_40) / (ad_28 - ad_40));
   double ld_100 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_52));
   double ld_108 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_28));
   double ld_116 = MathAbs((ad_40 - ad_28) / (ad_16 - ad_28));
   double ld_124 = MathAbs((ad_64 - ad_52) / (ad_40 - ad_52));
   double ld_132 = MathAbs(ad_40 - ad_28);
   double ld_140 = MathAbs(ad_16 - ad_28);
   double ld_148 = MathAbs(ad_52 - ad_40);
   double ld_156 = MathAbs(ad_64 - ad_52);
   double ld_164 = MathAbs(ad_76 - ad_64);
   int li_172 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_176 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   int li_180 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   int li_184 = iBarShift(Symbol(), Period(), ai_60) - iBarShift(Symbol(), Period(), ai_72);
   if (gi_556) {
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_28 < ad_40 && ad_40 > ad_52 && ad_52 < ad_64 && ad_64 > ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.382 && ld_124 >= 0.5 &&
         ld_124 <= 1.08 && ld_100 >= 0.25 && ld_100 <= 1.1 && ld_116 <= 1.08 && ld_116 >= 0.49 && ld_140 > ld_148 || ld_140 > ld_156 || ld_140 > ld_164 || ld_132 > ld_148 ||
         ld_132 > ld_156 || ld_132 > ld_164) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(62);
         SIGMON_FoundPatterns_Set(13, -1);
         return (62);
      }
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_28 > ad_40 && ad_40 < ad_52 && ad_52 > ad_64 && ad_64 < ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.382 && ld_124 >= 0.5 &&
         ld_124 <= 1.08 && ld_100 >= 0.25 && ld_100 <= 1.1 && ld_116 <= 1.08 && ld_116 >= 0.49 && ld_140 > ld_148 || ld_140 > ld_156 || ld_140 > ld_164 || ld_132 > ld_148 ||
         ld_132 > ld_156 || ld_132 > ld_164) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(63);
         SIGMON_FoundPatterns_Set(13, -1);
         return (63);
      }
   }
   return (0);
}

int Is_DiaTriangle(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, double ad_unused_72) {
   double ld_104;
   double ld_112;
   double ld_120;
   int li_80 = -1 * iBarShift(Symbol(), Period(), ai_0);
   int li_84 = -1 * iBarShift(Symbol(), Period(), ai_12);
   int li_88 = -1 * iBarShift(Symbol(), Period(), ai_24);
   int li_92 = -1 * iBarShift(Symbol(), Period(), ai_36);
   int li_96 = -1 * iBarShift(Symbol(), Period(), ai_48);
   int li_100 = -1 * iBarShift(Symbol(), Period(), ai_60);
   if (li_80 - li_88 == 0 || li_88 - li_96 == 0 || li_84 - li_92 == 0 || li_84 - li_100 == 0) return (0);
   if (gi_560) {
      ld_120 = (ad_28 - ad_52) / (li_88 - li_96);
      ld_104 = (ad_16 - ad_40) / (li_84 - li_92);
      ld_112 = ad_16 - ld_104 * li_84;
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_4 > ad_40 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_28 > ad_52 && ad_40 < ad_52 && ad_40 > ad_64 && ad_52 > ad_64 &&
         ld_104 > ld_120 && ad_64 >= ld_104 * li_100 + ld_112 - 5.0 * Point && ad_64 <= ld_104 * li_100 + ld_112 + 5.0 * Point) {
         HAR_FoundPatterns_Increase(58);
         SIGMON_FoundPatterns_Set(14, -1);
         return (58);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_4 < ad_40 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_28 < ad_52 && ad_40 > ad_52 && ad_40 < ad_64 && ad_52 < ad_64 &&
         ld_104 < ld_120 && ad_64 >= ld_104 * li_100 + ld_112 - 5.0 * Point && ad_64 <= ld_104 * li_100 + ld_112 + 5.0 * Point) {
         HAR_FoundPatterns_Increase(59);
         SIGMON_FoundPatterns_Set(14, -1);
         return (59);
      }
      ld_104 = (ad_16 - ad_64) / (li_84 - li_100);
      ld_112 = ad_16 - ld_104 * li_84;
      ld_120 = (ad_28 - ad_52) / (li_88 - li_96);
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_4 > ad_40 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_28 > ad_52 && ad_40 < ad_52 && ad_40 > ad_64 && ad_52 > ad_64 &&
         ld_104 > ld_120 && ad_40 >= ld_104 * li_92 + ld_112 - 5.0 * Point && ad_40 <= ld_104 * li_92 + ld_112 + 5.0 * Point) {
         HAR_FoundPatterns_Increase(58);
         SIGMON_FoundPatterns_Set(14, -1);
         return (58);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_4 < ad_40 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_28 < ad_52 && ad_40 > ad_52 && ad_40 < ad_64 && ad_52 < ad_64 &&
         ld_104 < ld_120 && ad_40 >= ld_104 * li_92 + ld_112 - 5.0 * Point && ad_40 <= ld_104 * li_92 + ld_112 + 5.0 * Point) {
         HAR_FoundPatterns_Increase(59);
         SIGMON_FoundPatterns_Set(14, -1);
         return (59);
      }
   }
   return (0);
}

int Is_OmarPattern(double ad_0, double ad_8, double ad_16, double ad_24, double ad_32, double ad_40) {
   double ld_48 = MathAbs(ad_16 - ad_8);
   double ld_56 = MathAbs(ad_32 - ad_24);
   double ld_64 = MathAbs(ad_24 - ad_16);
   if (gi_528) {
      if (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_16 < ad_32 && ad_24 > ad_32 && ad_32 < ad_8 &&
         (ld_56 >= 0.707 * ld_48 * (1 - ad_40) && ld_56 <= 0.707 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 0.786 * ld_48 * (1 - ad_40) && ld_56 <= 0.786 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 0.886 * ld_48 * (1 - ad_40) && ld_56 <= 0.886 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.0 * ld_48 * (1 - ad_40) && ld_56 <= 1.0 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 0.707 * ld_64 * (1 - ad_40) && ld_56 <= 0.707 * ld_64 * (ad_40 +
         1.0)) || (ld_56 >= 0.786 * ld_64 * (1 - ad_40) && ld_56 <= 0.786 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 0.886 * ld_64 * (1 - ad_40) && ld_56 <= 0.886 * ld_64 * (ad_40 + 1.0)) &&
         ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) {
         HAR_FoundPatterns_Increase(45);
         SIGMON_FoundPatterns_Set(20, 1);
         return (45);
      }
      if (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32 && ad_32 > ad_8 &&
         (ld_56 >= 0.707 * ld_48 * (1 - ad_40) && ld_56 <= 0.707 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 0.786 * ld_48 * (1 - ad_40) && ld_56 <= 0.786 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 0.886 * ld_48 * (1 - ad_40) && ld_56 <= 0.886 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.0 * ld_48 * (1 - ad_40) && ld_56 <= 1.0 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 0.707 * ld_64 * (1 - ad_40) && ld_56 <= 0.707 * ld_64 * (ad_40 +
         1.0)) || (ld_56 >= 0.786 * ld_64 * (1 - ad_40) && ld_56 <= 0.786 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 0.886 * ld_64 * (1 - ad_40) && ld_56 <= 0.886 * ld_64 * (ad_40 + 1.0)) &&
         ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) {
         HAR_FoundPatterns_Increase(46);
         SIGMON_FoundPatterns_Set(20, -1);
         return (46);
      }
      if (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 > ad_24 && ad_16 < ad_24 && ad_16 > ad_32 && ad_24 > ad_32 && ad_32 < ad_8 &&
         (ld_64 >= 0.618 * ld_48 * (1 - ad_40) && ld_64 <= 0.618 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 0.707 * ld_48 * (1 - ad_40) && ld_64 <= 0.707 * ld_48 * (ad_40 + 1.0)) ||
         (ld_64 >= 0.786 * ld_48 * (1 - ad_40) && ld_64 <= 0.786 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.0 * ld_48 * (1 - ad_40) && ld_56 <= 1.0 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.272 * ld_48 * (1 - ad_40) && ld_56 <= 1.272 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.414 * ld_48 * (1 - ad_40) && ld_56 <= 1.414 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.272 * ld_64 * (1 - ad_40) && ld_56 <= 1.272 * ld_64 * (ad_40 +
         1.0)) || (ld_56 >= 1.414 * ld_64 * (1 - ad_40) && ld_56 <= 1.414 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 1.618 * ld_64 * (1 - ad_40) && ld_56 <= 1.618 * ld_64 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(47);
         SIGMON_FoundPatterns_Set(21, 1);
         return (47);
      }
      if (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 < ad_24 && ad_16 > ad_24 && ad_16 < ad_32 && ad_24 < ad_32 && ad_32 > ad_8 &&
         (ld_64 >= 0.618 * ld_48 * (1 - ad_40) && ld_64 <= 0.618 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 0.707 * ld_48 * (1 - ad_40) && ld_64 <= 0.707 * ld_48 * (ad_40 + 1.0)) ||
         (ld_64 >= 0.786 * ld_48 * (1 - ad_40) && ld_64 <= 0.786 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.0 * ld_48 * (1 - ad_40) && ld_56 <= 1.0 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.272 * ld_48 * (1 - ad_40) && ld_56 <= 1.272 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.414 * ld_48 * (1 - ad_40) && ld_56 <= 1.414 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.272 * ld_64 * (1 - ad_40) && ld_56 <= 1.272 * ld_64 * (ad_40 +
         1.0)) || (ld_56 >= 1.414 * ld_64 * (1 - ad_40) && ld_56 <= 1.414 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 1.618 * ld_64 * (1 - ad_40) && ld_56 <= 1.618 * ld_64 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(48);
         SIGMON_FoundPatterns_Set(21, -1);
         return (48);
      }
      if (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 > ad_24 && ad_16 < ad_24 && ad_16 < ad_32 && ad_24 > ad_32 && ad_32 < ad_8 &&
         (ld_64 >= 0.707 * ld_48 * (1 - ad_40) && ld_64 <= 0.707 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 0.786 * ld_48 * (1 - ad_40) && ld_64 <= 0.786 * ld_48 * (ad_40 + 1.0)) ||
         (ld_64 >= 0.886 * ld_48 * (1 - ad_40) && ld_64 <= 0.886 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 1.0 * ld_48 * (1 - ad_40) && ld_64 <= 1.0 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= ld_48 / 2.0 * (1 - ad_40) && ld_56 <= ld_48 / 2.0 * (ad_40 +
         1.0)) || (ld_56 >= 0.618 * ld_48 * (1 - ad_40) && ld_56 <= 0.618 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 0.707 * ld_64 * (1 - ad_40) && ld_56 <= 0.707 * ld_64 * (ad_40 + 1.0)) ||
         (ld_56 >= 0.786 * ld_64 * (1 - ad_40) && ld_56 <= 0.786 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 0.886 * ld_64 * (1 - ad_40) && ld_56 <= 0.886 * ld_64 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(49);
         SIGMON_FoundPatterns_Set(22, 1);
         return (49);
      }
      if (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 < ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32 && ad_32 > ad_8 &&
         (ld_64 >= 0.707 * ld_48 * (1 - ad_40) && ld_64 <= 0.707 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 0.786 * ld_48 * (1 - ad_40) && ld_64 <= 0.786 * ld_48 * (ad_40 + 1.0)) ||
         (ld_64 >= 0.886 * ld_48 * (1 - ad_40) && ld_64 <= 0.886 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 1.0 * ld_48 * (1 - ad_40) && ld_64 <= 1.0 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= ld_48 / 2.0 * (1 - ad_40) && ld_56 <= ld_48 / 2.0 * (ad_40 +
         1.0)) || (ld_56 >= 0.618 * ld_48 * (1 - ad_40) && ld_56 <= 0.618 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 0.707 * ld_64 * (1 - ad_40) && ld_56 <= 0.707 * ld_64 * (ad_40 + 1.0)) ||
         (ld_56 >= 0.786 * ld_64 * (1 - ad_40) && ld_56 <= 0.786 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 0.886 * ld_64 * (1 - ad_40) && ld_56 <= 0.886 * ld_64 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(50);
         SIGMON_FoundPatterns_Set(22, -1);
         return (50);
      }
      if (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_16 > ad_32 && ad_24 > ad_32 && ad_32 < ad_8 &&
         (ld_56 >= 1.272 * ld_48 * (1 - ad_40) && ld_56 <= 1.272 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.414 * ld_48 * (1 - ad_40) && ld_56 <= 1.414 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.618 * ld_48 * (1 - ad_40) && ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.272 * ld_64 * (1 - ad_40) && ld_56 <= 1.272 * ld_64 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.414 * ld_64 * (1 - ad_40) && ld_56 <= 1.414 * ld_64 * (ad_40 + 1.0)) && ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) {
         HAR_FoundPatterns_Increase(51);
         SIGMON_FoundPatterns_Set(23, 1);
         return (51);
      }
      if (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 < ad_32 && ad_24 < ad_32 && ad_32 > ad_8 &&
         (ld_56 >= 1.272 * ld_48 * (1 - ad_40) && ld_56 <= 1.272 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.414 * ld_48 * (1 - ad_40) && ld_56 <= 1.414 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.618 * ld_48 * (1 - ad_40) && ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.272 * ld_64 * (1 - ad_40) && ld_56 <= 1.272 * ld_64 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.414 * ld_64 * (1 - ad_40) && ld_56 <= 1.414 * ld_64 * (ad_40 + 1.0)) && ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) {
         HAR_FoundPatterns_Increase(52);
         SIGMON_FoundPatterns_Set(23, -1);
         return (52);
      }
   }
   return (0);
}

int Is_VibrationPattern(int ai_0, double ad_4, int ai_12, double ad_16, double ad_24, double ad_32) {
   bool li_60;
   bool li_64;
   double ld_68;
   double ld_76;
   double ld_48 = 10000.0 * MathAbs(ad_4 - ad_16);
   int li_56 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_12);
   for (int l_index_40 = 0; l_index_40 <= 7; l_index_40++) {
      for (int l_index_44 = 0; l_index_44 <= 7; l_index_44++) {
         li_60 = FALSE;
         li_64 = FALSE;
         ld_68 = gda_600[l_index_40];
         ld_76 = gda_604[l_index_44];
         if (ld_48 > ld_68 * (1 - ad_24) && ld_48 < ld_68 * (ad_24 + 1.0)) li_60 = TRUE;
         if (li_56 > ld_76 * (1 - ad_32) && li_56 < ld_76 * (ad_32 + 1.0)) li_64 = TRUE;
         if (li_60 && li_64) {
            HAR_FoundPatterns_Increase(53);
            return (53);
         }
      }
   }
   for (l_index_40 = 0; l_index_40 <= 7; l_index_40++) {
      for (l_index_44 = 0; l_index_44 <= 7; l_index_44++) {
         li_60 = FALSE;
         ld_68 = gda_600[l_index_40];
         if (ld_48 > ld_68 * (1 - ad_24) && ld_48 < ld_68 * (ad_24 + 1.0)) li_60 = TRUE;
         if (li_60) {
            HAR_FoundPatterns_Increase(54);
            return (54);
         }
      }
   }
   for (l_index_40 = 0; l_index_40 <= 7; l_index_40++) {
      for (l_index_44 = 0; l_index_44 <= 7; l_index_44++) {
         li_64 = FALSE;
         ld_76 = gda_604[l_index_44];
         if (li_56 > ld_76 * (1 - ad_32) && li_56 < ld_76 * (ad_32 + 1.0)) li_64 = TRUE;
         if (li_64) {
            HAR_FoundPatterns_Increase(55);
            return (55);
         }
      }
   }
   return (0);
}

int Is_Pattern_Fibo(int ai_unused_0, double ad_4, int ai_unused_12, double ad_16, int ai_unused_24, double ad_28, double ad_36) {
   bool li_48 = FALSE;
   if (ad_4 - ad_16 == 0.0) return (0);
   double ld_52 = (ad_28 - ad_16) / (ad_4 - ad_16);
   if (bextFibo) {
      for (int l_index_44 = 0; l_index_44 < gi_380; l_index_44++)
         if (ld_52 >= gda_376[l_index_44] * (1.0 - ad_36) && ld_52 <= gda_376[l_index_44] * (ad_36 + 1.0)) li_48 = TRUE;
      if (li_48) {
         if (ad_4 < ad_16) {
            HAR_FoundPatterns_Increase(66);
            SIGMON_FoundPatterns_Set(24, 1);
            return (66);
         }
         if (ad_4 > ad_16) {
            HAR_FoundPatterns_Increase(67);
            SIGMON_FoundPatterns_Set(24, -1);
            return (67);
         }
      }
   }
   return (0);
}

int Is_Pattern_FiboExact(int ai_unused_0, double ad_4, int ai_unused_12, double ad_16, int ai_unused_24, double ad_28, double ad_36, double ad_44) {
   if (ad_4 - ad_16 == 0.0) return (0);
   double ld_52 = (ad_28 - ad_16) / (ad_4 - ad_16);
   if (ld_52 >= ad_36 * (1.0 - ad_44) && ld_52 <= ad_36 * (ad_44 + 1.0)) {
      if (ad_36 == 0.382 && ad_4 < ad_16) {
         HAR_FoundPatterns_Increase(68);
         SIGMON_FoundPatterns_Set(15, 1);
         return (68);
      }
      if (ad_36 == 0.382 && ad_4 > ad_16) {
         HAR_FoundPatterns_Increase(69);
         SIGMON_FoundPatterns_Set(15, -1);
         return (69);
      }
      if (ad_36 == 0.5 && ad_4 < ad_16) {
         HAR_FoundPatterns_Increase(70);
         SIGMON_FoundPatterns_Set(16, 1);
         return (70);
      }
      if (ad_36 == 0.5 && ad_4 > ad_16) {
         HAR_FoundPatterns_Increase(71);
         SIGMON_FoundPatterns_Set(16, -1);
         return (71);
      }
      if (ad_36 == 0.618 && ad_4 < ad_16) {
         HAR_FoundPatterns_Increase(72);
         SIGMON_FoundPatterns_Set(17, 1);
         return (72);
      }
      if (ad_36 == 0.618 && ad_4 > ad_16) {
         HAR_FoundPatterns_Increase(73);
         SIGMON_FoundPatterns_Set(17, -1);
         return (73);
      }
      if (ad_36 == 0.786 && ad_4 < ad_16) {
         HAR_FoundPatterns_Increase(74);
         SIGMON_FoundPatterns_Set(18, 1);
         return (74);
      }
      if (ad_36 == 0.786 && ad_4 > ad_16) {
         HAR_FoundPatterns_Increase(75);
         SIGMON_FoundPatterns_Set(18, -1);
         return (75);
      }
      if (ad_36 == 0.886 && ad_4 < ad_16) {
         HAR_FoundPatterns_Increase(76);
         SIGMON_FoundPatterns_Set(19, 1);
         return (76);
      }
      if (ad_36 == 0.886 && ad_4 > ad_16) {
         HAR_FoundPatterns_Increase(77);
         SIGMON_FoundPatterns_Set(19, -1);
         return (77);
      }
   }
   return (0);
}

int Draw_Pattern_ABCD(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44) {
   if (ad_8 - ad_20 == 0.0 || ad_32 - ad_20 == 0.0) return (0);
   string l_dbl2str_52 = DoubleToStr((ad_32 - ad_20) / (ad_8 - ad_20), 3);
   string l_dbl2str_60 = DoubleToStr((ad_32 - ad_44) / (ad_32 - ad_20), 3);
   if (ai_0 == 5) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBullishColor, "AB", gsa_1060[5][1], gi_964);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBullishColor, "BC", gsa_1060[5][1], gi_964);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBullishColor, "CD", gsa_1060[5][1], gi_964);
      DrawPoint("S", ai_4, ad_8, cextABCDDescColor, "A", gsa_1060[5][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_16, ad_20, cextABCDDescColor, "B", gsa_1060[5][1], iextDescrFontSize, 0);
      DrawPoint("S", ai_28, ad_32, cextABCDDescColor, "C", gsa_1060[5][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_40, ad_44, cextABCDDescColor, "D", gsa_1060[5][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_1060[5][1], 5);
   } else {
      if (ai_0 == 6) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBearishColor, "AB", gsa_1060[6][1], gi_964);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBearishColor, "BC", gsa_1060[6][1], gi_964);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBearishColor, "CD", gsa_1060[6][1], gi_964);
         DrawPoint("L", ai_4, ad_8, cextABCDDescColor, "A", gsa_1060[6][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_16, ad_20, cextABCDDescColor, "B", gsa_1060[6][1], iextDescrFontSize, 0);
         DrawPoint("L", ai_28, ad_32, cextABCDDescColor, "C", gsa_1060[6][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_40, ad_44, cextABCDDescColor, "D", gsa_1060[6][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_1060[6][1], 6);
      } else {
         if (ai_0 == 3) {
            DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBullishColor, "AB", gsa_1060[3][1], gi_964);
            DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBullishColor, "BC", gsa_1060[3][1], gi_964);
            DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBullishColor, "CD", gsa_1060[3][1], gi_964);
            DrawPoint("S", ai_4, ad_8, cextABCDDescColor, "A", gsa_1060[3][1], iextDescrFontSize, 0);
            DrawPoint("L", ai_16, ad_20, cextABCDDescColor, "B", gsa_1060[3][1], iextDescrFontSize, 0);
            DrawPoint("S", ai_28, ad_32, cextABCDDescColor, "C", gsa_1060[3][1], iextDescrFontSize, 0);
            DrawPoint("L", ai_40, ad_44, cextABCDDescColor, "D", gsa_1060[3][1], iextDescrFontSize, 0);
            CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_1060[3][1], 3);
         } else {
            if (ai_0 == 4) {
               DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBearishColor, "AB", gsa_1060[4][1], gi_964);
               DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBearishColor, "BC", gsa_1060[4][1], gi_964);
               DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBearishColor, "CD", gsa_1060[4][1], gi_964);
               DrawPoint("L", ai_4, ad_8, cextABCDDescColor, "A", gsa_1060[4][1], iextDescrFontSize, 0);
               DrawPoint("S", ai_16, ad_20, cextABCDDescColor, "B", gsa_1060[4][1], iextDescrFontSize, 0);
               DrawPoint("L", ai_28, ad_32, cextABCDDescColor, "C", gsa_1060[4][1], iextDescrFontSize, 0);
               DrawPoint("S", ai_40, ad_44, cextABCDDescColor, "D", gsa_1060[4][1], iextDescrFontSize, 0);
               CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_1060[4][1], 4);
            } else {
               if (ai_0 == 1) {
                  DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBullishColor, "AB", gsa_1060[1][1], gi_952);
                  DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBullishColor, "BC", gsa_1060[1][1], gi_952);
                  DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBullishColor, "CD", gsa_1060[1][1], gi_952);
                  CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_1060[1][1], 1);
                  DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_52, DarkSlateGray, "relAC", gsa_1060[1][1]);
                  DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_60, DarkSlateGray, "relBD", gsa_1060[1][1]);
                  ProjectionLine(ai_40, ad_32 - (ad_8 - ad_20), Lime, "CD=AB", 0, 4, "CD=AB", gsa_1060[1][1], gi_968);
                  ProjectionLine(ai_40, ad_32 - 1.272 * (ad_8 - ad_20), Lime, "CD=1272AB", 0, 4, "CD=1272AB", gsa_1060[1][1], gi_968);
                  ProjectionLine(ai_40, ad_32 - 1.618 * (ad_8 - ad_20), Lime, "CD=1618AB", 0, 4, "CD=1618AB", gsa_1060[1][1], gi_968);
               } else {
                  if (ai_0 == 2) {
                     DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBearishColor, "AB", gsa_1060[2][1], gi_952);
                     DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBearishColor, "BC", gsa_1060[2][1], gi_952);
                     DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBearishColor, "CD", gsa_1060[2][1], gi_952);
                     CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_1060[2][1], 2);
                     DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_52, DarkSlateGray, "relAC", gsa_1060[2][1]);
                     DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_60, DarkSlateGray, "relBD", gsa_1060[2][1]);
                     if (bextDrawProjectionLines) {
                        ProjectionLine(ai_40, ad_32 - (ad_8 - ad_20), Red, "CD=AB", 0, 4, "CD=AB", gsa_1060[2][1], gi_968);
                        ProjectionLine(ai_40, ad_32 - 1.272 * (ad_8 - ad_20), Red, "CD=1272AB", 0, 4, "CD=1272AB", gsa_1060[2][1], gi_968);
                        ProjectionLine(ai_40, ad_32 - 1.618 * (ad_8 - ad_20), Red, "CD=1618AB", 0, 4, "CD=1618AB", gsa_1060[2][1], gi_968);
                     }
                  }
               }
            }
         }
      }
   }
   return (0);
}

int Draw_Pattern_WXY(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44) {
   if (ad_8 - ad_20 == 0.0 || ad_32 - ad_20 == 0.0) return (0);
   string l_dbl2str_52 = DoubleToStr((ad_32 - ad_20) / (ad_8 - ad_20), 3);
   string l_dbl2str_60 = DoubleToStr((ad_32 - ad_44) / (ad_32 - ad_20), 3);
   if (ai_0 == 64) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextWXYColor, "AB", gsa_1060[64][1], gi_964);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextWXYColor, "BC", gsa_1060[64][1], gi_964);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextWXYColor, "CD", gsa_1060[64][1], gi_964);
      CreatePatternIdentityObject(ai_4, ad_8, cextWXYColor, gsa_1060[64][1], 64);
   } else {
      if (ai_0 == 65) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextWXYColor, "AB", gsa_1060[65][1], gi_964);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextWXYColor, "BC", gsa_1060[65][1], gi_964);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextWXYColor, "CD", gsa_1060[65][1], gi_964);
         CreatePatternIdentityObject(ai_4, ad_8, cextWXYColor, gsa_1060[65][1], 65);
      }
   }
   return (0);
}

int Draw_Pattern_Batman(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44) {
   if (ai_0 == 27) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextBatmanBullishColor, "AB", gsa_1060[27][1], gi_956);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextBatmanBullishColor, "BC", gsa_1060[27][1], gi_956);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextBatmanBullishColor, "CD", gsa_1060[27][1], gi_956);
      DrawPoint("S", ai_4, ad_8, cextBatmanDescColor, "A", gsa_1060[27][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_16, ad_20, cextBatmanDescColor, "B", gsa_1060[27][1], iextDescrFontSize, 0);
      DrawPoint("S", ai_28, ad_32, cextBatmanDescColor, "C", gsa_1060[27][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_40, ad_44, cextBatmanDescColor, "D", gsa_1060[27][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, cextBatmanDescColor, gsa_1060[27][1], 27);
   } else {
      if (ai_0 == 28) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextBatmanBearishColor, "AB", gsa_1060[28][1], gi_956);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextBatmanBearishColor, "BC", gsa_1060[28][1], gi_956);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextBatmanBearishColor, "CD", gsa_1060[28][1], gi_956);
         DrawPoint("L", ai_4, ad_8, cextBatmanDescColor, "A", gsa_1060[28][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_16, ad_20, cextBatmanDescColor, "B", gsa_1060[28][1], iextDescrFontSize, 0);
         DrawPoint("L", ai_28, ad_32, cextBatmanDescColor, "C", gsa_1060[28][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_40, ad_44, cextBatmanDescColor, "D", gsa_1060[28][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, cextBatmanDescColor, gsa_1060[28][1], 28);
      }
   }
   return (0);
}

void Draw_MultiDimPattern(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, double ad_64) {
   double ld_72;
   double ld_80;
   string ls_unused_88;
   if (ad_20 - ad_32 == 0.0 || ad_20 - ad_8 == 0.0 || ad_44 - ad_32 == 0.0) return;
   string l_dbl2str_96 = DoubleToStr((ad_44 - ad_32) / (ad_20 - ad_32), 3);
   string l_dbl2str_104 = DoubleToStr((ad_20 - ad_32) / (ad_20 - ad_8), 3);
   string l_dbl2str_112 = DoubleToStr((ad_44 - ad_56) / (ad_44 - ad_32), 3);
   string l_dbl2str_120 = DoubleToStr((ad_20 - ad_56) / (ad_20 - ad_8), 3);
   int li_128 = Time[iBarShift(Symbol(), Period(), ai_52)] - (Time[iBarShift(Symbol(), Period(), ai_52) + 5]);
   if (ai_0 == 7) {
      DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextGartleyBullishColor, "p1", gsa_1060[7][1]);
      DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextGartleyBullishColor, "p2", gsa_1060[7][1]);
      CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_1060[7][1], 7);
      if (bextDrawProjectionLines) {
         ProjectionLine(ai_52, ad_20 - 0.618 * (ad_20 - ad_8), SlateGray, "AD=618XA", 0, 2, "AD=618XA", gsa_1060[7][1], gi_968);
         ProjectionLine(ai_52, ad_20 - 0.786 * (ad_20 - ad_8), SlateGray, "AD=786XA", 0, 2, "AD=786XA", gsa_1060[7][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 1.127 * (ad_44 - ad_32), LightSeaGreen, "CD=1127BC", 0, 2, "CD=1127BC", gsa_1060[7][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 1.272 * (ad_44 - ad_32), LightSeaGreen, "CD=1272BC", 0, 2, "CD=1272BC", gsa_1060[7][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[7][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 2.2236 * (ad_44 - ad_32), LightSeaGreen, "CD=2236BC", 0, 2, "CD=2236BC", gsa_1060[7][1], gi_968);
         ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), MediumSeaGreen, "CD=AB", 0, 2, "CD=AB", gsa_1060[7][1], gi_968);
      }
      if (bextDrawRelationLines) {
         DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[7][1]);
         DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[7][1]);
         DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[7][1]);
         DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[7][1]);
      }
      ld_72 = MathMax(ad_20 - 0.786 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.2236 * (ad_44 - ad_32) * (ad_64 + 1.0));
      ld_80 = MathMin(ad_20 - 0.577 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.127 * (ad_44 - ad_32) * (1 - ad_64));
      CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMin(ad_20 - 0.577 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.272 * (ad_44 - ad_32) * (1 - ad_64)), MathMax(ad_20 - 0.786 * (ad_20 - ad_8) * (ad_64 +
         1.0), ad_44 - 2.2236 * (ad_44 - ad_32) * (ad_64 + 1.0)), cextRectangleColor, "Rect", gsa_1060[7][1]);
      if (bextDrawPRZ) {
         PRZ_FiboIntRet("intXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
         PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
         PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
         PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
      }
      DrawDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
      DrawDetailedDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
      return;
   }
   if (ai_0 == 8) {
      DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextGartleyBearishColor, "p1", gsa_1060[8][1]);
      DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextGartleyBearishColor, "p2", gsa_1060[8][1]);
      CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_1060[8][1], 8);
      if (bextDrawProjectionLines) {
         ProjectionLine(ai_52, ad_20 - 0.618 * (ad_20 - ad_8), SlateGray, "AD=618XA", 0, 2, "AD=618XA", gsa_1060[8][1], gi_968);
         ProjectionLine(ai_52, ad_20 - 0.786 * (ad_20 - ad_8), SlateGray, "AD=786XA", 0, 2, "AD=786XA", gsa_1060[8][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 1.272 * (ad_44 - ad_32), LightSeaGreen, "CD=1272BC", 0, 2, "CD=1272BC", gsa_1060[8][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 1.127 * (ad_44 - ad_32), LightSeaGreen, "CD=1127BC", 0, 2, "CD=1127BC", gsa_1060[8][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[8][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 2.2236 * (ad_44 - ad_32), LightSeaGreen, "CD=2236BC", 0, 2, "CD=2236BC", gsa_1060[8][1], gi_968);
         ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), MediumSeaGreen, "CD=AB", 0, 2, "CD=AB", gsa_1060[8][1], gi_968);
      }
      if (bextDrawRelationLines) {
         DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[8][1]);
         DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[8][1]);
         DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[8][1]);
         DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[8][1]);
      }
      ld_72 = MathMax(ad_20 - 0.577 * (ad_20 - ad_8) * (1 - ad_64), ad_44 + 1.127 * (ad_32 - ad_44) * (1 - ad_64));
      ld_80 = MathMin(ad_20 - 0.786 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 + 2.2236 * (ad_32 - ad_44) * (ad_64 + 1.0));
      CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[8][1]);
      if (bextDrawPRZ) {
         PRZ_FiboIntRet("intXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
         PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
         PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
         PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
      }
      DrawDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
      DrawDetailedDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
      return;
   }
   if (ai_0 == 15) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBullishColor, "XA", gsa_1060[15][1], gi_960);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBullishColor, "AB", gsa_1060[15][1], gi_960);
      DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBullishColor, "XB", gsa_1060[15][1], gi_960);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBullishColor, "BC", gsa_1060[15][1], gi_960);
      DrawLine(ai_28, ad_32, Time[0], ad_44 + (ad_32 - ad_20), cextEmergingBullishColor, "BD", gsa_1060[15][1], gi_960);
      DrawLine(ai_40, ad_44, Time[0], ad_44 + (ad_32 - ad_20), cextEmergingBullishColor, "CD", gsa_1060[15][1], gi_960);
      CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_1060[15][1], 15);
      if (bextDrawProjectionLines) {
         ProjectionLine(ai_52, ad_20 - 0.786 * (ad_20 - ad_8), SlateGray, "AD=786XA", 0, 2, "AD=786XA", gsa_1060[15][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[15][1], gi_968);
         ProjectionLine(ai_52, ad_44 - 2.2236 * (ad_44 - ad_32), LightSeaGreen, "CD=2236BC", 0, 2, "CD=2236BC", gsa_1060[15][1], gi_968);
         ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), MediumSeaGreen, "CD=AB", 0, 2, "CD=AB", gsa_1060[15][1], gi_968);
      }
      if (bextDrawRelationLines) {
         DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[7][1]);
         DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[7][1]);
         DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[7][1]);
         DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[7][1]);
      }
      ld_72 = MathMax(ad_20 - 0.786 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.2236 * (ad_44 - ad_32) * (ad_64 + 1.0));
      ld_80 = MathMin(ad_20 - 0.577 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.127 * (ad_44 - ad_32) * (1 - ad_64));
      CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMin(ad_20 - 0.577 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.127 * (ad_44 - ad_32) * (1 - ad_64)), MathMax(ad_20 - 0.786 * (ad_20 - ad_8) * (ad_64 +
         1.0), ad_44 - 2.2236 * (ad_44 - ad_32) * (ad_64 + 1.0)), cextRectangleColor, "Rect", gsa_1060[15][1]);
      if (bextDrawPRZ) {
         PRZ_FiboIntRet("intXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
         PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
         PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
         PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
      }
   } else {
      if (ai_0 == 16) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBearishColor, "XA", gsa_1060[16][1], gi_960);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBearishColor, "AB", gsa_1060[16][1], gi_960);
         DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBearishColor, "XB", gsa_1060[16][1], gi_960);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBearishColor, "BC", gsa_1060[16][1], gi_960);
         DrawLine(ai_28, ad_32, Time[0], ad_44 + (ad_32 - ad_20), cextEmergingBearishColor, "BD", gsa_1060[16][1], gi_960);
         DrawLine(ai_40, ad_44, Time[0], ad_44 + (ad_32 - ad_20), cextEmergingBearishColor, "CD", gsa_1060[16][1], gi_960);
         CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_1060[16][1], 16);
         if (bextDrawProjectionLines) {
            ProjectionLine(ai_52, ad_20 - 0.786 * (ad_20 - ad_8), SlateGray, "AD=786XA", 0, 2, "AD=786XA", gsa_1060[16][1], gi_968);
            ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[16][1], gi_968);
            ProjectionLine(ai_52, ad_44 - 2.2236 * (ad_44 - ad_32), LightSeaGreen, "CD=2236BC", 0, 2, "CD=2236BC", gsa_1060[16][1], gi_968);
            ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), MediumSeaGreen, "CD=AB", 0, 2, "CD=AB", gsa_1060[16][1], gi_968);
         }
         if (bextDrawRelationLines) {
            DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[16][1]);
            DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[16][1]);
            DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[16][1]);
            DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[16][1]);
         }
         ld_72 = MathMax(ad_20 - 0.577 * (ad_20 - ad_8) * (1 - ad_64), ad_44 + 1.127 * (ad_32 - ad_44) * (1 - ad_64));
         ld_80 = MathMin(ad_20 - 0.786 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 + 2.2236 * (ad_32 - ad_44) * (ad_64 + 1.0));
         CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[16][1]);
         if (bextDrawPRZ) {
            PRZ_FiboIntRet("intXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
            PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
            PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
            PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
         }
      } else {
         if (ai_0 == 9) {
            DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextButterflyBullishColor, "p1", gsa_1060[9][1]);
            DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextButterflyBullishColor, "p2", gsa_1060[9][1]);
            CreatePatternIdentityObject(ai_4, ad_8, cextButterflyDescColor, gsa_1060[9][1], 9);
            if (bextDrawProjectionLines) {
               ProjectionLine(ai_52, ad_20 - 1.27 * (ad_20 - ad_8), SlateGray, "AD=127XA", 0, 2, "AD=127XA", gsa_1060[9][1], gi_968);
               ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_1060[9][1], gi_968);
               ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[9][1], gi_968);
               ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_1060[9][1], gi_968);
            }
            if (bextDrawRelationLines) {
               DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[9][1]);
               DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[9][1]);
               DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[9][1]);
               DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[9][1]);
            }
            ld_72 = MathMax(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
            ld_80 = MathMin(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64));
            CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[9][1]);
            if (bextDrawPRZ) {
               PRZ_FiboExtRet("extXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
               PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
               PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
               PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
            }
            DrawDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
            DrawDetailedDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
         } else {
            if (ai_0 == 10) {
               DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextButterflyBearishColor, "p1", gsa_1060[10][1]);
               DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextButterflyBearishColor, "p2", gsa_1060[10][1]);
               CreatePatternIdentityObject(ai_4, ad_8, cextButterflyDescColor, gsa_1060[10][1], 10);
               if (bextDrawProjectionLines) {
                  ProjectionLine(ai_52, ad_20 - 1.27 * (ad_20 - ad_8), SlateGray, "AD=127XA", 0, 2, "AD=127XA", gsa_1060[10][1], gi_968);
                  ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_1060[10][1], gi_968);
                  ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[10][1], gi_968);
                  ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_1060[10][1], gi_968);
               }
               if (bextDrawRelationLines) {
                  DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[10][1]);
                  DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[10][1]);
                  DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[10][1]);
                  DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[10][1]);
               }
               ld_72 = MathMax(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64));
               ld_80 = MathMin(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
               CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[10][1]);
               if (bextDrawPRZ) {
                  PRZ_FiboExtRet("extXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                  PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                  PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                  PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
               }
               DrawDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
               DrawDetailedDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
            } else {
               if (ai_0 == 17) {
                  DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBullishColor, "XA", gsa_1060[17][1], gi_960);
                  DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBullishColor, "AB", gsa_1060[17][1], gi_960);
                  DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBullishColor, "XB", gsa_1060[17][1], gi_960);
                  DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBullishColor, "BC", gsa_1060[17][1], gi_960);
                  DrawLine(ai_28, ad_32, Time[0], ad_44 + 1.27 * (ad_8 - ad_20), cextEmergingBullishColor, "BD", gsa_1060[17][1], gi_960);
                  DrawLine(ai_40, ad_44, Time[0], ad_44 + 1.27 * (ad_8 - ad_20), cextEmergingBullishColor, "CD", gsa_1060[17][1], gi_960);
                  CreatePatternIdentityObject(ai_4, ad_8, cextButterflyDescColor, gsa_1060[17][1], 17);
                  if (bextDrawProjectionLines) {
                     ProjectionLine(ai_52, ad_20 - 1.27 * (ad_20 - ad_8), SlateGray, "AD=127XA", 0, 2, "AD=127XA", gsa_1060[17][1], gi_968);
                     ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_1060[17][1], gi_968);
                     ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[17][1], gi_968);
                     ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_1060[17][1], gi_968);
                  }
                  if (bextDrawRelationLines) {
                     DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[17][1]);
                     DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[17][1]);
                     DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[17][1]);
                     DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[17][1]);
                  }
                  ld_72 = MathMax(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                  ld_80 = MathMin(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64));
                  CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[17][1]);
                  if (bextDrawPRZ) {
                     PRZ_FiboExtRet("extXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                     PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                     PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                     PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                  }
               } else {
                  if (ai_0 == 18) {
                     DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBearishColor, "XA", gsa_1060[18][1], gi_960);
                     DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBearishColor, "AB", gsa_1060[18][1], gi_960);
                     DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBearishColor, "XB", gsa_1060[18][1], gi_960);
                     DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBearishColor, "BC", gsa_1060[18][1], gi_960);
                     DrawLine(ai_28, ad_32, Time[0], ad_44 + 1.27 * (ad_8 - ad_20), cextEmergingBearishColor, "BD", gsa_1060[18][1], gi_960);
                     DrawLine(ai_40, ad_44, Time[0], ad_44 + 1.27 * (ad_8 - ad_20), cextEmergingBearishColor, "CD", gsa_1060[18][1], gi_960);
                     CreatePatternIdentityObject(ai_4, ad_8, cextButterflyDescColor, gsa_1060[18][1], 18);
                     if (bextDrawProjectionLines) {
                        ProjectionLine(ai_52, ad_20 - 1.27 * (ad_20 - ad_8), SlateGray, "AD=127XA", 0, 2, "AD=127XA", gsa_1060[18][1], gi_968);
                        ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_1060[18][1], gi_968);
                        ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[18][1], gi_968);
                        ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_1060[18][1], gi_968);
                     }
                     if (bextDrawRelationLines) {
                        DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[18][1]);
                        DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[18][1]);
                        DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[18][1]);
                        DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[18][1]);
                     }
                     ld_72 = MathMax(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64));
                     ld_80 = MathMin(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                     CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[18][1]);
                     if (bextDrawPRZ) {
                        PRZ_FiboExtRet("extXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                        PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                        PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                        PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                     }
                  } else {
                     if (ai_0 == 11) {
                        DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextCrabBullishColor, "p1", gsa_1060[11][1]);
                        DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextCrabBullishColor, "p2", gsa_1060[11][1]);
                        CreatePatternIdentityObject(ai_4, ad_8, cextCrabDescColor, gsa_1060[11][1], 11);
                        if (bextDrawProjectionLines) {
                           ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_1060[11][1], gi_968);
                           ProjectionLine(ai_52, ad_44 - 2.24 * (ad_44 - ad_32), LightSeaGreen, "CD=2240BC", 0, 2, "CD=2240BC", gsa_1060[11][1], gi_968);
                           ProjectionLine(ai_52, ad_44 - 3.618 * (ad_44 - ad_32), LightSeaGreen, "CD=3618BC", 0, 2, "CD=3618BC", gsa_1060[11][1], gi_968);
                        }
                        if (bextDrawRelationLines) {
                           DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[11][1]);
                           DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[11][1]);
                           DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[11][1]);
                           DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[11][1]);
                        }
                        ld_72 = MathMax(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 3.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                        ld_80 = MathMin(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 2.24 * (ad_44 - ad_32) * (1 - ad_64));
                        CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[11][1]);
                        if (bextDrawPRZ) {
                           PRZ_FiboExtRet("extXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                           PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                           PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                           PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                        }
                        DrawDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                        DrawDetailedDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                     } else {
                        if (ai_0 == 12) {
                           DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextCrabBearishColor, "p1", gsa_1060[12][1]);
                           DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextCrabBearishColor, "p2", gsa_1060[12][1]);
                           CreatePatternIdentityObject(ai_4, ad_8, cextCrabDescColor, gsa_1060[12][1], 12);
                           if (bextDrawProjectionLines) {
                              ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_1060[12][1], gi_968);
                              ProjectionLine(ai_52, ad_44 - 2.24 * (ad_44 - ad_32), LightSeaGreen, "CD=2240BC", 0, 2, "CD=2240BC", gsa_1060[12][1], gi_968);
                              ProjectionLine(ai_52, ad_44 - 3.618 * (ad_44 - ad_32), LightSeaGreen, "CD=3618BC", 0, 2, "CD=3618BC", gsa_1060[12][1], gi_968);
                           }
                           if (bextDrawRelationLines) {
                              DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[12][1]);
                              DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[12][1]);
                              DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[12][1]);
                              DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[12][1]);
                           }
                           ld_72 = MathMax(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 2.24 * (ad_44 - ad_32) * (1 - ad_64));
                           ld_80 = MathMin(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 3.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                           CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[12][1]);
                           if (bextDrawPRZ) {
                              PRZ_FiboExtRet("extXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                              PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                              PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                              PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                           }
                           DrawDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                           DrawDetailedDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                        } else {
                           if (ai_0 == 19) {
                              DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBullishColor, "XA", gsa_1060[19][1], gi_960);
                              DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBullishColor, "AB", gsa_1060[19][1], gi_960);
                              DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBullishColor, "XB", gsa_1060[19][1], gi_960);
                              DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBullishColor, "BC", gsa_1060[19][1], gi_960);
                              DrawLine(ai_28, ad_32, Time[0], ad_20 + 1.618 * (ad_8 - ad_20), cextEmergingBullishColor, "BD", gsa_1060[19][1], gi_960);
                              DrawLine(ai_40, ad_44, Time[0], ad_20 + 1.618 * (ad_8 - ad_20), cextEmergingBullishColor, "CD", gsa_1060[19][1], gi_960);
                              CreatePatternIdentityObject(ai_4, ad_8, cextCrabDescColor, gsa_1060[19][1], 19);
                              if (bextDrawProjectionLines) {
                                 ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_1060[19][1], gi_968);
                                 ProjectionLine(ai_52, ad_44 - 2.24 * (ad_44 - ad_32), LightSeaGreen, "CD=2240BC", 0, 2, "CD=2240BC", gsa_1060[19][1], gi_968);
                                 ProjectionLine(ai_52, ad_44 - 3.618 * (ad_44 - ad_32), LightSeaGreen, "CD=3618BC", 0, 2, "CD=3618BC", gsa_1060[19][1], gi_968);
                              }
                              if (bextDrawRelationLines) {
                                 DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[19][1]);
                                 DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[19][1]);
                                 DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[19][1]);
                                 DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[19][1]);
                              }
                              ld_72 = MathMax(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 3.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                              ld_80 = MathMin(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 2.24 * (ad_44 - ad_32) * (1 - ad_64));
                              CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[19][1]);
                              if (bextDrawPRZ) {
                                 PRZ_FiboExtRet("extXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                                 PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                                 PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                                 PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                              }
                           } else {
                              if (ai_0 == 20) {
                                 DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBearishColor, "XA", gsa_1060[20][1], gi_960);
                                 DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBearishColor, "AB", gsa_1060[20][1], gi_960);
                                 DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBearishColor, "XB", gsa_1060[20][1], gi_960);
                                 DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBearishColor, "BC", gsa_1060[20][1], gi_960);
                                 DrawLine(ai_28, ad_32, Time[0], ad_20 + 1.618 * (ad_8 - ad_20), cextEmergingBearishColor, "BD", gsa_1060[20][1], gi_960);
                                 DrawLine(ai_40, ad_44, Time[0], ad_20 + 1.618 * (ad_8 - ad_20), cextEmergingBearishColor, "CD", gsa_1060[20][1], gi_960);
                                 CreatePatternIdentityObject(ai_4, ad_8, cextCrabDescColor, gsa_1060[20][1], 20);
                                 if (bextDrawProjectionLines) {
                                    ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_1060[20][1], gi_968);
                                    ProjectionLine(ai_52, ad_44 - 2.24 * (ad_44 - ad_32), LightSeaGreen, "CD=2240BC", 0, 2, "CD=2240BC", gsa_1060[20][1], gi_968);
                                    ProjectionLine(ai_52, ad_44 - 3.618 * (ad_44 - ad_32), LightSeaGreen, "CD=3618BC", 0, 2, "CD=3618BC", gsa_1060[20][1], gi_968);
                                 }
                                 if (bextDrawRelationLines) {
                                    DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[20][1]);
                                    DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[20][1]);
                                    DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[20][1]);
                                    DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[20][1]);
                                 }
                                 ld_72 = MathMax(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 2.24 * (ad_44 - ad_32) * (1 - ad_64));
                                 ld_80 = MathMin(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 3.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                                 CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[20][1]);
                                 if (bextDrawPRZ) {
                                    PRZ_FiboExtRet("extXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                                    PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                                    PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                                    PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                                 }
                              } else {
                                 if (ai_0 == 13) {
                                    DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextBatBullishColor, "p1", gsa_1060[13][1]);
                                    DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextBatBullishColor, "p2", gsa_1060[13][1]);
                                    CreatePatternIdentityObject(ai_4, ad_8, cextBatDescColor, gsa_1060[13][1], 13);
                                    if (bextDrawProjectionLines) {
                                       ProjectionLine(ai_52, ad_20 - 0.886 * (ad_20 - ad_8), SlateGray, "AD=886XA", 0, 2, "AD=886XA", gsa_1060[13][1], gi_968);
                                       ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[13][1], gi_968);
                                       ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_1060[13][1], gi_968);
                                    }
                                    if (bextDrawRelationLines) {
                                       DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[13][1]);
                                       DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[13][1]);
                                       DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[13][1]);
                                       DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[13][1]);
                                    }
                                    ld_72 = MathMax(ad_20 - 0.886 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                                    ld_80 = MathMin(ad_20 - 0.886 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64));
                                    CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[13][1]);
                                    if (bextDrawPRZ) {
                                       PRZ_FiboIntRet("intXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                                       PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                                       PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                                       PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                                    }
                                    DrawDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                                    DrawDetailedDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                                 } else {
                                    if (ai_0 == 14) {
                                       DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextBatBearishColor, "p1", gsa_1060[14][1]);
                                       DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextBatBearishColor, "p2", gsa_1060[14][1]);
                                       CreatePatternIdentityObject(ai_4, ad_8, cextBatDescColor, gsa_1060[14][1], 14);
                                       if (bextDrawProjectionLines) {
                                          ProjectionLine(ai_52, ad_20 - 0.886 * (ad_20 - ad_8), SlateGray, "AD=886XA", 0, 2, "AD=886XA", gsa_1060[14][1], gi_968);
                                          ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[14][1], gi_968);
                                          ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_1060[14][1], gi_968);
                                       }
                                       if (bextDrawRelationLines) {
                                          DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[14][1]);
                                          DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[14][1]);
                                          DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[14][1]);
                                          DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[14][1]);
                                       }
                                       ld_80 = MathMin(ad_20 - 0.886 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                                       ld_72 = MathMax(ad_20 - 0.886 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64));
                                       CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[14][1]);
                                       if (bextDrawPRZ) {
                                          PRZ_FiboIntRet("intXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                                          PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                                          PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                                          PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                                       }
                                       DrawDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                                       DrawDetailedDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                                    } else {
                                       if (ai_0 == 21) {
                                          DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBullishColor, "XA", gsa_1060[21][1], gi_960);
                                          DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBullishColor, "AB", gsa_1060[21][1], gi_960);
                                          DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBullishColor, "XB", gsa_1060[21][1], gi_960);
                                          DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBullishColor, "BC", gsa_1060[21][1], gi_960);
                                          DrawLine(ai_28, ad_32, Time[0], ad_20 + 0.886 * (ad_8 - ad_20), cextEmergingBullishColor, "BD", gsa_1060[21][1], gi_960);
                                          DrawLine(ai_40, ad_44, Time[0], ad_20 + 0.886 * (ad_8 - ad_20), cextEmergingBullishColor, "CD", gsa_1060[21][1], gi_960);
                                          CreatePatternIdentityObject(ai_4, ad_8, cextBatDescColor, gsa_1060[21][1], 21);
                                          if (bextDrawProjectionLines) {
                                             ProjectionLine(ai_52, ad_20 - 0.886 * (ad_20 - ad_8), SlateGray, "AD=886XA", 0, 2, "AD=886XA", gsa_1060[21][1], gi_968);
                                             ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[21][1], gi_968);
                                             ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_1060[21][1], gi_968);
                                          }
                                          if (bextDrawRelationLines) {
                                             DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[21][1]);
                                             DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[21][1]);
                                             DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[21][1]);
                                             DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[21][1]);
                                          }
                                          ld_72 = MathMax(ad_20 - 0.886 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                                          ld_80 = MathMin(ad_20 - 0.886 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64));
                                          CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[21][1]);
                                          if (bextDrawPRZ) {
                                             PRZ_FiboIntRet("intXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                                             PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                                             PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                                             PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                                          }
                                       } else {
                                          if (ai_0 == 22) {
                                             DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBearishColor, "XA", gsa_1060[22][1], gi_960);
                                             DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBearishColor, "AB", gsa_1060[22][1], gi_960);
                                             DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBearishColor, "XB", gsa_1060[22][1], gi_960);
                                             DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBearishColor, "BC", gsa_1060[22][1], gi_960);
                                             DrawLine(ai_28, ad_32, Time[0], ad_20 + 0.886 * (ad_8 - ad_20), cextEmergingBearishColor, "BD", gsa_1060[22][1], gi_960);
                                             DrawLine(ai_40, ad_44, Time[0], ad_20 + 0.886 * (ad_8 - ad_20), cextEmergingBearishColor, "CD", gsa_1060[22][1], gi_960);
                                             CreatePatternIdentityObject(ai_4, ad_8, cextBatDescColor, gsa_1060[22][1], 22);
                                             if (bextDrawProjectionLines) {
                                                ProjectionLine(ai_52, ad_20 - 0.886 * (ad_20 - ad_8), SlateGray, "AD=886XA", 0, 2, "AD=886XA", gsa_1060[22][1], gi_968);
                                                ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_1060[22][1], gi_968);
                                                ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_1060[22][1], gi_968);
                                             }
                                             if (bextDrawRelationLines) {
                                                DrawRelationLine(ai_16, ad_20, ai_40, ad_44, l_dbl2str_96, DarkSlateGray, "relAC", gsa_1060[22][1]);
                                                DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_104, DarkSlateGray, "relXB", gsa_1060[22][1]);
                                                DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_112, DarkSlateGray, "relBD", gsa_1060[22][1]);
                                                DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_120, DarkSlateGray, "relXD", gsa_1060[22][1]);
                                             }
                                             ld_80 = MathMin(ad_20 - 0.886 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0));
                                             ld_72 = MathMax(ad_20 - 0.886 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64));
                                             CalcRectangle(ai_40, ad_44, ai_52, ad_56, ld_72, ld_80, cextRectangleColor, "Rect", gsa_1060[22][1]);
                                             if (bextDrawPRZ) {
                                                PRZ_FiboIntRet("intXA", ld_72, ld_80, ai_4, ad_8, ai_16, ad_20, ai_52, Red);
                                                PRZ_FiboExtRet("extBC", ld_72, ld_80, ai_28, ad_32, ai_40, ad_44, ai_52, Yellow);
                                                PRZ_FiboProj("projAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_52, Green);
                                                PRZ_FiboAPPProj("APPprojAB", ld_72, ld_80, ai_28, ad_32, ai_16, ad_20, ai_40, ad_44, ai_52, Orange);
                                             }
                                          }
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
}

int Draw_Pattern_SHS(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, int ai_64, double ad_68) {
   if (ai_0 == 29 || ai_0 == 31) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextSHSBullishColor, "AB", gsa_1060[29][1], gi_964);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextSHSBullishColor, "BC", gsa_1060[29][1], gi_964);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextSHSBullishColor, "CD", gsa_1060[29][1], gi_964);
      DrawLine(ai_40, ad_44, ai_52, ad_56, cextSHSBullishColor, "DE", gsa_1060[29][1], gi_964);
      DrawLine(ai_52, ad_56, ai_64, ad_68, cextSHSBullishColor, "EF", gsa_1060[29][1], gi_964);
      DrawPoint("L", ai_16, ad_20, cextSHSDescColor, "S", gsa_1060[29][1], iextDescrFontSize, 0);
      if (ai_0 == 29) DrawPoint("L", ai_40, ad_44, cextSHSDescColor, "H", gsa_1060[29][1], iextDescrFontSize, 0);
      else DrawPoint("L", ai_40, ad_44, cextSHSDescColor, "I+H", gsa_1060[29][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_64, ad_68, cextSHSDescColor, "S", gsa_1060[29][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, cextSHSDescColor, gsa_1060[29][1], 29);
   } else {
      if (ai_0 == 30 || ai_0 == 32) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextSHSBearishColor, "AB", gsa_1060[30][1], gi_964);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextSHSBearishColor, "BC", gsa_1060[30][1], gi_964);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextSHSBearishColor, "CD", gsa_1060[30][1], gi_964);
         DrawLine(ai_40, ad_44, ai_52, ad_56, cextSHSBearishColor, "DE", gsa_1060[30][1], gi_964);
         DrawLine(ai_52, ad_56, ai_64, ad_68, cextSHSBearishColor, "EF", gsa_1060[30][1], gi_964);
         DrawPoint("S", ai_16, ad_20, cextSHSDescColor, "S", gsa_1060[30][1], iextDescrFontSize, 0);
         if (ai_0 == 30) DrawPoint("S", ai_40, ad_44, cextSHSDescColor, "H", gsa_1060[30][1], iextDescrFontSize, 0);
         else DrawPoint("S", ai_40, ad_44, cextSHSDescColor, "I+H", gsa_1060[30][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_64, ad_68, cextSHSDescColor, "S", gsa_1060[30][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, cextSHSDescColor, gsa_1060[30][1], 30);
      }
   }
   return (0);
}

int Draw_Pattern_3Drives(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, int ai_64, double ad_68) {
   if (ai_0 == 23) {
      DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cext3Drives1BullishColor, "p1", gsa_1060[23][1]);
      DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cext3Drives1BullishColor, "p2", gsa_1060[23][1]);
      DrawTriangle(ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, cext3Drives2BullishColor, "p3", gsa_1060[23][1]);
      DrawTriangle(ai_40, ad_44, ai_52, ad_56, ai_64, ad_68, cext3Drives2BullishColor, "p4", gsa_1060[23][1]);
      CreatePatternIdentityObject(ai_4, ad_8, cext3DrivesDescColor, gsa_1060[23][1], 23);
   } else {
      if (ai_0 == 24) {
         DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cext3Drives1BearishColor, "p1", gsa_1060[24][1]);
         DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cext3Drives1BearishColor, "p2", gsa_1060[24][1]);
         DrawTriangle(ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, cext3Drives2BearishColor, "p3", gsa_1060[24][1]);
         DrawTriangle(ai_40, ad_44, ai_52, ad_56, ai_64, ad_68, cext3Drives2BearishColor, "p4", gsa_1060[24][1]);
         CreatePatternIdentityObject(ai_4, ad_8, cext3DrivesDescColor, gsa_1060[24][1], 24);
      }
   }
   return (0);
}

int Draw_Pattern_5_0(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, int ai_64, double ad_68) {
   if (ai_0 == 25) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cext5_0BullishColor, "OX", gsa_1060[25][1], gi_964);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cext5_0BullishColor, "XA", gsa_1060[25][1], gi_964);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cext5_0BullishColor, "AB", gsa_1060[25][1], gi_964);
      DrawLine(ai_40, ad_44, ai_52, ad_56, cext5_0BullishColor, "BC", gsa_1060[25][1], gi_964);
      DrawLine(ai_52, ad_56, ai_64, ad_68, cext5_0BullishColor, "CD", gsa_1060[25][1], gi_964);
      DrawPoint("L", ai_40, ad_44, cext5_0DescColor, "5-0", gsa_1060[25][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, cext5_0DescColor, gsa_1060[25][1], 25);
   } else {
      if (ai_0 == 26) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cext5_0BearishColor, "OX", gsa_1060[26][1], gi_964);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cext5_0BearishColor, "XA", gsa_1060[26][1], gi_964);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cext5_0BearishColor, "AB", gsa_1060[26][1], gi_964);
         DrawLine(ai_40, ad_44, ai_52, ad_56, cext5_0BearishColor, "BC", gsa_1060[26][1], gi_964);
         DrawLine(ai_52, ad_56, ai_64, ad_68, cext5_0BearishColor, "CD", gsa_1060[26][1], gi_964);
         DrawPoint("S", ai_40, ad_44, cext5_0DescColor, "5-0", gsa_1060[25][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, cext5_0DescColor, gsa_1060[26][1], 26);
      }
   }
   return (0);
}

int Draw_Triangle(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56) {
   int li_64 = -1 * iBarShift(Symbol(), Period(), ai_4);
   int li_68 = -1 * iBarShift(Symbol(), Period(), ai_16);
   int li_72 = -1 * iBarShift(Symbol(), Period(), ai_28);
   int li_76 = -1 * iBarShift(Symbol(), Period(), ai_40);
   int li_80 = -1 * iBarShift(Symbol(), Period(), ai_52);
   if (li_64 - li_72 == 0 || li_68 - li_76 == 0) return (0);
   double ld_84 = (ad_8 - ad_32) / (li_64 - li_72);
   double ld_92 = ad_8 - ld_84 * li_64;
   double ld_100 = ld_84 * li_76 + ld_92;
   double ld_108 = (ad_20 - ad_44) / (li_68 - li_76);
   double ld_116 = ad_20 - ld_108 * li_68;
   double ld_124 = ld_108 * li_80 + ld_116;
   double ld_132 = ld_108 * li_64 + ld_116;
   if (ai_0 == 56) {
      DrawLine(ai_4, ad_8, ai_52, ad_56, cextTriangleBullishColor, "AE", gsa_1060[56][1], gi_976);
      DrawLine(ai_4, ld_132, ai_52, ld_124, cextTriangleBullishColor, "BD", gsa_1060[56][1], gi_976);
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextTriangleBullishColor, "AB", gsa_1060[56][1], gi_980);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextTriangleBullishColor, "BC", gsa_1060[56][1], gi_980);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextTriangleBullishColor, "CD", gsa_1060[56][1], gi_980);
      DrawLine(ai_40, ad_44, ai_52, ad_56, cextTriangleBullishColor, "DE", gsa_1060[56][1], gi_980);
      if (bextDrawPatternDescr) {
         DrawPoint("L", ai_4, ad_8, cextTriangleBullishColor, "a", gsa_1060[56][1], iextDescrFontSize, 2);
         DrawPoint("S", ai_16, ad_20, cextTriangleBullishColor, "b", gsa_1060[56][1], iextDescrFontSize, 2);
         DrawPoint("L", ai_28, ad_32, cextTriangleBullishColor, "c", gsa_1060[56][1], iextDescrFontSize, 2);
         DrawPoint("S", ai_40, ad_44, cextTriangleBullishColor, "d", gsa_1060[56][1], iextDescrFontSize, 2);
         DrawPoint("L", ai_52, ad_56, cextTriangleBullishColor, "e", gsa_1060[56][1], iextDescrFontSize, 2);
      }
      CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_1060[56][1], 56);
   } else {
      if (ai_0 == 57) {
         DrawLine(ai_4, ad_8, ai_52, ad_56, cextTriangleBearishColor, "AE", gsa_1060[57][1], gi_976);
         DrawLine(ai_4, ld_132, ai_52, ld_124, cextTriangleBearishColor, "BD", gsa_1060[57][1], gi_976);
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextTriangleBearishColor, "AB", gsa_1060[57][1], gi_980);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextTriangleBearishColor, "BC", gsa_1060[57][1], gi_980);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextTriangleBearishColor, "CD", gsa_1060[57][1], gi_980);
         DrawLine(ai_40, ad_44, ai_52, ad_56, cextTriangleBearishColor, "DE", gsa_1060[57][1], gi_980);
         if (bextDrawPatternDescr) {
            DrawPoint("S", ai_4, ad_8, cextTriangleBearishColor, "a", gsa_1060[57][1], iextDescrFontSize, 1);
            DrawPoint("L", ai_16, ad_20, cextTriangleBearishColor, "b", gsa_1060[57][1], iextDescrFontSize, 1);
            DrawPoint("S", ai_28, ad_32, cextTriangleBearishColor, "c", gsa_1060[57][1], iextDescrFontSize, 1);
            DrawPoint("L", ai_40, ad_44, cextTriangleBearishColor, "d", gsa_1060[57][1], iextDescrFontSize, 1);
            DrawPoint("S", ai_52, ad_56, cextTriangleBearishColor, "e", gsa_1060[57][1], iextDescrFontSize, 1);
         }
         CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_1060[57][1], 57);
      } else {
         if (ai_0 == 60) {
            DrawLine(ai_4, ad_8, ai_52, ad_56, cextITriangleBullishColor, "AE", gsa_1060[60][1], gi_976);
            DrawLine(ai_4, ld_132, ai_52, ld_124, cextITriangleBullishColor, "BD", gsa_1060[60][1], gi_976);
            DrawLine(ai_4, ad_8, ai_16, ad_20, cextITriangleBullishColor, "AB", gsa_1060[60][1], gi_980);
            DrawLine(ai_16, ad_20, ai_28, ad_32, cextITriangleBullishColor, "BC", gsa_1060[60][1], gi_980);
            DrawLine(ai_28, ad_32, ai_40, ad_44, cextITriangleBullishColor, "CD", gsa_1060[60][1], gi_980);
            DrawLine(ai_40, ad_44, ai_52, ad_56, cextITriangleBullishColor, "DE", gsa_1060[60][1], gi_980);
            if (bextDrawPatternDescr) {
               DrawPoint("L", ai_4, ad_8, cextITriangleBullishColor, "a", gsa_1060[60][1], iextDescrFontSize, 2);
               DrawPoint("S", ai_16, ad_20, cextITriangleBullishColor, "b", gsa_1060[60][1], iextDescrFontSize, 2);
               DrawPoint("L", ai_28, ad_32, cextITriangleBullishColor, "c", gsa_1060[60][1], iextDescrFontSize, 2);
               DrawPoint("S", ai_40, ad_44, cextITriangleBullishColor, "d", gsa_1060[60][1], iextDescrFontSize, 2);
               DrawPoint("L", ai_52, ad_56, cextITriangleBullishColor, "e", gsa_1060[60][1], iextDescrFontSize, 2);
            }
            CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_1060[60][1], 60);
         } else {
            if (ai_0 == 61) {
               DrawLine(ai_4, ad_8, ai_52, ad_56, cextITriangleBearishColor, "AE", gsa_1060[61][1], gi_976);
               DrawLine(ai_4, ld_132, ai_52, ld_124, cextITriangleBearishColor, "BD", gsa_1060[61][1], gi_976);
               DrawLine(ai_4, ad_8, ai_16, ad_20, cextITriangleBearishColor, "AB", gsa_1060[61][1], gi_980);
               DrawLine(ai_16, ad_20, ai_28, ad_32, cextITriangleBearishColor, "BC", gsa_1060[61][1], gi_980);
               DrawLine(ai_28, ad_32, ai_40, ad_44, cextITriangleBearishColor, "CD", gsa_1060[61][1], gi_980);
               DrawLine(ai_40, ad_44, ai_52, ad_56, cextITriangleBearishColor, "DE", gsa_1060[61][1], gi_980);
               if (bextDrawPatternDescr) {
                  DrawPoint("S", ai_4, ad_8, cextITriangleBearishColor, "a", gsa_1060[61][1], iextDescrFontSize, 1);
                  DrawPoint("L", ai_16, ad_20, cextITriangleBearishColor, "b", gsa_1060[61][1], iextDescrFontSize, 1);
                  DrawPoint("S", ai_28, ad_32, cextITriangleBearishColor, "c", gsa_1060[61][1], iextDescrFontSize, 1);
                  DrawPoint("L", ai_40, ad_44, cextITriangleBearishColor, "d", gsa_1060[61][1], iextDescrFontSize, 1);
                  DrawPoint("S", ai_52, ad_56, cextITriangleBearishColor, "e", gsa_1060[61][1], iextDescrFontSize, 1);
               }
               CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_1060[61][1], 61);
            } else {
               if (ai_0 == 62) {
                  DrawLine(ai_4, ad_8, ai_52, ad_56, cextNITriangleBullishColor, "AE", gsa_1060[62][1], gi_976);
                  DrawLine(ai_4, ld_132, ai_52, ld_124, cextNITriangleBullishColor, "BD", gsa_1060[62][1], gi_976);
                  DrawLine(ai_4, ad_8, ai_16, ad_20, cextNITriangleBullishColor, "AB", gsa_1060[62][1], gi_980);
                  DrawLine(ai_16, ad_20, ai_28, ad_32, cextNITriangleBullishColor, "BC", gsa_1060[62][1], gi_980);
                  DrawLine(ai_28, ad_32, ai_40, ad_44, cextNITriangleBullishColor, "CD", gsa_1060[62][1], gi_980);
                  DrawLine(ai_40, ad_44, ai_52, ad_56, cextNITriangleBullishColor, "DE", gsa_1060[62][1], gi_980);
                  if (bextDrawPatternDescr) {
                     DrawPoint("L", ai_4, ad_8, cextNITriangleBullishColor, "a", gsa_1060[62][1], iextDescrFontSize, 2);
                     DrawPoint("S", ai_16, ad_20, cextNITriangleBullishColor, "b", gsa_1060[62][1], iextDescrFontSize, 2);
                     DrawPoint("L", ai_28, ad_32, cextNITriangleBullishColor, "c", gsa_1060[62][1], iextDescrFontSize, 2);
                     DrawPoint("S", ai_40, ad_44, cextNITriangleBullishColor, "d", gsa_1060[62][1], iextDescrFontSize, 2);
                     DrawPoint("L", ai_52, ad_56, cextNITriangleBullishColor, "e", gsa_1060[62][1], iextDescrFontSize, 2);
                  }
                  CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_1060[62][1], 62);
               } else {
                  if (ai_0 == 63) {
                     DrawLine(ai_4, ad_8, ai_52, ad_56, cextNITriangleBearishColor, "AE", gsa_1060[63][1], gi_976);
                     DrawLine(ai_4, ld_132, ai_52, ld_124, cextNITriangleBearishColor, "BD", gsa_1060[63][1], gi_976);
                     DrawLine(ai_4, ad_8, ai_16, ad_20, cextNITriangleBearishColor, "AB", gsa_1060[63][1], gi_980);
                     DrawLine(ai_16, ad_20, ai_28, ad_32, cextNITriangleBearishColor, "BC", gsa_1060[63][1], gi_980);
                     DrawLine(ai_28, ad_32, ai_40, ad_44, cextNITriangleBearishColor, "CD", gsa_1060[63][1], gi_980);
                     DrawLine(ai_40, ad_44, ai_52, ad_56, cextNITriangleBearishColor, "DE", gsa_1060[63][1], gi_980);
                     if (bextDrawPatternDescr) {
                        DrawPoint("S", ai_4, ad_8, cextNITriangleBearishColor, "a", gsa_1060[63][1], iextDescrFontSize, 1);
                        DrawPoint("L", ai_16, ad_20, cextNITriangleBearishColor, "b", gsa_1060[63][1], iextDescrFontSize, 1);
                        DrawPoint("S", ai_28, ad_32, cextNITriangleBearishColor, "c", gsa_1060[63][1], iextDescrFontSize, 1);
                        DrawPoint("L", ai_40, ad_44, cextNITriangleBearishColor, "d", gsa_1060[63][1], iextDescrFontSize, 1);
                        DrawPoint("S", ai_52, ad_56, cextNITriangleBearishColor, "e", gsa_1060[63][1], iextDescrFontSize, 1);
                     }
                     CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_1060[61][1], 63);
                  }
               }
            }
         }
      }
   }
   return (0);
}

int Draw_DiaTriangle(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, int ai_64, double ad_68) {
   int li_84 = -1 * iBarShift(Symbol(), Period(), ai_28);
   int li_92 = -1 * iBarShift(Symbol(), Period(), ai_52);
   int li_96 = -1 * iBarShift(Symbol(), Period(), ai_64);
   if (li_84 - li_92 == 0) return (0);
   double ld_100 = (ad_32 - ad_56) / (li_84 - li_92);
   double ld_108 = ad_32 - ld_100 * li_84;
   double ld_116 = ld_100 * li_96 + ld_108;
   if (ai_0 == 58) {
      DrawLine(ai_16, ad_20, ai_64, ad_68, cextDiagonalColor, "AE", gsa_1060[58][1], gi_976);
      DrawLine(ai_28, ad_32, ai_52, ad_56, cextDiagonalColor, "BD", gsa_1060[58][1], gi_976);
      DrawLine(ai_52, ad_56, ai_64, ld_116, cextDiagonalColor, "DF", gsa_1060[58][1], gi_976);
      if (bextDrawPatternDescr) {
         DrawPoint("L", ai_16, ad_20, cextDiagonalDescColor, "1", gsa_1060[58][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_28, ad_32, cextDiagonalDescColor, "2", gsa_1060[58][1], iextDescrFontSize, 0);
         DrawPoint("L", ai_40, ad_44, cextDiagonalDescColor, "3", gsa_1060[58][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_52, ad_56, cextDiagonalDescColor, "4", gsa_1060[58][1], iextDescrFontSize, 0);
         DrawPoint("L", ai_64, ad_68, cextDiagonalDescColor, "5", gsa_1060[58][1], iextDescrFontSize, 0);
      }
      CreatePatternIdentityObject(ai_4, ad_8, cext5_0DescColor, gsa_1060[58][1], 58);
   } else {
      if (ai_0 == 59) {
         DrawLine(ai_16, ad_20, ai_64, ad_68, cextDiagonalColor, "AE", gsa_1060[59][1], gi_976);
         DrawLine(ai_28, ad_32, ai_52, ad_56, cextDiagonalColor, "BD", gsa_1060[59][1], gi_976);
         DrawLine(ai_52, ad_56, ai_64, ld_116, cextDiagonalColor, "DF", gsa_1060[59][1], gi_976);
         if (bextDrawPatternDescr) {
            DrawPoint("S", ai_16, ad_20, cextDiagonalDescColor, "1", gsa_1060[59][1], iextDescrFontSize, 0);
            DrawPoint("L", ai_28, ad_32, cextDiagonalDescColor, "2", gsa_1060[59][1], iextDescrFontSize, 0);
            DrawPoint("S", ai_40, ad_44, cextDiagonalDescColor, "3", gsa_1060[59][1], iextDescrFontSize, 0);
            DrawPoint("L", ai_52, ad_56, cextDiagonalDescColor, "4", gsa_1060[59][1], iextDescrFontSize, 0);
            DrawPoint("S", ai_64, ad_68, cextDiagonalDescColor, "5", gsa_1060[59][1], iextDescrFontSize, 0);
         }
         CreatePatternIdentityObject(ai_4, ad_8, cext5_0DescColor, gsa_1060[59][1], 59);
      }
   }
   return (0);
}

int Draw_OmarPattern(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56) {
   if (ai_0 == 45) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, gi_936, "XA", gsa_1060[45][1], gi_964);
      DrawLine(ai_16, ad_20, ai_28, ad_32, gi_936, "AB", gsa_1060[45][1], gi_964);
      DrawLine(ai_28, ad_32, ai_40, ad_44, gi_936, "BC", gsa_1060[45][1], gi_964);
      DrawLine(ai_40, ad_44, ai_52, ad_56, gi_936, "CD", gsa_1060[45][1], gi_964);
      CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[45][1], 45);
      ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_1060[45][1], gi_968);
      ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[45][1], gi_968);
      ProjectionLine(ai_52, ad_44 + 1.27 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_1060[45][1], gi_968);
      ProjectionLine(ai_52, ad_44 + 1.414 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_1060[45][1], gi_968);
      ProjectionLine(ai_52, ad_44 + 1.618 * (ad_44 - ad_56), SeaGreen, "T4", 1, 2, "T4", gsa_1060[45][1], gi_968);
   } else {
      if (ai_0 == 46) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, gi_940, "XA", gsa_1060[46][1], gi_964);
         DrawLine(ai_16, ad_20, ai_28, ad_32, gi_940, "AB", gsa_1060[46][1], gi_964);
         DrawLine(ai_28, ad_32, ai_40, ad_44, gi_940, "BC", gsa_1060[46][1], gi_964);
         DrawLine(ai_40, ad_44, ai_52, ad_56, gi_940, "CD", gsa_1060[46][1], gi_964);
         CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[46][1], 46);
         ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_1060[46][1], gi_968);
         ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[46][1], gi_968);
         ProjectionLine(ai_52, ad_44 + 1.27 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_1060[46][1], gi_968);
         ProjectionLine(ai_52, ad_44 + 1.414 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_1060[46][1], gi_968);
         ProjectionLine(ai_52, ad_44 + 1.618 * (ad_44 - ad_56), SeaGreen, "T4", 1, 2, "T4", gsa_1060[46][1], gi_968);
      } else {
         if (ai_0 == 47) {
            DrawLine(ai_4, ad_8, ai_16, ad_20, gi_936, "XA", gsa_1060[47][1], gi_964);
            DrawLine(ai_16, ad_20, ai_28, ad_32, gi_936, "AB", gsa_1060[47][1], gi_964);
            DrawLine(ai_28, ad_32, ai_40, ad_44, gi_936, "BC", gsa_1060[47][1], gi_964);
            DrawLine(ai_40, ad_44, ai_52, ad_56, gi_936, "CD", gsa_1060[47][1], gi_964);
            CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[47][1], 47);
            ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_1060[45][1], gi_968);
            ProjectionLine(ai_52, ad_44 + 0.786 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[47][1], gi_968);
            ProjectionLine(ai_52, ad_44 + 0.886 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_1060[47][1], gi_968);
            ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_1060[47][1], gi_968);
         } else {
            if (ai_0 == 48) {
               DrawLine(ai_4, ad_8, ai_16, ad_20, gi_940, "XA", gsa_1060[48][1], gi_964);
               DrawLine(ai_16, ad_20, ai_28, ad_32, gi_940, "AB", gsa_1060[48][1], gi_964);
               DrawLine(ai_28, ad_32, ai_40, ad_44, gi_940, "BC", gsa_1060[48][1], gi_964);
               DrawLine(ai_40, ad_44, ai_52, ad_56, gi_940, "CD", gsa_1060[48][1], gi_964);
               CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[48][1], 48);
               ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_1060[48][1], gi_968);
               ProjectionLine(ai_52, ad_44 + 0.786 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[48][1], gi_968);
               ProjectionLine(ai_52, ad_44 + 0.886 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_1060[48][1], gi_968);
               ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_1060[48][1], gi_968);
            } else {
               if (ai_0 == 49) {
                  DrawLine(ai_4, ad_8, ai_16, ad_20, gi_936, "XA", gsa_1060[49][1], gi_964);
                  DrawLine(ai_16, ad_20, ai_28, ad_32, gi_936, "AB", gsa_1060[49][1], gi_964);
                  DrawLine(ai_28, ad_32, ai_40, ad_44, gi_936, "BC", gsa_1060[49][1], gi_964);
                  DrawLine(ai_40, ad_44, ai_52, ad_56, gi_936, "CD", gsa_1060[49][1], gi_964);
                  CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[49][1], 49);
                  ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_1060[49][1], gi_968);
                  ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[49][1], gi_968);
                  ProjectionLine(ai_52, ad_44 + 1.27 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_1060[49][1], gi_968);
                  ProjectionLine(ai_52, ad_44 + 1.414 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_1060[49][1], gi_968);
               } else {
                  if (ai_0 == 50) {
                     DrawLine(ai_4, ad_8, ai_16, ad_20, gi_940, "XA", gsa_1060[50][1], gi_964);
                     DrawLine(ai_16, ad_20, ai_28, ad_32, gi_940, "AB", gsa_1060[50][1], gi_964);
                     DrawLine(ai_28, ad_32, ai_40, ad_44, gi_940, "BC", gsa_1060[50][1], gi_964);
                     DrawLine(ai_40, ad_44, ai_52, ad_56, gi_940, "CD", gsa_1060[50][1], gi_964);
                     CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[50][1], 50);
                     ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_1060[50][1], gi_968);
                     ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[50][1], gi_968);
                     ProjectionLine(ai_52, ad_44 + 1.27 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_1060[50][1], gi_968);
                     ProjectionLine(ai_52, ad_44 + 1.414 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_1060[50][1], gi_968);
                  } else {
                     if (ai_0 == 51) {
                        DrawLine(ai_4, ad_8, ai_16, ad_20, gi_936, "XA", gsa_1060[51][1], gi_964);
                        DrawLine(ai_16, ad_20, ai_28, ad_32, gi_936, "AB", gsa_1060[51][1], gi_964);
                        DrawLine(ai_28, ad_32, ai_40, ad_44, gi_936, "BC", gsa_1060[51][1], gi_964);
                        DrawLine(ai_40, ad_44, ai_52, ad_56, gi_936, "CD", gsa_1060[51][1], gi_964);
                        CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[51][1], 51);
                        ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_1060[51][1], gi_968);
                        ProjectionLine(ai_52, ad_44 + 0.707 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[51][1], gi_968);
                        ProjectionLine(ai_52, ad_44 + 0.786 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[51][1], gi_968);
                        ProjectionLine(ai_52, ad_44 + 0.886 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_1060[51][1], gi_968);
                        ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_1060[51][1], gi_968);
                     } else {
                        if (ai_0 == 52) {
                           DrawLine(ai_4, ad_8, ai_16, ad_20, gi_940, "XA", gsa_1060[52][1], gi_964);
                           DrawLine(ai_16, ad_20, ai_28, ad_32, gi_940, "AB", gsa_1060[52][1], gi_964);
                           DrawLine(ai_28, ad_32, ai_40, ad_44, gi_940, "BC", gsa_1060[52][1], gi_964);
                           DrawLine(ai_40, ad_44, ai_52, ad_56, gi_940, "CD", gsa_1060[52][1], gi_964);
                           CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[52][1], 52);
                           ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_1060[52][1], gi_968);
                           ProjectionLine(ai_52, ad_44 + 0.707 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[52][1], gi_968);
                           ProjectionLine(ai_52, ad_44 + 0.786 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_1060[52][1], gi_968);
                           ProjectionLine(ai_52, ad_44 + 0.886 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_1060[52][1], gi_968);
                           ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_1060[52][1], gi_968);
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (0);
}

int Draw_VibrationPattern(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20) {
   string l_dbl2str_28 = DoubleToStr(10000.0 * MathAbs(ad_8 - ad_20), 0);
   string ls_36 = iBarShift(Symbol(), Period(), ai_4) - iBarShift(Symbol(), Period(), ai_16);
   if (ai_0 == 53) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, gi_608, "PT", gsa_1060[53][1], gi_972);
      DrawPoint("S", ai_4, ad_8, gi_608, l_dbl2str_28 + " ; " + ls_36, gsa_1060[53][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, gi_620, gsa_1060[53][1], 53);
   } else {
      if (ai_0 == 54) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, gi_612, "P", gsa_1060[54][1], gi_972);
         DrawPoint("S", ai_4, ad_8, gi_612, l_dbl2str_28 + " ; " + ls_36, gsa_1060[54][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, gi_620, gsa_1060[54][1], 54);
      } else {
         if (ai_0 == 55) {
            DrawLine(ai_4, ad_8, ai_16, ad_20, gi_616, "T", gsa_1060[55][1], gi_972);
            DrawPoint("S", ai_4, ad_8, gi_620, l_dbl2str_28 + " ; " + ls_36, gsa_1060[55][1], iextDescrFontSize, 0);
            CreatePatternIdentityObject(ai_4, ad_8, gi_620, gsa_1060[55][1], 55);
         }
      }
   }
   return (0);
}

int Draw_Pattern_Fibo(int ai_0, int ai_4, double ad_8, int ai_unused_16, double ad_20, int ai_28, double ad_32) {
   if (ad_8 - ad_20 == 0.0) return (0);
   string l_dbl2str_40 = DoubleToStr((ad_32 - ad_20) / (ad_8 - ad_20), 3);
   if (ai_0 == 66 || ai_0 == 68 || ai_0 == 70 || ai_0 == 72 || ai_0 == 74 || ai_0 == 76) {
      CreatePatternIdentityObject(ai_4, ad_8, cextFiboDescColor, gsa_1060[66][1], 66);
      DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_40, Chocolate, "relAC", gsa_1060[66][1]);
   } else {
      if (ai_0 == 67 || ai_0 == 69 || ai_0 == 71 || ai_0 == 73 || ai_0 == 75 || ai_0 == 77) {
         CreatePatternIdentityObject(ai_4, ad_8, cextFiboDescColor, gsa_1060[67][1], 67);
         DrawRelationLine(ai_4, ad_8, ai_28, ad_32, l_dbl2str_40, Chocolate, "relAC", gsa_1060[67][1]);
      }
   }
   return (0);
}

void DrawPoint(string as_0, int ai_8, double a_price_12, color a_color_20, string a_text_24, string as_32, int a_fontsize_40, int ai_44) {
   int l_datetime_56;
   string l_name_48 = "HAR_O_" + "point_" + as_32 + "_" + a_text_24 + "_" + "_bars" + iBarShift(Symbol(), Period(), ai_8) + "_" + DateTimeReformat(TimeToStr(ai_8, TIME_DATE|TIME_MINUTES));
   ObjectDelete(l_name_48);
   if (ai_44 == 1) l_datetime_56 = ai_8 + 3 * (Time[0] - Time[1]);
   else {
      if (ai_44 == 2) l_datetime_56 = ai_8 - 3 * (Time[0] - Time[1]);
      else
         if (ai_44 == 0) l_datetime_56 = ai_8;
   }
   if (as_0 == "S") ObjectCreate(l_name_48, OBJ_TEXT, 0, l_datetime_56, a_price_12 + LabelOffset(a_fontsize_40 + 8));
   else {
      if (as_0 == "L") ObjectCreate(l_name_48, OBJ_TEXT, 0, l_datetime_56, a_price_12);
      else Alert("PANIC: unknown DrawPoint point type:", as_0);
   }
   ObjectSetText(l_name_48, a_text_24, a_fontsize_40, "Arial", a_color_20);
}

double LabelOffset(int ai_0) {
   double ld_4 = WindowPriceMax();
   double ld_12 = WindowPriceMin();
   if (ld_4 == 0.0 || ld_12 == 0.0) return (0);
   return (ai_0 * (ld_4 - ld_12) / WindowYPixels());
}

void DrawLine(int ai_0, double a_price_4, int ai_12, double a_price_16, color a_color_24, string as_28, string as_36, int a_width_44) {
   string l_name_48 = "HAR_O_" + "line_" + as_36 + "_" + as_28 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + iBarShift(Symbol(), Period(), ai_12) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(l_name_48);
   ObjectCreate(l_name_48, OBJ_TREND, 0, ai_0, a_price_4, ai_12, a_price_16);
   ObjectSet(l_name_48, OBJPROP_COLOR, a_color_24);
   ObjectSet(l_name_48, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(l_name_48, OBJPROP_WIDTH, a_width_44);
   ObjectSet(l_name_48, OBJPROP_BACK, TRUE);
   ObjectSet(l_name_48, OBJPROP_RAY, FALSE);
}

void ProjectionLine(int ai_0, double a_price_4, color a_color_12, string as_16, int ai_unused_24, int ai_28, string as_32, string as_40, int ai_unused_48) {
   int li_52 = Time[iBarShift(Symbol(), Period(), ai_0)] - (Time[iBarShift(Symbol(), Period(), ai_0) + ai_28]);
   string l_name_56 = "HAR_O_" + "fibo_" + as_40 + "_" + as_32 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(l_name_56);
   ObjectCreate(l_name_56, OBJ_FIBO, 0, ai_0 - li_52, a_price_4, ai_0 + li_52, a_price_4);
   ObjectSet(l_name_56, OBJPROP_STYLE, STYLE_DASH);
   ObjectSet(l_name_56, OBJPROP_COLOR, a_color_12);
   ObjectSet(l_name_56, OBJPROP_LEVELCOLOR, a_color_12);
   ObjectSet(l_name_56, OBJPROP_WIDTH, 1);
   ObjectSet(l_name_56, OBJPROP_FIBOLEVELS, 1);
   ObjectSet(l_name_56, OBJPROP_LEVELWIDTH, 1);
   ObjectSet(l_name_56, OBJPROP_FIRSTLEVEL, 0);
   ObjectSet(l_name_56, OBJPROP_RAY, FALSE);
   ObjectSetFiboDescription(l_name_56, 0, as_40 + " " + as_16 + "   @%$");
   ObjectSet(l_name_56, OBJPROP_ANGLE, 30);
}

void PRZ_FiboIntRet(string as_0, double ad_8, double ad_16, int ai_24, double a_price_28, int ai_unused_36, double a_price_40, int ai_48, color a_color_52) {
   int li_64 = (Time[1] - Time[0]) << 3;
   string l_name_68 = "HAR_O_" + "PRZ_fibointret_" + as_0 + "_" + iBarShift(Symbol(), Period(), ai_24) + "_" + iBarShift(Symbol(), Period(), ai_48);
   ObjectDelete(l_name_68);
   ObjectCreate(l_name_68, OBJ_FIBO, 0, ai_48, a_price_28, ai_48 + li_64, a_price_40);
   ObjectSet(l_name_68, OBJPROP_FIBOLEVELS, gi_412 - 1);
   int li_60 = 0;
   for (int l_index_56 = 0; l_index_56 < gi_412; l_index_56++) {
      if (a_price_40 + gda_408[l_index_56] * (a_price_28 - a_price_40) < ad_16 && a_price_40 + gda_408[l_index_56] * (a_price_28 - a_price_40) > ad_8) {
         ObjectSet(l_name_68, li_60 + 210, gda_408[l_index_56]);
         ObjectSet(l_name_68, OBJPROP_RAY, FALSE);
         ObjectSetFiboDescription(l_name_68, li_60, DoubleToStr(gda_408[l_index_56], 3));
         li_60++;
      }
   }
   ObjectSet(l_name_68, OBJPROP_STYLE, STYLE_DASH);
   ObjectSet(l_name_68, OBJPROP_COLOR, Black);
   ObjectSet(l_name_68, OBJPROP_LEVELCOLOR, a_color_52);
   ObjectSet(l_name_68, OBJPROP_WIDTH, 1);
   ObjectSet(l_name_68, OBJPROP_LEVELWIDTH, 1);
   ObjectSet(l_name_68, OBJPROP_FIBOLEVELS, li_60);
}

void PRZ_FiboExtRet(string as_0, double ad_8, double ad_16, int ai_24, double a_price_28, int ai_unused_36, double a_price_40, int ai_48, color a_color_52) {
   int li_64 = 6 * (Time[1] - Time[0]);
   string l_name_68 = "HAR_O_" + "PRZ_fiboextret_" + as_0 + "_" + iBarShift(Symbol(), Period(), ai_24) + "_" + iBarShift(Symbol(), Period(), ai_48);
   ObjectDelete(l_name_68);
   ObjectCreate(l_name_68, OBJ_FIBO, 0, ai_48, a_price_28, ai_48 + li_64, a_price_40);
   ObjectSet(l_name_68, OBJPROP_FIBOLEVELS, gi_396 - 1);
   int li_60 = 0;
   for (int l_index_56 = 0; l_index_56 < gi_396; l_index_56++) {
      if (a_price_40 + gda_392[l_index_56] * (a_price_28 - a_price_40) < ad_16 && a_price_40 + gda_392[l_index_56] * (a_price_28 - a_price_40) > ad_8) {
         ObjectSet(l_name_68, li_60 + 210, gda_392[l_index_56]);
         ObjectSet(l_name_68, OBJPROP_RAY, FALSE);
         ObjectSetFiboDescription(l_name_68, li_60, DoubleToStr(gda_392[l_index_56], 3));
         li_60++;
      }
   }
   ObjectSet(l_name_68, OBJPROP_STYLE, STYLE_DASH);
   ObjectSet(l_name_68, OBJPROP_COLOR, Black);
   ObjectSet(l_name_68, OBJPROP_LEVELCOLOR, a_color_52);
   ObjectSet(l_name_68, OBJPROP_WIDTH, 1);
   ObjectSet(l_name_68, OBJPROP_FIBOLEVELS, li_60);
   ObjectSet(l_name_68, OBJPROP_LEVELWIDTH, 1);
}

void PRZ_FiboProj(string as_0, double ad_8, double ad_16, int ai_24, double a_price_28, int ai_unused_36, double ad_40, int ai_48, color a_color_52) {
   int li_64 = (Time[1] - Time[0]) << 2;
   string l_name_68 = "HAR_O_" + "PRZ_fiboextproj_" + as_0 + "_" + iBarShift(Symbol(), Period(), ai_24) + "_" + iBarShift(Symbol(), Period(), ai_48);
   ObjectDelete(l_name_68);
   ObjectCreate(l_name_68, OBJ_FIBO, 0, ai_48, a_price_28 + (a_price_28 - ad_40), ai_48 + li_64, a_price_28);
   ObjectSet(l_name_68, OBJPROP_FIBOLEVELS, gi_428 - 1);
   int li_60 = 0;
   for (int l_index_56 = 0; l_index_56 < gi_428; l_index_56++) {
      if (a_price_28 + gda_424[l_index_56] * (a_price_28 - ad_40) < ad_16 && a_price_28 + gda_424[l_index_56] * (a_price_28 - ad_40) > ad_8) {
         ObjectSet(l_name_68, li_60 + 210, gda_424[l_index_56]);
         ObjectSet(l_name_68, OBJPROP_RAY, FALSE);
         ObjectSetFiboDescription(l_name_68, li_60, DoubleToStr(gda_424[l_index_56], 3));
         li_60++;
      }
   }
   ObjectSet(l_name_68, OBJPROP_STYLE, STYLE_DASH);
   ObjectSet(l_name_68, OBJPROP_COLOR, Black);
   ObjectSet(l_name_68, OBJPROP_LEVELCOLOR, a_color_52);
   ObjectSet(l_name_68, OBJPROP_WIDTH, 1);
   ObjectSet(l_name_68, OBJPROP_FIBOLEVELS, li_60);
   ObjectSet(l_name_68, OBJPROP_LEVELWIDTH, 1);
}

void PRZ_FiboAPPProj(string as_0, double ad_8, double ad_16, int ai_24, double ad_28, int ai_unused_36, double ad_40, int ai_unused_48, double a_price_52, int ai_60, color a_color_64) {
   int li_76 = (Time[1] - Time[0]) * 2;
   string l_name_80 = "HAR_O_" + "PRZ_fiboAPPproj_" + as_0 + "_" + iBarShift(Symbol(), Period(), ai_24) + "_" + iBarShift(Symbol(), Period(), ai_60);
   ObjectDelete(l_name_80);
   ObjectCreate(l_name_80, OBJ_FIBO, 0, ai_60, a_price_52 + (ad_28 - ad_40), ai_60 + li_76, a_price_52);
   ObjectSet(l_name_80, OBJPROP_FIBOLEVELS, gi_444 - 1);
   int li_72 = 0;
   for (int l_index_68 = 0; l_index_68 < gi_444; l_index_68++) {
      if (a_price_52 + gda_440[l_index_68] * (ad_28 - ad_40) < ad_16 && a_price_52 + gda_440[l_index_68] * (ad_28 - ad_40) > ad_8) {
         ObjectSet(l_name_80, li_72 + 210, gda_440[l_index_68]);
         ObjectSet(l_name_80, OBJPROP_RAY, FALSE);
         ObjectSetFiboDescription(l_name_80, li_72, DoubleToStr(gda_440[l_index_68], 3));
         li_72++;
      }
   }
   ObjectSet(l_name_80, OBJPROP_STYLE, STYLE_DASH);
   ObjectSet(l_name_80, OBJPROP_COLOR, Black);
   ObjectSet(l_name_80, OBJPROP_LEVELCOLOR, a_color_64);
   ObjectSet(l_name_80, OBJPROP_WIDTH, 1);
   ObjectSet(l_name_80, OBJPROP_FIBOLEVELS, li_72);
   ObjectSet(l_name_80, OBJPROP_LEVELWIDTH, 1);
}

void SmartRetracementLines(int ai_0, double a_price_4, int a_datetime_12, double a_price_16, int ai_unused_24, double ad_28, color a_color_36, string as_40, string as_48, int ai_unused_56, int ai_60, string as_64, string as_72, int ai_unused_80) {
   double ld_92;
   double ld_100;
   double ld_108;
   int li_120;
   string l_name_124;
   double lda_84[] = {0.236, 0.382, 0.414, 0.5, 0.618, 0.707, 0.786, 0.886, 1.0, 1.27, 1.272, 1.414, 1.618, 2.0, 2.24, 2.618, 3.618};
   int li_88 = 17;
   if (a_price_16 - a_price_4 != 0.0) {
      ld_92 = (a_price_16 - ad_28) / (a_price_16 - a_price_4);
      for (int l_index_116 = 0; l_index_116 < li_88; l_index_116++) {
         if (lda_84[l_index_116] < ld_92) {
            ld_100 = lda_84[l_index_116];
            ld_108 = lda_84[l_index_116 + 1];
         }
      }
      li_120 = Time[iBarShift(Symbol(), Period(), ai_0)] - (Time[iBarShift(Symbol(), Period(), ai_0) + ai_60]);
      l_name_124 = "HAR_O_" + "ifibo_" + as_72 + "_" + as_64 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
      ObjectDelete(l_name_124);
      ObjectCreate(l_name_124, OBJ_FIBO, 0, ai_0 + li_120, a_price_4, a_datetime_12, a_price_16);
      ObjectSet(l_name_124, OBJPROP_STYLE, STYLE_DOT);
      ObjectSet(l_name_124, OBJPROP_COLOR, a_color_36);
      ObjectSet(l_name_124, OBJPROP_LEVELCOLOR, a_color_36);
      ObjectSet(l_name_124, OBJPROP_WIDTH, 1);
      ObjectSet(l_name_124, OBJPROP_FIBOLEVELS, 2);
      ObjectSet(l_name_124, OBJPROP_LEVELWIDTH, 1);
      ObjectSet(l_name_124, OBJPROP_FIRSTLEVEL, ld_100);
      ObjectSet(l_name_124, 211, ld_108);
      ObjectSet(l_name_124, OBJPROP_RAY, FALSE);
      ObjectSetFiboDescription(l_name_124, 0, as_40 + DoubleToStr(ld_100, 3) + as_48 + "   %$");
      ObjectSetFiboDescription(l_name_124, 1, as_40 + DoubleToStr(ld_108, 3) + as_48 + "   %$");
      ObjectSet(l_name_124, OBJPROP_ANGLE, 30);
   }
}

void DrawRelationLine(int ai_0, double a_price_4, int a_datetime_12, double a_price_16, string as_24, color a_color_32, string as_36, string as_44) {
   double ld_52 = dextMaxDeviation;
   double ld_60 = 1000;
   string l_name_68 = "HAR_O_" + "relline_" + as_44 + "_" + as_36 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(l_name_68);
   ObjectCreate(l_name_68, OBJ_TREND, 0, ai_0, a_price_4, a_datetime_12, a_price_16);
   ObjectSet(l_name_68, OBJPROP_COLOR, a_color_32);
   ObjectSet(l_name_68, OBJPROP_STYLE, STYLE_DASHDOTDOT);
   ObjectSet(l_name_68, OBJPROP_WIDTH, 1);
   ObjectSet(l_name_68, OBJPROP_BACK, TRUE);
   ObjectSet(l_name_68, OBJPROP_RAY, FALSE);
   l_name_68 = "HAR_O_" + "linedesc_" + as_44 + "_" + as_36 + "_" + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(l_name_68);
   int l_shift_76 = iBarShift(Symbol(), Period(), ai_0);
   int l_shift_80 = iBarShift(Symbol(), Period(), a_datetime_12);
   int li_84 = (l_shift_76 + l_shift_80) / 2;
   ObjectCreate(l_name_68, OBJ_TEXT, 0, Time[li_84], MathAbs(a_price_4 + a_price_16) / 2.0);
   double l_str2dbl_88 = StrToDouble(as_24);
   string l_dbl2str_96 = "";
   for (int l_index_104 = 0; l_index_104 < gi_380; l_index_104++) {
      if (l_str2dbl_88 >= gda_376[l_index_104] * (1.0 - ld_52) && l_str2dbl_88 <= gda_376[l_index_104] * (ld_52 + 1.0) && MathAbs(l_str2dbl_88 - gda_376[l_index_104]) < ld_60) {
         l_dbl2str_96 = DoubleToStr(gda_376[l_index_104], 3);
         ld_60 = MathAbs(l_str2dbl_88 - gda_376[l_index_104]);
      }
   }
   if (StringLen(l_dbl2str_96) > 0) ObjectSetText(l_name_68, as_24 + " ( " + l_dbl2str_96 + " )", 8, "Arial", extTextColor);
   else ObjectSetText(l_name_68, DoubleToStr(100.0 * StrToDouble(as_24), 1), 8, "Arial", DimGray);
   if (bextRelationAngleRotate) {
      ObjectSet(l_name_68, OBJPROP_ANGLE, AngleEdit(ai_0, a_price_4, a_datetime_12, a_price_16));
      return;
   }
   ObjectSet(l_name_68, OBJPROP_ANGLE, 0);
}

double RoundedRelation(double ad_0) {
   double ld_ret_24;
   double ld_8 = dextMaxDeviation;
   double ld_16 = 1000;
   for (int l_index_32 = 0; l_index_32 < gi_380; l_index_32++) {
      if (ad_0 >= gda_376[l_index_32] * (1.0 - ld_8) && ad_0 <= gda_376[l_index_32] * (ld_8 + 1.0) && MathAbs(ad_0 - gda_376[l_index_32]) < ld_16) {
         ld_ret_24 = gda_376[l_index_32];
         ld_16 = MathAbs(ad_0 - gda_376[l_index_32]);
      }
   }
   return (ld_ret_24);
}

double AngleEdit(int ai_0, double ad_4, int ai_12, double ad_16) {
   int l_shift_52 = iBarShift(Symbol(), Period(), ai_0);
   int l_shift_56 = iBarShift(Symbol(), Period(), ai_12);
   double ld_24 = WindowPriceMax();
   double ld_32 = WindowPriceMin();
   int li_48 = WindowBarsPerChart();
   if (ld_24 == 0.0 || ld_32 == 0.0 || li_48 == 0 || l_shift_52 - l_shift_56 == 0) return (0.0);
   double ld_ret_40 = 57.3 * MathArctan((ad_16 - ad_4) * WindowYPixels() / (ld_24 - ld_32) / ((l_shift_52 - l_shift_56) * WindowYPixels() / li_48));
   return (ld_ret_40);
}

void DrawTriangle(int ai_0, double a_price_4, int ai_12, double a_price_16, int ai_24, double a_price_28, color a_color_36, string as_40, string as_48) {
   string l_name_56 = "HAR_O_" + "tria_" + as_48 + "_" + as_40 + "_" + iBarShift(Symbol(), Period(), ai_0) + "_" + iBarShift(Symbol(), Period(), ai_12) + "_" + iBarShift(Symbol(), Period(), ai_24) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(l_name_56);
   ObjectCreate(l_name_56, OBJ_TRIANGLE, 0, ai_0, a_price_4, ai_12, a_price_16, ai_24, a_price_28);
   ObjectSet(l_name_56, OBJPROP_COLOR, a_color_36);
   ObjectSet(l_name_56, OBJPROP_BACK, TRUE);
}

void CalcRectangle(int ai_0, double ad_4, int ai_12, double ad_16, double a_price_24, double a_price_32, color a_color_40, string as_44, string as_52) {
   int l_shift_60;
   int l_shift_64;
   double ld_68;
   double ld_76;
   int li_84;
   int li_88;
   int li_92;
   int li_96;
   string l_name_100;
   if (bextDrawRectangle != FALSE) {
      l_shift_60 = iBarShift(Symbol(), Period(), ai_0);
      l_shift_64 = iBarShift(Symbol(), Period(), ai_12);
      if (l_shift_60 - l_shift_64 != 0) {
         ld_68 = (ad_4 - ad_16) / (l_shift_60 - l_shift_64);
         ld_76 = ad_4 - ld_68 * l_shift_60;
         if (ld_68 != 0.0) {
            li_84 = (a_price_24 - ld_76) / ld_68;
            li_88 = (a_price_32 - ld_76) / ld_68;
            if (li_84 > 0) li_92 = iTime(NULL, 0, li_84);
            else li_92 = Time[0] - 60 * (li_84 * Period());
            if (li_88 > 0) li_96 = iTime(NULL, 0, li_88);
            else li_96 = Time[0] - 60 * (li_88 * Period());
            l_name_100 = "HAR_O_" + "rect_" + as_52 + "_" + as_44 + "_" + iBarShift(Symbol(), Period(), li_92) + "_" + iBarShift(Symbol(), Period(), li_96) + "_" + DateTimeReformat(TimeToStr(li_92, TIME_DATE|TIME_MINUTES));
            ObjectDelete(l_name_100);
            ObjectCreate(l_name_100, OBJ_RECTANGLE, 0, li_92, a_price_24, li_96, a_price_32);
            ObjectSet(l_name_100, OBJPROP_COLOR, a_color_40);
            ObjectSet(l_name_100, OBJPROP_BACK, FALSE);
         }
      }
   }
}

void DrawDimentions(int ai_0, int ai_4, double ad_8, int ai_16, double a_price_20, int ai_28, double a_price_32, int ai_40, double a_price_44, int ai_52, double a_price_56) {
   double ld_64;
   double ld_72;
   double ld_80;
   double ld_88;
   int li_96;
   int li_100;
   int li_104;
   int li_108;
   int l_fontsize_112;
   double ld_116;
   string l_name_124;
   if (bextDrawPatternDim != FALSE) {
      ld_64 = MathAbs(ad_8 - a_price_20) / Point;
      ld_72 = MathAbs(a_price_20 - a_price_32) / Point;
      ld_80 = MathAbs(a_price_32 - a_price_44) / Point;
      ld_88 = MathAbs(a_price_44 - a_price_56) / Point;
      li_96 = iBarShift(Symbol(), Period(), ai_4) - iBarShift(Symbol(), Period(), ai_16);
      li_100 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
      li_104 = iBarShift(Symbol(), Period(), ai_28) - iBarShift(Symbol(), Period(), ai_40);
      li_108 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
      l_fontsize_112 = 8;
      ld_116 = LabelOffset(l_fontsize_112 + 7);
      if (ai_0 == 1) {
         l_name_124 = "HAR_O_" + "pattern_dim_XA" + iBarShift(Symbol(), Period(), ai_4) + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
         ObjectDelete(l_name_124);
         ObjectCreate(l_name_124, OBJ_TEXT, 0, ai_16, a_price_20 + ld_116);
         ObjectSetText(l_name_124, DoubleToStr(ld_64, 0) + " (" + DoubleToStr(li_96, 0) + ")", l_fontsize_112, "Arial", cextPatternDimColor);
         l_name_124 = "HAR_O_" + "pattern_dim_AB" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
         ObjectDelete(l_name_124);
         ObjectCreate(l_name_124, OBJ_TEXT, 0, ai_28, a_price_32);
         ObjectSetText(l_name_124, DoubleToStr(ld_72, 0) + " (" + DoubleToStr(li_100, 0) + ")", l_fontsize_112, "Arial", cextPatternDimColor);
         l_name_124 = "HAR_O_" + "pattern_dim_BC" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
         ObjectDelete(l_name_124);
         ObjectCreate(l_name_124, OBJ_TEXT, 0, ai_40, a_price_44 + ld_116);
         ObjectSetText(l_name_124, DoubleToStr(ld_80, 0) + " (" + DoubleToStr(li_104, 0) + ")", l_fontsize_112, "Arial", cextPatternDimColor);
         l_name_124 = "HAR_O_" + "pattern_dim_CD" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
         ObjectDelete(l_name_124);
         ObjectCreate(l_name_124, OBJ_TEXT, 0, ai_52, a_price_56);
         ObjectSetText(l_name_124, DoubleToStr(ld_88, 0) + " (" + DoubleToStr(li_108, 0) + ")", l_fontsize_112, "Arial", cextPatternDimColor);
      } else {
         if (ai_0 == -1) {
            l_name_124 = "HAR_O_" + "pattern_dim_XA" + iBarShift(Symbol(), Period(), ai_4) + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
            ObjectDelete(l_name_124);
            ObjectCreate(l_name_124, OBJ_TEXT, 0, ai_16, a_price_20);
            ObjectSetText(l_name_124, DoubleToStr(ld_64, 0) + " (" + DoubleToStr(li_96, 0) + ")", l_fontsize_112, "Arial", cextPatternDimColor);
            l_name_124 = "HAR_O_" + "pattern_dim_AB" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
            ObjectDelete(l_name_124);
            ObjectCreate(l_name_124, OBJ_TEXT, 0, ai_28, a_price_32 + ld_116);
            ObjectSetText(l_name_124, DoubleToStr(ld_72, 0) + " (" + DoubleToStr(li_100, 0) + ")", l_fontsize_112, "Arial", cextPatternDimColor);
            l_name_124 = "HAR_O_" + "pattern_dim_BC" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
            ObjectDelete(l_name_124);
            ObjectCreate(l_name_124, OBJ_TEXT, 0, ai_40, a_price_44);
            ObjectSetText(l_name_124, DoubleToStr(ld_80, 0) + " (" + DoubleToStr(li_104, 0) + ")", l_fontsize_112, "Arial", cextPatternDimColor);
            l_name_124 = "HAR_O_" + "pattern_dim_CD" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
            ObjectDelete(l_name_124);
            ObjectCreate(l_name_124, OBJ_TEXT, 0, ai_52, a_price_56 + ld_116);
            ObjectSetText(l_name_124, DoubleToStr(ld_88, 0) + " (" + DoubleToStr(li_108, 0) + ")", l_fontsize_112, "Arial", cextPatternDimColor);
         }
      }
   }
}

void DrawDetailedDimentions(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56) {
   double ld_64;
   double ld_72;
   double ld_80;
   double ld_88;
   int li_96;
   int li_100;
   int li_104;
   int li_108;
   double ld_112;
   double ld_120;
   double ld_128;
   double ld_136;
   int l_fontsize_144;
   double ld_148;
   string l_name_156;
   string l_text_164;
   string l_text_172;
   if (bextDrawDetailedPatternDim != FALSE) {
      ld_64 = MathAbs(ad_8 - ad_20) / Point;
      ld_72 = MathAbs(ad_20 - ad_32) / Point;
      ld_80 = MathAbs(ad_32 - ad_44) / Point;
      ld_88 = MathAbs(ad_44 - ad_56) / Point;
      li_96 = iBarShift(Symbol(), Period(), ai_4) - iBarShift(Symbol(), Period(), ai_16);
      li_100 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
      li_104 = iBarShift(Symbol(), Period(), ai_28) - iBarShift(Symbol(), Period(), ai_40);
      li_108 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
      ld_112 = (ad_20 - ad_32) / (ad_20 - ad_8);
      ld_120 = (ad_44 - ad_32) / (ad_20 - ad_32);
      ld_128 = (ad_44 - ad_32) / (ad_44 - ad_56);
      ld_136 = (ad_44 - ad_56) / (ad_44 - ad_8);
      l_fontsize_144 = 8;
      ld_148 = LabelOffset(l_fontsize_144 + 7);
      l_text_164 = "";
      l_text_172 = "";
      if (ai_0 == 1) l_text_164 = "Bu";
      else
         if (ai_0 == -1) l_text_164 = "Be";
      l_text_164 = l_text_164 + "  XA=" + DoubleToStr(ld_64, 0) + " (" + DoubleToStr(li_96, 0) + ")";
      l_text_164 = l_text_164 + "  AB=" + DoubleToStr(ld_72, 0) + " (" + DoubleToStr(li_100, 0) + ")";
      l_text_164 = l_text_164 + "  BC=" + DoubleToStr(ld_80, 0) + " (" + DoubleToStr(li_104, 0) + ")";
      l_text_164 = l_text_164 + "  CD=" + DoubleToStr(ld_88, 0) + " (" + DoubleToStr(li_108, 0) + ")";
      l_text_172 = " rXB=" + DoubleToStr(100.0 * ld_112, 1) + "(" + DoubleToStr(100.0 * RoundedRelation(ld_112), 1) + ")" + " rAC=" + DoubleToStr(100.0 * ld_120, 1) + "(" + DoubleToStr(100.0 * RoundedRelation(ld_120), 1) + ")" + " rBD=" + DoubleToStr(100.0 * ld_128, 1) + "(" + DoubleToStr(100.0 * RoundedRelation(ld_128), 1) + ")" + " rXD=" + DoubleToStr(100.0 * ld_136, 1) + "(" + DoubleToStr(100.0 * RoundedRelation(ld_136), 1) + ")";
      l_name_156 = "HAR_O_" + "pattern_ddim_info1" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
      ObjectDelete(l_name_156);
      ObjectCreate(l_name_156, OBJ_TEXT, 0, ai_16, ad_20 + ld_148);
      ObjectSetText(l_name_156, l_text_164, l_fontsize_144, "Arial", cextPatternDimColor);
      l_name_156 = "HAR_O_" + "pattern_ddim_info2" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
      ObjectDelete(l_name_156);
      ObjectCreate(l_name_156, OBJ_TEXT, 0, ai_16, ad_20 + ld_148 + ld_148);
      ObjectSetText(l_name_156, l_text_172, l_fontsize_144, "Arial", cextPatternDimColor);
   }
}

void CreatePatternIdentityObject(int ai_0, double a_price_4, color a_color_12, string as_16, string as_24) {
   string l_name_32 = "HAR_O_" + "pattern" + as_24 + "_" + as_16 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(l_name_32);
   ObjectCreate(l_name_32, OBJ_TEXT, 0, ai_0, a_price_4);
   ObjectSetText(l_name_32, ".", 12, "Arial", a_color_12);
   ObjectSet(l_name_32, OBJPROP_COLOR, extBackgroundColor);
}

void SigWebMonitoring() {
   string l_name_0;
   string ls_8;
   string ls_16;
   int l_shift_36;
   string ls_40;
   string ls_48;
   string ls_56;
   int l_objs_total_24 = ObjectsTotal();
   for (int l_index_28 = 0; l_index_28 < 90; l_index_28++) {
      if (gia_1056[l_index_28] < gia_1052[l_index_28]) {
         for (int li_32 = 0; li_32 < l_objs_total_24; li_32++) {
            l_name_0 = ObjectName(li_32);
            ls_8 = gsa_1060[l_index_28][1];
            ls_16 = gsa_1060[l_index_28][0];
            if (StringFind(l_name_0, "HAR_O_" + "pattern") >= 0 && StringFind(l_name_0, ls_8) >= 0) {
               if (StringFind(ls_16, "Bullish") > 0) {
                  ls_48 = StringSubstr(ls_16, 0, StringLen(ls_16) - StringLen("Bullish") - 1);
                  ls_56 = "Bullish";
               } else {
                  if (StringFind(ls_16, "Bearish") > 0) {
                     ls_48 = StringSubstr(ls_16, 0, StringLen(ls_16) - StringLen("Bearish") - 1);
                     ls_56 = "Bearish";
                  } else {
                     if (StringFind(ls_16, "Fibo") >= 0 || StringFind(ls_16, "Vibr") >= 0 || StringFind(ls_16, "Triangle") >= 0 || StringFind(ls_16, "pattern") >= 0) {
                        ls_48 = ls_16;
                        ls_56 = "";
                     } else {
                        Alert("ERROR: Pattern name " + ls_48 + " does not contain Bullish/Bearish");
                        ls_48 = ls_16;
                        ls_56 = "";
                     }
                  }
               }
               l_shift_36 = iBarShift(Symbol(), Period(), ObjectGet(l_name_0, OBJPROP_TIME1));
               l_name_0 = StringReplaceDoubleDots(l_name_0);
               ls_40 = sextSigWebMonitoringDir + Symbol() + "_" + PeriodDesc(Period()) + "_" + ls_48 + "_" + DateTimeReformat(TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS));
               WindowScreenShot(ls_40 + ".gif", 1200, 600, 0, -1, -1);
               WriteScreenshotInfo(ls_40 + ".txt", Symbol() + ";" + PeriodDesc(Period()) + ";" + ls_48 + ";" + ls_56 + ";" + DateTimeReformat(TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS)));
            }
         }
      }
   }
}

void ScreenshotNewObjects() {
   string l_name_0;
   string ls_8;
   string ls_16;
   int l_shift_36;
   string ls_40;
   string ls_48;
   string ls_56;
   int l_objs_total_24 = ObjectsTotal();
   for (int l_index_28 = 0; l_index_28 < 90; l_index_28++) {
      if (gia_1056[l_index_28] < gia_1052[l_index_28]) {
         for (int li_32 = 0; li_32 < l_objs_total_24; li_32++) {
            l_name_0 = ObjectName(li_32);
            ls_8 = gsa_1060[l_index_28][1];
            ls_16 = gsa_1060[l_index_28][0];
            if (StringFind(l_name_0, "HAR_O_" + "pattern") >= 0 && StringFind(l_name_0, ls_8) >= 0) {
               if (StringFind(ls_16, "Bullish") > 0) {
                  ls_48 = StringSubstr(ls_16, 0, StringLen(ls_16) - StringLen("Bullish") - 1);
                  ls_56 = "Bullish";
               } else {
                  if (StringFind(ls_16, "Bearish") > 0) {
                     ls_48 = StringSubstr(ls_16, 0, StringLen(ls_16) - StringLen("Bearish") - 1);
                     ls_56 = "Bearish";
                  } else {
                     if (StringFind(ls_16, "Fibo") >= 0 || StringFind(ls_16, "Vibr") >= 0 || StringFind(ls_16, "Triangle") >= 0 || StringFind(ls_16, "pattern") >= 0) {
                        ls_48 = ls_16;
                        ls_56 = "";
                     } else {
                        Alert("ERROR: Pattern name " + ls_48 + " does not contain Bullish/Bearish");
                        ls_48 = ls_16;
                        ls_56 = "";
                     }
                  }
               }
               l_shift_36 = iBarShift(Symbol(), Period(), ObjectGet(l_name_0, OBJPROP_TIME1));
               l_name_0 = StringReplaceDoubleDots(l_name_0);
               ls_40 = sextSaveImageDestinationDir + Symbol() + "_" + PeriodDesc(Period()) + "_" + ls_48 + "_" + ls_56 + "_" + DateTimeReformat(TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS));
               WindowScreenShot(ls_40 + ".gif", 1200, 600, 0, -1, -1);
            }
         }
      }
   }
}

void ScreenshotLostObjects() {
   string l_name_0;
   string ls_8;
   int l_shift_28;
   int l_objs_total_16 = ObjectsTotal();
   for (int l_index_20 = 0; l_index_20 < 90; l_index_20++) {
      if (gia_1056[l_index_20] > gia_1052[l_index_20]) {
         for (int li_24 = 0; li_24 < l_objs_total_16; li_24++) {
            l_name_0 = ObjectName(li_24);
            ls_8 = gsa_1060[l_index_20][1];
            if (StringFind(l_name_0, "HAR_O_" + "pattern") >= 0 && StringFind(l_name_0, ls_8) >= 0) {
               l_shift_28 = iBarShift(Symbol(), Period(), ObjectGet(l_name_0, OBJPROP_TIME1));
               l_name_0 = StringReplaceDoubleDots(l_name_0);
               WindowScreenShot(sextSaveImageDestinationDir + Symbol() + "_" + PeriodDesc(Period()) + l_name_0 + "_stop" + ".gif", 1200, 600, 0, -1, -1);
            }
         }
      }
   }
}

int WriteScreenshotInfo(string a_name_0, string as_8) {
   int l_file_16 = FileOpen(a_name_0, FILE_CSV|FILE_WRITE|FILE_READ, "/t");
   FileWrite(l_file_16, "INSTRUMENT;TF;PATTERN;TYPE;TIME");
   FileWrite(l_file_16, as_8);
   FileClose(l_file_16);
   return (0);
}

string StringReplaceDoubleDots(string as_0) {
   int li_8 = StringFind(as_0, ":");
   if (li_8 != -1) as_0 = StringSetChar(as_0, li_8, '_');
   return (as_0);
}

bool IsIt(string as_0) {
   string ls_8 = Symbol();
   if (StringFind(ls_8, as_0) == -1) return (FALSE);
   return (TRUE);
}

int DefaultMinSwing() {
   int li_ret_52;
   int li_0 = 1;
   for (int l_index_4 = 0; l_index_4 < g_index_1072; l_index_4++) {
      if (gsa_1064[l_index_4][0] == Symbol()) {
         if (StrToInteger(gsa_1064[l_index_4][1]) < Digits) li_0 = 10;
         switch (Period()) {
         case PERIOD_M1:
            return (StrToInteger(gsa_1064[l_index_4][2]) * li_0);
         case PERIOD_M5:
            return (StrToInteger(gsa_1064[l_index_4][3]) * li_0);
         case PERIOD_M15:
            return (StrToInteger(gsa_1064[l_index_4][4]) * li_0);
         case PERIOD_M30:
            return (StrToInteger(gsa_1064[l_index_4][5]) * li_0);
         case PERIOD_H1:
            return (StrToInteger(gsa_1064[l_index_4][6]) * li_0);
         case PERIOD_H4:
            return (StrToInteger(gsa_1064[l_index_4][7]) * li_0);
         case PERIOD_D1:
            return (StrToInteger(gsa_1064[l_index_4][8]) * li_0);
         case PERIOD_W1:
            return (StrToInteger(gsa_1064[l_index_4][9]) * li_0);
         case PERIOD_MN1:
            return (StrToInteger(gsa_1064[l_index_4][10]) * li_0);
         }
         Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
      }
   }
   string ls_12 = Symbol();
   if (IsIt("EURUSD") || IsIt("GBPUSD") || IsIt("EURCAD") || IsIt("EURCAD") || IsIt("EURAUD") || IsIt("GBPUSD") || IsIt("GBPCHF") || IsIt("GBPCAD") || IsIt("GBPAUD") ||
      IsIt("AUDCHF") || IsIt("AUDCAD") || IsIt("AUDNZD") || IsIt("AUDCHF") || IsIt("NZDCHF") || IsIt("USDCHF") || IsIt("USDCAD") || IsIt("AUDUSD") || IsIt("NZDUSD") || IsIt("CADCHF")) {
      if (Digits == 4) li_0 = 1;
      else {
         if (Digits == 5) li_0 = 10;
         else Alert("PANIC:!!! Unknown Digits number(not 4 or 5)");
      }
      switch (Period()) {
      case PERIOD_M1:
         return (20 * li_0);
      case PERIOD_M5:
         return (40 * li_0);
      case PERIOD_M15:
         return (70 * li_0);
      case PERIOD_M30:
         return (120 * li_0);
      case PERIOD_H1:
         return (160 * li_0);
      case PERIOD_H4:
         return (300 * li_0);
      case PERIOD_D1:
         return (550 * li_0);
      case PERIOD_W1:
         return (1250 * li_0);
      case PERIOD_MN1:
         return (2100 * li_0);
      }
      Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
   } else {
      if (IsIt("EURGBP") || IsIt("EURCHF")) {
         if (Digits == 4) li_0 = 1;
         else {
            if (Digits == 5) li_0 = 10;
            else Alert("PANIC:!!! Unknown Digits number(not 4 or 5)");
         }
         switch (Period()) {
         case PERIOD_M1:
            return (20 * li_0);
         case PERIOD_M5:
            return (30 * li_0);
         case PERIOD_M15:
            return (55 * li_0);
         case PERIOD_M30:
            return (80 * li_0);
         case PERIOD_H1:
            return (100 * li_0);
         case PERIOD_H4:
            return (150 * li_0);
         case PERIOD_D1:
            return (230 * li_0);
         case PERIOD_W1:
            return (700 * li_0);
         case PERIOD_MN1:
            return (1300 * li_0);
         }
         Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
      } else {
         if (IsIt("EURNZD") || IsIt("GBPNZD")) {
            if (Digits == 4) li_0 = 1;
            else {
               if (Digits == 5) li_0 = 10;
               else Alert("PANIC:!!! Unknown Digits number(not 4 or 5)");
            }
            switch (Period()) {
            case PERIOD_M1:
               return (20 * li_0);
            case PERIOD_M5:
               return (50 * li_0);
            case PERIOD_M15:
               return (90 * li_0);
            case PERIOD_M30:
               return (200 * li_0);
            case PERIOD_H1:
               return (250 * li_0);
            case PERIOD_H4:
               return (550 * li_0);
            case PERIOD_D1:
               return (1300 * li_0);
            case PERIOD_W1:
               return (2500 * li_0);
            case PERIOD_MN1:
               return (4000 * li_0);
            }
            Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
         } else {
            if (IsIt("GBPJPY")) {
               if (Digits == 2) li_0 = 1;
               else {
                  if (Digits == 3) li_0 = 10;
                  else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
               }
               switch (Period()) {
               case PERIOD_M1:
                  return (20 * li_0);
               case PERIOD_M5:
                  return (50 * li_0);
               case PERIOD_M15:
                  return (90 * li_0);
               case PERIOD_M30:
                  return (200 * li_0);
               case PERIOD_H1:
                  return (250 * li_0);
               case PERIOD_H4:
                  return (550 * li_0);
               case PERIOD_D1:
                  return (1300 * li_0);
               case PERIOD_W1:
                  return (2500 * li_0);
               case PERIOD_MN1:
                  return (4000 * li_0);
               }
               Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
            } else {
               if (IsIt("USDJPY") || IsIt("EURJPY") || IsIt("CHFJPY") || IsIt("CADJPY") || IsIt("AUDJPY") || IsIt("NZDJPY")) {
                  if (Digits == 2) li_0 = 1;
                  else {
                     if (Digits == 3) li_0 = 10;
                     else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
                  }
                  switch (Period()) {
                  case PERIOD_M1:
                     return (20 * li_0);
                  case PERIOD_M5:
                     return (40 * li_0);
                  case PERIOD_M15:
                     return (70 * li_0);
                  case PERIOD_M30:
                     return (120 * li_0);
                  case PERIOD_H1:
                     return (160 * li_0);
                  case PERIOD_H4:
                     return (300 * li_0);
                  case PERIOD_D1:
                     return (550 * li_0);
                  case PERIOD_W1:
                     return (1250 * li_0);
                  case PERIOD_MN1:
                     return (2100 * li_0);
                  }
                  Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
               } else {
                  if (IsIt("GOLD")) {
                     if (Digits == 2) li_0 = 1;
                     else {
                        if (Digits == 3) li_0 = 10;
                        else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
                     }
                     switch (Period()) {
                     case PERIOD_M1:
                        return (200 * li_0);
                     case PERIOD_M5:
                        return (400 * li_0);
                     case PERIOD_M15:
                        return (700 * li_0);
                     case PERIOD_M30:
                        return (1400 * li_0);
                     case PERIOD_H1:
                        return (3000 * li_0);
                     case PERIOD_H4:
                        return (9000 * li_0);
                     case PERIOD_D1:
                        return (12000 * li_0);
                     case PERIOD_W1:
                        return (30000 * li_0);
                     case PERIOD_MN1:
                        return (30000 * li_0);
                     }
                     Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
                  } else {
                     if (IsIt("SILVER")) {
                        if (Digits == 3) li_0 = 1;
                        else {
                           if (Digits == 4) li_0 = 10;
                           else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
                        }
                        switch (Period()) {
                        case PERIOD_M1:
                           return (60 * li_0);
                        case PERIOD_M5:
                           return (100 * li_0);
                        case PERIOD_M15:
                           return (300 * li_0);
                        case PERIOD_M30:
                           return (500 * li_0);
                        case PERIOD_H1:
                           return (750 * li_0);
                        case PERIOD_H4:
                           return (1000 * li_0);
                        case PERIOD_D1:
                           return (2000 * li_0);
                        case PERIOD_W1:
                           return (6000 * li_0);
                        case PERIOD_MN1:
                           return (9000 * li_0);
                        }
                        Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
                     } else {
                        if (IsIt("USDJPY") || IsIt("EURJPY") || IsIt("CHFJPY") || IsIt("CADJPY") || IsIt("AUDJPY") || IsIt("NZDJPY")) {
                           if (Digits == 2) li_0 = 1;
                           else {
                              if (Digits == 3) li_0 = 10;
                              else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
                           }
                           switch (Period()) {
                           case PERIOD_M1:
                              return (20 * li_0);
                           case PERIOD_M5:
                              return (40 * li_0);
                           case PERIOD_M15:
                              return (70 * li_0);
                           case PERIOD_M30:
                              return (120 * li_0);
                           case PERIOD_H1:
                              return (160 * li_0);
                           case PERIOD_H4:
                              return (300 * li_0);
                           case PERIOD_D1:
                              return (550 * li_0);
                           case PERIOD_W1:
                              return (1250 * li_0);
                           case PERIOD_MN1:
                              return (2100 * li_0);
                           }
                           Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
                        } else {
                           li_ret_52 = iATR(NULL, 0, 100, 0) * gi_188 / Point;
                           if (li_ret_52 > 0) return (li_ret_52);
                           Alert("ERROR: ATR returned ZERO. Chart data was not loaded. Retry.");
                           return (-1);
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (-1);
}

void HAR_FoundPatterns_Init() {
   for (int l_index_0 = 0; l_index_0 < 90; l_index_0++) {
      gia_1052[l_index_0] = 0;
      gia_1056[l_index_0] = 0;
   }
}

void HAR_FoundPatterns_Reset() {
   for (int l_index_0 = 0; l_index_0 < 90; l_index_0++) gia_1052[l_index_0] = 0;
}

void HAR_FoundPatterns_Increase(int ai_0) {
   gia_1052[ai_0]++;
}

string HAR_FoundPatterns_ShowSettings() {
   string ls_unused_40;
   int li_unused_0 = 0;
   string ls_8 = "Bars:" + iextMaxBars + "  Swing:" + iextHL_MinSwing + "  ZZ:" + g_index_112 + "  Used:" + iextMaxZZPointsUsed;
   if (bextShowHistoryPatterns) ls_8 = ls_8 + "  History: ON";
   else ls_8 = ls_8 + "  History: OFF";
   string ls_16 = "Dev:" + DoubleToStr(dextMaxDeviation, 1);
   if (bextCheckMultiZigzags == TRUE) {
      ls_16 = ls_16 + "  MultiZZ: ON";
      ls_16 = ls_16 + "  Range: (" + DoubleToStr(iextHL_MinSwing - dextHL_MultiZZMinSwingRange * iextHL_MinSwing, 0) + "," + DoubleToStr(iextHL_MinSwing + dextHL_MultiZZMinSwingRange * iextHL_MinSwing, 0) + ")";
      ls_16 = ls_16 + "  Step:" + (iextHL_MinSwing / iextHL_MultiZZMinSwingNum);
   } else ls_16 = ls_16 + "  MultiZZ: OFF";
   string ls_24 = "Found patterns:";
   string ls_unused_32 = "Mon:";
   Comment(ls_8 + " " + ls_16, 
   "\n", "" + ls_24);
   return ("");
}

string HAR_FoundPatterns_ShowPatterns() {
   string l_text_8;
   string l_name_16;
   int l_count_0 = 0;
   for (int li_4 = 1; li_4 < 90; li_4++) {
      l_name_16 = "HAR_S_" + "found_pattern_" + li_4;
      ObjectDelete(l_name_16);
      if (gia_1052[li_4] > 0) {
         ObjectCreate(l_name_16, OBJ_LABEL, 0, 0, 0);
         ObjectSet(l_name_16, OBJPROP_XDISTANCE, 7);
         ObjectSet(l_name_16, OBJPROP_YDISTANCE, 12 * l_count_0 + 33);
         if (bextShowHistoryPatterns == FALSE) l_text_8 = "-" + gsa_1060[li_4][0];
         else l_text_8 = "-" + gsa_1060[li_4][0] + " x " + gia_1052[li_4];
         if (StringFind(gsa_1060[li_4][0], "Bullish") > -1) {
            if (StringFind(gsa_1060[li_4][0], "Emerging") > -1) ObjectSetText(l_name_16, l_text_8, 10, "Arial", cextEmergingBullishColor);
            else ObjectSetText(l_name_16, l_text_8, 9, "Arial", LimeGreen);
         } else {
            if (StringFind(gsa_1060[li_4][0], "Bearish") > -1) {
               if (StringFind(gsa_1060[li_4][0], "Emerging") > -1) ObjectSetText(l_name_16, l_text_8, 10, "Arial", cextEmergingBearishColor);
               else ObjectSetText(l_name_16, l_text_8, 9, "Arial", Red);
            } else ObjectSetText(l_name_16, l_text_8, 9, "Arial", extTextColor);
         }
         l_count_0++;
      }
   }
   return ("");
}

void HAR_FoundPatterns_StoreCurr() {
   for (int l_index_0 = 0; l_index_0 < 90; l_index_0++) gia_1056[l_index_0] = gia_1052[l_index_0];
}

int HAR_FoundPatterns_IsChanged() {
   for (int l_index_0 = 0; l_index_0 < 90; l_index_0++)
      if (gia_1056[l_index_0] != gia_1052[l_index_0]) return (1);
   return (0);
}

int HAR_FoundPatterns_Alert(int ai_0) {
   string ls_32;
   string ls_8 = " ";
   string ls_16 = " ";
   int l_count_24 = 0;
   int l_count_28 = 0;
   for (int l_index_4 = 0; l_index_4 < 90; l_index_4++) {
      if (StringFind(gsa_1060[l_index_4][0], "Fibo") <= 0) {
         if (gia_1056[l_index_4] < gia_1052[l_index_4]) {
            if (l_count_24 > 0) ls_8 = ls_8 + ",";
            ls_8 = ls_8 + gsa_1060[l_index_4][0];
            l_count_24++;
         }
         if (gia_1056[l_index_4] > gia_1052[l_index_4] && bextAlertInvalidatedPatterns) {
            if (l_count_28 > 0) ls_16 = ls_16 + ",";
            ls_16 = ls_16 + gsa_1060[l_index_4][0];
            l_count_28++;
         }
      }
   }
   if (l_count_24 == 0 && l_count_28 == 0) return (0);
   if (l_count_24 > 0) ls_32 = ls_8 + " found";
   if (l_count_24 > 0 && l_count_28 > 0) ls_32 = ls_32 + ", ";
   if (l_count_28 > 0) ls_32 = ls_32 + ls_16 + " invalidated";
   ls_32 = "INFO:" + "korHarmonics" + ":" + Symbol() + ":" + PeriodDesc(Period()) + ":" + ls_32;
   if (ai_0 == 0) Alert(ls_32);
   if (ai_0 == 4) SendMail(ls_32, ls_32);
   return (0);
}

int LoadMinSwingDefaults(string as_0) {
   string ls_8 = 0;
   g_index_1072 = 0;
   int l_file_16 = InitInputFile(as_0);
   if (l_file_16 < 1) return (1);
   while (!FileIsEnding(l_file_16)) {
      ls_8 = FileReadString(l_file_16);
      if (ls_8 != "") {
         if (ls_8 == "symbol") {
            FileReadString(l_file_16);
            FileReadString(l_file_16);
            FileReadString(l_file_16);
            FileReadString(l_file_16);
            FileReadString(l_file_16);
            FileReadString(l_file_16);
            FileReadString(l_file_16);
            FileReadString(l_file_16);
            FileReadString(l_file_16);
            FileReadString(l_file_16);
         } else {
            gsa_1064[g_index_1072][0] = ls_8;
            gsa_1064[g_index_1072][1] = FileReadString(l_file_16);
            gsa_1064[g_index_1072][2] = FileReadString(l_file_16);
            gsa_1064[g_index_1072][3] = FileReadString(l_file_16);
            gsa_1064[g_index_1072][4] = FileReadString(l_file_16);
            gsa_1064[g_index_1072][5] = FileReadString(l_file_16);
            gsa_1064[g_index_1072][6] = FileReadString(l_file_16);
            gsa_1064[g_index_1072][7] = FileReadString(l_file_16);
            gsa_1064[g_index_1072][8] = FileReadString(l_file_16);
            gsa_1064[g_index_1072][9] = FileReadString(l_file_16);
            gsa_1064[g_index_1072][10] = FileReadString(l_file_16);
            g_index_1072++;
            if (g_index_1072 >= 300) {
               Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "Too many MinSwingDefaults. Only first ", 300, " loaded.");
               return (0);
            }
         }
      }
   }
   CloseFile(l_file_16);
   return (0);
}

int Is_EOne2OnePattern(double ad_0, double ad_8, double ad_16, double ad_24, double ad_32, double ad_40, int ai_48) {
   double ld_52 = MathAbs(ad_8 - ad_16);
   double ld_60 = MathAbs(ad_24 - ad_32);
   if (ad_24 - ad_0 == 0.0) return (0);
   double ld_68 = (ad_24 - ad_32) / (ad_24 - ad_0);
   if (bextEOne2One && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) && ad_32 < ad_8 &&
      (ld_60 >= ld_52 * (1 - ad_40) && ld_60 <= ld_52 * (ad_40 + 1.0)) && (ld_68 >= (1 - ad_40) / 2.0 && ld_68 <= (ad_40 + 1.0) / 2.0) || (ld_68 >= (1 - ad_40) / 2.0 && ld_68 <= (ad_40 +
      1.0) / 2.0) || (ld_68 >= 0.618 * (1 - ad_40) && ld_68 <= 0.618 * (ad_40 + 1.0))) {
      HAR_FoundPatterns_Increase(37);
      SIGMON_FoundPatterns_Set(11, 1);
      return (37);
   }
   if (bextEOne2One && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32) &&
      ad_32 > ad_8 && (ld_60 >= ld_52 * (1 - ad_40) && ld_60 <= ld_52 * (ad_40 + 1.0)) && (ld_68 >= (1 - ad_40) / 2.0 && ld_68 <= (ad_40 + 1.0) / 2.0) || (ld_68 >= (1 - ad_40) / 2.0 &&
      ld_68 <= (ad_40 + 1.0) / 2.0) || (ld_68 >= 0.618 * (1 - ad_40) && ld_68 <= 0.618 * (ad_40 + 1.0))) {
      HAR_FoundPatterns_Increase(38);
      SIGMON_FoundPatterns_Set(11, -1);
      return (38);
   }
   if (bextOne2One && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) && ad_32 < ad_8 &&
      (ld_60 >= ld_52 * (1 - ad_40) && ld_60 <= ld_52 * (ad_40 + 1.0))) {
      HAR_FoundPatterns_Increase(33);
      SIGMON_FoundPatterns_Set(10, 1);
      return (33);
   }
   if (bextOne2One && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32) &&
      ad_32 > ad_8 && (ld_60 >= ld_52 * (1 - ad_40) && ld_60 <= ld_52 * (ad_40 + 1.0))) {
      HAR_FoundPatterns_Increase(34);
      SIGMON_FoundPatterns_Set(10, -1);
      return (34);
   }
   if (bextSOne2One && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) && (ld_60 >= ld_52 * (1 - ad_40) &&
      ld_60 <= ld_52 * (ad_40 + 1.0))) {
      HAR_FoundPatterns_Increase(41);
      SIGMON_FoundPatterns_Set(12, 1);
      return (41);
   }
   if (bextSOne2One && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32) &&
      (ld_60 >= ld_52 * (1 - ad_40) && ld_60 <= ld_52 * (ad_40 + 1.0))) {
      HAR_FoundPatterns_Increase(42);
      SIGMON_FoundPatterns_Set(12, -1);
      return (42);
   }
   if (bextOne2One || bextEOne2One && ai_48 && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) &&
      ad_32 < ad_8 && (ld_60 >= dextEmergingPatternPerc * ld_52 && ld_60 <= ld_52 * (1 - ad_40) && MathAbs(ad_24 - Low[0]) >= dextEmergingPatternPerc * ld_52 && MathAbs(ad_24 - Low[0]) <= ld_52 * (1 - ad_40))) {
      HAR_FoundPatterns_Increase(39);
      SIGMON_FoundPatterns_Set(11, 2);
      return (39);
   }
   if (bextOne2One || bextEOne2One && ai_48 && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 &&
      ad_24 < ad_32) && ad_32 > ad_8 && (ld_60 >= dextEmergingPatternPerc * ld_52 && ld_60 <= ld_52 * (1 - ad_40) && MathAbs(ad_32 - High[0]) >= dextEmergingPatternPerc * ld_52 && MathAbs(ad_24 - High[0]) <= ld_52 * (1 - ad_40))) {
      HAR_FoundPatterns_Increase(40);
      SIGMON_FoundPatterns_Set(11, -2);
      return (40);
   }
   if (bextSOne2One && ai_48 && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) && (ld_60 >= dextEmergingPatternPerc * ld_52 &&
      ld_60 <= ld_52 * (1 - ad_40) && MathAbs(ad_24 - Low[0]) >= dextEmergingPatternPerc * ld_52 && MathAbs(ad_24 - Low[0]) <= ld_52 * (1 - ad_40))) {
      HAR_FoundPatterns_Increase(43);
      SIGMON_FoundPatterns_Set(12, 2);
      return (43);
   }
   if (bextSOne2One && ai_48 && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32) &&
      (ld_60 >= dextEmergingPatternPerc * ld_52 && ld_60 <= ld_52 * (1 - ad_40) && MathAbs(ad_32 - High[0]) >= dextEmergingPatternPerc * ld_52 && MathAbs(ad_24 - High[0]) <= ld_52 * (1 - ad_40))) {
      HAR_FoundPatterns_Increase(44);
      SIGMON_FoundPatterns_Set(12, -2);
      return (44);
   }
   return (0);
}

int Draw_EOne2OnePattern(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56) {
   double ld_64;
   double ld_72;
   int li_80;
   int li_84;
   if (ad_44 - ad_8 == 0.0 || ad_44 - ad_32 == 0.0) return (0);
   string l_dbl2str_88 = DoubleToStr((ad_44 - ad_56) / (ad_44 - ad_8), 3);
   string l_dbl2str_96 = DoubleToStr((ad_44 - ad_56) / (ad_44 - ad_32), 3);
   if (ai_0 == 37) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBullishColor, "SI", gsa_1060[37][1], gi_984);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBullishColor, "IX", gsa_1060[37][1], gi_988);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBullishColor, "XT", gsa_1060[37][1], gi_984);
      DrawLine(ai_40, ad_44, ai_52, ad_56, cextOne2OneCorrBullishColor, "TB", gsa_1060[37][1], gi_988);
      DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_88, DarkSlateGray, "relXD", gsa_1060[37][1]);
      DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_96, DarkSlateGray, "relBD", gsa_1060[37][1]);
      if (bextOne2OneFibo) {
         SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[37][1], gi_968);
         SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[37][1], gi_968);
      }
      ld_64 = MathAbs(ad_20 - ad_32) / Point;
      ld_72 = MathAbs(ad_44 - ad_56) / Point;
      li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
      li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
      DrawEntryBox(1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
         1.0), Green, LimeGreen, "121EB", gsa_1060[38][1], DoubleToStr((ad_44 - ad_56) / Point - (ad_20 - ad_32) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) + "," + li_80 +
         " CD:" + DoubleToStr(ld_72, 0) + "," + li_84, "E 121");
      CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[37][1], 37);
   } else {
      if (ai_0 == 38) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBearishColor, "SI", gsa_1060[38][1], gi_984);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBearishColor, "IX", gsa_1060[38][1], gi_988);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBearishColor, "XT", gsa_1060[38][1], gi_984);
         DrawLine(ai_40, ad_44, ai_52, ad_56, cextOne2OneCorrBearishColor, "TB", gsa_1060[38][1], gi_988);
         DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_88, DarkSlateGray, "relXD", gsa_1060[38][1]);
         DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_96, DarkSlateGray, "relBD", gsa_1060[38][1]);
         if (bextOne2OneFibo) {
            SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[38][1], gi_968);
            SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[38][1], gi_968);
         }
         ld_64 = MathAbs(ad_20 - ad_32) / Point;
         ld_72 = MathAbs(ad_44 - ad_56) / Point;
         li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
         li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
         DrawEntryBox(-1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
            1.0), C'0x77,0x0B,0x20', C'0xD6,0x14,0x3A', "121EB", gsa_1060[38][1], DoubleToStr((ad_20 - ad_32) / Point - (ad_44 - ad_56) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) +
            "," + li_80 + " CD:" + DoubleToStr(ld_72, 0) + "," + li_84, "E 121");
         CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[38][1], 38);
      } else {
         if (ai_0 == 33) {
            DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBullishColor, "SI", gsa_1060[33][1], gi_984);
            DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBullishColor, "IX", gsa_1060[33][1], gi_988);
            DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBullishColor, "XT", gsa_1060[33][1], gi_984);
            DrawLine(ai_40, ad_44, ai_52, ad_56, cextOne2OneCorrBullishColor, "TB", gsa_1060[33][1], gi_988);
            DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_88, DarkSlateGray, "relXD", gsa_1060[33][1]);
            DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_96, DarkSlateGray, "relBD", gsa_1060[33][1]);
            if (bextOne2OneFibo) {
               SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[33][1], gi_968);
               SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[33][1], gi_968);
            }
            ld_64 = MathAbs(ad_20 - ad_32) / Point;
            ld_72 = MathAbs(ad_44 - ad_56) / Point;
            li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
            li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
            DrawEntryBox(1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
               1.0), Green, LimeGreen, "121EB", gsa_1060[34][1], DoubleToStr((ad_44 - ad_56) / Point - (ad_20 - ad_32) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) + "," + li_80 +
               " CD:" + DoubleToStr(ld_72, 0) + "," + li_84, "121");
            CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[33][1], 33);
         } else {
            if (ai_0 == 34) {
               DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBearishColor, "SI", gsa_1060[34][1], gi_984);
               DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBearishColor, "IX", gsa_1060[34][1], gi_988);
               DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBearishColor, "XT", gsa_1060[34][1], gi_984);
               DrawLine(ai_40, ad_44, ai_52, ad_56, cextOne2OneCorrBearishColor, "TB", gsa_1060[34][1], gi_988);
               DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_88, DarkSlateGray, "relXD", gsa_1060[34][1]);
               DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_96, DarkSlateGray, "relBD", gsa_1060[34][1]);
               if (bextOne2OneFibo) {
                  SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[34][1], gi_968);
                  SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[34][1], gi_968);
               }
               ld_64 = MathAbs(ad_20 - ad_32) / Point;
               ld_72 = MathAbs(ad_44 - ad_56) / Point;
               li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
               li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
               DrawEntryBox(-1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
                  1.0), C'0x77,0x0B,0x20', C'0xD6,0x14,0x3A', "121EB", gsa_1060[34][1], DoubleToStr((ad_20 - ad_32) / Point - (ad_44 - ad_56) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) +
                  "," + li_80 + " CD:" + DoubleToStr(ld_72, 0) + "," + li_84, "121");
               CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[34][1], 34);
            } else {
               if (ai_0 == 41) {
                  DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBullishColor, "SI", gsa_1060[41][1], gi_984);
                  DrawLine(ai_16, ad_20, ai_28, ad_32, cextSOne2OneCorrBullishColor, "IX", gsa_1060[41][1], gi_988);
                  DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBullishColor, "XT", gsa_1060[41][1], gi_984);
                  DrawLine(ai_40, ad_44, ai_52, ad_56, cextSOne2OneCorrBullishColor, "TB", gsa_1060[41][1], gi_988);
                  CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[41][1], 41);
                  DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_88, DarkSlateGray, "relXD", gsa_1060[41][1]);
                  DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_96, DarkSlateGray, "relBD", gsa_1060[41][1]);
                  if (bextOne2OneFibo) {
                     SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[41][1], gi_968);
                     SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[41][1], gi_968);
                  }
                  ld_64 = MathAbs(ad_20 - ad_32) / Point;
                  ld_72 = MathAbs(ad_44 - ad_56) / Point;
                  li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
                  li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
                  DrawEntryBox(1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
                     1.0), Green, LimeGreen, "121EB", gsa_1060[42][1], DoubleToStr((ad_44 - ad_56) / Point - (ad_20 - ad_32) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) + "," + li_80 +
                     " CD:" + DoubleToStr(ld_72, 0) + "," + li_84, "S 121");
               } else {
                  if (ai_0 == 42) {
                     DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBearishColor, "SI", gsa_1060[42][1], gi_984);
                     DrawLine(ai_16, ad_20, ai_28, ad_32, cextSOne2OneCorrBearishColor, "IX", gsa_1060[42][1], gi_988);
                     DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBearishColor, "XT", gsa_1060[42][1], gi_984);
                     DrawLine(ai_40, ad_44, ai_52, ad_56, cextSOne2OneCorrBearishColor, "TB", gsa_1060[42][1], gi_988);
                     CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[42][1], 42);
                     DrawRelationLine(ai_4, ad_8, ai_52, ad_56, l_dbl2str_88, DarkSlateGray, "relXD", gsa_1060[42][1]);
                     DrawRelationLine(ai_28, ad_32, ai_52, ad_56, l_dbl2str_96, DarkSlateGray, "relBD", gsa_1060[42][1]);
                     if (bextOne2OneFibo) {
                        SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[42][1], gi_968);
                        SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[42][1], gi_968);
                     }
                     ld_64 = MathAbs(ad_20 - ad_32) / Point;
                     ld_72 = MathAbs(ad_44 - ad_56) / Point;
                     li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
                     li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
                     DrawEntryBox(-1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
                        1.0), C'0x77,0x0B,0x20', C'0xD6,0x14,0x3A', "121EB", gsa_1060[42][1], DoubleToStr((ad_20 - ad_32) / Point - (ad_44 - ad_56) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) +
                        "," + li_80 + " CD:" + DoubleToStr(ld_72, 0) + "," + li_84, "S 121");
                  } else {
                     if (ai_0 == 39) {
                        DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBullishColor, "SI", gsa_1060[39][1], gi_984);
                        DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBullishColor, "IX", gsa_1060[39][1], gi_988);
                        DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBullishColor, "XT", gsa_1060[39][1], gi_984);
                        DrawLine(ai_40, ad_44, Time[0], ad_44 - (ad_20 - ad_32), cextEmergingBullishColor, "TB", gsa_1060[39][1], gi_988);
                        CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[39][1], 39);
                        ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), cextOne2OneCorrBullishColor, "IX=TB", 0, 4, "IX=TB", gsa_1060[39][1], gi_968);
                        if (bextOne2OneFibo) {
                           SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[39][1], gi_968);
                           SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[39][1], gi_968);
                        }
                     } else {
                        if (ai_0 == 35) {
                           DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBullishColor, "SI", gsa_1060[35][1], gi_984);
                           DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBullishColor, "IX", gsa_1060[35][1], gi_988);
                           DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBullishColor, "XT", gsa_1060[35][1], gi_984);
                           DrawLine(ai_40, ad_44, Time[0], ad_44 - (ad_20 - ad_32), cextEmergingBullishColor, "TB", gsa_1060[35][1], gi_988);
                           CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[35][1], 35);
                           ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), cextOne2OneCorrBullishColor, " ", 0, 4, " ", gsa_1060[35][1], gi_968);
                           if (bextOne2OneFibo) {
                              SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[35][1], gi_968);
                              SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[35][1], gi_968);
                           }
                        } else {
                           if (ai_0 == 43) {
                              DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBullishColor, "SI", gsa_1060[43][1], gi_984);
                              DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBullishColor, "IX", gsa_1060[43][1], gi_988);
                              DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBullishColor, "XT", gsa_1060[43][1], gi_984);
                              DrawLine(ai_40, ad_44, Time[0], ad_44 - (ad_20 - ad_32), cextEmergingBullishColor, "TB", gsa_1060[43][1], gi_988);
                              CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[43][1], 43);
                              ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), cextOne2OneCorrBullishColor, "IX=TB", 0, 4, "IX=TB", gsa_1060[43][1], gi_968);
                              if (bextOne2OneFibo) {
                                 SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[43][1], gi_968);
                                 SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[43][1], gi_968);
                              }
                           } else {
                              if (ai_0 == 40) {
                                 DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBearishColor, "SI", gsa_1060[40][1], gi_984);
                                 DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBearishColor, "IX", gsa_1060[40][1], gi_988);
                                 DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBearishColor, "XT", gsa_1060[40][1], gi_984);
                                 DrawLine(ai_40, ad_44, Time[0], ad_44 - (ad_20 - ad_32), cextEmergingBullishColor, "TB", gsa_1060[40][1], gi_988);
                                 CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[40][1], 40);
                                 ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), cextOne2OneCorrBullishColor, "", 0, 4, "", gsa_1060[40][1], gi_968);
                                 if (bextOne2OneFibo) {
                                    SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[40][1], gi_968);
                                    SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[40][1], gi_968);
                                 }
                              } else {
                                 if (ai_0 == 36) {
                                    DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBearishColor, "SI", gsa_1060[36][1], gi_984);
                                    DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBearishColor, "IX", gsa_1060[36][1], gi_988);
                                    DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBearishColor, "XT", gsa_1060[36][1], gi_984);
                                    DrawLine(ai_40, ad_44, Time[0], ad_44 - (ad_20 - ad_32), cextEmergingBullishColor, "TB", gsa_1060[36][1], gi_988);
                                    CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[36][1], 36);
                                    ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), cextOne2OneCorrBullishColor, " ", 0, 4, " ", gsa_1060[36][1], gi_968);
                                    if (bextOne2OneFibo) {
                                       SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[36][1], gi_968);
                                       SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[36][1], gi_968);
                                    }
                                 } else {
                                    if (ai_0 == 44) {
                                       DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBearishColor, "SI", gsa_1060[44][1], gi_984);
                                       DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBearishColor, "IX", gsa_1060[44][1], gi_988);
                                       DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBearishColor, "XT", gsa_1060[44][1], gi_984);
                                       DrawLine(ai_40, ad_44, Time[0], ad_44 - (ad_20 - ad_32), cextEmergingBullishColor, "TB", gsa_1060[44][1], gi_988);
                                       CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_1060[44][1], 44);
                                       ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), cextOne2OneCorrBullishColor, "", 0, 4, "", gsa_1060[44][1], gi_968);
                                       if (bextOne2OneFibo) {
                                          SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_1060[44][1], gi_968);
                                          SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_1060[44][1], gi_968);
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (0);
}

void DrawEntryBox(int ai_0, int ai_4, double a_price_8, int a_datetime_16, double a_price_20, color a_color_28, color a_color_32, string as_36, string as_44, string as_52, string as_60, string as_68) {
   string l_name_76 = "HAR_O_" + "rect_" + as_44 + "_" + as_36 + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
   ObjectDelete(l_name_76);
   ObjectCreate(l_name_76, OBJ_RECTANGLE, 0, ai_4, a_price_8, a_datetime_16, a_price_20);
   ObjectSet(l_name_76, OBJPROP_COLOR, a_color_28);
   ObjectSet(l_name_76, OBJPROP_BACK, TRUE);
   l_name_76 = "HAR_O_" + "121_desc_" + as_44 + "_" + as_36 + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
   int l_fontsize_84 = 8;
   if (ai_0 == 1) ObjectCreate(l_name_76, OBJ_TEXT, 0, ai_4 + (a_datetime_16 - ai_4) / 2, MathMin(a_price_8, a_price_20));
   else
      if (ai_0 == -1) ObjectCreate(l_name_76, OBJ_TEXT, 0, ai_4 + (a_datetime_16 - ai_4) / 2, MathMax(a_price_8, a_price_20) + LabelOffset(l_fontsize_84 + 8));
   ObjectSetText(l_name_76, as_52 + "   " + as_60 + "   " + as_68, l_fontsize_84, "Arial", a_color_32);
   l_name_76 = "HAR_O_" + "121_line_" + as_44 + "_" + as_36 + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
   ObjectCreate(l_name_76, OBJ_TREND, 0, ai_4, (a_price_8 + a_price_20) / 2.0, a_datetime_16, (a_price_8 + a_price_20) / 2.0);
   ObjectSet(l_name_76, OBJPROP_COLOR, a_color_32);
   ObjectSet(l_name_76, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(l_name_76, OBJPROP_WIDTH, 1);
   ObjectSet(l_name_76, OBJPROP_BACK, FALSE);
   ObjectSet(l_name_76, OBJPROP_RAY, FALSE);
}