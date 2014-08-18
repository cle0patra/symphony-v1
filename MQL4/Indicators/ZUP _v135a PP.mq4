
#property copyright "nen"
#property link      "http://www.onix-trade.net/forum/topic/118-gartley-patterns-%d0%b8-%d0%b8%d1%85-%d0%bc%d0%be%d0%b4%d0%b8%d1%84%d0%b8%d0%ba%d0%b0%d1%86%d0%b8%d0%b8/page__view__findpost__p__434115"
// ��������          http://onix-trade.net/forum/index.php?s=&showtopic=373&view=findpost&p=72865

#property stacksize 65535
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Magenta //Red 
//#property indicator_width6 5 
#property indicator_color2 Green
#property indicator_color3 Orange
#property indicator_color4 LightSkyBlue
#property indicator_color5 LemonChiffon
//#property indicator_color4 Chartreuse
//#property indicator_color5 Red
#property indicator_color6 Magenta //Yellow
#import "user32.dll"
   int GetClientRect(int hWnd,int lpRect[]);
#import

#include <stdlib.mqh>
#include <stderror.mqh> 

#include <Symphony_Definitions.mqh>
#define pi  3.14159265
#define phi 1.6180339887
#define defaultVectorRet 26
// �������� Gartley
 string ______________3_____________ = "Parameters for Gartley Patterns";
                                                      // add 6  pats - 121 & A 121, 3 DRIVES & A 3 DRIVES, WHITE SWAN, NAVARRO 200"; // ������� 16.03.13
 extern int    maxDepth                = 15;          // ���������� cypher  � � cypher, ABCD - �������� ��� ��������� �� grandaevus ( http://www.forex-tsd.com )   
 color  ExtColorPatterns        = DarkOrange; // �� ����������� �������� -  ��� ������ 7 
 int    AlgorithmSearchPatterns = 0;          // add Sea PONY & PARTIZAN
 int    SelectPattern           = 0;
 int    PotencialsLevels_retXD  = 1;
 int    visibleLevelsABCD       = 3;
 int    PotencialsLevelsNum     = 5;
// �������� ��� ������� �� MT4  � ������� Talex
 int    minDepth                = 3;
 bool   FiboStep                = true; //false;
 int    IterationStepDepth      = 2;
// ��������� ��� ������� ������ 1 � ������� Ensign - ������ ������
 int    maxSize_                = 150;
 int    minSize_                = 15;
 int    IterationStepSize       = 3;
// ��������� ��� ������� ������ 2 - ������ �������
 double maxPercent_             = 10.0;
 double minPercent_             = 0.4;
 double IterationStepPercent    = 15;
//
 bool   DirectionOfSearchMaxMin = true;
 string visiblePattern          = "000000000000000000000000000";
 int    NumberPattern           = 1;  // ����� ��������, �� �������� ����������� ������ � ��������� �������� ��������� ����� InfoTF
 int    ExtGartleyTypeSearch    = 0;
 int    ExtHiddenPP             = 1;
 bool   ExtGartleyOnOff         = false;
// int    VarDisplay=0;
 int    maxBarToD               = 15;
 int    patternInfluence        = 1; //2;
 bool   patternTrue             = true;
 double AllowedBandPatternInfluence = 1.618;
 int    RangeForPointD          = 2; // 0; //
 int    VectorOfAMirrorTrend    = 1;
 color  ExtColorRangeForPointD  = PowderBlue;
 color  ExtLineForPointD_AB     = MediumBlue; //Aqua;
 color  ExtLineForPointD_BC     = Chocolate;  //Gold;
 string ExtColorPatternList     = "Blue,DarkGreen,Navy,Sienna,MediumBlue,RoyalBlue,DodgerBlue,CornflowerBlue,LightSkyBlue,SlateBlue,MediumSlateBlue,SlateGray,LightSteelBlue";
 double ExtDeltaGartley         = 0.09;
 double ExtDeltaStrongGartley   = 0.07;
 int    varStrongPatterns       = 1;
 int    levelD                  = 1;
 color  colorLevelD             = Red;

//---------------
 bool   Equilibrium             = false;
 bool   ReactionType            = false;
 int    EquilibriumStyle        = 1;
 int    EquilibriumWidth        = 0;
 color  ColorEquilibrium        = Red;
 color  ColorReaction           = Tomato; //Yellow;
//--------------- Dragon ------------
 bool   Dragon                  = true;
 int    PeakZZDragon            = 5;
//--------------- 4-Point Pattern ------------
 bool   Ext_4PointPattern       = false;
 double _maxXB                  = 0.618;
//--------------- 5-0 ------------
 bool   _50                     = false;
//--------------- AB=CD ------------
 bool ABCD = false;
 bool visibleABCDrayZZ = true;
 double ExtDevABCDLeg = 0.07;
 double ExtDevABCDFib = 0.05;
 int ABCDrayZZStyle = 0;
 int ABCDrayZZWidth = 4;
 string ABCDAlternate = "0.128.0.382,0.447,0.5,0.618,0.707,0.786,0.854,0.886,1.272,1.414,1.618,2.0,2.4,2.618 ";

//--------------- Custom 5-Point Pattern
 int    CustomPattern           = 1; // 0 - �� ��������� ���������������� ������� 
                                           // 1 - ��������� ������ � �������� ������� ���������
                                           // 2 - ��������� ������ custom ��������
 double minXB                   = 1.128; // 2;  //0.5;  ���   HENRY  ������� 
 double maxXB                   = 1.618;   // 0.942;  //0.618;
 double minAC                   = 0.447;  // 0.447;  //0.382;
 double maxAC                   = 0.786; // 0.942;  //0.618;
 double minBD                   = 0.447;   // 1.144;  //1.128;
 double maxBD                   = 1.0;    // 2.128;  //1.272;
 double minXD                   = 0.447; // 0.5;    //0.618;
 double maxXD                   = 3.618; // 0.942;  //0.886;

 bool   filtrEquilibrium        = false;

//===================================
//---- indicator parameters
 string ______________0_____________ = "Parameters for ZigZag";
 int    ExtIndicator            = 11; 
 int    ParametresZZforDMLEWA   = 6;
 int    minBars                 = 8;
 int    minSize                 = 50;
// ���������� �� ZigZag �� ��
 int    ExtDeviation            = 5;
 int    ExtBackstep             = 3;
 bool   noBackstep              = true;
// ���������� ��� nen-ZigZag
 int    GrossPeriod             = 240;
//----
 double minPercent              = 0.0;      // 0.08
 int    ExtPoint=11; // ���������� ����� ������� ��� ������� Talex 
// ��������� ��� �������, �������������� wellx
 int    StLevel                 = 28;
 int    BigLevel                = 32; 
 bool   auto                    = true;
 double minBar=38.2, maxBar=61.8;

 bool   ExtStyleZZ              = true;

 int    ExtMaxBar               = 1400;     // ���������� ����� ������� (0-���)
 int    ExtMinBar               = 0;
// ����� ������� ��������� ��������
 bool   ExtNumberPeak           = false;
 bool   ExtNumberPeak10         = true;
 bool   ExtNumberPeakLow        = true;
 color  ExtNumberPeakColor      = Red;
 int    ExtNumberPeakFontSize   = 11;

 string ______________1_____________ = "Parameters for fibo Levels";
 bool   ExtFiboDinamic          = false;
 bool   ExtFiboStatic           = false;
 int    ExtFiboStaticNum        = 2;
 bool   ExtFiboCorrectionExpansion = false;
 color  ExtFiboD                = Sienna;
 color  ExtFiboS                = Teal;
 int    ExtFiboStyle            = 2;
 int    ExtFiboWidth            = 0;
//-------------------------------------

 string ______________2_____________ = "Parameters for Pesavento Patterns";
 int    ExtPPWithBars           = 0;
 int    ExtHidden               = 1;
 int    ExtFractal              = 7;
 int    ExtFractalEnd           = 7;
 int    ExtFiboChoice           = 2;
 bool   ExtFiboZigZag           = false;
 double ExtDelta                = 0.04;
 int    ExtDeltaType            = 2;
 int    ExtSizeTxt              = 9;
 color  ExtLine                 = DarkBlue;
 color  ExtLine886              = Purple;
 color  ExtNotFibo              = Black;
 color  ExtPesavento            = Black; // Yellow; ����� ��� ������ ����. ����� ����� ��� ������� ���� 
 color  ExtGartley886           = Black; // GreenYellow;
       color  colorPPattern;

//----------------------------------------------------------------------
// �������� ������������, ���������� ��������� � ������ �������. ������.
//----------------------------------------------------------------------
// ���������� ��� ��� �������
 string ______________4_____________ = "Parameters for Andrews Pitchfork";
 int    ExtPitchforkDinamic       = 0;
 bool   AutoAPDinamicTestRedZone = true;
 double ExtPitchforkDinamicCustom = 0;
 color  ExtLinePitchforkD         = DarkOrange; //MediumSlateBlue;
 int    ExtPitchforkStatic        = 0;
 int    ExtPitchforkStaticNum     = 3;
 double ExtPitchforkStaticCustom  = 0;
 color  ExtLinePitchforkS         = MediumBlue; // DarkKhaki; //
 int    ExtMasterPitchfork        = 0;
 color  ExtPitchforkStaticColor   = CLR_NONE;
 int    ExtPitchforkStyle         = 1;
 int    ExtPitchforkWidth         = 0;

// ����� ������� RL
 bool   ExtRLDinamic              = true;
 int    ExtRLStyleDinamic         = 1;
 bool   ExtVisibleRLDinamic       = true;
 bool   ExtRLStatic               = true; // false; //
 int    ExtRLStyleStatic          = 1;
 bool   ExtVisibleRLStatic        = true;
 bool   ExtRL146                  = true;
 bool   ExtRLineBase              = true;

// RedZone ��� ����� �������
 int    ExtRedZoneDinamic         = 2;
 int    ExtRedZoneStatic          = 2;
 double ExtRZDinamicValue         = 0;
 double ExtRZStaticValue          = 0;
 color  ExtRZDinamicColor         = Salmon;
 color  ExtRZStaticColor          = Salmon;

// ���������� ���������� �����
 bool   ExtISLDinamic             = true; // false; //
 int    ExtISLStyleDinamic        = 1;
 bool   ExtVisibleISLDinamic      = true;
 bool   ExtISLStatic              = true; // false;
 int    ExtISLStyleStatic         = 1;
 bool   ExtVisibleISLStatic       = true;
 int    ExtISLWidth               = 0;
// color  ExtISLChannelDinamicColor = DarkViolet;
// color  ExtISLChannelStaticColor  = CadetBlue;
 color  ExtISLChannelDinamicColor = Turquoise; // CLR_NONE;
 color  ExtISLChannelStaticColor  = Aqua; // DarkSlateGray; // CLR_NONE; //

// ���������� ����� 50% �������
 bool   ExtSLMDinamic         = true; //false;
 color  ExtSLMDinamicColor    = DarkOrange; //MediumSlateBlue;
 bool   ExtSLMStatic          = true; // false; //
 color  ExtSLMStaticColor     = MediumBlue; // DarkKhaki; //
 bool   ExtFSLShiffLinesDinamic      = true; //false; // ����� ����� FSL ����� ����� ��� ������������ ��� �������
 color  ExtFSLShiffLinesDinamicColor = DarkOrange; //MediumSlateBlue; // MediumBlue; // DarkKhaki; //
 bool   ExtFSLShiffLinesStatic       = true; // false; // ����� ����� FSL ����� ����� ��� ����������� ��� �������
 color  ExtFSLShiffLinesStaticColor  = MediumBlue; // DarkKhaki; //

// ��������������� � ����������� ����� ����������� ��� �������
 bool   ExtUTL        = false; // true; //
 bool   ExtLTL        = false; // true; //
 bool   ExtUWL        = false; // true; //
 bool   ExtVisibleUWL = false;
 bool   ExtLWL        = false; // true; //
 bool   ExtVisibleLWL = false;
 bool   ExtLongWL     = false;

// ����������� ���� Pivot Zone
 color  ExtPivotZoneDinamicColor = CLR_NONE;
 color  ExtPivotZoneStaticColor  = CLR_NONE;
 bool   ExtPivotZoneFramework    = false;

// ���������� ��� ���������� ��� ������� �� ������������ ������
 bool   ExtCustomStaticAP = false; // true; //
 bool   AutoMagnet        = true;
 int    AMBars            = 5;

// ���������� ��������� ��� �� ��������� ������
//----------------------------------------------------------------------
// datetime ExtDateTimePitchfork_1 = D'11.07.2006 00:00';
// datetime ExtDateTimePitchfork_2 = D'19.07.2006 00:00';
// datetime ExtDateTimePitchfork_3 = D'09.08.2006 00:00';
//----------------------------------------------------------------------
// ���� ������� ��������� ��������� ��� ���������� ��� ������� ��� ���� ������� eurusd ��� ������
//----------------------------------------------------------------------
 bool     ExtPitchforkCandle     = false;
 datetime ExtDateTimePitchfork_1 = D'15.06.1989 00:00';
 datetime ExtDateTimePitchfork_2 = D'08.03.1995 00:00';
 datetime ExtDateTimePitchfork_3 = D'26.10.2000 00:00';
 bool     ExtPitchfork_1_HighLow = false;

// ���������� ��� ����������
 bool   ExtFiboFanDinamic     = false;  // ����� ���������� ��������������
 bool   ExtFiboFanStatic      = false;  // ��������� ������ ��������� �� ������������ ������
 bool   ExtFiboFanExp         = true;
 bool   ExtFiboFanHidden      = false;
 color  ExtFiboFanD           = Sienna;
 color  ExtFiboFanS           = Teal;

 color  ExtFiboFanMedianaDinamicColor = CLR_NONE;
 color  ExtFiboFanMedianaStaticColor  = CLR_NONE;

// ��������� ���� ���� � ������� ��� �������
 bool   ExtFiboTime1          = false;
 bool   ExtFiboTime2          = false;
 bool   ExtFiboTime3          = false;
 color  ExtFiboTime1C         = Teal;
 color  ExtFiboTime2C         = Sienna;
 color  ExtFiboTime3C         = Aqua;
 bool   ExtVisibleDateTime    = false;
 string ExtVisibleNumberFiboTime = "111";

//----------------------------------------------------------------------
// ������� ���������������� ������� ���� ��� ������������, ���������� � ���� �������
 bool   ExtFiboFreePitchfork  = true;
 string ExtFiboFreeRLDinamic  = "0.236,0.382,0.618,1.0,1.618,2.618,4.236,6.854,11.09,17.944,29.034,46.979,76.013";
 string ExtFiboFreeRLStatic   = "0.236,0.382,0.618,1.0,1.618,2.618,4.236,6.854,11.09,17.944,29.034,46.979,76.013";
 string ExtFiboFreeISLDinamic = "0.236,0.382,0.618,0.764";
 string ExtFiboFreeISLStatic  = "0.236,0.382,0.618,0.764";
 string ExtFiboFreeUWL        = "0.382,0.618,1.0,1.618,2.618,4.236";
 string ExtFiboFreeLWL        = "0.382,0.618,1.0,1.618,2.618,4.236";
 string ExtFiboFreeFT1        = "0.382,0.618,1.0,1.618,2.618";
 string ExtFiboFreeFT2        = "0.382,0.618,1.0,1.618,2.618";
 string ExtFiboFreeFT3        = "0.382,0.618,1.0,1.618,2.618";
//----------------------------------------------------------------------

// ������� ������ � ����
 int    mSelectVariantsPRZ      = 0;
 int    mTypeBasiclAP           = 0;
 int    mTypealAP         = 0;
 int    malHandAP         = 0;

 bool   mAuto_d                 = true; // false; //
 bool   mAuto_s                 = true; // false; //
 bool   mSaveWL_TL              = true;
 bool   mOutRedZone             = false; // true; //
 bool   mExitFSL_SSL            = true; // false; //

 bool   mPivotPoints            = true;
 bool   mPivotPointsChangeColor = false;

 int    mSSL                    = 0;
 int    m1_2Mediana             = 0;
 int    mISL382                 = 0;
 int    mMediana                = 0;
 int    mISL618                 = 0;
 int    mFSL                    = 0;
 int    mSLM                    = 0;
 int    mFSLShiffLines          = 0;

 int    mUTL                    = 0;
 int    mLTL                    = 0;
 int    mUWL                    = 0;
 int    mLWL                    = 0;

 bool   mCriticalPoints         = false;

 int    mSSL_d                  = 0;
 int    m1_2Mediana_d           = 0;
 int    mISL382_d               = 0;
 int    mMediana_d              = 0;
 int    mISL618_d               = 0;
 int    mFSL_d                  = 0;
 int    mSLM_d                  = 0;
 int    mFSLShiffLines_d        = 0;

 bool   mCriticalPoints_d       = false;

 bool   mAllLevels              = true;
 color  mColorUP                = Blue;
 color  mColorDN                = Red;
 color  mColor                  = DarkOrchid;
 color  mColorRectangleUP       = LightBlue;
 color  mColorRectangleDN       = Pink;
 color  mColorRectangle         = Thistle;
 bool   mBack                   = false;
 bool   mBackZones              = true;
 int    mLineZonesWidth         = 5;
 bool   mVisibleST              = false;
 bool   mVisibleISL             = true;
 int    mPeriodWriteToFile      = 60;
 bool   mWriteToFile            = false; // true; //
//----------------------------------------------------------------------

// ������ micmed'a
 string ________________5_____________ = "Parameters for micmed Channels";
 int    ExtCM_0_1A_2B_Dinamic = 0, ExtCM_0_1A_2B_Static = 0;
 double ExtCM_FiboDinamic = 0.618, ExtCM_FiboStatic = 0.618;
//----------------------------------------------------------------------
// �������� ������������, ���������� ��������� � ������ �������. �����.
//----------------------------------------------------------------------

// ��������� ��������������
 string ______________6_____________ = "Parameters for fibo Fan";
 color  ExtFiboFanColor = CLR_NONE;
 int    ExtFiboFanNum   = 0;
 int    ExtFanStyle     = 1;
 int    ExtFanWidth     = 0;

// ���������� ���������
 string ______________7_____________ = "Parameters for fibo Expansion";
 int    ExtFiboExpansion      = 0;
 color  ExtFiboExpansionColor = Yellow;
 int    ExtExpansionStyle     = 2;
 int    ExtExpansionWidth     = 0;
//--------------------------------------

 string ______________8_____________ = "Parameters for versum Levels";
 color  ExtVLDinamicColor = CLR_NONE;
 color  ExtVLStaticColor  = CLR_NONE;
 int    ExtVLStaticNum    = 0;
 int    ExtVLStyle        = 0;
 int    ExtVLWidth        = 0;
//--------------------------------------

 string ______________9_____________ = "Parameters for fibo Arc";
 int    ExtArcDinamicNum   = 0;
 int    ExtArcStaticNum    = 0;
 color  ExtArcDinamicColor = Sienna;
 color  ExtArcStaticColor  = Teal;
 double ExtArcDinamicScale = 0;
 double ExtArcStaticScale  = 0;
 int    ExtArcStyle        = 0;
 int    ExtArcWidth        = 0;

 string ______________10_____________ = "Golden Spiral";
 int    ExtSpiralNum       = 0;
 double goldenSpiralCycle  = 1;
 double accurity           = 0.2;
 int    NumberOfLines      = 200;
 bool   clockWiseSpiral    = true;
 color  spiralColor1       = Blue;
 color  spiralColor2       = Red;
 int    ExtSpiralStyle     = 0;
 int    ExtSpiralWidth     = 0; 

 string ______________11_____________ = "Pivot ZigZag";
 color  ExtPivotZZ1Color = Blue;
 color  ExtPivotZZ2Color = Red;
 int    ExtPivotZZ1Num   = 0;
 int    ExtPivotZZ2Num   = 0;
 int    ExtPivotZZStyle  = 0;
 int    ExtPivotZZWidth  = 2;

 string ______________12_____________ = "Parameters for Channels";
 int    ExtTypeChannels      = 0;
 int    ExtTypeLineChannels  = 1;
 int    ExtChannelsNum       = 2;
 color  ExtLTColor           = Red;
 color  ExtLCColor           = Green;
 int    ExtLTChannelsStyle   = 0;
 int    ExtLTChannelsWidth   = 1; 
 int    ExtLCChannelsStyle   = 2;
 int    ExtLCChannelsWidth   = 0; 
 bool   ExtRay               = false;

 string ______________13_____________ = "Parameters Fibo Time";
// ��������� ���� ����
 int    ExtFiboTimeNum      = 0;
 bool   ExtFiboTime1x       = false;
 bool   ExtFiboTime2x       = false;
 bool   ExtFiboTime3x       = false;
 color  ExtFiboTime1Cx      = Teal;
 color  ExtFiboTime2Cx      = Sienna;
 color  ExtFiboTime3Cx      = Aqua;
 bool   ExtVisibleDateTimex = false;
 string ExtVisibleNumberFiboTimex = "111";

 string ______________14_____________ = "Parameters Exp";
 bool   chHL                = false;
 bool   PeakDet             = false;
// ���������� ��� i-vts
 bool   chHL_PeakDet_or_vts = true;
 int    ExtLabel            = 0;
 int    ExtCodLabel         = 116;
 int    NumberOfBars        = 1000;     // ���������� ����� ������� (0-���)
 int    NumberOfVTS         = 13;
 int    NumberOfVTS1        = 1;

 string ______________15_____________ = "Common Parameters";
//--------------------------------------
 int    ExtFiboType       = 1;
 string ExtFiboTypeFree  = "0,0.382,0.618,0.764,1,1.236,1.618"; // ���������������� ������ ���� 
 color  ExtObjectColor    = CLR_NONE;
 int    ExtObjectStyle    = 1;
 int    ExtObjectWidth    = 0; 
// ����� ����������� �������� � ������ ������������
 bool   ExtDinamic        = false; //true; //
 string ExtVisibleDinamic = "01100000000";
 bool   RefreshStaticNewRayZZ =true;
 bool   AutoTestRedZone   = false; //true; //

 bool   ZigZagHighLow     = true;
// --------------------------------
// �������������� �������
 bool   ExtSendMail       = true;
 bool   ExtAlert          = false;
 bool   ExtPlayAlert      = false;
// ����� �������� � ���� ����
 bool   ExtBack           = true;
// ���������� ����������� ��� �������, Fibo Time � �.�.
 bool   ExtSave           = false;
 string info_comment      = "01111";
 bool   infoMerrillPattern= false;
 bool   infoTF            = true;
// ����� ������������ ����� �� ������� ����
 bool   CursorLine        = false;
 color  CLColor           = Black;
 int    CLWidth           = 1;
 int    CLStyle           = 2;	
 bool   CLBack            = False;	
// ����� �������� ��������� ������� �������
 bool   bigText           = true;
 int    bigTextSize       = 16;
 color  bigTextColor      = Red;
 color  bigTextColorBearish = Red;
 int    bigTextX          = 50;
 int    bigTextY          = 20;
 bool   ExtVisible        = true;
 int    ExtComplekt       = 136635;
//===================================

// ������� ��� ZigZag 
// ������ ��� ��������� ZigZag
double zz[];
// ������ ��������� ZigZag
double zzL[];
// ������ ���������� ZigZag
double zzH[];
// ������� ��� nen-ZigZag
double nen_ZigZag[];

double interVectorLevels[2][14];

int    _maxbarZZ; // ���������� �����, ����������� � ������� ��������.

// ������ �����, �������� �������������
double fi[];
string fitxt[];
string fitxt100[];
int    Sizefi=0,Sizefi_1=0;

color  ExtLine_;

double number[64];
string numbertxt[64];
int    numberFibo[64];
int    numberPesavento[64];
int    numberGartley[64];
int    numberMix[64];
int    numberGilmorQuality[64];
int    numberGilmorGeometric[64];
int    numberGilmorHarmonic[64];
int    numberGilmorArithmetic[64];
int    numberGilmorGoldenMean[64];
int    numberSquare[64];
int    numberCube[64];
int    numberRectangle[64];
int    numberExt[64];

string nameObj="", nameObjtxt="", save="", nameObjAPMaster="";
string nameUWL="", nameLWL="", nameUTL="", nameLTL="", nameUWLd="", nameLWLd="", nameUTLd="", nameLTLd="";
// 
bool descript_b=false;
// PPWithBars - �����, ��������� � �������������� �����
// descript - �������� ��������
string PPWithBars="", descript="";
// ������� ��� ������ ����������� ����� afr - ������ �������� ������� ���� ��������� ��������� � ��������� ������������ � ����������� ���
// afrl - ��������, afrh - ���������
int afr[]={0,0,0,0,0,0,0,0,0,0};
double afrl[]={0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0}, afrh[]={0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0}, afrx[]={0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
// ��������� ����������
double openTF[]={0.0,0.0,0.0,0.0,0.0}, closeTF[]={0.0,0.0,0.0,0.0,0.0}, lowTF[]={0.0,0.0,0.0,0.0,0.0}, highTF[]={0.0,0.0,0.0,0.0,0.0};
double close_TF=0;
string TF[]={"MN","W1","D1","H4","H1","m30","m15","m5","m1"};
string Period_tf="";
bool   afrm=true;
double ExtHL;
double HL,HLp,kk,kj,Angle;
// LowPrim,HighPrim,LowLast,HighLast - �������� ��������� � ���������� �����
double LowPrim,HighPrim,LowLast,HighLast;
// numLowPrim,numHighPrim,numLowLast,numHighLast -������ �����
int numLowPrim,numHighPrim,numLowLast,numHighLast,k,k1,k2,ki,kiPRZ=0,countLow1,countHigh1,shift,shift1,shift2,shift3;
string txtkk="";
// ����� ���� � ������, ������ � ������� �� �������� ���� ���������
int timeFr1new,timeFr2new,timeFr3new;
// ������� ���������
int countFr;
// ���, �� �������� ���� �������� �������������� ����� �� �������� ����
int countBarEnd=0,TimeBarEnd;
// ���, �� �������� ���� ������������� �� �������� ����
int numBar=0;
// ����� �������
int numOb;
// flagFrNew=true - ����������� ����� ������� ��� ������ ������� ��������� �� ������ ���. =false - �� ���������.
bool flagFrNew=false;
// ������������� ������ ����
bool newRay=true;
// flagGartley - ��������� ������ �������� Gartley ��� ������������ �������� Gartley
bool flagGartley=false;
// ������ �������� �������
int perTF;
bool Demo;
// ���������� ��� �������, �������������� wellx
bool   first=true;
int    NewBarTime=0, countbars=0;
int    lasthighpos,lastlowpos,realcnt=0;
double lasthigh,lastlow;

double int_to_d=0, int_to_d1=0, int_to_d2=0;

int counted_bars, cbi, iBar;

// ������� ������ ���� �������� ����������
// The average size of a bar
double ASBar;

// ���������� ��� ZigZag ������ � ���������� ��������� ����������� � Ensign
double ha[],la[],hi,li,si,sip,di,hm,lm,ham[],lam[],him,lim,lLast=0,hLast=0;
int fs=0,fsp,countBar;
int ai,bi,ai0,bi0,aim,bim;
datetime tai,tbi,ti,tmh,tml;
// fcount0 - ��� ��������� �������� ����������� ����� �� 0 ���� fcount0=true.
// �� ��������� ���� =false � ����� ���������� ����� ��������
bool fh=false,fl=false,fcount0,PeakDetIni;

/*
// ���������� ��� ������� �����
double lLast_m=0, hLast_m=0;
int countBarExt; // ������� ������� �����
int countBarl,countBarh;
*/
// ���������� ��� nen-ZigZag
bool hi_nen;
bool init_zz=true;

// ���������� ��� ������������ ������ ������ ����������
int mFibo[]={0,0}, mPitch[]={0,0,0}, mFan[]={0,0}, mExpansion[]={0,0,0}, mVL[]={0,0,0}, mArcS[]={0,0}, mArcD[]={0,0}, mSpiral[]={0,0},mChannels[]={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
// ���������� ��� ���������� ��� ������� �� ������
int      mPitchTime[]={0,0,0};
int      mPitchTimeSave;
double   mPitchCena[]={0.0,0.0,0.0};

double   hBar, lBar;
datetime tiZZ;
int      _ExtPitchforkStatic=0, _ExtPitchforkDinamic=0;

// ���������� ��� vts
double   ms[2];
// ���������� ��� ��������� Gartley
string   vBullBear    = ""; // ���������� ��� ����������� ����� ��� �������� �������
string   vNamePattern = ""; // ���������� ��� ����������� ������������ ��������
string   vBullBearToNumberPattern = "";
string   vNamePatternToNumberPattern = "";
string   vNameStrongToNumberPattern = "";
string   vNameStrongPattern = "";
int      maxPeak;
bool     vPatOnOff = false, vPatNew = false, saveParametersZZ=false;
int      Depth;

datetime TimeForDmin  = 0, TimeForDminToNumberPattern;
datetime TimeForDmax  = 0, TimeForDmaxToNumberPattern;
double   LevelForDmin = 0, LevelForDminToNumberPattern;
double   LevelForDmax = 0, LevelForDmaxToNumberPattern;
double   PeakCenaX[1],PeakCenaA[1],PeakCenaB[1],PeakCenaC[1],PeakCenaD[1];
datetime PeakTimeX[1],PeakTimeA[1],PeakTimeB[1],PeakTimeC[1],PeakTimeD[1];
int      countGartley = 0;      // ������� ���������
int      minBarsToNumberPattern;
int      minSizeToNumberPattern;
double   minPercentToNumberPattern;
color    ColorList[];
int      ColorSize;
int      countColor   = 0;
bool     flagExtGartleyTypeSearch2=false;
int      minBarsSave, minBarsX;
string   info_RZS_RL="",info_RZD_RL="";

bool   CustomPat_[37];
string namepatterns[37]=
{"Gartley",       "Bat",         "A alt Shark",        "A Nen star",   "Butterfly 113",
"Butterfly",      "Crab",        "A Shark",            "new A Cypher", "LEONARDO",   
"A Butterfly",    "A Crab",      "Shark",              "new Cypher",   "sea PONY",
"A Gartley",      "A Bat",       "alt Shark",          "Nen star",     "Partizan",
"alt Bat",        "Deep Crab",   "Black swan",          "121",
"max Bat",        "max Gartley", "max Butterfly",       "A 121",
"white SWAN",     "Navarro 200", "3 drives",            "A 3 drives",
"TOTAL 1",        "TOTAL 2",     "TOTAL 3",             "TOTAL 4",      "TOTAL ***"};

double minXB_[37]=
{0.618, 0.382, 0.446, 0.5,   0.786
 0.786, 0.382, 0.446, 0.5,   0.5,
 0.382, 0.276, 0.382, 0.382, 0.128,
 0.618, 0.382, 0.382, 0.382, 0.128,
 0.382, 0.886, 1.382, 0.5,
 0.382, 0.382, 0.618, 1.618,
 0.382, 0.382, 1.272, 0.618,
 0.382, 0.382, 0.276, 0.382, 0.276};
double maxXB_[37]=
{0.618, 0.5,   0.618, 0.886, 1.0,
 0.786, 0.618, 0.618, 0.886, 0.5,
 0.618, 0.446, 0.618, 0.618, 3.618,
 0.786, 0.618, 0.618, 0.618, 3.618,
 0.382, 0.886, 2.618, 0.618,
 0.618, 0.618, 0.886, 0.786,
 0.724, 0.786, 1.618, 0.786,
 0.786, 0.786, 0.618, 0.786, 0.786}; 
double minAC_[37]=
{0.382, 0.382, 0.618, 0.467, 0.618,
 0.382, 0.382, 0.618, 0.467, 0.382,
 1.128, 1.128, 1.128, 1.414, 0.382,
 1.128, 1.128, 1.128, 1.414, 0.382,
 0.382, 0.382, 0.236, 1.272,
 0.382, 0.382, 0.382, 0.447,
 2.0,  0.886,  0.618, 1.272,
 0.382, 0.382, 1.128, 1.128, 0.382};
double maxAC_[37]=
{0.886, 0.886, 0.886, 0.707, 1.0,
 0.886, 0.886, 0.886, 0.707, 0.886,
 2.618, 2.618, 1.618, 2.14,  0.5,
 2.618, 2.618, 1.618, 2.14,  0.382,
 0.886, 0.886, 0.5,   2.0,
 0.886, 0.886, 0.886, 0.786,
 4.237, 1.128, 0.786, 1.618,
 0.886, 0.886, 2.618, 2.618, 2.618};
double minBD_[37]=
{1.272, 1.618, 1.618, 1.618, 1.128,
 1.618, 2.24,  1.618, 1.618, 1.128,
 1.272, 1.618, 1.618, 1.128, 1.618,
 1.618, 2.0,   1.618, 1.128, 1.618,
 2.0,   2.618, 1.128, 0.447,
 1.272, 1.128, 1.272, 1.618,
 0.5,   0.886, 1.272, 0.618,
 1.272, 1.618, 1.272, 1.618, 1.272};
double maxBD_[37]=
{1.618, 2.618, 2.618, 2.618, 1.618,
 2.618, 3.618, 2.618, 2.618, 2.618,
 1.272, 2.618, 2.236, 2.0,   2.618,
 1.618, 2.618, 2.236, 2.0,   1.618,
 3.618, 3.618, 2.0,   0.618,
 2.618, 2.236, 2.618, 2.0,
 0.886, 3.618, 1.618, 0.786,
 2.618, 3.618, 2.618, 2.618, 3.618};
double minXD_[37]=
{0.786, 0.886, 0.886, 0.786, 1.128,
 1.272, 1.618, 1.128, 1.272, 0.786,
 0.618, 0.618, 0.886, 0.786, 0.618,
 1.272, 1.128, 1.128, 1.272, 0.618,
 1.128, 1.618, 1.128, 0.382,
 0.886, 0.618, 1.272, 1.272,
 0.382, 0.886, 1.618, 0.13,
 0.786, 1.128, 0.618, 1.128, 0.618};
double maxXD_[37]=
{0.786, 0.886, 0.886, 0.786, 1.128,
 1.618, 1.618, 1.128, 1.272, 0.786,
 0.786, 0.618, 0.886, 0.786, 3.618,
 1.272, 1.128, 1.128, 1.272, 3.618,
 1.128, 1.618, 2.618, 0.786,
 0.886, 0.786, 1.618, 2.618,
 0.886, 1.128, 2.618, 0.886,
 0.886, 1.618, 0.886, 1.272, 1.618};

// ������ ����� ������ ���������
int codPatterns[788,3]=
{5,10912,9,5,10913,9,5,10914,9,5,10915,9,5,11012,9,5,11013,9,5,11014,9,5,11015,9,5,11112,9,5,11113,9,5,11114,9,5,11115,9,5,11212,9,5,11213,9,5,11214,9,5,11215,9,5,11312,9,5,11313,9,
5,11314,9,5,11315,9,5,11412,9,5,11413,9,5,11414,9,5,11415,9,5,11512,9,5,11513,9,5,11514,9,5,11515,9,5,20910,8,5,20912,9,5,20913,9,5,20914,9,5,20915,9,5,21010,8,5,21012,9,5,21013,9,
5,21014,9,5,21015,9,5,21110,8,5,21112,9,5,21113,9,5,21114,9,5,21115,9,5,21210,8,5,21212,9,5,21213,9,5,21214,9,5,21215,9,5,21310,8,5,21312,9,5,21313,9,5,21314,9,5,21315,9,5,21410,8,
5,21412,9,5,21413,9,5,21414,9,5,21415,9,5,21510,8,5,21512,9,5,21513,9,5,21514,9,5,21515,9,5,30910,8,5,30912,9,5,30913,9,5,30914,9,5,30915,9,5,31010,8,5,31012,9,5,31013,9,5,31014,9,
5,31015,9,5,31110,8,5,31112,9,5,31113,9,5,31114,9,5,31115,9,5,31210,8,5,31212,9,5,31213,9,5,31214,9,5,31215,9,5,31310,8,5,31312,9,5,31313,9,5,31314,9,5,31315,9,5,31410,8,5,31412,9,
5,31413,9,5,31414,9,5,31415,9,5,31510,8,5,31512,9,5,31513,9,5,31514,9,5,31515,9,5,40910,8,5,41010,8,5,41110,8,5,41210,8,5,41310,8,5,41410,8,5,41510,8,5,50910,8,5,51010,8,5,51110,8,
5,51210,8,5,51310,8,5,51410,8,5,51510,8,6,20910,8,6,21010,8,6,21110,8,6,21210,8,6,21310,8,6,21410,8,6,21510,8,6,30910,8,6,31010,8,6,31110,8,6,31210,8,6,31310,8,6,31410,8,6,31510,8,
6,40910,8,6,41010,8,6,41110,8,6,41210,8,6,41310,8,6,41410,8,6,41510,8,6,50910,8,6,51010,8,6,51110,8,6,51210,8,6,51310,8,6,51410,8,6,51510,8,7,20910,11,7,20911,11,7,20912,11,
7,20913,11,7,21010,8,7,21110,11,7,21111,11,7,21112,11,7,21113,11,7,21210,8,7,21310,8,7,21410,8,7,21510,8,7,30910,11,7,30911,11,7,30912,11,7,30913,11,7,31010,8,7,31110,11,7,31111,11,
7,31112,11,7,31113,11,7,31210,8,7,31310,8,7,31410,8,7,31510,8,7,40612,3,7,40613,3,7,40614,3,7,40615,3,7,40712,3,7,40713,3,7,40714,3,7,40715,3,7,40812,3,7,40813,3,7,40814,3,7,40815,3,
7,40910,11,7,40911,11,7,40912,11,7,40913,11,7,41010,8,7,41110,11,7,41111,11,7,41112,11,7,41113,11,7,41210,8,7,41310,8,7,41410,8,7,41510,8,7,50210,0,7,50211,0,7,50212,0,7,50310,0,
7,50311,0,7,50312,0,7,50410,0,7,50411,0,7,50412,0,7,50510,0,7,50511,0,7,50512,0,7,50610,0,7,50611,0,7,50612,0,7,50613,3,7,50614,3,7,50615,3,7,50710,0,7,50711,0,7,50712,0,7,50713,3,
7,50714,3,7,50715,3,7,50810,0,7,50811,0,7,50812,0,7,50813,3,7,50814,3,7,50815,3,7,50910,11,7,50911,11,7,50912,11,7,50813,11,7,51009,8,7,51110,11,7,51110,11,7,51112,11,7,51113,11,
7,51210,8,7,51310,8,7,51410,8,7,51510,8,7,60612,3,7,60613,3,7,60614,3,7,60615,3,7,60712,3,7,60713,3,7,60714,3,7,60715,3,7,60812,3,7,60813,3,7,60814,3,7,60815,3,7,70612,3,7,70613,3,
7,70614,3,7,70615,3,7,70712,3,7,70713,3,7,70714,3,7,70715,3,7,70812,3,7,70813,3,7,70814,3,7,70815,3,8,20215,1,8,20315,1,8,20415,1,8,20515,1,8,20614,1,8,20615,1,8,20714,1,8,20715,1,
8,20813,1,8,20814,1,8,20815,1,8,20912,10,8,20913,10,8,20914,10,8,21112,10,8,21113,10,8,21114,10,8,21212,10,8,21213,10,8,21214,10,8,30512,2,8,30513,2,8,30514,2,8,30515,2,8,30612,2,
8,30613,2,8,30614,2,8,30615,2,8,30712,2,8,30713,2,8,30714,2,8,30715,2,8,30812,2,8,30813,2,8,30814,2,8,30815,2,8,30912,10,8,30913,10,8,30914,10,8,31112,10,8,31113,10,8,31114,10,
8,31212,10,8,31213,10,8,31214,10,8,40214,1,8,40215,1,8,40314,1,8,40315,1,8,40413,1,8,40414,1,8,40315,1,8,40512,1,8,40513,1,8,40514,1,8,40515,1,8,40612,1,8,40613,1,8,40614,1,8,40615,1,
8,40712,1,8,40713,1,8,40714,1,8,40715,1,8,40812,1,8,40813,1,8,40814,1,8,40815,1,8,40912,10,8,40913,10,8,40914,10,8,41112,10,8,41113,10,8,41114,10,8,41212,10,8,41213,10,8,41214,10,
8,50512,2,8,50513,2,8,50514,2,8,50515,2,8,50612,2,8,50613,2,8,50614,2,8,50615,2,8,50712,2,8,50713,2,8,50714,2,8,50715,2,8,50812,2,8,50813,2,8,50814,2,8,50815,2,8,50912,10,8,50913,10,
8,50914,10,8,51112,10,8,51113,10,8,51114,10,8,51211,10,8,51213,10,8,51214,10,9,20215,16,9,20217,16,9,20314,16,9,20315,16,9,20317,16,9,20414,16,9,20415,16,9,20417,16,9,20513,16,
9,20514,16,9,20515,16,9,20517,16,9,20613,16,9,20614,16,9,20615,16,9,20617,16,9,20713,16,9,20714,16,9,20715,16,9,20813,16,9,20814,16,9,20815,16,9,20913,14,9,20914,14,9,20915,14,
9,20917,14,9,20918,14,9,21013,13,9,21014,13,9,21015,13,9,21113,14,9,21114,14,9,21115,14,9,21117,14,9,21118,14,9,21213,14,9,21214,14,9,21215,14,9,21217,14,9,21218,14,9,21313,13,
9,21314,13,9,21315,13,9,21413,13,9,21414,13,9,21415,13,9,21513,13,9,21514,13,9,21515,13,9,30512,6,9,30513,6,9,30514,6,9,30515,6,9,30612,6,9,30613,6,9,30614,6,9,30615,6,9,30712,6,
9,30713,6,9,30714,6,9,30715,6,9,30812,6,9,30813,6,9,30814,6,9,30815,6,9,30913,14,9,30914,14,9,30915,14,9,30917,14,9,30918,14,9,31013,13,9,31014,13,9,31015,13,9,31113,14,9,31114,14,
9,31115,14,9,31117,14,9,31213,14,9,31214,14,9,31215,14,9,31217,14,9,31313,13,9,31314,13,9,31315,13,9,31413,13,9,31414,13,9,31415,13,9,31513,13,9,31514,13,9,31515,13,9,40512,6,
9,40513,6,9,40514,6,9,40514,6,9,40612,6,9,40613,6,9,40614,6,9,40615,6,9,40712,6,9,40713,6,9,40714,6,9,40715,6,9,40812,6,9,40813,6,9,40814,6,9,40815,6,9,40913,14,9,40914,14,9,40915,14,
9,40917,14,9,41013,13,9,41014,13,9,41015,13,9,41113,14,9,41114,14,9,41115,14,9,41117,14,9,41213,14,9,41214,14,9,41215,14,9,41313,13,9,41314,13,9,41315,13,9,41413,13,9,41414,13,
9,41415,13,9,41513,13,9,41514,13,9,41515,13,9,50512,6,9,50513,6,9,50514,6,9,50415,6,9,50612,6,9,50613,6,9,50614,6,9,50615,6,9,50712,6,9,50713,6,9,50714,6,9,50715,6,9,50812,6,
9,50813,6,9,50814,6,9,50815,6,9,50913,14,9,50914,14,9,50915,14,9,50917,14,9,51013,13,9,51014,13,9,51015,13,9,51113,14,9,51114,14,9,51115,14,9,51117,14,9,51213,14,9,51214,14,9,51215,14,
9,51312,13,9,51314,13,9,51315,13,9,51413,13,9,51413,13,9,51415,13,9,51513,13,9,51514,13,9,51514,13,10,20910,15,10,20911,15,10,20912,15,10,20913,15,10,20915,15,10,21110,15,10,21111,15,
10,21112,15,10,21113,15,10,21115,15,10,30910,15,10,30911,15,10,30912,15,10,30913,15,10,30915,15,10,31110,15,10,31111,15,10,31112,15,10,31113,15,10,31115,15,10,40612,7,10,40613,7,
10,40614,7,10,40615,7,10,40712,7,10,40713,7,10,40714,7,10,40715,7,10,40812,7,10,40813,7,10,40814,7,10,40815,7,10,40910,15,10,40911,15,10,40912,15,10,40913,15,10,40915,15,10,41110,15,
10,41111,15,10,41112,15,10,41113,15,10,41115,15,10,50612,7,10,50613,7,10,50614,7,10,50615,7,10,50712,7,10,50713,7,10,50714,7,10,50715,7,10,50812,7,10,50813,7,10,50814,7,10,50815,7,
10,50910,15,10,50911,15,10,50912,12,10,50913,15,10,51012,12,10,51110,15,10,51111,15,10,51112,12,10,51113,15,10,51212,12,10,51312,12,10,51412,12,10,51512,12,10,60612,7,10,60613,7,
10,60614,7,10,60515,7,10,60712,7,10,60713,7,10,60714,7,10,60715,7,10,60812,7,10,60813,7,10,60814,7,10,60815,7,10,60912,12,10,61012,12,10,61112,12,10,61212,12,10,61312,12,10,61412,12,
10,61512,12,10,70212,4,10,70213,4,10,70214,4,10,70215,4,10,70312,4,10,70313,4,10,70314,4,10,70315,4,10,70412,4,10,70413,4,10,70414,4,10,70415,4,10,70512,4,10,70513,4,10,70514,4,
10,70515,4,10,70612,4,10,70613,4,10,70614,4,10,70615,4,10,70712,4,10,70713,4,10,70714,4,10,70715,4,10,70812,4,10,70813,4,10,70814,4,10,70815,4,10,70912,12,10,71012,12,10,71112,12,
10,71212,12,10,71312,12,10,71412,12,10,71512,12,11,70212,4,11,70213,4,11,70214,4,11,70312,4,11,70313,4,11,70314,4,11,70412,4,11,70413,4,11,70414,4,11,70512,4,11,70513,4,11,70514,4,
11,70612,4,11,70613,4,11,70614,4,11,70712,4,11,70713,4,11,70714,4,11,70812,4,11,70813,4,11,70814,4,12,20212,5,12,20213,5,12,20214,5,12,20215,5,12,20216,5,12,20217,5,12,20118,5,
12,20312,5,12,20313,5,12,20314,5,12,20315,5,12,20316,5,12,20317,5,12,20318,5,12,20412,5,12,20413,5,12,20414,5,12,20415,5,12,20416,5,12,20417,5,12,20418,5,12,20512,5,12,20513,5,
12,20514,5,12,20515,5,12,20516,5,12,20517,5,12,20612,5,12,20613,5,12,20614,5,12,20615,5,12,20615,5,12,20616,5,12,20712,5,12,20713,5,12,20714,5,12,20715,5,12,20716,5,12,20717,5,
12,20812,5,12,20813,5,12,20814,5,12,20815,5,12,20816,5,12,20817,5,12,30212,5,12,30213,5,12,30214,5,12,30215,5,12,30216,5,12,30217,5,12,30218,5,12,30312,5,12,30313,5,12,30214,5,
12,30614,5,12,40217,5,12,40317,5,12,40417,5,12,40517,5,12,40617,5,12,40716,5,12,40717,5,12,40816,5,12,40817,5,12,50217,5,12,50317,5,12,50416,5,12,50616,5,12,50617,5,12,50715,5,
12,50716,5,12,50717,5,12,50814,5,12,50815,5,12,50816,5,12,70212,4,12,70213,4,12,70214,4,12,70312,4,12,70313,4,12,70314,4,12,70412,4,12,70413,4,12,70414,4,12,70512,4,12,70513,4,
12,70514,4,12,70612,4,12,70613,4,12,70614,4,12,70712,4,12,70713,4,12,70614,4,12,70812,4,12,70813,4,12,70814,4,12,80215,17,12,80216,17,12,80217,17,12,80315,17,12,80316,17,12,80317,17,
12,80415,17,12,80416,17,12,80417,17,12,80515,17,12,80516,17,12,80518,17,12,80614,17,12,80615,17,12,80616,17,12,80714,17,12,80715,17,12,80716,17,12,80814,17,12,80815,17,12,80716,5};
// ��������� ������ ��� ������ ���������
int index[788,2]=
{0,10912,1,10913,2,10914,3,10915,4,11012,5,11013,6,11014,7,11015,8,11112,9,11113,10,11114,11,11115,12,11212,13,11213,14,11214,15,11215,16,11312,17,11313,18,11314,19,11315,20,11412,
21,11413,22,11414,23,11415,24,11512,25,11513,26,11514,27,11515,676,20118,670,20212,671,20213,672,20214,258,20215,360,20215,673,20215,674,20216,361,20217,675,20217,677,20312,678,20313,
362,20314,679,20314,259,20315,363,20315,680,20315,681,20316,364,20317,682,20317,683,20318,684,20412,685,20413,365,20414,686,20414,260,20415,366,20415,687,20415,688,20416,367,20417,
689,20417,690,20418,691,20512,368,20513,692,20513,369,20514,693,20514,261,20515,370,20515,694,20515,695,20516,371,20517,696,20517,697,20612,372,20613,698,20613,262,20614,373,20614,
699,20614,263,20615,374,20615,700,20615,701,20615,702,20616,375,20617,703,20712,376,20713,704,20713,264,20714,377,20714,705,20714,265,20715,378,20715,706,20715,707,20716,708,20717,
709,20812,266,20813,379,20813,710,20813,267,20814,380,20814,711,20814,268,20815,381,20815,712,20815,713,20816,714,20817,28,20910,112,20910,140,20910,528,20910,141,20911,529,20911,
29,20912,142,20912,269,20912,530,20912,30,20913,143,20913,270,20913,382,20913,531,20913,31,20914,271,20914,383,20914,32,20915,384,20915,532,20915,385,20917,386,20918,33373,21010,
113,21010,144,21010,34,21012,35,21013,387,21013,36,21014,388,21014,37,21015,389,21015,38,21110,114,21110,145,21110,533,21110,146,21111,534,21111,39,21112,147,21112,272,21112,535,21112,
40,21113,148,21113,273,21113,390,21113,536,21113,41,21114,274,21114,391,21114,42,21115,392,21115,537,21115,393,21117,394,21118,43,21210,115,21210,149,21210,44,21212,275,21212,
45,21213,276,21213,395,21213,46,21214,277,21214,396,21214,47,21215,397,21215,398,21217,399,21218,48,21310,116,21310,150,21310,49,21312,50,21313,400,21313,51,21314,401,21314,52,21315,
402,21315,53,21410,117,21410,151,21410,54,21412,55,21413,403,21413,56,21414,404,21414,57,21415,405,21415,58,21510,118,21510,152,21510,59,21512,60,21513,406,21513,61,21514,407,21514,
62,21515,408,21515,715,30212,716,30213,717,30214,724,30214,718,30215,719,30216,720,30217,721,30218,722,30312,723,30313,278,30512,409,30512,279,30513,410,30513,280,30514,411,30514,
281,30515,412,30515,282,30612,413,30612,283,30613,414,30613,284,30614,415,30614,725,30614,285,30615,416,30615,286,30712,417,30712,287,30713,418,30713,288,30714,419,30714,289,30715,
420,30715,290,30812,421,30812,291,30813,422,30813,292,30814,423,30814,293,30815,424,30815,63,30910,119,30910,153,30910,538,30910,154,30911,539,30911,64,30912,155,30912,294,30912,
540,30912,65,30913,156,30913,295,30913,425,30913,541,30913,66,30914,296,30914,426,30914,67,30915,427,30915,542,30915,428,30917,429,30918,68,31010,120,31010,157,31010,69,31012,70,31013,
430,31013,71,31014,431,31014,72,31015,432,31015,73,31110,121,31110,158,31110,543,31110,159,31111,544,31111,74,31112,160,31112,297,31112,545,31112,75,31113,161,31113,298,31113,
433,31113,546,31113,76,31114,299,31114,434,31114,77,31115,435,31115,547,31115,436,31117,78,31210,122,31210,162,31210,79,31212,300,31212,80,31213,301,31213,437,31213,81,31214,
302,31214,438,31214,82,31215,439,31215,440,31217,83,31310,123,31310,163,31310,84,31312,85,31313,441,31313,86,31314,442,31314,87,31315,443,31315,88,31410,124,31410,164,31410,89,31412,
90,31413,444,31413,91,31414,445,31414,92,31415,446,31415,93,31510,125,31510,165,31510,94,31512,95,31513,447,31513,96,31514,448,31514,97,31515,449,31515,303,40214,304,40215,726,40217,
305,40314,306,40315,309,40315,727,40317,307,40413,308,40414,728,40417,310,40512,450,40512,311,40513,451,40513,312,40514,452,40514,453,40514,313,40515,729,40517,166,40612,314,40612,
454,40612,548,40612,167,40613,315,40613,455,40613,549,40613,168,40614,316,40614,456,40614,550,40614,169,40615,317,40615,457,40615,551,40615,730,40617,170,40712,318,40712,458,40712,
552,40712,171,40713,319,40713,459,40713,553,40713,172,40714,320,40714,460,40714,554,40714,173,40715,321,40715,461,40715,555,40715,731,40716,732,40717,174,40812,322,40812,462,40812,
556,40812,175,40813,323,40813,463,40813,557,40813,176,40814,324,40814,464,40814,558,40814,177,40815,325,40815,465,40815,559,40815,733,40816,734,40817,98,40910,126,40910,178,40910,
560,40910,179,40911,561,40911,180,40912,326,40912,562,40912,181,40913,327,40913,466,40913,563,40913,328,40914,467,40914,468,40915,564,40915,469,40917,99,41010,127,41010,182,41010,
470,41013,471,41014,472,41015,100,41110,128,41110,183,41110,565,41110,184,41111,566,41111,185,41112,329,41112,567,41112,186,41113,330,41113,473,41113,568,41113,331,41114,474,41114,
475,41115,569,41115,476,41117,101,41210,129,41210,187,41210,332,41212,333,41213,477,41213,334,41214,478,41214,479,41215,102,41310,130,41310,188,41310,480,41313,481,41314,482,41315,
103,41410,131,41410,189,41410,483,41413,484,41414,485,41415,104,41510,132,41510,190,41510,486,41513,487,41514,488,41515,191,50210,192,50211,193,50212,735,50217,194,50310,195,50311,
196,50312,736,50317,197,50410,198,50411,199,50412,492,50415,737,50416,200,50510,201,50511,202,50512,335,50512,489,50512,336,50513,490,50513,337,50514,491,50514,338,50515,203,50610,
204,50611,205,50612,339,50612,493,50612,570,50612,206,50613,340,50613,494,50613,571,50613,207,50614,341,50614,495,50614,572,50614,208,50615,342,50615,496,50615,573,50615,738,50616,
739,50617,209,50710,210,50711,211,50712,343,50712,497,50712,574,50712,212,50713,344,50713,498,50713,575,50713,213,50714,345,50714,499,50714,576,50714,214,50715,346,50715,500,50715,
577,50715,740,50715,741,50716,742,50717,215,50810,216,50811,217,50812,347,50812,501,50812,578,50812,218,50813,224,50813,348,50813,502,50813,579,50813,219,50814,349,50814,503,50814,
580,50814,743,50814,220,50815,350,50815,504,50815,581,50815,744,50815,745,50816,105,50910,133,50910,221,50910,582,50910,222,50911,583,50911,223,50912,351,50912,584,50912,352,50913,
505,50913,585,50913,353,50914,506,50914,507,50915,508,50917,225,51009,106,51010,134,51010,586,51012,509,51013,510,51014,511,51015,107,51110,135,51110,226,51110,227,51110,587,51110,
588,51111,228,51112,354,51112,589,51112,229,51113,355,51113,512,51113,590,51113,356,51114,513,51114,514,51115,515,51117,108,51210,136,51210,230,51210,357,51211,591,51212,358,51213,
516,51213,359,51214,517,51214,518,51215,109,51310,137,51310,231,51310,519,51312,592,51312,520,51314,521,51315,110,51410,138,51410,232,51410,593,51412,522,51413,523,51413,524,51415,
111,51510,139,51510,233,51510,594,51512,525,51513,526,51514,527,51514,598,60515,234,60612,595,60612,235,60613,596,60613,236,60614,597,60614,237,60615,238,60712,599,60712,239,60713,
600,60713,240,60714,601,60714,241,60715,602,60715,242,60812,603,60812,243,60813,604,60813,244,60814,605,60814,245,60815,606,60815,607,60912,608,61012,609,61112,610,61212,611,61312,
612,61412,613,61512,614,70212,649,70212,746,70212,615,70213,650,70213,747,70213,616,70214,651,70214,748,70214,617,70215,618,70312,652,70312,749,70312,619,70313,653,70313,750,70313,
620,70314,654,70314,751,70314,621,70315,622,70412,655,70412,752,70412,623,70413,656,70413,753,70413,624,70414,657,70414,754,70414,625,70415,626,70512,658,70512,755,70512,627,70513,
659,70513,756,70513,628,70514,660,70514,757,70514,629,70515,246,70612,630,70612,661,70612,758,70612,247,70613,631,70613,662,70613,759,70613,248,70614,632,70614,663,70614,760,70614,
763,70614,249,70615,633,70615,250,70712,634,70712,664,70712,761,70712,251,70713,635,70713,665,70713,762,70713,252,70714,636,70714,666,70714,253,70715,637,70715,254,70812,638,70812,
667,70812,764,70812,255,70813,639,70813,668,70813,765,70813,256,70814,640,70814,669,70814,766,70814,257,70815,641,70815,642,70912,643,71012,644,71112,645,71212,646,71312,647,71412,
648,71512,767,80215,768,80216,769,80217,770,80315,771,80316,772,80317,773,80415,774,80416,775,80417,776,80515,777,80516,778,80518,779,80614,780,80615,781,80616,782,80714,783,80715,
784,80716,787,80716,785,80814,786,80815};

int levelXD[32,2]; // ����� ��������, ��� ������
//string   namepatterns[18]={"Gartley","Bat","Anti Alternate Shark","Anti Nen Star","Butterfly","Crab","Anti Shark","Anti Cypher","Anti Butterfly","Anti Crab","Shark","Cypher",
//"Anti Gartley","Anti Bat","Alternate Shark","Nen Star","Alternate Bat","Deep Crab"};
int      nstrcod[8,2]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; // ������ ������� ����� ����� ������� retXD
int      nstrind[8,2]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; // ������ ������� ����� ����� ������� retXB
int      nstrind1[95,2];
double   deltapatterns[19,2];
//                          0      1     2     3    4   5      6     7    8     9    10     11   12    13   14   15     16     17    18
double   retpatterns[19]={0.146,0.236,0.382,0.447,0.5,0.618,0.707,0.786,0.886,1.128,1.272,1.414,1.618,2.0,2.236,2.618,3.1416,3.618,4.236};
string   retpatternstxt[19]={".146",".236",".382",".447",".5",".618",".707",".786",".886","1.128","1.272","1.414","1.618","2.0","2.236","2.618","3.14","3.618","4.236"};
bool     strongABCD[19];
double   min_DeltaGartley, max_DeltaGartley;
int      ret[4]; // XD-XB-AC-BD
double   _ABCDtype[];
string   _ABCDtypetxt[];
int      _ABCDsize;

// ���������� ��� Merrill Patterns
double   mPeak0[5][2]={0,5,0,4,0,3,0,2,0,1}, mPeak1[5][2]={0,5,0,4,0,3,0,2,0,1};
string   mMerrillPatterns[32][3]=
{"21435", "M1", "DownTrend",
"21453", "M2", "InvertedHeadAndShoulders",
"24135", "M3", "DownTrend",
"24153", "M4", "InvertedHeadAndShoulders",
"42135", "M5", "Broadening",
"42153", "M6", "InvertedHeadAndShoulders",
"24315", "M7", "*",
"24513", "M8", "InvertedHeadAndShoulders",
"42315", "M9", "*",
"42513", "M10", "InvertedHeadAndShoulders",
"45213", "M11", "InvertedHeadAndShoulders",
"24351", "M12", "*",
"24531", "M13", "Triangle",
"42351", "M14", "*",
"42531", "M15", "UpTrend",
"45231", "M16", "UpTrend",
"13245", "W1", "DownTrend",
"13524", "W2", "DownTrend",
"15324", "W3", "*",
"13224", "W4", "Triangle",
"15342", "W5", "*",
"31254", "W6", "HeadAndShoulders",
"42513", "W7", "HeadAndShoulders",
"51324", "W8", "*",
"31542", "W9", "HeadAndShoulders",
"51324", "W10", "*",
"35124", "W11", "HeadAndShoulders",
"53124", "W12", "Broadening",
"35142", "W13", "HeadAndShoulders",
"53142", "W14", "UpTrend",
"35412", "W15", "HeadAndShoulders",
"53412", "W16", "UpTrend"};

// ���������� ��� ������� Talex
static int    endbar = 0;
static double endpr  = 0;

// ���������� ��� ������� �������� ���� � �������� ��� Golden Spiral
static int GPixels,VPixels;
int rect[4],hwnd;
int f=1;

// ���������� ��� �������
int DinamicChannels=-1;

// ���������� ��� ������� ����� � ����� �������
bool mAP = false;      // ���� ���������� ������ �����
//double mMax, mMin;   // ���� ��������� ����� ������ � �����. ��� ����������� ���� ������� ������� ���������� ������ ���� �����.
datetime mTime;        // ������� ��������� ������� ����, ��� ����������� ������� ���������� ������� ������� ������� ���� � �������� ��������� ������� ����.
bool mAPs, mAPd;       // ����� - ������� ��� �������� ����� � ����� �������
double RZs=-1, RZd=-1; // ���������� �� ������� ����. �������������� ��� ������ �����.
datetime mPeriod;      // ����� ��������� ������ �������� ����� � ����
bool   aOutRedZone[]  = {false,false,false}; // ������ ��� �������� ���������� �� ����� ����� ��� �������������� ������ ����� ��� ������ ���� �� ������� ����
                                       // ��� ������������ [0] � ����������� [1] ���. [2] - ��� ����������� ��� � ������������ ������
// ���������� ��� ������ ��������� AutoTestRedZone
int    pitch_timeRZ[]={0,0,0}; 
double pitch_cenaRZ[]={0,0,0};

// ���������� ��� ������ ��������� mOutRedZone ��� ������������ � ����������� ���
int    pitch_timeD[]={0,0,0}; 
double pitch_cenaD[]={0,0,0};
int    pitch_timeS[]={0,0,0}; 
double pitch_cenaS[]={0,0,0};

// ���������� ��� ���������� �������� �����
bool mStart=true; // ���������� ��� ��������������� ������� ������ �����
int  aMetki[2][15];      // ������ ��� �������� ������� ������ �����. aMetki[0][15] - ����� ��� ����������� ���; aMetki[1][15] - ����� ��� ������������ ���

double aPointAP[2][8]; // ������ ����� �������� ��� �������. aPointAP[0][6] - ����������� ����, aPointAP[1][6] - ������������ ����. 
                       // �� ������ ��������� ���������� �����, ���� �����
                       // - time1-cena1--time2-cena2--time3-cena3, � ����� ����� ��� ��������� ��� � �����.
                       // aPointAP[x][6] - ���� ��������� ������������ ���,  aPointAP[x][7] - ���� ��������� �����
                       // aPointAP[x][6]=0 - ���������� ���������� ��������
                       // aPointAP[x][6]=1 - �������� ��������� �� ����
                       // ���� ������� �������� ��������� �����. (05 ������ 2011)
                       // ���� ������ ������ ��� ��������� ���������� �����. �������� ����� �������� �������� �������� ����������.

double arrm_s[][7];    // ������ ��� ��������������� ������ ����� � ����������� ����� �������
double arrm_d[][7];    // ������ ��� ��������������� ������ ����� � ������������ ����� �������
double atg[2][9];      // ������ ��������� ����� ������� ������������ ��� ������� � ��� �� ���������
int    anum_cena[2][2];// ������ ������� ����� ��� arrm_s � arrm_d
                       // anum_cena[x][1] - ������������ ���� �����; anum_cena[x][0] - ����������� ���� �����

double aexitFSL_SSL[]={0,0}; // ������ ������ ��� ������ ��������� mExitFSL_SSL

// ������ ����� ��� �������� �������� ����� � ����� �������
string atextm[]={"","SSL","SLM","50% Mediana","SLM 61.8","ISL 38.2","Mediana","ISL 61.8","FSL","FSL Shiff Lines","50% Mediana","UTL","LTL","UWL","LWL"};

// ���������� ��� ���������� ��� ������� �� ������������ ������
int    vX, vY; // ���������� ����� APm
bool   tik2 = false;
bool   tik1 = true;

// APm
bool   SlavePitchfork = false;
string nameCheckLabel_hidden="CheckLabel_hidden";
string nameCheckLabel="CheckLabel";
string nameMagnet[3];
int    period_AM[3];
int    ExtComplektAPm = 0; // ����� ���������, ������� ������������� ����� APm � "������"

string cursor = "Cursor";

//+------------------------------------------------------------------+
//| Custom indicator initialization function. ������.                |
//+------------------------------------------------------------------+
int init()
  {
   if (!ExtVisible) return(-1);

   string aa="", aa1="", txt="";
   int aa2, i, j;
   int i_APm=0; // ������� ��� � ������ APm
   int count_APm;
   int bb=0,bb1=-1;

   nameUWL="UWL " + ExtComplekt+"_";
   nameLWL="LWL " + ExtComplekt+"_";
   nameUTL="UTL " + ExtComplekt+"_";
   nameLTL="LTL " + ExtComplekt+"_";

   nameUWLd="UWL_d " + ExtComplekt+"_";
   nameLWLd="LWL_d " + ExtComplekt+"_";
   nameUTLd="UTL_d " + ExtComplekt+"_";
   nameLTLd="LTL_d " + ExtComplekt+"_";

   vX=30; vY=30; // ���������� ����� APm

   hwnd=WindowHandle(Symbol(),Period());
   if(hwnd>0)
     {
      GetClientRect(hwnd,rect);
      GPixels=rect[2]; // ����� ������� ���������� ���-�� �������� �� ����������� ��� ���� � ��������, � ������� ����������� ���������
      VPixels=rect[3]; // ����� ������� ���������� ���-�� �������� �� ���������
     }

   if (ParametresZZforDMLEWA>0 && (ExtIndicator==0 || ExtIndicator==6))
     {
      switch (ParametresZZforDMLEWA)
        {
         case 1:
           minBars=5; ExtBackstep=8;
           break;
         case 2:
           minBars=8; ExtBackstep=13;
           break;
         case 3:
           minBars=13; ExtBackstep=21;
           break;
         case 4:
           minBars=21; ExtBackstep=34;
           break;
         case 5:
           minBars=34; ExtBackstep=55;
           break;
         case 6:
           minBars=55; ExtBackstep=89;
           break;
         case 7:
           minBars=89; ExtBackstep=144;
           break;
         case 8:
           minBars=144; ExtBackstep=233;
        }
     }

   minBarsSave=minBars;

   IndicatorBuffers(8);

   if (ExtIndicator==14)
     {
      if (auto)
        {
         double wrmassiv[];

         if (minBar>=100) minBar=61.8;
         if (minBar<=0) minBar=61.8;
         if (maxBar>=100) maxBar=38.2;
         if (minBar<=0) minBar=38.2;

         ArrayResize(wrmassiv,Bars-1);
         for (i=Bars-1;i>0;i--) {wrmassiv[i]=High[i]-Low[i]+Point;}
         ArraySort (wrmassiv);
         i=MathFloor(minBar*Bars/100);
         StLevel=MathFloor(wrmassiv[i]/Point);
         i=MathFloor(maxBar*Bars/100);
         BigLevel=MathFloor(wrmassiv[i]/Point);
        }
     }

   if (ExtMaxBar>Bars) ExtMaxBar=Bars;
   if (ExtMaxBar>0) _maxbarZZ=ExtMaxBar; else _maxbarZZ=Bars;

// -------
// Gartley Patterns

   if (ExtIndicator==11 || PotencialsLevels_retXD<0) PotencialsLevels_retXD=0;
   if (PotencialsLevels_retXD>2) PotencialsLevels_retXD=2;

   if (ExtIndicator==11 || ExtGartleyOnOff || PotencialsLevels_retXD>0)
     {
      j=0;
      bb1=0;
      for (i=0;i<788;i++)
        {
         if (bb1<index[i,1]/100)
           {
            bb1=index[i,1]/100; 
            nstrind1[j,0]=bb1; 
            nstrind1[j,1]=i; 
            j++;
           }
        }

      j=0;
      for (i=0;i<788;i++)
        {
         bb1=codPatterns[i,0];
         if (bb<bb1)
           {
            bb=bb1;
            nstrcod[j,0]=bb;
            nstrcod[j,1]=i;
            j++;
           }
        }

      j=0; bb=-1;
      for (i=0;i<788;i++)
        {
         bb1=index[i,1]/10000;
         if (bb<bb1)
           {
            bb=bb1;
            nstrind[j,0]=bb;
            nstrind[j,1]=i;
            j++;
           }
        }

      min_DeltaGartley = (1 - ExtDeltaStrongGartley);
      max_DeltaGartley = (1 + ExtDeltaStrongGartley);

      for (i=0;i<19;i++)
        {
         deltapatterns[i,0]=retpatterns[i]*min_DeltaGartley;
         deltapatterns[i,1]=retpatterns[i]*max_DeltaGartley;
        }

      min_DeltaGartley = (1 - ExtDeltaGartley);
      max_DeltaGartley = (1 + ExtDeltaGartley);

      if (CustomPattern>0)
        {
         minAC = min_DeltaGartley * minAC;
         minBD = min_DeltaGartley * minBD;
         minXB = min_DeltaGartley * minXB;
         minXD = min_DeltaGartley * minXD;

         maxAC = max_DeltaGartley * maxAC;
         maxBD = max_DeltaGartley * maxBD;
         maxXB = max_DeltaGartley * maxXB;
         maxXD = max_DeltaGartley * maxXD;
        }

      for (i=0;i<27;i++)
        {
         minAC_[i] = min_DeltaGartley * minAC_[i];
         minBD_[i] = min_DeltaGartley * minBD_[i];
         minXB_[i] = min_DeltaGartley * minXB_[i];
         minXD_[i] = min_DeltaGartley * minXD_[i];

         maxAC_[i] = max_DeltaGartley * maxAC_[i];
         maxBD_[i] = max_DeltaGartley * maxBD_[i];
         maxXB_[i] = max_DeltaGartley * maxXB_[i];
         maxXD_[i] = max_DeltaGartley * maxXD_[i];
        }

      if (ExtGartleyTypeSearch<0) ExtGartleyTypeSearch=0;
      if (ExtGartleyTypeSearch>2) ExtGartleyTypeSearch=2;

      if (ExtIndicator==11)
        {
         if (ExtHiddenPP<0) ExtHiddenPP=0;
         if (ExtHiddenPP>2) ExtHiddenPP=2;

         if (IterationStepDepth<1) IterationStepDepth=1;
         if (IterationStepDepth>maxDepth-minDepth) IterationStepDepth=maxDepth-minDepth;

         if (IterationStepSize<1) IterationStepSize=1;
         if (IterationStepSize>maxSize_-minSize_) IterationStepSize=maxSize_-minSize_;

         if (IterationStepPercent<1) IterationStepPercent=1;
        }

      if (NumberPattern<1) NumberPattern=1;

      if (ExtIndicator==11 && (ExtHiddenPP==0 || ExtHiddenPP==2)) {ExtHidden=0; ExtStyleZZ=false;}

      if (ExtGartleyTypeSearch>0)
        {
         if (patternInfluence==0)
           {
            if (ExtMaxBar>0)
              {
               if (maxBarToD==0 || maxBarToD>ExtMaxBar) maxBarToD=ExtMaxBar-15;
              }
            else if (maxBarToD==0) maxBarToD=Bars-15;
           }

         if (RangeForPointD>2) RangeForPointD=2;

         ColorSize=0;
         _stringtocolorarray (ExtColorPatternList, ColorList, ColorSize); // ���������� ������ �������� ����� ��� ������� Gartley, �������� �������������
        }

      if (CustomPattern<0) CustomPattern=0;
      if (CustomPattern>2) CustomPattern=2;

      if (SelectPattern==0) ArrayInitialize(CustomPat_,true); // ���

      if (SelectPattern==1) // ������ ������������
        {
         ArrayInitialize(CustomPat_,false);
         CustomPat_[0]=true;
         CustomPat_[1]=true;
         CustomPat_[4]=true;
         CustomPat_[5]=true;
         CustomPat_[16]=true;
         CustomPat_[17]=true;
         CustomPat_[19]=true;
         CustomPat_[20]=true;
         CustomPat_[21]=true;
        }

      if (SelectPattern==2) // ������������ � ����������������
        {
         ArrayInitialize(CustomPat_,false);
         CustomPat_[0]=true;
         CustomPat_[1]=true;
         CustomPat_[4]=true;
         CustomPat_[5]=true;
         CustomPat_[16]=true;
         CustomPat_[17]=true;
         CustomPat_[19]=true;
         CustomPat_[20]=true;
         CustomPat_[21]=true;

         CustomPat_[8]=true;
         CustomPat_[9]=true;
         CustomPat_[12]=true;
         CustomPat_[13]=true;
        }

      if (SelectPattern==3) // ��������
        {
         ArrayInitialize(CustomPat_,false);
         CustomPat_[2]=true;
         CustomPat_[3]=true;
         CustomPat_[6]=true;
         CustomPat_[7]=true;
         CustomPat_[10]=true;
         CustomPat_[11]=true;
         CustomPat_[14]=true;
         CustomPat_[15]=true;
         CustomPat_[18]=true;
        }

      if (SelectPattern==4) // ������ ������������
        {
         ArrayInitialize(CustomPat_,false);
         CustomPat_[2]=true;
         CustomPat_[3]=true;
         CustomPat_[6]=true;
         CustomPat_[7]=true;
         CustomPat_[8]=true;
         CustomPat_[9]=true;
         CustomPat_[12]=true;
         CustomPat_[13]=true;
        }

      if (SelectPattern==5) // ��� ����� TOTAL
        {
         ArrayInitialize(CustomPat_,true);
         CustomPat_[22]=false;
         CustomPat_[23]=false;
         CustomPat_[24]=false;
         CustomPat_[25]=false;
         CustomPat_[26]=false;
        }

      if (SelectPattern==6) // ������ TOTAL
        {
         ArrayInitialize(CustomPat_,false);
         CustomPat_[22]=true;
         CustomPat_[23]=true;
         CustomPat_[24]=true;
         CustomPat_[25]=true;
         CustomPat_[26]=true;
        }

      if (SelectPattern==7) // ������������ ����� ������������ ��������� ��� ������
        {
         j=StringLen(visiblePattern);
         for(i=0;i<j;i++)
           {
            if (StringSubstr(visiblePattern,i,1)=="1") CustomPat_[i]=true; else CustomPat_[i]=false;
           }
        }

      if (ABCD) 
        {
         _stringtodoublearray (ABCDAlternate, _ABCDtype, _ABCDtypetxt, _ABCDsize, false);
        }
     }

// Gartley Patterns
// -------

   if (ExtStyleZZ) {SetIndexStyle(0,DRAW_SECTION);}
   else {SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0,158);}

   if (ExtLabel>0)
     {
      SetIndexStyle(3,DRAW_ARROW); SetIndexArrow(3,ExtCodLabel);
      SetIndexStyle(4,DRAW_ARROW); SetIndexArrow(4,ExtCodLabel);
     }
   else
     {
      SetIndexStyle(3,DRAW_LINE,STYLE_DOT);
      SetIndexStyle(4,DRAW_LINE,STYLE_DOT);
     }

   SetIndexLabel(0,"ZUP"+ExtComplekt+" (zz"+ExtIndicator+")");
   if (ExtIndicator==6)
     {
      if (noBackstep)
        {
         SetIndexLabel(5,"ZUP"+ExtComplekt+" DT6_"+minBars+"/GP="+GrossPeriod+"");
        }
      else
        {
          SetIndexLabel(5,"ZUP"+ExtComplekt+" DT6_"+minBars+"/"+ExtBackstep+"/GP="+GrossPeriod+"");
        }
     }
   else if (ExtIndicator==7) SetIndexLabel(5,"ZUP"+ExtComplekt+" DT7_"+minBars+"/GP="+GrossPeriod+"");
   else if (ExtIndicator==8) SetIndexLabel(5,"ZUP"+ExtComplekt+" DT8_"+minBars+"/"+ExtDeviation+"/GP="+GrossPeriod+"");

   if (ExtLabel>0)
     {
      SetIndexLabel(1,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" H_PeakDet");
      SetIndexLabel(2,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" L_PeakDet");
      SetIndexLabel(3,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" UpTrend");
      SetIndexLabel(4,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" DownTrend");
     }
   else
     {
      if (chHL_PeakDet_or_vts)
        {
         PeakDetIni=true;
         SetIndexLabel(1,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" H_PeakDet");
         SetIndexLabel(2,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" L_PeakDet");
         SetIndexLabel(3,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" H_chHL");
         SetIndexLabel(4,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" L_chHL");
        }
      else
        {
         SetIndexLabel(1,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" H_vts");
         SetIndexLabel(2,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" L_vts");
         SetIndexLabel(3,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" H_vts1");
         SetIndexLabel(4,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" L_vts1");
        }
     }

// ������ ���������� �����
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(2,DRAW_LINE,STYLE_DOT); 
   SetIndexBuffer(1,ham);
   SetIndexBuffer(2,lam);
// ������ �������������
   SetIndexBuffer(3,ha);
   SetIndexBuffer(4,la);

   SetIndexBuffer(0,zz);
   SetIndexBuffer(5,nen_ZigZag);
   SetIndexBuffer(6,zzL);
   SetIndexBuffer(7,zzH);

   SetIndexStyle(5,DRAW_ARROW);
   SetIndexArrow(5,159);

   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
   SetIndexEmptyValue(6,0.0);
   SetIndexEmptyValue(7,0.0);

   if (ExtIndicator<6 || ExtIndicator>10)
     {
      switch (Period())
        {
         case 1     : {Period_tf=TF[8];break;}
         case 5     : {Period_tf=TF[7];break;}
         case 15    : {Period_tf=TF[6];break;}
         case 30    : {Period_tf=TF[5];break;}
         case 60    : {Period_tf=TF[4];break;}
         case 240   : {Period_tf=TF[3];break;}
         case 1440  : {Period_tf=TF[2];break;}
         case 10080 : {Period_tf=TF[1];break;}
         case 43200 : {Period_tf=TF[0];break;}
        }
     }
   else
     {
      switch (GrossPeriod)
        {
         case 1     : {Period_tf=TF[8];break;}
         case 5     : {Period_tf=TF[7];break;}
         case 15    : {Period_tf=TF[6];break;}
         case 30    : {Period_tf=TF[5];break;}
         case 60    : {Period_tf=TF[4];break;}
         case 240   : {Period_tf=TF[3];break;}
         case 1440  : {Period_tf=TF[2];break;}
         case 10080 : {Period_tf=TF[1];break;}
         case 43200 : {Period_tf=TF[0];break;}
        }

      if (GrossPeriod>43200)
        {
         if (MathMod(GrossPeriod,43200)>0) Period_tf=GrossPeriod; else Period_tf=TF[0]+GrossPeriod/43200 + ""; 
        }
      else if (GrossPeriod<43200)
        {
         if (GrossPeriod>10080)
           { 
            if (MathMod(GrossPeriod,10080)>0) Period_tf=GrossPeriod; else Period_tf="W"+GrossPeriod/10080 + ""; 
           }
         else if (GrossPeriod<10080)
           {
            if (GrossPeriod>1440)
              { 
               if (MathMod(GrossPeriod,1440)>0) Period_tf=GrossPeriod; else Period_tf="D"+GrossPeriod/1440 + ""; 
              }
            else if (GrossPeriod<1440)
              {
               if (GrossPeriod!=60)
                 { 
                  if (MathMod(GrossPeriod,60)>0) Period_tf=GrossPeriod; else Period_tf="H"+GrossPeriod/60 + ""; 
                 }
              }
           }
        }
     }
      if (minSize==0 && minPercent!=0) di=minPercent*Close[i]/2/100;

   if (ExtIndicator==1) if (minSize!=0) di=minSize*Point/2;
   if (ExtIndicator==2) {di=minSize*Point; countBar=minBars;}
   if (ExtIndicator==3) {countBar=minBars;}

   if (ExtIndicator>5 && ExtIndicator<11 && GrossPeriod>Period())
     {
      if (GrossPeriod==43200 && Period()==10080) maxBarToD=maxBarToD*5; else maxBarToD=maxBarToD*GrossPeriod/Period();
     }
   
   if (ExtIndicator<6 ||ExtIndicator>10) GrossPeriod=Period();

   if (ExtFiboType<0) ExtFiboType=0;
   if (ExtFiboType>2) ExtFiboType=2;

   if (ExtFiboType==2) // ���������� ������ ���, �������� �������������
     {
      _stringtodoublearray (ExtFiboTypeFree, fi, fitxt, Sizefi, true);
     }
// -------
 
// �������� ������������ ��������� ������� ����������
   if (ExtDelta<=0) ExtDelta=0.001;
   if (ExtDelta>1) ExtDelta=0.999;

   if (ExtHidden<0) ExtHidden=0;
   if (ExtHidden>5) ExtHidden=5;
 
   if (ExtDeltaType<0) ExtDeltaType=0;
   if (ExtDeltaType>3) ExtDeltaType=3;

   if (ExtFiboChoice<0) ExtFiboChoice=0;
   if (ExtFiboChoice>11) ExtFiboChoice=11;

   if (ExtPivotZZ1Num>9) ExtPivotZZ1Num=9;
   if (ExtPivotZZ2Num>9) ExtPivotZZ2Num=9;

   if (ExtPivotZZ1Num==ExtPivotZZ2Num)
     {
      if (ExtPivotZZ1Num>0) ExtPivotZZ1Num=ExtPivotZZ2Num-1;
     }

   if (ExtFractalEnd>0)
     {
      if (ExtFractalEnd<1) ExtFractalEnd=1;
     }

   if (ExtPitchforkStatic>4) ExtPitchforkStatic=4;
   _ExtPitchforkStatic=ExtPitchforkStatic;
   if (ExtPitchforkDinamic>4) ExtPitchforkDinamic=4;
   if (AutoAPDinamicTestRedZone)
     {
      _ExtPitchforkDinamic=ExtPitchforkDinamic;
      ExtPitchforkDinamic=0;
     }

   if (ExtMasterPitchfork<0 || ExtMasterPitchfork>2) ExtMasterPitchfork=0;

   if (ExtCM_0_1A_2B_Dinamic<0) ExtCM_0_1A_2B_Dinamic=0;
   if (ExtCM_0_1A_2B_Dinamic>5) ExtCM_0_1A_2B_Dinamic=5;
   if (ExtCM_0_1A_2B_Static<0) ExtCM_0_1A_2B_Static=0;
   if (ExtCM_0_1A_2B_Static>5) ExtCM_0_1A_2B_Static=5;
   if (ExtCM_FiboDinamic<0) ExtCM_FiboDinamic=0;
   if (ExtCM_FiboDinamic>1) ExtCM_FiboDinamic=1;
   if (ExtCM_FiboStatic<0) ExtCM_FiboStatic=0;
   if (ExtCM_FiboStatic>1) ExtCM_FiboStatic=1;

//--------------------------------------------
   if (ExtPitchforkStaticNum<3) ExtPitchforkStaticNum=3;
   
   if ((ExtPitchforkStatic>0 || ExtPitchforkDinamic>0 || _ExtPitchforkDinamic>0) && mAllLevels && 
   (mPivotPoints || mSSL>0 || m1_2Mediana>0 || mISL382>0 || mMediana>0 || mISL618>0 || mFSL>0 || mCriticalPoints || mSLM>0 || mFSLShiffLines>0 || mUTL || mLTL || mUWL || mLWL ||
    mSSL_d>0 || m1_2Mediana_d>0 || mISL382_d>0 || mMediana_d>0 || mISL618_d>0 || mFSL_d>0 || mCriticalPoints_d || mSLM_d>0 || mFSLShiffLines_d>0 || mAuto_d || mAuto_s)) mAP=true;

   if (mSSL<0) mSSL=0; if (mSSL>9) mSSL=9;
   if (m1_2Mediana<0) m1_2Mediana=0; if (m1_2Mediana>9) m1_2Mediana=9;
   if (mISL382<0) mISL382=0; if (mISL382>9) mISL382=9;
   if (mMediana<0) mMediana=0; if (mMediana>9) mMediana=9;
   if (mISL618<0) mISL618=0; if (mISL618>9) mISL618=9;
   if (mFSL<0) mFSL=0; if (mFSL>9) mFSL=9;
   if (mSLM<0) mSLM=0; if (mSLM>9) mSLM=9;
   if (mFSLShiffLines<0) mFSLShiffLines=0; if (mFSLShiffLines>9) mFSLShiffLines=9;
   if (mUTL<0) mUTL=0; if (mUTL>9) mUTL=9;
   if (mLTL<0) mLTL=0; if (mLTL>9) mLTL=9;
   if (mUWL<0) mUWL=0; if (mUWL>9) mUWL=9;
   if (mLWL<0) mLWL=0; if (mLWL>9) mLWL=9;

   if (mSSL_d<0) mSSL_d=0; if (mSSL_d>9) mSSL_d=9;
   if (m1_2Mediana_d<0) m1_2Mediana_d=0; if (m1_2Mediana_d>9) m1_2Mediana_d=9;
   if (mISL382_d<0) mISL382_d=0; if (mISL382_d>9) mISL382_d=9;
   if (mMediana_d<0) mMediana_d=0; if (mMediana_d>9) mMediana_d=9;
   if (mISL618_d<0) mISL618_d=0; if (mISL618_d>9) mISL618_d=9;
   if (mFSL_d<0) mFSL_d=0; if (mFSL_d>9) mFSL_d=9;
   if (mSLM_d<0) mSLM_d=0; if (mSLM_d>9) mSLM_d=9;
   if (mFSLShiffLines_d<0) mFSLShiffLines_d=0; if (mFSLShiffLines_d>9) mFSLShiffLines_d=9;

   aMetki[0][0]=0;
   aMetki[0][1]=mSSL;
   aMetki[0][2]=mSLM;
   aMetki[0][3]=m1_2Mediana;
   aMetki[0][4]=mSLM;
   aMetki[0][5]=mISL382;
   aMetki[0][6]=mMediana;
   aMetki[0][7]=mISL618;
   aMetki[0][8]=mFSL;
   aMetki[0][9]=mFSLShiffLines;
   aMetki[0][10]=mCriticalPoints;
   aMetki[0][11]=mUTL;
   aMetki[0][12]=mLTL;
   aMetki[0][13]=mUWL;
   aMetki[0][14]=mLWL;

   aMetki[1][0]=0;
   aMetki[1][1]=mSSL_d;
   aMetki[1][2]=mSLM_d;
   aMetki[1][3]=m1_2Mediana_d;
   aMetki[1][4]=mSLM_d;
   aMetki[1][5]=mISL382_d;
   aMetki[1][6]=mMediana_d;
   aMetki[1][7]=mISL618_d;
   aMetki[1][8]=mFSL_d;
   aMetki[1][9]=mFSLShiffLines_d;
   aMetki[1][10]=mCriticalPoints_d;
   aMetki[1][11]=0;
   aMetki[1][12]=0;
   aMetki[1][13]=0;
   aMetki[1][14]=0;

   if (mSelectVariantsPRZ>9) mSelectVariantsPRZ=-1;

   if (ExtFiboStaticNum<2) ExtFiboStaticNum=2;

   if (ExtFiboStaticNum>9)
     {
      aa=DoubleToStr(ExtFiboStaticNum,0);
      aa1=StringSubstr(aa,0,1);
      mFibo[0]=StrToInteger(aa1);
      aa1=StringSubstr(aa,1,1);
      mFibo[1]=StrToInteger(aa1);
     }
   else
     {
      mFibo[0]=ExtFiboStaticNum;
      mFibo[1]=ExtFiboStaticNum-1;
     }

   if (ExtFiboFanNum<1) ExtFiboFanNum=1;

   if (ExtFiboFanNum>9)
     {
      aa=DoubleToStr(ExtFiboFanNum,0);
      aa1=StringSubstr(aa,0,1);
      mFan[0]=StrToInteger(aa1);
      aa1=StringSubstr(aa,1,1);
      mFan[1]=StrToInteger(aa1);
     }
   else
     {
      mFan[0]=ExtFiboFanNum;
      mFan[1]=ExtFiboFanNum-1;
     }

   if (ExtPitchforkStaticNum>99)
     {
      aa=DoubleToStr(ExtPitchforkStaticNum,0);
      aa1=StringSubstr(aa,0,1);
      mPitch[0]=StrToInteger(aa1);
      aa1=StringSubstr(aa,1,1);
      mPitch[1]=StrToInteger(aa1);
      aa1=StringSubstr(aa,2,1);
      mPitch[2]=StrToInteger(aa1);
     }
   else
     {
      mPitch[0]=ExtPitchforkStaticNum;
      mPitch[1]=ExtPitchforkStaticNum-1;
      mPitch[2]=ExtPitchforkStaticNum-2;
     }

   if (ExtFiboExpansion<2) ExtFiboExpansion=0;
   
   if (ExtFiboExpansion>0)
     {
      if (ExtFiboExpansion>99)
        {
         aa=DoubleToStr(ExtFiboExpansion,0);
         aa1=StringSubstr(aa,0,1);
         mExpansion[0]=StrToInteger(aa1);
         aa1=StringSubstr(aa,1,1);
         mExpansion[1]=StrToInteger(aa1);
         aa1=StringSubstr(aa,2,1);
         mExpansion[2]=StrToInteger(aa1);
        }
      else
        {
         mExpansion[0]=ExtFiboExpansion;
         mExpansion[1]=ExtFiboExpansion-1;
         mExpansion[2]=ExtFiboExpansion-2;
        }
     }
   
   if (ExtPitchforkCandle && !ExtCustomStaticAP)
     {
      mPitchTime[0]=ExtDateTimePitchfork_1;
      mPitchTime[1]=ExtDateTimePitchfork_2;
      mPitchTime[2]=ExtDateTimePitchfork_3;

      if (ExtPitchfork_1_HighLow)
        {
         mPitchCena[0]=High[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_1,true)];
         mPitchCena[1]=Low[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_2,true)];
         mPitchCena[2]=High[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3,true)];
        }
      else
        {
         mPitchCena[0]=Low[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_1,true)];
         mPitchCena[1]=High[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_2,true)];
         mPitchCena[2]=Low[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3,true)];
        }

      if (mPitchCena[0]<=0 || mPitchCena[1]<=0 || mPitchCena[2]<=0) {ExtPitchforkCandle=false; ExtPitchforkStatic=0;}
     }

   if (ExtFiboTimeNum<=2) ExtFiboTimeNum=0;
   if (ExtFiboTimeNum>999) ExtFiboTimeNum=0;

   if (ExtVLStaticNum>0)
     {
      if (ExtVLStaticNum<2) ExtVLStaticNum=2;

      if (ExtVLStaticNum>99)
        {
         aa=DoubleToStr(ExtVLStaticNum,0);
         aa1=StringSubstr(aa,0,1);
         mVL[0]=StrToInteger(aa1);
         aa1=StringSubstr(aa,1,1);
         mVL[1]=StrToInteger(aa1);
         aa1=StringSubstr(aa,2,1);
         mVL[2]=StrToInteger(aa1);
        }
      else
        {
         mVL[0]=ExtVLStaticNum;
         mVL[1]=ExtVLStaticNum-1;
         mVL[2]=ExtVLStaticNum-2;
        }
     }

   if (ExtArcStaticNum>0)
     {
      if (ExtArcStaticNum<2) ExtArcStaticNum=2;
      if (ExtArcStaticNum<12 && ExtArcStaticNum>9) ExtArcStaticNum=9;
      if (ExtArcStaticNum>98) ExtArcStaticNum=98;

      if (ExtArcStaticNum>=12)
        {
         aa=DoubleToStr(ExtArcStaticNum,0);
         aa1=StringSubstr(aa,1,1);
         mArcS[0]=StrToInteger(aa1);
         aa1=StringSubstr(aa,0,1);
         mArcS[1]=StrToInteger(aa1);
         if (mArcS[0]==0) {ExtArcStaticNum=0; mArcS[1]=0;}
        }
      else
        {
         mArcS[1]=ExtArcStaticNum;
         mArcS[0]=ExtArcStaticNum-1;
        }
     }

   if (ExtArcDinamicNum>0)
     {
      if (ExtArcDinamicNum>90) ExtArcStaticNum=90;

      if (ExtArcDinamicNum>9)
        {
         aa=DoubleToStr(ExtArcDinamicNum,0);
         aa1=StringSubstr(aa,1,1);
         mArcD[0]=StrToInteger(aa1);
         aa1=StringSubstr(aa,0,1);
         mArcD[1]=StrToInteger(aa1);
         if (mArcD[0]>0) mArcD[0]=0;
        }
      else
        {
         mArcD[1]=0;
         mArcD[0]=ExtArcDinamicNum;
        }
     }

   // ������� �������
   if (ExtSpiralNum>0)
     {
      if(goldenSpiralCycle <= 0) goldenSpiralCycle = 1;
      if(accurity <= 0) accurity = 0.2;
      if (ExtSpiralNum<2) ExtSpiralNum=2;
      if (ExtSpiralNum>98) ExtSpiralNum=98;

      if (ExtSpiralNum>9)
        {
         aa=DoubleToStr(ExtSpiralNum,0);
         aa1=StringSubstr(aa,1,1);
         mSpiral[0]=StrToInteger(aa1);
         aa1=StringSubstr(aa,0,1);
         mSpiral[1]=StrToInteger(aa1);
         if (mSpiral[0]==0) {ExtSpiralNum=0; mSpiral[1]=0;}
        }
      else
        {
         mSpiral[1]=ExtSpiralNum;
         mSpiral[0]=ExtSpiralNum-1;
        }

     }

   // ������
   if (ExtChannelsNum>9876543210) ExtChannelsNum=0;

   if (ExtChannelsNum>0)
     {
      aa=DoubleToStr(ExtChannelsNum,0);
      aa2=StringLen(aa);
   
      for (i=0;i<aa2;i++)
        {
         mChannels[i]=StrToInteger(StringSubstr(aa,i,1));
        }

      if (aa2==1) {mChannels[aa2]=mChannels[0]-1; aa2++;}

      ArraySort(mChannels,WHOLE_ARRAY,0,MODE_DESCEND);
      for (i=1;i<=9;i++)
        {
         if ((mChannels[i]==mChannels[i-1]) && mChannels[i]>=0) {mChannels[i]=-1; ArraySort(mChannels,WHOLE_ARRAY,0,MODE_DESCEND); i--;}
        }

      for (i=1;i<=9;i++)
        {
         if (mChannels[i]==0) {DinamicChannels=i; break;}
        }
     }


   if (ExtSave)
     {
      MathSrand(LocalTime());
      save=MathRand();
     }

   if (ExtCM_0_1A_2B_Static==4 || ExtCM_0_1A_2B_Dinamic==4)
     {
      for (i=Bars-1; i>-1; i--)
        {
         ASBar=ASBar + iHigh(NULL,GrossPeriod,i) - iLow(NULL,GrossPeriod,i) + Point;
        }
      ASBar=ASBar/Bars;
     }
   
   array_();
   perTF=Period();
   Demo=IsDemo();
   delete_objects1();
   if (!ExtCustomStaticAP || ExtPitchforkStatic==0)
     {
      ObjectDelete("pitchforkS" + ExtComplekt+"_APm_");
      delete_objects8();
      ExtCustomStaticAP=false;
     }

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      // ������������� ������ ������� �� ������� ����� � ����� �������
      if (!mAPs)
        {
         if (StringFind(txt,"m#"+ExtComplekt+"_"+"s")>-1) mAPs=true;
        }

      if (!mAPd)
        {
         if (StringFind(txt,"m#"+ExtComplekt+"_"+"d")>-1) mAPd=true;
        }

      // ������� ����������� ��� � ������ APm
      if (ObjectType(txt)==OBJ_PITCHFORK)
        {
         if (StringFind(txt,"_APm",0)>0) i_APm++;
        }
     }

   ObjectDelete(nameCheckLabel_hidden);
   if (i_APm>1)
     {
      if (ObjectFind(nameCheckLabel)==0)
        {
         // �������� ��������� ���������� ����� APm
         if (ObjectGet(nameCheckLabel,OBJPROP_XDISTANCE)!=vX || ObjectGet(nameCheckLabel,OBJPROP_YDISTANCE)!=vY)
           {
            count_APm=(i_APm-1)*2;
           }
         else
           {
            count_APm=i_APm;
           }

         ObjectCreate(nameCheckLabel_hidden,OBJ_TEXT,0,0,0);

         ObjectSetText(nameCheckLabel_hidden,""+i_APm+"_"+count_APm);
         ObjectSet(nameCheckLabel_hidden, OBJPROP_COLOR, CLR_NONE);
         ObjectSet(nameCheckLabel_hidden, OBJPROP_BACK, true);
        }
     }

   nameMagnet[0]="AM_0_"+ExtComplekt;
   nameMagnet[1]="AM_1_"+ExtComplekt;
   nameMagnet[2]="AM_2_"+ExtComplekt;

   if (!ExtCustomStaticAP || !AutoMagnet)
     {
      if (ObjectFind(nameMagnet[0])==0)
        {
         ObjectDelete(nameMagnet[0]);
         ObjectDelete(nameMagnet[1]);
         ObjectDelete(nameMagnet[2]);
        }
     }

   // �������� ��������� ����� ��� AutoMagnet
   if (ExtCustomStaticAP && AutoMagnet)
     {
      txt=StringSubstr("0000"+Period(),StringLen("0000"+Period())-5,5)+"00000000000";
      if (!ObjectFind(nameMagnet[0])==0)
        {
         ObjectCreate(nameMagnet[0],OBJ_TEXT,0,0,0);
         ObjectSet(nameMagnet[0], OBJPROP_COLOR, CLR_NONE);
         ObjectSetText(nameMagnet[0],txt);

         ObjectCreate(nameMagnet[1],OBJ_TEXT,0,0,0);
         ObjectSet(nameMagnet[1], OBJPROP_COLOR, CLR_NONE);
         ObjectSetText(nameMagnet[1],txt);

         ObjectCreate(nameMagnet[2],OBJ_TEXT,0,0,0);
         ObjectSet(nameMagnet[2], OBJPROP_COLOR, CLR_NONE);
         ObjectSetText(nameMagnet[2],txt);

         period_AM[0]=Period();
         period_AM[1]=Period();
         period_AM[2]=Period();
        }
      else
        {
         period_AM[0]=StrToInteger(StringSubstr(ObjectDescription(nameMagnet[0]),0,5));
         period_AM[1]=StrToInteger(StringSubstr(ObjectDescription(nameMagnet[1]),0,5));
         period_AM[2]=StrToInteger(StringSubstr(ObjectDescription(nameMagnet[2]),0,5));
        }
     }
    
   mPeriod=0; // 
   mStart=true;
   tik1 = true;
   
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function. �����.                 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| ���������������. �������� ���� ��������� ����� � ��������� ��������. ������.
//+------------------------------------------------------------------+
int deinit()
  {
   int i;

   ObjectDelete("fiboS" + ExtComplekt+"_");

   ObjectDelete("fiboFanS" + ExtComplekt+"_");
   ObjectDelete("RLineS" + ExtComplekt+"_");
   if (!ExtCustomStaticAP)
     {
      ObjectDelete("pitchforkS" + ExtComplekt+"_APm_");
      ObjectDelete("Master_pitchforkS" + ExtComplekt+"_APm_");
     }

   ObjectDelete("pitchforkS" + ExtComplekt+"_");
   ObjectDelete("Master_pitchforkS" + ExtComplekt+"_");
   ObjectDelete("pmedianaS" + ExtComplekt+"_");
   ObjectDelete("1-2pmedianaS" + ExtComplekt+"_");
   ObjectDelete("SLM382S" + ExtComplekt+"_");
   ObjectDelete("SLM618S" + ExtComplekt+"_");
   ObjectDelete("FSL Shiff Lines S" + ExtComplekt+"_");
   ObjectDelete("fiboTime1" + ExtComplekt+"_");ObjectDelete("fiboTime2" + ExtComplekt+"_");ObjectDelete("fiboTime3" + ExtComplekt+"_");
   ObjectDelete("fiboTime1Free" + ExtComplekt+"_");ObjectDelete("fiboTime2Free" + ExtComplekt+"_");ObjectDelete("fiboTime3Free" + ExtComplekt+"_");
   ObjectDelete(nameUTL);ObjectDelete(nameLTL);
   ObjectDelete(nameUWL);ObjectDelete(nameLWL);
   ObjectDelete(nameUTLd);ObjectDelete(nameLTLd);
   ObjectDelete(nameUWLd);ObjectDelete(nameLWLd);
   ObjectDelete("ISL_S" + ExtComplekt+"_");
   ObjectDelete("RZS" + ExtComplekt+"_");
   ObjectDelete("CL" + ExtComplekt+"_");
   ObjectDelete("CISL" + ExtComplekt+"_"+0);
   ObjectDelete("CISL" + ExtComplekt+"_"+1);
   ObjectDelete("PivotZoneS" + ExtComplekt+"_");
   ObjectDelete("FanMedianaStatic" + ExtComplekt+"_");

   ObjectDelete("FiboFan" + ExtComplekt+"_");
   ObjectDelete("FiboArcS" + ExtComplekt+"_");
   ObjectDelete("LinePivotZZ" + "1" + ExtComplekt+"_");
   ObjectDelete("LinePivotZZ" + "2" + ExtComplekt+"_");
   ObjectDelete("#_TextPattern_#" + ExtComplekt+"_");
   ObjectDelete("#_TextPatternMP_#" + ExtComplekt+"_");

   for (i=0;i<9; i++)
     {
      nameObj="LCChannel" + i + ExtComplekt+"_";
      ObjectDelete(nameObj);
      nameObj="LTChannel" + i + ExtComplekt+"_";
      ObjectDelete(nameObj);
     }
   
   for (i=0; i<7; i++)
     {
      nameObj="VLS"+i+" " + ExtComplekt+"_";
      ObjectDelete(nameObj);
     }

   // ��������� ������� ���������� ����� ��� �������� ��������
   delete_objects_dinamic();
   delete_objects1();
   delete_objects3();
   delete_objects4();
   delete_objects5();
   delete_objects6(0);
   delete_objects6(1);
   delete_objects_spiral();
   delete_objects_number();
   delete_objects8();
   delete_objects9();
   ObjectDelete(cursor);

   if (infoTF) Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//| ���������������. �������� ���� ��������� ����� � ��������� ��������. ������.
//+------------------------------------------------------------------+

// ������
int start()
  {
   int i, j, k; // ��� ������� ������� ����

   if (ExtCustomStaticAP && tik2)
     {
      screenPitchforkS();
     }
   tik2 = true;

   if ((ExtIndicator==6 || ExtIndicator==7 || ExtIndicator==8 || ExtIndicator==10) && Period()>GrossPeriod) 
     {
      ArrayInitialize(zz,0);ArrayInitialize(zzL,0);ArrayInitialize(zzH,0);ArrayInitialize(nen_ZigZag,0);
      init_zz=true;
      return;
     }

   counted_bars=IndicatorCounted();
  
   if (perTF!=Period())
     {
      delete_objects1();  
      perTF=Period();
     }

   if (Demo!=IsDemo())
     {
      delete_objects1();  
      Demo=IsDemo();
      counted_bars=0;
     }

//-----------------------------------------
//
//     1.
//
// ���� ���������� �������. ������. 
//-----------------------------------------   
// zz[] - �����, ������ �� �������� ������� ��� ��������� ������ ZigZag-a
// zzL[] - ������ ��������� ��������
// zzH[] - ������ ���������� ��������
//
//-----------------------------------------   

   if (Bars-IndicatorCounted()>2)
     {
      if (ExtMaxBar>0) cbi=ExtMaxBar; else cbi=Bars-1;
      lLast=0; hLast=0;
      ti=0; ai=0; bi=0; tai=0; tbi=0; fs=0; si=0; sip=0; 
      lBar=iLow(NULL,GrossPeriod,0); hBar=iHigh(NULL,GrossPeriod,0); tiZZ=iTime(NULL,GrossPeriod,0);
      fh=false; fl=false;
      ArrayInitialize(zz,0);ArrayInitialize(zzL,0);ArrayInitialize(zzH,0);ArrayInitialize(nen_ZigZag,0);
      init_zz=true; afrm=true; delete_objects_dinamic(); delete_objects1(); delete_objects3();
      flagExtGartleyTypeSearch2=false; vPatOnOff=false;
      ArrayInitialize(aOutRedZone,false);
      mStart=true;
      if (chHL_PeakDet_or_vts) PeakDetIni=true;
      if (CursorLine)
        {
         ObjectDelete(cursor);
         ObjectCreate(cursor, OBJ_VLINE, 0, TimeCurrent(), 0);
         ObjectSet(cursor, OBJPROP_BACK,  CLBack);
         ObjectSet(cursor, OBJPROP_COLOR, CLColor);
         ObjectSet(cursor, OBJPROP_STYLE, CLStyle);
         ObjectSet(cursor, OBJPROP_WIDTH, CLWidth);
        }
     }
   else
     {
      if (ExtIndicator==1) cbi=Bars-IndicatorCounted()-1;
      else cbi=Bars-IndicatorCounted();

      if (ExtMinBar>0)
        {
         if ((ExtIndicator==0||ExtIndicator==1||ExtIndicator==2||ExtIndicator==3||ExtIndicator==5||ExtIndicator==6||ExtIndicator==7||ExtIndicator==8||ExtIndicator==10||ExtIndicator==11) && tiZZ==iTime(NULL,GrossPeriod,0))
         return (0);
        }

      if (lBar<=iLow(NULL,GrossPeriod,0) && hBar>=iHigh(NULL,GrossPeriod,0) && tiZZ==iTime(NULL,GrossPeriod,0)) return(0);
      else
        {
         if (tiZZ<iTime(NULL,GrossPeriod,0)) 
           {
            if (CursorLine)
              {
               ObjectDelete(cursor);
               ObjectCreate(cursor, OBJ_VLINE, 0, TimeCurrent(), 0);
               ObjectSet(cursor, OBJPROP_BACK,  CLBack);
               ObjectSet(cursor, OBJPROP_COLOR, CLColor);
               ObjectSet(cursor, OBJPROP_STYLE, CLStyle);
               ObjectSet(cursor, OBJPROP_WIDTH, CLWidth);
              }

            if (iBarShift(Symbol(),Period(),afr[0])==2 && ExtHidden<5)
              {
               if (ExtPivotZZ1Num==1 && ExtPivotZZ1Color>0) PivotZZ(ExtPivotZZ1Color, ExtPivotZZ1Num, 1);
               if (ExtPivotZZ2Num==1 && ExtPivotZZ2Color>0) PivotZZ(ExtPivotZZ2Color, ExtPivotZZ2Num, 2);
              }
           }
         lBar=iLow(NULL,GrossPeriod,0); hBar=iHigh(NULL,GrossPeriod,0); tiZZ=iTime(NULL,GrossPeriod,0);
        }

      if (mOutRedZone && mAuto_d && ExtPitchforkDinamic>0)
        {
         aOutRedZone[0]=false;
         _RZ("RZD", ExtRZDinamicValue, ExtRZDinamicColor, pitch_timeD, pitch_cenaD, ExtRedZoneDinamic, 1, false);
        }

      if (_ExtPitchforkStatic>0)
        {
         if (mOutRedZone && mAuto_s)
           {
            if (!aOutRedZone[1]) _RZ("RZS", ExtRZStaticValue, ExtRZStaticColor, pitch_timeS, pitch_cenaS, ExtRedZoneStatic, 0, false);
           }

         if (AutoTestRedZone && ExtDinamic && !ExtCustomStaticAP && !ExtPitchforkCandle)
           {
            if (StringSubstr(ExtVisibleDinamic,2,1)=="1")
              {
               aOutRedZone[2]=false;
               _RZ("RZ_", ExtRZStaticValue, ExtRZStaticColor, pitch_timeRZ, pitch_cenaRZ, ExtRedZoneStatic, 0, false);
              }
           }
        }
     }

   switch (ExtIndicator)
     {
      case 0  : {ZigZag_();        break;}
      case 1  : {ang_AZZ_();       break;}
      case 2  : {Ensign_ZZ();      break;}
      case 3  : {Ensign_ZZ();      break;}
      case 4  : {ZigZag_tauber();  break;}
      case 5  : {GannSwing();      break;}
      case 6  : {nenZigZag();      break;} // DT-ZigZag - � ������������, ���������������� �������� ZigZag_nen.mq4
      case 7  : {nenZigZag();      break;} // DT-ZigZag - ������� �������, ������� ������� ����������� klot - DT_ZZ.mq4
      case 8  : {nenZigZag();      break;} // DT-ZigZag - ������� �������, ������� ������� ����������� Candid - CZigZag.mq4
      case 10 : {nenZigZag();      break;} // DT-ZigZag - ������� ������� ExtIndicator=5 � ������ DT - ������� ������ Swing_zz.mq4
// ����� ���������
      case 11 : 
       {
        if (ExtGartleyTypeSearch<2) vPatOnOff = false;
        if (ExtGartleyTypeSearch!=2) countGartley = 0;
        countColor   = 0;
        if (!flagExtGartleyTypeSearch2) {delete_objects3(); vPatOnOff = false; if (ExtHiddenPP==2) delete_objects4();}

        switch (AlgorithmSearchPatterns)
          {
           case 0  : {ZigZag_();       break;}
           case 1  : {ang_AZZ_();      break;}
           case 2  : {ang_AZZ_();      break;}
           case 3  : {Ensign_ZZ();     break;}
           case 4  : {ZigZag_tauber(); break;}
           case 5  : {GannSwing();     break;}
           case 6  : {ZZTalex();       break;}
          }
 
        if (ExtGartleyTypeSearch==2 && vPatOnOff) flagExtGartleyTypeSearch2=true;

        if (vPatOnOff && !vPatNew)
          {
           vPatNew=true; flagGartley=true;
           if(ExtPlayAlert) 
           {
            Alert (Symbol(),"  ",Period(),"  appeared new pattern");
            PlaySound("alert.wav");
           }
           if (ExtSendMail){
               // _SendMail("There was a pattern","on  " + Symbol() + " " + Period() + " pattern " + vBullBear + " " + vNamePattern);
               //GlobalVariableSet(StringConcatenate("PatternID_135",Symbol(),Period()),getPattern(vNamePattern));
               }
          }
        else if (!vPatOnOff && vPatNew)
          {
           vPatNew=false; flagGartley=true;
          }

        if (minBarsSave!=minBarsX)
          {
           afrm=true; delete_objects_dinamic(); delete_objects1(); counted_bars=0; minBarsSave=minBarsX; PeakDetIni=true;
          }
        break;
       } 

      case 12 : {ZZTalex();        break;}
      case 13 : {ZigZag_SQZZ();    break;}  // ZigZag ����������     
      case 14 : {ZZ_2L_nen();      break;}  // ZigZag wellx     
     }

   if (ExtHidden<5) // ���������� �� ����� ��������. ������.
     {
      if(!chHL_PeakDet_or_vts)
        {
         if (ExtLabel==0) {i_vts(); i_vts1();}
        }
      else if (PeakDetIni && PeakDet)
        {
         PeakDetIni=false;
         double kl=0,kh=0;  // kl - min; kh - max

         for (shift=Bars; shift>0; shift--)
           {
            if (zzH[shift]>0) {kh=zzH[shift];}
            if (zzL[shift]>0) {kl=zzL[shift];}

            lam[shift]=kl;
            ham[shift]=kh;
           }
        }

      // ������������� �������
      matriza();
      if (infoTF) if (close_TF!=Close[0]) info_TF();
     }

//-----------------------------------------
// ���� ���������� �������. �����.
//-----------------------------------------   

   if (ExtHidden<5) // ���������� �� ����� ��������. ������.
     {
//======================
//======================
//======================

//-----------------------------------------
//
//     2.
//
// ���� ���������� ������. ������.
//-----------------------------------------   

      if (Bars - counted_bars>2 || flagFrNew)
        {

      // ����� ������� � ������ ����, �� �������� ����� ���������� �������������� ����� 
         if (countBarEnd==0)
           {
            if (ExtFractalEnd>0)
              {
               k=ExtFractalEnd;
               for (shift=0; shift<Bars && k>0; shift++) 
                 { 
                  if (zz[shift]>0 && zzH[shift]>0) {countBarEnd=shift; TimeBarEnd=Time[shift]; k--;}
                 }
              }
            else 
              {
               countBarEnd=Bars-3;
               TimeBarEnd=Time[Bars-3];
              }
           }
         else
           {
            countBarEnd=iBarShift(Symbol(),Period(),TimeBarEnd); 
           }

        }
//-----------------------------------------
// ���� ���������� ������. �����.
//-----------------------------------------   

//-----------------------------------------
//
//     3.
//
// ���� �������� � �������� �����, 
// ���������� ������������. ������.
//-----------------------------------------   
// ��������� ����������� ����� � �����. ������.

      if (Bars - counted_bars<3 || tik1)
        {
         tik1 = false;
         timeFr1new=0; timeFr2new=0; timeFr3new=0;

         // ����� ������� ���� ������� ����������, ������ �� �������� ����
         for (shift1=0; shift1<Bars; shift1++) 
           {
            if (zz[shift1]>0.0 && (zzH[shift1]==zz[shift1] || zzL[shift1]==zz[shift1])) 
              {
               timeFr1new=Time[shift1];

               if (_ExtPitchforkDinamic>0 && AutoAPDinamicTestRedZone)
                 {
                  pitch_timeD[2]=Time[shift1];
                  if (zzH[shift1]>0) pitch_cenaD[2]=High[shift1]; else pitch_cenaD[2]=Low[shift1];

                  if (pitch_timeD[0]==0)
                    {
                     j=0;
                     pitch_timeD[1]=0;
                     pitch_timeD[2]=0;
                     for (i=0;i<Bars;i++)
                       {
                        if (zzH[i]>0 || zzL[i]>0)
                          {
                           if (pitch_timeD[2]==0)
                             {
                              j=i;
                              pitch_timeD[2]=Time[j];
                              if (zzH[j]>0) pitch_cenaD[2]=zzH[j]; else pitch_cenaD[2]=zzL[j];
                             }
                           else if (pitch_timeD[1]==0)
                             {
                              pitch_timeD[1]=Time[i];
                              if (zzH[j]>0) pitch_cenaD[1]=zzL[i]; else pitch_cenaD[1]=zzH[i];
                             }
                           else if (pitch_timeD[0]==0)
                             {
                              pitch_timeD[0]=Time[i];
                              if (zzH[j]>0) pitch_cenaD[0]=zzH[i]; else pitch_cenaD[0]=zzL[i];

                              aOutRedZone[0]=false;
                              _RZ("RZD", ExtRZDinamicValue, ExtRZDinamicColor, pitch_timeD, pitch_cenaD, ExtRedZoneDinamic, 1, false);
                              if (aOutRedZone[0])
                                {
                                 ExtPitchforkDinamic=_ExtPitchforkDinamic;
                                 screenPitchforkD();
                                }
                              else
                                {
                                 ExtPitchforkDinamic=0;
                                 delete_objects10();
                                }

                              break;
                             }
                          }
                       }
                    }
                  else
                    {
                     aOutRedZone[0]=false;
                     _RZ("RZD", ExtRZDinamicValue, ExtRZDinamicColor, pitch_timeD, pitch_cenaD, ExtRedZoneDinamic, 1, false);
                     if (aOutRedZone[0])
                       {
                        ExtPitchforkDinamic=_ExtPitchforkDinamic;
                        screenPitchforkD();
                       }
                     else
                       {
                        ExtPitchforkDinamic=0;
                        delete_objects10();
                       }
                    }
                 }

               break;
              }
           }

         // ����� ������� ���� ������� ����������, ������ �� �������� ����
         for (shift2=shift1+1; shift2<Bars; shift2++) 
           {
            if (zz[shift2]>0.0 && (zzH[shift2]==zz[shift2] || zzL[shift2]==zz[shift2])) 
              {
               timeFr2new=Time[shift2];
               break;
              }
           }

         // ����� ������� ���� �������� ����������, ������ �� �������� ����
         for (shift3=shift2+1; shift3<Bars; shift3++) 
           {
            if (zz[shift3]>0.0 && (zzH[shift3]==zz[shift3] || zzL[shift3]==zz[shift3])) 
              {
               timeFr3new=Time[shift3];
               break;
              }
           }
 
         // �������� ����� ��� ZigZag
         //if ((zzH[shift1]>0 && afrl[0]>0) || (zzL[shift1]>0 && afrh[0]>0) || 
         if (timeFr2new!=afr[1] || (timeFr3new!=afr[2] && timeFr2new==afr[1]) || timeFr2new<afr[2])
           {
            newRay=true;
            if (!ExtDinamic)
              {
               if (!(RefreshStaticNewRayZZ && timeFr2new<afr[2]))
                 {
                  ExtNumberPeak=false;
                  ExtFiboStatic=false;
                  ExtPitchforkStatic=0;
                  ExtFiboFanNum=0;
                  ExtFiboExpansion=0;
                  ExtVLStaticNum=0;
                  ExtArcStaticNum=0;
                  ExtSpiralNum=0;
                  ExtPivotZZ2Num=0;
                  ExtChannelsNum=0;
                  ExtFiboTimeNum=0;
                 }
              }
            else
              {
               if (StringSubstr(ExtVisibleDinamic,0,1)!="1")  ExtNumberPeak=false;
               if (StringSubstr(ExtVisibleDinamic,1,1)!="1")  ExtFiboStatic=false;
               if (StringSubstr(ExtVisibleDinamic,2,1)=="1")
                 {
                  if (_ExtPitchforkStatic>0)
                    {
                     if (AutoTestRedZone && !ExtCustomStaticAP && !ExtPitchforkCandle)
                       {
                        j=0; k=0;
                        pitch_timeRZ[0]=0;
                        pitch_timeRZ[1]=0;
                        pitch_timeRZ[2]=0;
                        for (i=0;i<Bars;i++)
                          {
                           if (zzH[i]>0 || zzL[i]>0)
                             {
                              if (k==mPitch[2] || k==mPitch[1] || k==mPitch[0])
                                {
                                 if (pitch_timeRZ[2]==0)
                                   {
                                    j=i;
                                    pitch_timeRZ[2]=Time[j];
                                    if (zzH[j]>0) pitch_cenaRZ[2]=zzH[j]; else pitch_cenaRZ[2]=zzL[j];
                                   }
                                 else if (pitch_timeRZ[1]==0)
                                   {
                                    pitch_timeRZ[1]=Time[i];
                                    if (zzH[j]>0) pitch_cenaRZ[1]=zzL[i]; else pitch_cenaRZ[1]=zzH[i];
                                   }
                                 else if (pitch_timeRZ[0]==0)
                                   {
                                    pitch_timeRZ[0]=Time[i];
                                    if (zzH[j]>0) pitch_cenaRZ[0]=zzH[i]; else pitch_cenaRZ[0]=zzL[i];
                                    break;
                                   }
                                }
                              k++;
                             }
                          }

                        aOutRedZone[2]=false;
                        if (pitch_timeRZ[0]>0)
                          {
                           _RZ("RZ_", ExtRZStaticValue, ExtRZStaticColor, pitch_timeRZ, pitch_cenaRZ, ExtRedZoneStatic, 0, false);
                          }

                        if (aOutRedZone[2])
                          {
                           ExtPitchforkStatic=_ExtPitchforkStatic;
                          }
                        else ExtPitchforkStatic=0;
                        aOutRedZone[2]=false;
                       }
                    }
                 }
               else ExtPitchforkStatic=0;
               if (StringSubstr(ExtVisibleDinamic,3,1)!="1")  ExtFiboFanNum=0;
               if (StringSubstr(ExtVisibleDinamic,4,1)!="1")  ExtFiboExpansion=0;
               if (StringSubstr(ExtVisibleDinamic,5,1)!="1")  ExtVLStaticNum=0;
               if (StringSubstr(ExtVisibleDinamic,6,1)!="1")  ExtArcStaticNum=0;
               if (StringSubstr(ExtVisibleDinamic,7,1)!="1")  ExtSpiralNum=0;
               if (StringSubstr(ExtVisibleDinamic,8,1)!="1")  ExtPivotZZ2Num=0;
               if (StringSubstr(ExtVisibleDinamic,9,1)!="1")  ExtChannelsNum=0;
               if (StringSubstr(ExtVisibleDinamic,10,1)!="1") ExtFiboTimeNum=0;
              }

            if (_ExtPitchforkDinamic>0 && AutoAPDinamicTestRedZone)
              {
               j=0;
               pitch_timeD[0]=0;
               pitch_timeD[1]=0;
               pitch_timeD[2]=0;
               for (i=0;i<Bars;i++)
                 {
                  if (zzH[i]>0 || zzL[i]>0)
                    {
                     if (pitch_timeD[2]==0)
                       {
                        j=i;
                        pitch_timeD[2]=Time[j];
                        if (zzH[j]>0) pitch_cenaD[2]=zzH[j]; else pitch_cenaD[2]=zzL[j];
                       }
                     else if (pitch_timeD[1]==0)
                       {
                        pitch_timeD[1]=Time[i];
                        if (zzH[j]>0) pitch_cenaD[1]=zzL[i]; else pitch_cenaD[1]=zzH[i];
                       }
                     else if (pitch_timeD[0]==0)
                       {
                        pitch_timeD[0]=Time[i];
                        if (zzH[j]>0) pitch_cenaD[0]=zzH[i]; else pitch_cenaD[0]=zzL[i];
                        break;
                       }
                    }
                 }

               aOutRedZone[0]=false;
               _RZ("RZD", ExtRZDinamicValue, ExtRZDinamicColor, pitch_timeD, pitch_cenaD, ExtRedZoneDinamic, 1, false);
               if (aOutRedZone[0])
                 {
                  ExtPitchforkDinamic=_ExtPitchforkDinamic;
                  screenPitchforkD();
                 }
               else
                 {
                  ExtPitchforkDinamic=0;
                  delete_objects10();
                 }
              }
      
            if (ExtAlert)
              {
               Alert (Symbol(),"  ",Period(),"  appeared new ray ZigZag");
               PlaySound("alert.wav");
              }
            afrm=true;
           }

         // ����� ����, �� ������� ������ ��������� ��� �����.
         shift=iBarShift(Symbol(),Period(),afr[0]); 

         // ��������� �������� �������� ���������� � ���, ������� ��� �����

         // ����������� ����� ���������
         if (timeFr1new!=afr[0])
           {
            flagFrNew=true;
            if (shift>=shift1) numBar=shift; else  numBar=shift1;
            afrm=true;
           }

         // ��������� �� ��������� ��������� �� ������ ���
         if (afrh[0]>0 && zz[shift]==0.0)
           {
            flagFrNew=true;
            if (numBar<shift) numBar=shift;
            afrm=true;
           }
         // ��������� �� �������� ��������� �� ������ ���
         if (afrl[0]>0 && zz[shift]==0.0)
           {
            flagFrNew=true;
            if (numBar<shift) numBar=shift;
            afrm=true;
           }

//-----------3 ��������� �������� ��� �������, �� ������� �� ��� �� ����. ������.

//============= 1 ��������� ��������. ������.
         if (afrh[0]-High[shift]!=0 && afrh[0]>0)
           {
            flagFrNew=true;
            numBar=0;
            delete_objects2(afr[0]);
            afrx[0]=High[shift];
            afrh[0]=High[shift];
            if (ExtFiboFanDinamic) screenFiboFanD();
            if (mFibo[1]==0 && ExtFiboStatic) screenFiboS();
            if (ExtFiboDinamic) screenFiboD();
            if (ExtPitchforkDinamic>0) screenPitchforkD();
            if (ExtVLDinamicColor>0) VLD();
            if (mVL[2]==0 && ExtVLStaticNum>0) VLS();
            if (ExtFiboTimeNum>2) fiboTimeX ();
            if (ExtPitchforkStatic>0)
              {
               if (ExtCustomStaticAP)
                 {
                  screenPitchforkS();
                 }
               else
                 {
                  if (ExtPitchforkCandle)
                   {
                     if (iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)==0) screenPitchforkS();
                    }
                  else
                    {
                     if (mPitch[2]==0) screenPitchforkS();
                    }
                 }
              }
            if (mExpansion[2]==0 && ExtFiboExpansion>0) FiboExpansion();
            if (mFan[1]==0 && ExtFiboFanNum>0 && ExtFiboFanColor>0) screenFiboFan();
            if (ExtArcDinamicNum>0) screenFiboArcD();
            if (ExtArcStaticNum>0) screenFiboArcS();

            // ����� ��������� Gartley
            search_Gartley();
           }
//============= 1 ��������� ��������. �����.
//
//============= 1 ��������� �������. ������.
         if (afrl[0]-Low[shift]!=0 && afrl[0]>0)
           {
            flagFrNew=true;
            numBar=0;
            delete_objects2(afr[0]);
            afrx[0]=Low[shift];
            afrl[0]=Low[shift];
            if (mFibo[1]==0 && ExtFiboStatic) screenFiboS();
            if (ExtFiboDinamic) screenFiboD();
            if (ExtPitchforkDinamic>0) screenPitchforkD();
            if (ExtFiboFanDinamic) screenFiboFanD();
            if (ExtVLDinamicColor>0) VLD();
            if (mVL[2]==0 && ExtVLStaticNum>0) VLS();
            if (ExtFiboTimeNum>2) fiboTimeX ();
            if (ExtPitchforkStatic>0)
              {
               if (ExtCustomStaticAP)
                 {
                  screenPitchforkS();
                 }
               else
                 {
                  if (ExtPitchforkCandle)
                    {
                     if (iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)==0) screenPitchforkS();
                    }
                  else
                    {
                     if (mPitch[2]==0) screenPitchforkS();
                    }
                 }
              }
            if (mExpansion[2]==0 && ExtFiboExpansion>0) FiboExpansion();
            if (mFan[1]==0 && ExtFiboFanNum>0 && ExtFiboFanColor>0) screenFiboFan();
            if (ExtArcDinamicNum>0) screenFiboArcD();
            if (ExtArcStaticNum>0) screenFiboArcS();

            // ����� ��������� Gartley
            search_Gartley();
           }
//============= 1 ��������� �������. �����.
//-----------3 ��������� �������� ��� �������, �� ������� �� ��� �� ����. �����.

        // ����� ����������� ��������� � �������� �����, ��������� �� ���� ���������. ������.
        countBarEnd=iBarShift(Symbol(),Period(),TimeBarEnd);
        for (k=0; k<5; k++)
          {

           // �������� ����������.
           if (afrh[k]>0)
             {
              // ����� ����, �� ������� ��� ���� �������
              shift=iBarShift(Symbol(),Period(),afr[k]); 
              if (zz[shift]==0)
                {
                 flagFrNew=true;
                 if (shift>numBar) numBar=shift;
                 afrm=true;
                 numHighPrim=shift; numHighLast=0;HighLast=0.0;
                 for (k1=shift+1; k1<=countBarEnd; k1++)
                   {
                    if (zzH[k1]>0) 
                      {
                       if (ZigZagHighLow) HighLast=High[k1]; else HighLast=zzH[k1];
                       numHighLast=k1;

                       nameObj="_" + ExtComplekt + "ph" + Time[numHighPrim] + "_" + Time[numHighLast];

                       numOb=ObjectFind(nameObj);
                       if (numOb>-1)
                         {
                          ObjectDelete(nameObj); 

                          nameObjtxt="_" + ExtComplekt + "phtxt" + Time[numHighPrim] + "_" + Time[numHighLast];

                          ObjectDelete(nameObjtxt);
                         }
                      }
                   }
                }
             }

           // �������� ���������.
           if (afrl[k]>0)
             {
              // ����� ����, �� ������� ��� ���� �������
              shift=iBarShift(Symbol(),Period(),afr[k]); 
              if (zz[shift]==0)
                {
                 flagFrNew=true;
                 if (shift>numBar) numBar=shift;

                 afrm=true;
                 numLowPrim=shift; numLowLast=0;LowLast=10000000;
                 for (k1=shift+1; k1<=countBarEnd; k1++)
                   {
                    if (zzL[k1]>0) 
                      {
                       if (ZigZagHighLow) LowLast=Low[k1]; else LowLast=zzL[k1];
                       numLowLast=k1;

                       nameObj="_" + ExtComplekt + "pl" + Time[numLowPrim] + "_" + Time[numLowLast];

                       numOb=ObjectFind(nameObj);
                       if (numOb>-1)
                         {
                          ObjectDelete(nameObj); 

                          nameObjtxt="_" + ExtComplekt + "pltxt" + Time[numLowPrim] + "_" + Time[numLowLast];

                          ObjectDelete(nameObjtxt);
                         }
                      }
                   }
                }
             }
          }
        // ����� ����������� ��������� � �������� �����, ��������� �� ���� ���������. �����.

        // ���������� �������. ������.
        matriza ();
        // ���������� �������. �����.
       }
// ��������� ����������� ����� � �����. �����.
//-----------------------------------------
// ���� �������� � �������� �����, 
// ���������� ������������. �����.
//-----------------------------------------   


     // ������� ���������� ���������. ������.
     countFractal();
     // ������� ���������� ���������. �����.

//-----------------------------------------
//
//     4.
//
// ���� ������ �������������� �����. ������.
//-----------------------------------------   
      if (Bars - counted_bars>2 && ExtHidden>0)
        {
//-----------1 ��������� ����������. ������.
//+--------------------------------------------------------------------------+
//| ����� ����������� ����� � ����� ��������� � 0.886 ��� ���������� ZigZag-a
//| ��������� ���������� �� �������� ����
//+--------------------------------------------------------------------------+

         numLowPrim=0; numLowLast=0;
         numHighPrim=0; numHighLast=0;

         LowPrim=0.0; LowLast=0.0;
         HighPrim=0.0; HighLast=0.0;

         Angle=-100;
   
         if (flagFrNew && !flagGartley) countFr=1;
         else countFr=ExtFractal;

         for (k=0; (k<Bars-1 && countHigh1>0 && countFr>0); k++)
           {
            if (zzL[k]>0.0 && (zzL[k]<LowPrim || LowPrim==0.0) && HighPrim>0 && zzL[k]==zz[k])
              {
               if (ZigZagHighLow) LowPrim=Low[k]; else LowPrim=zzL[k]; 
               numLowPrim=k;
              }
            if (zzH[k]>0.0 && zzH[k]==zz[k])
              {
               if (HighPrim>0) 
                 {

                  if (ZigZagHighLow) HighLast=High[k]; else HighLast=zzH[k];
                  numHighLast=k;

                  HL=HighLast-LowPrim;
                  kj=(HighPrim-HighLast)*1000/(numHighLast-numHighPrim);
                  if (HL>0 && (Angle>=kj || Angle==-100))  // �������� ���� ������� �����
                    {
                     Angle=kj;
                     // �������� ����� � ���������� �������
                     HLp=HighPrim-LowPrim;
                     k1=MathCeil((numHighPrim+numHighLast)/2);
                     kj=HLp/HL;
               
                     if (ExtPPWithBars==0) PPWithBars="";
                     else if (ExtPPWithBars==1) PPWithBars=" ("+(numHighLast-numHighPrim)+")";
                     else if (ExtPPWithBars==2) PPWithBars=" ("+(numHighLast-numLowPrim)+"-"+(numLowPrim-numHighPrim)+")";
                     else if (ExtPPWithBars==3)
                       {
                        int_to_d1=(numLowPrim-numHighPrim);
                        int_to_d2=(numHighLast-numLowPrim);
                        int_to_d=int_to_d1/int_to_d2;
                        PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                       }
                     else if (ExtPPWithBars==4)
                       {
                        int_to_d1=(Time[numLowPrim]-Time[numHighPrim]);
                        int_to_d2=(Time[numHighLast]-Time[numLowPrim]);
                        int_to_d=int_to_d1/int_to_d2;
                        PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                       }
                     else if (ExtPPWithBars==5)
                       {
                        int_to_d1=(numLowPrim-numHighPrim)*(High[numHighPrim]-Low[numLowPrim]);
                        int_to_d2=(numHighLast-numLowPrim)*(High[numHighLast]-Low[numLowPrim]);
                        int_to_d=int_to_d1/int_to_d2;
                        PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                       }
                     else if (ExtPPWithBars==7)
                       {
                        int_to_d1=((High[numHighLast]-Low[numLowPrim])/Point)/(numHighLast-numLowPrim);
                        int_to_d2=((High[numHighPrim]-Low[numLowPrim])/Point)/(numLowPrim-numHighPrim);
                        PPWithBars=" ("+DoubleToStr(int_to_d1,3)+"/"+DoubleToStr(int_to_d2,3)+")";
                       }
                     else if (ExtPPWithBars==8)
                       {
                        int_to_d1=MathSqrt((numLowPrim-numHighPrim)*(numLowPrim-numHighPrim) + ((High[numHighPrim]-Low[numLowPrim])/Point)*((High[numHighPrim]-Low[numLowPrim])/Point));
                        int_to_d2=MathSqrt((numHighLast-numLowPrim)*(numHighLast-numLowPrim) + ((High[numHighLast]-Low[numLowPrim])/Point)*((High[numHighLast]-Low[numLowPrim])/Point));
                        int_to_d=int_to_d1/int_to_d2;
                        PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                       }
                     else if (ExtPPWithBars==9)
                       {
                        int_to_d1=100-100*Low[numLowPrim]/High[numHighLast];
                        int_to_d2=100*High[numHighPrim]/Low[numLowPrim]-100;
                        PPWithBars=" ("+DoubleToStr(int_to_d1,1)+"/"+DoubleToStr(int_to_d2,1)+")";
                       }
                     else if (ExtPPWithBars==10)
                       {
                        PPWithBars=" "+TimeToStr(Time[numHighPrim],TIME_DATE|TIME_MINUTES)+" / "+DoubleToStr(High[numHighPrim],Digits)+" ";
                       }

// ExtPPWithBars=6 ����������� ���������� ������� � ������� ���������� �� ����������� "���������"

                     ExtLine_=ExtLine;
                     if (kj>0.1 && kj<9.36)
                       {
                        // �������� ���������� ������� (����� ���������). % �������������� ����� �����������
                        kk=kj;
                        k2=1;
                        Pesavento_patterns();
                        if (k2<0)
                          // ������� �������������� ����� ��������� � 0.886
                          {
                           ExtLine_=ExtLine886;
                           if (ExtHidden!=4)
                             {
                              nameObj="_" + ExtComplekt + "phtxt" + Time[numHighPrim] + "_" + Time[numHighLast];
                              ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(HighPrim+HighLast)/2);

                              if (ExtPPWithBars==6)
                                {
                                 int_to_d=MathAbs((kk-kj)/kk)*100;
                                 PPWithBars=" ("+DoubleToStr((LowPrim+(HighLast-LowPrim)*kk-HighPrim)/Point,0)+"/"+DoubleToStr(int_to_d,2)+"%)";
                                }
                              descript=txtkk;
                              if (ExtPPWithBars==10)
                                {
                                 ObjectSetText(nameObj,PPWithBars,ExtSizeTxt,"Arial", colorPPattern);
                                }
                              else
                                {
                                 ObjectSetText(nameObj,txtkk+PPWithBars,ExtSizeTxt,"Arial", colorPPattern);
                                }
                              if (ExtPPWithBars==6) PPWithBars="";
                             }
                          }
                        else
                          // ������� �������������� (�� ��������� � 0.886)
                          {
                           if (ExtHidden==1 || ExtHidden==4)
                             {
                              nameObj="_" + ExtComplekt + "phtxt" + Time[numHighPrim] + "_" + Time[numHighLast];

                              ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(HighPrim+HighLast)/2);

                              descript=DoubleToStr(kk,3);
                              if (ExtPPWithBars==10)
                                {
                                 ObjectSetText(nameObj,""+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                                }
                              else
                                {
                                 if (ExtDeltaType==3)
                                   {
                                    ObjectSetText(nameObj,""+DoubleToStr(kk,3)+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                                   }
                                 else
                                   {
                                    ObjectSetText(nameObj,""+DoubleToStr(kk,2)+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                                   }
                                }
                             }
                          }

                        if ((ExtHidden==2 && k2<0) || ExtHidden!=2)
                          {
                           nameObj="_" + ExtComplekt + "ph" + Time[numHighPrim] + "_" + Time[numHighLast];
                           ObjectCreate(nameObj,OBJ_TREND,0,Time[numHighLast],HighLast,Time[numHighPrim],HighPrim);

                           if (descript_b) ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" PPesavento "+"Line High "+descript);
                           ObjectSet(nameObj,OBJPROP_RAY,false);
                           ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DOT);
                           ObjectSet(nameObj,OBJPROP_COLOR,ExtLine_);
                           ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
                          }
                        if (ExtFiboZigZag) k=countBarEnd;
                       }
                    }
                 }
               else 
                 {
                  if (ZigZagHighLow) HighPrim=High[k]; else HighPrim=zzH[k];
                  numHighPrim=k;
                 }
              }
            // ������� �� ��������� ���������
            if (k>countBarEnd) 
              {
               k=numHighPrim+1; countHigh1--; countFr--;

               numLowPrim=0; numLowLast=0;
               numHighPrim=0; numHighLast=0;

               LowPrim=0.0; LowLast=0.0;
               HighPrim=0.0; HighLast=0.0;
   
               Angle=-100;
              }
           }
//-----------1 ��������� ����������. �����.

//-----------2 ��������� ���������. ������.
//+-------------------------------------------------------------------------+
//| ����� ����������� ����� � ����� ��������� � 0.886 ��� ��������� ZigZag-a
//| ��������� ���� �� �������� ����
//+-------------------------------------------------------------------------+

         numLowPrim=0; numLowLast=0;
         numHighPrim=0; numHighLast=0;

         LowPrim=0.0; LowLast=0.0;
         HighPrim=0.0; HighLast=0.0;
   
         Angle=-100;

         if (flagFrNew && !flagGartley) countFr=1;
         else countFr=ExtFractal;
         flagFrNew=false;
         flagGartley=false;

         for (k=0; (k<Bars-1 && countLow1>0 && countFr>0); k++)
           {
            if (zzH[k]>HighPrim && LowPrim>0)
              {
               if (ZigZagHighLow) HighPrim=High[k]; else HighPrim=zzH[k];
               numHighPrim=k;
              }

            if (zzL[k]>0.0 && zzL[k]==zz[k]) 
              {
               if (LowPrim>0) 
                 {

                  if (ZigZagHighLow) LowLast=Low[k]; else LowLast=zzL[k];
                  numLowLast=k;

                  // ����� ����������� ����� � ��������� ��������������(����� ���������)
                  HL=HighPrim-LowLast;
                  kj=(LowPrim-LowLast)*1000/(numLowLast-numLowPrim);
                  if (HL>0 && (Angle<=kj || Angle==-100))  // �������� ���� ������� �����
                    {
                     Angle=kj;

                     HLp=HighPrim-LowPrim;
                     k1=MathCeil((numLowPrim+numLowLast)/2);
                     kj=HLp/HL;

                     if (ExtPPWithBars==0) PPWithBars="";
                     else if (ExtPPWithBars==1) PPWithBars=" ("+(numLowLast-numLowPrim)+")";
                     else if (ExtPPWithBars==2) PPWithBars=" ("+(numLowLast-numHighPrim)+"-"+(numHighPrim-numLowPrim)+")";
                     else if (ExtPPWithBars==3)
                       {
                        int_to_d1=(numHighPrim-numLowPrim);
                        int_to_d2=(numLowLast-numHighPrim);
                        int_to_d=int_to_d1/int_to_d2;
                        PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                       }
                     else if (ExtPPWithBars==4)
                       {
                        int_to_d1=(Time[numHighPrim]-Time[numLowPrim]);
                        int_to_d2=(Time[numLowLast]-Time[numHighPrim]);
                        int_to_d=int_to_d1/int_to_d2;
                        PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                       }
                     else if (ExtPPWithBars==5)
                       {
                        int_to_d1=(numHighPrim-numLowPrim)*(High[numHighPrim]-Low[numLowPrim]);
                        int_to_d2=(numLowLast-numHighPrim)*(High[numHighPrim]-Low[numLowLast]);
                        int_to_d=int_to_d1/int_to_d2;
                        PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                       }
                     else if (ExtPPWithBars==7)
                       {
                        int_to_d1=((High[numHighPrim]-Low[numLowLast])/Point)/(numLowLast-numHighPrim);
                        int_to_d2=((High[numHighPrim]-Low[numLowPrim])/Point)/(numHighPrim-numLowPrim);
                        PPWithBars=" ("+DoubleToStr(int_to_d1,3)+"/"+DoubleToStr(int_to_d2,3)+")";
                       }
                     else if (ExtPPWithBars==8)
                       {
                        int_to_d1=MathSqrt((numHighPrim-numLowPrim)*(numHighPrim-numLowPrim) + ((High[numHighPrim]-Low[numLowPrim])/Point)*((High[numHighPrim]-Low[numLowPrim])/Point));
                        int_to_d2=MathSqrt((numLowLast-numHighPrim)*(numLowLast-numHighPrim) + ((High[numHighPrim]-Low[numLowLast])/Point)*((High[numHighPrim]-Low[numLowLast])/Point));
                        int_to_d=int_to_d1/int_to_d2;
                        PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                       }
                     else if (ExtPPWithBars==9)
                       {
                        int_to_d1=100*High[numHighPrim]/Low[numLowLast]-100;
                        int_to_d2=100-100*Low[numLowPrim]/High[numHighPrim];
                        PPWithBars=" ("+DoubleToStr(int_to_d1,1)+"/"+DoubleToStr(int_to_d2,1)+")";
                       }
                     else if (ExtPPWithBars==10)
                       {
                        PPWithBars=" "+TimeToStr(Time[numLowPrim],TIME_DATE|TIME_MINUTES)+" / "+DoubleToStr(Low[numLowPrim],Digits)+" ";
                       }

// ExtPPWithBars=6 ����������� ��������� ������� � ������� ���������� �� ����������� "���������"

                     ExtLine_=ExtLine;
                     if ( kj>0.1 && kj<9.36)
                       {
                        // �������� ���������� ������� (����� ���������). % �������������� ����� ����������
                        kk=kj;
                        k2=1;
                        Pesavento_patterns();
                        if (k2<0)
                        // ������� �������������� ����� ��������� � 0.886
                          {
                           ExtLine_=ExtLine886;
                           if (ExtHidden!=4)                  
                             {
                              nameObj="_" + ExtComplekt + "pltxt" + Time[numLowPrim] + "_" + Time[numLowLast];
                              ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(LowPrim+LowLast)/2);

                              if (ExtPPWithBars==6)
                                {
                                 int_to_d=MathAbs((kk-kj)/kk)*100;
                                 PPWithBars=" ("+DoubleToStr((HighPrim-(HighPrim-LowLast)*kk-LowPrim)/Point,0)+"/"+DoubleToStr(int_to_d,2)+"%)";
                                }
                              descript=txtkk;
                              if (ExtPPWithBars==10)
                                {
                                 ObjectSetText(nameObj,PPWithBars,ExtSizeTxt,"Arial", colorPPattern);
                                }
                              else
                                {
                                 ObjectSetText(nameObj,txtkk+PPWithBars,ExtSizeTxt,"Arial", colorPPattern);
                                }
                              if (ExtPPWithBars==6) PPWithBars="";
                             }
                          }
                        else 
                          // ������� �������������� (�� ��������� � 0.886)
                          { 
                           if (ExtHidden==1 || ExtHidden==4)
                             {
                              nameObj="_" + ExtComplekt + "pltxt" + Time[numLowPrim] + "_" + Time[numLowLast];

                              ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(LowPrim+LowLast)/2);
      
                              descript=DoubleToStr(kk,3);
                              if (ExtPPWithBars==10)
                                {
                                 ObjectSetText(nameObj,""+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                                }
                              else
                                {
                                 if (ExtDeltaType==3)
                                   {
                                    ObjectSetText(nameObj,""+DoubleToStr(kk,3)+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                                   }
                                 else
                                   {
                                    ObjectSetText(nameObj,""+DoubleToStr(kk,2)+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                                   }
                                }
                             }
                           }

                         if ((ExtHidden==2 && k2<0) || ExtHidden!=2)
                           {
                            nameObj="_" + ExtComplekt + "pl" + Time[numLowPrim] + "_" + Time[numLowLast];

                            ObjectCreate(nameObj,OBJ_TREND,0,Time[numLowLast],LowLast,Time[numLowPrim],LowPrim);

                            if (descript_b) ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" PPesavento "+"Line Low "+descript);
                            ObjectSet(nameObj,OBJPROP_RAY,false);
                            ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DOT);
                            ObjectSet(nameObj,OBJPROP_COLOR,ExtLine_);
                            ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
                           }
                         if (ExtFiboZigZag) k=countBarEnd;
                        }
                     }
                 }
               else
                 {
                  numLowPrim=k; 
                  if (ZigZagHighLow) LowPrim=Low[k]; else LowPrim=zzL[k];
                 }
              }
            // ������� �� ��������� ���������
            if (k>countBarEnd) 
              {
               k=numLowPrim+1; countLow1--; countFr--;

               numLowPrim=0; numLowLast=0;
               numHighPrim=0; numHighLast=0;

               LowPrim=0.0; LowLast=0.0;
               HighPrim=0.0; HighLast=0.0;
  
               Angle=-100;
              }
           }

//-----------2 ��������� ���������. �����.

        }
//-----------------------------------------
// ���� ������ �������������� �����. �����.
//-----------------------------------------   

//======================
//======================
//======================
     } // ���������� �� ����� ��������. �����.

   if (mAP)
     {
      if (mAPs || mAPd)
        {
         metkaAP(true);  // �������� ����� � ����� �������
        }
      else if (mTime<iTime(NULL,Period(),0) || mStart)
        {
         if (_ExtPitchforkStatic>0) mAPs=true;
         if (ExtPitchforkDinamic>0) mAPd=true;
         if (mAPs || mAPd) metkaAP(true);  // ������������� ��������� ����� � ����� �������
         mStart=false;
         mTime=iTime(NULL,Period(),0);
        }
      else if (mAuto_d && ((mOutRedZone && aOutRedZone[0]) || AutoAPDinamicTestRedZone))
        {
         if (ExtPitchforkDinamic>0) {mAPd=true; metkaAP(true);} // ������������� ��������� ����� � ����� �������
        }
      else 
        {
         metkaAP(false);  // ����������� ����� ����� � ����� �������
        }
     }
// �����
  } // start

//----------------------------------------------------
//  ������������ � �������
//----------------------------------------------------

//--------------------------------------------------------
// ������� ���������� �����������. ��������� � ����������. ������.
//--------------------------------------------------------
void countFractal()
  {
   int shift;
   countLow1=0;
   countHigh1=0;
   if (flagFrNew && !flagGartley)
     {
      for(shift=0; shift<=numBar; shift++)
        {
         if (zzL[shift]>0.0) {countLow1++;}
         if (zzH[shift]>0.0) {countHigh1++;}    
        }

      numBar=0;  
      counted_bars=Bars-4;
     }
   else
     {
      if (flagGartley)  {counted_bars=0;}
      for(shift=0; shift<=countBarEnd; shift++)
        {
         if (zzL[shift]>0.0) {countLow1++;}
         if (zzH[shift]>0.0) {countHigh1++;}
        }
     }
  }
//--------------------------------------------------------
// ������� ���������� �����������. ��������� � ����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������������ �������. ������.
//
// ������� ������������ ��� ������ ����������� �����������.
// ��� ���������� ����������� �������������� ��������� ������������ ZigZag-a.
//
// ����� ��������� ����������� � ������������ ���� � ����� ���������,
// ���� �������...
//------------------------------------------------------
void matriza()
  {
   if (afrm && ExtHidden<5)
     {
      afrm=false;
//      aOutRedZone[0]=false;
      int shift,k,m;
      double kl=0,kh=0;

      if (ExtMaxBar>0) cbi=ExtMaxBar; else cbi=Bars;

      k=0; m=0;
      for (shift=0; shift<cbi && k<10; shift++)
        {
         if (zz[shift]>0)
           {
            afrx[k]=zz[shift];
            afr[k]=Time[shift];
            if (zz[shift]==zzL[shift])
              {
               kl=zzL[shift];
               if (ZigZagHighLow) afrl[k]=Low[shift]; 
               else
                 {
                  if (k==0) afrl[k]=Low[shift]; else  afrl[k]=zzL[shift];
                 }
               afrh[k]=0.0;
              }
            if (zz[shift]==zzH[shift])
              {
               kh=zzH[shift];
               if (ZigZagHighLow) afrh[k]=High[shift]; 
               else
                 {
                  if (k==0) afrh[k]=High[shift]; else afrh[k]=zzH[shift];
                 }
               afrl[k]=0.0;
              }
            k++;

            if (infoMerrillPattern)
              {
               if (m<6)
                 {
                  if (m<5)
                    {
                     mPeak0[m][0]=zz[shift];
                    }
                  if (m>0)
                    {
                     mPeak1[m-1][0]=zz[shift];
                    }
                  m++;
                 }
              }
           }
        }

      if (infoMerrillPattern)
        {
         ArraySort(mPeak1,5,0,MODE_ASCEND);
         ArraySort(mPeak0,5,0,MODE_ASCEND);
        }

      if (PeakDet && chHL_PeakDet_or_vts)
        {
         // kl - min; kh - max
         for (k=shift; k>0; k--)
           {
            if (zzH[k]>0) {kh=zzH[k];}
            if (zzL[k]>0) {kl=zzL[k];}

            if (kl>0) lam[k]=kl;
            if (kh>0) ham[k]=kh;
           }
        }

      // ����� Fibo Time ��� ��� �������
      if (ExtFiboTimeNum>2) fiboTimeX(); // ������ ���������� ������ ������ ����������� ��� �������

      // ����� ��� �������
      if (ExtPitchforkStatic>0)
        {
         if (ExtCustomStaticAP)
           {
            screenPitchforkS();
           }
         else
           {
            if (newRay && mPitch[2]>0) screenPitchforkS();
            if (ExtPitchforkCandle)
              {
               if (iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)==0) screenPitchforkS();
              }
            else
              {
               if (mPitch[2]==0) screenPitchforkS();
              }
           }
        }

      if (ExtPitchforkDinamic>0) screenPitchforkD();

      // ����� ��������.
      if (ExtChannelsNum>1 || DinamicChannels>0) Channels();

      // ����� ����������� � ������������ ���.
      if (ExtFiboStatic)
        {
         if (newRay && mFibo[1]>0) screenFiboS();
         if (mFibo[1]==0) screenFiboS();
        }
      if (ExtFiboDinamic) screenFiboD();

      // ���������� ���������
      if (ExtFiboExpansion>0)
        {
         if (newRay && mExpansion[2]>0) FiboExpansion();
         if (mExpansion[2]==0) FiboExpansion();
        }

      // ����� ����������
      if (ExtFiboFanNum>0 && ExtFiboFanColor>0)
        {
         if (newRay && mFan[1]>0) screenFiboFan();
         if (mFan[1]==0) screenFiboFan();
        }
      if (ExtFiboFanDinamic) screenFiboFanD();

      // ����� Versum Levels
      if (ExtVLStaticColor>0)
        {
         if (newRay && mVL[2]>0 && ExtVLStaticNum>0) VLS();
         if (mVL[2]==0) VLS();
        }
      if (ExtVLDinamicColor>0) VLD();

      // ����� PivotZZ ������������
      if (ExtPivotZZ1Num==1 && ExtPivotZZ1Color>0) PivotZZ(ExtPivotZZ1Color, ExtPivotZZ1Num, 1);
      if (ExtPivotZZ2Num==1 && ExtPivotZZ2Color>0) PivotZZ(ExtPivotZZ2Color, ExtPivotZZ2Num, 2);

      // ����� PivotZZ �����������
      if (newRay && ExtPivotZZ1Num>1 && ExtPivotZZ1Color>0) PivotZZ(ExtPivotZZ1Color, ExtPivotZZ1Num, 1);
      if (newRay && ExtPivotZZ2Num>1 && ExtPivotZZ2Color>0) PivotZZ(ExtPivotZZ2Color, ExtPivotZZ2Num, 2);

      // ����� �������
      if (ExtArcDinamicNum>0) screenFiboArcD();
      if (newRay && ExtArcStaticNum>0) screenFiboArcS();

      // ����� �������
      if (newRay && ExtSpiralNum>0) GoldenSpiral(afr[mSpiral[0]],afrx[mSpiral[0]],afr[mSpiral[1]],afrx[mSpiral[1]]);

      // ����� ��������� Gartley
      search_Gartley();
      
      ExtSave=false;
     }
   if (newRay && ExtNumberPeak) NumberPeak();
   newRay=false;
  }
//--------------------------------------------------------
// ������������ �������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ��������� Gartley. ������.
//--------------------------------------------------------
void search_Gartley()
  {
   if (ExtGartleyOnOff || PotencialsLevels_retXD>0)
     {
      switch (ExtIndicator )
        {
         case 0     : {_Gartley("ExtIndicator=0_" + minBars+"/"+ExtBackstep,0);break;}
         case 1     : {_Gartley("ExtIndicator=1_" + minSize+"/"+minPercent,0);break;}
         case 2     : {_Gartley("ExtIndicator=2_" + minBars+"/"+minSize,0);break;}
         case 3     : {_Gartley("ExtIndicator=3_" + minBars,0);break;}
         case 4     : {_Gartley("ExtIndicator=4_" + minSize,0);break;}
         case 5     : {_Gartley("ExtIndicator=5_" + minBars,0);break;}
         case 6     : {_Gartley("ExtIndicator=6_" + minBars+"/"+ExtBackstep,0);break;}
         case 7     : {_Gartley("ExtIndicator=7_" + minBars,0);break;}
         case 8     : {_Gartley("ExtIndicator=8_" + minBars+"/"+ExtDeviation,0);break;}
         case 10    : {_Gartley("ExtIndicator=10_" + minBars,0);break;}
         case 12    : {_Gartley("ExtIndicator=12_" + minBars,0);break;}
         case 13    : {_Gartley("ExtIndicator=13_" + minBars+"/"+minSize,0);break;}
         case 14    : {_Gartley("ExtIndicator=14_" + minBars,0);break;}
        }

      if (vPatOnOff && !vPatNew)
        {
         vPatNew=true;
         if (ExtSendMail){
             //_SendMail("There was a pattern","on  " + Symbol() + " " + Period() + " pattern " + vBullBear + " " + vNamePattern);
             //GlobalVariableSet(StringConcatenate("PatternID_135",Symbol(),Period()),getPattern(vNamePattern));
             }
        }
      else if (!vPatOnOff && vPatNew) vPatNew=false;
     }
  }
//--------------------------------------------------------
// ����� ��������� Gartley. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ������� ��������� ��������. ������.
//--------------------------------------------------------
void NumberPeak()
  {
   int n=0,i,endNumber;
   string txt="";
   if (ExtNumberPeak10) endNumber=iBarShift(Symbol(),Period(),afr[9]); else endNumber=Bars-minBars;
   
   delete_objects_number();

   for (i=iBarShift(Symbol(),Period(),afr[0])+1;i<endNumber;i++)
     {
      if (zz[i]>0)
        {
         n++;
         if (ExtNumberPeakLow)
           {
            if (zzL[i]>0)
              {
               txt=DoubleToStr(n,0);
               nameObj="NumberPeak" + "_" + ExtComplekt + "_" + n;
               ObjectCreate(nameObj,OBJ_TEXT,0,Time[i],zz[i]);
               ObjectSetText(nameObj,txt,ExtNumberPeakFontSize,"Arial",ExtNumberPeakColor);
              }
           }
         else
           {
            txt=DoubleToStr(n,0);
            nameObj="NumberPeak" + "_" + ExtComplekt + "_" + n;
            ObjectCreate(nameObj,OBJ_TEXT,0,Time[i],zz[i]);
            ObjectSetText(nameObj,txt,ExtNumberPeakFontSize,"Arial",ExtNumberPeakColor);
           }
        }
     }
   }
//--------------------------------------------------------
// ����� ������� ��������� ��������. �����
//--------------------------------------------------------

//--------------------------------------------------------
// ������. ������.
//--------------------------------------------------------
void Channels()
  {
   int    i,j,k,m,n,nul,peakLeft,peakRight,peakBase;
   double tangens, sdvigH, sdvigL, sdvigH_, sdvigL_, cenaLTLeft, cenaLTRight, cenaLCLeft, cenaLCRight, wrcenaL, wrcenaR;
   datetime timeLTLeft, timeLTRight, timeLCLeft, timeLCRight;
   int    baseExtremum; // ����� �������� ������� (���), �� �������� �������� ���������
   bool   fTrend=false; // =true - Bull �������� ��������� �� ���������, =false - Bear �������� ��������� �� ����������
   bool   dinamic=false;

   if (ExtChannelsNum==0 && DinamicChannels>0) dinamic=true;

//int o;
   k=0;
   for (i=0;i<=9;i++) {if (mChannels[i]>=0) k++;}

   // ������ � ������ ������, ������ ����� ������� �� �������� �������, 
   // ������ ����� ��������� �� ����������� � ����� �� �������, ������������ �������. ������.
   if (ExtTypeChannels==1)
     {
      if (dinamic) nul=DinamicChannels;
      else nul=1;

      for (i=1;i<k;i++)
        {
         sdvigH=0; sdvigL=0; sdvigH_=0; sdvigL_=0;

         peakLeft=iBarShift(Symbol(),Period(),afr[mChannels[i-1]],true);
         if (peakLeft<0) continue;
         peakRight=iBarShift(Symbol(),Period(),afr[mChannels[i]],true);
         if (peakRight<0) continue;
         if (peakLeft==peakRight) continue;
         if (afrx[mChannels[i-1]]<afrx[mChannels[i]]) fTrend=true; else fTrend=false;

         j=mChannels[i-1]-mChannels[i];
         if (j==1)
           {
            if (afrx[mChannels[i-1]]<afrx[mChannels[i]]) fTrend=true; else fTrend=false;
            baseExtremum=mChannels[i-1];
           }
         else if (j==2)
           {
            if (afrx[mChannels[i-1]]<afrx[mChannels[i]])
              { 
               fTrend=true;
               if (afrx[mChannels[i-1]]<afrx[mChannels[i-1]-1]) baseExtremum=mChannels[i-1]; else baseExtremum=mChannels[i-1]-1;
              }
            else
              {
               fTrend=false;
               if (afrx[mChannels[i-1]]<afrx[mChannels[i-1]-1]) baseExtremum=mChannels[i-1]-1; else baseExtremum=mChannels[i-1];
              }
           }

         peakBase=iBarShift(Symbol(),Period(),afr[baseExtremum]);
         tangens=(afrx[mChannels[i]]-afrx[baseExtremum])/(peakBase-peakRight);

         for (j=peakBase;j>=peakRight;j--) // ��������� tangens
           {
            if (fTrend)
              {
               if (afrx[baseExtremum] + tangens*(peakBase-j)-Low[j]>0) tangens=(Low[j]-afrx[baseExtremum])/(peakBase-j);
              }
            else
              {
               if (High[j] - (afrx[baseExtremum] + tangens*(peakBase-j))>0) tangens=(High[j]-afrx[baseExtremum])/(peakBase-j);
              }
           }

         for (j=peakLeft;j>=peakRight;j--) // ��������� ������
           {
            if (fTrend)
              {
               sdvigH_=High[j] - (afrx[baseExtremum] + tangens*(peakBase-j));
               if (sdvigH_>sdvigH) {sdvigH=sdvigH_; cenaLCRight=High[j]+tangens*(j-peakRight);}
              }
            else
              {
               sdvigL_=afrx[baseExtremum] + tangens*(peakBase-j)-Low[j];
               if (sdvigL_>sdvigL) {sdvigL=sdvigL_; cenaLCRight=Low[j]+tangens*(j-peakRight);}
              }
           }
         timeLCRight=afr[mChannels[i]];

         if (ExtTypeLineChannels==0)
           {
            while (j>0)
              {
               if (fTrend)
                 {
                  if (afrx[baseExtremum] + tangens*(peakBase-j)-Low[j]>sdvigL) break;
                 }
               else
                 {
                  if (High[j] - (afrx[baseExtremum] + tangens*(peakBase-j))>sdvigH) break;
                 }
               j--;
              }
           }

         if (j<0) j=0;

         nameObj="LTChannel" + i + ExtComplekt+"_";
         if (ExtSave)
           {
            if (i!=DinamicChannels) nameObj=nameObj + save;
           }
         ObjectDelete(nameObj);

         if (fTrend)
           {
            timeLTLeft=afr[mChannels[i-1]];  cenaLTLeft=afrx[baseExtremum]-tangens*(peakLeft-peakBase);
            timeLTRight=Time[j]; cenaLTRight=afrx[baseExtremum] + tangens*(peakBase-j)-sdvigL;
           }
         else
           {
            timeLTLeft=afr[mChannels[i-1]]; cenaLTLeft=afrx[baseExtremum]-tangens*(peakLeft-peakBase);
            timeLTRight=Time[j]; cenaLTRight=afrx[baseExtremum] + tangens*(peakBase-j)+sdvigH;
           }

         if (ExtTypeLineChannels==1 || ExtTypeLineChannels==3)
           {
            n=j;
            wrcenaR=cenaLTRight;
            if (fTrend)
              {
               while (cenaLTRight<=afrx[mChannels[i]] && n>0) {n--; cenaLTRight=wrcenaR+tangens*(j-n);}
              }
            else
              {
               while (cenaLTRight>=afrx[mChannels[i]] && n>0) {n--; cenaLTRight=wrcenaR+tangens*(j-n);}
              }
            timeLTRight=Time[n];
            timeLTLeft=afr[baseExtremum];  cenaLTLeft=afrx[baseExtremum];
           }

         ObjectCreate(nameObj,OBJ_TREND,0,timeLTLeft,cenaLTLeft,timeLTRight,cenaLTRight);
         if (ExtTypeLineChannels<2) ObjectSet(nameObj,OBJPROP_RAY,ExtRay);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtLTColor);
         ObjectSet(nameObj,OBJPROP_STYLE,ExtLTChannelsStyle);
         ObjectSet(nameObj,OBJPROP_WIDTH,ExtLTChannelsWidth);
         
         nameObj="LCChannel" + i + ExtComplekt+"_";
         if (ExtSave)
           {
            if (i!=DinamicChannels) nameObj=nameObj + save;
           }
         ObjectDelete(nameObj);

         if (fTrend)
           {
            cenaLCLeft=afrx[baseExtremum]+sdvigH-tangens*(peakLeft-peakBase);
           }
         else
           {
            cenaLCLeft=afrx[baseExtremum]-sdvigL-tangens*(peakLeft-peakBase);
           }
         timeLCLeft=afr[mChannels[i-1]];

         if (ExtTypeLineChannels==1 || ExtTypeLineChannels==3)
           {
            m=peakLeft;
            wrcenaL=cenaLCLeft;
            n=peakRight;
            wrcenaR=cenaLCRight;
            if (fTrend)
              {
               while (cenaLCLeft>=afrx[baseExtremum] && m<=Bars) {m++; cenaLCLeft=wrcenaL-tangens*(m-peakLeft);}
               while (cenaLCRight>=afrx[mChannels[i]] && n<=peakLeft) {n++; cenaLCRight=wrcenaR-tangens*(n-peakRight);}
              }
            else
              {
               while (cenaLCLeft<=afrx[baseExtremum] && m<=Bars) {m++; cenaLCLeft=wrcenaL-tangens*(m-peakLeft);}
               while (cenaLCRight<=afrx[mChannels[i]] && n<=peakLeft) {n++; cenaLCRight=wrcenaR-tangens*(n-peakRight);}
              }
            timeLCLeft=Time[m];
            cenaLCRight=wrcenaR-tangens*(n-1-peakRight);
            timeLCRight=Time[n-1];
           }

         ObjectCreate(nameObj,OBJ_TREND,0,timeLCLeft,cenaLCLeft,timeLCRight,cenaLCRight);
         if (ExtTypeLineChannels<2) ObjectSet(nameObj,OBJPROP_RAY,ExtRay);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtLCColor);
         ObjectSet(nameObj,OBJPROP_STYLE,ExtLCChannelsStyle);
         ObjectSet(nameObj,OBJPROP_WIDTH,ExtLCChannelsWidth);

         if (dinamic) break;
        }
     }
   // ������ � ������ ������, ������ ����� ������� �� �������� �������, 
   // ������ ����� ��������� �� ����������� � ����� �� �������, ������������ �������. �����.

   // ������, ������������ ���� �������. ������.
   if (ExtTypeChannels==2)
     {
      if (dinamic) nul=DinamicChannels;
      else nul=1;

      for (i=1;i<k;i++)
        {
         sdvigH=0; sdvigL=0; sdvigH_=0; sdvigL_=0;

         peakLeft=iBarShift(Symbol(),Period(),afr[mChannels[i-1]],true);
         if (peakLeft<0) continue;
         peakRight=iBarShift(Symbol(),Period(),afr[mChannels[i]],true);

         if (peakRight<0) continue;
         if (peakLeft==peakRight) continue;
         if (afrx[mChannels[i-1]]<afrx[mChannels[i]]) fTrend=true; else fTrend=false;

         tangens=(afrx[mChannels[i]]-afrx[mChannels[i-1]])/(peakLeft-peakRight);

         for (j=peakLeft;j>=peakRight;j--) // ��������� ������
           {
            sdvigH_=High[j] - (afrx[mChannels[i-1]] + tangens*(peakLeft-j));
            sdvigL_=afrx[mChannels[i-1]] + tangens*(peakLeft-j)-Low[j];
            if (sdvigH_>sdvigH) sdvigH=sdvigH_;
            if (sdvigL_>sdvigL) sdvigL=sdvigL_;
           }

         if (ExtTypeLineChannels==0)
           {
            while (j>=0)
              {
               if (fTrend)
                 {
                  if (afrx[mChannels[i-1]] + tangens*(peakLeft-j)-Low[j]>sdvigL) break;
                 }
               else
                 {
                  if (High[j] - (afrx[mChannels[i-1]] + tangens*(peakLeft-j))>sdvigH) break;
                 }
               j--;
              }
           }

         if (j<0) j=0;

         nameObj="LTChannel" + i + ExtComplekt+"_";
         if (ExtSave)
           {
            if (i!=DinamicChannels) nameObj=nameObj + save;
           }
         ObjectDelete(nameObj);
         if (fTrend)
           {
            timeLTLeft=afr[mChannels[i-1]];  cenaLTLeft=afrx[mChannels[i-1]]-sdvigL;
            timeLTRight=Time[j]; cenaLTRight=afrx[mChannels[i-1]] + tangens*(peakLeft-j)-sdvigL;
           }
         else
           {
            timeLTLeft=afr[mChannels[i-1]]; cenaLTLeft=afrx[mChannels[i-1]]+sdvigH;
            timeLTRight=Time[j]; cenaLTRight=afrx[mChannels[i-1]] + tangens*(peakLeft-j)+sdvigH;
           }

         if (ExtTypeLineChannels==1 || ExtTypeLineChannels==3)
           {
            if (fTrend)
              {
               m=peakLeft;
               wrcenaL=cenaLTLeft;
               while (cenaLTLeft<afrx[mChannels[i-1]] && m>=peakRight) {m--; cenaLTLeft=wrcenaL+tangens*(peakLeft-m);}
               timeLTLeft=Time[m+1];  cenaLTLeft=wrcenaL+tangens*(peakLeft-m-1);

               n=peakRight;
               wrcenaR=cenaLTRight;
               while (cenaLTRight<afrx[mChannels[i]] && n>0) {n--; cenaLTRight=wrcenaL+tangens*(peakLeft-n);}
               timeLTRight=Time[n];
              }
            else
              {
               m=peakLeft;
               wrcenaL=cenaLTLeft;
               while (cenaLTLeft>=afrx[mChannels[i-1]] && m>=peakRight) {m--; cenaLTLeft=wrcenaL+tangens*(peakLeft-m);}
               timeLTLeft=Time[m+1];  cenaLTLeft=wrcenaL+tangens*(peakLeft-m-1);

               n=peakRight;
               wrcenaR=cenaLTRight;
               while (cenaLTRight>afrx[mChannels[i]] && n>0) {n--; cenaLTRight=wrcenaL+tangens*(peakLeft-n);}
               timeLTRight=Time[n];
              }
            }

         ObjectCreate(nameObj,OBJ_TREND,0,timeLTLeft,cenaLTLeft,timeLTRight,cenaLTRight);
         if (ExtTypeLineChannels<2) ObjectSet(nameObj,OBJPROP_RAY,false);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtLTColor);
         ObjectSet(nameObj,OBJPROP_STYLE,ExtLTChannelsStyle);
         ObjectSet(nameObj,OBJPROP_WIDTH,ExtLTChannelsWidth);
         
         nameObj="LCChannel" + i + ExtComplekt+"_";
         if (ExtSave)
           {
            if (i!=DinamicChannels) nameObj=nameObj + save;
           }
         ObjectDelete(nameObj);
         if (fTrend)
           {
            timeLCLeft=afr[mChannels[i-1]]; cenaLCLeft=afrx[mChannels[i-1]]+sdvigH;
            timeLCRight=afr[mChannels[i]]; cenaLCRight=afrx[mChannels[i]]+sdvigH;
           }
         else
           {
            timeLCLeft=afr[mChannels[i-1]]; cenaLCLeft=afrx[mChannels[i-1]]-sdvigL;
            timeLCRight=afr[mChannels[i]]; cenaLCRight=afrx[mChannels[i]]-sdvigL;
           }

         if (ExtTypeLineChannels==1 || ExtTypeLineChannels==3)
           {
            if (fTrend)
              {
               m=peakLeft;
               wrcenaL=cenaLCLeft;
               while (cenaLCLeft>afrx[mChannels[i-1]] && m<Bars) {m++; cenaLCLeft=wrcenaL-tangens*(m-peakLeft);}
               timeLCLeft=Time[m];
 
               n=peakRight;
               wrcenaR=cenaLCRight;
               while (cenaLCRight>afrx[mChannels[i]] && n<peakLeft) {n++; cenaLCRight=wrcenaR-tangens*(n-peakRight);}
               timeLCRight=Time[n-1]; cenaLCRight=wrcenaR-tangens*(n-1-peakRight);
              }
            else
              {
               m=peakLeft;
               wrcenaL=cenaLCLeft;
               while (cenaLCLeft<=afrx[mChannels[i-1]] && m<=Bars) {m++; cenaLCLeft=wrcenaL-tangens*(m-peakLeft);}
               timeLCLeft=Time[m];

               n=peakRight;
               wrcenaR=cenaLCRight;
               while (cenaLCRight<=afrx[mChannels[i]] && n<=peakLeft) {n++; cenaLCRight=wrcenaR-tangens*(n-peakRight);}
               timeLCRight=Time[n-1]; cenaLCRight=wrcenaR-tangens*(n-1-peakRight);
              }
            }

         ObjectCreate(nameObj,OBJ_TREND,0,timeLCLeft,cenaLCLeft,timeLCRight,cenaLCRight);
         if (ExtTypeLineChannels<2) ObjectSet(nameObj,OBJPROP_RAY,false);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtLCColor);
         ObjectSet(nameObj,OBJPROP_STYLE,ExtLCChannelsStyle);
         ObjectSet(nameObj,OBJPROP_WIDTH,ExtLCChannelsWidth);

         if (dinamic) break;
        }
     }
   // ������, ������������ ���� �������. �����.

   ExtChannelsNum=0;
  }
//--------------------------------------------------------
// ������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� Pivot ZigZag. ������.
//--------------------------------------------------------
void PivotZZ(int PivotZZColor, int PivotZZNum, int LinePivotZZ)
  {
   int peak1, peak2, shift;
   double tangens, cena, val;
   peak1=iBarShift(Symbol(),Period(),afr[PivotZZNum-1]);
   peak2=iBarShift(Symbol(),Period(),afr[PivotZZNum]);

   nameObj="LinePivotZZ" + LinePivotZZ + ExtComplekt+"_";
   if (ExtSave)
     {
      nameObj=nameObj + save;
     }
   ObjectDelete(nameObj);
   if (peak1>1)
     {
      cena=(zz[peak2]+zz[peak1]+Close[peak1-1])/3;

      tangens=(zz[peak2]-zz[peak1])/(peak2-peak1);
      val=zz[peak1];
      for (shift=peak1; shift<peak2; shift++)
        {
         val=val+tangens;
         if (zz[peak2]>zz[peak1])
           {
            if (val>cena) break;
           }
         else
           {
            if (val<cena) break;
           }
        }

      ObjectCreate(nameObj,OBJ_TREND,0,Time[shift+1],cena,Time[0]+5*Period()*60,cena);
      ObjectSet(nameObj,OBJPROP_COLOR,PivotZZColor);
      ObjectSet(nameObj,OBJPROP_STYLE,ExtPivotZZStyle);
      ObjectSet(nameObj,OBJPROP_WIDTH,ExtPivotZZWidth);
     }
  }
//--------------------------------------------------------
// ����� Pivot ZigZag. ������.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� Versum Levels �����������. ������.
//--------------------------------------------------------
void VLS()
  {
   VL(mVL[0],mVL[1],mVL[2],ExtVLStaticColor,"VLS");
  }
//--------------------------------------------------------
// ����� Versum Levels �����������. ������.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� Versum Levels ������������. ������.
//--------------------------------------------------------
void VLD()
  {
   VL(2,1,0,ExtVLDinamicColor,"VLD");
  }
//--------------------------------------------------------
// ����� Versum Levels ������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// Versum Levels. ������.
//--------------------------------------------------------
void VL(int na,int nb,int nc,color color_line,string vl)
  {
   double line_pesavento[7]={0.236, 0.382, 0.447, 0.5, 0.618, 0.786, 0.886}, line_fibo[7]={0.236, 0.382, 0.455, 0.5, 0.545, 0.618, 0.764};
   int c_bar1, c_bar2, i;
   double H_L, mediana, tangens, cena;

   c_bar1=iBarShift(Symbol(),Period(),afr[na])-iBarShift(Symbol(),Period(),afr[nb]); // ���������� ��� � ������� AB
   c_bar2=iBarShift(Symbol(),Period(),afr[nb])-iBarShift(Symbol(),Period(),afr[nc]); // ���������� ��� � ������� ��
   if (afrl[na]>0)
    {
     H_L=afrh[nb]-afrl[nc]; // ������ ������� ��

     for (i=0; i<7; i++)
       {
        if (ExtFiboType==1)
          {
           mediana=line_pesavento[i]*H_L+afrl[nc];
           tangens=(mediana-afrl[na])/(c_bar1+(1-line_pesavento[i])*c_bar2);
           cena=c_bar2*line_pesavento[i]*tangens+mediana;
           nameObj=vl+i+" " + ExtComplekt+"_";
           ObjectDelete(nameObj);
           ObjectCreate(nameObj,OBJ_TREND,0,afr[na],afrl[na],afr[nc],cena);
           ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" "+vl+" "+DoubleToStr(line_pesavento[i]*100,1)+"");
          }
        else
          {
           mediana=line_fibo[i]*H_L+afrl[nc];
           tangens=(mediana-afrl[na])/(c_bar1+(1-line_fibo[i])*c_bar2);
           cena=c_bar2*line_fibo[i]*tangens+mediana;
           nameObj=vl+i+" " + ExtComplekt+"_";
           ObjectDelete(nameObj);
           ObjectCreate(nameObj,OBJ_TREND,0,afr[na],afrl[na],afr[nc],cena);
           ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" "+vl+" "+DoubleToStr(line_fibo[i]*100,1)+"");
          }
        ObjectSet(nameObj,OBJPROP_COLOR,color_line);
        ObjectSet(nameObj,OBJPROP_STYLE,ExtVLStyle);
        ObjectSet(nameObj,OBJPROP_WIDTH,ExtVLWidth);
       }
    }
   else
    {
     H_L=afrh[nc]-afrl[nb]; // ������ ������� ��

     for (i=0; i<7; i++)
       {
        if (ExtFiboType==1)
          {
           mediana=afrh[nc]-line_pesavento[i]*H_L;
           tangens=(afrh[na]-mediana)/(c_bar1+(1-line_pesavento[i])*c_bar2);
           cena=mediana-c_bar2*line_pesavento[i]*tangens;
           nameObj=vl+i+" " + ExtComplekt+"_";
           ObjectDelete(nameObj);
           ObjectCreate(nameObj,OBJ_TREND,0,afr[na],afrh[na],afr[nc],cena);
           ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" "+vl+" "+DoubleToStr(line_pesavento[i]*100,1)+"");
          }
        else
          {
           mediana=afrh[nc]-line_fibo[i]*H_L;
           tangens=(afrh[na]-mediana)/(c_bar1+(1-line_fibo[i])*c_bar2);
           cena=mediana-c_bar2*line_fibo[i]*tangens;
           nameObj=vl+i+" " + ExtComplekt+"_";
           ObjectDelete(nameObj);
           ObjectCreate(nameObj,OBJ_TREND,0,afr[na],afrh[na],afr[nc],cena);
           ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" "+vl+" "+DoubleToStr(line_fibo[i]*100,1)+"");
          }
        ObjectSet(nameObj,OBJPROP_COLOR,color_line);
        ObjectSet(nameObj,OBJPROP_STYLE,ExtVLStyle);
        ObjectSet(nameObj,OBJPROP_WIDTH,ExtVLWidth);
       }
    }
  }
//--------------------------------------------------------
// Versum Levels. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ��� ������� �����������. ������.
//--------------------------------------------------------
void screenPitchforkS()
  {
   int i, i_APm=0, count_APm=0;
   double a1,b1,c1,ab1,bc1,ab2,bc2,tangens,n1,cl1,ch1,cena,wr,wr1,wr2;
   datetime ta1,tb1,tc1,tab2,tbc2,tcl1,tch1,twr1,twr2;
   int    a0,b0,c0;
   int    i_AM, i_period, tf, k_AM, const_AM, hl, i_tf;
   datetime end, time_AM[3];
   double cena_AM[3];
   bool exit_tf, end_tf[3];
   int    pitch_time[]={0,0,0}; 
   double pitch_cena[]={0,0,0};
   double TLine, m618=phi-1, m382=2-phi;
   bool   moveAP=false;
   string txt="";
   if (ExtCustomStaticAP)
     {
      if (ObjectFind(nameCheckLabel)==0)
        {
         // �������� ��������� ���������� ����� APm
         if (ObjectGet(nameCheckLabel,OBJPROP_XDISTANCE)!=vX || ObjectGet(nameCheckLabel,OBJPROP_YDISTANCE)!=vY)
           {
            if (ObjectFind(nameCheckLabel_hidden)==0)
              {
               i_APm=StrToInteger(StringSubstr(ObjectDescription(nameCheckLabel_hidden),0,1));
               count_APm=StrToInteger(StringSubstr(ObjectDescription(nameCheckLabel_hidden),2));
               count_APm--;

               if (count_APm<1) txt=""+i_APm+"_"+i_APm; else txt=""+i_APm+"_"+count_APm;
               ObjectSetText(nameCheckLabel_hidden,txt);
              }

            if (count_APm<1)
              {
               ObjectDelete(nameCheckLabel);
               ObjectCreate(nameCheckLabel,OBJ_LABEL,0,0,0);

               ObjectSetText(nameCheckLabel,"APm");
               ObjectSet(nameCheckLabel, OBJPROP_FONTSIZE, 10);
               ObjectSet(nameCheckLabel, OBJPROP_COLOR, Red);

               ObjectSet(nameCheckLabel, OBJPROP_CORNER, 1);
               ObjectSet(nameCheckLabel, OBJPROP_XDISTANCE, vX);
               ObjectSet(nameCheckLabel, OBJPROP_YDISTANCE, vY);
              }

           if (ObjectFind("pitchforkS" + ExtComplekt+"_")==0) {moveAP=true; nameObj="pitchforkS" + ExtComplekt+"_";}
           if (ObjectFind("pitchforkS" + ExtComplekt+"_APm_")==0) {moveAP=true; nameObj="pitchforkS" + ExtComplekt+"_APm_";}
          }
        else
          {
           if (ObjectFind("pitchforkS" + ExtComplekt+"_APm_")==0) return;
          }
        }
      else
        {
         ObjectCreate(nameCheckLabel,OBJ_LABEL,0,0,0);

         ObjectSetText(nameCheckLabel,"APm");
         ObjectSet(nameCheckLabel, OBJPROP_FONTSIZE, 10);
         ObjectSet(nameCheckLabel, OBJPROP_COLOR, Red);

         ObjectSet(nameCheckLabel, OBJPROP_CORNER, 1);
         ObjectSet(nameCheckLabel, OBJPROP_XDISTANCE, vX);
         ObjectSet(nameCheckLabel, OBJPROP_YDISTANCE, vY);
        }
     }

   if (moveAP)
     {
      mPitchCena[0]=ObjectGet(nameObj,OBJPROP_PRICE1);
      mPitchCena[1]=ObjectGet(nameObj,OBJPROP_PRICE2);
      mPitchCena[2]=ObjectGet(nameObj,OBJPROP_PRICE3);
      mPitchTime[0]=ObjectGet(nameObj,OBJPROP_TIME1);
      mPitchTime[1]=ObjectGet(nameObj,OBJPROP_TIME2);
      mPitchTime[2]=ObjectGet(nameObj,OBJPROP_TIME3);
      if (AutoMagnet)
        {
         for (i=0;i<3;i++) {cena_AM[i]=0;time_AM[i]=0;period_AM[i]=Period();end_tf[i]=true;}
      // ��������/��������� ��������� ����� ��� AutoMagnet
         txt=StringSubstr("0000"+Period(),StringLen("0000"+Period())-5,5)+"00000000000";
         if (!ObjectFind(nameMagnet[0])==0)
           {
            ObjectCreate(nameMagnet[0],OBJ_TEXT,0,0,0);
            ObjectSet(nameMagnet[0], OBJPROP_COLOR, CLR_NONE);
            ObjectSetText(nameMagnet[0],txt);

            ObjectCreate(nameMagnet[1],OBJ_TEXT,0,0,0);
            ObjectSet(nameMagnet[1], OBJPROP_COLOR, CLR_NONE);
            ObjectSetText(nameMagnet[1],txt);

            ObjectCreate(nameMagnet[2],OBJ_TEXT,0,0,0);
            ObjectSet(nameMagnet[2], OBJPROP_COLOR, CLR_NONE);
            ObjectSetText(nameMagnet[2],txt);
           }
         else
           {
            for (i_AM=0;i_AM<3;i_AM++)
              {
               period_AM[i_AM]=StrToInteger(StringSubstr(ObjectDescription(nameMagnet[i_AM]),0,5));
               cena_AM[i_AM]=StrToDouble(StringSubstr(ObjectDescription(nameMagnet[i_AM]),14,10));
               time_AM[i]=StrToTime(StringSubstr(ObjectDescription(nameMagnet[i_AM]),5,10));
               if (mPitchCena[i_AM]==cena_AM[i_AM] && mPitchTime[i_AM]==time_AM[i_AM]) end_tf[i_AM]=false;
              }
           }

         for (i_AM=0;i_AM<3;i_AM++)
           {
            if (!end_tf[i_AM]) continue;
            const_AM=AMBars*2+1;
            hl=0;
            k_AM=iBarShift(Symbol(),period_AM[i_AM],mPitchTime[i_AM],false);

            // ����� ���������� �� ��� ����������, �� ������� �������� ����� APm
            if (mPitchCena[i_AM]>=iHigh(Symbol(),period_AM[i_AM],k_AM))
              {
               mPitchCena[i_AM]=0;
               hl=1;
               for(k_AM=k_AM+AMBars;const_AM>0;const_AM--)
                 {
                  if (iHigh(Symbol(),period_AM[i_AM],k_AM)>mPitchCena[i_AM])
                    {
                     mPitchCena[i_AM]=iHigh(Symbol(),period_AM[i_AM],k_AM);
                     mPitchTime[i_AM]=iTime(Symbol(),period_AM[i_AM],k_AM);
                    }
                  k_AM--;
                 }
              }
            else if (mPitchCena[i_AM]<=iLow(Symbol(),period_AM[i_AM],k_AM))
              {
               mPitchCena[i_AM]=1000000;
               hl=2;
               for(k_AM=k_AM+AMBars;const_AM>0;const_AM--)
                 {
                  if (iLow(Symbol(),period_AM[i_AM],k_AM)<mPitchCena[i_AM] && iLow(Symbol(),period_AM[i_AM],k_AM)>0)
                    {
                     mPitchCena[i_AM]=iLow(Symbol(),period_AM[i_AM],k_AM);
                     mPitchTime[i_AM]=iTime(Symbol(),period_AM[i_AM],k_AM);
                    }
                  k_AM--;
                 }
              }

            // ����� ���������� �� ���������� ��������� ����������
            if (hl>0)
              {
               exit_tf=false;
               for (i_period=0;i_period<period_AM[i_AM];i_period++)
                 {
                  switch (i_period)
                    {
                     case 0: {tf=1; break;}
                     case 1: {tf=5; break;}
                     case 2: {tf=15; break;}
                     case 3: {tf=30; break;}
                     case 4: {tf=60; break;}
                     case 5: {tf=240; break;}
                     case 6: {tf=1440; break;}
                     case 7: {tf=10080; break;}
                     case 8: {tf=43200;}
                    }

                  k_AM=iBarShift(Symbol(),tf,mPitchTime[i_AM],false);
                  end=mPitchTime[i_AM]+period_AM[i_AM]*60;
                  if (hl==1)
                    {
                     for (i_tf=k_AM;iTime(Symbol(),tf,i_tf)<=end;i_tf--)
                       {
                        if (iHigh(Symbol(),tf,i_tf)>=mPitchCena[i_AM])
                          {
                           mPitchTime[i_AM]=iTime(Symbol(),tf,i_tf);
                           exit_tf=true;
                           break;
                          }
                       }
                    }
                  else
                    {
                     for (i_tf=k_AM;iTime(Symbol(),tf,i_tf)<=end;i_tf--)
                       {
                         if (iLow(Symbol(),tf,i_tf)<=mPitchCena[i_AM] && iLow(Symbol(),tf,i_tf)>0)
                          {
                           mPitchTime[i_AM]=iTime(Symbol(),tf,i_tf);
                           exit_tf=true;
                           break;
                          }
                      }
                    }

                  if (exit_tf)
                    {
                     ObjectSetText(nameMagnet[i_AM],StringSubstr("0000"+tf,StringLen("0000"+tf)-5,5)+StringSubstr("000000000"+mPitchTime[i_AM],StringLen("000000000"+mPitchTime[i_AM])-10,1010)+""+mPitchCena[i_AM]);
                     break;
                    }
                 }
              }
           }
        }
     }
   else
     {
      if (ExtPitchforkCandle)
        {
         if (iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)==0)
           {
            if (ExtPitchfork_1_HighLow)
              {
               mPitchCena[2]=High[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)];
              }
            else
              {
               mPitchCena[2]=Low[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)];
              }
           }

         cena=mPitchCena[0];
         if (ExtPitchfork_1_HighLow)
           {
            if (ExtCM_0_1A_2B_Static==1)
              {
               cena=mPitchCena[0]-(mPitchCena[0]-mPitchCena[1])*ExtCM_FiboStatic;
              }
            else if (ExtCM_0_1A_2B_Static==4)
              {
               mPitchTimeSave=mPitchTime[0];
               mPitchTime[0]=mPitchTime[1];
               if (maxGipotenuza4(mPitchTime,mPitchCena))
                 {
                  cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
                 }
               else
                 {
                  cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
                 }
              }
            else if (ExtCM_0_1A_2B_Static==5)
              {
               mPitchTimeSave=mPitchTime[0];
               mPitchTime[0]=mPitchTime[1];
               if (maxGipotenuza5(mPitchTime,mPitchCena))
                 {
                  cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
                 }
               else
                 {
                  cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
                 }
              }
            else if (ExtCM_0_1A_2B_Static>1)
              {
               if (ExtCM_0_1A_2B_Static==2) mPitchTime[0]=mPitchTime[1];
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*ExtCM_FiboStatic;
              }
           }
         else
           {
            if (ExtCM_0_1A_2B_Static==1)
              {
               cena=mPitchCena[0]+(mPitchCena[1]-mPitchCena[0])*ExtCM_FiboStatic;
              }
            else if (ExtCM_0_1A_2B_Static==4)
              {
               mPitchTimeSave=mPitchTime[0];
               mPitchTime[0]=mPitchTime[1];
               if (maxGipotenuza4(mPitchTime,mPitchCena))
                 {
                  cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
                 }
               else
                 {
                  cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
                 }
              }
            else if (ExtCM_0_1A_2B_Static==5)
              {
               mPitchTimeSave=mPitchTime[0];
               mPitchTime[0]=mPitchTime[1];
               if (maxGipotenuza5(mPitchTime,mPitchCena))
                 {
                  cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
                 }
               else
                 {
                  cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
                 }
              }
            else if (ExtCM_0_1A_2B_Static>1)
              {
               if (ExtCM_0_1A_2B_Static==2) mPitchTime[0]=mPitchTime[1];
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*ExtCM_FiboStatic;
              }
           }
        }
      else
        {
         mPitchTime[0]=afr[mPitch[0]]; mPitchTime[1]=afr[mPitch[1]]; mPitchTime[2]=afr[mPitch[2]];

         if (mPitchTime[0]==0) return;

         if (afrl[mPitch[0]]>0)
           {
            cena=afrl[mPitch[0]]; 
            mPitchCena[1]=afrh[mPitch[1]]; mPitchCena[2]=afrl[mPitch[2]];
            if (ExtCM_0_1A_2B_Static==1)
              {
               cena=mPitchCena[0]+(mPitchCena[1]-mPitchCena[0])*ExtCM_FiboStatic;
              }
            else if (ExtCM_0_1A_2B_Static==4)
              {
               mPitchTimeSave=mPitchTime[0];
               mPitchTime[0]=mPitchTime[1];
               if (maxGipotenuza4(mPitchTime,mPitchCena))
                 {
                  cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
                 }
               else
                 {
                  cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
                 }
              }
            else if (ExtCM_0_1A_2B_Static==5)
              {
               mPitchTimeSave=mPitchTime[0];
               mPitchTime[0]=mPitchTime[1];
               if (maxGipotenuza5(mPitchTime,mPitchCena))
                 {
                  cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
                 }
               else
                 {
                  cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
                 }
              }
            else if (ExtCM_0_1A_2B_Static>1)
              {
               if (ExtCM_0_1A_2B_Static==2) mPitchTime[0]=mPitchTime[1];
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*ExtCM_FiboStatic;
              }
           }
         else
           {
            cena=afrh[mPitch[0]];
            mPitchCena[1]=afrl[mPitch[1]]; mPitchCena[2]=afrh[mPitch[2]];
            if (ExtCM_0_1A_2B_Static==1)
              {
               cena=mPitchCena[0]-(mPitchCena[0]-mPitchCena[1])*ExtCM_FiboStatic;
              }
            else if (ExtCM_0_1A_2B_Static==4)
              {
               mPitchTimeSave=mPitchTime[0];
               mPitchTime[0]=mPitchTime[1];
               if (maxGipotenuza4(mPitchTime,mPitchCena))
                 {
                  cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
                 }
               else
                 {
                  cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
                 }
              }
            else if (ExtCM_0_1A_2B_Static==5)
              {
               mPitchTimeSave=mPitchTime[0];
               mPitchTime[0]=mPitchTime[1];
               if (maxGipotenuza5(mPitchTime,mPitchCena))
                 {
                  cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
                 }
               else
                 {
                  cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
                 }
              }
            else if (ExtCM_0_1A_2B_Static>1)
              {
               if (ExtCM_0_1A_2B_Static==2) mPitchTime[0]=mPitchTime[1];
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*ExtCM_FiboStatic;
              }
           }
        }

      mPitchCena[0]=cena;
     }

   if (ExtFiboFanStatic) {ExtFiboFanStatic=false; screenFiboFanS();}

   coordinaty_1_2_mediany_AP(mPitchCena[0], mPitchCena[1], mPitchCena[2], mPitchTime[0], mPitchTime[1], mPitchTime[2], tab2, tbc2, ab1, bc1, ExtPitchforkStatic, ExtPitchforkStaticCustom);

   pitch_time[0]=tab2;pitch_cena[0]=ab1;

   // 50% ������� 
   if (ExtPitchforkStatic==2)
     {
      nameObj="pmedianaS" + ExtComplekt+"_";

      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }
  
      ObjectDelete(nameObj);
      ObjectCreate(nameObj,OBJ_TREND,0,tab2,ab1,tbc2,bc1);
      ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
      ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      if (ExtSLMStatic)
        {
         b0=iBarShift(Symbol(),Period(),mPitchTime[1]);
         c0=iBarShift(Symbol(),Period(),mPitchTime[2]);

         // �������� slm
         wr=(ObjectGetValueByShift(nameObj,c0)-mPitchCena[2])*(1-2*m382);

         //����� ���� ����� 1
         a0=c0-(c0-b0)*m382-1;
         // ����� ����� 1
         twr1=iTime(Symbol(),Period(),a0);
         // ���� ����� 1
         wr1=ObjectGetValueByShift(nameObj,a0)-wr;
         // ���������� ����� 2
         wr2=ObjectGetValueByShift(nameObj,0)-wr;
         twr2=iTime(Symbol(),Period(),0);

         nameObj="SLM382S" + ExtComplekt+"_";
         if (ExtSave)
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
           }
         ObjectDelete(nameObj);
         ObjectCreate(nameObj,OBJ_TREND,0,twr1,wr1,twr2,wr2);
         ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtSLMStaticColor);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

         //����� ���� ����� 1
         a0=c0-(c0-b0)*m618-1;
         // ����� ����� 1
         twr1=iTime(Symbol(),Period(),a0);
         // ���� ����� 1
         nameObj="pmedianaS" + ExtComplekt+"_";
         wr1=ObjectGetValueByShift(nameObj,a0)+wr;
         // ���������� ����� 2
         wr2=ObjectGetValueByShift(nameObj,0)+wr;
         twr2=iTime(Symbol(),Period(),0);

         nameObj="SLM618S" + ExtComplekt+"_";
         if (ExtSave)
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
           }
         ObjectDelete(nameObj);
         ObjectCreate(nameObj,OBJ_TREND,0,twr1,wr1,twr2,wr2);
         ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtSLMStaticColor);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
        }

      if (ExtFSLShiffLinesStatic)
        {
         c0=iBarShift(Symbol(),Period(),mPitchTime[1]);

         // ����� ����� 1
         twr1=mPitchTime[1];
         // ���� ����� 1
         wr1=mPitchCena[1];
         // ���������� ����� 2
         nameObj="pmedianaS" + ExtComplekt+"_";
         wr2=ObjectGetValueByShift(nameObj,0)-ObjectGetValueByShift(nameObj,c0)+mPitchCena[1];
         twr2=iTime(Symbol(),Period(),0);

         nameObj="FSL Shiff Lines S" + ExtComplekt+"_";
         if (ExtSave)
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
           }
         ObjectDelete(nameObj);
         ObjectCreate(nameObj,OBJ_TREND,0,twr1,wr1,twr2,wr2);
         ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtFSLShiffLinesStaticColor);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
        }

      nameObj="1-2pmedianaS" + ExtComplekt+"_";

      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }
      ObjectDelete(nameObj);
      ObjectCreate(nameObj,OBJ_TEXT,0,tab2,ab1+3*Point);
      ObjectSetText(nameObj,"     1/2 ML",9,"Arial", ExtLinePitchforkS);
     }   

   if (ExtCustomStaticAP) nameObj="pitchforkS" + ExtComplekt+"_APm_"; else nameObj="pitchforkS" + ExtComplekt+"_";
   if (ExtSave)
     {
      if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
        {
         nameObj=nameObj + save;
        }
      else
        {
         if (mPitch[2]>0)
           {
            nameObj=nameObj + save;
           }
        }
     }

   if (ExtPitchforkStatic!=4)
     {
      pitch_time[0]=mPitchTime[0];pitch_cena[0]=mPitchCena[0];
      if (ExtPitchforkStatic==3) pitch_cena[0]=ab1;
     }
   pitch_time[1]=mPitchTime[1];pitch_cena[1]=mPitchCena[1];
   pitch_time[2]=mPitchTime[2];pitch_cena[2]=mPitchCena[2];

   // ����� ����� � ����� �������
   mAPs=false;
   if (ObjectFind(nameObj)>=0)
     {
      if (mAP)
        {
         if (ObjectGet(nameObj,OBJPROP_TIME1)!=pitch_time[0] || ObjectGet(nameObj,OBJPROP_PRICE1)!=pitch_cena[0] ||
             ObjectGet(nameObj,OBJPROP_TIME2)!=pitch_time[1] || ObjectGet(nameObj,OBJPROP_PRICE2)!=pitch_cena[1] ||
             ObjectGet(nameObj,OBJPROP_TIME3)!=pitch_time[2] || ObjectGet(nameObj,OBJPROP_PRICE3)!=pitch_cena[2] ||
             ExtCustomStaticAP) {mAPs=true; RZs=-1;}
        } 

      ObjectDelete(nameObj);
     }
   else if (mAP) {mAPs=true; RZs=-1;}

   if (AutoTestRedZone && !ExtCustomStaticAP && !ExtPitchforkCandle)
     {
      if (afr[mPitch[2]-1]>0)
        {
         pitch_timeRZ[0]=afr[mPitch[0]-1];
         pitch_timeRZ[1]=afr[mPitch[1]-1];
         pitch_timeRZ[2]=afr[mPitch[2]-1];
         if (afrl[mPitch[0]-1]>0)
           {
            pitch_cenaRZ[0]=afrl[mPitch[0]-1];
            pitch_cenaRZ[1]=afrh[mPitch[1]-1];
            pitch_cenaRZ[2]=afrl[mPitch[2]-1];
           }
         else
           {
            pitch_cenaRZ[0]=afrh[mPitch[0]-1];
            pitch_cenaRZ[1]=afrl[mPitch[1]-1];
            pitch_cenaRZ[2]=afrh[mPitch[2]-1];
           }
        }
     }

   if (mOutRedZone && mAuto_s)
     {
      pitch_timeS[0]=pitch_time[0];
      pitch_timeS[1]=pitch_time[1];
      pitch_timeS[2]=pitch_time[2];

      pitch_cenaS[0]=pitch_cena[0];
      pitch_cenaS[1]=pitch_cena[1];
      pitch_cenaS[2]=pitch_cena[2];

      aOutRedZone[1]=false;
      _RZ("RZS", ExtRZStaticValue, ExtRZStaticColor, pitch_timeS, pitch_cenaS, ExtRedZoneStatic, 0, false);
     }

   ObjectCreate(nameObj,OBJ_PITCHFORK,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1],pitch_time[2],pitch_cena[2]);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtPitchforkStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtPitchforkWidth);
   ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   if (ExtMasterPitchfork==2)
     {
      nameObjAPMaster="Master_"+nameObj;
      ObjectDelete(nameObjAPMaster);
      ObjectCreate(nameObjAPMaster,OBJ_PITCHFORK,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1],pitch_time[2],pitch_cena[2]);
      ObjectSet(nameObjAPMaster,OBJPROP_STYLE,ExtPitchforkStyle);
      ObjectSet(nameObjAPMaster,OBJPROP_WIDTH,ExtPitchforkWidth);
      ObjectSet(nameObjAPMaster,OBJPROP_COLOR,CLR_NONE);
      ObjectSet(nameObjAPMaster,OBJPROP_BACK,true);
     }

   if (ExtFiboFanMedianaStaticColor>0)
     {
      coordinaty_mediany_AP(pitch_cena[0], pitch_cena[1], pitch_cena[2], pitch_time[0], pitch_time[1], pitch_time[2], tb1, b1);      

      nameObj="FanMedianaStatic" + ExtComplekt+"_";
/*
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }
*/
      ObjectDelete(nameObj);

      ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
      ObjectCreate(nameObj,OBJ_FIBOFAN,0,pitch_time[0],pitch_cena[0],tb1,b1);
      ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DASH);
      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanMedianaStaticColor);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      if (ExtFiboType==0)
        {
         screenFibo_st();
        }
      else if (ExtFiboType==1)
        {
         screenFibo_Pesavento();
        }
      else if (ExtFiboType==2)
        {
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
         for (i=0;i<Sizefi;i++)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
            ObjectSetFiboDescription(nameObj, i, fitxt100[i]); 
           }
        }
     }
//-------------------------------------------------------

   if (ExtUTL)
     {
      nameObj=nameUTL;
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }

      ObjectDelete(nameObj);
      if (pitch_cena[1]>pitch_cena[2])
        {
         ObjectCreate(nameObj,OBJ_TREND,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1]);
        }
      else
        {
         ObjectCreate(nameObj,OBJ_TREND,0,pitch_time[0],pitch_cena[0],pitch_time[2],pitch_cena[2]);
        }
      ObjectSet(nameObj,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
     }

   if (ExtPivotZoneStaticColor>0 && ExtPitchforkStatic<4) PivotZone(pitch_time, pitch_cena, ExtPivotZoneStaticColor, "PivotZoneS");

   if (ExtLTL)
     {
      nameObj=nameLTL;
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }

      ObjectDelete(nameObj);
      if (pitch_cena[1]>pitch_cena[2])
        {
         ObjectCreate(nameObj,OBJ_TREND,0,pitch_time[0],pitch_cena[0],pitch_time[2],pitch_cena[2]);
        }
      else
        {
         ObjectCreate(nameObj,OBJ_TREND,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1]);
        }
      ObjectSet(nameObj,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
     }
//-------------------------------------------------------

   if (ExtUWL || ExtLWL)
     {
      n1=iBarShift(Symbol(),Period(),pitch_time[0])-(iBarShift(Symbol(),Period(),pitch_time[1])+iBarShift(Symbol(),Period(),pitch_time[2]))/2.0;
      ta1=pitch_time[0];
      tb1=Time[0];
      a1=pitch_cena[0];
      tangens=(pitch_cena[0]-(pitch_cena[1]+pitch_cena[2])/2.0)/n1;
      b1=pitch_cena[0]-tangens*iBarShift(Symbol(),Period(),pitch_time[0]);

      ML_RL400(tangens, pitch_cena, pitch_time, tb1, b1, false);

      if (pitch_cena[1]>pitch_cena[2])
        {
         if (ExtUWL)
           {
            ch1=pitch_cena[1];
            tch1=pitch_time[1];
           }
         if (ExtLWL)
           {
            cl1=pitch_cena[2];
            tcl1=pitch_time[2];
           }
        }
      else
        {
         if (ExtUWL)
           {
            ch1=pitch_cena[2];
            tch1=pitch_time[2];
           }
         if (ExtLWL)
           {
            cl1=pitch_cena[1];
            tcl1=pitch_time[1];
           }
        }

      if (ExtUWL)
        {
         nameObj=nameUWL;
         if (ExtSave)
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
           }
  
         ObjectDelete(nameObj);

         ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tch1,ch1);
         ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtLinePitchforkS);
         ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
         ObjectSet(nameObj,OBJPROP_RAY,ExtLongWL);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
         ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);

         UWL_LWL (ExtVisibleUWL,nameObj,"UWL ",ExtFiboFreeUWL);
        }

      if (ExtLWL)
        {
         nameObj=nameLWL;
         if (ExtSave)
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
           }

         ObjectDelete(nameObj);

         ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tcl1,cl1);
         ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtLinePitchforkS);
         ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
         ObjectSet(nameObj,OBJPROP_RAY,ExtLongWL);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
         ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);

         UWL_LWL (ExtVisibleLWL,nameObj,"LWL ",ExtFiboFreeLWL);
        }

     }

//-------------------------------------------------------

   if (ExtPitchforkStaticColor>0)
     {

      n1=iBarShift(Symbol(),Period(),pitch_time[0])-(iBarShift(Symbol(),Period(),pitch_time[1])+iBarShift(Symbol(),Period(),pitch_time[2]))/2.0;
   
      TLine=pitch_cena[1]-iBarShift(Symbol(),Period(),pitch_time[1])*(pitch_cena[0]-(pitch_cena[2]+pitch_cena[1])/2)/n1;

      nameObj="CL" + ExtComplekt+"_";
/*
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }
*/
      ObjectDelete(nameObj);

      ObjectCreate(nameObj,OBJ_CHANNEL,0,pitch_time[1],pitch_cena[1],Time[0],TLine,pitch_time[2],pitch_cena[2]);
      ObjectSet(nameObj, OBJPROP_BACK, true);
      ObjectSet(nameObj, OBJPROP_COLOR, ExtPitchforkStaticColor); 
     }
//-------------------------------------------------------
   if (ExtISLChannelStaticColor>0)
     {
      channelISL(pitch_cena[0], pitch_cena[1], pitch_cena[2], pitch_time[0], pitch_time[1], pitch_time[2], 0);
     }
//-------------------------------------------------------

   if (ExtISLStatic)
     {
      _ISL("ISL_S", pitch_time, pitch_cena, ExtLinePitchforkS, ExtISLStyleStatic, 0, "");
     }

//-------------------------------------------------------

   if (ExtRLStatic)
     {
      _RL("RLineS", pitch_time, pitch_cena, ExtLinePitchforkS, ExtRLStyleStatic, ExtVisibleRLStatic, 0, "");
     }
//-------------------------------------------------------

   if (ExtRedZoneStatic>0)
     {
      _RZ("RZS", ExtRZStaticValue, ExtRZStaticColor, pitch_time, pitch_cena, ExtRedZoneStatic, 0, true);
     }
//--------------------------------------------------------
   // ��������� ���� ���� � ������� ����������� ��� �������
   fiboTimeX ();

   if (ExtCustomStaticAP)
     {
      if (mAPs || mAPd)
        {
         metkaAP(true);  // �������� ����� � ����� �������
        }

      i_APm=0;
      for (i=ObjectsTotal()-1; i>=0; i--)
       {
         txt=ObjectName(i);
         // ������� ����������� ��� � ������ APm
         if (ObjectType(txt)==OBJ_PITCHFORK)
           {
            if (StringFind(txt,"_APm",0)>0) i_APm++;
           }
        }

      ObjectDelete(nameCheckLabel_hidden);
      if (i_APm>1)
        {
         count_APm=StrToInteger(StringSubstr(ObjectDescription(nameCheckLabel_hidden),2));
         if (count_APm<1) txt=""+i_APm+"_"+i_APm; else txt=""+i_APm+"_"+count_APm;

         ObjectCreate(nameCheckLabel_hidden,OBJ_TEXT,0,0,0);

         ObjectSetText(nameCheckLabel_hidden,txt);
         ObjectSet(nameCheckLabel_hidden, OBJPROP_COLOR, CLR_NONE);
         ObjectSet(nameCheckLabel_hidden, OBJPROP_BACK, true);
        }
    }
  }
//--------------------------------------------------------
// ����� ��� ������� �����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ������� ����� (metkaAP) � ����� �������.
// ����������. ����� ���. ������.
//--------------------------------------------------------
void metkaAP(bool create)
  {
   color  mclr;
   string prefics="";
   double cena1, cena2;
   int    i;

   if (create) // �������� �����
     {
      if (mSelectVariantsPRZ==0)
        {
         for (i=0;i<2;i++)
           {
            if (i==0 && mAPs)
              {
               if (_ExtPitchforkStatic==0) continue;
               if (!mStart)
                 {
                  if (mOutRedZone && !aOutRedZone[1] && mAuto_s) continue;
                 }
               _metkaAP(arrm_s, i, mAuto_s, 0);
              }
            else if (i==1 && mAPd)
              {
               if (ExtPitchforkDinamic==0) continue;
               if (!mStart)
                 {
                  if (mOutRedZone && !aOutRedZone[0] && mAuto_d) continue;
                 }
               _metkaAP(arrm_d, i, mAuto_d, 0);
              }
           }
        }
      else if(mSelectVariantsPRZ>0)
        {
         if (mTypeBasiclAP==0)
           {
            _metkaAP(arrm_s, 0, mAuto_s, 1);
            if (((mOutRedZone && aOutRedZone[0] && mAuto_d) || !mOutRedZone || mStart) && _ExtPitchforkStatic>0)
              {
               _metkaAP(arrm_d, 1, mAuto_d, 0);
              }
           }
         else if (mTypeBasiclAP==1)
           {
            _metkaAP(arrm_d, 1, mAuto_d, 1);
            if (((mOutRedZone && aOutRedZone[1] && mAuto_s) || !mOutRedZone || mStart) && ExtPitchforkDinamic>0)
              {
               _metkaAP(arrm_s, 0, mAuto_s, 0);
              }
           }
        }

      mAPs=false;
      mAPd=false;
     }
   else // ����� �������������� ����� ��� ������ ���� ����� �� ������� ����� �� ������� ����
     {
      if (mSelectVariantsPRZ==0)
        {
         if (mAuto_s)
           {
            if (((mOutRedZone && aOutRedZone[1] && mAuto_s) || !mOutRedZone) && _ExtPitchforkStatic>0) new_metkaAP(arrm_s, 0, mAuto_s);
           }

         if (mAuto_d)
           {
            if (((mOutRedZone && aOutRedZone[0] && mAuto_d) || !mOutRedZone) && ExtPitchforkDinamic>0) new_metkaAP(arrm_d, 1, mAuto_d);
           }
        }
      else if(mSelectVariantsPRZ>0)
        {
         if (mTypeBasiclAP==0)
           {
            if (mAuto_d)
              {
               if (((mOutRedZone && aOutRedZone[0] && mAuto_d) || !mOutRedZone) && ExtPitchforkDinamic>0) new_metkaAP(arrm_d, 1, mAuto_d);
              }
           }
         else if (mTypeBasiclAP==1)
           {
            if (mAuto_s)
              {
               if (((mOutRedZone && aOutRedZone[1] && mAuto_s) || !mOutRedZone) && _ExtPitchforkStatic>0) new_metkaAP(arrm_s, 0, mAuto_s);
              }
           }
        }
     }

   // ������� ����� �����
   prefics="m#"+ExtComplekt+"_";
   for (i=ObjectsTotal()-1;i>=0;i--)
     {
      nameObj=ObjectName(i);
      if (StringFind(nameObj,prefics)>-1)
        {
         if (ObjectType(nameObj)==OBJ_ARROW)
           {
            cena1=ObjectGet(nameObj,OBJPROP_PRICE1);
            if (iClose(NULL,Period(),0)<cena1) mclr=mColorUP;
            else if (iClose(NULL,Period(),0)>cena1) mclr=mColorDN;
            else mclr=mColor;
           }
         else if (ObjectType(nameObj)==OBJ_RECTANGLE || ObjectType(nameObj)==OBJ_TREND)
           {
            cena1=ObjectGet(nameObj,OBJPROP_PRICE1);
            cena2=ObjectGet(nameObj,OBJPROP_PRICE2);
            if (iClose(NULL,Period(),0)<cena1 && iClose(NULL,Period(),0)<cena2) mclr=mColorRectangleUP;
            else if (iClose(NULL,Period(),0)>cena1 && iClose(NULL,Period(),0)>cena2) mclr=mColorRectangleDN;
            else mclr=mColor;
           }
         if (!mPivotPointsChangeColor)
           {
            if (StringFind(nameObj,prefics+"s"+" point")>-1 || StringFind(nameObj,prefics+"d"+" point")>-1) continue;
           }
         ObjectSet(nameObj,OBJPROP_COLOR,mclr);
        }
     }

   WindowRedraw();
  }
//--------------------------------------------------------
// ����� ������� ����� (metkaAP) � ����� �������.
// ����������. ����� ���. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� �������������� ������� ����� � ����� �������.
// ������.
//--------------------------------------------------------
void new_metkaAP(double& arrm[][], int sd, bool mAuto)
  {
   int      i_1, i_2, i_x, ii, n, j, a1, b1, c1;
   double   tangensAP, tangensUTL, tangensLTL;
   double   pitch_cena[]={0,0,0};
   datetime pitch_time[]={0,0,0};
   string   prefics="";
   string   wl="", tmp="", file="", nameObj="";
   int      handle=-1;
   bool     writetofile=false;
   string   _nameUWL="", _nameLWL="", _nameUTL="", _nameLTL="";
   bool     exitSL = false; // ���� ��� ������ ��������� mExitFSL_SSL

   if (mAuto) exitSL=mExitFSL_SSL || Close[0]>=aexitFSL_SSL[1] || Close[0]<=aexitFSL_SSL[0]; else exitSL=true;
   if (sd==0) file="\\Price Label S\\";
   if (sd==1) file="\\Price Label D\\";

   if (sd==0)
     {
      _nameUWL=nameUWL;
      _nameLWL=nameLWL;
      _nameUTL=nameUTL;
      _nameLTL=nameLTL;
     }
   else
     {
      _nameUWL=nameUWLd;
      _nameLWL=nameLWLd;
      _nameUTL=nameUTLd;
      _nameLTL=nameLTLd;
     }

   if (anum_cena[sd][0]>0 && anum_cena[sd][1]<ArrayRange(arrm,0)-1)
     {
      if (arrm[anum_cena[sd][0]][0]>=iClose(NULL,Period(),0)) // �������
        {
         i_1=anum_cena[sd][0]-1;
         i_x=i_1;
         if (arrm[i_1][0]>0)
           {
            anum_cena[sd][0]=i_1;
           }
         else return;
        }
      else if (arrm[anum_cena[sd][1]][0]<=iClose(NULL,Period(),0)) // ��������
        {
         i_2=anum_cena[sd][1]+1;
         i_x=i_2;
         if (arrm[i_2][0]>0)
           {
            anum_cena[sd][1]=i_2;
           }
         else return;
        }
      else return;

      ii=arrm[i_x][5];
      if (!exitSL && ii>10) return;

      // ������� �������������� �����
      if (sd==0)
        {
         if (ExtCustomStaticAP) nameObj="pitchforkS" + ExtComplekt+"_APm_"; else nameObj="pitchforkS" + ExtComplekt+"_";
         prefics="m#"+ExtComplekt+"_"+"s ";        //������ ��������
        }
      else if (sd==1)
        {
         nameObj="pitchforkD" + ExtComplekt+"_"; 
         prefics="m#"+ExtComplekt+"_"+"d ";
        }

      // ���������� ����� � ���� �����, � ������� ��������� (�������) ���� �������
      pitch_time[0]=ObjectGet(nameObj,OBJPROP_TIME1); pitch_cena[0]=ObjectGet(nameObj,OBJPROP_PRICE1);
      pitch_time[1]=ObjectGet(nameObj,OBJPROP_TIME2); pitch_cena[1]=ObjectGet(nameObj,OBJPROP_PRICE2);
      pitch_time[2]=ObjectGet(nameObj,OBJPROP_TIME3); pitch_cena[2]=ObjectGet(nameObj,OBJPROP_PRICE3);

      // ���������� ������ �����, � ������� ��������� ���� �������
      a1=iBarShift(NULL,Period(),pitch_time[0],false);
      b1=iBarShift(NULL,Period(),pitch_time[1],false);
      c1=iBarShift(NULL,Period(),pitch_time[2],false);

      tangensAP=atg[sd][0];
      atg[sd][3]=tangensUTL;
      atg[sd][4]=tangensLTL;

      // ��������� ���� ��� ������ �����
      if (mWriteToFile)
        {
//         if (mPeriod<TimeCurrent())
           {
            tmp="_";
            if (ExtMasterPitchfork>0)
              {
               tmp="_0_";
              }
            else
              {
               if (SlavePitchfork) tmp="_"+StringSubstr(""+ExtComplekt,StringLen(""+ExtComplekt)-1)+"_";
               else
                 {
                  j=ObjectsTotal();
                  for (n=0; n<j; n++)
                    {
                     if (ObjectType(ObjectName(n))==OBJ_PITCHFORK)
                       {
                        if (StringFind(ObjectName(n),"Master_",0)>=0)
                          {
                           tmp="_"+StringSubstr(""+ExtComplekt,StringLen(""+ExtComplekt)-1)+"_";
                           break;
                          }
                       }
                    }
                 }
              }

            writetofile=true;
            if (ExtIndicator==6 && GrossPeriod==Period()) file=file+Symbol()+"_"+GrossPeriod+tmp+ExtComplekt+".csv";
            else file=file+Symbol()+"_"+Period()+tmp+ExtComplekt+".csv";
            handle=FileOpen(file,FILE_CSV | FILE_READ | FILE_WRITE,';');
           }
        }

      if (ii==11 && mAuto && ObjectFind(_nameUTL)<0) visibleTL(pitch_cena, pitch_time, 11, sd);// UTL
      if (ii==12 && mAuto && ObjectFind(_nameLTL)<0) visibleTL(pitch_cena, pitch_time, 12, sd);// LTL

      if (ii>12) wl=DoubleToStr(arrm[i_x][6],3); else wl="";
      if (ii==13 && mAuto && ObjectFind(_nameUWL)<0) // UWL
        {
         if (ObjectFind(_nameUTL)<0) visibleTL(pitch_cena, pitch_time, 11, sd);// UTL
         if (sd==0)
           {
            visibleWL(pitch_cena, pitch_time, pitch_cena[0], pitch_time[0], pitch_cena[0]-tangensAP*a1, iTime(Symbol(),Period(),0), 13, sd, "", tangensAP, ExtLinePitchforkS, true);
           }
         else
           {
            visibleWL(pitch_cena, pitch_time, pitch_cena[0], pitch_time[0], pitch_cena[0]-tangensAP*a1, iTime(Symbol(),Period(),0), 13, sd, "", tangensAP, ExtLinePitchforkD, true);
           }
        }

      if (ii==14 && mAuto && ObjectFind(nameLWL)<0) // LWL
        {
         if (ObjectFind(_nameLTL)<0) visibleTL(pitch_cena, pitch_time, 12, sd);// LTL
         if (sd==0)
           {
            visibleWL(pitch_cena, pitch_time, pitch_cena[0], pitch_time[0], pitch_cena[0]-tangensAP*a1, iTime(Symbol(),Period(),0), 14, sd, "", tangensAP, ExtLinePitchforkS, true);
           }
         else
           {
            visibleWL(pitch_cena, pitch_time, pitch_cena[0], pitch_time[0], pitch_cena[0]-tangensAP*a1, iTime(Symbol(),Period(),0), 14, sd, "", tangensAP, ExtLinePitchforkD, true);
           }
        }

      if (aMetki[sd][ii]==1 || aMetki[sd][ii]==0)
        {
         nameObj=prefics+atextm[ii]+wl+" x 0-bar";
         ObjectCreate(nameObj,OBJ_ARROW,0,iTime(NULL,Period(),0),arrm[i_x][0]);
         ObjectSet(nameObj,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
         ObjectSet(nameObj,OBJPROP_BACK,mBack);
         if (writetofile)
           {
            FileSeek(handle, 0, SEEK_END);
            FileWrite(handle, 0, ii, aMetki[sd][ii], 0, DoubleToStr(arrm[i_x][0], Digits), 0, DoubleToStr(iClose(NULL,Period(),0), Digits), sd,
            DoubleToStr(pitch_cena[0], Digits), DoubleToStr(pitch_cena[1], Digits), DoubleToStr(pitch_cena[2], Digits));
           }
        }
      else if (aMetki[sd][ii]>1 && arrm[i_x][4]>0)
        {
         if (aMetki[sd][ii]!=3 && aMetki[sd][ii]!=6 && aMetki[sd][ii]!=8)
           {
            nameObj=prefics+atextm[ii]+wl+" left 0-bar";
            ObjectCreate(nameObj,OBJ_ARROW,0,arrm[i_x][1],arrm[i_x][2]);
            ObjectSet(nameObj,OBJPROP_ARROWCODE,SYMBOL_LEFTPRICE);
            ObjectSet(nameObj,OBJPROP_BACK,mBack);

            nameObj=prefics+atextm[ii]+wl+" right 0-bar";
            ObjectCreate(nameObj,OBJ_ARROW,0,arrm[i_x][3],arrm[i_x][4]);
            ObjectSet(nameObj,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
            ObjectSet(nameObj,OBJPROP_BACK,mBack);
           }
 
         if (aMetki[sd][ii]>7)
           {
            nameObj=prefics+atextm[ii]+wl+" line Zones";
            ObjectCreate(nameObj,OBJ_TREND,0,arrm[i_x][1],arrm[i_x][2],arrm[i_x][3],arrm[i_x][4]);
            ObjectSet(nameObj,OBJPROP_WIDTH,mLineZonesWidth); 
            ObjectSet(nameObj,OBJPROP_RAY,false); 
            ObjectSet(nameObj,OBJPROP_BACK,mBackZones); 
           }
         else if (aMetki[sd][ii]>2 && aMetki[sd][ii]!=5)
           {
            if (aMetki[sd][ii]>5) nameObj=prefics+"Shift "+atextm[ii]+wl+" Zones"; 
            else nameObj=prefics+atextm[ii]+wl+" Zones";
            ObjectCreate(nameObj,OBJ_RECTANGLE,0,arrm[i_x][1],arrm[i_x][2],arrm[i_x][3],arrm[i_x][4]);
            ObjectSet(nameObj,OBJPROP_BACK,mBackZones);
           }

         if (writetofile)
           {
            FileSeek(handle, 0, SEEK_END);
            FileWrite(handle, 0, ii, aMetki[sd][ii], DoubleToStr(arrm[i_x][2], Digits), 0, DoubleToStr(arrm[i_x][4], Digits), DoubleToStr(iClose(NULL,Period(),0), Digits), sd,
            DoubleToStr(pitch_cena[0], Digits), DoubleToStr(pitch_cena[1], Digits), DoubleToStr(pitch_cena[2], Digits));
           }
        }

      // ��������� ���� ��� ������ �����
      if (mWriteToFile)
        {
         if (FileSize(handle)<1) {FileClose(handle); FileDelete(file);} else FileClose(handle);
        }

     }
  }
//--------------------------------------------------------
// ����� �������������� ������� ����� � ����� �������.
// �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ������� ����� (metkaAP) � ����� �������. ������.
//--------------------------------------------------------
/*
//========================================================
����� ���������� � ����
 int    mPeriodWriteToFile       = 240;
 bool   mWriteToFile             = true;

�������� ������ ����������: 

�������� ����� eurusd_1440_0.csv - � ����� ���������� ����������, ���������� � ���������� 1440 ����� (D1) ��� ���������� ExtComplekt=0

������ ����� ���������� ������������ � ����:
 
����� ������ ������������� ������� ���; �������� �����; ����� ������ �����; ���� ����� �����; ���� ����� �� ������� ����; ���� ������ �����; �������� ���� �������� �������� ���� � ������ ������ �����������; ������������ ��� (����������� ��� ������������); ���� ������ ����� �������� ���; ���� ������ ����� �������� ���; ���� ������� ����� �������� ���;

�������� �����:
1 - mSSL;
2 � mSLM382;
3 - m1_2Mediana;
4 � mSLM618;
5 - mISL382;
6 - mMediana;
7 - mISL618;
8 - mFSL;
9 - mFSLShiffLines;
10 - mCriticalPoints - ��� �������� ���������� � �������: ���� ����� �����; � ���� ������ �����; 
11 - mUTL
12 - mLTL
13 � mUWL
14 - mLWL

������ ����������� - ��� ������ � �������� �����:
m1 - 1
m5 - 5
m15 - 15
m30 - 30
h1 - 60
h4 - 240
d1 - 1440
w1 - 10080
mn - 43200
� ��� �����.

������������ ��� (����������� ��� ������������):
����������� - 0
������������ - 1 
//========================================================
����������� ���� ��������� �����

mSelectVariantsPRZ
 = 0 - ��������� ����� "������" ������� (���������) ���
 > 0 - ��������� ����� ��� ����������� ������� (�������) ��� � �������� ������
 = 1 - ����� ����������� SSL
 = 2 - ����� ����������� �������
 = 3 - ����� ����������� FSL
 = 4 - ���� ����������� ������ �������
 = 5 - ���� ����������� ������ ��� 
 = 6 - ����� ����������� 1/2 �������
 = 7 - ���� ����������� ������ 1/2 �������
 = 8 - ���� ����������� ������ ����� �����
 = 9 - ����� ����������� UTL

mTypeBasiclAP - ����� ���� ������� ���
 = 0 - ����������� ���� �� �������� ���������
 = 1 - ������������ ���� �� �������� ���������

mTypealAP - ����� ���� ������� ��� 
 = 0 - ������������ ��� ����������� ���� �������� ��������� (��������������� �������)
 = 1 - ����������� ���� �� �������� ���������
 = 2 - ����� ���� �� �������� ���������
 = 3 - ����������� ���� �� ������ ���������� ZUP � �������� �������
 = 4 - ������������ ���� �� ������ ���������� ZUP � �������� �������
 = 5 - ����� ���� �� ������ ���������� ZUP � �������� �������
 = 6 - ���� � �������� �������, ���������� �������, �� � ������� ZUP
 = 7 - ����� ������� ����

malHandAP - ������� ���������� ������������ ���, ���������� �������, ��� ������� ������ ����� ��� ����������� � ������� ������
 = 0 - ����� ����� ������ ��� ����������� � �������� � SSL/FSL ������ ���
 = 1 - ���������� ����� ������������ ���, � �������� �������� ����� �����
 = 2 - ����� ������ ����� ��� ���������� ����� ������������ ������� ���

������� ������������ �����

����� "������" ������� (���������) ���

prefics="m#"+ExtComplekt+"_"+"s ";
prefics="m#"+ExtComplekt+"_"+"d ";

����� � ����� �������� ��� �������
"point 1 AP" 
"point 2 AP" 
"point 3 AP"

����� ��� ����������� 50%-� ������� � ISL 38.2 � ��������� ���������� ������
"50% Mediana x SSL"
"50% Mediana x ISL 38.2"

����� ��� ����������� �������� ���� 50%-� �������� ��� �������
"50% Mediana x 0-bar"
"50% Mediana left 0-bar" 
"50% Mediana right 0-bar"

����� �� SLM382
"SLM 38.2 x 0-bar"
"SLM 38.2 left 0-bar"
"SLM 38.2 right 0-bar"
"Shift SLM 38.2 Zones"
"SLM 38.2 Zones"

����� �� SLM618
"SLM 61.8 x 0-bar"
"SLM 61.8 left 0-bar"
"SLM 61.8 right 0-bar"
"Shift SLM 61.8 Zones"
"SLM 61.8 Zones"

����� ��� ����������� �������� ���� ������ SSL
"SSL x 0-bar"
"SSL left 0-bar"
"SSL right 0-bar"
"Shift SSL Zones"
"SSL Zones"

����� ��� ����������� �������� ���� ������ FSL
"FSL x 0-bar"
"FSL left 0-bar"
"FSL right 0-bar"
"Shift FSL Zones"
"FSL Zones"

����� ��� ����������� �������� ���� �������� ��� �������
"Mediana x 0-bar"
"Mediana left 0-bar"
"Mediana right 0-bar"
"Shift Mediana Zones"
"Mediana Zones"

����� ��� ����������� �������� ���� ������ ISL 38.2
"ISL 38.2 x 0-bar"
"ISL 38.2 left 0-bar"
"ISL 38.2 right 0-bar"
"Shift ISL 38.2 Zones"
"ISL 38.2 Zones"

����� ��� ����������� �������� ���� ������ ISL 61.8
"ISL 61.8 x 0-bar"
"ISL 61.8 left 0-bar"
"ISL 61.8 right 0-bar"
"Shift ISL 61.8 Zones"
"ISL 61.8 Zones"

����� ��� ����������� �������� ���� ���������������� ������� LWL �/��� UWL ���������� ��� �������
ObjectGetFiboDescription(nameObj,k), ��� nameObj=nameLWL;
ObjectGetFiboDescription(nameObj,k)+" left 0-bar"
ObjectGetFiboDescription(nameObj,k)+" right 0-bar"
ObjectGetFiboDescription(nameObj,k)+" Shift Zones"
ObjectGetFiboDescription(nameObj,k)+" Zones"

ObjectGetFiboDescription(nameObj,k), ��� nameObj=nameUWL;
ObjectGetFiboDescription(nameObj,k)+" left 0-bar"
ObjectGetFiboDescription(nameObj,k)+" right 0-bar"
ObjectGetFiboDescription(nameObj,k)+" Shift Zones"
ObjectGetFiboDescription(nameObj,k)+" Zones"

����� ��� ����������� �������� ���� ������������ ������� LTL �/��� UTL ���������� ��� �������
"LTL x 0-bar"
"LTL left 0-bar" 
"LTL right 0-bar" 
"Shift LTL Zones"
"LTL Zones"

"UTL x 0-bar"
"UTL left 0-bar"
"UTL right 0-bar"
"Shift UTL Zones"
"UTL Zones"

����� ����� �������� ������ � ������� ������, ��������������� �� �������

���� ����� �����. ����� ���������. ����������� ����� ������. ��� ������������ �������������.

--

� ������� ����������� 
+"_"+"s ""+ExtComplekt - ��� ����������� ������� ���
+"_"+"d ""+ExtComplekt - ��� ������������ ������� ���
+"_"+"s ""+ExtComplekt - ��� ����������� ������� ���  -  + save

prefics="m#"+ExtComplekt+"_"+"s";
prefics="m#"+ExtComplekt+"_"+"d";


   aMetki[sd][0]=0;
   aMetki[sd][1]=mSSL;
   aMetki[sd][2]=mSLM;
   aMetki[sd][3]=m1_2Mediana;
   aMetki[sd][4]=mSLM;
   aMetki[sd][5]=mISL382;
   aMetki[sd][6]=mMediana;
   aMetki[sd][7]=mISL618;
   aMetki[sd][8]=mFSL;
   aMetki[sd][9]=mFSLShiffLines;
   aMetki[sd][10]=mCriticalPoints;
   aMetki[sd][11]=mUTL;
   aMetki[sd][12]=mLTL;
   aMetki[sd][13]=mUWL;
   aMetki[sd][14]=mLWL;

*/
void _metkaAP(double& arrm[][], int sd, bool mAuto, int VariantsPRZ)  // sd - 0 - �������������� ����������� ����, 1 - �������������� ������������ ����
  {
   int      pitch_time[]={0,0,0}; 
   double   pitch_cena[]={0,0,0};
   double   aUWL[], aLWL[];
   int      i,j,j1,k,m,n, a1=0,b1=0,c1=0,m12, x=0, y=0, z=0, symb;
   string   prefics="", str05median="", strSLM382="", strSLM618="", nameFibo="";
   string   arrName[];    // ������ ��� �������� ������������ ��� �������
   double   tangensAP=0, tangensRL=0, tangens05median=0, wr, tangensUTL=0, tangensLTL=0, arrRL[], tangens=0;
   double   cena1, cena2, cenaRL, X, Y, W, cenaUWL, cenaLWL, h=0, delta, rl1, rl2, hAP, hAP1_2mediana, bazaAP, ret, retISL, xISL=0, xret=0; // m382=2-phi, m618=phi-1;
   datetime time1, time2;
   bool     updn;
   // ���������� ��� ������������ ����� CSV
   string   file="";
   string   tmp="", str1="", str2="", str3="", strUWL="", strLWL="";
   int      handle=-1;
   bool     writetofile=false;
   string   _nameUWL="", _nameLWL="", _nameUTL="", _nameLTL="";

   bool     exitSL = false; // ���� ��� ������ ��������� mExitFSL_SSL

   if (sd==0)
     {
      _nameUWL=nameUWL;
      _nameLWL=nameLWL;
      _nameUTL=nameUTL;
      _nameLTL=nameLTL;
     }
   else
     {
      _nameUWL=nameUWLd;
      _nameLWL=nameLWLd;
      _nameUTL=nameUTLd;
      _nameLTL=nameLTLd;
     }

   nameObj="";
   if (sd==0)
     {
      if (ExtCustomStaticAP) nameObj="pitchforkS" + ExtComplekt+"_APm_"; else nameObj="pitchforkS" + ExtComplekt+"_";
      prefics="m#"+ExtComplekt+"_"+"s ";        //������ ��������
      str05median="pmedianaS";
     }
   else if (sd==1)
     {
      nameObj="pitchforkD" + ExtComplekt+"_"; 
      prefics="m#"+ExtComplekt+"_"+"d ";
      str05median="pmedianaD";
     }

   delete_objects6(sd);

   // ��������� ���� ��� ������ �����
   if (sd==0) file="\\Price Label S\\";
   if (sd==1) file="\\Price Label D\\";
   if (mWriteToFile)
     {
      if (mPeriod<TimeCurrent())
        {
         tmp="_";
         if (ExtMasterPitchfork>0)
           {
            tmp="_0_";
           }
         else
           {
            if (SlavePitchfork) tmp="_"+StringSubstr(""+ExtComplekt,StringLen(""+ExtComplekt)-1)+"_";
            else
              {
               j=ObjectsTotal();
               for (n=0; n<j; n++)
                 {
                  if (ObjectType(ObjectName(n))==OBJ_PITCHFORK)
                    {
                     if (StringFind(ObjectName(n),"Master_",0)>=0)
                       {
                        SlavePitchfork = true;
                        tmp="_"+StringSubstr(""+ExtComplekt,StringLen(""+ExtComplekt)-1)+"_";
                        break;
                       }
                    }
                 }
              }
           }

         writetofile=true;
         if (ExtIndicator==6 && GrossPeriod==Period()) file=file+Symbol()+"_"+GrossPeriod+tmp+ExtComplekt+".csv";
         else file=file+Symbol()+"_"+Period()+tmp+ExtComplekt+".csv";
         handle=FileOpen(file,FILE_CSV|FILE_WRITE,';');
        }
     }

   // ���������� ����� � ���� �����, � ������� ��������� (�������) ���� �������
   pitch_time[0]=ObjectGet(nameObj,OBJPROP_TIME1); pitch_cena[0]=ObjectGet(nameObj,OBJPROP_PRICE1);
   pitch_time[1]=ObjectGet(nameObj,OBJPROP_TIME2); pitch_cena[1]=ObjectGet(nameObj,OBJPROP_PRICE2);
   pitch_time[2]=ObjectGet(nameObj,OBJPROP_TIME3); pitch_cena[2]=ObjectGet(nameObj,OBJPROP_PRICE3);

   // ���������� ������ �����, � ������� ��������� (�������) ���� �������
   a1=iBarShift(NULL,Period(),pitch_time[0],false);
   b1=iBarShift(NULL,Period(),pitch_time[1],false);
   c1=iBarShift(NULL,Period(),pitch_time[2],false);

   // ���������, ��� �� ������������ ����, � ������� 2 � 3 ����� �������� ��������� �� ����� ����, �.�. (b!=�).
   if (b1-c1==0 || a1==0)
     {
      if (mWriteToFile)
        {
         if (FileSize(handle)<1) {FileClose(handle); FileDelete(file);} else FileClose(handle);
        }
      return;
     }

   // ��������� �����
   if (!(aPointAP[sd][0]==pitch_time[0] && aPointAP[sd][1]==pitch_cena[0] &&
       aPointAP[sd][2]==pitch_time[1] && aPointAP[sd][3]==pitch_cena[1] &&
       aPointAP[sd][4]==pitch_time[2] && aPointAP[sd][5]==pitch_cena[2]))
     {
      aPointAP[sd][0]=pitch_time[0]; aPointAP[sd][1]=pitch_cena[0];
      aPointAP[sd][2]=pitch_time[1]; aPointAP[sd][3]=pitch_cena[1];
      aPointAP[sd][4]=pitch_time[2]; aPointAP[sd][5]=pitch_cena[2];
      aPointAP[sd][6]=0; aPointAP[sd][7]=0;
//      if (mAuto) z=1;  // �������� ������ ��� mCriticalPoints � �������������� ������ ������ �����

      if (VariantsPRZ==0)
        {
         if (sd==0)
           {
            if (ExtUWL) x=ObjectGet(_nameUWL,OBJPROP_FIBOLEVELS);
            if (ExtLWL) y=ObjectGet(_nameLWL,OBJPROP_FIBOLEVELS);
           }

         if (ExtFiboFreePitchfork || ExtFiboType==2)
           {
            strUWL=ExtFiboFreeUWL;
            strLWL=ExtFiboFreeLWL;
           }
         else
           {
            strUWL="0.146,0.236,0.382,0.5,0.618,0.764,0.854,1,1.618,2.0,2.618,4.236";
            strLWL=strUWL;
           }

         if (mAuto && (x==0 || y==0))
           {
            if (VariantsPRZ==0 && sd==0)
              {
               if (!ExtUWL) ObjectDelete(_nameUWL);
               if (!ExtLWL) ObjectDelete(_nameLWL);
               if (!ExtUTL) ObjectDelete(_nameUTL);
               if (!ExtLTL) ObjectDelete(_nameLTL);
              }

            if (VariantsPRZ==0 && sd==1)
              {
               ObjectDelete(_nameUWL);
               ObjectDelete(_nameLWL);
               ObjectDelete(_nameUTL);
               ObjectDelete(_nameLTL);
              }

            if (ExtFiboFreePitchfork || ExtFiboType==2)
              {
               x=quantityFibo(ExtFiboFreeUWL)+1;
               y=quantityFibo(ExtFiboFreeLWL)+1;
              }
            else
              {
               x=12;
               y=x;
              }
           }

         if (ArrayRange(arrm,0)!=11+x+y+z) ArrayResize(arrm,11+x+y+z);

         ArrayResize(aUWL,x);
         for (i=0;i<x;i++)
           {
            k=StringFind(strUWL, ",", 0);
            aUWL[i]=StrToDouble(StringTrimLeft(StringTrimRight(StringSubstr(strUWL,0,k))));
            if (k>=0) strUWL=StringSubstr(strUWL,k+1);
           }

         ArrayResize(aLWL,y);
         for (i=0;i<y;i++)
           {
            k=StringFind(strLWL, ",", 0);
            aLWL[i]=StrToDouble(StringTrimLeft(StringTrimRight(StringSubstr(strLWL,0,k))));
            if (k>=0) strLWL=StringSubstr(strLWL,k+1);
           }
        }
     }

   if (VariantsPRZ==0 && !mSaveWL_TL)
     {
      if (mAuto && sd==0)
        {
         if (!ExtUWL) ObjectDelete(_nameUWL);
         if (!ExtLWL) ObjectDelete(_nameLWL);
         if (!ExtUTL) ObjectDelete(_nameUTL);
         if (!ExtLTL) ObjectDelete(_nameLTL);
        }

      if (VariantsPRZ==0 && sd==1)
        {
         ObjectDelete(_nameUWL);
         ObjectDelete(_nameLWL);
         ObjectDelete(_nameUTL);
         ObjectDelete(_nameLTL);
        }
     }

   ArrayInitialize(arrm,0);

   // ���������� �������� (������ �����) � ����
   if ((a1-(c1+b1)/2.0)==0) return;
   if (a1-c1==0) return;

   if (aPointAP[sd][7]==0)
     {
      // ������� ���� ������� ��� �������
      tangensAP=((pitch_cena[2]+pitch_cena[1])/2-pitch_cena[0])/(a1-(c1+b1)/2.0);
      atg[sd][0]=tangensAP;
      // ������� ���� ������� ����� ������� ��� �������
      tangensRL=(pitch_cena[2]-pitch_cena[1])/(b1-c1);
      atg[sd][1]=tangensRL;
      // ������� ���� ������� 1/2 ������� ��� �������
      if (ObjectFind(str05median+ExtComplekt+"_")>=0)
        {
         tangens05median=(pitch_cena[2]-pitch_cena[0])/(a1-c1);
        }

      atg[sd][2]=tangens05median;

      if (pitch_cena[1]>pitch_cena[2])
        {
         tangensUTL=(pitch_cena[1]-pitch_cena[0])/(a1-b1);
         tangensLTL=(pitch_cena[2]-pitch_cena[0])/(a1-c1);
        }
      else
        {
         tangensUTL=(pitch_cena[2]-pitch_cena[0])/(a1-c1);
         tangensLTL=(pitch_cena[1]-pitch_cena[0])/(a1-b1);
        }
      atg[sd][3]=tangensUTL;
      atg[sd][4]=tangensLTL;

      // ���������� ���������� �� ��������� �� SSL �� FSL - ���� �� ������ ��� �������
      hAP=pitch_cena[1]+(b1-c1)*tangensAP-pitch_cena[2];
      atg[sd][5]=hAP;
      
      // ���������� ���������� �� ��������� �� SSL �� FSL - ���� �� ������ ��� ����� �����
      hAP1_2mediana=pitch_cena[1]-(pitch_cena[2]-tangens05median*(b1-c1));
      atg[sd][6]=hAP1_2mediana;

      // ���������� ���� ��� ���������� ����� ������� RL - ���� �� �������
      bazaAP=a1-(b1+c1)/2.0;
      atg[sd][7]=bazaAP;
     }
   else
     {
      // ������� ���� ������� ��� �������
      tangensAP=atg[sd][0];
      // ������� ���� ������� ����� ������� ��� �������
      tangensRL=atg[sd][1];
      // ������� ���� ������� 1/2 ������� ��� �������
      tangens05median=atg[sd][2];
 
      tangensUTL=atg[sd][3];
      tangensLTL=atg[sd][4];
 
      hAP=atg[sd][5];
      hAP1_2mediana=atg[sd][6];
      bazaAP=atg[sd][7];
     }

   // �������� ����� � ����� �������� ��� �������
   if (mPivotPoints)
     {
      nameObj=prefics+"point 1 AP";
      ObjectCreate(nameObj,OBJ_ARROW,0,pitch_time[0],pitch_cena[0]);
      ObjectSet(nameObj,OBJPROP_ARROWCODE,SYMBOL_LEFTPRICE);
      ObjectSet(nameObj,OBJPROP_BACK,mBack);
      if (!mPivotPointsChangeColor)
        {
         if (pitch_cena[0]<pitch_cena[1] || pitch_cena[1]>pitch_cena[2]) updn=true; else updn=false;
         if (updn) ObjectSet(nameObj,OBJPROP_COLOR, mColorDN); else ObjectSet(nameObj,OBJPROP_COLOR, mColorUP);
        }

      nameObj=prefics+"point 2 AP";
      ObjectCreate(nameObj,OBJ_ARROW,0,pitch_time[1],pitch_cena[1]);
      ObjectSet(nameObj,OBJPROP_ARROWCODE,SYMBOL_LEFTPRICE);
      ObjectSet(nameObj,OBJPROP_BACK,mBack);
      if (!mPivotPointsChangeColor)
        {
         if (updn) ObjectSet(nameObj,OBJPROP_COLOR, mColorUP); else ObjectSet(nameObj,OBJPROP_COLOR, mColorDN);
        }

      nameObj=prefics+"point 3 AP";
      ObjectCreate(nameObj,OBJ_ARROW,0,pitch_time[2],pitch_cena[2]);
      ObjectSet(nameObj,OBJPROP_ARROWCODE,SYMBOL_LEFTPRICE);
      ObjectSet(nameObj,OBJPROP_BACK,mBack);
      if (!mPivotPointsChangeColor)
        {
         if (updn) ObjectSet(nameObj,OBJPROP_COLOR, mColorDN); else ObjectSet(nameObj,OBJPROP_COLOR, mColorUP);
        }
     }

   if (VariantsPRZ==0)
     {
      if (sd==0)
        {
         RLtoArray (arrRL, "RLineS"+ ExtComplekt+"_", ExtFiboFreeRLStatic);
         strSLM382="SLM382S";
         strSLM618="SLM618S";
        }
      else if (sd==1)
        {
         RLtoArray (arrRL, "RLineD"+ ExtComplekt+"_", ExtFiboFreeRLDinamic);
         strSLM382="SLM382D";
         strSLM618="SLM618D";
        }
      j1=ArraySize(arrRL);

      // ���������� ����������� ISL � RL � ����� ������� ���� �����
      if (hAP==0 || bazaAP==0) return;
      xISL=(hAP-(pitch_cena[1]+tangensAP*b1-iClose(NULL,Period(),0)))/hAP; // �������� ����� ISL
      xret=(c1+(b1-c1)*xISL)/bazaAP;  // �������� ����� RL

//---
/*
��������� ������� arrm[][10]

������ ��������� - ������
0 - mSSL 
1 � mSLM382 
2 - m1_2Mediana 
3 � mSLM618 
4 - mISL382 
5 - mMediana 
6 - mISL618 
7 - mFSL 
8 - mFSLShiffLines
9 - mUTL
10 - mLTL

������ ��������� - �������
0 - ���� ��������� ����� �� �����������
1 - ����� ����� ����� ����
2 - ���� ����� ����� ����
3 - ����� ������ ����� ����
4 - ���� ������ ����� ����
5 - ����� ����������� - ������������� ������� ��� ������ ����� � ����

1 - mSSL;
2 � mSLM382;
3 - m1_2Mediana;
4 � mSLM618;
5 - mISL382;
6 - mMediana;
7 - mISL618;
8 - mFSL;
9 - mFSLShiffLines;
//10 - mCriticalPoints - ��� �������� ���������� � �������: ���� ����� �����; � ���� ������ �����; 
11 - mUTL
12 - mLTL
//13 � mUWL
//14 - mLWL

6 - ��������� ����������
*/

//---
      // �������� �����
      i=0; // �������� ������� ����� ������� arrm

      nameObj=str05median+ExtComplekt+"_";
      if (ExtPitchforkStatic==2 || ExtPitchforkDinamic==2 || ObjectFind(nameObj)>=0)
        {
         // �������� ����� ��� ����������� 50%-� ������� � ISL 38.2 � ��������� ���������� ������ // mCriticalPoints
         if (!mAuto && aMetki[sd][10]>0)
           {
            if (ObjectFind(nameObj)>=0)
              {
               // ���������� ����� �� ������� ����� �������� ��� ������� �� ����� ����������� 50%-� ������� � ��������� ���������� ������
               if ((tangens05median-tangensAP)==0) return;
               X=(pitch_cena[2]-ObjectGetValueByShift(nameObj,c1))/(tangens05median-tangensAP); x=X; if (x<X) x++;
               cena1=pitch_cena[2]+X*tangensAP;
               if (x<=c1) {time1=iTime(NULL,Period(),c1-x); symb=SYMBOL_LEFTPRICE;} else {time1=iTime(NULL,Period(),0)+(x-c1)*60*Period(); symb=SYMBOL_RIGHTPRICE;}

               // ��������� ���������� �� ������� ����
               if ((sd==0 && RZs<0) || (sd==1 && RZd<0))
                 {
                  if (pitch_cena[1]>pitch_cena[2])
                    {
                     for (k=b1-1;k>=c1;k--)
                       {
                        delta=iHigh(NULL,Period(),k)-(pitch_cena[1]+(b1-k)*tangensRL);
                        if (delta>h) h=delta;
                       }
                    }
                  else
                    {
                     for (k=b1-1;k>=c1;k--)
                       {
                        delta=(pitch_cena[1]+(b1-k)*tangensRL)-iLow(NULL,Period(),k);
                        if (delta>h) h=delta;
                       }
                     }
                  if (sd==0) RZs=h; else RZd=h;
                 }
               else
                 {
                  if (sd==0) h=RZs; else h=RZd;
                 }

               nameObj=str05median+ExtComplekt+"_";
               // ���������� ����� �� ������� ����� �������� ��� ������� �� ����� ����������� 50%-� ������� � ��������� ���������� ������
               cena2=ObjectGetValueByShift(nameObj,b1);
               X=(pitch_cena[0]-cena2+(a1-b1)*tangensAP-(phi-1.5)*(pitch_cena[1]+(b1-c1)*tangensAP-pitch_cena[2]))/(tangens05median-tangensAP);
               x=X;
               cena2=cena2+X*tangens05median;
               if (x<=b1) {time2=iTime(NULL,Period(),b1-x); symb=SYMBOL_LEFTPRICE;}
               else {if (x<X) x++; time2=iTime(NULL,Period(),0)+(x-b1)*60*Period(); symb=SYMBOL_RIGHTPRICE;}
               if (MathAbs(pitch_cena[1]+x*tangensRL-cena1)>h)
                 {
                 }
               else cena2=0;

               arrm[i][0]=cena1; arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2; arrm[i][5]=10; i++;
               if (cena2>0) arrm[i][0]=cena2; arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2; arrm[i][5]=10; arrm[i][6]=1; i++;
              }
           }

         // �������� ����� ��� ����������� �������� ���� 50%-� �������� ��� ������� // m1_2Mediana
         if (mAuto || aMetki[sd][3]>0)
           {
            nameObj=str05median+ExtComplekt+"_";
            if (ObjectFind(nameObj)>=0)
              {
               cena1=ObjectGetValueByShift(nameObj,0);
               arrm[i][0]=cena1; arrm[i][5]=3;
               if (aMetki[sd][3]>1) //if ((m1_2Mediana>1 && sd==0) || (m1_2Mediana_d>1 && sd==1))
                 {
                  retISL=(cena1 -(pitch_cena[2]+c1*tangensAP))/hAP;
                  if (tangensAP==0)
                    {
                     ret=(c1+retISL*(b1-c1))/bazaAP;
                    }
                  else
                    {
                     if ((tangensAP*bazaAP)==0) return;
                     ret=(cena1-pitch_cena[2]-retISL*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                    }
                  if (!mAuto && aMetki[sd][3]>4 && xISL>retISL) ret=xret;

                  rl1=0; rl2=0;
                  for (m=0;m<j1;m++)
                    {
                     if (arrRL[m]>=ret)
                       {
                        rl2=arrRL[m];
                        break;
                       }
                     else
                       {
                        rl1=arrRL[m];
                       }
                    }

                  if (rl2>0)
                    {
                     nameObj=str05median+ExtComplekt+"_";
                     cenaRL=pitch_cena[1]+bazaAP*rl1*(tangensAP-tangensRL);
                     wr=ObjectGetValueByShift(nameObj,b1);
                     X=(cenaRL-wr)/(tangens05median-tangensRL);
                     x=X;
                     if (tangensAP!=0) cena1=wr+X*tangens05median; else cena1=cenaRL+X*tangensRL;
                     if (x<=b1) time1=iTime(NULL,Period(),b1-x); else time1=iTime(NULL,Period(),0)+(x-b1)*Period()*60;
                     cenaRL=pitch_cena[1]+bazaAP*rl2*(tangensAP-tangensRL);
                     X=(cenaRL-wr)/(tangens05median-tangensRL);
                     x=X; if (x<X) x++;
                     if (tangensAP!=0) cena2=wr+X*tangens05median; else cena2=cenaRL+X*tangensRL;
                     if (x<=b1) time2=iTime(NULL,Period(),b1-x); else time2=iTime(NULL,Period(),0)+(x-b1)*Period()*60;

                     arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
                    }
                 }

               i++;
              }
           }

         // ����� �� SLM // mSLM
         if ((sd==0 && ExtSLMStatic) || (sd==1 && ExtSLMDinamic))
           {
            if (mAuto || aMetki[sd][2]>0)
              {
               // �������� ����� �� SLM382
               nameObj=strSLM382+ExtComplekt+"_";
               if (ObjectFind(nameObj)>=0)
                 {
                  cena1=ObjectGetValueByShift(nameObj,0);
                  arrm[i][0]=cena1; arrm[i][5]=2;
                  if (aMetki[sd][2]>1)
                    {
                     retISL=(cena1 -(pitch_cena[2]+c1*tangensAP))/hAP;
                     if (tangensAP==0) ret=(c1+retISL*(b1-c1))/bazaAP; 
                     else
                       {
                        if ((tangensAP*bazaAP)==0) return;
                        ret=(cena1-pitch_cena[2]-retISL*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                       }

                     if (!mAuto && aMetki[sd][2]>4 && xISL>retISL) ret=xret;

                     rl1=0; rl2=0;
                     for (m=0;m<j1;m++)
                       {
                        if (arrRL[m]>=ret)
                          {
                           rl2=arrRL[m];
                           break;
                          }
                        else
                          {
                           rl1=arrRL[m];
                          }
                       }

                     if (rl2>0)
                       {
                        nameObj=strSLM382+ExtComplekt+"_";
                        cenaRL=pitch_cena[1]+bazaAP*rl1*(tangensAP-tangensRL);
                        wr=ObjectGetValueByShift(nameObj,c1)-tangens05median*(b1-c1);
                        X=(cenaRL-wr)/(tangens05median-tangensRL);
                        x=X;
                        if (tangensAP!=0) cena1=wr+X*tangens05median; else cena1=cenaRL+X*tangensRL;
                        if (x<=b1) time1=iTime(NULL,Period(),b1-x); else time1=iTime(NULL,Period(),0)+(x-b1)*Period()*60;
                        cenaRL=pitch_cena[1]+bazaAP*rl2*(tangensAP-tangensRL);
                        if ((tangens05median-tangensRL)==0) return;
                        X=(cenaRL-wr)/(tangens05median-tangensRL);
                        x=X; if (x<X) x++;
                        if (tangensAP!=0) cena2=wr+X*tangens05median; else cena2=cenaRL+X*tangensRL;
                        if (x<=b1) time2=iTime(NULL,Period(),b1-x); else time2=iTime(NULL,Period(),0)+(x-b1)*Period()*60;

                        arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
                       }
                    }

                  i++;
                 }

               // �������� ����� �� SLM618 // mSLM
               nameObj=strSLM618+ExtComplekt+"_";
               if (ObjectFind(nameObj)>=0)
                 {
                  cena1=ObjectGetValueByShift(nameObj,0);
                  arrm[i][0]=cena1; arrm[i][5]=4;
                  if (aMetki[sd][4]>1)
                    {
                     retISL=(cena1 -(pitch_cena[2]+c1*tangensAP))/hAP;
                     if (tangensAP==0) ret=(c1+retISL*(b1-c1))/bazaAP; 
                     else
                       {
                        if ((tangensAP*bazaAP)==0) return;
                        ret=(cena1-pitch_cena[2]-retISL*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                       }

                     if (!mAuto && aMetki[sd][4]>4 && xISL>retISL) ret=xret;

                     rl1=0; rl2=0;
                     for (m=0;m<j1;m++)
                       {
                        if (arrRL[m]>=ret)
                          {
                           rl2=arrRL[m];
                           break;
                          }
                        else
                          {
                           rl1=arrRL[m];
                          }
                       }

                     if (rl2>0)
                       {
                        nameObj=strSLM618+ExtComplekt+"_";
                        cenaRL=pitch_cena[1]+bazaAP*rl1*(tangensAP-tangensRL);
                        wr=ObjectGetValueByShift(nameObj,c1)-tangens05median*(b1-c1);
                        X=(cenaRL-wr)/(tangens05median-tangensRL);
                        x=X;
                        if (tangensAP!=0) cena1=wr+X*tangens05median; else cena1=cenaRL+X*tangensRL;
                        if (x<=b1) time1=iTime(NULL,Period(),b1-x); else time1=iTime(NULL,Period(),0)+(x-b1)*Period()*60;
                        cenaRL=pitch_cena[1]+bazaAP*rl2*(tangensAP-tangensRL);
                        if ((tangens05median-tangensRL)==0) return;
                        X=(cenaRL-wr)/(tangens05median-tangensRL);
                        x=X; if (x<X) x++;
                        if (tangensAP!=0) cena2=wr+X*tangens05median; else cena2=cenaRL+X*tangensRL;
                        if (x<=b1) time2=iTime(NULL,Period(),b1-x); else time2=iTime(NULL,Period(),0)+(x-b1)*Period()*60;

                        arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
                       }
                    }

                  i++;
                 }
              }
           }

         // �������� ����� �� FSL Shiff Lines // mFSLShiffLines
         if ((sd==0 && ExtFSLShiffLinesStatic) || (sd==1 && ExtFSLShiffLinesDinamic))
           {
            if (mAuto || aMetki[sd][9]>0)
              {
               if (sd==0) nameObj="FSL Shiff Lines S" + ExtComplekt+"_"; else nameObj="FSL Shiff Lines D" + ExtComplekt+"_";
               if (ObjectFind(nameObj)>=0)
                 {
                  cena1=ObjectGetValueByShift(nameObj,0);
                  arrm[i][0]=cena1; arrm[i][5]=9;
                  if (aMetki[sd][9]>1)
                    {
                     retISL=(cena1 -(pitch_cena[2]+c1*tangensAP))/hAP;
                     if (tangensAP==0) ret=(c1+retISL*(b1-c1))/bazaAP;
                     else
                       {
                        if ((tangensAP*bazaAP)==0) return;
                        ret=(cena1-pitch_cena[2]-retISL*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                       }

                     if (!mAuto && aMetki[sd][9]>4 && xISL>retISL) ret=xret;
                     rl1=0; rl2=0;
                     for (m=0;m<j1;m++)
                       {
                        if (arrRL[m]>=ret)
                          {
                           rl2=arrRL[m];
                           break;
                          }
                        else
                          {
                           rl1=arrRL[m];
                          }
                       }
                     if (rl2>0)
                       {
                        if (sd==0) nameObj="FSL Shiff Lines S" + ExtComplekt+"_"; else nameObj="FSL Shiff Lines D" + ExtComplekt+"_";
                        cenaRL=pitch_cena[1]+bazaAP*rl1*(tangensAP-tangensRL);
                        wr=ObjectGetValueByShift(nameObj,c1)-tangens05median*(b1-c1);
                        X=(cenaRL-wr)/(tangens05median-tangensRL);
                        x=X;
                        if (tangensAP!=0) cena1=wr+X*tangens05median; else cena1=cenaRL+X*tangensRL;
                        if (x<=b1) time1=iTime(NULL,Period(),b1-x); else time1=iTime(NULL,Period(),0)+(x-b1)*Period()*60;
                        cenaRL=pitch_cena[1]+bazaAP*rl2*(tangensAP-tangensRL);
                        if ((tangens05median-tangensRL)==0) return;
                        X=(cenaRL-wr)/(tangens05median-tangensRL);
                        x=X; if (x<X) x++;
                        if (tangensAP!=0) cena2=wr+X*tangens05median; else cena2=cenaRL+X*tangensRL;
                        if (x<=b1) time2=iTime(NULL,Period(),b1-x); else time2=iTime(NULL,Period(),0)+(x-b1)*Period()*60;

                        arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
                       }
                    }

                  i++;
                 }
              }
           }
        }

      // �������� ����� ��� ����������� ������� �������� ����

      // �������� ����� ��� ����������� �������� ���� ������ SSL // mSSL
      if (mAuto || aMetki[sd][1]>0)
        {
         cena1=pitch_cena[2]+c1*tangensAP;
         arrm[i][0]=cena1; arrm[i][5]=1;

         if (!mExitFSL_SSL)
           {
            if (pitch_cena[1]>pitch_cena[2]) aexitFSL_SSL[0]=cena1;
            else aexitFSL_SSL[1]=cena1;
           }

         if (aMetki[sd][1]>1)
           {
            if (mAuto || aMetki[sd][1]<5 || (xISL<=0 && aMetki[sd][1]>4))
              {
               if (tangensAP==0) ret=c1/bazaAP; 
               else
                 {
                  if ((tangensAP*bazaAP)==0) return;
                  ret=(cena1-pitch_cena[2])/(tangensAP*bazaAP);
                 }
              }
            else ret=xret;

            rl1=0; rl2=0;
            for (m=0;m<j1;m++)
              {
               if (arrRL[m]>=ret)
                 {
                  rl2=arrRL[m];
                  break;
                 }
               else
                 {
                  rl1=arrRL[m];
                 }
              }

            if (rl2>0)
              {
               X=bazaAP*rl1; x=X;
               cena1=pitch_cena[2]+X*tangensAP;
               if (x<=c1) time1=iTime(NULL,Period(),c1-x); else time1=iTime(NULL,Period(),0)+(x-c1)*Period()*60;
               X=bazaAP*rl2; x=X; if (x<X) x++;
               cena2=pitch_cena[2]+X*tangensAP;
               if (x<=c1) time2=iTime(NULL,Period(),c1-x); else time2=iTime(NULL,Period(),0)+(x-c1)*Period()*60;

               arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
              }
           }

         i++;
        }

      // �������� ����� ��� ����������� �������� ���� ������ FSL // mFSL
      if (mAuto || aMetki[sd][8]>0)
        {
         cena1=pitch_cena[1]+b1*tangensAP;
         arrm[i][0]=cena1; arrm[i][5]=8;

         if (!mExitFSL_SSL)
           {
            if (pitch_cena[1]>pitch_cena[2]) aexitFSL_SSL[1]=cena1;
            else aexitFSL_SSL[0]=cena1;
           }

         if (aMetki[sd][8]>1)
           {
            if (mAuto || aMetki[sd][8]<5 || (xISL<=1 && aMetki[sd][8]>4))
              {
               if (tangensAP==0) ret=b1/bazaAP;
               else
                 {
                  if ((tangensAP*bazaAP)==0) return;
                  ret=(cena1-pitch_cena[1])/(tangensAP*bazaAP);
                 }
              }
            else ret=xret;

            rl1=0; rl2=0;
            for (m=0;m<j1;m++)
              {
               if (arrRL[m]>=ret)
                 {
                  rl2=arrRL[m];
                  break;
                 }
               else
                 {
                  rl1=arrRL[m];
                 }
              }

            if (rl2>0)
              {
               X=bazaAP*rl1; x=X;
               cena1=pitch_cena[1]+X*tangensAP;
               if (x<=b1) time1=iTime(NULL,Period(),b1-x); else time1=iTime(NULL,Period(),0)+(x-b1)*Period()*60;
               X=bazaAP*rl2; x=X; if (x<X) x++;
               cena2=pitch_cena[1]+X*tangensAP;
               if (x<=b1) time2=iTime(NULL,Period(),b1-x); else time2=iTime(NULL,Period(),0)+(x-b1)*Period()*60;

               arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
              }
           }

         i++;
        }

      // �������� ����� ��� ����������� �������� ���� �������� ��� ������� // mMediana
      if (mAuto || aMetki[sd][6]>0)
        {
         cena1=pitch_cena[0]+a1*tangensAP;
         arrm[i][0]=cena1; arrm[i][5]=6;
         if (aMetki[sd][6]>1)
           {
            if (mAuto || aMetki[sd][6]<5 || (xISL<=0.5 && aMetki[sd][6]>4))
              {
               if (tangensAP==0) ret=a1/bazaAP-1; 
               else
                 {
                  if ((tangensAP*bazaAP)==0) return;
                  ret=(cena1-pitch_cena[0])/(tangensAP*bazaAP)-1;
                 }
              }
            else ret=xret;

            rl1=0; rl2=0;
            for (m=0;m<j1;m++)
              {
               if (arrRL[m]>=ret)
                 {
                  rl2=arrRL[m];
                  break;
                 }
               else
                 {
                  rl1=arrRL[m];
                 }
              }

            if (rl2>0)
              {
               X=bazaAP*(rl1+1); x=X;
               cena1=pitch_cena[0]+X*tangensAP;
               if (x<=a1) time1=iTime(NULL,Period(),a1-x); else time1=iTime(NULL,Period(),0)+(x-a1)*Period()*60;
               X=bazaAP*(rl2+1); x=X; if (x<X) x++;
               cena2=pitch_cena[0]+X*tangensAP;
               if (x<=a1) time2=iTime(NULL,Period(),a1-x); else time2=iTime(NULL,Period(),0)+(x-a1)*Period()*60;

               arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
              }
           }

         i++;
        }

      // �������� ����� ��� ����������� �������� ���� ������ ISL 38.2 // mISL382
      if (mAuto || aMetki[sd][5]>0)
        {
         cena1=pitch_cena[2]+c1*tangensAP+hAP*(2-phi);
         arrm[i][0]=cena1; arrm[i][5]=5;
         if (aMetki[sd][5]>1)
           {
            if (mAuto || aMetki[sd][5]<5 || (xISL<=(2-phi) && aMetki[sd][5]>4))
              {
               if (tangensAP==0) ret=(c1+(2-phi)*(b1-c1))/bazaAP; 
               else
                 {
                  if ((tangensAP*bazaAP)==0) return;
                  ret=(cena1-pitch_cena[2]-(2-phi)*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                 }
              }
            else ret=xret;

            rl1=0; rl2=0;
            for (m=0;m<j1;m++)
              {
               if (arrRL[m]>=ret)
                 {
                  rl2=arrRL[m];
                  break;
                 }
               else
                 {
                  rl1=arrRL[m];
                 }
              }

            if (rl2>0)
              {
               X=bazaAP*rl1; x=X;
               cena1=pitch_cena[2]+X*tangensAP+(2-phi)*(hAP-(b1-c1)*tangensAP);
               if (x<=b1-(b1-c1)*(phi-1)) time1=iTime(NULL,Period(),b1-(b1-c1)*(phi-1)-x); else time1=iTime(NULL,Period(),0)+(x-b1+(b1-c1)*(phi-1))*Period()*60;
               X=bazaAP*rl2; x=X; if (x<X) x++;
               cena2=pitch_cena[2]+X*tangensAP+(2-phi)*(hAP-(b1-c1)*tangensAP);
               if (x<=b1-(b1-c1)*(phi-1)) time2=iTime(NULL,Period(),b1-(b1-c1)*(phi-1)-x); else time2=iTime(NULL,Period(),0)+(x-b1+(b1-c1)*(phi-1))*Period()*60;

               arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
              }
           }

         i++;
        }

      // �������� ����� ��� ����������� �������� ���� ������ ISL 61.8 // mISL618
      if (mAuto || aMetki[sd][7]>0)
        {
         cena1=pitch_cena[2]+c1*tangensAP+hAP*(phi-1);
         arrm[i][0]=cena1; arrm[i][5]=7;
         if (aMetki[sd][7]>1)
           {
            if (mAuto || aMetki[sd][7]<5 || (xISL<=(phi-1) && aMetki[sd][7]>4))
              {
               if (tangensAP==0) ret=(c1+(phi-1)*(b1-c1))/bazaAP; 
               else
                 {
                  if ((tangensAP*bazaAP)==0) return;
                  ret=(cena1-pitch_cena[2]-(phi-1)*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                 }
              }
            else ret=xret;

            rl1=0; rl2=0;
            for (m=0;m<j1;m++)
              {
               if (arrRL[m]>=ret)
                 {
                  rl2=arrRL[m];
                  break;
                 }
               else
                 {
                  rl1=arrRL[m];
                 }
              }

            if (rl2>0)
              {
               X=bazaAP*rl1; x=X;
               cena1=pitch_cena[2]+X*tangensAP+(phi-1)*(hAP-(b1-c1)*tangensAP);
               if (x<=b1-(b1-c1)*(2-phi)) time1=iTime(NULL,Period(),b1-(b1-c1)*(2-phi)-x); else time1=iTime(NULL,Period(),0)+(x-b1+(b1-c1)*(2-phi))*Period()*60;
               X=bazaAP*rl2; x=X; if (x<X) x++;
               cena2=pitch_cena[2]+X*tangensAP+(phi-1)*(hAP-(b1-c1)*tangensAP);
               if (x<=b1-(b1-c1)*(2-phi)) time2=iTime(NULL,Period(),b1-(b1-c1)*(2-phi)-x); else time2=iTime(NULL,Period(),0)+(x-b1+(b1-c1)*(2-phi))*Period()*60;

               arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
              }
           }

         i++;
        }

      if (sd==0 || (sd==1 && mAuto))
        {
         // �������� ����� ��� ����������� �������� ���� ���������������� ������� LWL �/��� UWL ���������� ��� ������� // mUWL, mLWL
         if (mAuto || aMetki[sd][13]>0 || aMetki[sd][14]>0)
           {

            if (pitch_cena[1]>pitch_cena[2])
              {
               cenaUWL=pitch_cena[1];
               cenaLWL=pitch_cena[2];
              }
            else
              {
               cenaUWL=pitch_cena[2];
               cenaLWL=pitch_cena[1];
              }

            if (mAuto || ExtUWL)
              {
               nameObj=nameUWL;
               if (mAuto || ObjectFind(nameObj)>=0)
                 {
                  // ������������ � ����������� �������� ���� �����
                  if (pitch_cena[1]>pitch_cena[2])
                    {
                     X=pitch_cena[1]+b1*tangensUTL;
                     Y=pitch_cena[1]+b1*tangensAP;
                    }
                  else
                    {
                     X=pitch_cena[2]+c1*tangensUTL; 
                     Y=pitch_cena[2]+c1*tangensAP;
                    }

                  x=ArraySize(aUWL);
                  for (k=0;k<x;k++)
                    {
                     cena1=Y+MathAbs(hAP)*aUWL[k]/2;
                     if ((aMetki[sd][13]==0 && mAuto) || aMetki[sd][13]==1)
                       {
                        if (cena1<=X)
                          {
                           arrm[i][0]=cena1; arrm[i][5]=13; arrm[i][6]=aUWL[k];
                          }
                        else
                          {
                           break;
                          }
                       }
                     else //if (mUWL>1)
                       {
                        retISL=(cena1 -(pitch_cena[2]+c1*tangensAP))/hAP;

                        if (!mAuto && aMetki[sd][13]>4 && xISL>retISL) ret=xret;
                        else
                          {
                           if (tangensAP==0) ret=(c1+retISL*(b1-c1))/bazaAP; 
                           else
                             {
                              if ((tangensAP*bazaAP)==0) return;
                              ret=(cena1-pitch_cena[2]-retISL*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                             }
                          }

                        rl1=0; rl2=0;
                        for (m=0;m<j1;m++)
                          {
                           if (arrRL[m]>=ret)
                             {
                              rl2=arrRL[m];
                              break;
                             }
                           else
                             {
                              rl1=arrRL[m];
                             }
                          }
                        arrm[i][0]=cena1; arrm[i][5]=13; arrm[i][6]=aUWL[k];

                        W=bazaAP*rl2; // x=X; if (x<X) x++;
                        cena2=pitch_cena[2]+W*tangensAP+retISL*(hAP-(b1-c1)*tangensAP);
                        if ((cenaUWL+tangensUTL*W)<cena2) continue;
                        if (W<=c1+(b1-c1)*retISL) time2=iTime(NULL,Period(),c1+(b1-c1)*retISL-W); else time2=iTime(NULL,Period(),0)+(W-c1-(b1-c1)*retISL)*Period()*60;

                        W=bazaAP*rl1;
                        cena1=pitch_cena[2]+W*tangensAP+retISL*(hAP-(b1-c1)*tangensAP);
                        if (W<=c1+(b1-c1)*retISL) time1=iTime(NULL,Period(),c1+(b1-c1)*retISL-W); else time1=iTime(NULL,Period(),0)+(W-c1-(b1-c1)*retISL)*Period()*60;

                        arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
                       }

                     i++;
                    }
                 }
              }

            if (mAuto || ExtLWL)
              {
               nameObj=nameLWL;
               if (mAuto || ObjectFind(nameObj)>=0)
                 {
                  // ������������ � ����������� �������� ���� �����
                  if (pitch_cena[1]>pitch_cena[2])
                    {
                     Y=pitch_cena[2]+c1*tangensAP;
                     X=pitch_cena[2]+c1*tangensLTL;
                    }
                  else
                    {
                     Y=pitch_cena[1]+b1*tangensAP;
                     X=pitch_cena[1]+b1*tangensLTL;
                    }

                  x=ArraySize(aLWL);
                  for (k=0;k<x;k++)
                    {
                     cena1=Y-MathAbs(hAP)*aLWL[k]/2;
                     if ((aMetki[sd][14]==0 && mAuto) || aMetki[sd][14]==1)
                       {
                        if (cena1>=X)
                          {
                           arrm[i][0]=cena1; arrm[i][5]=14; arrm[i][6]=aLWL[k];
                          }
                        else
                          {
                           break;
                          }
                       }
                     else //if (mLWL>1)
                       {
                        retISL=(cena1 -(pitch_cena[2]+c1*tangensAP))/hAP;

                        if (!mAuto && aMetki[sd][14]>4 && xISL>retISL) ret=xret;
                        else
                          {
                           if (tangensAP==0) ret=(c1+retISL*(b1-c1))/bazaAP; 
                           else
                             {
                              if ((tangensAP*bazaAP)==0) return;
                              ret=(cena1-pitch_cena[2]-retISL*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                             }
                          }

                        rl1=0; rl2=0;
                        for (m=0;m<j1;m++)
                          {
                           if (arrRL[m]>=ret)
                             {
                              rl2=arrRL[m];
                              break;
                             }
                           else
                             {
                              rl1=arrRL[m];
                             }
                          }
                        arrm[i][0]=cena1; arrm[i][5]=14; arrm[i][6]=aLWL[k];

                        W=bazaAP*rl2; // x=X; if (x<X) x++;
                        cena2=pitch_cena[2]+W*tangensAP+retISL*(hAP-(b1-c1)*tangensAP);
                        if ((cenaLWL+tangensLTL*W)>cena2) continue;
                        if (W<=c1+(b1-c1)*retISL) time2=iTime(NULL,Period(),c1+(b1-c1)*retISL-W); else time2=iTime(NULL,Period(),0)+(W-c1-(b1-c1)*retISL)*Period()*60;

                        W=bazaAP*rl1;
                        cena1=pitch_cena[2]+W*tangensAP+retISL*(hAP-(b1-c1)*tangensAP);
                        if (W<=c1+(b1-c1)*retISL) time1=iTime(NULL,Period(),c1+(b1-c1)*retISL-W); else time1=iTime(NULL,Period(),0)+(W-c1-(b1-c1)*retISL)*Period()*60;

                        arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
                       }

                     i++;
                    }
                 }
              }
           }

         // �������� ����� ��� ����������� �������� ���� ������������ ������� LTL �/��� UTL ���������� ��� ������� // mUTL, mLTL
         if (mAuto || aMetki[sd][11]>0 || aMetki[sd][12]>0)
           {
            if (mAuto || ExtUTL)
              {
               nameObj=_nameUTL;
               if (mAuto || ObjectFind(nameObj)>=0)
                 {
                  cena1=pitch_cena[0]+tangensUTL*a1;
                  arrm[i][0]=cena1; arrm[i][5]=11;
                  if (mAuto || aMetki[sd][11]>1)
                    {
                     retISL=(cena1 -(pitch_cena[2]+c1*tangensAP))/hAP;

                     if (!mAuto && aMetki[sd][11]>4 && xISL>retISL) ret=xret;
                     else
                       {
                        if (tangensAP==0) ret=(c1+retISL*(b1-c1))/bazaAP; 
                        else
                          {
                           if ((tangensAP*bazaAP)==0) return;
                           ret=(cena1-pitch_cena[2]-retISL*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                          }
                       }

                     rl1=0; rl2=0;
                     for (m=0;m<j1;m++)
                       {
                        if (arrRL[m]>=ret)
                          {
                           rl2=arrRL[m];
                           break;
                          }
                        else
                          {
                           rl1=arrRL[m];
                          }
                       }
  
                     if (rl2>0)
                       {
                        if (pitch_cena[1]>pitch_cena[2])
                          {
                           X=pitch_cena[1];
                          }
                        else
                          {
                           X=pitch_cena[2];
                          }

                        if ((tangensRL-tangensUTL)!=0 && tangensUTL!=0)
                          {
                           cena1=X+bazaAP*rl1*tangensUTL*(tangensRL-tangensAP)/(tangensRL-tangensUTL);
                           x=a1-MathCeil((cena1-pitch_cena[0])/tangensUTL);
                           if (x>0) time1=iTime(Symbol(),Period(),x); else time1=iTime(Symbol(),Period(),0)-x*Period()*60;

                           cena2=X+bazaAP*rl2*tangensUTL*(tangensRL-tangensAP)/(tangensRL-tangensUTL);
                           x=a1-MathCeil((cena2-pitch_cena[0])/tangensUTL);
                           if (x>0) time2=iTime(Symbol(),Period(),x); else time2=iTime(Symbol(),Period(),0)-x*Period()*60;

                           arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
                          }
                       }
                    }

                  i++;
                 }
              }

            if (mAuto || ExtLTL)
              {
               nameObj=_nameLTL;
               if (mAuto || ObjectFind(nameObj)>=0)
                 {
                  cena1=pitch_cena[0]+tangensLTL*a1;
                  arrm[i][0]=cena1; arrm[i][5]=12;
                  if (mAuto || aMetki[sd][12]>1)
                    {
                     retISL=(cena1 -(pitch_cena[2]+c1*tangensAP))/hAP;

                     if (!mAuto && aMetki[sd][12]>4 && xISL>retISL) ret=xret;
                     else
                      {
                       if (tangensAP==0) ret=(c1+retISL*(b1-c1))/bazaAP; 
                       else
                         {
                          if ((tangensAP*bazaAP)==0) return;
                          ret=(cena1-pitch_cena[2]-retISL*(hAP-(b1-c1)*tangensAP))/(tangensAP*bazaAP);
                         }
                      }

                     rl1=0; rl2=0;
                     for (m=0;m<j1;m++)
                       {
                        if (arrRL[m]>=ret)
                          {
                           rl2=arrRL[m];
                           break;
                          }
                        else
                          {
                           rl1=arrRL[m];
                          }
                       }

                     if (rl2>0)
                       {
                        if (pitch_cena[2]>pitch_cena[1])
                          {
                           X=pitch_cena[1];
                          }
                        else
                          {
                           X=pitch_cena[2];
                          }

                        if ((tangensRL-tangensLTL)!=0 && tangensLTL!=0)
                          {
                           cena1=X+bazaAP*rl1*tangensLTL*(tangensRL-tangensAP)/(tangensRL-tangensLTL);
                           x=a1-MathCeil((cena1-pitch_cena[0])/tangensLTL);
                           if (x>0) time1=iTime(Symbol(),Period(),x); else time1=iTime(Symbol(),Period(),0)-x*Period()*60;

                           cena2=X+bazaAP*rl2*tangensLTL*(tangensRL-tangensAP)/(tangensRL-tangensLTL);
                           x=a1-MathCeil((cena2-pitch_cena[0])/tangensLTL);
                           if (x>0) time2=iTime(Symbol(),Period(),x); else time2=iTime(Symbol(),Period(),0)-x*Period()*60;

                           arrm[i][1]=time1; arrm[i][2]=cena1; arrm[i][3]=time2; arrm[i][4]=cena2;
                          }
                       }
                    }

                 }
              }
           }
        }

      string wl="";
      int ii, i_1=0, i_2=ArrayRange(arrm,0)-1;
      double cl=iClose(NULL,Period(),0), pp;
      // x - ���������� ����� ����� �� ������� ����
      // y - ���������� ����� ����

      if (mAuto)
        {
         exitSL=mExitFSL_SSL || Close[0]>=aexitFSL_SSL[1] || Close[0]<=aexitFSL_SSL[0];

         if (aPointAP[sd][3]-aPointAP[sd][1]==0) pp=10;
         else pp=MathAbs((aPointAP[sd][5]-aPointAP[sd][1])/(aPointAP[sd][3]-aPointAP[sd][1]));

         if (aPointAP[sd][3]>aPointAP[sd][5]) // ���������� ���� - ����������� �����
           {
            if (aPointAP[sd][5]<=aPointAP[sd][1] && aPointAP[sd][1]<aPointAP[sd][3] && pp<0.854) {x=3; y=2;} // ����������� ����������
            else if (aPointAP[sd][1]<aPointAP[sd][5])
                   {
                    if (pp<0.854) {x=3; y=1;}  // ��������� ����������
                    else {x=2;  y=1;}          // �������� ����������
                   }
            else if (aPointAP[sd][5]<aPointAP[sd][1] && aPointAP[sd][1]<aPointAP[sd][3] && pp>=0.854 && pp<=1.146) {x=2; y=2;} // ��������������
            else if ((aPointAP[sd][5]<aPointAP[sd][1] && aPointAP[sd][1]<=aPointAP[sd][3] && pp>1.146) || aPointAP[sd][1]>aPointAP[sd][3]) {x=3; y=2;}   // �����
           }
         else if (aPointAP[sd][5]>aPointAP[sd][3]) // ���������� ���� - ����������� ����
           {
            if (aPointAP[sd][5]>=aPointAP[sd][1] && aPointAP[sd][1]>aPointAP[sd][3] && pp <0.854) {x=2; y=3;} // ����������� ����������
            else if (aPointAP[sd][1]>aPointAP[sd][5])
                   {
                    if (pp<0.854) {x=1; y=3;}  // ��������� ����������
                    else {x=1;  y=2;}          // �������� ����������
                   }
            else if (aPointAP[sd][5]>aPointAP[sd][1] && aPointAP[sd][1]>aPointAP[sd][3] && pp>=0.854 && pp<=1.146) {x=2; y=2;} // ��������������
            else if ((aPointAP[sd][5]>aPointAP[sd][1] && aPointAP[sd][1]>=aPointAP[sd][3] && pp>1.146) || aPointAP[sd][1]<aPointAP[sd][3]) {x=2; y=3;}   // �����
           }

         ArraySort(arrm);
         for (i=i_1;i<i_2;i++)
           {
            if (cl<=arrm[i][0]) break;
           }

         i_1=i-y;
         i_2=i+x; if (cl==arrm[i][0]) i_2++;
         if (i_1<0) i_1=0;
         if (i_2>ArrayRange(arrm,0)) i_2=ArrayRange(arrm,0);
        }
      else exitSL=true;

      anum_cena[sd][0]=i_1;
      anum_cena[sd][1]=i_2-1;

      for (i=i_1;i<i_2;i++)
        {
         if (arrm[i][0]==0) continue;
         ii=arrm[i][5];

         if (ii==10)  // ����������� �����
           {
            if (arrm[i][6]==0)
              {
               nameObj=prefics+atextm[ii]+" x SSL";
               ObjectCreate(nameObj,OBJ_ARROW,0,arrm[i][1],arrm[i][2]);
               ObjectSet(nameObj,OBJPROP_ARROWCODE,symb);
               ObjectSet(nameObj,OBJPROP_BACK,mBack);

               if (writetofile)
                 {
                  FileSeek(handle, 0, SEEK_END);
                  FileWrite(handle, 0, ii, 1, DoubleToStr(arrm[i][4], Digits), 0, DoubleToStr(arrm[i][2], Digits), DoubleToStr(iClose(NULL,Period(),0), Digits), sd,
                   DoubleToStr(pitch_cena[0], Digits), DoubleToStr(pitch_cena[1], Digits), DoubleToStr(pitch_cena[2], Digits));
                 }
              }
            else if (arrm[i][6]==1)
              {
               nameObj=prefics+atextm[ii]+" x ISL 38.2";
               ObjectCreate(nameObj,OBJ_ARROW,0,arrm[i][3],arrm[i][4]);
               ObjectSet(nameObj,OBJPROP_ARROWCODE,symb);
               ObjectSet(nameObj,OBJPROP_BACK,mBack);
              }
           }
         else
           {
            if (!exitSL && ii>10) continue;

            if (ii==11 && mAuto && ObjectFind(_nameUTL)<0) visibleTL(pitch_cena, pitch_time, 11, sd);// UTL
            if (ii==12 && mAuto && ObjectFind(_nameLTL)<0) visibleTL(pitch_cena, pitch_time, 12, sd);// LTL
 
            if (ii>12) wl=DoubleToStr(arrm[i][6],3); else wl="";
            if (ii==13 && (mAuto && ObjectFind(_nameUWL)<0)) // UWL
              {
               if (ObjectFind(_nameUTL)<0) visibleTL(pitch_cena, pitch_time, 11, sd);// UTL
               if (sd==0)
                 {
                  visibleWL(pitch_cena, pitch_time, pitch_cena[0], pitch_time[0], pitch_cena[0]-tangensAP*a1, iTime(Symbol(),Period(),0), 13, sd, "", tangensAP, ExtLinePitchforkS, true);
                 }
               else
                 {
                  visibleWL(pitch_cena, pitch_time, pitch_cena[0], pitch_time[0], pitch_cena[0]-tangensAP*a1, iTime(Symbol(),Period(),0), 13, sd, "", tangensAP, ExtLinePitchforkD, true);
                 }
              }

            if (ii==14 && mAuto && ObjectFind(nameLWL)<0) // LWL
              {
               if (ObjectFind(_nameLTL)<0) visibleTL(pitch_cena, pitch_time, 12, sd);// LTL
               if (sd==0)
                 {
                  visibleWL(pitch_cena, pitch_time, pitch_cena[0], pitch_time[0], pitch_cena[0]-tangensAP*a1, iTime(Symbol(),Period(),0), 14, sd, "", tangensAP, ExtLinePitchforkS, true);
                 }
               else
                 {
                  visibleWL(pitch_cena, pitch_time, pitch_cena[0], pitch_time[0], pitch_cena[0]-tangensAP*a1, iTime(Symbol(),Period(),0), 14, sd, "", tangensAP, ExtLinePitchforkD, true);
                 }
              }

            if (aMetki[sd][ii]==1 || (mAuto &&aMetki[sd][ii]==0))
              {
               nameObj=prefics+atextm[ii]+wl+" x 0-bar";
               ObjectCreate(nameObj,OBJ_ARROW,0,iTime(NULL,Period(),0),arrm[i][0]);
               ObjectSet(nameObj,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
               ObjectSet(nameObj,OBJPROP_BACK,mBack);
               if (writetofile)
                 {
                  FileSeek(handle, 0, SEEK_END);
                  FileWrite(handle, 0, ii, aMetki[sd][ii], 0, DoubleToStr(arrm[i][0], Digits), 0, DoubleToStr(iClose(NULL,Period(),0), Digits), sd,
                  DoubleToStr(pitch_cena[0], Digits), DoubleToStr(pitch_cena[1], Digits), DoubleToStr(pitch_cena[2], Digits));
                 }
              }
            else if (aMetki[sd][ii]>1 && arrm[i][4]>0)
              {
               if (aMetki[sd][ii]!=3 && aMetki[sd][ii]!=6 && aMetki[sd][ii]!=8)
                 {
                  nameObj=prefics+atextm[ii]+wl+" left 0-bar";
                  ObjectCreate(nameObj,OBJ_ARROW,0,arrm[i][1],arrm[i][2]);
                  ObjectSet(nameObj,OBJPROP_ARROWCODE,SYMBOL_LEFTPRICE);
                  ObjectSet(nameObj,OBJPROP_BACK,mBack);

                  nameObj=prefics+atextm[ii]+wl+" right 0-bar";
                  ObjectCreate(nameObj,OBJ_ARROW,0,arrm[i][3],arrm[i][4]);
                  ObjectSet(nameObj,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
                  ObjectSet(nameObj,OBJPROP_BACK,mBack);
                 }
 
               if (aMetki[sd][ii]>7)
                 {
                  nameObj=prefics+atextm[ii]+wl+" line Zones";
                  ObjectCreate(nameObj,OBJ_TREND,0,arrm[i][1],arrm[i][2],arrm[i][3],arrm[i][4]);
                  ObjectSet(nameObj,OBJPROP_WIDTH,mLineZonesWidth); 
                  ObjectSet(nameObj,OBJPROP_RAY,false); 
                  ObjectSet(nameObj,OBJPROP_BACK,mBackZones); 
                 }
               else if (aMetki[sd][ii]>2 && aMetki[sd][ii]!=5)
                 {
                  if (aMetki[sd][ii]>5) nameObj=prefics+"Shift "+atextm[ii]+wl+" Zones"; 
                  else nameObj=prefics+atextm[ii]+wl+" Zones";
                  ObjectCreate(nameObj,OBJ_RECTANGLE,0,arrm[i][1],arrm[i][2],arrm[i][3],arrm[i][4]);
                  ObjectSet(nameObj,OBJPROP_BACK,mBackZones);
                 }

               if (writetofile)
                 {
                  FileSeek(handle, 0, SEEK_END);
                  FileWrite(handle, 0, ii, aMetki[sd][ii], DoubleToStr(arrm[i][2], Digits), 0, DoubleToStr(arrm[i][4], Digits), DoubleToStr(iClose(NULL,Period(),0), Digits), sd,
                  DoubleToStr(pitch_cena[0], Digits), DoubleToStr(pitch_cena[1], Digits), DoubleToStr(pitch_cena[2], Digits));
                 }
              }
           }
        }
     }

   if(VariantsPRZ==1)
     {
      checkAP (arrName);

      if (ArraySize(arrName)==0)
        {
         if (mWriteToFile)
           {
            if (FileSize(handle)<1) {FileClose(handle); FileDelete(file);} else FileClose(handle);
           }
         return;
        }

      str1=DoubleToStr(pitch_cena[0], Digits); str2=DoubleToStr(pitch_cena[1], Digits); str3=DoubleToStr(pitch_cena[2], Digits);
/*
mSelectVariantsPRZ
 = 1 - ����� ����������� SSL
 = 2 - ����� ����������� �������
 = 3 - ����� ����������� FSL
 = 4 - ���� ����������� ������ �������
 = 5 - ���� ����������� ������ ��� 
 = 6 - ����� ����������� 1/2 �������
 = 7 - ���� ����������� ������ 1/2 �������
 = 8 - ���� ����������� ������ ����� �����
 = 9 - ����� ����������� UTL, LTL
*/
      if (mSelectVariantsPRZ<6)
        {
         if (mSelectVariantsPRZ==1)       // ����� ����������� SSL
           {
            alAP (c1, pitch_cena[2], 0, 0, tangensAP, prefics+"SSL x ", "", "", arrName, handle, str1 , str2, str3, sd);
           }
         else if (mSelectVariantsPRZ==2)  // ����� ����������� �������
           {
            alAP (a1, pitch_cena[0], 0, 0, tangensAP, prefics+"Mediana x ", "", "", arrName, handle, str1 , str2, str3, sd);
           }
         else if (mSelectVariantsPRZ==3)  // ����� ����������� FSL
           {
            alAP (b1, pitch_cena[1], 0, 0, tangensAP, prefics+"FSL x ", "", "", arrName, handle, str1 , str2, str3, sd);
           }
         else if (mSelectVariantsPRZ==4)  // ���� ����������� ������ �������
           {
            alAP (b1, pitch_cena[1]-hAP*(2-phi), b1, pitch_cena[1]-hAP*(phi-1), tangensAP, prefics+"ISL 38.2 x ", prefics+"ISL 61.8 x ", prefics+"channal Mediana x ", arrName, handle, str1 , str2, str3, sd);
           }
         else if (mSelectVariantsPRZ==5)  // ���� ����������� ������ ���
           {
            alAP (b1, pitch_cena[1], c1, pitch_cena[2], tangensAP, prefics+"SSL x ", prefics+"FSL x ", prefics+"channal AP x ", arrName, handle, str1 , str2, str3, sd);
           }
        }
      else if (mSelectVariantsPRZ<9 && ExtPitchforkStatic==2)
        {
         cena2=pitch_cena[1]-hAP1_2mediana/2;

         if (mSelectVariantsPRZ==6)       // ����� ����������� 1/2 �������
           {
            alAP (b1, cena2, 0, 0, tangens05median, prefics+"50% Mediana x ", "", "", arrName, handle, str1 , str2, str3, sd);
           }
         else if (mSelectVariantsPRZ==7)  // ���� ����������� ������ 1/2 �������
           {
            alAP (b1, pitch_cena[1]-hAP1_2mediana*(phi-1), b1, pitch_cena[1]-hAP1_2mediana*(2-phi), tangens05median, prefics+"SLM 38.2 x ", prefics+"SLM 61.8 x ", prefics+"channal 50% Mediana x ", arrName, handle, str1 , str2, str3, sd);
           }
         else if (mSelectVariantsPRZ==8)  // ���� ����������� ������ ����� �����
           {
            alAP (b1, pitch_cena[1], c1, pitch_cena[2], tangens05median, prefics+"SSL Shiff Line x ", prefics+"FSL Shiff Line x ", prefics+"channal Shiff Line x ", arrName, handle, str1 , str2, str3, sd);
           }
        }
      else if (mSelectVariantsPRZ==9)
        {
         if (ExtLTL) // ����� ����������� LTL
           {
            alAP (a1, pitch_cena[0], 0, 0, tangensLTL, prefics+"LTL x ", "", "", arrName, handle, str1 , str2, str3, sd);
           }

         if (ExtUTL) // ����� ����������� UTL
           {
            alAP (a1, pitch_cena[0], 0, 0, tangensUTL, prefics+"UTL x ", "", "", arrName, handle, str1 , str2, str3, sd);
           }
        }
     }

   // ��������� ���� ��� ������ �����
   if (mWriteToFile)
     {
      mPeriod=mPeriod+mPeriodWriteToFile*60;
      if (FileSize(handle)<1) {FileClose(handle); FileDelete(file);} else FileClose(handle);
     }
  }
//--------------------------------------------------------
// ����� ������� ����� (metkaAP) � ����� �������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���������� ���������� ������� ��� 
// ������.
//--------------------------------------------------------
/*
a1 - ����� ���� ������ ����� 1
cenaA1 - ���� �� ����� 1 �� ���� a1
a2 - ����� ���� ������ ����� 2
cenaA2 - ���� �� ����� 2 �� ���� a2
tangensA - ������� ���� ������� ����� ������� ���
nameMetki1 - ������������ ����� 1
nameMetki2 - ������������ ����� 2
nameZones - ������������ ����
aName[] - ������ � �������������� ������� ���

���� ��������� �����, �� � ������ ������ ����� � ������������ ���� ���������� 0 ��� "" ��� ��������� ����������

int    mSSL
int    mISL382
int    mMediana
int    mISL618
int    mFSL
int    mUWL
int    mLWL

int    m1_2Mediana
int    mSLM
int    mFSLShiffLines

int    mUTL
int    mLTL

*/

void alAP (int a1, double cenaA1, int b1, double cenaB1, double tangensA, string nameMetki1, string nameMetki2, string nameZones, string aName[], int handle, string str1 , string str2, string str3, int sd)
  {
   int      i, j, k, x, y, z , wr, znak;
   int      a2, b2, c2;                 // ������ ����� �������� ������� ���
   double   cPitch[3];                  // ���� � ������ �������� ������� ���
   datetime tPitch[3];                  // ����� � ������ �������� ������� ���
   color    PitchColor;                 // ���� ������� ���, ����������� �������
   double   cena1, cena2, cena3;        // ���� � ������ �������� ������������ ���, ����������� �������
   datetime time1, time2, time3;        // ����� � ������ �������� ������������ ���, ����������� �������
   datetime twr;
   double   tangensAP, tangens05median; // �������� ����� ������� ������� ���.
   double   hAP, hAP1_2mediana;         // 
   bool     typeAP;     //  = - false ���� ������� � ������� ZUP, = true - ���� ������� �������
   string   suffics="", sufficsWL="", suffics_APm="", sufficsWL_APm;    // ������������� �������������� ������������ ��� ������ ���������.
   string   txt="";
   string   nameObjAP="";  // ������������ ������������ ���, ����������� �������
   string   nameObj_="";   // �������� ���
   bool     canal=true; // ���� ������ ����� ��� ����� �� ������� ��� ��� �� ������, ������������� ������������� ������� ���
   string   str="";
   double   fi;

   if (StringLen(nameZones)==0) canal=false;

   for (i=ArraySize(aName)-1;i>=0;i--)
     {
      typeAP=false;
      if (StringFind(aName[i],"Andrews Pitchfork",0)>=0) typeAP=true;
      
      if (typeAP && malHandAP==1) PitchColor=ObjectGet(aName[i],OBJPROP_COLOR);

      // ���������� ������������� �������������� ������������ ��� ������ ���������.
      suffics="";
      sufficsWL="";

      if (StringFind(aName[i],"Andrews Pitchfork",0)>=0)
        {
         suffics=StringSubstr(aName[i],17);
        }
      else
        {
         j=StringFind(aName[i],"_",0);
         suffics=StringSubstr(aName[i],9);
         sufficsWL=StringSubstr(aName[i],10);
         if (StringSubstr(aName[i],9,1)=="S")
           {
            if (StringSubstr(aName[i],j+1,3)=="APm")
              {
               if (j+5<StringLen(aName[i]))
                 {
                  sufficsWL=StrToInteger(StringSubstr(aName[i],10,j-10))+"_"+StringSubstr(aName[i],j+5);
                  suffics="S"+sufficsWL;
                 }
              }
           }
        }
      suffics_APm=suffics;
      sufficsWL_APm=sufficsWL;
      if (StringFind(suffics,"_APm",0)>0)
        {
         suffics_APm=StringSubstr(suffics,0,StringFind(suffics,"APm",0));
         sufficsWL_APm=StringSubstr(sufficsWL,0,StringFind(sufficsWL,"APm",0));
        }

      // ���������� ����� � ���� �����, � ������� ��������� ������� ���� �������
      tPitch[0]=ObjectGet(aName[i],OBJPROP_TIME1); cPitch[0]=ObjectGet(aName[i],OBJPROP_PRICE1);
      tPitch[1]=ObjectGet(aName[i],OBJPROP_TIME2); cPitch[1]=ObjectGet(aName[i],OBJPROP_PRICE2);
      tPitch[2]=ObjectGet(aName[i],OBJPROP_TIME3); cPitch[2]=ObjectGet(aName[i],OBJPROP_PRICE3);
      // ���������� ������ �����, � ������� ��������� ���� �������
      if (typeAP)
        {
         twr=iTime(Symbol(),Period(),0);
         if (tPitch[0]<=twr) a2=iBarShift(NULL,Period(),tPitch[0],false); else a2=-(tPitch[0]-twr)/(Period()*60);
         if (tPitch[1]<=twr) b2=iBarShift(NULL,Period(),tPitch[1],false); else b2=-(tPitch[1]-twr)/(Period()*60);
         if (tPitch[2]<=twr) c2=iBarShift(NULL,Period(),tPitch[2],false); else c2=-(tPitch[2]-twr)/(Period()*60);
        }
      else
        {
         a2=iBarShift(NULL,Period(),tPitch[0],false);
         b2=iBarShift(NULL,Period(),tPitch[1],false);
         c2=iBarShift(NULL,Period(),tPitch[2],false);
        }

      // ������� ���� ������� ��� �������
      tangensAP=0;
      if ((a2-(c2+b2)/2.0)!=0) tangensAP=((cPitch[2]+cPitch[1])/2-cPitch[0])/(a2-(c2+b2)/2.0);

      // ���������� ���������� �� ��������� �� SSL �� FSL - ���� �� ������ ��� �������
      hAP=cPitch[1]+(b2-c2)*tangensAP-cPitch[2];

      if (aMetki[sd][3]>0 || aMetki[sd][2]>0)
        {
         // ������� ���� ������� 1/2 ������� ��� �������
         tangens05median=(cPitch[2]-cPitch[0])/(a2-c2);
         // ���������� ���������� �� ��������� �� SSL �� FSL - ���� �� ������ ��� ����� �����
         hAP1_2mediana=cPitch[1]-(cPitch[2]-tangens05median*(b2-c2));
        }

      if (aMetki[sd][1]>0)
        {
         txt=" SSL "+suffics;
         visual (a1, cenaA1, b1, cenaB1, tangensA, c2, cPitch[2], tangensAP, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][1], handle, 1, str1 , str2, str3);
        }

      if (aMetki[sd][5]>0)
        {
         if (typeAP && malHandAP==1)
           {
            _ISL("ISL_", tPitch, cPitch, PitchColor, STYLE_DASH, 2, suffics);
           }

         if ((typeAP && malHandAP>0) || !typeAP)
           {
            txt=" ISL 38.2 "+suffics;
            visual (a1, cenaA1, b1, cenaB1, tangensA, b2, cPitch[1]-hAP*(phi-1), tangensAP, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][5], handle, 5, str1 , str2, str3);
           }
        }

      if (aMetki[sd][6]>0)
        {
         txt=" Mediana "+suffics;
         visual (a1, cenaA1, b1, cenaB1, tangensA, a2, cPitch[0], tangensAP, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][6], handle, 6, str1 , str2, str3);
        }

      if (aMetki[sd][7]>0)
        {
         if (typeAP && malHandAP==1)
           {
            _ISL("ISL_", tPitch, cPitch, PitchColor, STYLE_DASH, 2, suffics);
           }

         if ((typeAP && malHandAP>0) || !typeAP)
           {
            txt=" ISL 61.8 "+suffics;
            visual (a1, cenaA1, b1, cenaB1, tangensA, b2, cPitch[1]-hAP*(2-phi), tangensAP, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][7], handle, 7, str1 , str2, str3);
           }
        }

      if (aMetki[sd][8]>0)
        {
         txt=" FSL "+suffics;
         visual (a1, cenaA1, b1, cenaB1, tangensA, b2, cPitch[1], tangensAP, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][8], handle, 8, str1 , str2, str3);
        }

      if (aMetki[sd][13]>0 || aMetki[sd][14]>0)
        {
         if (typeAP && malHandAP==1)
           {
            cena1=cPitch[0];
            time1=tPitch[0];
            time2=iTime(Symbol(),Period(),0);
            cena2=cPitch[0]-tangensAP*a2;

            visibleWL(cPitch, tPitch, cena1, time1, cena2, time2, 13, sd, suffics, tangensAP, PitchColor, false); // UWL
            visibleWL(cPitch, tPitch, cena1, time1, cena2, time2, 14, sd, suffics, tangensAP, PitchColor, false); // LWL
           }

         if (aMetki[sd][13]>0)
           {
            if ((typeAP && malHandAP>0) || (!typeAP && ObjectFind("UWL" + sufficsWL_APm)==0))
              {
               if (!typeAP) nameObj_="UWL" + sufficsWL_APm;
               else if (typeAP && malHandAP>0) nameObj_="UWL"+ ExtComplekt+"_" + suffics;

               if (cPitch[1]>cPitch[2])
                 {
                  y=b2;
                  cena3=cPitch[1];
                 }
               else
                 {
                  y=c2;
                  cena3=cPitch[2];
                 }

               if (ObjectFind(nameObj_)>=0)
                 {
                  x=ObjectGet(nameObj_,OBJPROP_FIBOLEVELS);
                  for (k=0;k<x;k++)
                    {
                     txt=" UWL " + DoubleToStr(ObjectGet(nameObj_,OBJPROP_FIRSTLEVEL+k),3) + suffics;
                     visual (a1, cenaA1, b1, cenaB1, tangensA, y, cena3+MathAbs(hAP)*ObjectGet(nameObj_,OBJPROP_FIRSTLEVEL+k)/2,
                      tangensAP, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][13], handle, 13, str1 , str2, str3);
                    }
                 }
               else
                 {
                  if (ExtFiboFreePitchfork || ExtFiboType==2)
                    {
                     str=ExtFiboFreeUWL;
                    }
                  else
                    {
                     str="0.146,0.236,0.382,0.5,0.618,0.764,0.854,1,1.618,2.0,2.618,4.236";
                    }

                  x=quantityFibo (str);
                  for (k=0;k<=x;k++)
                    {
                     z=StringFind(str, ",", 0);
                     fi=StrToDouble(StringTrimLeft(StringTrimRight(StringSubstr(str,0,z))));

                     txt=" UWL " + DoubleToStr(fi,3) + suffics;
                     visual (a1, cenaA1, b1, cenaB1, tangensA, y, cena3+MathAbs(hAP)*fi/2, tangensAP, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][13], handle, 13, str1 , str2, str3);

                     if (z>=0) str=StringSubstr(str,z+1);
                    }
                 }
              }
           }

         if (aMetki[sd][14]>0)
           {
            if ((typeAP && malHandAP>0) || (!typeAP && ObjectFind("LWL" + sufficsWL_APm)==0))
              {
               if (!typeAP) nameObj_="LWL" + sufficsWL_APm;
               else if (typeAP && malHandAP>0) nameObj_="LWL"+ ExtComplekt+"_" + suffics;

               if (cPitch[1]>cPitch[2])
                 {
                  y=c2;
                  cena3=cPitch[2];
                 }
               else
                 {
                  y=b2;
                  cena3=cPitch[1];
                 }

               if (ObjectFind(nameObj_)>=0)
                 {
                  x=ObjectGet(nameObj_,OBJPROP_FIBOLEVELS);
                  for (k=0;k<x;k++)
                    {
                     txt=" LWL " + DoubleToStr(ObjectGet(nameObj_,OBJPROP_FIRSTLEVEL+k),3) + suffics;
                     visual (a1, cenaA1, b1, cenaB1, tangensA, y, cena3-MathAbs(hAP)*ObjectGet(nameObj_,OBJPROP_FIRSTLEVEL+k)/2,
                      tangensAP, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][14], handle, 14, str1 , str2, str3);
                    }
                 }
               else
                 {
                  if (ExtFiboFreePitchfork || ExtFiboType==2)
                    {
                     str=ExtFiboFreeLWL;
                    }
                  else
                    {
                     str="0.146,0.236,0.382,0.5,0.618,0.764,0.854,1,1.618,2.0,2.618,4.236";
                    }

                  x=quantityFibo (str);
                  for (k=0;k<=x;k++)
                    {
                     z=StringFind(str, ",", 0);
                     fi=StrToDouble(StringTrimLeft(StringTrimRight(StringSubstr(str,0,z))));

                     txt=" LWL " + DoubleToStr(fi,3) + suffics;
                     visual (a1, cenaA1, b1, cenaB1, tangensA, y, cena3-MathAbs(hAP)*fi/2, tangensAP, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][14], handle, 14, str1 , str2, str3);

                     if (z>=0) str=StringSubstr(str,z+1);
                    }
                 }
              }
           }
        }

      if (aMetki[sd][3]>0)
        {
         if (typeAP && malHandAP==1)
           {
            coordinaty_1_2_mediany_AP(cPitch[0], cPitch[1], cPitch[2], tPitch[0], tPitch[1], tPitch[2], time1, time2, cena1, cena2, 2, 0);

            nameObjAP="pmediana_" + ExtComplekt+"_" + suffics;

            ObjectDelete(nameObjAP);
            ObjectCreate(nameObjAP,OBJ_TREND,0,time1,cena1,time2,cena2);
            ObjectSet(nameObjAP,OBJPROP_STYLE,STYLE_DASH);
            ObjectSet(nameObjAP,OBJPROP_COLOR,PitchColor);
            ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
           }

         if ((typeAP && malHandAP>0) || (!typeAP && ObjectFind("pmediana"+suffics_APm)==0))
           {
            txt=" 50% Mediana "+suffics;
            visual (a1, cenaA1, b1, cenaB1, tangensA, b2, cPitch[1]-hAP1_2mediana/2, tangens05median, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][3], handle, 3, str1 , str2, str3);
           }
        }

      if (aMetki[sd][2]>0)
        {
         if (typeAP && malHandAP==1)
           {
            if (a2>c2) znak=1;
            else if (a2==c2) znak=0;
            else znak=-1;

            // ����� SLM 38.2
            wr=c2+(b2-c2)*(2-phi);
            cena1=cPitch[1] + (b2-c2)*(phi-1)*tangens05median-hAP1_2mediana*(phi-1);
            if (wr>=0)
              {
               time1=iTime(Symbol(),Period(),wr);
               cena2=cena1+znak*wr*tangens05median;
               if (znak>0) time2=iTime(Symbol(),Period(),0);
               else if (znak<0) time2=iTime(Symbol(),Period(),2*wr);
              }
            else
              {
               time1=iTime(Symbol(),Period(),0)-wr*Period()*60;
               if (znak!=0) cena2=cena1+znak*10*tangens05median;
               else
                 {
                  if (tangens05median>0) cena2=cena1*1.1;
                  else cena2=cena1*0.9;
                 }
               time2=iTime(Symbol(),Period(),0)-(wr-znak*10)*Period()*60;
              }

            nameObjAP="SLM382_" + ExtComplekt+"_" + suffics;
            ObjectDelete(nameObjAP);
            ObjectCreate(nameObjAP,OBJ_TREND,0,time1,cena1,time2,cena2);
            ObjectSet(nameObjAP,OBJPROP_STYLE,STYLE_DASH);
            ObjectSet(nameObjAP,OBJPROP_COLOR,PitchColor);
            ObjectSet(nameObjAP,OBJPROP_BACK,ExtBack);

            // ����� SLM 68.8
            wr=c2+(b2-c2)*(phi-1);
            cena1=cPitch[1] + (b2-c2)*(2-phi)*tangens05median-hAP1_2mediana*(2-phi);
            if (wr>=0)
              {
               time1=iTime(Symbol(),Period(),wr);
               cena2=cena1+znak*wr*tangens05median;
               if (znak>0) time2=iTime(Symbol(),Period(),0);
               else if (znak<0) time2=iTime(Symbol(),Period(),2*wr);
              }
            else
              {
               time1=iTime(Symbol(),Period(),0)-wr*Period()*60;
               if (znak!=0) cena2=cena1+znak*10*tangens05median;
               else
                 {
                  if (tangens05median>0) cena2=cena1*1.1;
                  else cena2=cena1*0.9;
                 }
               time2=iTime(Symbol(),Period(),0)-(wr-znak*10)*Period()*60;
              }
            nameObjAP="SLM618_" + ExtComplekt+"_" + suffics;
            ObjectDelete(nameObjAP);
            ObjectCreate(nameObjAP,OBJ_TREND,0,time1,cena1,time2,cena2);
            ObjectSet(nameObjAP,OBJPROP_STYLE,STYLE_DASH);
            ObjectSet(nameObjAP,OBJPROP_COLOR,PitchColor);
            ObjectSet(nameObjAP,OBJPROP_BACK,ExtBack);
           }

         if ((typeAP && malHandAP>0) || (!typeAP && ObjectFind("SLM382"+suffics_APm)==0))
           {
            txt=" SLM 38.2 "+suffics;
            visual (a1, cenaA1, b1, cenaB1, tangensA, b2, cPitch[1]-hAP1_2mediana*(phi-1), tangens05median, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][2], handle, 2, str1 , str2, str3);
           }

         if ((typeAP && malHandAP>0) || (!typeAP && ObjectFind("SLM618"+suffics_APm)==0))
           {
            txt=" SLM 61.8 "+suffics;
            visual (a1, cenaA1, b1, cenaB1, tangensA, b2, cPitch[1]-hAP1_2mediana*(2-phi), tangens05median, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][4], handle, 4, str1 , str2, str3);
           }
        }

      if (aMetki[sd][9]>0)
        {
         if (typeAP && malHandAP==1)
           {
            if (a2>c2) znak=1;
            else if (a2==c2) znak=0;
            else znak=-1;

            // ����� FSL Shiff Lines
            wr=c2+b2-c2;
            cena1=cPitch[1];
            if (wr>=0)
              {
               time1=tPitch[1];
               cena2=cena1+znak*wr*tangens05median;
               if (znak>0) time2=iTime(Symbol(),Period(),0);
               else if (znak<0) time2=iTime(Symbol(),Period(),2*wr);
              }
            else
              {
               time1=iTime(Symbol(),Period(),0)-wr*Period()*60;
               if (znak!=0) cena2=cena1+znak*10*tangens05median;
               else
                 {
                  if (tangens05median>0) cena2=cena1*1.1;
                  else cena2=cena1*0.9;
                 }
               time2=iTime(Symbol(),Period(),0)-(wr-znak*10)*Period()*60;
              }

            nameObjAP="FSL Shiff Lines_" + ExtComplekt+"_" + suffics;
            ObjectDelete(nameObjAP);
            ObjectCreate(nameObjAP,OBJ_TREND,0,time1,cena1,time2,cena2);
            ObjectSet(nameObjAP,OBJPROP_STYLE,STYLE_DASH);
            ObjectSet(nameObjAP,OBJPROP_COLOR,PitchColor);
            ObjectSet(nameObjAP,OBJPROP_BACK,ExtBack);
           }

         if ((typeAP && malHandAP>0) || (!typeAP && ObjectFind("FSL Shiff Lines "+suffics_APm)==0))
           {
            txt=" FSL Shiff Lines "+suffics;
            visual (a1, cenaA1, b1, cenaB1, tangensA, b2, cPitch[1], tangens05median, nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][9], handle, 9, str1 , str2, str3);
           }
        }

      if (aMetki[sd][11]>0 || aMetki[sd][12]>0)
        {
         if (typeAP && malHandAP==1)
           {
            time1=tPitch[0];
            cena1=cPitch[0];
            if (aMetki[sd][11]>0)
              {
               nameObjAP=nameUTL + suffics;
               if (cPitch[1]>cPitch[2])
                 {
                  time2=tPitch[1];
                  cena2=cPitch[1];
                 }
               else
                 {
                  time2=tPitch[2];
                  cena2=cPitch[2];
                 }
               ObjectDelete(nameObjAP);
               ObjectCreate(nameObjAP,OBJ_TREND,0,time1,cena1,time2,cena2);
               ObjectSet(nameObjAP,OBJPROP_STYLE,STYLE_DASH);
               ObjectSet(nameObjAP,OBJPROP_COLOR,PitchColor);
               ObjectSet(nameObjAP,OBJPROP_BACK,ExtBack);
              }

            if (aMetki[sd][12]>0)
              {
               nameObjAP=nameLTL + suffics;
               if (cPitch[1]>=cPitch[2])
                 {
                  time2=tPitch[2];
                  cena2=cPitch[2];
                 }
               else
                 {
                  time2=tPitch[1];
                  cena2=cPitch[1];
                 }
               ObjectDelete(nameObjAP);
               ObjectCreate(nameObjAP,OBJ_TREND,0,time1,cena1,time2,cena2);
               ObjectSet(nameObjAP,OBJPROP_STYLE,STYLE_DASH);
               ObjectSet(nameObjAP,OBJPROP_COLOR,PitchColor);
               ObjectSet(nameObjAP,OBJPROP_BACK,ExtBack);
              }
           }

         if (aMetki[sd][11]>0)
           {
            if ((typeAP && malHandAP>0) || (!typeAP && ObjectFind("UTL"+sufficsWL_APm)==0))
              {
               txt=" UTL "+suffics;
               if (cPitch[1]>cPitch[2])
                 {
                  visual (a1, cenaA1, b1, cenaB1, tangensA, b2, cPitch[1], (cPitch[1]-cPitch[0])/(a2-b2), nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][11], handle, 11, str1 , str2, str3);
                 }
               else
                 {
                  visual (a1, cenaA1, b1, cenaB1, tangensA, c2, cPitch[2], (cPitch[2]-cPitch[0])/(a2-c2), nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][11], handle, 11, str1 , str2, str3);
                 }
              }
           }

         if (aMetki[sd][12]>0)
           {
            if ((typeAP && malHandAP>0) || (!typeAP && ObjectFind("LTL"+sufficsWL_APm)==0))
              {
               txt=" LTL "+suffics;
               if (cPitch[2]>cPitch[1])
                 {
                  visual (a1, cenaA1, b1, cenaB1, tangensA, b2, cPitch[1], (cPitch[1]-cPitch[0])/(a2-b2), nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][12], handle, 12, str1 , str2, str3);
                 }
               else
                 {
                  visual (a1, cenaA1, b1, cenaB1, tangensA, c2, cPitch[2], (cPitch[2]-cPitch[0])/(a2-c2), nameMetki1+txt, nameMetki2+txt, nameZones+txt, canal, aMetki[sd][12], handle, 12, str1 , str2, str3);
                 }
              }
           }
        }
     }
  }
//--------------------------------------------------------
// ���������� ���������� ������� ��� 
// �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ����� ����������� ����� (TL) - UTL � LTL
// ������.
//--------------------------------------------------------
void visibleTL(double& cPitch[], datetime& tPitch[], int metka, int sd)
  {
   string nameObj="";
   string _nameUTL="", _nameLTL="";

   if (sd==0)
     {
      _nameUTL=nameUTL;
      _nameLTL=nameLTL;
     }
   else
     {
      _nameUTL=nameUTLd;
      _nameLTL=nameLTLd;
     }
   if (metka==11) nameObj=_nameUTL; 
   if (metka==12) nameObj=_nameLTL; 

   if (cPitch[1]>cPitch[2])
     {
      if (metka==11) ObjectCreate(nameObj,OBJ_TREND,0,tPitch[0],cPitch[0],tPitch[1],cPitch[1]);
      if (metka==12) ObjectCreate(nameObj,OBJ_TREND,0,tPitch[0],cPitch[0],tPitch[2],cPitch[2]);
     }
   else
     {
      if (metka==11) ObjectCreate(nameObj,OBJ_TREND,0,tPitch[0],cPitch[0],tPitch[2],cPitch[2]);
      if (metka==12) ObjectCreate(nameObj,OBJ_TREND,0,tPitch[0],cPitch[0],tPitch[1],cPitch[1]);
     }

   ObjectSet(nameObj,OBJPROP_STYLE,STYLE_SOLID);
   if (sd==0) ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
   else ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkD);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
  }
//--------------------------------------------------------
// ����� ����������� ����� (TL) - UTL � LTL
// �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ����� ��������������� ����� (WL) - UWL � LWL
// ������.
//--------------------------------------------------------
void visibleWL(double& cPitch[], datetime& tPitch[], double cena1, datetime time1, double cena2, datetime time2, int metka, int sd, string suffics, double tangensAP, color PitchColor, bool mAuto)
  {
   double   cena3;
   datetime time3;
   string   nameObj="";
   string   _nameUWL="", _nameLWL="";

   if (sd==0)
     {
      _nameUWL=nameUWL;
      _nameLWL=nameLWL;
     }
   else
     {
      _nameUWL=nameUWLd;
      _nameLWL=nameLWLd;
     }

   ML_RL400(-tangensAP, cPitch, tPitch, time2, cena2, false);

   if (mAuto || aMetki[sd][metka]>0)
     {
      if (metka==13)
        {
         nameObj=_nameUWL + suffics;
         if (cPitch[1]>cPitch[2])
           {
            time3=tPitch[1];
            cena3=cPitch[1];
           }
         else
           {
            time3=tPitch[2];
            cena3=cPitch[2];
           }
        }
      if (metka==14)
        {
         nameObj=_nameLWL + suffics;
         if (cPitch[1]>=cPitch[2])
           {
            time3=tPitch[2];
            cena3=cPitch[2];
           }
         else
           {
            time3=tPitch[1];
            cena3=cPitch[1];
           }
        }

      ObjectDelete(nameObj);

      ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,time1,cena1,time2,cena2,time3,cena3);
      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,PitchColor);
      ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
      ObjectSet(nameObj,OBJPROP_RAY,ExtLongWL);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
      ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);

      if (metka==13) UWL_LWL (true,nameObj,"UWL ",ExtFiboFreeUWL);
      if (metka==14) UWL_LWL (true,nameObj,"LWL ",ExtFiboFreeLWL);
     }
  }
//--------------------------------------------------------
// ����� ��������������� ����� (WL) - UWL � LWL
// �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ������� ����� �� ������.                  
// ������.
//--------------------------------------------------------
void visual (int a1, double cenaA1, int a2, double cenaA2, double tgA, int b, double cenaB, double tgB, string m1, string m2, string Zones, bool canal, int metka, int handle, int name, string str1 , string str2, string str3)
  {
   int x, x1;
   double   cena1, cena2;
   datetime tcena1, tcena2;
   string nameObj_="";

   x=(cenaA1-cenaB+tgA*a1-tgB*b)/(tgA-tgB);
   if (x>a1 && !mVisibleST) return;

   if (canal)
     {
      x1=(cenaA2-cenaB+tgA*a2-tgB*b)/(tgA-tgB);
      cena2=cenaA2+(a2-x1)*tgA;
      if (x1>=0) tcena2=iTime(Symbol(),Period(),x1); else tcena2=iTime(Symbol(),Period(),0)-x1*Period()*60;
     }
   cena1=cenaA1+(a1-x)*tgA;
   if (x>=0) tcena1=iTime(Symbol(),Period(),x); else tcena1=iTime(Symbol(),Period(),0)-x*Period()*60;

   if (canal)
     {
      if (handle>=0)
        {
         FileSeek(handle, 0, SEEK_END);
         FileWrite(handle, mSelectVariantsPRZ, name, metka, DoubleToStr(cena1, Digits), 0, DoubleToStr(cena2, Digits), DoubleToStr(iClose(NULL,Period(),0), Digits), mTypeBasiclAP,
          str1, str2, str3);
        }

      if (metka==5 || metka==7 || metka==9)
        {
         nameObj_=m1;
         ObjectCreate(nameObj_,OBJ_ARROW,0,tcena1,cena1);
         if (tcena1<tcena2) ObjectSet(nameObj_,OBJPROP_ARROWCODE,SYMBOL_LEFTPRICE); else ObjectSet(nameObj_,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
         ObjectSet(nameObj_,OBJPROP_BACK,mBack);

         nameObj_=m2;
         ObjectCreate(nameObj_,OBJ_ARROW,0,tcena2,cena2);
         if (tcena1<tcena2) ObjectSet(nameObj_,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE); else ObjectSet(nameObj_,OBJPROP_ARROWCODE,SYMBOL_LEFTPRICE);
         ObjectSet(nameObj_,OBJPROP_BACK,mBack);
        }

      if (metka>7)
        {
         nameObj_=Zones;
         ObjectCreate(nameObj_,OBJ_TREND,0,tcena1,cena1,tcena2,cena2);
         ObjectSet(nameObj_,OBJPROP_WIDTH,mLineZonesWidth); 
         ObjectSet(nameObj_,OBJPROP_RAY,false); 
         ObjectSet(nameObj_,OBJPROP_BACK,mBackZones); 
        }
      else if (metka>5)
        {
         if (metka>5) nameObj_=Zones;
         ObjectCreate(nameObj_,OBJ_RECTANGLE,0,tcena1,cena1,tcena2,cena2);
         ObjectSet(nameObj_,OBJPROP_BACK,mBackZones);
        }
     }
   else
     {
      nameObj_=m1;
      ObjectCreate(nameObj_,OBJ_ARROW,0,tcena1,cena1);
      ObjectSet(nameObj_,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
      ObjectSet(nameObj_,OBJPROP_BACK,mBack);

      if (handle>=0)
        {
         FileSeek(handle, 0, SEEK_END);
         FileWrite(handle, mSelectVariantsPRZ, name, metka, 0, DoubleToStr(cena1, Digits), 0, DoubleToStr(iClose(NULL,Period(),0), Digits), mTypeBasiclAP,
           str1, str2, str3);
        }
     }

  }
//--------------------------------------------------------
// ����� ������� ����� �� ������.                  
// �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ������� ������� ��� ��� ������� ����� ����������� ���
// � ���������� �������� ������� ��� � ������. 
// ������.
//--------------------------------------------------------
void checkAP (string& aName[]) //arrName[]
  {
   int i, j, k;
   string name="";
/*
mTypealAP - ����� ���� ������� ��� 
 = 0 - ������������ ��� ����������� ���� �������� ��������� (��������������� �������)
 = 1 - ����������� ���� �� �������� ���������
 = 2 - ����� ���� �� �������� ���������
 = 3 - ����������� ���� �� ������ ���������� ZUP � �������� �������
 = 4 - ������������ ���� �� ������ ���������� ZUP � �������� �������
 = 5 - ����� ���� �� ������ ���������� ZUP � �������� �������
 = 6 - ���� � �������� �������, ���������� �������, �� � ������� ZUP
 = 7 - ����� ������� ����

mTypeBasiclAP - ����� ���� ������� ���
 = 0 - ����������� ���� �� �������� ���������
 = 1 - ������������ ���� �� �������� ���������
*/
// mSelectVariantsPRZ ExtMasterPitchfork       nameObjAPMaster="Master_"+nameObj;

   j=ObjectsTotal();
   SlavePitchfork = false;
   if (ExtMasterPitchfork==0)
     {
      k=0;
      for (i=0; i<j; i++)
        {
         name=ObjectName(i);
         if (ObjectType(name)==OBJ_PITCHFORK)
           {
            if (StringFind(name,"Master_",0)>=0)
             {
              k++;
              ArrayResize(aName,k);
              aName[k-1]=StringSubstr(name,7);
              SlavePitchfork = true;
              return;
             }
           }
        }
     }

   k=0;
   if (mTypealAP==0)       // ������������ ��� ����������� ���� �������� ��������� (��������������� �������)
     {
      if (mTypeBasiclAP==0)      // ������������ ���� �������� ���������
        {
         name="pitchforkD" + ExtComplekt+"_";
         if (ObjectFind(name)==0)
           {
            ArrayResize(aName,1);
            aName[0]=name;
           }
        }
      else if (mTypeBasiclAP==1) // ����������� ���� �������� ���������
        {
         name="pitchforkS" + ExtComplekt+"_";
         if (ObjectFind(name)==0)
           {
            ArrayResize(aName,1);
            aName[0]=name;
           }
         else
           {
            name="pitchforkS" + ExtComplekt+"_"+"_APm_";
            if (ObjectFind(name)==0)
              {
               ArrayResize(aName,1);
               aName[0]=name;
              }
           }
        }
     }
   else if (mTypealAP==1)  // ����������� ���� �� �������� ���������
     {
      for (i=0; i<j; i++)
        {
         name=ObjectName(i);
         if (ObjectType(name)==OBJ_PITCHFORK)
           {
            if (StringFind(name,"pitchforkS" + ExtComplekt+"_",0)>=0 && StringLen(name)>StringLen("pitchforkS" + ExtComplekt+"_")+4)
             {
              k++;
              ArrayResize(aName,k);
              aName[k-1]=name;
             }
           }
        }
     }
   else if (mTypealAP==2)  // ����� ���� �� �������� ���������
     {
      if (mTypeBasiclAP==0)
        {
         for (i=0; i<j; i++)
           {
            name=ObjectName(i);
            if (ObjectType(name)==OBJ_PITCHFORK)
              {
               if (StringFind(name,"pitchforkS" + ExtComplekt+"_",0)>=0 && StringLen(name)>StringLen("pitchforkS" + ExtComplekt+"_")+4)
                 {
                  k++;
                  ArrayResize(aName,k);
                  aName[k-1]=name;
                 }
              }
           }
         name="pitchforkD" + ExtComplekt+"_";
         if (ObjectFind(name)==0)
           {
            k++;
            ArrayResize(aName,k);
            aName[k-1]=name;
           }
        }
      else if (mTypeBasiclAP==1)
        {
         for (i=0; i<j; i++)
           {
            name=ObjectName(i);
            if (ObjectType(name)==OBJ_PITCHFORK)
              {
               if (StringFind(name,"pitchforkS" + ExtComplekt+"_",0)>=0)
                 {
                  k++;
                  ArrayResize(aName,k);
                  aName[k-1]=name;
                 }
              }
           }
        }
     }
   else if (mTypealAP==3)  // ����������� ���� �� ������ ���������� ZUP � �������� �������
     {
      for (i=0; i<j; i++)
        {
         name=ObjectName(i);
         if (ObjectType(name)==OBJ_PITCHFORK)
           {
            if (StringFind(name,"pitchforkS" + ExtComplekt+"_",0)<0 && StringFind(name,"pitchforkS",0)>=0)
              {
               k++;
               ArrayResize(aName,k);
               aName[k-1]=name;
              }
           }
        }
     }
   else if (mTypealAP==4)  // ������������ ���� �� ������ ���������� ZUP � �������� �������
     {
      for (i=0; i<j; i++)
        {
         name=ObjectName(i);
         if (ObjectType(name)==OBJ_PITCHFORK)
           {
            if (StringFind(name,"pitchforkD" + ExtComplekt+"_",0)<0 && StringFind(name,"pitchforkD",0)>=0)
              {
               k++;
               ArrayResize(aName,k);
               aName[k-1]=name;
              }
           }
        }
     }
   else if (mTypealAP==5)  // ����� ���� �� ������ ���������� ZUP � �������� �������
     {
      for (i=0; i<j; i++)
        {
         name=ObjectName(i);
         if (ObjectType(name)==OBJ_PITCHFORK)
           {
            if (StringFind(name,"pitchforkD" + ExtComplekt+"_",0)<0 && StringFind(name,"pitchforkD",0)>=0)
              {
               k++;
               ArrayResize(aName,k);
               aName[k-1]=name;
              }

            if (StringFind(name,"pitchforkS" + ExtComplekt+"_",0)<0 && StringFind(name,"pitchforkS",0)>=0)
              {
               k++;
               ArrayResize(aName,k);
               aName[k-1]=name;
              }
           }
        }
     }
   else if (mTypealAP==6)  // ���� � �������� �������, ���������� �������, �� � ������� ZUP
     {
      for (i=0; i<j; i++)
        {
         name=ObjectName(i);
         if (ObjectType(name)==OBJ_PITCHFORK)
           {
            if (StringFind(name,"Andrews Pitchfork",0)>=0)
              {
               k++;
               ArrayResize(aName,k);
               aName[k-1]=name;
              }
           }
        }
     }
   else if (mTypealAP==7)  // ����� ������� ����
     {
      if (mTypeBasiclAP==0)
        {
         for (i=0; i<j; i++)
           {
            name=ObjectName(i);
            if (ObjectType(name)==OBJ_PITCHFORK)
              {
               if (StringFind(name,"pitchforkS",0)>=0 && (StringLen(name)>StringLen("pitchforkS" + ExtComplekt+"_")+4 || StringFind(name,"pitchforkS" + ExtComplekt+"_",0)<0))
                 {
                  k++;
                  ArrayResize(aName,k);
                  aName[k-1]=name;
                 }

               if (StringFind(name,"pitchforkD",0)>=0)
                 {
                  k++;
                  ArrayResize(aName,k);
                  aName[k-1]=name;
                 }

               if (StringFind(name,"Andrews Pitchfork",0)>=0)
                 {
                  k++;
                  ArrayResize(aName,k);
                  aName[k-1]=name;
                 }
              }
           }
        }
      else if (mTypeBasiclAP==1)
        {
         for (i=0; i<j; i++)
           {
            name=ObjectName(i);
            if (ObjectType(name)==OBJ_PITCHFORK)
              {
               if (StringFind(name,"pitchforkD",0)>=0 && (StringLen(name)>StringLen("pitchforkD" + ExtComplekt+"_")+4 || StringFind(name,"pitchforkD" + ExtComplekt+"_",0)<0))
                 {
                  k++;
                  ArrayResize(aName,k);
                  aName[k-1]=name;
                 }

               if (StringFind(name,"pitchforkS",0)>=0)
                 {
                  k++;
                  ArrayResize(aName,k);
                  aName[k-1]=name;
                 }

               if (StringFind(name,"Andrews Pitchfork",0)>=0)
                 {
                  k++;
                  ArrayResize(aName,k);
                  aName[k-1]=name;
                 }
              }
           }
        }
     }
  }
//--------------------------------------------------------
// �������� ������� ������� ��� ��� ������� ����� ����������� ���
// � ���������� �������� ������� ��� � ������. 
// �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���������� ������� ���������� RL ��� ������� ������� 
// ����� (metkaAP) � ����� �������. ������.
//--------------------------------------------------------
void RLtoArray (double& aRL[], string nameRL, string fiboFree)
  {
   int i, j, k;
   string str;
   if(ObjectFind(nameRL)>-1)
     {
      j=ObjectGet(nameRL,OBJPROP_FIBOLEVELS);
      ArrayResize(aRL,j);
      k=0;
      if (ExtFiboFreePitchfork || ExtFiboType==2) k=0;
      else if (ExtFiboType==0)
        {
         if (ExtRL146)
           {
            aRL[0]=0.146;
            k=1;
           }
        }
      else if (ExtFiboType==1)
        {
         if (ExtRL146)
           {
            aRL[0]=0.146;
            aRL[1]=0.236;
            k=2;
           }
        }

      for (i=0;k<j;i++)
        {
         aRL[k]=ObjectGet(nameRL,OBJPROP_FIRSTLEVEL+i);
         k++;
        }
     }
   else
     {
      if (ExtFiboFreePitchfork || ExtFiboType==2)
        {
         j=quantityFibo (fiboFree);
         str=fiboFree;
        }
      else if (ExtFiboType==1)
        {
         if (ExtRL146) j=16; else j=14;
         str="0.382,0.5,0.618,0.707,0.786,0.886,1,1.128,1.272,1.414,1.618,2.0,2.414,2.618,4.236,0.146,0.236";
        }
      else if (ExtFiboType==0)
        {
         if (ExtRL146) j=12; else j=11;
         str="0.236,0.382,0.5,0.618,0.764,0.854,1,1.236,1.618,2.0,2.618,4.236,0.146";
        }
      ArrayResize(aRL,j);

      for (i=0;i<=j;i++)
        {
         k=StringFind(str, ",", 0);
         aRL[i]=StrToDouble(StringTrimLeft(StringTrimRight(StringSubstr(str,0,k))));

         if (k>=0) str=StringSubstr(str,k+1);
        }
     }

   ArraySort(aRL);
  }
//--------------------------------------------------------
// ���������� ������� ���������� RL ��� ������� ������� 
// ����� (metkaAP) � ����� �������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� UWL_LWL. ������.
//--------------------------------------------------------
void UWL_LWL (bool visible, string nameObj_, string WL, string fiboFree)
  {
   int i,j,k;
   string str="";
   double fi;

   if (ExtFiboFreePitchfork || ExtFiboType==2)
     {
      str=fiboFree;
     }
   else
     {
      str="0.146,0.236,0.382,0.5,0.618,0.764,0.854,1,1.618,2.0,2.618,4.236";
     }

   j=quantityFibo (str);
   ObjectSet(nameObj_,OBJPROP_FIBOLEVELS,j+1);
   for (i=0;i<=j;i++)
     {
      k=StringFind(str, ",", 0);
      fi=StrToDouble(StringTrimLeft(StringTrimRight(StringSubstr(str,0,k))));

      ObjectSet(nameObj_,OBJPROP_FIRSTLEVEL+i,fi);
      if (visible) ObjectSetFiboDescription(nameObj_, i, WL+DoubleToStr(fi*100,1));

      if (k>=0) str=StringSubstr(str,k+1);
     }
  }
//--------------------------------------------------------
// ����� UWL_LWL. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����-Time. ������.
//--------------------------------------------------------
void fiboTimeX()
  {
   bool  ft1, ft2, ft3;
   color ftc1, ftc2, ftc3;

   ft1=ExtFiboTime1;
   ft2=ExtFiboTime2;
   ft3=ExtFiboTime3;
   ftc1=ExtFiboTime1C;
   ftc2=ExtFiboTime2C;
   ftc3=ExtFiboTime3C;

   if (ExtFiboTimeNum>2)
     {
      ft1=ExtFiboTime1x;
      ft2=ExtFiboTime2x;
      ft3=ExtFiboTime3x;
      ftc1=ExtFiboTime1Cx;
      ftc2=ExtFiboTime2Cx;
      ftc3=ExtFiboTime3Cx;

      int mft[]={0,0,0};
      string aa=DoubleToStr(ExtFiboTimeNum,0);
      double ftmincena;

      mft[0]=StrToInteger(StringSubstr(aa,0,1));
      mft[1]=StrToInteger(StringSubstr(aa,1,1));
      mft[2]=StrToInteger(StringSubstr(aa,2,1));
      ArraySort(mft,WHOLE_ARRAY,0,MODE_DESCEND);

      if (mft[0]<3) ExtFiboTimeNum=0;
      else
        {
         if (mft[1]==1) mft[1]++;
         if (mft[1]==0) {mft[1]=mft[0]-1; mft[2]=mft[1]-1;}
         if (mft[2]==0) mft[2]=mft[1]-1;
        }

      if (afrx[mft[0]]<afrx[mft[1]]) ftmincena=afrx[mft[0]]; else ftmincena=afrx[mft[1]];
      if (ftmincena>afrx[mft[2]]) ftmincena=afrx[mft[2]];

     }

   if (ft1)
     {
      if (ExtFiboTimeNum>2)
        {
         nameObj="fiboTime1Free" + ExtComplekt+"_";
        }
      else
        {
         nameObj="fiboTime1" + ExtComplekt+"_";
        }

      if (ExtSave)
        {
         if (ExtFiboTimeNum>2)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
            }
        }

      ObjectDelete(nameObj);

      if (ExtFiboTimeNum>2)
        {
         ObjectCreate(nameObj,OBJ_FIBOTIMES,0,afr[mft[0]],ftmincena-5*Point,afr[mft[2]],ftmincena-5*Point);
        }
      else
        {
         if (ExtPitchforkCandle)
           {
            if (!ExtPitchfork_1_HighLow)
              {
               if (mPitchCena[0]>mPitchCena[2])
                 {
                  ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[2]-5*Point,mPitchTime[2],mPitchCena[2]-5*Point);
                 }
               else
                 {
                  ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[0]-5*Point,mPitchTime[2],mPitchCena[0]-5*Point);
                 }
              }
            else
              {
               ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[1]-5*Point,mPitchTime[2],mPitchCena[1]-5*Point);
              }
           }
         else
           {
            if (afrl[mPitch[0]]>0)
              {
               if (afrl[mPitch[0]]>afrl[mPitch[2]])
                 {
                  ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[2]-5*Point,mPitchTime[2],mPitchCena[2]-5*Point);
                 }
               else
                 {
                  ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[0]-5*Point,mPitchTime[2],mPitchCena[0]-5*Point);
                 }
              }
            else
              {
               ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[1]-5*Point,mPitchTime[2],afrl[mPitch[1]]-5*Point);
              }
           }
         }
       

      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ftc1);

      if (ExtFiboTimeNum>2)
        {
         fiboTime (nameObj, afr[mft[0]], afr[mft[2]]-afr[mft[0]], 0, "FT1_");
        }
      else
        {
         fiboTime (nameObj, mPitchTime[0], mPitchTime[2]-mPitchTime[0], 0, "FT1 ");
        }
     }

   if (ft2)
     {
      if (ExtFiboTimeNum>2)
        {
         nameObj="fiboTime2Free" + ExtComplekt+"_";
        }
      else
        {
         nameObj="fiboTime2" + ExtComplekt+"_";
        }

      if (ExtSave)
        {
         if (ExtFiboTimeNum>2)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
            }
        }

      ObjectDelete(nameObj);

      if (ExtFiboTimeNum>2)
        {
         ObjectCreate(nameObj,OBJ_FIBOTIMES,0,afr[mft[1]],(afrx[mft[2]]+afrx[mft[1]])/2,afr[mft[2]],(afrx[mft[2]]+afrx[mft[1]])/2);
        }
      else
        {
         ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[1],(mPitchCena[2]+mPitchCena[1])/2,mPitchTime[2],(mPitchCena[2]+mPitchCena[1])/2);
        }

      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ftc2);

      if (ExtFiboTimeNum>2)
        {
         fiboTime (nameObj, afr[mft[1]], afr[mft[2]]-afr[mft[1]], 1, "FT2_");
        }
      else
        {
         fiboTime (nameObj, mPitchTime[1], mPitchTime[2]-mPitchTime[1], 1, "FT2 ");
        }
     }

   if (ft3)
     {
      datetime shiftTime;

      if (ExtFiboTimeNum>2)
        {
         shiftTime=afr[mft[1]]-afr[mft[0]];
         nameObj="fiboTime3Free" + ExtComplekt+"_";
        }
      else
        {
         shiftTime=mPitchTime[1]-mPitchTime[0];
         nameObj="fiboTime3" + ExtComplekt+"_";
        }

      if (ExtSave)
        {
         if (ExtFiboTimeNum>2)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
            }
        }

      ObjectDelete(nameObj);

      if (ExtFiboTimeNum>2)
        {
         ObjectCreate(nameObj,OBJ_FIBOTIMES,0,afr[mft[2]]-shiftTime,(afrx[mft[2]]+afrx[mft[1]])/2-8*Point,afr[mft[2]],(afrx[mft[2]]+afrx[mft[1]])/2-8*Point);
        }
      else
        {
         ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[2]-shiftTime,(mPitchCena[2]+mPitchCena[1])/2-8*Point,mPitchTime[2],(mPitchCena[2]+mPitchCena[1])/2-8*Point);
        }

      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ftc3);

      if (ExtFiboTimeNum>2)
        {
         fiboTime (nameObj, afr[mft[2]]-shiftTime, shiftTime, 2, "FT3_");
        }
      else
        {
         fiboTime (nameObj, mPitchTime[2]-shiftTime, shiftTime, 2, "FT3 ");
        }
     }

  }
//--------------------------------------------------------
// ����-Time. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����-Time. ������.
//--------------------------------------------------------
void fiboTime (string nameObj, datetime t1, datetime t2, int number, string ftx)
  {
   string str="", str1="";
   double fi;
   int j,k;

   int   ftvisibleDT;
   string ftvisible="";
  
   if (ExtFiboTimeNum>2)
     {
      ftvisibleDT=ExtVisibleDateTimex;
      ftvisible=ExtVisibleNumberFiboTimex;
     }
   else
     {
      ftvisibleDT=ExtVisibleDateTime;
      ftvisible=ExtVisibleNumberFiboTime;
     }

   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

   if (ExtFiboFreePitchfork || ExtFiboType==2) // ���� ����-Time � ����������������� �������.
     {
      if (number==0)
        {
         str=ExtFiboFreeFT1;
        }
      else if (number==1)
        {
         str=ExtFiboFreeFT2;
        }
      else if (number==2)
        {
         str=ExtFiboFreeFT3;
        }
     }
   else if (ExtFiboType==1) // ���� ����-Time � ������� ���������.
     {
      str="0.382,0.5,0.618,0.707,0.786,0.886,1.0,1.272,1.414,1.618,2.0,2.414,2.618,3.0";
     }
   else if (ExtFiboType==0) // ���� ����-Time �� ������������ �������.
     {
      str="0.146,0.236,0.382,0.5,0.618,0.764,0.854,1.0,1.236,1.382,1.618,2.0,2.618,3.0,4.236";
     }

   j=quantityFibo (str);
   ObjectSet(nameObj,OBJPROP_FIBOLEVELS, j+3);

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,0.0);
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,1.0);
   if (ftvisibleDT && StringSubstr(ftvisible,number,1)=="1")
     {
      ObjectSetFiboDescription(nameObj, 0, ftx + "0" + " " + TimeToStr(t1,TIME_DATE|TIME_MINUTES));
      ObjectSetFiboDescription(nameObj, 1, ftx + "1.0" + " " + TimeToStr(t1 + t2,TIME_DATE|TIME_MINUTES));
     }
   else
     {
      ObjectSetFiboDescription(nameObj, 0, ftx + "0");
      ObjectSetFiboDescription(nameObj, 1, ftx + "1.0");
     }

   for (int i=0; i<=j; i++)
     {
      k=StringFind(str, ",", 0);
      str1=StringTrimLeft(StringTrimRight(StringSubstr(str,0,k)));
      fi=StrToDouble(str1);
      if (fi<1) str1=StringSubstr(str1,1);

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+(i+2),fi+1);
      if (ftvisibleDT && StringSubstr(ftvisible,number,1)=="1")
        {
         ObjectSetFiboDescription(nameObj, i+2, ftx + str1 + " " + TimeToStr(t1 + t2*(fi+1),TIME_DATE|TIME_MINUTES));
        }
      else
        {
         ObjectSetFiboDescription(nameObj, i+2, ftx + str1);
        }
      if (k>=0) str=StringSubstr(str,k+1);
     }

  }
//--------------------------------------------------------
// ����-Time. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������� ���. ������.
//--------------------------------------------------------
int quantityFibo (string sFibo)
  {
   int j=0,i,k;

   while (true)
     {
      k=StringFind(sFibo, ",",i+1);
      if (k>0) {j++; i=k;}
      else return (j);
     }
  }
//--------------------------------------------------------
// ������� ���. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ��� ������� ������������. ������.
//--------------------------------------------------------
void screenPitchforkD()
  {
   int i;
   double b1,ab1,bc1,ab2,bc2,d,cena,m618=phi-1,m382=2-phi,wr,wr1,wr2;
   datetime tb1,tab2,tbc2,twr1,twr2;
   int    a0,b0,c0;
   int    pitch_time[]={0,0,0}; 
   double pitch_cena[]={0,0,0};

   mPitchTime[0]=afr[2]; mPitchTime[1]=afr[1]; mPitchTime[2]=afr[0];
   mPitchCena[0]=afrx[2]; mPitchCena[1]=afrx[1]; mPitchCena[2]=afrx[0];

   if (mPitchTime[0]==0) return;

   cena=afrx[2]; 

   if (afrl[2]>0)
     {
      if (ExtCM_0_1A_2B_Dinamic==1)
        {
         cena=mPitchCena[0]+(mPitchCena[1]-mPitchCena[0])*ExtCM_FiboDinamic;
        }
      else if (ExtCM_0_1A_2B_Dinamic==4)
        {
         mPitchTimeSave=mPitchTime[0];
         mPitchTime[0]=mPitchTime[1];
         if (maxGipotenuza4(mPitchTime,mPitchCena))
           {
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
           }
         else
           {
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
           }
        }
      else if (ExtCM_0_1A_2B_Dinamic==5)
        {
         mPitchTimeSave=mPitchTime[0];
         mPitchTime[0]=mPitchTime[1];
         if (maxGipotenuza5(mPitchTime,mPitchCena))
           {
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
           }
         else
           {
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
           }
        }
      else if (ExtCM_0_1A_2B_Dinamic>1)
        {
         if (ExtCM_0_1A_2B_Dinamic==2) mPitchTime[0]=mPitchTime[1];
         cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*ExtCM_FiboDinamic;
        }
     }
   else
     {
      if (ExtCM_0_1A_2B_Dinamic==1)
        {
         cena=mPitchCena[0]-(mPitchCena[0]-mPitchCena[1])*ExtCM_FiboDinamic;
        }
      else if (ExtCM_0_1A_2B_Dinamic==4)
        {
         mPitchTimeSave=mPitchTime[0];
         mPitchTime[0]=mPitchTime[1];
         if (maxGipotenuza4(mPitchTime,mPitchCena))
           {
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
           }
         else
           {
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
           }
        }
      else if (ExtCM_0_1A_2B_Dinamic==5)
        {
         mPitchTimeSave=mPitchTime[0];
         mPitchTime[0]=mPitchTime[1];
         if (maxGipotenuza5(mPitchTime,mPitchCena))
           {
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
           }
         else
           {
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
           }
        }
      else if (ExtCM_0_1A_2B_Dinamic>1)
        {
         if (ExtCM_0_1A_2B_Dinamic==2) mPitchTime[0]=mPitchTime[1];
         cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*ExtCM_FiboDinamic;
        }
     }

   mPitchCena[0]=cena;

   coordinaty_1_2_mediany_AP(mPitchCena[0], mPitchCena[1], mPitchCena[2], mPitchTime[0], mPitchTime[1], mPitchTime[2], tab2, tbc2, ab1, bc1, ExtPitchforkDinamic, ExtPitchforkDinamicCustom);
      
   pitch_time[0]=tab2;pitch_cena[0]=ab1;

   nameObj="pmedianaD" + ExtComplekt+"_";
   ObjectDelete(nameObj);
     
   if (ExtPitchforkDinamic==2)
     {
      ObjectCreate(nameObj,OBJ_TREND,0,tab2,ab1,tbc2,bc1);
      ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
      ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkD);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      if (ExtSLMDinamic)
        {
         b0=iBarShift(Symbol(),Period(),mPitchTime[1]);
         c0=iBarShift(Symbol(),Period(),mPitchTime[2]);

         // �������� slm
         wr=(ObjectGetValueByShift(nameObj,c0)-mPitchCena[2])*(1-2*m382);

         //����� ���� ����� 1
         a0=c0-(c0-b0)*m382-1;
         // ����� ����� 1
         twr1=iTime(Symbol(),Period(),a0);
         // ���� ����� 1
         wr1=ObjectGetValueByShift(nameObj,a0)-wr;
         // ���������� ����� 2
         wr2=ObjectGetValueByShift(nameObj,0)-wr;
         twr2=iTime(Symbol(),Period(),0);

         nameObj="SLM382D" + ExtComplekt+"_";
         ObjectDelete(nameObj);
         ObjectCreate(nameObj,OBJ_TREND,0,twr1,wr1,twr2,wr2);
         ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtSLMDinamicColor);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

         //����� ���� ����� 1
         a0=c0-(c0-b0)*m618-1;
         // ����� ����� 1
         twr1=iTime(Symbol(),Period(),a0);
         // ���� ����� 1
         nameObj="pmedianaD" + ExtComplekt+"_";
         wr1=ObjectGetValueByShift(nameObj,a0)+wr;
         // ���������� ����� 2
         wr2=ObjectGetValueByShift(nameObj,0)+wr;
         twr2=iTime(Symbol(),Period(),0);

         nameObj="SLM618D" + ExtComplekt+"_";
         ObjectDelete(nameObj);
         ObjectCreate(nameObj,OBJ_TREND,0,twr1,wr1,twr2,wr2);
         ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtSLMDinamicColor);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
        }

      if (ExtFSLShiffLinesDinamic)
        {
         c0=iBarShift(Symbol(),Period(),mPitchTime[1]);

         // ����� ����� 1
         twr1=mPitchTime[1];
         // ���� ����� 1
         wr1=mPitchCena[1];
         // ���������� ����� 2
         nameObj="pmedianaD" + ExtComplekt+"_";
         wr2=ObjectGetValueByShift(nameObj,0)-ObjectGetValueByShift(nameObj,c0)+mPitchCena[1];
         twr2=iTime(Symbol(),Period(),0);

         nameObj="FSL Shiff Lines D" + ExtComplekt+"_";
         ObjectDelete(nameObj);
         ObjectCreate(nameObj,OBJ_TREND,0,twr1,wr1,twr2,wr2);
         ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtFSLShiffLinesDinamicColor);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
        }

      nameObj="1-2pmedianaD" + ExtComplekt+"_";
      ObjectDelete(nameObj);
      ObjectCreate(nameObj,OBJ_TEXT,0,tab2,ab1+3*Point);
      ObjectSetText(nameObj,"     1/2 ML",9,"Arial", ExtLinePitchforkD);
     }

   nameObj="pitchforkD" + ExtComplekt+"_";

   if (ExtPitchforkDinamic!=4)
     {
      pitch_time[0]=mPitchTime[0];pitch_cena[0]=mPitchCena[0];
      if (ExtPitchforkDinamic==3) pitch_cena[0]=ab1;
     }
   pitch_time[1]=mPitchTime[1];pitch_cena[1]=mPitchCena[1];
   pitch_time[2]=mPitchTime[2];pitch_cena[2]=mPitchCena[2];

   // ����� ����� � ����� �������
   mAPd=false;
   if (ObjectFind(nameObj)>=0)
     {
      if (mAP)
        {
         if (ObjectGet(nameObj,OBJPROP_TIME1)!=pitch_time[0] || ObjectGet(nameObj,OBJPROP_PRICE1)!=pitch_cena[0] ||
             ObjectGet(nameObj,OBJPROP_TIME2)!=pitch_time[1] || ObjectGet(nameObj,OBJPROP_PRICE2)!=pitch_cena[1] ||
             ObjectGet(nameObj,OBJPROP_TIME3)!=pitch_time[2] || ObjectGet(nameObj,OBJPROP_PRICE3)!=pitch_cena[2])
           {
            mAPd=true; RZd=-1;
           }
        } 

      ObjectDelete(nameObj);
     }
   else if (mAP) {mAPd=true; RZd=-1;}

   if (mAuto_d)
     {
      ObjectDelete(nameUWLd);
      ObjectDelete(nameLWLd);
      ObjectDelete(nameUTLd);
      ObjectDelete(nameLTLd);

      if (mOutRedZone)
        {
         pitch_timeD[0]=pitch_time[0];pitch_cenaD[0]=pitch_cena[0];
         pitch_timeD[1]=pitch_time[1];pitch_cenaD[1]=pitch_cena[1];
         pitch_timeD[2]=pitch_time[2];pitch_cenaD[2]=pitch_cena[2];
         aOutRedZone[0]=false;
         _RZ("RZD", ExtRZDinamicValue, ExtRZDinamicColor, pitch_timeD, pitch_cenaD, ExtRedZoneDinamic, 1, false);
        }
     }

   ObjectCreate(nameObj,OBJ_PITCHFORK,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1],pitch_time[2],pitch_cena[2]);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtPitchforkStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtPitchforkWidth);
   ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkD);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   if (ExtMasterPitchfork==1)
     {
      nameObjAPMaster="Master_"+nameObj;
      ObjectDelete(nameObjAPMaster);
      ObjectCreate(nameObjAPMaster,OBJ_PITCHFORK,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1],pitch_time[2],pitch_cena[2]);
      ObjectSet(nameObjAPMaster,OBJPROP_STYLE,ExtPitchforkStyle);
      ObjectSet(nameObjAPMaster,OBJPROP_WIDTH,ExtPitchforkWidth);
      ObjectSet(nameObjAPMaster,OBJPROP_COLOR,CLR_NONE);
      ObjectSet(nameObjAPMaster,OBJPROP_BACK,true);
     }

   if (ExtPivotZoneDinamicColor>0 && ExtPitchforkDinamic<4) PivotZone(pitch_time, pitch_cena, ExtPivotZoneDinamicColor, "PivotZoneD");

   if (ExtFiboFanMedianaDinamicColor>0)
     {
      coordinaty_mediany_AP(pitch_cena[0], pitch_cena[1], pitch_cena[2], pitch_time[0], pitch_time[1], pitch_time[2], tb1, b1);      

      nameObj="FanMedianaDinamic" + ExtComplekt+"_";
      ObjectDelete(nameObj);

      ObjectCreate(nameObj,OBJ_FIBOFAN,0,pitch_time[0],pitch_cena[0],tb1,b1);
      ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DASH);
      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanMedianaDinamicColor);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      if (ExtFiboType==0)
        {
         screenFibo_st();
        }
      else if (ExtFiboType==1)
        {
         screenFibo_Pesavento();
        }
      else if (ExtFiboType==2)
        {
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
         for (i=0;i<Sizefi;i++)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
            ObjectSetFiboDescription(nameObj, i, fitxt100[i]); 
           }
        }
     }

//-------------------------------------------------------

   if (ExtISLChannelDinamicColor>0)
     {
      channelISL(pitch_cena[0], pitch_cena[1], pitch_cena[2], pitch_time[0], pitch_time[1], pitch_time[2], 1);
     }

//--------------------------------------------------------

   if (ExtISLDinamic)
     {
      _ISL("ISL_D", pitch_time, pitch_cena, ExtLinePitchforkD, ExtISLStyleDinamic, 1, "");
     }

//--------------------------------------------------------

   if (ExtRLDinamic)
     {
      _RL("RLineD", pitch_time, pitch_cena, ExtLinePitchforkD, ExtRLStyleDinamic, ExtVisibleRLDinamic, 1, "");
     }
//--------------------------------------------------------
   if (ExtRedZoneDinamic>0)
     {
      _RZ("RZD", ExtRZDinamicValue, ExtRZDinamicColor, pitch_time, pitch_cena, ExtRedZoneDinamic, 1, true);
     }
//--------------------------------------------------------

  }
//--------------------------------------------------------
// ����� ��� ������� ������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ISL. ������.
//--------------------------------------------------------
void _ISL(string nameISL, datetime pitch_time[], double pitch_cena[], color lineColor, int lineStyle, int StaticDinamic, string suffcs)
// StaticDinamic 0 - Static, 1 - Dinamic
  {
   int i,j,k, a, b, c, znak=1;
   string str="";
   double fi,a1,b1,c1,tangens,x;
   datetime ta1,tb1,tc1;
   datetime twr;

   if (pitch_time[2]<pitch_time[1]) znak=-1;

   twr=iTime(Symbol(),Period(),0);
   if (twr>=pitch_time[0]) a=iBarShift(Symbol(),Period(),pitch_time[0]); else a=-(pitch_time[0]-twr)/(Period()*60);
   if (twr>=pitch_time[1]) b=iBarShift(Symbol(),Period(),pitch_time[1]); else b=-(pitch_time[1]-twr)/(Period()*60);
   if (twr>=pitch_time[2]) c=iBarShift(Symbol(),Period(),pitch_time[2]); else c=-(pitch_time[2]-twr)/(Period()*60);

   x=a-(b+c)/2.0;

   ta1=pitch_time[1];
   a1=pitch_cena[1];
   tangens=znak*(pitch_cena[0]-(pitch_cena[1]+pitch_cena[2])/2.0)/x;

   ML_RL400(tangens, pitch_cena, pitch_time, tb1, b1, true);

   tc1=pitch_time[2];
   c1=pitch_cena[2];

   nameObj=nameISL + ExtComplekt+"_" + suffcs;
   if (ExtSave && nameISL=="ISL_S")
     {
      if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
        {
         nameObj=nameObj + save;
        }
      else
        {
         if (mPitch[2]>0)
           {
            nameObj=nameObj + save;
           }
        }
      }

   ObjectDelete(nameObj);

   ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tc1,c1);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,lineColor);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,lineStyle);
   ObjectSet(nameObj,OBJPROP_LEVELWIDTH,ExtISLWidth);
   ObjectSet(nameObj,OBJPROP_RAY,false);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);

   if (StaticDinamic==2)
     {
      str="0.618,0.382";
     }
   else if (ExtFiboFreePitchfork || ExtFiboType==2)
     {
      if (StaticDinamic==0)
        {
         str=ExtFiboFreeISLStatic ;
        }
      else
        {
         str=ExtFiboFreeISLDinamic;
        }
     }
   else if (ExtFiboType==0)
     {
      str="0.854,0.764,0.618,0.382,0.236,0.146";
     }
   else if (ExtFiboType==1)
     {
      str="0.886,0.786,0.618,0.382,0.236,0.146";
     }

   j=quantityFibo (str);
   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,j+1);
   for (i=0;i<=j;i++)
     {
      k=StringFind(str, ",", 0);
      fi=StrToDouble(StringTrimLeft(StringTrimRight(StringSubstr(str,0,k))));

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,-fi);
      if (StaticDinamic==0)
        {
         if (ExtVisibleISLStatic) ObjectSetFiboDescription(nameObj, i," ISL "+DoubleToStr(fi*100,1));
        }
      else if (StaticDinamic==1)
        {
         if (ExtVisibleISLDinamic) ObjectSetFiboDescription(nameObj, i," ISL "+DoubleToStr(fi*100,1));
        }
      else
        {
         if (mVisibleISL) ObjectSetFiboDescription(nameObj, i," ISL "+DoubleToStr(fi*100,1));
        }

      if (k>=0) str=StringSubstr(str,k+1);
     }
  }
//--------------------------------------------------------
// ����� ISL. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� RLine. ������.
//--------------------------------------------------------
void _RL(string nameRL, datetime pitch_time[], double pitch_cena[], color lineColor, int lineStyle, bool visibleRL, int StaticDinamic, string RZ)
// StaticDinamic 0 - Static, 1 - Dinamic
  {
   string str="";
   double fi;
   int i,j,k,n,nbase1,nbase2,mirror1,mirror2;
   double a1,b1,c1;
   datetime ta1,tb1,tc1;
   
   n=iBarShift(Symbol(),Period(),pitch_time[0])-(iBarShift(Symbol(),Period(),pitch_time[1])+iBarShift(Symbol(),Period(),pitch_time[2]))/2.0;

   nbase1=iBarShift(Symbol(),Period(),mPitchTime[1]);
   nbase2=iBarShift(Symbol(),Period(),mPitchTime[2]);

   if (nbase1+n<=Bars)
     {
      mirror1=1;
      mirror2=0;

      ta1=Time[nbase1+n];
      tb1=Time[nbase2+n];
      tc1=mPitchTime[1];

      a1=(pitch_cena[0]-(mPitchCena[1]+mPitchCena[2])/2)+mPitchCena[1];
      b1=(pitch_cena[0]-(mPitchCena[1]+mPitchCena[2])/2)+mPitchCena[2];
      c1=mPitchCena[1];
     }
   else
     {
      mirror1=-1;
      mirror2=-1;

      ta1=mPitchTime[2];
      tb1=mPitchTime[1];
      tc1=Time[nbase2+n];

      a1=mPitchCena[2];
      b1=mPitchCena[1];
      c1=(pitch_cena[0]-(mPitchCena[1]+mPitchCena[2])/2)+mPitchCena[2];
     }

   nameObj=nameRL + ExtComplekt+"_";
   if (nameRL=="RZS" || nameRL=="RZD")
     {
      if (ExtSave && nameRL=="RZS")
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }
      j=1;
      str=RZ;
     }
   else
     {
      if (ExtSave && nameRL=="RLineS")
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }

      if (ExtFiboFreePitchfork || ExtFiboType==2)
        {
         if (StaticDinamic==0)
           {
            j=quantityFibo (ExtFiboFreeRLStatic);
            str=ExtFiboFreeRLStatic;
           }
         else
           {
            j=quantityFibo (ExtFiboFreeRLDinamic);
            str=ExtFiboFreeRLDinamic;
           }
        }
      else if (ExtFiboType==1)
        {
         if (ExtRL146) j=16; else j=14;
         str="0.382,0.5,0.618,0.707,0.786,0.886,1,1.128,1.272,1.414,1.618,2.0,2.414,2.618,4.236,0.146,0.236";
        }
      else if (ExtFiboType==0)
        {
         if (ExtRL146) j=12; else j=11;
         str="0.236,0.382,0.5,0.618,0.764,0.854,1,1.236,1.618,2.0,2.618,4.236,0.146";
        }
     }

   ObjectDelete(nameObj);

   ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tc1,c1);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,lineColor);

   if (ExtRLineBase) 
     {
      ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
     }
   else
     {
      ObjectSet(nameObj,OBJPROP_COLOR,lineColor);
     }

   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,lineStyle);
   ObjectSet(nameObj,OBJPROP_RAY,false);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,j+1);
   for (i=0;i<=j;i++)
     {
      k=StringFind(str, ",", 0);
      fi=StrToDouble(StringTrimLeft(StringTrimRight(StringSubstr(str,0,k))));

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,mirror2+mirror1*fi);
      if (visibleRL) ObjectSetFiboDescription(nameObj, i, " RL "+DoubleToStr(fi*100,1));

      if (k>=0) str=StringSubstr(str,k+1);
     }
  }
//--------------------------------------------------------
// ����� RLine. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� RedZone. ������.
//--------------------------------------------------------
void _RZ(string nameRZ, double RZValue, color RZColor, datetime pitch_time[], double pitch_cena[], int RedZone, int StaticDinamic, bool visible)
  {
   int i,j,k,n,_nbase1,_nbase2;
   double b1=0,hRZ=0,delta=0,h=0,hbase=0,tangens23=0,tangensMediana=0,n1,nbase0=0,nbase1=0,nbase2=0;
   datetime tb1;

   nbase0=iBarShift(Symbol(),Period(),pitch_time[0]);
   nbase1=iBarShift(Symbol(),Period(),pitch_time[1]);
   nbase2=iBarShift(Symbol(),Period(),pitch_time[2]);
   _nbase1=iBarShift(Symbol(),Period(),pitch_time[1]);
   _nbase2=iBarShift(Symbol(),Period(),pitch_time[2]);

   if ((nbase1-nbase2)==0) return;
   tangens23=(pitch_cena[2]-pitch_cena[1])/(nbase1-nbase2);
   n1=nbase0-(nbase1+nbase2)/2;
   if (n1==0) return;
   tangensMediana=((pitch_cena[2]+pitch_cena[1])/2-pitch_cena[0])/n1;

   if (pitch_cena[1]>pitch_cena[2])
     {
      for (i=_nbase1-1;i>=_nbase2;i--)
        {
         delta=(pitch_cena[1]+(_nbase1-i)*tangens23)-High[i];
         if (delta<h) h=delta;
        }
     }
   else
     {
      for (i=_nbase1-1;i>=_nbase2;i--)
        {
         delta=(pitch_cena[1]+(_nbase1-i)*tangens23)-Low[i];
         if (delta>h) h=delta;
        }
     }

   if (!visible) // ������� �� ����� �� ������� ����
     {
      if (pitch_cena[1]>pitch_cena[2])
        {
         for (i=nbase2+1;i>=0;i--)
           {
            delta=(pitch_cena[1]+(_nbase1-i)*tangens23)-High[i];
            if (delta<h)
              {
               if (nameRZ=="RZS") {aOutRedZone[1]=true; return;}
               if (nameRZ=="RZD") {aOutRedZone[0]=true; return;}
               if (nameRZ=="RZ_") {aOutRedZone[2]=true; return;}
              }
           }
        }
      else
        {
         for (i=nbase2+1;i>=0;i--)
           {
            delta=(pitch_cena[1]+(_nbase1-i)*tangens23)-Low[i];
            if (delta>h)
              {
               if (nameRZ=="RZS") {aOutRedZone[1]=true; return;}
               if (nameRZ=="RZD") {aOutRedZone[0]=true; return;}
               if (nameRZ=="RZ_") {aOutRedZone[2]=true; return;}
              }
           }
        } 

      return;
     }

   if (tangens23==0) return;
   hbase=pitch_cena[0]-(pitch_cena[1]-(nbase0-nbase1)*tangens23);
   hRZ=hbase*RZValue;

   if (RedZone>1)
     {
      if (hbase==0) return;
      if (StaticDinamic==0)
        {
         _RL("RZS", pitch_time, pitch_cena, ExtRZStaticColor, ExtRLStyleStatic, true, 0, DoubleToStr(MathAbs(h/hbase),3));
        }
      else
        {
         _RL("RZD", pitch_time, pitch_cena, ExtRZDinamicColor, ExtRLStyleDinamic, true, 1, DoubleToStr(MathAbs(h/hbase),3));
        }
     }
   else
     {
      if (infoTF)
        {
         if (hbase==0) return;
         if (nameRZ=="RZS")
           {
            info_RZS_RL=DoubleToStr(MathAbs(100*h/hbase),1);
           }
         else if (nameRZ=="RZD")
           {
            info_RZD_RL=DoubleToStr(MathAbs(100*h/hbase),1);
           }
        }

      if (MathAbs(hRZ)<MathAbs(h)) hRZ=h;

      for (i=1;i<100;i++)
        {
         if (MathAbs(hRZ)<=MathAbs(tangens23*i)+MathAbs(tangensMediana*i)) break;
        }
      n=nbase2-i;

      if (n>=0) tb1=Time[n];
      else tb1=Time[0]+MathAbs(n)*60*Period();

      b1=pitch_cena[2]+i*tangens23-hRZ;

      nameObj=nameRZ + ExtComplekt+"_";

      ObjectDelete(nameObj);

      ObjectCreate(nameObj,OBJ_CHANNEL,0,pitch_time[2],pitch_cena[2],tb1,b1,pitch_time[1],pitch_cena[1]);
      ObjectSet(nameObj, OBJPROP_COLOR, RZColor); 
      ObjectSet(nameObj, OBJPROP_BACK, true);
      ObjectSet(nameObj, OBJPROP_RAY, false);
     }

  }
//--------------------------------------------------------
// ����� RedZone. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������������ ������ ������ �� ISL .382 - .618. ������.
//--------------------------------------------------------
void channelISL(double A_1, double B_2, double C_3, datetime T_1, datetime T_2, datetime T_3, int StaticDinamic)
  {
   double tangens;
   int    n1, n2, n3, nc1, nb1;
   double c1, c2, b1, b2, nc1_, nb1_;
   string nameObj="";

   // ������ �����, �� ������� �������� ���� �������
   n1=iBarShift(Symbol(),Period(),T_1);
   n2=iBarShift(Symbol(),Period(),T_2);
   n3=iBarShift(Symbol(),Period(),T_3);

   // ������� ���� ������� ������� ��� �������
   tangens=((C_3 + B_2)/2 -A_1)/(n1-(n2 + n3)/2.0);
   // ������ ����� ����� 1 (nc1) � 3 (nb1) ��� �������� ������, ����������� �� n3
   nc1_=(n2-n3)*(2.0-phi);
   nb1_=(n2-n3)*(phi-1);
   nc1=nc1_;
   nb1=nb1_;

   // ��������� ���� � ������ 1 � 3 ��� �������� ������
   c2=C_3+(B_2+(n2-n3)*tangens-C_3)*(2-phi);
   b2=C_3+(B_2+(n2-n3)*tangens-C_3)*(phi-1);
   c1=c2-tangens*nc1;
   b1=b2-tangens*nb1;

   nameObj="CISL" + ExtComplekt+"_" + StaticDinamic;
   ObjectDelete(nameObj);

   ObjectCreate(nameObj,OBJ_CHANNEL,0,Time[nc1+n3],c1,Time[0],c2+tangens*n3,Time[nb1+n3],b1); // Time[n3],b2);
   ObjectSet(nameObj, OBJPROP_BACK, true);
   if (StaticDinamic==0)
     {
      ObjectSet(nameObj, OBJPROP_COLOR, ExtISLChannelStaticColor); 
     }
   else
     {
      ObjectSet(nameObj, OBJPROP_COLOR, ExtISLChannelDinamicColor); 
     }

  }
//--------------------------------------------------------
// ������������ ������ ������ �� ISL .382 - .618. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������������ ������� ��������� 1/2 ������� ��� �������. ������.
//--------------------------------------------------------
// ������������ ��������� ���� � ����� ���� ����� ��� �������
// � ����� ������ �� ���������� - 
// tAB2, tBC2 - ����� �����, ����� ������� ���������� 1/2 �������
// AB2, BC2 - ������� �������� �����, ����� ������� ���������� 1/2 �������
// 
void coordinaty_1_2_mediany_AP(double A_1, double B_2, double C_3, datetime T_1, datetime T_2, datetime T_3, datetime& tAB2, datetime& tBC2, double& AB2, double& BC2, int type, double Custom)
  {
   double tangens;
   int    n1, n2, n3, nab2, nbc2;
   datetime twr;

   // ������ �����, �� ������� �������� ���� �������
   twr=iTime(Symbol(),Period(),0);
   if (T_1<=twr) n1=iBarShift(Symbol(),Period(),T_1); else n1=-(T_1-twr)/(Period()*60);
   if (T_2<=twr) n2=iBarShift(Symbol(),Period(),T_2); else n2=-(T_2-twr)/(Period()*60);
   if (T_3<=twr) n3=iBarShift(Symbol(),Period(),T_3); else n3=-(T_3-twr)/(Period()*60);

   // ������� ���� ������� 1/2 ������� ��� �������
   if ((n1 - n3)==0) return;
   tangens=(C_3 - A_1)/(n1 - n3);
   // ������ �����, ����� ������� ����� ��������� 1/2 �������
   nab2=MathCeil((n1+n2)/2.0);
   nbc2=MathCeil((n2+n3)/2.0);
   
   // �������� ���� �����, ����� ������� ����� ��������� 1/2 �������
   if (type!=3)
     {
      AB2=(A_1 + B_2)/2 - (nab2-(n1+n2)/2.0)*tangens;
     }
   else
     {
      if (type==3 && Custom<0.00000001)
        {
         AB2=(A_1 + B_2)/2;
        }
      else if (Custom>8.99999999)
        {
         AB2=(A_1 + C_3)/2;
        }
      else
        {
         AB2=B_2+(C_3-B_2)*Custom;
        }
     }
   BC2=(B_2 + C_3)/2 - (nbc2-(n2+n3)/2.0)*tangens;
   // ����� �����, ����� ������� ����� ��������� 1/2 �������
   if (nab2>=0) tAB2=iTime(Symbol(),Period(),nab2); else tAB2=iTime(Symbol(),Period(),0)-nab2*Period()*60;
   if (nbc2>=0) tBC2=iTime(Symbol(),Period(),nbc2); else tBC2=iTime(Symbol(),Period(),0)-nbc2*Period()*60;
  }
//--------------------------------------------------------
// ������������ ������� ��������� 1/2 ������� ��� �������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������������ ������� ���������� ����� �� ������� ��� �������. ������.
//--------------------------------------------------------
// ������������ ��������� ���� � ����� ���� ����� ��� �������
// � ����� ������ �� ���������� - 
// tAB2, tBC2 - ����� �����, ����� ������� ���������� 1/2 �������
// AB2, BC2 - ������� �������� �����, ����� ������� ���������� 1/2 �������
// 
void coordinaty_mediany_AP(double A_1, double B_2, double C_3, datetime T_1, datetime T_2, datetime T_3, datetime& tB1, double& B1)
  {
   double tangens;
   int    n1, n2, n3, nbc2;
   
   // ������ �����, �� ������� �������� ���� �������
   n1=iBarShift(Symbol(),Period(),T_1);
   n2=iBarShift(Symbol(),Period(),T_2);
   n3=iBarShift(Symbol(),Period(),T_3);
   
   // ������� ���� ������� ������� ��� �������
   if ((n1 - (n3+n2)/2.0)==0) return;
   tangens=(A_1-(C_3+B_2)/2)/(n1 - (n3+n2)/2.0);
   if (tangens==0) return;
   // ����� ����, ����� ������� �������� �������
   nbc2=MathCeil((n2+n3)/2.0);

   // �������� ���� �����, ����� ������� �������� �������
   B1=(B_2 + C_3)/2 - ((n2+n3)/2.0-nbc2)*tangens;

   // ����� ����, ����� ������� �������� �������
   tB1=Time[nbc2];
  }
//--------------------------------------------------------
// ������������ ������� ���������� ����� �� ������� ��� �������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ��������� ��������� ��� ExtCM_0_1A_2B=4. ������.
//-------------------------------------------------------
bool maxGipotenuza4(datetime pitch_time1[], double pitch_cena1[])
  {
   double k2,k3;
   datetime k4,k5;

   k2=MathAbs(pitch_cena1[0]-pitch_cena1[1])/ASBar;
   k3=MathAbs(pitch_cena1[1]-pitch_cena1[2])/ASBar;
   k4=iBarShift(NULL,GrossPeriod,mPitchTimeSave)-iBarShift(NULL,GrossPeriod,pitch_time1[1]);
   k5=iBarShift(NULL,GrossPeriod,pitch_time1[1])-iBarShift(NULL,GrossPeriod,pitch_time1[2]);

   if (k2*k2+k4*k4>k3*k3+k5*k5) return(true); else return(false);
  }
//--------------------------------------------------------
// ��������� ��������� ��� ExtCM_0_1A_2B=4. �����.
//-------------------------------------------------------

//--------------------------------------------------------
// ��������� ��������� ��� ExtCM_0_1A_2B=5. ������.
//-------------------------------------------------------
bool maxGipotenuza5(datetime pitch_time1[], double pitch_cena1[])
  {
   double k2,k3;
   datetime k4,k5;

   k2=MathAbs(pitch_cena1[0]-pitch_cena1[1])/Point;
   k3=MathAbs(pitch_cena1[1]-pitch_cena1[2])/Point;
   k4=iBarShift(NULL,GrossPeriod,mPitchTimeSave)-iBarShift(NULL,GrossPeriod,pitch_time1[1]);
   k5=iBarShift(NULL,GrossPeriod,pitch_time1[1])-iBarShift(NULL,GrossPeriod,pitch_time1[2]);

   if (k2*k2+k4*k4>k3*k3+k5*k5) return(true); else return(false);
  }
//--------------------------------------------------------
// ��������� ��������� ��� ExtCM_0_1A_2B=5. �����.
//-------------------------------------------------------

//--------------------------------------------------------
// Pivot Zone. ������.
//-------------------------------------------------------
void PivotZone(datetime pitch_time1[], double pitch_cena1[], color PivotZoneColor, string name)
  {
   datetime ta1, tb1;
   double a1, b1, d, n1;
   int m, m1, m2;
  
   ta1=pitch_time1[2];
   a1=pitch_cena1[2];
   m1=iBarShift(Symbol(),Period(),pitch_time1[0])-iBarShift(Symbol(),Period(),pitch_time1[1]);
   m2=iBarShift(Symbol(),Period(),pitch_time1[1])-iBarShift(Symbol(),Period(),pitch_time1[2]);
   m=iBarShift(Symbol(),Period(),pitch_time1[2]);
   n1=iBarShift(Symbol(),Period(),pitch_time1[0])-(iBarShift(Symbol(),Period(),pitch_time1[1])+iBarShift(Symbol(),Period(),pitch_time1[2]))/2.0;
   d=(pitch_cena1[0]-(pitch_cena1[1]+pitch_cena1[2])/2.0)/n1;

   if (m1>m2)
     {
      if (m1>m)
        {
         tb1=Time[0]+(m1-m)*Period()*60;
        }
      else
        {
         tb1=Time[iBarShift(Symbol(),Period(),pitch_time1[2])-m1];
        }
      b1=pitch_cena1[0]-d*(2*m1+m2);
     }
   else
     {
      if (m2>m)
        {
         tb1=Time[0]+(m2-m)*Period()*60;
        }
      else
        {
         tb1=Time[iBarShift(Symbol(),Period(),pitch_time1[2])-m2];
        }
      b1=pitch_cena1[0]-d*(2*m2+m1);
     }

   nameObj=name + ExtComplekt+"_";
   ObjectDelete(nameObj);

   ObjectCreate(nameObj,OBJ_RECTANGLE,0,ta1,a1,tb1,b1);
   ObjectSetText(nameObj,"PZ "+Period_tf+"  "+TimeToStr(tb1,TIME_DATE|TIME_MINUTES));
   ObjectSet(nameObj, OBJPROP_BACK, ExtPivotZoneFramework);
   ObjectSet(nameObj, OBJPROP_COLOR, PivotZoneColor); 
  }
//--------------------------------------------------------
// Pivot Zone. �����.
//-------------------------------------------------------

//--------------------------------------------------------
// ����������� ����� ����������� RL400 �������. ������.
//-------------------------------------------------------
// flag=true - �������������� ISL
// flag=false - �������������� UWL/LWL
void ML_RL400(double Tangens, double pitch_cena1[], datetime pitch_time1[], int& tB1, double& B1, bool flag)
  {
   int m, m1, m2, a, b, c;
   datetime twr;

   twr=iTime(Symbol(),Period(),0);
   if (twr>=pitch_time1[0]) a=iBarShift(Symbol(),Period(),pitch_time1[0]); else a=-(pitch_time1[0]-twr)/(Period()*60);
   if (twr>=pitch_time1[1]) b=iBarShift(Symbol(),Period(),pitch_time1[1]); else b=-(pitch_time1[1]-twr)/(Period()*60);
   if (twr>=pitch_time1[2]) c=iBarShift(Symbol(),Period(),pitch_time1[2]); else c=-(pitch_time1[2]-twr)/(Period()*60);

   m1=a;
 
   m2=MathCeil((b+c)/2.0);
   m=(m1-m2)*6.85; // *4  04-01-2012

   if (m>m2)
     {
      tB1=Time[0]+(m-m2)*Period()*60;
      if (tB1<0) tB1=2133648000;
      if (flag)
        {
         B1=pitch_cena1[1]-Tangens*(b+(tB1-Time[0])/(60*Period()));
        }
      else
        {
         B1=pitch_cena1[0]-Tangens*(a+(tB1-Time[0])/(60*Period()));
        }
     }
   else
     {
      tB1=Time[m2-m];
      if (flag) B1=pitch_cena1[1]-Tangens*(b-iBarShift(Symbol(),Period(),tB1));
      else  B1=pitch_cena1[0]-Tangens*(a-iBarShift(Symbol(),Period(),tB1));

     }
  }
//--------------------------------------------------------
// ����������� ����� ����������� RL400 �������. �����.
//-------------------------------------------------------

//--------------------------------------------------------
// ����� ������������ ����������. ������.
//--------------------------------------------------------
void screenFiboFan()
  {
   int i;
   double a1,b1;  

   a1=afrx[mFan[0]]; b1=afrx[mFan[1]];
  
   nameObj="FiboFan" + ExtComplekt+"_";

   if (mFan[1]>0)
     {
      if (ExtSave)
        {
         nameObj=nameObj + save;
        }
     }

   ObjectDelete(nameObj);

   ObjectCreate(nameObj,OBJ_FIBOFAN,0,afr[mFan[0]],a1,afr[mFan[1]],b1);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,ExtFanStyle);
   ObjectSet(nameObj,OBJPROP_LEVELWIDTH,ExtFanWidth);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanColor);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);

   if (ExtFiboType==0)
     {
      screenFibo_st();
     }
   else if (ExtFiboType==1)
     {
      screenFibo_Pesavento();
     }
   else if (ExtFiboType==2)
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
      for (i=0;i<Sizefi;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
         ObjectSetFiboDescription(nameObj, i, fitxt100[i]); 
        }
     }

  }
//--------------------------------------------------------
// ����� ������������ ����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������ ����������� ��� ��� ������������ ������. ������.
//--------------------------------------------------------
void screenFibo_st()
  {
   double   fi_1[]={0.236, 0.382, 0.5, 0.618, 0.764, 0.854, 1.0, phi, 2.618};
   string   fitxt100_1[]={"23.6", "38.2", "50.0", "61.8", "76.4", "85.4", "100.0", "161.8", "2.618"};
   int i;
   Sizefi_1=9;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj, i, fitxt100_1[i]); 
     }
  }
//--------------------------------------------------------
// ������ ����������� ��� ��� ������������ ������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������ ��� ��������� ��� ������������ ������. ������.
//--------------------------------------------------------
void screenFibo_Pesavento()
  {
   double   fi_1[]={0.382, 0.5, 0.618, 0.786, 0.886, 1.0, 1.272, phi, 2.0, 2.618};
   string   fitxt100_1[]={"38.2", "50.0", "61.8", "78.6", "88.6", "100.0", "127.2", "161.8", "200.0", "2.618"};
   int i;
   Sizefi_1=10;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj, i, fitxt100_1[i]); 
     }
  }
//--------------------------------------------------------
// ������ ��� ��������� ��� ������������ ������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ��� �����������. ������.
//--------------------------------------------------------
void screenFiboS()
  {
   nameObj="fiboS" + ExtComplekt+"_";
   if (mFibo[1]>0)
     {
      if (ExtSave)
        {
         nameObj=nameObj + save;
        }
     }

   screenFibo_(ExtFiboS, "                             ", mFibo[0], mFibo[1]);
  }
//--------------------------------------------------------
// ����� ��� �����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ��� ������������. ������.
//--------------------------------------------------------
void screenFiboD()
  {
   nameObj="fiboD" + ExtComplekt+"_";
   screenFibo_(ExtFiboD, "", 1, 0);
  }
//--------------------------------------------------------
// ����� ��� ������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ���. ������.
//--------------------------------------------------------
void screenFibo_(color colorFibo, string otstup, int a1, int a2)
  {
   double fibo_0, fibo_100, fiboPrice, fiboPrice1;

   ObjectDelete(nameObj);

   if (!ExtFiboCorrectionExpansion)
     {
      fibo_0=afrx[a1];fibo_100=afrx[a2];
      fiboPrice=afrx[a1]-afrx[a2];fiboPrice1=afrx[a2];
     }
   else
     {
      fibo_100=afrx[a1];fibo_0=afrx[a2];
      fiboPrice=afrx[a2]-afrx[a1];fiboPrice1=afrx[a1];
     }

   if (!ExtFiboCorrectionExpansion)
     {
      ObjectCreate(nameObj,OBJ_FIBO,0,afr[a1],fibo_0,afr[a2],fibo_100);
     }
   else
     {
      ObjectCreate(nameObj,OBJ_FIBO,0,afr[a2],fibo_0,afr[a1],fibo_100);
     }

   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,colorFibo);

   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,ExtFiboStyle);
   ObjectSet(nameObj,OBJPROP_LEVELWIDTH,ExtFiboWidth);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

   if (ExtFiboType==0)
     {
      fibo_standart(fiboPrice, fiboPrice1,"-"+Period_tf+otstup);
     }
   else if (ExtFiboType==1)
     {
      fibo_patterns(fiboPrice, fiboPrice1,"-"+Period_tf+otstup);
     }
   else if (ExtFiboType==2)
     {
      fibo_custom(fiboPrice, fiboPrice1,"-"+Period_tf+otstup);
     }
  }
//--------------------------------------------------------
// �������� ���. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� �����������. ������.
//--------------------------------------------------------
void fibo_standart(double fiboPrice,double fiboPrice1,string fibo)
  {
   double   fi_1[]={0, 0.146, 0.236, 0.382, 0.5, 0.618, 0.764, 0.854, 1.0, 1.236, phi, 2.618, 4.236, 6.854};
   string   fitxt100_1[]={"0.0", "14.6", "23.6", "38.2", "50.0", "61.8", "76.4", "85.4", "100.0", "123.6", "161.8", "2.618", "423.6", "685.4"};
   int i;
   Sizefi_1=14;

   if (!ExtFiboCorrectionExpansion)
     {   
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
      for (i=0;i<Sizefi_1;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
         ObjectSetFiboDescription(nameObj, i, fitxt100_1[i]+" "+"  %$"+fibo); 
        }
     }
   else
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1+2);

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,0);
      ObjectSetFiboDescription(nameObj, 0, "Fe 1 "+"  %$"+fibo); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,1);
      ObjectSetFiboDescription(nameObj, 1, "Fe 0 "+"  %$"+fibo); 

      for (i=1;i<Sizefi_1;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i+2,1+fi_1[i]);
         ObjectSetFiboDescription(nameObj, i+2, "Fe "+fitxt100_1[i]+" "+"  %$"+fibo); 
        }
     }
  }
//--------------------------------------------------------
// ���� �����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� � ����������. ������.
//--------------------------------------------------------
void fibo_patterns(double fiboPrice,double fiboPrice1,string fibo)
  {
   double   fi_1[]={0.0, 0.382, 0.447, 0.5, 0.618, 0.707, 0.786, 0.854, 0.886, 1.0, 1.128, 1.272, 1.414, phi, 2.0, 2.618, 4.236};
   string   fitxt100_1[]={"0.0", "38.2", "44.7", "50.0", "61.8", "70.7", "78.6", "85.4", "88.6", "100.0", "112.8", "127.2", "141.4", "161.8", "200.0", "261.8", "423.6"};
   int i;
   Sizefi_1=17;

   if (!ExtFiboCorrectionExpansion)
     {   
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
      for (i=0;i<Sizefi_1;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
         ObjectSetFiboDescription(nameObj, i, fitxt100_1[i]+" "+"  %$"+fibo); 
        }
     }
   else
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1+2);

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,0);
      ObjectSetFiboDescription(nameObj, 0, "Fe 1 "+"  %$"+fibo); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,1);
      ObjectSetFiboDescription(nameObj, 1, "Fe 0 "+"  %$"+fibo); 

      for (i=1;i<Sizefi_1;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i+2,1+fi_1[i]);
         ObjectSetFiboDescription(nameObj, i+2, "Fe "+fitxt100_1[i]+" "+"  %$"+fibo); 
        }
     }
  }
//--------------------------------------------------------
// ���� � ����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� ����������������. ������.
//--------------------------------------------------------
void fibo_custom(double fiboPrice,double fiboPrice1,string fibo)
  {
   int i;

   if (!ExtFiboCorrectionExpansion)
     {   
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
      for (i=0;i<Sizefi;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
         ObjectSetFiboDescription(nameObj, i, fitxt100[i]+" "+"  %$"+fibo); 
        }
     }
   else
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi+2);

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,0);
      ObjectSetFiboDescription(nameObj, 0, "Fe 1 "+"  %$"+fibo); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,1);
      ObjectSetFiboDescription(nameObj, 1, "Fe 0 "+"  %$"+fibo); 

      for (i=0;i<Sizefi;i++)
        {
         if (fi[i]>0)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i+2,1+fi[i]);
            ObjectSetFiboDescription(nameObj, i+2, "Fe "+fitxt100[i]+" "+"  %$"+fibo); 
           }
        }
     }
  }
//--------------------------------------------------------
// ���� ����������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ����-��� �����������. ������.
//--------------------------------------------------------
void screenFiboArcS()
  {
   double fibo_0, fibo_100, AutoScale;

   fibo_0=afrx[mArcS[0]];fibo_100=afrx[mArcS[1]];

   if (ExtArcStaticScale>0)
     {
      AutoScale=ExtArcStaticScale;
     }
   else
     {
      AutoScale=(MathAbs(fibo_0-fibo_100)/Point)/MathAbs(iBarShift(Symbol(),Period(),afr[mArcS[1]])-iBarShift(Symbol(),Period(),afr[mArcS[0]]));
     }

   nameObj="FiboArcS" + ExtComplekt+"_";
   if (ExtSave)
     {
      nameObj=nameObj + save;
     }
   ObjectDelete(nameObj);

   ObjectCreate(nameObj,OBJ_FIBOARC,0,afr[mArcS[0]],fibo_0,afr[mArcS[1]],fibo_100);

   fiboArc(AutoScale, ExtArcStaticColor);
  }
//--------------------------------------------------------
// ����� ����-��� �����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ����-��� ������������. ������.
//--------------------------------------------------------
void screenFiboArcD()
  {
   double fibo_0, fibo_100, AutoScale;

   fibo_0=afrx[mArcD[0]];fibo_100=afrx[mArcD[1]];

   if (ExtArcDinamicScale>0)
     {
      AutoScale=ExtArcDinamicScale;
     }
   else
     {
      AutoScale=(MathAbs(fibo_0-fibo_100)/Point)/MathAbs(iBarShift(Symbol(),Period(),afr[mArcD[1]])-iBarShift(Symbol(),Period(),afr[mArcD[0]]));
     }

   nameObj="FiboArcD" + ExtComplekt+"_";

   ObjectDelete(nameObj);

   ObjectCreate(nameObj, OBJ_FIBOARC,0,afr[mArcD[0]],fibo_0,afr[mArcD[1]],fibo_100);

   fiboArc(AutoScale, ExtArcDinamicColor);
  }
//--------------------------------------------------------
// ����� ����-��� ������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� ��� ����-���. ������.
//--------------------------------------------------------
void fiboArc(double AutoScale, color ArcColor)
  {
   ObjectSet(nameObj,OBJPROP_SCALE,AutoScale);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);
   ObjectSet(nameObj,OBJPROP_ELLIPSE,true);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ArcColor);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,ExtArcStyle);
   ObjectSet(nameObj,OBJPROP_LEVELWIDTH,ExtArcWidth);


   if (ExtFiboType==0)
     {
      fiboArc_st();
     }
   else if (ExtFiboType==1)
     {
      fiboArc_Pesavento();
     }
   else if (ExtFiboType==2)
     {
      fiboArc_custom();
     }
  }
//--------------------------------------------------------
// ���� ��� ����-���. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� ��� ����������� ����-���. ������.
//--------------------------------------------------------
void fiboArc_st()
  {
   double   fi_1[]={0.0, 0.146, 0.236, 0.382, 0.5, 0.618, 0.764, 0.854, 1.0, 1.236, phi, 2.0, 2.618, 3.0, 4.236, 4.618};
   string   fitxt100_1[]={"0.0", "14.6", "23.6", "38.2", "50.0", "61.8", "76.4", "85.4", "100.0", "123.6", "161.8", "200.0", "261.8", "300.0", "423.6", "461.8"};
   int i;
   Sizefi_1=16;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj,i,fitxt100_1[i]);
     }
  }
//--------------------------------------------------------
// ���� ��� ����������� ����-���. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� ��� ����-��� � ������� ���������. ������.
//--------------------------------------------------------
void fiboArc_Pesavento()
  {
   double   fi_1[]={0.0, 0.146, 0.236, 0.382, 0.5, 0.618, 0.786, 0.886, 1.0, 1.272, phi, 2.0, 2.618, 3.0, 4.236, 4.618};
   string   fitxt100_1[]={"0.0", "14.6", "23.6", "38.2", "50.0", "61.8", "78.6", "88.6", "100.0", "127.2", "161.8", "200.0", "261.8", "300.0", "423.6", "461.8"};
   int i;
   Sizefi_1=16;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj,i,fitxt100_1[i]);
     }
  }
//--------------------------------------------------------
// ���� ��� ����-��� � ������� ���������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� ��� ���������������� ����-���. ������.
//--------------------------------------------------------
void fiboArc_custom()
  {
   int i;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
   for (i=0;i<Sizefi;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
      ObjectSetFiboDescription(nameObj,i,fitxt100[i]);
     }
  }
//--------------------------------------------------------
// ���� ��� ���������������� ����-���. �����.
//--------------------------------------------------------

//--------------------------------------------------------
//  ������� ��� ��������� ������� �������. ������.
//--------------------------------------------------------
void GoldenSpiral(datetime t2,double p2,datetime t4,double p4) 
 {
// In polar coordinates the basic spiral equation is:
// r = a * e ^ (Theta * cot Alpah)
// for golden spiral: cot Alpha = 2/pi * ln(phi)
   
   double startAngle; // ���� � ��������(in radians)

   startAngle=MathArctan(((p4-p2)/Point)/((iBarShift(NULL,0,t4,false)-iBarShift(NULL,0,t2,false))*Scale()));

//----  
   double cotAlpha = (1/(2 * goldenSpiralCycle *pi)) * MathLog(phi);
   double r0 = (iBarShift(NULL,0,t4,false)-iBarShift(NULL,0,t2,false))/MathCos(startAngle);
   double r1=1.0/MathExp(startAngle * cotAlpha);
   double a = 0;
   double x1 = 0;
   double y1 = 0;
//----   
   for(int i = 0; i < NumberOfLines; i++)
     {
      double Theta =startAngle + a * pi / 4;
      double r = r0*r1 * MathExp(Theta * cotAlpha);
      //----
      if (clockWiseSpiral == false){Theta = startAngle - a * pi / 4;}
      //----      
      double x2 = r * MathCos(Theta);
      double y2 = r * MathSin(Theta);
      a += accurity;
      //----     
      string label = "Spiral_"+"_"+ExtComplekt+"_"+i;
      DrawLine(x1, y1, x2, y2,t2,p2,t4,p4,label);
      //----              
      x1 = x2;
      y1 = y2;
     }
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawLine(double x1, double y1, double x2, double y2,datetime t2,double p2,datetime t4,double p4, string label)
  {
   int Shift_1 = iBarShift(NULL, 0, t4, false);
   int Shift_2 = iBarShift(NULL, 0, t2, false);

//----   
   int timeShift1 = Shift_2 + MathRound(x1);
   int timeShift2 = Shift_2 + MathRound(x2);
//----   
   double price1 = p2 + NormalizeDouble(y1* Scale() * Point, Digits);
   double price2 = p2 + NormalizeDouble(y2* Scale() * Point, Digits);
//----   
   if((x2 >= 0 && y2 >= 0) || (x2 <= 0 && y2 <= 0))
       color lineColor = spiralColor1;
   else
       lineColor = spiralColor2;
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, 0, GetTime(timeShift1), price1, GetTime(timeShift2), price2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, ExtSpiralStyle);
   ObjectSet(label, OBJPROP_WIDTH, ExtSpiralWidth);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime GetTime(int timeShift)
  {
   if(timeShift >= 0)
      return(Time[timeShift]);
   datetime time = Time[0] - Period()*timeShift*60;
   return(time);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Scale()
{
   double priceRange = WindowPriceMax(0) - WindowPriceMin(0);
   double barsCount = WindowBarsPerChart();
   double chartScale = (priceRange / Point) / barsCount;
   return(chartScale*GPixels/VPixels);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//--------------------------------------------------------
// ������� ��� ��������� ������� �������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ����-������ �����������. ������.
//--------------------------------------------------------
void screenFiboFanS()
  {
   double fiboPrice1, fiboPrice2;

   nameObj="fiboFanS" + ExtComplekt+"_";
   ObjectDelete(nameObj);

   if (ExtPitchforkCandle)
     {
      if (ExtPitchfork_1_HighLow)
        {
         fiboPrice1=mPitchCena[1];fiboPrice2=mPitchCena[2];
        }
      else 
        {
         fiboPrice1=mPitchCena[1];fiboPrice2=mPitchCena[2];
        }
      ObjectCreate(nameObj,OBJ_FIBOFAN,0,mPitchTime[1],fiboPrice1,mPitchTime[2],fiboPrice2);
     }
   else
     {
      if (afrl[mPitch[1]]>0) 
        {
         fiboPrice1=afrl[mPitch[1]];fiboPrice2=afrh[mPitch[2]];
        }
      else 
        {
         fiboPrice1=afrh[mPitch[1]];fiboPrice2=afrl[mPitch[2]];
        }
      ObjectCreate(nameObj,OBJ_FIBOFAN,0,afr[mPitch[1]],fiboPrice1,afr[mPitch[2]],fiboPrice2);
     }

   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanS);

   FiboFanLevel();

  }
//--------------------------------------------------------
// ����� ����-������ �����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ����-������ ������������. ������.
//--------------------------------------------------------
void screenFiboFanD()
  {
   double fiboPrice1, fiboPrice2;

   nameObj="fiboFanD" + ExtComplekt+"_";

   ObjectDelete(nameObj);

   fiboPrice1=afrx[1];fiboPrice2=afrx[0];

   ObjectCreate(nameObj,OBJ_FIBOFAN,0,afr[1],fiboPrice1,afr[0],fiboPrice2);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanD);

   FiboFanLevel();
  }
//--------------------------------------------------------
// ����� ����-������ ������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������ ����-������. �����.
//--------------------------------------------------------
void FiboFanLevel()
  {
   if(ExtFiboFanExp) ObjectSet(nameObj,OBJPROP_FIBOLEVELS,6); else ObjectSet(nameObj,OBJPROP_FIBOLEVELS,4);

   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);

   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DASH);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,0.236);
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,0.382);
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,0.5);
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,phi-1);

   if (ExtFiboFanHidden)
     {
      ObjectSetFiboDescription(nameObj, 0, "23.6"); 
      ObjectSetFiboDescription(nameObj, 1, "38.2"); 
      ObjectSetFiboDescription(nameObj, 2, "50.0"); 
      ObjectSetFiboDescription(nameObj, 3, "61.8"); 
     }
   if(ExtFiboFanExp)
     {
      if (ExtFiboType==0)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,0.764);
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,0.854);

         if (ExtFiboFanHidden)
           {
            ObjectSetFiboDescription(nameObj, 4, "76.4"); 
            ObjectSetFiboDescription(nameObj, 5, "85.4"); 
           }
        }
      else
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,0.786);
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,0.886);

         if (ExtFiboFanHidden)
           {
            ObjectSetFiboDescription(nameObj, 4, "78.6"); 
            ObjectSetFiboDescription(nameObj, 5, "88.6"); 
           }
        }
     }
  }
//--------------------------------------------------------
//  ������ ����-������. ������.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ���������� ���������. ������.
//--------------------------------------------------------
void FiboExpansion()
  {
   if (ExtFiboExpansion>1)
     {
      int i;
      double znach1,znach2,fi_1[];

      nameObj="fiboExpansion" + ExtComplekt+"_";
      if (mExpansion[2]>0)
        {
         if (ExtSave)
           {
            nameObj=nameObj + save;
           }
        }

      ObjectDelete(nameObj);
      if (afrl[mExpansion[0]]>0)
        {
         ObjectCreate(nameObj,OBJ_EXPANSION,0,afr[mExpansion[0]],afrl[mExpansion[0]],afr[mExpansion[1]],afrh[mExpansion[1]],afr[mExpansion[2]],afrl[mExpansion[2]]);
         znach1=afrh[mExpansion[1]]-afrl[mExpansion[0]];
         znach2=afrl[mExpansion[2]];
        }
      else
        {
         ObjectCreate(nameObj,OBJ_EXPANSION,0,afr[mExpansion[0]],afrh[mExpansion[0]],afr[mExpansion[1]],afrl[mExpansion[1]],afr[mExpansion[2]],afrh[mExpansion[2]]);
         znach1=-(afrh[mExpansion[0]]-afrl[mExpansion[1]]);
         znach2=afrh[mExpansion[2]];
        }

      ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
      ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
      ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);
      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboExpansionColor);
      ObjectSet(nameObj,OBJPROP_LEVELSTYLE,ExtExpansionStyle);
      ObjectSet(nameObj,OBJPROP_LEVELWIDTH,ExtExpansionWidth);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      if (ExtFiboType==0)
        {
         FiboExpansion_st(znach1, znach2);
        }
      else if (ExtFiboType==1)
        {
         FiboExpansion_Pesavento(znach1, znach2);
        }
      else if (ExtFiboType==2)
        {
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
         for (i=0;i<Sizefi;i++)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
            ObjectSetFiboDescription(nameObj, i, "FE "+fitxt100[i]+" "+DoubleToStr(znach1*fi[i]+znach2, Digits)+"-"+Period_tf); 
           }
        }
     }
  }
//--------------------------------------------------------
// ����� ���������� ���������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ����������� ��� ��� ���������� ���������. ������.
//--------------------------------------------------------
void FiboExpansion_st(double znach1, double znach2)
  {
   int i;
   double fi_1[]={0.236, 0.382, 0.5, 0.618, 0.764, 0.854, 1.0, 1.236, phi, 2.0, 2.618};
   string tf="-"+Period_tf, fitxt100_1[]={"23.6", "38.2", "50.0", "61.8", "76.4", "85.4", "100.0", "123.6", "161.8", "200.0", "261.8"};
   Sizefi_1=11;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj, i, "FE "+fitxt100_1[i]+" "+DoubleToStr(znach1*fi_1[i]+znach2, Digits)+tf); 
     }
  }
//--------------------------------------------------------
// �������� ����������� ��� ��� ���������� ���������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��� ��������� ��� ���������� ���������. ������.
//--------------------------------------------------------
void FiboExpansion_Pesavento(double znach1, double znach2)
  {
   int i;
   double fi_1[]={0.382, 0.5, 0.618, 0.707, 0.786, 0.886, 1.0, 1.272, 1.414, phi, 2.0, 2.618, 3.0, 4.236, 4.618};
   string tf="-"+Period_tf, fitxt100_1[]={"38.2", "50.0", "61.8", "70.7", "78.6", "88.6", "100.0", "127.2", "141.4", "161.8", "200.0", "261.8", "300.0", "423.6", "461.8"};
   Sizefi_1=15;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj, i, "FE "+fitxt100_1[i]+" "+DoubleToStr(znach1*fi_1[i]+znach2, Digits)+tf); 
     }
  }
//--------------------------------------------------------
// �������� ��� ��������� ��� ���������� ���������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� �������������� ����� � �����.
//--------------------------------------------------------
void delete_objects1()
  {
   int i;
   string txt="";

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,"_" + ExtComplekt + "pl")>-1) ObjectDelete (txt);
      if (StringFind(txt,"_" + ExtComplekt + "ph")>-1) ObjectDelete (txt);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� �������������� ����� � �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� �������������� ����� � �����.
//--------------------------------------------------------
void delete_objects2(string txt1)
  {
   int i;
   string txt="";

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,txt1)>-1)ObjectDelete (txt);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� �������������� ����� � �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� �������� ��������� Gartley.
//--------------------------------------------------------
void delete_FiboStrongPattern()
  {
   int i;
   string txt="";
   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,"_"+ExtComplekt+"StrongPattern_")>-1) ObjectDelete (txt);
      if (StringFind(txt,"_"+ExtComplekt+"StrongPatternVL_")>-1) ObjectDelete (txt);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� �������� ��������� Gartley.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� �������� ��������� Gartley.
//--------------------------------------------------------
void delete_objects3()
  {
   int i;
   string txt="";

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,"_"+ExtComplekt+"StrongPattern_")>-1)ObjectDelete (txt);
      if (StringFind(txt,"_"+ExtComplekt+"StrongPatternVL_")>-1) ObjectDelete (txt);
      if (StringFind(txt,"_"+ExtComplekt+"Triangle")>-1)ObjectDelete (txt);
      if (StringFind(txt,"_"+ExtComplekt+"ABCDzz")>-1)ObjectDelete (txt);
      if (RangeForPointD>0)
        {
         if (StringFind(txt,"_"+ExtComplekt+"PointD")>-1)ObjectDelete (txt);
         if (StringFind(txt,"_"+ExtComplekt+"PDL")>-1)ObjectDelete (txt);
        }

      if (StringFind(txt,"_"+ExtComplekt+"Equilibrium")>-1)ObjectDelete (txt);
      if (StringFind(txt,"_"+ExtComplekt+"Reaction")>-1)ObjectDelete (txt);
      if (bigText)
        {
         if (StringFind(txt,"#_TextPattern_#" + ExtComplekt+"_")>-1)ObjectDelete (txt);
        }
      vBullBearToNumberPattern="";
      vNamePatternToNumberPattern="";
      vNameStrongToNumberPattern="";
      if (VectorOfAMirrorTrend>0) if (StringFind(txt,"_"+ExtComplekt+"VectorOfAMirrorTrend")>-1) ObjectDelete (txt);

      ArrayInitialize(PeakCenaX,0);
      ArrayInitialize(PeakCenaA,0);
      ArrayInitialize(PeakCenaB,0);
      ArrayInitialize(PeakCenaC,0);
      ArrayInitialize(PeakCenaD,0);

      ArrayInitialize(PeakTimeX,0);
      ArrayInitialize(PeakTimeA,0);
      ArrayInitialize(PeakTimeB,0);
      ArrayInitialize(PeakTimeC,0);
      ArrayInitialize(PeakTimeD,0);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� �������� ��������� Gartley.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� �������������� ����� � �����.
//--------------------------------------------------------
void delete_objects4()
  {
   int i;
   string txt="";

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,"_" + ExtComplekt + "pg")>-1) ObjectDelete (txt);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� �������������� ����� � �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� Equilibrium.
//--------------------------------------------------------
void delete_objects5()
  {
   int i;
   string txt="";

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,"_"+ExtComplekt+"Equilibrium")>-1)ObjectDelete (txt);
      else if (StringFind(txt,"_"+ExtComplekt+"Reaction")>-1)ObjectDelete (txt);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� Equilibrium.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ����� � ����� ������� � ������ � �������. ������.
//--------------------------------------------------------
void delete_objects6(int sd)
  {
   int i, k=0; //, handle;
   string txt="", tmp="", metka="", file="";

   if (sd==0) // �����������
     {
      file="\\Price Label S\\";
      metka="m#"+ExtComplekt+"_"+"s";
     }

   if (sd==1) // ������������
     {
      file="\\Price Label D\\";
      metka="m#"+ExtComplekt+"_"+"d";
     }

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,metka)>-1) {ObjectDelete (txt); k++;}
     }

   // �������� ����� � �������
   if (k>0 && mWriteToFile && mAP)
     {
      tmp="_";
      if (ExtMasterPitchfork>0)
        {
         tmp="_0_";
        }
      else
        {
         if (SlavePitchfork) tmp="_"+StringSubstr(""+ExtComplekt,StringLen(""+ExtComplekt)-1)+"_";
         else
           {
            for (i=ObjectsTotal()-1; i>=0; i--)
              {
               if (ObjectType(ObjectName(i))==OBJ_PITCHFORK)
                 {
                  if (StringFind(ObjectName(i),"Master_",0)>=0)
                    {
                     tmp="_"+StringSubstr(""+ExtComplekt,StringLen(""+ExtComplekt)-1)+"_";
                     break;
                    }
                 }
              }
           }
        }

      if (ExtIndicator==6 && GrossPeriod==Period()) file=file+Symbol()+"_"+GrossPeriod+tmp+ExtComplekt+".csv";
      else file=file+Symbol()+"_"+Period()+tmp+ExtComplekt+".csv";

//      handle=FileOpen(file,FILE_CSV|FILE_WRITE,';');
//      FileClose(handle);

      FileDelete(file);
     }
  }
//--------------------------------------------------------
// �������� ����� � ����� ������� � ������ � �������. �����.
//--------------------------------------------------------
/*
//--------------------------------------------------------
// �������� ����� � ����� �������. ������.
//--------------------------------------------------------
void delete_objects7(int sd)
  {
   int i, k=0; //, handle;
   string txt="", tmp="", metka="", file="";

   if (sd==0) // �����������
     {
      file="\\Price Label S\\";
      metka="m#"+ExtComplekt+"_"+"s";
     }

   if (sd==1) // ������������
     {
      file="\\Price Label D\\";
      metka="m#"+ExtComplekt+"_"+"d";
     }

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,metka)>-1) {ObjectDelete (txt); k++;}
     }
  }
//--------------------------------------------------------
// �������� ����� � ����� �������. �����.
//--------------------------------------------------------
*/
//--------------------------------------------------------
// �������� ��������. ������.
// �������� ���������� ����� APm.
//--------------------------------------------------------
 
void delete_objects8()
  {
   int i, i_APm=0, count_APm=0;
   string txt="";
   if (!ExtCustomStaticAP || !AutoMagnet)
     {
      if (ObjectFind("AM_0_" + ExtComplekt)==0)
        {
         ObjectDelete("AM_0_" + ExtComplekt);
         ObjectDelete("AM_1_" + ExtComplekt);
         ObjectDelete("AM_2_" + ExtComplekt);
        }
     }

   if (!ObjectFind(nameCheckLabel)==0) return;

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      // ������� ����������� ��� � ������ APm
      if (ObjectType(txt)==OBJ_PITCHFORK)
        {
         if (StringFind(txt,"_APm",0)>0) i_APm++;
        }
     }

   ObjectDelete(nameCheckLabel_hidden);
   if (i_APm>1)
     {
      if (ObjectFind(nameCheckLabel)==0)
        {
         // �������� ��������� ���������� ����� APm
         if (ObjectGet(nameCheckLabel,OBJPROP_XDISTANCE)!=vX || ObjectGet(nameCheckLabel,OBJPROP_YDISTANCE)!=vY)
           {
            count_APm=(i_APm-1)*2;
           }
         else
           {
            count_APm=i_APm;
           }

         ObjectCreate(nameCheckLabel_hidden,OBJ_TEXT,0,0,0);

         ObjectSetText(nameCheckLabel_hidden,""+i_APm+"_"+count_APm);
         ObjectSet(nameCheckLabel_hidden, OBJPROP_COLOR, CLR_NONE);
         ObjectSet(nameCheckLabel_hidden, OBJPROP_BACK, true);
        }
     }

   if (i_APm>0)
     {
      ObjectDelete(nameCheckLabel);
      ObjectCreate(nameCheckLabel,OBJ_LABEL,0,0,0);

      ObjectSetText(nameCheckLabel,"APm");
      ObjectSet(nameCheckLabel, OBJPROP_FONTSIZE, 10);
      ObjectSet(nameCheckLabel, OBJPROP_COLOR, Red);

      ObjectSet(nameCheckLabel, OBJPROP_CORNER, 1);
      ObjectSet(nameCheckLabel, OBJPROP_XDISTANCE, vX+2);
      ObjectSet(nameCheckLabel, OBJPROP_YDISTANCE, vY);
     }
   else ObjectDelete(nameCheckLabel);
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� ���������� ����� APm.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� ������������ ���, ��������� �������.
//--------------------------------------------------------
 
void delete_objects9()
  {
   int i;
   string txt="";

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,"pmediana_" + ExtComplekt+"_")>-1) ObjectDelete(txt);
      if (StringFind(txt,"SLM382_" + ExtComplekt+"_")>-1) ObjectDelete(txt);
      if (StringFind(txt,"SLM618_" + ExtComplekt+"_")>-1) ObjectDelete(txt);
      if (StringFind(txt,"ISL_" + ExtComplekt+"_")>-1) ObjectDelete(txt);
      if (StringFind(txt,nameUTL)>-1) ObjectDelete(txt);
      if (StringFind(txt,nameLTL)>-1) ObjectDelete(txt);
      if (StringFind(txt,nameUWL)>-1) ObjectDelete(txt);
      if (StringFind(txt,nameLWL)>-1) ObjectDelete(txt);
      if (StringFind(txt,"FSL Shiff Lines S_" + ExtComplekt+"_")>-1) ObjectDelete(txt);

     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� ������������ ���, ��������� �������.
//--------------------------------------------------------


//--------------------------------------------------------
// �������� ��������. ������.
// �������� ������������ ������������ ���.
//--------------------------------------------------------
void delete_objects10()
  {
   ObjectDelete(nameUTLd);ObjectDelete(nameLTLd);
   ObjectDelete(nameUWLd);ObjectDelete(nameLWLd);
   ObjectDelete("RLineD" + ExtComplekt+"_");
   ObjectDelete("pitchforkD" + ExtComplekt+"_");
   ObjectDelete("Master_pitchforkD" + ExtComplekt+"_");
   ObjectDelete("ISL_D" + ExtComplekt+"_");
   ObjectDelete("RZD" + ExtComplekt+"_");
   ObjectDelete("PivotZoneD" + ExtComplekt+"_");
   ObjectDelete("pmedianaD" + ExtComplekt+"_");
   ObjectDelete("1-2pmedianaD" + ExtComplekt+"_");
   ObjectDelete("SLM382D" + ExtComplekt+"_");
   ObjectDelete("SLM618D" + ExtComplekt+"_");
   ObjectDelete("FSL Shiff Lines D" + ExtComplekt+"_");
   ObjectDelete("FanMedianaDinamic" + ExtComplekt+"_");
   ObjectDelete("CISL" + ExtComplekt+"_"+1);
   delete_objects6(1);
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� ������������ ������������ ���.
//--------------------------------------------------------


//--------------------------------------------------------
// �������� ��������. ������.
// �������� �������.
//--------------------------------------------------------
void delete_objects_spiral()
  {
   int i;

   for(i=0;i<NumberOfLines;i++)
     {
      ObjectDelete("Spiral_"+"_"+ExtComplekt+"_"+i);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� �������.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� ������� ��������� �������.
//--------------------------------------------------------
void delete_objects_number()
  {
   int i;
   string txt="";

   for (i=ObjectsTotal()-1; i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,"NumberPeak" + "_" + ExtComplekt + "_")>-1) ObjectDelete (txt);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� ������� ��������� �������.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ������������ ��������. ������.
//--------------------------------------------------------
void delete_objects_dinamic()
  {
   int i;
   
   ObjectDelete("fiboD" + ExtComplekt+"_");
   ObjectDelete("fiboFanD" + ExtComplekt+"_");
   ObjectDelete("RLineD" + ExtComplekt+"_");
   ObjectDelete("pitchforkD" + ExtComplekt+"_");
   ObjectDelete("Master_pitchforkD" + ExtComplekt+"_");
   ObjectDelete("ISL_D" + ExtComplekt+"_");
   ObjectDelete("RZD" + ExtComplekt+"_");
   ObjectDelete("pmedianaD" + ExtComplekt+"_");
   ObjectDelete("1-2pmedianaD" + ExtComplekt+"_");
   ObjectDelete("SLM382D" + ExtComplekt+"_");
   ObjectDelete("SLM618D" + ExtComplekt+"_");
   ObjectDelete("FSL Shiff Lines D" + ExtComplekt+"_");
   ObjectDelete("fiboExpansion" + ExtComplekt+"_");
   ObjectDelete("PivotZoneD" + ExtComplekt+"_");
   ObjectDelete("FanMedianaDinamic" + ExtComplekt+"_");
   ObjectDelete("FiboArcD" + ExtComplekt+"_");
   if (ExtPivotZZ1Num==1) ObjectDelete("LinePivotZZ" + "1" + ExtComplekt+"_");
   if (ExtPivotZZ2Num==1) ObjectDelete("LinePivotZZ" + "2" + ExtComplekt+"_");

   for (i=0; i<7; i++)
     {
      nameObj="VLD"+i+" " + ExtComplekt+"_";
      ObjectDelete(nameObj);
     }
  }
//--------------------------------------------------------
// �������� ������������ ��������. �����.
//--------------------------------------------------------

//----------------------------------------------------
//  ZigZag ������ ������� ����������. ������.
//----------------------------------------------------
void ang_AZZ_()
 {
   int    i,n;
   bool   endCyklDirection=true;
   bool   endSearchPattern=false;
   int    vSize;
   double vPercent_, vPercent;

   if (ExtMaxBar>0) cbi=ExtMaxBar; else cbi=Bars-1;

   if (ExtIndicator==11)
     {
      if (AlgorithmSearchPatterns==1)
        {
         if (DirectionOfSearchMaxMin) vSize = maxSize_; else vSize = minSize_;
        }
      else
        {
         if (DirectionOfSearchMaxMin) vPercent_ = maxPercent_; else vPercent_ = minPercent_;
        }
     }

   while (endCyklDirection)
     {
      if (ExtIndicator==11)
        {
         if (ExtLabel>0) {ArrayInitialize(la,0.0); ArrayInitialize(ha,0.0);}
         ArrayInitialize(zz,0);ArrayInitialize(zzL,0);ArrayInitialize(zzH,0);
         ti=0; fs=0; fsp=0; tbi=0; tai=0; si=0;

         if (AlgorithmSearchPatterns==1)
           {
            if (DirectionOfSearchMaxMin)
              {
               if (vSize < minSize_)
                 {
                  if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vSize=minSizeToNumberPattern;
                  else vSize=minSize_;
                  endSearchPattern=true;
                 }

               di=vSize*Point/2;
               vSize-=IterationStepSize;
              }
            else
              {
               if (vSize > maxSize_)
                 {
                  if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vSize=minSizeToNumberPattern;
                  else vSize=minSize_;
                  endSearchPattern=true;
                 }

               di=vSize*Point/2;
               vSize+=IterationStepSize;
              }
           }
         else
           {
            if (DirectionOfSearchMaxMin)
              {
               if (vPercent_ < minPercent_)
                 {
                  if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vPercent_=minPercentToNumberPattern;
                  else vPercent_=minPercent_;
                  endSearchPattern=true;
                 }

               vPercent=vPercent_;
               vPercent_=vPercent_*(1-IterationStepPercent/100);
              }
            else
              {
               if (vPercent_ > maxPercent_)
                 {
                  if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vPercent_=minPercentToNumberPattern;
                  else vPercent_=minPercent;
                  endSearchPattern=true;
                 }

               vPercent=vPercent_;
               vPercent_=vPercent_*(1+IterationStepPercent/100);
              }
           }

         if (flagExtGartleyTypeSearch2)
           {
            endSearchPattern=true; 

            if (AlgorithmSearchPatterns==1)
              {
               vSize=minSizeToNumberPattern;
              }
            else
              {
               vPercent_=minPercentToNumberPattern;
              }
           }
        }
      else
        {
         endCyklDirection=false;
         endSearchPattern=true;
        }

      for (i=cbi; i>=ExtMinBar; i--) 
        {
         // ���������� �������� ����������� ������ fs � ������� ���� si �� ���������� ����
         if (ti<Time[i]) {fsp=fs; sip=si;} ti=Time[i];
         // ��������� �������� �������� ������� �� �������� ����������
         if (ExtIndicator==11)
           {
            if (AlgorithmSearchPatterns==2) di=vPercent*Close[i]/2/100;
           }
         else if (minSize==0 && minPercent!=0) di=minPercent*Close[i]/2/100;

         // ������������� ������� ����
         if (High[i]>si+di && Low[i]<si-di) // ������� ��� �� ��������� � �������� ������� di
           {
//        if (High[i]-si>si-Low[i]) si=High[i]-di;  // ���������� ��� �� ������� ���� ������ ���������� ����
//        else if (High[i]-si<si-Low[i]) si=Low[i]+di;  // ��������������, ������

            if (fs==1) si=High[i]-di;  // 
            if (fs==2) si=Low[i]+di;  // 
           } 
         else  // �� ������� ���
           {
            if (fs==1)
              {
               if (High[i]>=si+di) si=High[i]-di;   // 
               else if (Low[i]<si-di) si=Low[i]+di;   // 
              }
            if (fs==2)
              {
               if (Low[i]<=si-di) si=Low[i]+di;   // 
               else if (High[i]>si+di) si=High[i]-di;   //
              }
           }

         // ���������� ���������� �������� ������� ����

         if (i>cbi-1) {si=(High[i]+Low[i])/2;}
         // ���������� ����������� ������ ��� ���������� ����
         if (si>sip) fs=1; // ����� ����������
         if (si<sip) fs=2; // ����� ����������

         //-------------------------------------------------
         if (fs==1 && fsp==2) // ����� �������� � ����������� �� ����������
           {
            hm=High[i];

            bi=iBarShift(Symbol(),Period(),tbi);
            zz[bi]=Low[bi];
            zzL[bi]=Low[bi];
            tai=Time[i];
            fsp=fs;
            si=High[i]-di;
            sip=si;

            if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0)
              {
               ha[i]=High[i]; la[bi]=Low[bi]; la[i]=0;
               tmh=Time[i]; ha[i]=High[i]; la[i]=0; // ����������� ����� �� ���������� ����
              }
           }

         if (fs==2 && fsp==1) // ����� �������� � ����������� �� ����������
           {
            lm=Low[i]; 

            ai=iBarShift(Symbol(),Period(),tai); 
            zz[ai]=High[ai];
            zzH[ai]=High[ai];
            tbi=Time[i];
            si=Low[i]+di;
            fsp=fs;
            sip=si;

            if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0)
              {
               ha[ai]=High[ai]; ha[i]=0; la[i]=Low[i];
               tml=Time[i]; ha[i]=0; la[i]=Low[i]; // ����������� ����� �� ���������� ����
              }
           }

         // ����������� t�����. ������������ ������.
         if (fs==1 && High[i]>hm) {hm=High[i]; tai=Time[i]; si=High[i]-di;}
         if (fs==2 && Low[i]<lm)  {lm=Low[i]; tbi=Time[i]; si=Low[i]+di;}

         if ((ExtIndicator!=11 || endSearchPattern))
           {
            // ��������� ������ ��� ������� �������������
            if (chHL && chHL_PeakDet_or_vts && ExtLabel==0) {ha[i]=si+di; la[i]=si-di;} 

            //===================================================================================================
            // ������� ���. ������ ������� ���� ZigZag-a
            if (i==0) 
              {
               ai0=iBarShift(Symbol(),Period(),tai); 
               bi0=iBarShift(Symbol(),Period(),tbi);
               if (fs==1)
                 {
                  for (n=bi0-1; n>=0; n--) {zzH[n]=0; zz[n]=0; if (ExtLabel>0) ha[n]=0;}
                  zz[ai0]=High[ai0]; zzH[ai0]=High[ai0]; zzL[ai0]=0; if (ExtLabel>0) ha[ai0]=High[ai0];
                 }
               if (fs==2)
                 {
                  for (n=ai0-1; n>=0; n--) {zzL[n]=0; zz[n]=0; if (ExtLabel>0) la[n]=0;}
                  zz[bi0]=Low[bi0]; zzL[bi0]=Low[bi0]; zzH[bi0]=0; if (ExtLabel>0) la[bi0]=Low[bi0];
                 }

               if (ExtLabel>0)
                 {
                  if (fs==1) {aim=iBarShift(Symbol(),0,tmh); if (aim<bi0) ha[aim]=High[aim];}
                  else if (fs==2) {bim=iBarShift(Symbol(),0,tml); if (bim<ai0) la[bim]=Low[bim];}
                 }
              }
            //====================================================================================================
           }
        }

      if (ExtIndicator==11)
        {
         // ����� ���������

         if (endSearchPattern)
           {
            return(0);
           }

         _Gartley("ExtIndicator=11_"+vSize+"/"+vPercent+"", 0);

         if (saveParametersZZ)
           {
            saveParametersZZ=false;

            if (AlgorithmSearchPatterns==1) minSizeToNumberPattern=vSize;
            else minPercentToNumberPattern=vPercent;
           }

         if (ExtGartleyTypeSearch==0 && vPatOnOff)
           {
            return(0);
           }

        }
     }
 }
//--------------------------------------------------------
// ZigZag ������. �����. 
//--------------------------------------------------------

//----------------------------------------------------
// ������ �����. ������.
//----------------------------------------------------
void GannSwing()
 {
   int    i,n;
   int    vBars  = minBars;
   bool   endCyklDirection=true;
   bool   endSearchPattern=false;

   // ���������� ��� ������� �����
   double lLast_m=0, hLast_m=0;
   int    countBarExt=0; // ������� ������� �����
   int    countBarl=0,countBarh=0;
   fs=0; ti=0;

// lLast, hLast - ������� � �������� ��������� ����
// lLast_m, hLast_m - ������� � �������� "�������������" �����

//   cbi=Bars-IndicatorCounted()-1;
//---------------------------------
//   cbi=Bars-1; 
   if (ExtMaxBar>0) cbi=ExtMaxBar; else cbi=Bars-1;

   if (ExtIndicator==11)
     {
      if (DirectionOfSearchMaxMin) vBars = minBars; else vBars = 0;
     }

   while (endCyklDirection)
     {
      if (ExtLabel>0) {ArrayInitialize(la,0.0); ArrayInitialize(ha,0.0);}
      ArrayInitialize(zz,0);ArrayInitialize(zzL,0);ArrayInitialize(zzH,0);

      if (ExtIndicator==11)
        {
         lLast=0; lLast_m=0; hLast_m=0; fs=0; ti=0;

         if (DirectionOfSearchMaxMin)
           {
            if (vBars < 0)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vBars=minBarsToNumberPattern;
               else vBars=minBars;
               endSearchPattern=true;
              }

            vBars--;
           }
         else
           {
            if (vBars > minBars)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vBars=minBarsToNumberPattern;
               else vBars=minBars;
               endSearchPattern=true;
              }

            vBars++;
           }

         if (flagExtGartleyTypeSearch2)
           {
            endSearchPattern=true; 
            vBars=minSizeToNumberPattern;
           }
        }
      else
        {
         vBars=minBars;
         endCyklDirection=false;
         endSearchPattern=true;
        }

      for (i=cbi; i>=ExtMinBar; i--) 
        {
//-------------------------------------------------
         // ������������� ��������� �������� �������� � ��������� ����
         if (lLast==0) {lLast=Low[i]; hLast=High[i]; ai=i; bi=i;}
         if (ti!=Time[i])
           {
            ti=Time[i];
            if (lLast_m==0 && hLast_m==0)
              {
               if (lLast>Low[i] && hLast<High[i]) // ������� ���
                 {
                  lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
                  if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
                  else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
                  else {countBarl++;countBarh++;}
                 }
               else if (lLast<=Low[i] && hLast<High[i]) // ��������� �� ������� ���� ����������
                 {
                  lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
                  if (fs!=1) countBarh++;
                  else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
                 }
               else if (lLast>Low[i] && hLast>=High[i]) // ��������� �� ������� ���� ����������
                 {
                  lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
                  if (fs!=2) countBarl++;
                  else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
                 }
              }
            else  if (lLast_m>0 && hLast_m>0) // ������� ��� (����������)
              {
               if (lLast_m>Low[i] && hLast_m<High[i]) // ������� ���
                 {
                  lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
                  if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
                  else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
                  else {countBarl++;countBarh++;}
                 }
               else if (lLast_m<=Low[i] && hLast_m<High[i]) // ��������� �� ������� ���� ����������
                 {
                  lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
                  if (fs!=1) countBarh++;
                  else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
                 }
               else if (lLast_m>Low[i] && hLast_m>=High[i]) // ��������� �� ������� ���� ����������
                 {
                  lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
                  if (fs!=2) countBarl++;
                  else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
                 }
              }
            else  if (lLast_m>0)
              {
               if (lLast_m>Low[i] && hLast<High[i]) // ������� ���
                 {
                  lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
                  if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
                  else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
                  else {countBarl++;countBarh++;}
                 }
               else if (lLast_m<=Low[i] && hLast<High[i]) // ��������� �� ������� ���� ����������
                 {
                  lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
                  if (fs!=1) countBarh++;
                  else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
                 }
               else if (lLast_m>Low[i] && hLast>=High[i]) // ��������� �� ������� ���� ����������
                 {
                  lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
                  if (fs!=2) countBarl++;
                  else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
                 }
              }
            else  if (hLast_m>0)
              {
               if (lLast>Low[i] && hLast_m<High[i]) // ������� ���
                 {
                  lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
                  if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
                  else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
                  else {countBarl++;countBarh++;}
                 }
               else if (lLast<=Low[i] && hLast_m<High[i]) // ��������� �� ������� ���� ����������
                 {
                  lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
                  if (fs!=1) countBarh++;
                  else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
                 }
               else if (lLast>Low[i] && hLast_m>=High[i]) // ��������� �� ������� ���� ����������
                 {
                  lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
                  if (fs!=2) countBarl++;
                  else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
                 }
              }

            // ���������� ����������� ������. 
            if (fs==0)
              {
               if (lLast<lLast_m && hLast>hLast_m) // ���������� ���
                 {
                  lLast=Low[i]; hLast=High[i]; ai=i; bi=i; countBarl=0;countBarh=0;countBarExt=0;
                 }

               if (countBarh>countBarl && countBarh>countBarExt && countBarh>vBars)
                 {
                  lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;
                  fs=1;countBarh=0;countBarl=0;countBarExt=0;
                  zz[bi]=Low[bi];
                  zzL[bi]=Low[bi];
                  zzH[bi]=0;
                  ai=i;
                  tai=Time[i];
                 }
               else if (countBarl>countBarh && countBarl>countBarExt && countBarl>vBars)
                 {
                  lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;
                  fs=2;countBarl=0;countBarh=0;countBarExt=0;
                  zz[ai]=High[ai];
                  zzH[ai]=High[ai];
                  zzL[ai]=0;
                  bi=i;
                  tbi=Time[i];
                 }
              }
            else
              {
               if (lLast_m==0 && hLast_m==0)
                 {
                  countBarl=0;countBarh=0;countBarExt=0;
                 }

               // ��������� ����������
               if (fs==1)
                 {
                  if (countBarl>countBarh && countBarl>countBarExt && countBarl>vBars) // ���������� ����� ����� ���������.
                    {
                     // ���������� �������� ����������� ������ fs �� ���������� ����
                     ai=iBarShift(Symbol(),Period(),tai); 
                     fs=2;
                     countBarl=0;

                     zz[ai]=High[ai];
                     zzH[ai]=High[ai];
                     zzL[ai]=0;
                     bi=i;
                     if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0)
                       {
                        ha[ai]=High[ai]; la[ai]=0; // ����������� ����� �� ����������
                        tml=Time[i]; ha[i]=0; la[i]=Low[i]; // ����������� ����� �� ���������� ����
                       }
                     tbi=Time[i];

                     lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;

                     for (n=0;countBarExt<vBars;n++) 
                       {
                        if (lLast<Low[i+n+1] && hLast>High[i+n+1]) {countBarExt++; countBarh++; lLast=Low[i+n+1]; hLast=High[i+n+1]; hLast_m=High[i];}
                        else break;
                       }

                     lLast=Low[i]; hLast=High[i];

                    }
                 }

               // ��������� ����������
               if (fs==2)
                 {
                  if (countBarh>countBarl && countBarh>countBarExt && countBarh>vBars) // ���������� ����� ����� ���������.
                    {
                     // ���������� �������� ����������� ������ fs �� ���������� ����
                     bi=iBarShift(Symbol(),Period(),tbi);
                     fs=1;
                     countBarh=0;

                     zz[bi]=Low[bi];
                     zzL[bi]=Low[bi];
                     zzH[bi]=0;
                     ai=i;
                     if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0)
                       {
                        ha[bi]=0; la[bi]=Low[bi];  // ����������� ����� �� ���������
                        tmh=Time[i]; ha[i]=High[i]; la[i]=0; // ����������� ����� �� ���������� ����
                       }
                     tai=Time[i];

                     lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;

                     for (n=0;countBarExt<vBars;n++) 
                       {
                        if (lLast<Low[i+n+1] && hLast>High[i+n+1]) {countBarExt++; countBarl++; lLast=Low[i+n+1]; hLast=High[i+n+1]; lLast_m=Low[i];}
                        else break;
                       }

                     lLast=Low[i]; hLast=High[i];

                    }
                 }
              } 
           } 

         if ((ExtIndicator!=11 || endSearchPattern))
           {
            if (i==0)
              {
               if (hLast<High[i] && fs==1) // ��������� �� ������� ���� ����������
                 {
                  ai=i; tai=Time[i]; zz[ai]=High[ai]; zzH[ai]=High[ai]; zzL[ai]=0;
                  if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0) {ha[ai]=High[ai]; la[ai]=0;} // �������� �����
                 }
               else if (lLast>Low[i] && fs==2) // ��������� �� ������� ���� ����������
                 {
                  bi=i; tbi=Time[i]; zz[bi]=Low[bi]; zzL[bi]=Low[bi]; zzH[bi]=0;
                  if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0) {la[bi]=Low[bi]; ha[bi]=0;} // �������� �����
                 }
              //===================================================================================================

              // ������� ���. ������ ������� ���� ZigZag-a
               ai0=iBarShift(Symbol(),Period(),tai); 
               bi0=iBarShift(Symbol(),Period(),tbi);

               if (bi0>1) if (fs==1)
                 {
                  for (n=bi0-1; n>=0; n--) {zzH[n]=0.0; zz[n]=0.0; if (ExtLabel>0) ha[n]=0;}
                  zz[ai0]=High[ai0]; zzH[ai0]=High[ai0]; zzL[ai0]=0.0; if (ExtLabel>0) ha[ai0]=High[ai0];
                 }
               if (ai0>1) if (fs==2)
                 {
                  for (n=ai0-1; n>=0; n--) {zzL[n]=0.0; zz[n]=0.0; if (ExtLabel>0) la[n]=0;} 
                  zz[bi0]=Low[bi0]; zzL[bi0]=Low[bi0]; zzH[bi0]=0.0; if (ExtLabel>0) la[bi0]=Low[bi0];
                 }

               if (ExtLabel>0)
                 {
                  if (fs==1) {aim=iBarShift(Symbol(),0,tmh); if (aim<bi0) ha[aim]=High[aim];}
                  else if (fs==2) {bim=iBarShift(Symbol(),0,tml); if (bim<ai0) la[bim]=Low[bim];}
                 }

               if (ti<Time[1]) i=2;

               //====================================================================================================
              }
           }
        }

      if (ExtIndicator==11)
        {
         // ����� ���������

         if (endSearchPattern)
           {
            return(0);
           }

         _Gartley("ExtIndicator=11_"+vBars+"", 0);

         if (saveParametersZZ)
           {
            saveParametersZZ=false;
            minBarsToNumberPattern=vBars;
           }

         if (ExtGartleyTypeSearch==0 && vPatOnOff)
           {
            return(0);
           }

        }
     }
//--------------------------------------------
 }
//--------------------------------------------------------
// ������ �����. �����. 
//--------------------------------------------------------

/*------------------------------------------------------------------+
|  ZigZag_Talex, ���� ����� �������� �� �������. ���������� �����   |
|  �������� ������� ���������� ExtPoint.                            |
+------------------------------------------------------------------*/
void ZZTalex()
  {
   int    i,j,k,zzbarlow,zzbarhigh,curbar,curbar1,curbar2,EP,Mbar[];
   double curpr,Mprice[];
   bool   flag,fd;
   int    vBars  = minBars;
   bool   endCyklDirection=true;
   bool   endSearchPattern=false;
   
   if (DirectionOfSearchMaxMin) vBars = maxDepth; else vBars = minDepth;
   ArrayResize(Mbar,ExtPoint);
   ArrayResize(Mprice,ExtPoint);

   while (endCyklDirection)
     {
      ArrayInitialize(zz,0);ArrayInitialize(zzL,0);ArrayInitialize(zzH,0);
      ArrayInitialize(Mbar,0);ArrayInitialize(Mprice,0);
      if (ExtIndicator==11)
        {
         if (DirectionOfSearchMaxMin)
           {
            if (vBars < 0)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vBars=minBarsToNumberPattern;
               else vBars=minBars;
               endSearchPattern=true;
              }

            vBars-=IterationStepDepth;
           }
         else
           {
            if (vBars > minBars)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vBars=minBarsToNumberPattern;
               else vBars=minBars;
               endSearchPattern=true;
              }

            vBars+=IterationStepDepth;
           }

         if (flagExtGartleyTypeSearch2)
           {
            endSearchPattern=true; 
            vBars=minSizeToNumberPattern;
           }
        }
      else
        {
         vBars=minBars;
         endCyklDirection=false;
         endSearchPattern=true;
        }

      EP=ExtPoint;
      zzbarlow=iLowest(NULL,0,MODE_LOW,vBars,0);        
      zzbarhigh=iHighest(NULL,0,MODE_HIGH,vBars,0);     

      if(zzbarlow<zzbarhigh) {curbar=zzbarlow; curpr=Low[zzbarlow];}
      if(zzbarlow>zzbarhigh) {curbar=zzbarhigh; curpr=High[zzbarhigh];}
      if(zzbarlow==zzbarhigh){curbar=zzbarlow;curpr=funk1(zzbarlow, vBars);}

      j=0;
      endpr=curpr;
      endbar=curbar;
      Mbar[j]=curbar;
      Mprice[j]=curpr;

      EP--;
      if(curpr==Low[curbar]) flag=true;
      else flag=false;
      fl=flag;
 
      i=curbar+1;
      while(EP>0)
        {
         if(flag)
           {
            while(i<=Bars-1)
              {
               curbar1=iHighest(NULL,0,MODE_HIGH,vBars,i); 
               curbar2=iHighest(NULL,0,MODE_HIGH,vBars,curbar1); 
               if(curbar1==curbar2){curbar=curbar1;curpr=High[curbar];flag=false;i=curbar+1;j++;break;}
               else i=curbar2;
              }

            Mbar[j]=curbar;
            Mprice[j]=curpr;
            EP--;
           }

         if(EP==0) break;

         if(!flag) 
           {
            while(i<=Bars-1)
              {
               curbar1=iLowest(NULL,0,MODE_LOW,vBars,i); 
               curbar2=iLowest(NULL,0,MODE_LOW,vBars,curbar1); 
               if(curbar1==curbar2){curbar=curbar1;curpr=Low[curbar];flag=true;i=curbar+1;j++;break;}
               else i=curbar2;
              }

            Mbar[j]=curbar;
            Mprice[j]=curpr;
            EP--;
           }
        }

      /* ����������� ������ */
      if(Mprice[0]==Low[Mbar[0]])fd=true; else fd=false;
      for(k=0;k<=ExtPoint-1;k++)
        {
         if(k==0)
           {
            if(fd==true)
              {
               Mbar[k]=iLowest(NULL,0,MODE_LOW,Mbar[k+1]-Mbar[k],Mbar[k]);Mprice[k]=Low[Mbar[k]];endbar=vBars;
              }
            if(fd==false)
              {
               Mbar[k]=iHighest(NULL,0,MODE_HIGH,Mbar[k+1]-Mbar[k],Mbar[k]);Mprice[k]=High[Mbar[k]];endbar=vBars;
              }
           }
         if(k<ExtPoint-2)
           {
            if(fd==true)
              {
               Mbar[k+1]=iHighest(NULL,0,MODE_HIGH,Mbar[k+2]-Mbar[k]-1,Mbar[k]+1);Mprice[k+1]=High[Mbar[k+1]];
              }
            if(fd==false)
              {
               Mbar[k+1]=iLowest(NULL,0,MODE_LOW,Mbar[k+2]-Mbar[k]-1,Mbar[k]+1);Mprice[k+1]=Low[Mbar[k+1]];
              }
           }
         if(fd==true)fd=false;else fd=true;

         /* ��������� ZigZag'a */
         zz[Mbar[k]]=Mprice[k];
         if (k==0)
           {
            if (Mprice[k]>Mprice[k+1])
              {
               zzH[Mbar[k]]=Mprice[k];
              }
            else
              {
               zzL[Mbar[k]]=Mprice[k];
              }
           }
         else
           {
            if (Mprice[k]>Mprice[k-1])
              {
               zzH[Mbar[k]]=Mprice[k];
              }
            else
              {
               zzL[Mbar[k]]=Mprice[k];
              }

           }
        }

      if (ExtIndicator==11)
        {
         // ����� ���������

         if (endSearchPattern)
           {
            return(0);
           }

         _Gartley("ExtIndicator=11_"+vBars+"", 0);

         if (saveParametersZZ)
           {
            saveParametersZZ=false;
            minBarsToNumberPattern=vBars;
           }

         if (ExtGartleyTypeSearch==0 && vPatOnOff)
           {
            return(0);
           }

        }
     }
  
  } 
//------------------------------------------------------------------
//  ZigZag_Talex �����                                              
//------------------------------------------------------------------

/*-------------------------------------------------------------------+
/ ������ ��� ������ � ������� ���� (���� �� �������) ����� ��������� |
/ ����� ������������ � �������� �������. ��� ZigZag_Talex.           |
/-------------------------------------------------------------------*/
double funk1(int zzbarlow, int ExtDepth)
{
 double pr;
 int fbarlow,fbarhigh;
 
 fbarlow=iLowest(NULL,0,MODE_LOW,ExtDepth,zzbarlow);  
 fbarhigh=iHighest(NULL,0,MODE_HIGH,ExtDepth,zzbarlow);
 
 if(fbarlow>fbarhigh) pr=High[zzbarlow];
 if(fbarlow<fbarhigh) pr=Low[zzbarlow];
 if(fbarlow==fbarhigh)
 {
  fbarlow=iLowest(NULL,0,MODE_LOW,2*ExtDepth,zzbarlow);  
  fbarhigh=iHighest(NULL,0,MODE_HIGH,2*ExtDepth,zzbarlow);
  if(fbarlow>fbarhigh) pr=High[zzbarlow];
  if(fbarlow<fbarhigh) pr=Low[zzbarlow];
  if(fbarlow==fbarhigh)
  {
   fbarlow=iLowest(NULL,0,MODE_LOW,3*ExtDepth,zzbarlow);  
   fbarhigh=iHighest(NULL,0,MODE_HIGH,3*ExtDepth,zzbarlow);
   if(fbarlow>fbarhigh) pr=High[zzbarlow];
   if(fbarlow<fbarhigh) pr=Low[zzbarlow];
  }
 }
 return(pr);
}
//--------------------------------------------------------
// �����. ��� ZigZag_Talex.
//--------------------------------------------------------

//----------------------------------------------------
//  ZigZag tauber. ������.
//----------------------------------------------------
void ZigZag_tauber()
  {
//  ZigZag �� ��. ������.
   int    shift, back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;
   int    vSize;
   bool   endCyklDirection=true;
   bool   endSearchPattern=false;

   int    metka=0; // =0 - �� ������� �������� ZZ. =1 - ���� ����� ����������. =2 - ���� ����� ���������.
   double peak, wrpeak;

   if (ExtIndicator==11)
     {
      if (DirectionOfSearchMaxMin) vSize = maxSize_; else vSize = minSize_;
     }

   while (endCyklDirection)
     {
      if (ExtLabel>0) {ArrayInitialize(la,0.0); ArrayInitialize(ha,0.0);}
      ArrayInitialize(zz,0);ArrayInitialize(zzL,0);ArrayInitialize(zzH,0);

      if (ExtIndicator==11)
        {
         if (DirectionOfSearchMaxMin)
           {
            if (vSize < minSize_)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vSize=minSizeToNumberPattern;
               else vSize=minSize_;
               endSearchPattern=true;
              }

            di=minSize*Point;
            vSize-=IterationStepSize;
           }
         else
           {
            if (vSize > maxSize_)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vSize=minSizeToNumberPattern;
               else vSize=minSize_;
               endSearchPattern=true;
              }

            di=minSize*Point;
            vSize+=IterationStepSize;
           }

         if (flagExtGartleyTypeSearch2)
           {
            endSearchPattern=true; 
            vSize=minSizeToNumberPattern;
           }
        }
      else
        {
         vSize=minSize;
         endCyklDirection=false;
         endSearchPattern=true;
        }

      GetHigh(0,Bars,0.0,0,vSize);

      // final cutting 
      lasthigh=-1; lasthighpos=-1;
      lastlow=-1;  lastlowpos=-1;

      for(shift=Bars; shift>=0; shift--)
        {
         curlow=zzL[shift];
         curhigh=zzH[shift];
         if((curlow==0)&&(curhigh==0)) continue;
         //---
         if(curhigh!=0)
           {
           if(lasthigh>0) 
              {
               if(lasthigh<curhigh) zzH[lasthighpos]=0;
               else zzH[shift]=0;
              }
           //---
            if(lasthigh<curhigh || lasthigh<0)
              {
               lasthigh=curhigh;
               lasthighpos=shift;
              }
            lastlow=-1;
           }
         //----
         if(curlow!=0)
           {
            if(lastlow>0)
              {
               if(lastlow>curlow) zzL[lastlowpos]=0;
               else zzL[shift]=0;
             }
            //---
            if((curlow<lastlow)||(lastlow<0))
              {
               lastlow=curlow;
               lastlowpos=shift;
              } 
            lasthigh=-1;
           }
        }

      for(shift=Bars-1; shift>=0; shift--)
        {
         zz[shift]=zzL[shift];
         res=zzH[shift];
         if(res!=0.0) zz[shift]=res;
        }

      if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0)  // ����������� �����
        {
         for(shift=Bars-1; shift>=0; shift--)
           {

            if (zz[shift]>0)
              {
               if (zzH[shift]>0)
                 {
                  peak=High[shift]; wrpeak=Low[shift];
                  ha[shift]=High[shift]; la[shift]=0;
                  metka=2; shift--;
                 }
               else
                 {
                  peak=Low[shift]; wrpeak=High[shift];
                  la[shift]=Low[shift]; ha[shift]=0;
                  metka=1; shift--;
                 }
              }

            if (metka==1)
              {
               if (wrpeak<High[shift])
                 {
                  if (High[shift]-peak>minSize*Point) {metka=0;  ha[shift]=High[shift];}
                 }
               else
                 {
                  wrpeak=High[shift];
                 }
              }
            else if (metka==2)
              {
               if (wrpeak>Low[shift])
                 {
                  if (peak-Low[shift]>minSize*Point) {metka=0;  la[shift]=Low[shift];}
                 }
               else
                 {
                  wrpeak=Low[shift];
                 }
              }
           }
        }

      if (ExtIndicator==11)
        {
         // ����� ���������

         if (endSearchPattern)
           {
            return(0);
           }

         _Gartley("ExtIndicator=11_"+AlgorithmSearchPatterns+"", 0);

         if (saveParametersZZ)
           {
            saveParametersZZ=false;
            minSizeToNumberPattern=vSize;
           }

         if (ExtGartleyTypeSearch==0 && vPatOnOff)
           {
            return(0);
           }
        }
     }
  }

void GetHigh(int start, int end, double price, int step, int vSize)
  {
   int count=end-start;
   if (count<=0) return;
   int i=iHighest(NULL,0,MODE_HIGH,count+1,start);
   double val=High[i];
   if ((val-price)>(vSize*Point))
     { 
      zzH[i]=val;
      if (i==start) {GetLow(start+step,end-step,val,1-step,vSize); if (zzL[start-1]>0) zzL[start]=0; return;}     
      if (i==end) {GetLow(start+step,end-step,val,1-step,vSize); if (zzL[end+1]>0) zzL[end]=0; return;} 
      GetLow(start,i-1,val,0,vSize);
      GetLow(i+1,end,val,0,vSize);
     }
  }

void GetLow(int start, int end, double price, int step, int vSize)
  {
   int count=end-start;
   if (count<=0) return;
   int i=iLowest(NULL,0,MODE_LOW,count+1,start);
   double val=Low[i];
   if ((price-val)>(vSize*Point))
     {
      zzL[i]=val; 
      if (i==start) {GetHigh(start+step,end-step,val,1-step,vSize); if (zzH[start-1]>0) zzH[start]=0; return;}     
      if (i==end) {GetHigh(start+step,end-step,val,1-step,vSize); if (zzH[end+1]>0) zzH[end]=0; return;}   
      GetHigh(start,i-1,val,0,vSize);
      GetHigh(i+1,end,val,0,vSize);
     }
  }
//--------------------------------------------------------
// ZigZag tauber. �����. 
//--------------------------------------------------------

//----------------------------------------------------
// ��������� �������� ����������� � Ensign. ������.
//----------------------------------------------------
void Ensign_ZZ()
 {
   int  i,n;
   int  vSize;
   bool endCyklDirection=true;
   bool endSearchPattern=false;

   if (ExtMaxBar>0) cbi=ExtMaxBar; else cbi=Bars-1;

   if (ExtIndicator==11)
     {
      if (DirectionOfSearchMaxMin) vSize = maxSize_; else vSize = minSize_;
     }

   while (endCyklDirection)
     {
      if (ExtIndicator==11)
        {
         if (ExtLabel>0) {ArrayInitialize(la,0.0); ArrayInitialize(ha,0.0);}
         ArrayInitialize(zz,0);ArrayInitialize(zzL,0);ArrayInitialize(zzH,0);
         ti=0; fs=0; tbi=0; tai=0; si=0;

         if (DirectionOfSearchMaxMin)
           {
            if (vSize < minSize_)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vSize=minSizeToNumberPattern;
               else vSize=minSize_;
               endSearchPattern=true;
              }

            di=vSize*Point;
            vSize-=IterationStepSize;
           }
         else
           {
            if (vSize > maxSize_)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vSize=minSizeToNumberPattern;
               else vSize=minSize_;
               endSearchPattern=true;
              }

            di=vSize*Point;
            vSize+=IterationStepSize;
           }

         if (flagExtGartleyTypeSearch2)
           {
            endSearchPattern=true; 
            vSize=minSizeToNumberPattern;
           }
        }
      else
        {
         endCyklDirection=false;
         endSearchPattern=true;
        }
 
      for (i=cbi; i>=ExtMinBar; i--) 
        {
         // ������������� ��������� �������� �������� � ��������� ����
         if (lLast==0) {lLast=Low[i];hLast=High[i]; if (ExtIndicator==3) di=hLast-lLast;}

         // ���������� ����������� ������ �� ������ ����� ����� ������.
         // ��� �� ����� ������ ������� ���� �� ����� �����.
         if (fs==0)
           {
            if (lLast<Low[i] && hLast<High[i]) {fs=1; hLast=High[i]; si=High[i]; ai=i; tai=Time[i]; if (ExtIndicator==3) di=High[i]-Low[i];}  // ����� ����������
            if (lLast>Low[i] && hLast>High[i]) {fs=2; lLast=Low[i]; si=Low[i]; bi=i; tbi=Time[i]; if (ExtIndicator==3) di=High[i]-Low[i];}  // ����� ����������
           }

//      if (ti<Time[i])
           {
            // ���������� �������� ����������� ������ fs �� ���������� ����
            ti=Time[i];

            ai0=iBarShift(Symbol(),Period(),tai); 
            bi0=iBarShift(Symbol(),Period(),tbi);

            fcount0=false;
            if ((fh || fl) && countBar>0) {countBar--; if (i==0 && countBar==0) fcount0=true;}
            // ���������. ����������� ����������� ����������� ������.
            if (fs==1)
              {
               if (hLast>High[i] && !fh) fh=true;

               if (i==0)
                 {
                  if (Close[i+1]<lLast && fh) {fs=2; countBar=minBars; fh=false;}
                  if (countBar==0 && si-di>Low[i+1] && High[i+1]<hLast && ai0>i+1 && fh && !fcount0) {fs=2; countBar=minBars; fh=false;}

                  if (fs==2) // ����� �������� � ����������� �� ���������� �� ���������� ����
                    {
                     zz[ai0]=High[ai0];
                     zzH[ai0]=High[ai0];
                     lLast=Low[i+1];
                     if (ExtIndicator==3) di=High[i+1]-Low[i+1];
                     si=Low[i+1];
                     bi=i+1;
                     tbi=Time[i+1];
                     if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0)
                       {
                        ha[ai0]=High[ai0];
                        tml=Time[i+1]; ha[i+1]=0; la[i+1]=Low[i+1]; // ����������� ����� �� ���������� ����
                       }
//                  else if (chHL && chHL_PeakDet_or_vts) {ha[i+1]=si+di; la[i+1]=si;}
                    }
                 }
               else
                 {
                  if (Close[i]<lLast && fh) {fs=2; countBar=minBars; fh=false;}
                  if (countBar==0 && si-di>Low[i] && High[i]<hLast && fh) {fs=2; countBar=minBars; fh=false;}

                  if (fs==2) // ����� �������� � ����������� �� ����������
                    {
                     zz[ai]=High[ai];
                     zzH[ai]=High[ai];
                     lLast=Low[i];
                     if (ExtIndicator==3) di=High[i]-Low[i];
                     si=Low[i];
                     bi=i;
                     tbi=Time[i];
                     if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0)
                       {
                        ha[ai]=High[ai];
                        tml=Time[i]; ha[i]=0; la[i]=Low[i]; // ����������� ����� �� ���������� ����
                       }
//                  else if (chHL && chHL_PeakDet_or_vts) {ha[i]=si+di; la[i]=si;}
                    }
                 }
              }
            else // fs==2
              {
               if (lLast<Low[i] && !fl) fl=true;

               if (i==0)
                 {
                  if (Close[i+1]>hLast && fl) {fs=1; countBar=minBars; fl=false;}
                  if (countBar==0 && si+di<High[i+1] && Low[i+1]>lLast && bi0>i+1 && fl && !fcount0) {fs=1; countBar=minBars; fl=false;}

                  if (fs==1) // ����� �������� � ����������� �� ���������� �� ���������� ����
                    {
                     zz[bi0]=Low[bi0];
                     zzL[bi0]=Low[bi0];
                     hLast=High[i+1];
                     if (ExtIndicator==3) di=High[i+1]-Low[i+1];
                     si=High[i+1];
                     ai=i+1;
                     tai=Time[i+1];
                     if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0)
                       {
                        la[bi0]=Low[bi0];
                        tmh=Time[i+1]; ha[i+1]=High[i+1]; la[i+1]=0; // ����������� ����� �� ���������� ����
                       }
//                  else if (chHL && chHL_PeakDet_or_vts) {ha[i+1]=si; la[i+1]=si-di;}
                    }
                 }
               else
                 {
                  if (Close[i]>hLast && fl) {fs=1; countBar=minBars; fl=false;}
                  if (countBar==0 && si+di<High[i] && Low[i]>lLast && fl) {fs=1; countBar=minBars; fl=false;}

                  if (fs==1) // ����� �������� � ����������� �� ����������
                    {
                     zz[bi]=Low[bi];
                     zzL[bi]=Low[bi];
                     hLast=High[i];
                     if (ExtIndicator==3) di=High[i]-Low[i];
                     si=High[i];
                     ai=i;
                     tai=Time[i];
                     if ((ExtIndicator!=11 || endSearchPattern) && ExtLabel>0)
                       {
                        la[bi]=Low[bi];
                        tmh=Time[i]; ha[i]=High[i]; la[i]=0; // ����������� ����� �� ���������� ����
                       }
//                  else if (chHL && chHL_PeakDet_or_vts==1) {ha[i]=si; la[i]=si-di;}
                    }
                 }
              }
           } 

         // ����������� ������
         if (fs==1 && High[i]>si) {ai=i; tai=Time[i]; hLast=High[i]; si=High[i]; countBar=minBars; fh=false; if (ExtIndicator==3) di=High[i]-Low[i];}
         if (fs==2 && Low[i]<si) {bi=i; tbi=Time[i]; lLast=Low[i]; si=Low[i]; countBar=minBars; fl=false; if (ExtIndicator==3) di=High[i]-Low[i];}

         if ((ExtIndicator!=11 || endSearchPattern))
           {
            // ��������� ������ ��� ������� �������������
            if (chHL && chHL_PeakDet_or_vts && ExtLabel==0)
              {
               if (fs==1) {ha[i]=si; la[i]=si-di;}
               if (fs==2) {ha[i]=si+di; la[i]=si;}
              } 

            //===================================================================================================
            // ������� ���. ������ ������� ���� ZigZag-a
            if (i==0) 
              {
               ai0=iBarShift(Symbol(),Period(),tai); 
               bi0=iBarShift(Symbol(),Period(),tbi);

               if (fs==1)
                 {
                  for (n=bi0-1; n>=0; n--) {zzH[n]=0; zz[n]=0; if (ExtLabel>0) ha[n]=0;} 
                  zz[ai0]=High[ai0]; zzH[ai0]=High[ai0]; zzL[ai0]=0; if (ExtLabel>0) ha[ai0]=High[ai0];
                 }
               if (fs==2)
                 {
                  for (n=ai0-1; n>=0; n--) {zzL[n]=0; zz[n]=0; if (ExtLabel>0) la[n]=0;} 
                  zz[bi0]=Low[bi0]; zzL[bi0]=Low[bi0]; zzH[bi0]=0; if (ExtLabel>0) la[bi0]=Low[bi0];
                 }

               if (ExtLabel>0)
                 {
                  if (fs==1) {aim=iBarShift(Symbol(),0,tmh); if (aim<bi0) ha[aim]=High[aim];}
                  else if (fs==2) {bim=iBarShift(Symbol(),0,tml); if (bim<ai0) la[bim]=Low[bim];}
                 }
              }
            //====================================================================================================
           }
        }

      if (ExtIndicator==11)
        {
         // ����� ���������

         if (endSearchPattern)
           {
            return(0);
           }

         _Gartley("ExtIndicator=11_"+minBars+"/"+vSize+"", 0);

         if (saveParametersZZ)
           {
            saveParametersZZ=false;
            minSizeToNumberPattern=vSize;
           }

         if (ExtGartleyTypeSearch==0 && vPatOnOff)
           {
            return(0);
           }

        }
     }
 }
//--------------------------------------------------------
// ��������� �������� ����������� � Ensign. �����. 
//--------------------------------------------------------

//----------------------------------------------------
//  ZigZag (�� ��4 ������� ����������). ������.
//----------------------------------------------------
void ZigZag_()
  {
//  ZigZag �� ��. ������.
   int    shift, back,lasthighpos,lastlowpos,lastpos;
   double val;
   double curlow,curhigh,lasthigh,lastlow;
   int    vDepth = 0;
   int    vBackstep = ExtBackstep;
   bool   endCyklDirection=true;
   bool   endSearchPattern=false;
   int    i;

   if (ExtMaxBar>0) _maxbarZZ=ExtMaxBar; else _maxbarZZ=Bars;

   if (ExtIndicator==11)
     {
      Depth    = minDepth;
     }
   else
     {
      Depth    = minBars;
      minDepth = minBars;
      maxDepth = minBars;
     }

   if (DirectionOfSearchMaxMin) vDepth = maxDepth; else vDepth = minDepth;

   while (endCyklDirection)
     {
      if (ExtIndicator==11)
        {
         if (ExtLabel>0) {ArrayInitialize(la,0.0); ArrayInitialize(ha,0.0);}
         ArrayInitialize(zz,0);ArrayInitialize(zzL,0);ArrayInitialize(zzH,0);

         if (DirectionOfSearchMaxMin)
           {
            if (vDepth < minDepth)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vDepth=minBarsToNumberPattern;
               else vDepth=minBars;
               endSearchPattern=true;
              }

            Depth = vDepth;
            vDepth-=IterationStepDepth;
           }
         else
           {
            if (vDepth > maxDepth)
              {
               if (ExtGartleyTypeSearch>0 && ExtIndicator==11 && vPatOnOff) vDepth=minBarsToNumberPattern;
               else vDepth=minBars;
               endSearchPattern=true;
              }

            Depth = vDepth;
            vDepth+=IterationStepDepth;
           }

         if (flagExtGartleyTypeSearch2) {endSearchPattern=true; Depth=minBarsToNumberPattern;}
        }
      else
        {
         endCyklDirection=false;
        }

      minBarsX=Depth;
      
      // ������ ������� ����
      for(shift=_maxbarZZ-Depth; shift>=ExtMinBar; shift--)
        {
         i=iLowest(NULL,0,MODE_LOW,Depth,shift);
         if (i==shift)
           {
            val=Low[i];
            if (!noBackstep)
              {
               if(val==lastlow) val=0.0;
               else 
                 { 
                  lastlow=val; 
                  for(back=1; back<=vBackstep; back++)
                    {
                     if(val<zzL[shift+back]) zzL[shift+back]=0.0; 
                    }
                 } 
              }
             zzL[shift]=val;
             if (ExtLabel>0) la[shift]=val;
            }

          i=iHighest(NULL,0,MODE_HIGH,Depth,shift);
          if (i==shift)
            {
             val=High[i];
            if (!noBackstep)
              {
                if(val==lasthigh) val=0.0;
                else 
                  {
                   lasthigh=val;
                   for(back=1; back<=vBackstep; back++)
                     {
                      if(val>zzH[shift+back]) zzH[shift+back]=0.0; 
                     }
                  }
               }
             zzH[shift]=val;
             if (ExtLabel>0) ha[shift]=val;
            }
        }

      // ������ ������� ���� 
      lasthigh=-1; lasthighpos=-1;
      lastlow=-1;  lastlowpos=-1;

      for(shift=_maxbarZZ-Depth; shift>=ExtMinBar; shift--)
        {
         curlow=zzL[shift];
         curhigh=zzH[shift];
         if((curlow==0)&&(curhigh==0)) continue;

         if(curhigh!=0)
           {
            if(lasthigh>0) 
              {
               if(lasthigh<curhigh) zzH[lasthighpos]=0;
               else zzH[shift]=0;
              }

            if(lasthigh<curhigh || lasthigh<0)
              {
               lasthigh=curhigh;
               lasthighpos=shift;
              }
            lastlow=-1;
           }

         if(curlow!=0)
           {
            if(lastlow>0)
              {
               if(lastlow>curlow) zzL[lastlowpos]=0;
               else zzL[shift]=0;
              }

            if((curlow<lastlow)||(lastlow<0))
              {
               lastlow=curlow;
               lastlowpos=shift;
              } 
            lasthigh=-1;
           }
        }

      // ������ ������� ����
      lasthigh=-1; lasthighpos=-1;
      lastlow=-1;
      lastpos=-1;
      for(shift=_maxbarZZ-1; shift>=ExtMinBar; shift--)
        {
         zz[shift]=zzL[shift];
         if(shift>=_maxbarZZ-Depth) {zzH[shift]=0.0; zzL[shift]=0.0; zz[shift]=0.0;}
         else
           {
            if (!noBackstep)
              {
               if(zzH[shift]!=0.0) zz[shift]=zzH[shift];
              }
            else
              {
               if(zzH[shift]>0.0)
                 {
                  if (zz[shift]>0)
                    {
                     if (lasthigh>0 && iLow(NULL,0,shift)<iLow(NULL,0,lastpos) && iHigh(NULL,0,shift)>iHigh(NULL,0,lastpos)) zz[shift]=zzH[shift];
                    }
                  else zz[shift]=zzH[shift];
                 }
              }

            if (zz[shift]>0)
              {
               lastpos=shift;
               if (zzL[shift]==zz[shift]>0)
                 {
                  curlow=zz[shift];
                  lasthigh=-1; curhigh=0; 
                  if (noBackstep)
                    {
                     if(lastlow>0)
                       {
                        if(lastlow>curlow) zz[lastlowpos]=0;
                        else zz[shift]=0;
                       }
                     //---
                     if(curlow<lastlow || lastlow<0)
                       {
                        lastlow=curlow;
                        lastlowpos=shift;
                       } 
                    }
                  continue;
                 }
               lastlow=-1;
               curhigh=zzH[shift];
               if(lasthigh>0) 
                 {
                  if(lasthigh<curhigh) zz[lasthighpos]=0;
                  else zz[shift]=0;
                 }

               if(lasthigh<curhigh || lasthigh<0)
                 {
                  lasthigh=curhigh;
                  lasthighpos=shift;
                 }
              }
           }
        }

      if (ExtIndicator!=11 && ExtLabel>0)  // ����������� ����� �� �����, ��� �������� ����� ��� � �� ��������� �������
        {
         Metka();
        }

      // ����� ���������
      if (ExtIndicator==11)
        {
         if (ExtLabel>0 && endSearchPattern)  // ����������� ����� �� �����, ��� �������� ����� ��� � �� ��������� �������
           {
            Metka();
           }

         if (endSearchPattern)
           {
            return(0);
           }

         _Gartley("ExtIndicator=11_0_" + Depth+"/"+vBackstep, Depth);

         if (saveParametersZZ)
           {
            saveParametersZZ=false;
            minBarsToNumberPattern=Depth;
           }

         if (ExtGartleyTypeSearch==0 && vPatOnOff)
           {
            return(0);
           }

         if (FiboStep) {vBackstep=vDepth*1.618; ExtBackstep=vBackstep;}
        }  // ����� ��������� �����
     }
  }
//--------------------------------------------------------
// ZigZag �� ��. �����. 
//--------------------------------------------------------

//--------------------------------------------------------
// ����������� �����. ������.
//--------------------------------------------------------
void Metka()
  {
   int shift, metka=0; // =0 - �� ������� �������� ZZ. =1 - ���� ����� ����������. =2 - ���� ����� ���������.
   for(shift=Bars-1; shift>=0; shift--)
     {
      if (zz[shift]>0)
        {
         if (zzH[shift]>0)
           {
            metka=2; la[shift]=0; shift--;
           }
         else
           {
            metka=1; ha[shift]=0; shift--;
           }
        }

      if (metka==0)
        {
         ha[shift]=0; la[shift]=0;
        }
      else if (metka==1)
        {
         if (ha[shift]>0) metka=0;
         la[shift]=0;
        }
      else if (metka==2)
        {
         if (la[shift]>0) metka=0;
         ha[shift]=0;
        }
     }
  }
//--------------------------------------------------------
// ����������� �����. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ��������� Gartley. ������.
//--------------------------------------------------------
void _Gartley(string _Depth, int Depth)
  {
   int  i, ip=0, in=0, ik[2], iu, ibreak, j, k, m, shift, kod, kod1;
   bool PotencialsLevels_retXD_=false;

   double   LevelDA1272,LevelDA1618,LevelDA2,LevelDA2618,LevelDA3618,LevelDA4236,LevelDC786=0,LevelDC886=0,LevelDC1272,LevelDC1618,LevelDC2,LevelDC2618,LevelDC3618,LevelDC4236;
   double   LevelForD;
   datetime timeLineD;
   double   bartoD=10000;
   double   vlXB=0, vhXB=0, vlAC=0, vhAC=0, vlBD=0, vhBD=0, vlXD=0, vhXD=0;
   double   vl786=min_DeltaGartley * 0.786;
   double   vh786=max_DeltaGartley * 0.786;
   double   vl886=min_DeltaGartley * 0.886;
   double   vh886=max_DeltaGartley * 0.886;

   int      aXABCD[5]; // ������ ����� � ������� XABCD ������������ ���������
   double   retXD;
   double   retXB;
   double   retBD;
   double   retAC;
   double   XA, BC, XC, BD, AB, CD;
   
   double   vDelta0 = 0.0000001;
   int      X=0,A=1,B=2,C=3,D=4;
   string   nameObj1="", nameObj2="";
   string   vBull      = "Bullish";
   string   vBear      = "Bearish";
   string   vCustom    = "Henry";
   string   v4Point    = "4-P Continuation";
   string   vABCD      = "AB=CD";
   string   vABCD1272  = "1.272*AB=CD";
   string   vABCD1618  = "1.618*AB=CD";

   string   v50        = "5-0";
   string   vDragon    = "Dragon";
   datetime tDragonE   = 0;
   double   cDragonE   = 0;
   int      aNumBarPeak[];
   double   tangensXB;

   color    colorPattern;
   bool     yes;

   LevelForDmin = 0;
   LevelForDmax = 0;
   vBullBear    = "";
   vNamePattern = "";
   vNameStrongPattern = "";

   if (ExtIndicator!=11) delete_objects3();
   if (varStrongPatterns==1 || PotencialsLevels_retXD>0) delete_FiboStrongPattern();

   if ((ExtGartleyTypeSearch==0 && ExtIndicator==11) || ExtIndicator!=11) vPatOnOff = false;
   maxPeak      = 0;

   ArrayResize(aNumBarPeak, ArraySize(zz));
   for(shift=0; shift<_maxbarZZ; shift++)
     {
      if (zz[shift]>0) {aNumBarPeak[maxPeak] = shift; maxPeak++;}
     }

   ArrayResize(aNumBarPeak, maxPeak);

   if (ExtIndicator>5 && ExtIndicator<11 && GrossPeriod>Period())
     {
      bartoD=maxBarToD;
     }
   else
     {
      if (patternInfluence==1)
        {
         bartoD=AllowedBandPatternInfluence*(aNumBarPeak[4]-aNumBarPeak[0]);
        }
      else if (patternInfluence==0)
        {
         bartoD=maxBarToD;
        }
     }

   aXABCD[D] = aNumBarPeak[0];
   k = 0;
   while (k < maxPeak-5 && (aXABCD[D] < bartoD+2 || patternInfluence==2))
     {
      aXABCD[X] = aNumBarPeak[k + 4];
      aXABCD[A] = aNumBarPeak[k + 3];
      aXABCD[B] = aNumBarPeak[k + 2];
      aXABCD[C] = aNumBarPeak[k + 1];
      aXABCD[D] = aNumBarPeak[k];

      vBullBear    = "";
      vNamePattern = "";
      if (CustomPattern<2)
        {
         tangensXB=(zz[aXABCD[B]]-zz[aXABCD[X]])/(aXABCD[X]-aXABCD[B]);

         if (zz[aXABCD[C]]>zz[aXABCD[D]] && (zz[aXABCD[B]]+(aXABCD[B]-aXABCD[D])*tangensXB)>zz[aXABCD[D]])
           {
            vBullBear = vBull;
           }
         else if (zz[aXABCD[C]]<zz[aXABCD[D]] && (zz[aXABCD[B]]+(aXABCD[B]-aXABCD[D])*tangensXB)<zz[aXABCD[D]])
           {
            vBullBear = vBear;
           }

         if (StringLen(vBullBear)>0)
           { 
            // ���������� �����������
            retXB = (zz[aXABCD[A]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[X]] + vDelta0);
            retAC = (zz[aXABCD[C]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[B]] + vDelta0);
            retBD = (zz[aXABCD[C]] - zz[aXABCD[D]]) / (zz[aXABCD[C]] - zz[aXABCD[B]] + vDelta0);
            if ((zz[aXABCD[A]]>zz[aXABCD[C]] && vBullBear == vBull) || (zz[aXABCD[A]]<zz[aXABCD[C]] && vBullBear == vBear)) retXD = (zz[aXABCD[A]] - zz[aXABCD[D]]) / (zz[aXABCD[A]] - zz[aXABCD[X]] + vDelta0);
            else retXD = (zz[aXABCD[C]] - zz[aXABCD[D]]) / (zz[aXABCD[C]] - zz[aXABCD[X]] + vDelta0);

            // ������ ��������
            vNameStrongPattern = "";
            ArrayInitialize(ret,0);
            for (ip=1;ip<19;ip++)
              {
               if (retXD>=deltapatterns[ip,0] && retXD<=deltapatterns[ip,1]) {ret[0]=ip; vlXD = deltapatterns[ip,0]; vhXD = deltapatterns[ip,1];}
               if (retXB>=deltapatterns[ip,0] && retXB<=deltapatterns[ip,1]) {ret[1]=ip; vlXB = deltapatterns[ip,0]; vhXB = deltapatterns[ip,1];}
               if (retAC>=deltapatterns[ip,0] && retAC<=deltapatterns[ip,1]) {ret[2]=ip; vlAC = deltapatterns[ip,0]; vhAC = deltapatterns[ip,1];}
               if (retBD>=deltapatterns[ip,0] && retBD<=deltapatterns[ip,1]) {ret[3]=ip; vlBD = deltapatterns[ip,0]; vhBD = deltapatterns[ip,1];}
              }

            if (PotencialsLevels_retXD<2 && SelectPattern<8)
              {
               if (varStrongPatterns==0)
                 {
                  if (ret[0]>0 && ret[1]>0 && ret[2]>0 && ret[3]>0)
                    {
                     for (shift=0;shift<8;shift++) if (ret[0]==nstrcod[shift,0]) break;
                     if (shift==8) ret[0]=0;
                    }
                  else ret[0]=0;
                 }
               else if (varStrongPatterns==1)
                 {
                  if (ret[0]==0)
                    {
                     for (ip=1;ip<18;ip++) if (retXD>=deltapatterns[ip,1] && retXD<=deltapatterns[ip+1,0]) {ret[0]=ip+1; break;}
                     for (shift=0;shift<8;shift++) if (ret[1]==nstrind[shift,0]) break;
                     if (shift==8) ret[0]=0;
                    }
                 }

               if (ret[0]>0)
                 {
                  kod=ret[3]+100*ret[2]+10000*ret[1];
                  yes=false;
                  for (ip=shift;ip<788;ip++)
                    {
                     if (varStrongPatterns==0)
                       {
                        if (ret[0]<codPatterns[ip,0] || kod<codPatterns[ip,1]) break;
                        if (kod==codPatterns[ip,1])
                          {
                           if (!CustomPat_[codPatterns[ip,2]]) break;
                           yes=true;
                           vNamePattern=namepatterns[codPatterns[ip,2]];
                           vNameStrongPattern = "["+retpatternstxt[ret[1]]+"/"+retpatternstxt[ret[2]]+"/"+retpatternstxt[ret[3]]+"]";
                          }
                       }
                     else if (varStrongPatterns==1)
                       {
                        if (kod<index[ip,1]) break;
                        if (kod==index[ip,1])
                          {
                           ArrayInitialize(levelXD,0);
                           iu=-1; ik[0]=-1; ik[1]=-1;
                           for(in=ip;in<ip+10;in++)
                             {
                              if (kod<index[in,1]) break;
                              if (kod==index[in,1])
                                {
                                 if (CustomPat_[codPatterns[index[in,0],2]])
                                   {
                                    iu++;
                                    levelXD[iu,0]=codPatterns[index[in,0],2];
                                    levelXD[iu,1]=codPatterns[index[in,0],0];
                                    if ((ret[0]>levelXD[iu,1] && ik[0]<levelXD[iu,1]) || (ik[0]<0 && ik[1]<0)) {ik[0]=levelXD[iu,1]; ik[1]=levelXD[iu,0];}
                                   }
                                }
                             }

                           if (iu>=0)
                             {
                              vNamePattern=namepatterns[ik[1]];
                              vNameStrongPattern = "["+retpatternstxt[ret[1]]+"/"+retpatternstxt[ret[2]]+"/"+retpatternstxt[ret[3]]+"]";
                              ret[0]=ik[0]; vlXD = deltapatterns[ik[0],0]; vhXD = deltapatterns[ik[0],1];
                              yes=true;
                             }
                          }
                       }
//  0      1      2      3     4    5      6      7      8      9      10     11     12    13    14     15     16      17     18
//0.146  0.236  0.382  0.447  0.5  0.618  0.707  0.786  0.886  1.128  1.272  1.414  1.618  2.0  2.236  2.618  3.1416  3.618  4.236

                     if (yes)
                       {
                        // ������������ ���� �������� ����� D ��������
                        if (RangeForPointD>0 || patternTrue)
                          {
                           if (retAC<1)
                             {
                              XA=zz[aXABCD[A]] - zz[aXABCD[X]];
                              BC=zz[aXABCD[C]] - zz[aXABCD[B]];
                              if (varStrongPatterns==0)
                                {
                                 if (vBullBear==vBull)
                                   {
                                    LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vhXD,zz[aXABCD[C]]-BC*vhBD);
                                    LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vlXD,zz[aXABCD[C]]-BC*vlBD);
                                   }
                                 else
                                   {
                                    LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vlXD,zz[aXABCD[C]]-BC*vlBD);
                                    LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vhXD,zz[aXABCD[C]]-BC*vhBD);
                                   }
                                }
                              else if (varStrongPatterns==1)
                                {
                                 if (vBullBear==vBull)
                                   {
                                    LevelForDmin = MathMin(zz[aXABCD[A]]-XA*vhXD,zz[aXABCD[C]]-BC*vhBD);
                                    LevelForDmax = MathMax(zz[aXABCD[A]]-XA*vlXD,zz[aXABCD[C]]-BC*vlBD);
                                   }
                                 else
                                   {
                                    LevelForDmin = MathMin(zz[aXABCD[A]]-XA*vlXD,zz[aXABCD[C]]-BC*vlBD);
                                    LevelForDmax = MathMax(zz[aXABCD[A]]-XA*vhXD,zz[aXABCD[C]]-BC*vhBD);
                                   }
                                }

                              if (RangeForPointD==2)
                                {
                                 LevelDA1272   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*1.272;
                                 LevelDA1618   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*phi;
                                 LevelDA2      = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*2;
                                 LevelDA2618   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*(1+phi);
                                 LevelDA3618   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*(2+phi);
                                 LevelDA4236   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*(4.236);
                                }
                             }
                           else
                             {
                              XC=zz[aXABCD[C]] - zz[aXABCD[X]];
                              BC=zz[aXABCD[C]] - zz[aXABCD[B]];
                              if (varStrongPatterns==0)
                                {
                                 if (vBullBear==vBull)
                                   {
                                    LevelForDmin = MathMax(zz[aXABCD[C]]-XC*vhXD,zz[aXABCD[C]]-BC*vhBD);
                                    LevelForDmax = MathMin(zz[aXABCD[C]]-XC*vlXD,zz[aXABCD[C]]-BC*vlBD);
                                   }
                                 else
                                   {
                                    LevelForDmin = MathMax(zz[aXABCD[C]]-XC*vlXD,zz[aXABCD[C]]-BC*vlBD);
                                    LevelForDmax = MathMin(zz[aXABCD[C]]-XC*vhXD,zz[aXABCD[C]]-BC*vhBD);
                                   }
                                }
                              else if (varStrongPatterns==1)
                                {
                                 if (vBullBear==vBull)
                                   {
                                    LevelForDmin = MathMin(zz[aXABCD[C]]-XC*vhXD,zz[aXABCD[C]]-BC*vhBD);
                                    LevelForDmax = MathMax(zz[aXABCD[C]]-XC*vlXD,zz[aXABCD[C]]-BC*vlBD);
                                   }
                                 else
                                   {
                                    LevelForDmin = MathMin(zz[aXABCD[C]]-XC*vlXD,zz[aXABCD[C]]-BC*vlBD);
                                    LevelForDmax = MathMax(zz[aXABCD[C]]-XC*vhXD,zz[aXABCD[C]]-BC*vhBD);
                                   }
                                }

                              if (RangeForPointD==2)
                                {
                                 LevelDA1272   = 0;
                                 LevelDA1618   = 0;
                                 LevelDA2      = 0;
                                 LevelDA2618   = 0;
                                 LevelDA3618   = 0;
                                 LevelDA4236   = 0;
                                }
                             }

                           if (RangeForPointD==2)
                             {
                              LevelDC1272   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*1.272;
                              LevelDC1618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*phi;
                              LevelDC2      = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*2;
                              LevelDC2618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(1+phi);
                              LevelDC3618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(2+phi);
                              LevelDC4236   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(4.236);
                             }

                           if (patternTrue)
                             {
                              if (k<2)
                                {
                                 if (vBullBear==vBull)
                                   {
                                    for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                                      {
                                       if (iLow(NULL,0,ibreak)<LevelForDmin)
                                         {
                                          vNamePattern = "";
                                          vNameStrongPattern = "";
                                          break;
                                         }
                                      }
                                   }
                                 else
                                   {
                                    for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                                      {
                                       if (iHigh(NULL,0,ibreak)>LevelForDmax)
                                         {
                                          vNamePattern = "";
                                          vNameStrongPattern = "";
                                          break;
                                         }
                                      }
                                   }
                                }
                              else
                                {
                                 if (vBullBear==vBull)
                                   {
                                    for (ibreak=k;ibreak>=2;ibreak--)
                                      {
                                       if (iLow(NULL,0,aNumBarPeak[ibreak-2])<LevelForDmin)
                                         {
                                          vNamePattern = "";
                                          vNameStrongPattern = "";
                                          break;
                                         }
                                      }
                                   }
                                 else
                                   {
                                    for (ibreak=k;ibreak>=2;ibreak--)
                                      {
                                       if (iHigh(NULL,0,aNumBarPeak[ibreak-2])>LevelForDmax)
                                         {
                                          vNamePattern = "";
                                          vNameStrongPattern = "";
                                          break;
                                         }
                                      }
                                   }
                                }
                             }
                          }

                        break;
                       }
                    }
                 }
              }

            // �������� ��������
            if (StringLen(vNamePattern)==0 && PotencialsLevels_retXD<2 && SelectPattern<8)
              {
               for (ip=0;ip<33;ip++)
                 {
                  if (!CustomPat_[ip]) continue;

                  vlAC = minAC_[ip];
                  vlBD = minBD_[ip];
                  vlXB = minXB_[ip];
                  vlXD = minXD_[ip];

                  vhAC = maxAC_[ip];
                  vhBD = maxBD_[ip];
                  vhXB = maxXB_[ip];
                  vhXD = maxXD_[ip];

                  if (retAC>vlAC && retAC<vhAC && retBD>vlBD && retBD<vhBD && retXB>vlXB && retXB<vhXB && retXD>vlXD && retXD<vhXD)
                    {
                     vNamePattern=namepatterns[ip];
                     // ������������ ���� �������� ����� D ��������
                     if (RangeForPointD>0 || patternTrue)
                       {
                        if (retAC<1)
                          {
                           XA=zz[aXABCD[A]] - zz[aXABCD[X]];
                           BC=zz[aXABCD[C]] - zz[aXABCD[B]];
                           if (vBullBear==vBull)
                             {
                              LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vhXD,zz[aXABCD[C]]-BC*vhBD);
                              LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vlXD,zz[aXABCD[C]]-BC*vlBD);
                             }
                           else
                             {
                              LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vlXD,zz[aXABCD[C]]-BC*vlBD);
                              LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vhXD,zz[aXABCD[C]]-BC*vhBD);
                             }

                           if (RangeForPointD==2)
                             {
                              LevelDA1272   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*1.272;
                              LevelDA1618   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*phi;
                              LevelDA2      = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*2;
                              LevelDA2618   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*(1+phi);
                              LevelDA3618   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*(2+phi);
                              LevelDA4236   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*(4.236);
                             }
                          }
                        else
                          {
                           XC=zz[aXABCD[C]] - zz[aXABCD[X]];
                           BC=zz[aXABCD[C]] - zz[aXABCD[B]];
                           if (vBullBear==vBull)
                             {
                              LevelForDmin = MathMax(zz[aXABCD[C]]-XC*vhXD,zz[aXABCD[C]]-BC*vhBD);
                              LevelForDmax = MathMin(zz[aXABCD[C]]-XC*vlXD,zz[aXABCD[C]]-BC*vlBD);
                             }
                           else
                             {
                              LevelForDmin = MathMax(zz[aXABCD[C]]-XC*vlXD,zz[aXABCD[C]]-BC*vlBD);
                              LevelForDmax = MathMin(zz[aXABCD[C]]-XC*vhXD,zz[aXABCD[C]]-BC*vhBD);
                             }

                           if (RangeForPointD==2)
                             {
                              LevelDA1272   = 0;
                              LevelDA1618   = 0;
                              LevelDA2      = 0;
                              LevelDA2618   = 0;
                              LevelDA3618   = 0;
                              LevelDA4236   = 0;
                             }
                          }

                        if (RangeForPointD==2)
                          {
                           LevelDC1272   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*1.272;
                           LevelDC1618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*phi;
                           LevelDC2      = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*2;
                           LevelDC2618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(1+phi);
                           LevelDC3618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(2+phi);
                           LevelDC4236   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(4.236);
                          }

                        if (patternTrue)
                          {
                           if (k<2)
                             {
                              if (vBullBear==vBull)
                                {
                                 for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                                   {
                                    if (iLow(NULL,0,ibreak)<LevelForDmin)
                                      {
                                       vNamePattern = "";
                                       break;
                                      }
                                   }
                                }
                              else
                                {
                                 for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                                   {
                                    if (iHigh(NULL,0,ibreak)>LevelForDmax)
                                      {
                                       vNamePattern = "";
                                       break;
                                      }
                                   }
                                }
                             }
                           else
                             {
                              if (vBullBear==vBull)
                                {
                                 for (ibreak=k;ibreak>=2;ibreak--)
                                   {
                                    if (iLow(NULL,0,aNumBarPeak[ibreak-2])<LevelForDmin)
                                      {
                                       vNamePattern = "";
                                       break;
                                      }
                                   }
                                }
                              else
                                {
                                 for (ibreak=k;ibreak>=2;ibreak--)
                                   {
                                    if (iHigh(NULL,0,aNumBarPeak[ibreak-2])>LevelForDmax)
                                      {
                                       vNamePattern = "";
                                       break;
                                      }
                                   }
                                }
                             }
                          }
                       }
                    }

                  if (StringLen(vNamePattern)>0) // �� ���� ��� REAL ABCD
                    {
                     break;
                    }
                 }
              }

            if (Dragon && StringLen(vNamePattern)==0 && k<=PeakZZDragon && PotencialsLevels_retXD<2)
              {
               vlXB=min_DeltaGartley * 0.382;
               vhXB=max_DeltaGartley * 0.5;
               vlAC=min_DeltaGartley * 0.618;
               vhAC=max_DeltaGartley * 1.272;

               if (retXB>=vlXB && retXB<=vhXB && retAC>=vlAC && retAC<=vhAC)
                 {
                  vNamePattern=vDragon;
                  cDragonE=zz[aXABCD[X]]+(aXABCD[X]-aXABCD[C])*tangensXB;
                  if ((vBullBear==vBear && cDragonE<iLow(NULL,0,aXABCD[C])) || (vBullBear==vBull && cDragonE>iHigh(NULL,0,aXABCD[C]))) vNamePattern="";
                  else
                    {
                     tDragonE=0;
                     double _level=0;
                     bool BB=false;
                     if (vBullBear==vBull)
                       {
                        vBullBear=vBear;
                        _level=MathMax(iHigh(NULL,0,aXABCD[A]),iHigh(NULL,0,aXABCD[C]));
                       }
                     else
                       {
                        vBullBear=vBull;
                        _level=MathMin(iLow(NULL,0,aXABCD[A]),iLow(NULL,0,aXABCD[C]));
                        BB=true;
                       }

                     for (i=aXABCD[C]-1;i>=0;i--)
                       {
                        if (tDragonE==0)
                          {
                           cDragonE=zz[aXABCD[X]]+(aXABCD[X]-i)*tangensXB;
                           if (cDragonE>=iLow(NULL,0,i) && cDragonE<=iHigh(NULL,0,i))
                             {
                              tDragonE=iTime(NULL,0,i); i++;
                             }
                          }
                        else
                          {
                           if (BB)
                             {
                              if (_level>iLow(NULL,0,i)) {vNamePattern=""; break;}
                             }
                           else
                             {
                              if (_level<iHigh(NULL,0,i)) {vNamePattern=""; break;}
                             }
                          }
                       }

                     LevelForDmin = cDragonE;
                     LevelForDmax = cDragonE;
                    }
                 }
              }
           }
        }

      // CustomPattern
      if (CustomPattern>0 && StringLen(vNamePattern)==0 && PotencialsLevels_retXD<2)
        {
         vBullBear    = "";
         vNamePattern = "";

         vlAC = minAC;
         vlBD = minBD;
         vlXB = minXB;
         vlXD = minXD;

         vhAC = maxAC;
         vhBD = maxBD;
         vhXB = maxXB;
         vhXD = maxXD;

         if (filtrEquilibrium) tangensXB=(zz[aXABCD[B]]-zz[aXABCD[X]])/(aXABCD[X]-aXABCD[B]);

         if (zz[aXABCD[C]]>zz[aXABCD[D]] && (((zz[aXABCD[B]]+(aXABCD[B]-aXABCD[D])*tangensXB)>zz[aXABCD[D]] && filtrEquilibrium) || !filtrEquilibrium))
           {
            vBullBear = vBull;
           }
         else if (zz[aXABCD[C]]<zz[aXABCD[D]] && (((zz[aXABCD[B]]+(aXABCD[B]-aXABCD[D])*tangensXB)<zz[aXABCD[D]] && filtrEquilibrium) || !filtrEquilibrium))
           {
            vBullBear = vBear;
           }

         if (StringLen(vBullBear)>0)
           {
            // ���������� �����������
            retXB = (zz[aXABCD[A]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[X]] + vDelta0);
            retAC = (zz[aXABCD[C]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[B]] + vDelta0);
            retBD = (zz[aXABCD[C]] - zz[aXABCD[D]]) / (zz[aXABCD[C]] - zz[aXABCD[B]] + vDelta0);
            if ((zz[aXABCD[A]]>zz[aXABCD[C]] && vBullBear == vBull) || (zz[aXABCD[A]]<zz[aXABCD[C]] && vBullBear == vBear)) retXD = (zz[aXABCD[A]] - zz[aXABCD[D]]) / (zz[aXABCD[A]] - zz[aXABCD[X]] + vDelta0);
            else retXD = (zz[aXABCD[C]] - zz[aXABCD[D]]) / (zz[aXABCD[C]] - zz[aXABCD[X]] + vDelta0);

            if (retAC>vlAC && retAC<vhAC && retBD>vlBD && retBD<vhBD && retXB>vlXB && retXB<vhXB && retXD>vlXD && retXD<vhXD)
              {
               vNamePattern=vCustom; // Custom
               // ������������ ���� �������� ����� D ��������
               if (RangeForPointD>0 || patternTrue)
                 {
                  if (retAC<1)
                    {
                     XA=zz[aXABCD[A]] - zz[aXABCD[X]];
                     BC=zz[aXABCD[C]] - zz[aXABCD[B]];
                     if (vBullBear==vBull)
                       {
                        LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vhXD,zz[aXABCD[C]]-BC*vhBD);
                        LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vlXD,zz[aXABCD[C]]-BC*vlBD);
                       }
                     else
                       {
                        LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vlXD,zz[aXABCD[C]]-BC*vlBD);
                        LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vhXD,zz[aXABCD[C]]-BC*vhBD);
                       }

                     if (RangeForPointD==2)
                       {
                        LevelDA1272   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*1.272;
                        LevelDA1618   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*phi;
                        LevelDA2      = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*2;
                        LevelDA2618   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*(1+phi);
                        LevelDA3618   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*(2+phi);
                        LevelDA4236   = zz[aXABCD[A]]-(zz[aXABCD[A]]-zz[aXABCD[B]])*(4.236);
                       }
                    }
                  else
                    {
                     XC=zz[aXABCD[C]] - zz[aXABCD[X]];
                     BC=zz[aXABCD[B]] - zz[aXABCD[D]];
                     if (vBullBear==vBull)
                       {
                        LevelForDmin = MathMax(zz[aXABCD[C]]-XC*vhXD,zz[aXABCD[C]]-BC*vhBD);
                        LevelForDmax = MathMin(zz[aXABCD[C]]-XC*vlXD,zz[aXABCD[C]]-BC*vlBD);
                       }
                     else
                       {
                        LevelForDmin = MathMax(zz[aXABCD[C]]-XC*vlXD,zz[aXABCD[C]]-BC*vlBD);
                        LevelForDmax = MathMin(zz[aXABCD[C]]-XC*vhXD,zz[aXABCD[C]]-BC*vhBD);
                       }

                     if (RangeForPointD==2)
                       {
                        LevelDA1272   = 0;
                        LevelDA1618   = 0;
                        LevelDA2      = 0;
                        LevelDA2618   = 0;
                        LevelDA3618   = 0;
                        LevelDA4236   = 0;
                       }
                    }

                  if (RangeForPointD==2)
                    {
                     LevelDC1272   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*1.272;
                     LevelDC1618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*phi;
                     LevelDC2      = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*2;
                     LevelDC2618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(1+phi);
                     LevelDC3618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(2+phi);
                     LevelDC4236   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(4.236);
                    }

                  if (patternTrue)
                    {
                     if (k<2)
                       {
                        if (vBullBear==vBull)
                          {
                           for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                             {
                              if (iLow(NULL,0,ibreak)<LevelForDmin)
                                {
                                 vNamePattern = "";
                                 break;
                                }
                             }
                          }
                        else
                          {
                           for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                             {
                              if (iHigh(NULL,0,ibreak)>LevelForDmax)
                                {
                                 vNamePattern = "";
                                 break;
                                }
                             }
                          }
                       }
                     else
                       {
                        if (vBullBear==vBull)
                          {
                           for (ibreak=k;ibreak>=0;ibreak--)
                             {
                              if (iLow(NULL,0,aNumBarPeak[ibreak-2])<LevelForDmin)
                                {
                                 vNamePattern = "";
                                 break;
                                }
                             }
                          }
                        else
                          {
                           for (ibreak=k;ibreak>=0;ibreak--)
                             {
                              if (iHigh(NULL,0,aNumBarPeak[ibreak-2])>LevelForDmax)
                                {
                                 vNamePattern = "";
                                 break;
                                }
                             }
                          }
                       }
                    }

                 }
              }
           }
        }

      PotencialsLevels_retXD_=false;
      if (StringLen(vNamePattern)==0 && PotencialsLevels_retXD>0 && k<=PotencialsLevelsNum)
        {
         iu=-1;
         // ���������� �����������
         retAC = (zz[aXABCD[C]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[B]] + vDelta0);
         retBD = (zz[aXABCD[C]] - zz[aXABCD[D]]) / (zz[aXABCD[C]] - zz[aXABCD[B]] + vDelta0);
         // ������ ��������
         vNameStrongPattern = "";
         ArrayInitialize(ret,0);
         for (ip=1;ip<19;ip++)
           {
            if (retAC>=deltapatterns[ip,0] && retAC<=deltapatterns[ip,1]) {ret[2]=ip; vlAC = deltapatterns[ip,0]; vhAC = deltapatterns[ip,1];}
            if (retBD>=deltapatterns[ip,0] && retBD<=deltapatterns[ip,1]) {ret[3]=ip; vlBD = deltapatterns[ip,0]; vhBD = deltapatterns[ip,1];}
           }

         if (ret[3]>0 && ret[2]>0)
           {
            kod1=ret[3]+100*ret[2];
            ArrayInitialize(levelXD,0);
            ArrayInitialize(strongABCD,false);

            for (ip=0;ip<95;ip++) if (kod1==nstrind1[ip,0]) break; // �������� � ������� index - nstrind1[ip,1]
            if (ip<95)
              {
               PotencialsLevels_retXD_=true;
               for(in=nstrind1[ip,1];in<nstrind1[ip,1]+32;in++)
                 {
                  if (kod1<index[in,1]/100) break;
                  if (kod1==index[in,1]/100)
                    {
                     if (CustomPat_[codPatterns[index[in,0],2]])
                       {
                        strongABCD[index[in,1]-kod1*100]=true;
                        if (iu<0)
                          {
                           iu++;
                           levelXD[iu,0]=codPatterns[index[in,0],2];
                           levelXD[iu,1]=codPatterns[index[in,0],0];
                          }
                        else if (levelXD[iu,0]!=codPatterns[index[in,0],2] || levelXD[iu,1]!=codPatterns[index[in,0],0])
                          {
                           int iii;
                           for (iii=0;iii<=iu;iii++)
                             {
                              if (levelXD[iii,0]==codPatterns[index[in,0],2] && levelXD[iii,1]==codPatterns[index[in,0],0]) break;
                             }

                           if (iii>iu)
                             {
                              iu++;
                              levelXD[iu,0]=codPatterns[index[in,0],2];
                              levelXD[iu,1]=codPatterns[index[in,0],0];
                             }
                          }
                       }
                    }
                 }
              }
           }
        }

      // The 4-Point Continuation Pattern - Jim Kane
      if (Ext_4PointPattern && StringLen(vNamePattern)==0 && PotencialsLevels_retXD<2)
        {
         vBullBear    = "";
         vNamePattern = "";

         vlAC=min_DeltaGartley * 0.786;
         vlBD=min_DeltaGartley * 0.786;
         vlXB=0;

         vhAC = max_DeltaGartley * 0.886;
         vhBD = max_DeltaGartley * 0.886;

         if ((zz[aXABCD[A]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[X]] + vDelta0)<_maxXB)
           {
            // ���������� �����������
            retAC = (zz[aXABCD[C]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[B]] + vDelta0);
            retBD = (zz[aXABCD[C]] - zz[aXABCD[D]]) / (zz[aXABCD[C]] - zz[aXABCD[B]] + vDelta0);

            if (retAC>vlAC && retAC<vhAC && retBD>vlBD && retBD<vhBD)
              {
               vNamePattern=v4Point; // The 4-Point Continuation Pattern

               if (zz[aXABCD[C]]>zz[aXABCD[D]])
                 {
                  vBullBear = vBull;
                 }
               else if (zz[aXABCD[C]]<zz[aXABCD[D]])
                 {
                  vBullBear = vBear;
                 }

               // ������������ ���� �������� ����� D ��������
               if (RangeForPointD>0 || patternTrue)
                 {
                  BC=zz[aXABCD[C]] - zz[aXABCD[B]];

                  if (vBullBear==vBull)
                    {
                     LevelForDmin = zz[aXABCD[C]]-BC*vhBD;
                     LevelForDmax = zz[aXABCD[C]]-BC*vlBD;
                    }
                  else
                    {
                     LevelForDmin = zz[aXABCD[C]]-BC*vlBD;
                     LevelForDmax = zz[aXABCD[C]]-BC*vhBD;
                    }

                  if (RangeForPointD==2)
                    {
                     LevelDA1272   = 0;
                     LevelDA1618   = 0;
                     LevelDA2      = 0;
                     LevelDA2618   = 0;
                     LevelDA3618   = 0;
                     LevelDA4236   = 0;

                     LevelDC786    = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*0.786;
                     LevelDC886    = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*0.886;
                     LevelDC1272   = 0;
                     LevelDC1618   = 0;
                     LevelDC2      = 0;
                     LevelDC2618   = 0;
                     LevelDC3618   = 0;
                     LevelDC4236   = 0;
                    }

                  if (patternTrue)
                    {
                     if (k<2)
                       {
                        if (vBullBear==vBull)
                          {
                           for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                             {
                              if (iLow(NULL,0,ibreak)<LevelForDmin)
                                {
                                 vNamePattern = "";
                                 break;
                                }
                             }
                          }
                        else
                          {
                           for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                             {
                              if (iHigh(NULL,0,ibreak)>LevelForDmax)
                                {
                                 vNamePattern = "";
                                 break;
                                }
                             }
                          }
                       }
                     else
                       {
                        if (vBullBear==vBull)
                          {
                           for (ibreak=k;ibreak>=0;ibreak--)
                             {
                              if (iLow(NULL,0,aNumBarPeak[ibreak-2])<LevelForDmin)
                                {
                                 vNamePattern = "";
                                 break;
                                }
                             }
                          }
                        else
                          {
                           for (ibreak=k;ibreak>=0;ibreak--)
                             {
                              if (iHigh(NULL,0,aNumBarPeak[ibreak-2])>LevelForDmax)
                                {
                                 vNamePattern = "";
                                 break;
                                }
                             }
                          }
                       }
                    }

                 }
              }
           }
        }

      if (_50 && StringLen(vNamePattern)==0 && PotencialsLevels_retXD<2)
        {
         vBullBear    = "";
         vNamePattern = "";

         vlAC=min_DeltaGartley * 1.618;
         vlBD=min_DeltaGartley * 0.5;
         vlXB=min_DeltaGartley * 1.128;

         vhAC = max_DeltaGartley * 2.236;
         vhBD = max_DeltaGartley * 0.5;
         vhXB = max_DeltaGartley * 1.618;

         // ���������� �����������
         retAC = (zz[aXABCD[C]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[B]] + vDelta0);
         retBD = (zz[aXABCD[C]] - zz[aXABCD[D]]) / (zz[aXABCD[C]] - zz[aXABCD[B]] + vDelta0);
         retXB = (zz[aXABCD[A]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[X]] + vDelta0);

         if (retAC>vlAC && retAC<vhAC && retBD>vlBD && retBD<vhBD && retXB>vlXB && retXB<vhXB)
           {
            vNamePattern=v50; // 5-0 Pattern

            if (zz[aXABCD[C]]>zz[aXABCD[D]])
              {
               vBullBear = vBull;
              }
            else if (zz[aXABCD[C]]<zz[aXABCD[D]])
              {
               vBullBear = vBear;
              }

            // ������������ ���� �������� ����� D ��������
            if (RangeForPointD>0 || patternTrue)
              {
               BC=zz[aXABCD[C]] - zz[aXABCD[B]];

               if (vBullBear==vBull)
                 {
                  LevelForDmin = zz[aXABCD[C]]-BC*vhBD;
                  LevelForDmax = zz[aXABCD[C]]-BC*vlBD;
                 }
               else
                 {
                  LevelForDmin = zz[aXABCD[C]]-BC*vlBD;
                  LevelForDmax = zz[aXABCD[C]]-BC*vhBD;
                 }

               if (RangeForPointD==2)
                 {
                  LevelDA1272   = 0;
                  LevelDA1618   = 0;
                  LevelDA2      = 0;
                  LevelDA2618   = 0;
                  LevelDA3618   = 0;
                  LevelDA4236   = 0;

                  LevelDC1272   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*1.272;
                  LevelDC1618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*phi;
                  LevelDC2      = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*2;
                  LevelDC2618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(1+phi);
                  LevelDC3618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(2+phi);
                  LevelDC4236   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(4.236);
                 }

               if (patternTrue)
                 {
                  if (k<2)
                    {
                     if (vBullBear==vBull)
                       {
                        for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                          {
                           if (iLow(NULL,0,ibreak)<LevelForDmin)
                             {
                              vNamePattern = "";
                              break;
                             }
                          }
                       }
                     else
                       {
                        for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                          {
                           if (iHigh(NULL,0,ibreak)>LevelForDmax)
                             {
                              vNamePattern = "";
                              break;
                             }
                          }
                       }
                    }
                  else
                    {
                     if (vBullBear==vBull)
                       {
                        for (ibreak=k;ibreak>=0;ibreak--)
                          {
                           if (iLow(NULL,0,aNumBarPeak[ibreak-2])<LevelForDmin)
                             {
                              vNamePattern = "";
                              break;
                             }
                          }
                       }
                     else
                       {
                        for (ibreak=k;ibreak>=0;ibreak--)
                          {
                           if (iHigh(NULL,0,aNumBarPeak[ibreak-2])>LevelForDmax)
                             {
                              vNamePattern = "";
                              break;
                             }
                          }
                       }
                    }
                 }

              }
           }
        }

      if (ABCD && StringLen(vNamePattern)==0 && PotencialsLevels_retXD<2) // ������ ��� REAL ABCD
     
{
vBullBear = "";
vNamePattern = "";

AB=MathAbs(zz[aXABCD[B]] - zz[aXABCD[A]]);
CD=MathAbs(zz[aXABCD[D]] - zz[aXABCD[C]]); 

retAC = (zz[aXABCD[C]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[B]] + vDelta0);
retBD = (zz[aXABCD[C]] - zz[aXABCD[D]]) / (zz[aXABCD[C]] - zz[aXABCD[B]] + vDelta0);

double checkLegsMin=1-ExtDevABCDLeg;
double checkLegsMax=1+ExtDevABCDLeg;

double checkFibRatioMin=1-ExtDevABCDFib ;
double checkFibRatioMax=1+ExtDevABCDFib ;

if(
(retAC>=0.382*checkFibRatioMin && retAC<=0.382*checkFibRatioMax && retBD>=2.240*checkFibRatioMin && retBD<=2.240*checkFibRatioMax)
||
(retAC>=0.382*checkFibRatioMin && retAC<=0.382*checkFibRatioMax && retBD>=2.618*checkFibRatioMin && retBD<=2.618*checkFibRatioMax)
||
(retAC>=0.500*checkFibRatioMin && retAC<=0.500*checkFibRatioMax && retBD>=2.000*checkFibRatioMin && retBD<=2.000*checkFibRatioMax)
||
(retAC>=0.447*checkFibRatioMin && retAC<=0.447*checkFibRatioMax && retBD>=2.237*checkFibRatioMin && retBD<=2.237*checkFibRatioMax)
||
(retAC>=0.618*checkFibRatioMin && retAC<=0.618*checkFibRatioMax && retBD>=1.618*checkFibRatioMin && retBD<=1.618*checkFibRatioMax)
||
(retAC>=0.707*checkFibRatioMin && retAC<=0.707*checkFibRatioMax && retBD>=1.414*checkFibRatioMin && retBD<=1.414*checkFibRatioMax)
||
(retAC>=0.786*checkFibRatioMin && retAC<=0.786*checkFibRatioMax && retBD>=1.270*checkFibRatioMin && retBD<=1.270*checkFibRatioMax)
||
(retAC>=0.854*checkFibRatioMin && retAC<=0.854*checkFibRatioMax && retBD>=1.171*checkFibRatioMin && retBD<=1.171*checkFibRatioMax)
||
(retAC>=0.886*checkFibRatioMin && retAC<=0.886*checkFibRatioMax && retBD>=1.130*checkFibRatioMin && retBD<=1.130*checkFibRatioMax) 
)
{
if ( (CD>AB*checkLegsMin && CD<AB*checkLegsMax && zz[aXABCD[A]] > zz[aXABCD[B]] && zz[aXABCD[A]] > zz[aXABCD[C]] && zz[aXABCD[C]] > zz[aXABCD[B]])
||
(CD>AB*checkLegsMin && CD<AB*checkLegsMax && zz[aXABCD[A]] < zz[aXABCD[B]] && zz[aXABCD[A]] < zz[aXABCD[C]] && zz[aXABCD[C]] < zz[aXABCD[B]])
) 
{
vNamePattern=vABCD; // AB-CD
} 
} 

else
{
for (int iABCD=0;iABCD<_ABCDsize;iABCD++)
{
if ( (CD>_ABCDtype[iABCD]*AB*checkLegsMin && CD<_ABCDtype[iABCD]*AB*checkLegsMax && zz[aXABCD[A]] > zz[aXABCD[B]] && zz[aXABCD[A]] > zz[aXABCD[C]] && zz[aXABCD[C]] > zz[aXABCD[B]])
||
(CD>_ABCDtype[iABCD]*AB*checkLegsMin && CD<_ABCDtype[iABCD]*AB*checkLegsMax && zz[aXABCD[A]] < zz[aXABCD[B]] && zz[aXABCD[A]] < zz[aXABCD[C]] && zz[aXABCD[C]] < zz[aXABCD[B]])
)
{
vNamePattern=_ABCDtypetxt[iABCD]+"*AB=CD";
break;
}
}
}
         if (StringLen(vNamePattern)>0) // �� ���� ��� REAL ABCD
           {
            if (zz[aXABCD[C]]>zz[aXABCD[D]])
              {
               vBullBear = vBull;
              }
            else if (zz[aXABCD[C]]<zz[aXABCD[D]])
              {
               vBullBear = vBear;
              }

            // ������������ ���� �������� ����� D ��������
            if (RangeForPointD>0 || patternTrue)
              {
               if (vNamePattern==vABCD)
                 {
                  if (vBullBear==vBull)
                    {
                     LevelForDmin = zz[aXABCD[C]]-AB*max_DeltaGartley;
                     LevelForDmax = zz[aXABCD[C]]-AB*min_DeltaGartley;
                    }
                  else
                    {
                     LevelForDmin = zz[aXABCD[C]]+AB*min_DeltaGartley;
                     LevelForDmax = zz[aXABCD[C]]+AB*max_DeltaGartley;
                    }
                 }
               else
                 {
                  if (vBullBear==vBull)
                    {
                     LevelForDmin = zz[aXABCD[C]]-_ABCDtype[iABCD]*AB*max_DeltaGartley;
                     LevelForDmax = zz[aXABCD[C]]-_ABCDtype[iABCD]*AB*min_DeltaGartley;
                    }
                  else
                    {
                     LevelForDmin = zz[aXABCD[C]]+_ABCDtype[iABCD]*AB*min_DeltaGartley;
                     LevelForDmax = zz[aXABCD[C]]+_ABCDtype[iABCD]*AB*max_DeltaGartley;
                    }
                 }

               if (RangeForPointD==2)
                 {
                  LevelDA1272   = 0;
                  LevelDA1618   = 0;
                  LevelDA2      = 0;
                  LevelDA2618   = 0;
                  LevelDA3618   = 0;
                  LevelDA4236   = 0;

                  LevelDC1272   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*1.272;
                  LevelDC1618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*phi;
                  LevelDC2      = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*2;
                  LevelDC2618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(1+phi);
                  LevelDC3618   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(2+phi);
                  LevelDC4236   = zz[aXABCD[C]]-(zz[aXABCD[C]]-zz[aXABCD[B]])*(4.236);
                 }

               if (patternTrue)
                 {
                  if (k<2)
                    {
                     if (vBullBear==vBull)
                       {
                        for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                          {
                           if (iLow(NULL,0,ibreak)<LevelForDmin)
                             {
                              vNamePattern = "";
                              break;
                             }
                          }
                       }
                     else
                       {
                        for (ibreak=aXABCD[D]-1;ibreak>=0;ibreak--)
                          {
                           if (iHigh(NULL,0,ibreak)>LevelForDmax)
                             {
                              vNamePattern = "";
                              break;
                             }
                          }
                       }
                    }
                  else
                    {
                     if (vBullBear==vBull)
                       {
                        for (ibreak=k;ibreak>=0;ibreak--)
                          {
                           if (iLow(NULL,0,aNumBarPeak[ibreak-2])<LevelForDmin)
                             {
                              vNamePattern = "";
                              break;
                             }
                          }
                       }
                     else
                       {
                        for (ibreak=k;ibreak>=0;ibreak--)
                          {
                           if (iHigh(NULL,0,aNumBarPeak[ibreak-2])>LevelForDmax)
                             {
                              vNamePattern = "";
                              break;
                             }
                          }
                       }
                    }
                 }
              }
           }
        }

      if ((levelD && varStrongPatterns==1 && StringLen(vNameStrongPattern)>0) || (iu>=0 && PotencialsLevels_retXD_))  // ����� ������ ����� D �� �������� retXD
        {
         if (iu>=0 && PotencialsLevels_retXD_)
           {
            nameObj="_"+ExtComplekt+"StrongPattern_" + k + "";
            ObjectDelete(nameObj);

            nameObj1="_"+ExtComplekt+"StrongPatternVL_" + k + "";
            ObjectDelete(nameObj1);
            ObjectCreate(nameObj1,OBJ_VLINE,0,Time[aXABCD[D]],zz[aXABCD[C]]);
            ObjectSet(nameObj1,OBJPROP_WIDTH,0);
            ObjectSet(nameObj1,OBJPROP_STYLE,STYLE_DOT);
            ObjectSet(nameObj1,OBJPROP_COLOR,colorLevelD);

            double pointC=0, pointD;
            int abcd=0, ii;

            if (retBD<9)
              {
               ObjectCreate(nameObj,OBJ_FIBO,0,Time[aXABCD[D]],zz[aXABCD[A]],Time[aXABCD[D]],zz[aXABCD[B]]);
               pointC=zz[aXABCD[B]];
              }
            else
              {
               ObjectCreate(nameObj,OBJ_FIBO,0,Time[aXABCD[D]],zz[aXABCD[A]],Time[aXABCD[D]],zz[aXABCD[D]]);
               pointC=zz[aXABCD[D]];
              }
            PotencialsLevels_retXD_=false;

            if (visibleLevelsABCD==0)
              {
               ObjectSet(nameObj,OBJPROP_FIBOLEVELS,iu+1);
              }
            else
              {
               ii=iu;
               if (visibleLevelsABCD==1 || visibleLevelsABCD==3)
                 {
                  for (i=0;i<19;i++)
                    {
                     if (strongABCD[i]) abcd++;
                    }
                 }

               if (visibleLevelsABCD==1)
                 {
                  ObjectSet(nameObj,OBJPROP_FIBOLEVELS,iu+1+abcd);
                 }
               else if (visibleLevelsABCD==2)
                 {
                  ObjectSet(nameObj,OBJPROP_FIBOLEVELS,iu+1+3);
                 }
               else if (visibleLevelsABCD==3)
                 {
                  ObjectSet(nameObj,OBJPROP_FIBOLEVELS,iu+1+abcd+3);
                 }

               if (visibleLevelsABCD==1 || visibleLevelsABCD==3)
                 {
                  for (i=0;i<19;i++)
                    {
                     if (strongABCD[i])
                       {
                        ii++;
                        pointD=zz[aXABCD[D]]+(zz[aXABCD[C]]-zz[aXABCD[D]])*retpatterns[i];
                        ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+ii,(pointD-pointC)/(zz[aXABCD[A]]-pointC));
                        ObjectSetFiboDescription(nameObj, ii, "BD=" +retpatternstxt[i]+"  %$");
                       }
                    }
                 }

               if (visibleLevelsABCD==2 || visibleLevelsABCD==3)
                 {
                  ii++;
                  pointD=zz[aXABCD[D]]+(zz[aXABCD[C]]-zz[aXABCD[B]]);
                  ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+ii,(pointD-pointC)/(zz[aXABCD[A]]-pointC));
                  ObjectSetFiboDescription(nameObj, ii, "AB=CD" + "  %$");
                  ii++;
                  pointD=zz[aXABCD[D]]+(zz[aXABCD[C]]-zz[aXABCD[B]])*1.272;
                  ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+ii,(pointD-pointC)/(zz[aXABCD[A]]-pointC));
                  ObjectSetFiboDescription(nameObj, ii, "1.272*AB=CD" + "  %$");
                  ii++;
                  pointD=zz[aXABCD[D]]+(zz[aXABCD[C]]-zz[aXABCD[B]])*1.618;
                  ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+ii,(pointD-pointC)/(zz[aXABCD[A]]-pointC));
                  ObjectSetFiboDescription(nameObj, ii, "1.618*AB=CD" + "  %$");
                 }
              }
           }
         else
           {
            nameObj="_"+ExtComplekt+"StrongPattern_" + countGartley + "";
            ObjectDelete(nameObj);
            if (retAC<9)
              {
               ObjectCreate(nameObj,OBJ_FIBO,0,Time[aXABCD[D]],zz[aXABCD[X]],Time[aXABCD[D]],zz[aXABCD[A]]);
              }
            else  
              {
               ObjectCreate(nameObj,OBJ_FIBO,0,Time[aXABCD[D]],zz[aXABCD[X]],Time[aXABCD[D]],zz[aXABCD[C]]);
              }
            ObjectSet(nameObj,OBJPROP_FIBOLEVELS,iu+1);
           }

         ObjectSet(nameObj,OBJPROP_LEVELCOLOR,colorLevelD);
         ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
         ObjectSet(nameObj,OBJPROP_LEVELWIDTH,0);
         ObjectSet(nameObj,OBJPROP_LEVELSTYLE,2);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
         ObjectSet(nameObj,OBJPROP_RAY,false);

         for (i=0;i<iu+1;i++)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,retpatterns[levelXD[i,1]]);
            ObjectSetFiboDescription(nameObj, i, namepatterns[levelXD[i,0]]+"  %$");
           }
         ArrayInitialize(levelXD,0);
        }

      if (StringLen(vNamePattern)>0 &&  (aXABCD[D] < bartoD+2 || patternInfluence==2) || (iu>=0 && PotencialsLevels_retXD_))
        {
         if (LevelForDmin>LevelForDmax)
           {
            LevelForD=LevelForDmin;
            LevelForDmin=LevelForDmax;
            LevelForDmax=LevelForD;
           }

         if (ExtGartleyTypeSearch>0 && ExtIndicator==11)
           {
            for (m=0;m<=countGartley;m++) // �������� �� ��������� ������ ��������
              {
               if (vNamePattern==v4Point || StringFind(vNamePattern,"AB=CD",0)>-1)
                 {
                  if (PeakCenaX[m]==0 && PeakCenaA[m]==zz[aXABCD[A]] && PeakCenaB[m]==zz[aXABCD[B]] && PeakCenaC[m]==zz[aXABCD[C]] && PeakCenaD[m]==zz[aXABCD[D]])
                    {
                     if (PeakTimeX[m]==0 && PeakTimeA[m]==Time[aXABCD[A]] && PeakTimeB[m]==Time[aXABCD[B]] && PeakTimeC[m]==Time[aXABCD[C]] && PeakTimeD[m]==Time[aXABCD[D]]) {k++; break;}
                    }
                 }
               else
                 {
                  if (PeakCenaX[m]==zz[aXABCD[X]] && PeakCenaA[m]==zz[aXABCD[A]] && PeakCenaB[m]==zz[aXABCD[B]] && PeakCenaC[m]==zz[aXABCD[C]] && PeakCenaD[m]==zz[aXABCD[D]])
                    {
                     if (PeakTimeX[m]==Time[aXABCD[X]] && PeakTimeA[m]==Time[aXABCD[A]] && PeakTimeB[m]==Time[aXABCD[B]] && PeakTimeC[m]==Time[aXABCD[C]] && PeakTimeD[m]==Time[aXABCD[D]]) {k++; break;}
                    }
                 }
              }

            if (m<=countGartley)
              {
               continue;
              }

            if (ArraySize(PeakCenaX)<countGartley+1)
              {
               ArrayResize(PeakCenaX,countGartley+1);
               ArrayResize(PeakCenaA,countGartley+1);
               ArrayResize(PeakCenaB,countGartley+1);
               ArrayResize(PeakCenaC,countGartley+1);
               ArrayResize(PeakCenaD,countGartley+1);
               
               ArrayResize(PeakTimeX,countGartley+1);
               ArrayResize(PeakTimeA,countGartley+1);
               ArrayResize(PeakTimeB,countGartley+1);
               ArrayResize(PeakTimeC,countGartley+1);
               ArrayResize(PeakTimeD,countGartley+1);
              }

            // ������ ��������� ������ �������� � �������
            if (vNamePattern==v4Point || StringFind(vNamePattern,"AB=CD",0)>-1)
              {
               PeakCenaX[countGartley]=0;
               PeakTimeX[countGartley]=0;
              }
            else
              {
               PeakCenaX[countGartley]=zz[aXABCD[X]];
               PeakTimeX[countGartley]=Time[aXABCD[X]];
              }

            PeakCenaA[countGartley]=zz[aXABCD[A]];
            PeakCenaB[countGartley]=zz[aXABCD[B]];
            PeakCenaC[countGartley]=zz[aXABCD[C]];
            PeakCenaD[countGartley]=zz[aXABCD[D]];

            PeakTimeA[countGartley]=Time[aXABCD[A]];
            PeakTimeB[countGartley]=Time[aXABCD[B]];
            PeakTimeC[countGartley]=Time[aXABCD[C]];
            PeakTimeD[countGartley]=Time[aXABCD[D]];

            if (NumberPattern-1==countGartley)
              {
               saveParametersZZ=true;

               LevelForDminToNumberPattern=LevelForDmin;
               LevelForDmaxToNumberPattern=LevelForDmax;

               vBullBearToNumberPattern = vBullBear;
               vNamePatternToNumberPattern = vNamePattern;
               vNameStrongToNumberPattern = vNameStrongPattern;
              }

            if (countColor==ColorSize) countColor=0;  // "������������" ������� ������
            colorPattern=ColorList[countColor];
            countColor++;
            countGartley++;
           }
         else
           {
            colorPattern=ExtColorPatterns;

            LevelForDminToNumberPattern=LevelForDmin;
            LevelForDmaxToNumberPattern=LevelForDmax;

            vBullBearToNumberPattern = vBullBear;
            vNamePatternToNumberPattern = vNamePattern;
            vNameStrongToNumberPattern = vNameStrongPattern;
           }

         if (Equilibrium && ExtGartleyTypeSearch==0 && vNamePattern!=v50 && StringFind(vNamePattern,"AB=CD",0)==-1 && vNamePattern!=v4Point)
           {
            double tangens, h_ea=0, h_ec=0, delta;

            tangens=(zz[aXABCD[B]]-zz[aXABCD[X]])/(aXABCD[X]-aXABCD[B]);
            if (ReactionType)
              {
               h_ea=zz[aXABCD[A]]-(zz[aXABCD[X]]+(aXABCD[X]-aXABCD[A])*tangens);
               h_ec=zz[aXABCD[C]]-(zz[aXABCD[B]]+(aXABCD[B]-aXABCD[C])*tangens);
              }
            else
              {
               if (zz[aXABCD[X]]>zz[aXABCD[A]])
                 {
                  for (i=aXABCD[X]-1;i>=aXABCD[A];i--)
                    {
                     delta=Low[i]-(zz[aXABCD[X]]+(aXABCD[X]-i)*tangens);
                     if (delta<h_ea) h_ea=delta;
                    }

                  for (i=aXABCD[B]-1;i>=aXABCD[C];i--)
                    {
                     delta=Low[i]-(zz[aXABCD[B]]+(aXABCD[B]-i)*tangens);
                     if (delta<h_ec) h_ec=delta;
                    }
                 }
               else
                 {
                  for (i=aXABCD[X]-1;i>=aXABCD[A];i--)
                    {
                     delta=High[i]-(zz[aXABCD[X]]+(aXABCD[X]-i)*tangens);
                     if (delta>h_ea) h_ea=delta;
                    }

                  for (i=aXABCD[B]-1;i>=aXABCD[C];i--)
                    {
                     delta=High[i]-(zz[aXABCD[B]]+(aXABCD[B]-i)*tangens);
                     if (delta>h_ec) h_ec=delta;
                    }
                 }
              }

            nameObj="_"+ExtComplekt+"Equilibrium_" + countGartley;
            ObjectDelete(nameObj);
            ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[X]],zz[aXABCD[X]],Time[aXABCD[B]],zz[aXABCD[B]]);
            ObjectSet(nameObj,OBJPROP_COLOR,ColorEquilibrium);
            ObjectSet(nameObj,OBJPROP_STYLE,EquilibriumStyle);
            ObjectSet(nameObj,OBJPROP_WIDTH,EquilibriumWidth);
            nameObj="_"+ExtComplekt+"Reaction1_" + countGartley;
            ObjectDelete(nameObj);
            ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],zz[aXABCD[B]]+tangens*(aXABCD[B]-aXABCD[C])-h_ec,Time[0],zz[aXABCD[B]]+tangens*aXABCD[B]-h_ec);
            ObjectSet(nameObj,OBJPROP_COLOR,ColorReaction);
            ObjectSet(nameObj,OBJPROP_STYLE,EquilibriumStyle);
            ObjectSet(nameObj,OBJPROP_WIDTH,EquilibriumWidth);
            nameObj="_"+ExtComplekt+"Reaction2_" + countGartley;
            ObjectDelete(nameObj);
            ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],zz[aXABCD[B]]+tangens*(aXABCD[B]-aXABCD[C])-h_ea,Time[0],zz[aXABCD[B]]+tangens*aXABCD[B]-h_ea);
            ObjectSet(nameObj,OBJPROP_COLOR,ColorReaction);
            ObjectSet(nameObj,OBJPROP_STYLE,EquilibriumStyle);
            ObjectSet(nameObj,OBJPROP_WIDTH,EquilibriumWidth);
           }

         vPatOnOff = true;

         //---------------------------------------------
         if(f==1 && ExtIndicator!=11)
           {
            f=0;
            if(ExtPlayAlert) 
              {
               Alert (Symbol(),"  ",Period(),"  appeared new pattern");
               PlaySound("alert.wav");
              }
            if (ExtSendMail){
               // _SendMail("There was a pattern","on  " + Symbol() + " " + Period() + " pattern " + vBullBear + " " + vNamePattern + " " + vNameStrongPattern);
               //GlobalVariableSet(StringConcatenate("PatternID_135",Symbol(),Period()),getPattern(vNamePattern));
               }
           }
         //---------------------------------------------

         if (StringLen(vBullBear)>0)
           {
            if (visibleABCDrayZZ && StringFind(vNamePattern,"AB=CD",0)>-1)
              {
               nameObj="_"+ExtComplekt+"ABCDzz1_" + countGartley + "_" + _Depth + "_" + aXABCD[D] + "_" +vBullBear + " " + vNamePattern;
               ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[A]],zz[aXABCD[A]],Time[aXABCD[B]],zz[aXABCD[B]]);
               ObjectSet(nameObj,OBJPROP_COLOR,colorPattern);
               ObjectSet(nameObj,OBJPROP_STYLE,ABCDrayZZStyle);
               ObjectSet(nameObj,OBJPROP_WIDTH,ABCDrayZZWidth);
               ObjectSet(nameObj, OBJPROP_RAY, false); 
               nameObj="_"+ExtComplekt+"ABCDzz2_" + countGartley + "_" + _Depth + "_" + aXABCD[D] + "_" +vBullBear + " " + vNamePattern;
               ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[B]],zz[aXABCD[B]],Time[aXABCD[C]],zz[aXABCD[C]]);
               ObjectSet(nameObj,OBJPROP_COLOR,colorPattern);
               ObjectSet(nameObj,OBJPROP_STYLE,ABCDrayZZStyle);
               ObjectSet(nameObj, OBJPROP_RAY, false); 
               ObjectSet(nameObj,OBJPROP_WIDTH,ABCDrayZZWidth);
               nameObj="_"+ExtComplekt+"ABCDzz3_" + countGartley + "_" + _Depth + "_" + aXABCD[D] + "_" +vBullBear + " " + vNamePattern;
               ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],zz[aXABCD[C]],Time[aXABCD[D]],zz[aXABCD[D]]);
               ObjectSet(nameObj,OBJPROP_COLOR,colorPattern);
               ObjectSet(nameObj,OBJPROP_STYLE,ABCDrayZZStyle);
               ObjectSet(nameObj,OBJPROP_WIDTH,ABCDrayZZWidth);
               ObjectSet(nameObj, OBJPROP_RAY, false); 
              }
            else
              {
               nameObj1="_"+ExtComplekt+"Triangle1_" + countGartley + "_" + _Depth + "_" + aXABCD[D] + "_" +vBullBear + " " + vNamePattern; //* + " " + vNameStrongPattern;
               nameObj2="_"+ExtComplekt+"Triangle2_" + countGartley + "_" + _Depth + "_" + aXABCD[D] + "_" +vBullBear + " " + vNamePattern; // + " " + vNameStrongPattern;

               if (vNamePattern == v4Point || StringFind(vNamePattern,"AB=CD",0)>-1) // || vNamePattern==v50)
                 {
                  ObjectCreate(nameObj1,OBJ_TRIANGLE,0,Time[aXABCD[A]],zz[aXABCD[A]],Time[aXABCD[B]],zz[aXABCD[B]],Time[aXABCD[C]],zz[aXABCD[C]]);
                 }
               else
                 {
                  ObjectCreate(nameObj1,OBJ_TRIANGLE,0,Time[aXABCD[X]],zz[aXABCD[X]],Time[aXABCD[A]],zz[aXABCD[A]],Time[aXABCD[B]],zz[aXABCD[B]]);
                 }
               ObjectSet(nameObj1,OBJPROP_COLOR,colorPattern);// ������ ����� �����
               if (vNamePattern==vDragon)
                 {
                  ObjectCreate(nameObj2,OBJ_TRIANGLE,0,Time[aXABCD[B]],zz[aXABCD[B]],Time[aXABCD[C]],zz[aXABCD[C]],tDragonE,cDragonE);
                 }
               else
                 {
                  ObjectCreate(nameObj2,OBJ_TRIANGLE,0,Time[aXABCD[B]],zz[aXABCD[B]],Time[aXABCD[C]],zz[aXABCD[C]],Time[aXABCD[D]],zz[aXABCD[D]]);
                 }
               ObjectSet(nameObj2,OBJPROP_COLOR,colorPattern); //������ ����� �����
              }
           }

         if (RangeForPointD>0 && LevelForDmin > 0) // ����� �������������� ��� ���� ����� D
           {
            for (j=aXABCD[C];j>=aXABCD[D];j--)
              {
               if (vBullBear == vBull)
                 {
                  if (LevelForDmax>=Low[j]) {TimeForDmax  = Time[j]; break;}
                 }
               else if (vBullBear == vBear)
                 {
                  if (LevelForDmin<=High[j]) {TimeForDmin  = Time[j]; break;}
                 }
              }

            if (vBullBear == vBull)
              {
               TimeForDmin  = TimeForDmax+((LevelForDmax-LevelForDmin)/((zz[aXABCD[C]]-zz[aXABCD[D]])/(aXABCD[C]-aXABCD[D]+1)))*Period()*60;
              }
            else if (vBullBear == vBear)
              {
               TimeForDmax  = TimeForDmin+((LevelForDmax-LevelForDmin)/((zz[aXABCD[D]]-zz[aXABCD[C]])/(aXABCD[C]-aXABCD[D]+1)))*Period()*60;
              }

            if (TimeForDmin>TimeForDmax)
              {
               timeLineD=TimeForDmin;
               TimeForDmin=TimeForDmax;
               TimeForDmax=timeLineD;
              }
            else
              {
               timeLineD=TimeForDmax;
              }

            if (VectorOfAMirrorTrend==1)
              {
               nameObj="_"+ExtComplekt+"VectorOfAMirrorTrend_1_" + countGartley + "";
              }
            else if (VectorOfAMirrorTrend==2)
              {
               nameObj="_"+ExtComplekt+"VectorOfAMirrorTrend_2_" + countGartley + "";

               if (vBullBear == vBear) ObjectCreate(nameObj,OBJ_TREND,0,TimeForDmin,LevelForDmax,TimeForDmax,LevelForDmin);
               else  ObjectCreate(nameObj,OBJ_TREND,0,TimeForDmin,LevelForDmin,TimeForDmax,LevelForDmax);
                 
               ObjectSet(nameObj, OBJPROP_BACK, false);
               ObjectSet(nameObj, OBJPROP_RAY, true); 
               ObjectSet(nameObj, OBJPROP_COLOR, LawnGreen); 
               ObjectSet(nameObj, OBJPROP_STYLE, STYLE_DASH); 
              }

            nameObj="_"+ExtComplekt+"PointD_" + countGartley + "";

            ObjectCreate(nameObj,OBJ_RECTANGLE,0,TimeForDmin,LevelForDmin,TimeForDmax,LevelForDmax);
            ObjectSet(nameObj, OBJPROP_BACK, false);
            ObjectSet(nameObj, OBJPROP_COLOR, ExtColorRangeForPointD); 
            double current=0,start=0;
            
            GlobalVariableSet(StringConcatenate("POINT_X_135",Symbol(),Period()),zz[aXABCD[X]]);
            GlobalVariableSet(StringConcatenate("POINT_A_135",Symbol(),Period()),zz[aXABCD[A]]);
            GlobalVariableSet(StringConcatenate("POINT_B_135",Symbol(),Period()),zz[aXABCD[B]]);
            GlobalVariableSet(StringConcatenate("POINT_C_135",Symbol(),Period()),zz[aXABCD[C]]);
            GlobalVariableSet(StringConcatenate("POINT_D_135",Symbol(),Period()),zz[aXABCD[D]]);
            double xaLeg,abLeg,bcLeg,cdLeg;
            xaLeg = zz[aXABCD[X]] - zz[aXABCD[A]]; xaLeg = MathAbs(xaLeg); xaLeg = NormalizeDouble(xaLeg,Digits);
            abLeg = zz[aXABCD[A]] - zz[aXABCD[B]]; abLeg = MathAbs(abLeg); abLeg = NormalizeDouble(abLeg,Digits);
            bcLeg = zz[aXABCD[B]] - zz[aXABCD[C]]; bcLeg = MathAbs(bcLeg); bcLeg = NormalizeDouble(bcLeg,Digits);
            cdLeg = zz[aXABCD[C]] - zz[aXABCD[D]]; cdLeg = MathAbs(cdLeg); cdLeg = NormalizeDouble(cdLeg,Digits);
            GlobalVariableSet(StringConcatenate("XA_LEG_135",Symbol(),Period()),xaLeg);
            GlobalVariableSet(StringConcatenate("AB_LEG_135",Symbol(),Period()),abLeg);
            GlobalVariableSet(StringConcatenate("BC_LEG_135",Symbol(),Period()),bcLeg);
            GlobalVariableSet(StringConcatenate("CD_LEG_135",Symbol(),Period()),cdLeg);
            
            int barsCDLeg,barsPattern,barsABLeg;
            barsABLeg = (iBarShift(NULL,0,Time[aXABCD[B]],false)-iBarShift(NULL,0,Time[aXABCD[A]],false)); barsABLeg = MathAbs(barsABLeg);
            barsCDLeg = (iBarShift(NULL,0,Time[aXABCD[D]],false)-iBarShift(NULL,0,Time[aXABCD[C]],false)); barsCDLeg = MathAbs(barsCDLeg);
            barsPattern = (iBarShift(NULL,0,Time[aXABCD[D]],false)-iBarShift(NULL,0,Time[aXABCD[X]],false)); barsPattern = MathAbs(barsPattern);
            GlobalVariableSet(StringConcatenate("BarsAB_135",Symbol(),Period()),barsABLeg);
            GlobalVariableSet(StringConcatenate("BarsCD_135",Symbol(),Period()),barsCDLeg);
            GlobalVariableSet(StringConcatenate("BarsPattern_135",Symbol(),Period()),barsPattern);
            
            string dmintime,dmtest1,dmtest2,dmtest2sec,dmintest2sec,dmaxtime;
            int dminTime, dmaxTime, dminTime2,dmaxTime2;
            
            dmintime = TimeToStr(TimeForDmin,TIME_DATE|TIME_MINUTES); dmtest1 = StringConcatenate("",StringSubstr(dmintime,0,4),StringSubstr(dmintime,5,2),StringSubstr(dmintime,8,2));
            dmintest2sec = StringConcatenate("",StringSubstr(dmintime,11,2),StringSubstr(dmintime,14,2));
            dminTime = StrToInteger(dmtest1); dminTime2 = StrToInteger(dmintest2sec);
            dmaxtime = TimeToStr(TimeForDmax,TIME_DATE|TIME_MINUTES); dmtest2 = StringConcatenate("",StringSubstr(dmaxtime,0,4),StringSubstr(dmaxtime,5,2),StringSubstr(dmaxtime,8,2));
            dmtest2sec = StringConcatenate("",StringSubstr(dmaxtime,11,2),StringSubstr(dmaxtime,14,2));
            dmaxTime = StrToInteger(dmtest2); dmaxTime2 = StrToInteger(dmtest2sec);
            
           // Print("ZUP_135, ",periodToString(Period())," TFDMax: ",TimeToStr(TimeForDmax,TIME_DATE|TIME_MINUTES)," TFDMin: ",TimeToStr(TimeForDmin,TIME_DATE|TIME_MINUTES));
            
            GlobalVariableSet(StringConcatenate("PRZ_BEGIN_1351",Symbol(),Period()),dminTime);
            GlobalVariableSet(StringConcatenate("PRZ_BEGIN_1352",Symbol(),Period()),dminTime2);
            GlobalVariableSet(StringConcatenate("PRZ_END_1351",Symbol(),Period()),dmaxTime);
            GlobalVariableSet(StringConcatenate("PRZ_END_1352",Symbol(),Period()),dmaxTime2);
            GlobalVariableSet(StringConcatenate("PRZ_LOW_135",Symbol(),Period()),NormalizeDouble(LevelForDmin,Digits)); // my code
            GlobalVariableSet(StringConcatenate("PRZ_HIGH_135",Symbol(),Period()),NormalizeDouble(LevelForDmax,Digits)); // my code
            setZZ();

            if (RangeForPointD==2)
              {
               if (LevelForDmax>=LevelDA1272 && LevelDA1272>=LevelForDmin)
                 {
                  //toVectorLevel(////toVector_135,LevelDA1272);
                  nameObj="_"+ExtComplekt+"PDLA1272_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDA1272,timeLineD,LevelDA1272);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_AB); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDA1618 && LevelDA1618>=LevelForDmin)
                 {
                 //toVectorLevel(PDLA1618_135,LevelDA1618);
                  nameObj="_"+ExtComplekt+"PDLA1618_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDA1618,timeLineD,LevelDA1618);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_AB); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDA2 && LevelDA2>=LevelForDmin)
                 {
                  //toVectorLevel(PDLA2_135,LevelDA2);
                  nameObj="_"+ExtComplekt+"PDLA2_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDA2,timeLineD,LevelDA2);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_AB); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDA2618 && LevelDA2618>=LevelForDmin)
                 {
                  //toVectorLevel(PDLA2618_135,LevelDA2618);
                  nameObj="_"+ExtComplekt+"PDLA2618_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDA2618,timeLineD,LevelDA2618);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_AB); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }
               if (LevelForDmax>=LevelDA3618 && LevelDA3618>=LevelForDmin)
                 {
                  //toVectorLevel(PDLA3618_135,LevelDA3618);
                  nameObj="_"+ExtComplekt+"PDLA3618_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDA3618,timeLineD,LevelDA3618);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_AB); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDA4236 && LevelDA4236>=LevelForDmin)
                 {
                  //toVectorLevel(PDLA4236_135,LevelDA4236);
                  nameObj="_"+ExtComplekt+"PDLA4618_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDA4236,timeLineD,LevelDA4236);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_AB); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDC786 && LevelDC786>=LevelForDmin)
                 {
                  //toVectorLevel(PDLC786_135,LevelDC786);
                  nameObj="_"+ExtComplekt+"PDLC786_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDC786,timeLineD,LevelDC786);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_BC); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDC886 && LevelDC886>=LevelForDmin)
                 {   
                  //toVectorLevel(PDLC886_135,LevelDC886);
                  nameObj="_"+ExtComplekt+"PDLC886_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDC886,timeLineD,LevelDC886);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_BC); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDC1272 && LevelDC1272>=LevelForDmin)
                 {
                  //toVectorLevel(PDLC1272_135,LevelDC1272);
                  nameObj="_"+ExtComplekt+"PDLC1272_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDC1272,timeLineD,LevelDC1272);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_BC); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDC1618 && LevelDC1618>=LevelForDmin)
                 {
                  //toVectorLevel(PDLC1618_135,LevelDC1618);
                  nameObj="_"+ExtComplekt+"PDLC1618_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDC1618,timeLineD,LevelDC1618);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_BC); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDC2 && LevelDC2>=LevelForDmin)
                 {
                  //toVectorLevel(PDLC2_135,LevelDC2);
                  nameObj="_"+ExtComplekt+"PDLC2_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDC2,timeLineD,LevelDC2);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_BC); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDC2618 && LevelDC2618>=LevelForDmin)
                 {
                  //toVectorLevel(PDLC2618_135,LevelDC2618);
                  nameObj="_"+ExtComplekt+"PDLC2618_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDC2618,timeLineD,LevelDC2618);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_BC); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDC3618 && LevelDC3618>=LevelForDmin)
                 {
                  //toVectorLevel(PDLC3618_135,LevelDC3618);
                  nameObj="_"+ExtComplekt+"PDLC3618_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDC3618,timeLineD,LevelDC3618);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_BC); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }

               if (LevelForDmax>=LevelDC4236 && LevelDC4236>=LevelForDmin)
                 {
                  //toVectorLevel(PDLC4236_135,LevelDC4236);
                  nameObj="_"+ExtComplekt+"PDLC4236_" + countGartley + "";
                  ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[C]],LevelDC4236,timeLineD,LevelDC4236);
                  ObjectSet(nameObj, OBJPROP_COLOR, ExtLineForPointD_BC); 
                  ObjectSet(nameObj, OBJPROP_RAY, false); 
                 }
                  setPRZLevels(LevelForDmin,LevelForDmax,zz[aXABCD[C]],zz[aXABCD[D]]);
              }

            if (ExtIndicator==11 && ExtHiddenPP==2)
              {
               k1=MathCeil((aXABCD[X]+aXABCD[B])/2);
               nameObj="_" + ExtComplekt + "pgtxt" + Time[aXABCD[B]] + "_" + Time[aXABCD[X]];
               ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(zz[aXABCD[B]]+zz[aXABCD[X]])/2);
               ObjectSetText(nameObj,DoubleToStr(retXB,3),ExtSizeTxt,"Arial", ExtNotFibo);
               nameObj="_" + ExtComplekt + "pg" + Time[aXABCD[B]] + "_" + Time[aXABCD[X]];
               ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[X]],zz[aXABCD[X]],Time[aXABCD[B]],zz[aXABCD[B]]);
               ObjectSet(nameObj,OBJPROP_RAY,false);
               ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DOT);
               ObjectSet(nameObj,OBJPROP_COLOR,ExtLine);
               ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
                
               k1=MathCeil((aXABCD[X]+aXABCD[D])/2);
               nameObj="_" + ExtComplekt + "pgtxt" + Time[aXABCD[D]] + "_" + Time[aXABCD[X]];
               ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(zz[aXABCD[D]]+zz[aXABCD[X]])/2);
               ObjectSetText(nameObj,DoubleToStr(retXD,3),ExtSizeTxt,"Arial", ExtNotFibo);
               nameObj="_" + ExtComplekt + "pg" + Time[aXABCD[D]] + "_" + Time[aXABCD[X]];
               ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[X]],zz[aXABCD[X]],Time[aXABCD[D]],zz[aXABCD[D]]);
               ObjectSet(nameObj,OBJPROP_RAY,false);
               ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DOT);
               ObjectSet(nameObj,OBJPROP_COLOR,ExtLine);
               ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
                
               k1=MathCeil((aXABCD[B]+aXABCD[D])/2);
               nameObj="_" + ExtComplekt + "pgtxt" + Time[aXABCD[D]] + "_" + Time[aXABCD[B]];
               ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(zz[aXABCD[D]]+zz[aXABCD[B]])/2);
               ObjectSetText(nameObj,DoubleToStr(retBD,3),ExtSizeTxt,"Arial", ExtNotFibo);
               nameObj="_" + ExtComplekt + "pg" + Time[aXABCD[D]] + "_" + Time[aXABCD[B]];
               ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[B]],zz[aXABCD[B]],Time[aXABCD[D]],zz[aXABCD[D]]);
               ObjectSet(nameObj,OBJPROP_RAY,false);
               ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DOT);
               ObjectSet(nameObj,OBJPROP_COLOR,ExtLine);
               ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
                  
               k1=MathCeil((aXABCD[A]+aXABCD[C])/2);
               nameObj="_" + ExtComplekt + "pgtxt" + Time[aXABCD[C]] + "_" + Time[aXABCD[A]];
               ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(zz[aXABCD[C]]+zz[aXABCD[A]])/2);
               ObjectSetText(nameObj,DoubleToStr(retAC,3),ExtSizeTxt,"Arial", ExtNotFibo);
               nameObj="_" + ExtComplekt + "pg" + Time[aXABCD[C]] + "_" + Time[aXABCD[A]];
               ObjectCreate(nameObj,OBJ_TREND,0,Time[aXABCD[A]],zz[aXABCD[A]],Time[aXABCD[C]],zz[aXABCD[C]]);
               ObjectSet(nameObj,OBJPROP_RAY,false);
               ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DOT);
               ObjectSet(nameObj,OBJPROP_COLOR,ExtLine);
               ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
              }
           }

         return(0);
        }
      else 
        {
         vBullBear    = "";
         vNamePattern = "";
        }
      k++;

      if (patternInfluence==1)
        {
         if (!(ExtIndicator>5 && ExtIndicator<11 && GrossPeriod>Period()))
           {
            bartoD=AllowedBandPatternInfluence*(aNumBarPeak[k+4]-aNumBarPeak[k]);
           }
        }
     }
  }
//--------------------------------------------------------
// ����� ��������� Gartley. �����.
//--------------------------------------------------------

//----------------------------------------------------
// nen-ZigZag. ����� DT. ������.
//----------------------------------------------------
void nenZigZag()
 {
  if (cbi>0)
    {
//     datetime nen_time=iTime(NULL,GrossPeriod,ExtMinBar);
     datetime nen_time=iTime(NULL,GrossPeriod,0);
     int i=0, j=0; // j - ����� ���� � ������������ ���������� (����������� ���������) � ������� nen-ZigZag
     double nen_dt=0, last_j=0, last_nen=0; //last_j - �������� ������������� ��������� (������������ ��������) � ������� nen_ZigZag
     int limit, big_limit, bigshift=0;

     int i_metka=-1, i_metka_m=-1, k, m, jm;
     bool fl_metka=false;
     double last_jm=0, last_nen_m=0;

     if (ExtMaxBar>0) _maxbarZZ=ExtMaxBar; else _maxbarZZ=Bars;

     if (init_zz)
       {
        limit=_maxbarZZ-1;
        big_limit=iBars(NULL,GrossPeriod)-1;
       }
     else
       {
        limit=iBarShift(NULL,0,afr[2]);
        big_limit=iBarShift(NULL,GrossPeriod,afr[2]);
       }

     while (bigshift<big_limit && i<limit) // ��������� ���������� ������ nen-ZigZag ("�������")
       {
        if (Time[i]>=nen_time)
          {
           if (ExtIndicator==6)
             {
              if (ExtLabel>0)
                {
                 ha[i]=iCustom(NULL,GrossPeriod,"ZigZag_nen1",minBars,ExtBackstep,noBackstep,1,1,bigshift);
                 la[i]=iCustom(NULL,GrossPeriod,"ZigZag_nen1",minBars,ExtBackstep,noBackstep,1,2,bigshift);
                }
              nen_ZigZag[i]=iCustom(NULL,GrossPeriod,"ZigZag_nen1",minBars,ExtBackstep,noBackstep,0,0,bigshift);
             }
           else  if (ExtIndicator==7)
             {
              if (ExtLabel>0)
                {
                 ha[i]=iCustom(NULL,GrossPeriod,"DT_ZZ_nen",minBars,1,1,bigshift);
                 la[i]=iCustom(NULL,GrossPeriod,"DT_ZZ_nen",minBars,1,2,bigshift);
                }
              nen_ZigZag[i]=iCustom(NULL,GrossPeriod,"DT_ZZ_nen",minBars,0,0,bigshift);
             }
           else  if (ExtIndicator==8) nen_ZigZag[i]=iCustom(NULL,GrossPeriod,"CZigZag",minBars,ExtDeviation,0,bigshift);
           else  if (ExtIndicator==10)
             {
              if (ExtLabel>0)
                {
                 ha[i]=iCustom(NULL,GrossPeriod,"Swing_ZZ_1",minBars,1,1,bigshift);
                 la[i]=iCustom(NULL,GrossPeriod,"Swing_ZZ_1",minBars,1,2,bigshift);
                }
              nen_ZigZag[i]=iCustom(NULL,GrossPeriod,"Swing_ZZ_1",minBars,1,0,bigshift);
             }
           i++;
          }
        else {bigshift++;nen_time=iTime(NULL,GrossPeriod,bigshift);}
       }

     if (init_zz) // ��������� �������
       {
        double i1=0, i2=0;
        init_zz=false;

        for (i=limit;i>ExtMinBar;i--) // ����������� ����������� ������� ����
          {
           if (nen_ZigZag[i]>0)
             {
              if (i1==0) i1=nen_ZigZag[i];
              else if (i1>0 && i1!=nen_ZigZag[i]) i2=nen_ZigZag[i];
              if (i2>0) 
                {
                 if (i1>i2) hi_nen=true;
                 else hi_nen=false;
                 break;
                }
             }
          }
       }
     else // ����� ��������� �������
       {
        if (afrl[2]>0) hi_nen=false; else hi_nen=true;
       }

     for (i=limit;i>=0;i--)
       {
//        if (i<limit) 
        {zz[i]=0; zzH[i]=0; zzL[i]=0;}

        if (nen_ZigZag[i]>0)
          {
           if (ExtLabel==2)
             {
              if (i_metka_m>=0 && !fl_metka)
                {
                 m=i_metka_m-GrossPeriod/Period();

                 for (k=i_metka_m; k>m; k--)
                   {
                    ha[k]=0; la[k]=0;
                   }

                 if (hi_nen) ha[jm]=last_nen_m;
                 else la[jm]=last_nen_m;
                 jm=0; last_nen_m=0; last_jm=0; i_metka_m=-1;
                }

              if (i_metka<0) i_metka=i;
             }

           fl_metka=true;

           if (nen_dt>0 && nen_dt!=nen_ZigZag[i])
             {
              if (i_metka>=0 && fl_metka)
                {
                 m=i_metka-GrossPeriod/Period();
                 for (k=i_metka; k>m; k--)
                   {
                    ha[k]=0; la[k]=0;
                   }
                 if (hi_nen) ha[j]=last_nen;
                 else la[j]=last_nen;
                 i_metka=i;
                }

              if (hi_nen) {hi_nen=false;zzH[j]=last_nen;}
              else {hi_nen=true;zzL[j]=last_nen;}
              last_j=0;nen_dt=0;zz[j]=last_nen;
             }

           if (hi_nen)
             {
              nen_dt=nen_ZigZag[i];
              if (last_j<High[i]) {j=i;last_j=High[i];last_nen=nen_ZigZag[i];}
             }
           else
             {
              nen_dt=nen_ZigZag[i];
              if (last_j==0) {j=i;last_j=Low[i];last_nen=nen_ZigZag[i];}
              if (last_j>Low[i]) {j=i;last_j=Low[i];last_nen=nen_ZigZag[i];}
             }

           if (nen_dt>0 && i==0)  // ����������� �������� �� ������� ���� GrossPeriod
             {
              if (i_metka>=0 && fl_metka)
                {
                 m=i_metka-GrossPeriod/Period();
                 for (k=i_metka; k>m; k--)
                   {
                    ha[k]=0; la[k]=0;
                   }
                 if (hi_nen) ha[j]=last_nen;
                 else la[j]=last_nen;
                 fl_metka=false;
                }

              zz[j]=last_nen;
              if (hi_nen) zzH[j]=last_nen; else zzL[j]=last_nen;
             }
          }
        else
          {
           if (last_j>0 && fl_metka)
             {
              if (i_metka>=0 && fl_metka)
                {
                 m=i_metka-GrossPeriod/Period();

                 for (k=i_metka; k>m; k--)
                   {
                    ha[k]=0; la[k]=0;
                   }
                 if (hi_nen) ha[j]=last_nen;
                 else la[j]=last_nen;
                }

              fl_metka=false;

              if (hi_nen) {hi_nen=false;zzH[j]=last_nen;}
              else {hi_nen=true;zzL[j]=last_nen;}
              last_j=0;nen_dt=0;zz[j]=last_nen;
              i_metka=-1;
             }

           if (ExtLabel==2)
             {
              if ((ha[i]>0 || la[i]>0) && !fl_metka)
                {

                 if (i_metka_m<0)
                   { 
                    i_metka_m=i; jm=i;
                    if (hi_nen)
                      {
                       last_jm=High[i];last_nen_m=ha[i];
                      }
                    else
                      {
                       last_jm=Low[i];last_nen_m=la[i];
                      }
                   }

                 if (hi_nen)
                   {
                    if (last_nen_m>last_jm) {jm=i;last_jm=High[i];}
                   }
                 else
                   {
                    if (last_nen_m<last_jm) {jm=i;last_jm=Low[i];}
                   }
                }

             }
          }
       }
    }
 }
//--------------------------------------------------------
// nen-ZigZag. ����� DT. �����. 
//--------------------------------------------------------

//������������������������������������������������������������������������������������������������������������������������������
//  SQZZ by tovaroved.lv.  ������.  ��������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������
double div(double a, double b){if(MathAbs(b)*10000>MathAbs(a)) return(a*1.0/b); else return(0);}
//=============================================================================================
double ray_value(double B1, double P1, double B2, double P2, double AAA){return(P1+( AAA -B1)*div(P2-P1,B2-B1));}
//=============================================================================================
datetime bar2time(int b){int t,TFsec=Period()*60; if(b<0) t=Time[0]-(b)*TFsec; else if(b>(Bars-1)) t=Time[Bars-1]-(b-Bars+1)*TFsec; else t=Time[b];  return(t);}
//=============================================================================================
int time2bar(datetime t){int b,t0=Time[0],TFsec=Period()*60; if(t>t0) b=(t0-t)/TFsec; else if(t<Time[Bars-2]) b=(Bars-2)+(Time[Bars-2]-t)/TFsec; else b=iBarShift(0,0,t); return(b);}
//=============================================================================================
void ZigZag_SQZZ(bool zzFill=true)
  {
   static int act_time=0,	H1=10000,L1=10000,H2=10000,H3=10000,H4=10000,L2=10000,L3=10000,L4=10000;	
	static double H1p=-1,H2p=-1,H3p=-1, H4p=-1,	L1p=10000,L2p=10000,L3p=10000,L4p=10000;
	int   mnm=1,tb,sH,sL,sX, i, a, barz, b,c, ii, H,L;	double val,x,Lp,Hp,k=0.;   if(Bars<100) return; if(1==2)bar2time(0);
	barz=Bars-4;int bb=barz;
	if(minBars==0)minBars=minSize;	if(minSize==0)minSize=minBars*3; tb=MathSqrt(minSize*minBars);
	mnm=tb;
	a=time2bar(act_time);	b=barz;
	if(a>=0 && a<tb)
	  {
		ii=a;		a--;		L1+=a;		H1+=a;
		L2+=a;	H2+=a;	L3+=a;		H3+=a;
		if(!zzFill)
		  {
			for(i=barz; i>=a; i--) {zzH[i]=zzH[i-a];	zzL[i]=zzL[i-a];}
			for(;i>=0;i--) {zzH[i]=0;	zzL[i]=0;}
	     }
	  }
	else
	  {
		ii=barz;
		H1=ii+1; L1=ii;
		H2=ii+3; L2=ii+2;
		L2p=Low[L2];H2p=High[H2];	
		L1p=Low[L1];H1p=High[H1];
		H3=H2;	H3p=H2p;
		L3=L2;	L3p=L2p;
     }
	act_time=Time[1];

	for(c=0; ii>=0; c++, ii--)
	  {
		H=ii; L=ii;		Hp=	High[H];	Lp=	Low[L];
		//-------------------------------------------------------------------------------------
		if(H2<L2)
		  {// ��� ��� ���� �������
			if( Hp>=H1p )
			  {
			   H1=H;	H1p=Hp;
				if( H1p>H2p )
				  {
					zzH[H2]=0;
					H1=H;	H1p=Hp;
					H2=H1;	H2p=H1p;
					L1=H1;	L1p=H1p;
					zzH[H2]=H2p;
				  }
			  }
			else if( Lp<=L1p )
			  {
			   L1=L;	L1p=Lp;
				x=ray_value(L2,L2p,H2+(L2-H3)*0.5,H2p+(L2p-H3p)*0.5,L1);
				if( L1p<=L2p//����� �������� L1p<=L2p*0.75+H2p*0.25 ��� ����� ������ �������
				    || tb*tb*Point<(H2p-L1p)*(H2-L1))
				  { //�������� ��� Low
					L4=L3;	L4p=L3p;
					L3=L2;	L3p=L2p;
					L2=L1;	L2p=L1p;
					H1=L1;	H1p=L1p;
					zzL[L2]=L2p;
				  }
			  }
	     }
		//--------------------------------------------------------------
		if(L2<H2) {// ��� ��� ���� �������
			if( Lp<=L1p )
			  {L1=L;	L1p=Lp;
				if( L1p<=L2p )
				  {
					zzL[L2]=0;
					L1=L;	L1p=Lp;
					L2=L1;	L2p=L1p;
					H1=L1;	H1p=L1p;
					zzL[L2]=L2p;
				  }
			  }
			else if( Hp>=H1p )
			  {
			   H1=H;	H1p=Hp;
				x=ray_value(H2,H2p,L2+0.5*(H2-L3),L2p+0.5*(H2p-L3p),H1);
				if( H1p>=H2p//����� � ���: H1p>=H2p*0.75+L2p*0.25
				    || tb*tb*Point<(H1p-L2p)*(L2-H1))
				  { //�������� ��� High
					H4=H3;	H4p=H3p;
					H3=H2;	H3p=H2p;
					H2=H1;	H2p=H1p;
					L1=H1;	L1p=H1p;
					zzH[H2]=H2p;
				  }
			   }

    		}//--------------------------------------------------------------------------------
	  }//for
	for(ii=bb-1; ii>=0; ii--) zz[ii]=MathMax(zzL[ii],zzH[ii]);
  }
//=======================================================================
// SQZZ by tovaroved.lv. �����. 
//=======================================================================

//--------------------------------------------------------
// ZZ_2L_nen . ������.
//#property copyright "Copyright � 2007, wellx. ver 0.07 alpha"
//#property link      "aveliks@gmail.com"
//--------------------------------------------------------
void ZZ_2L_nen()
  {
   int count = IndicatorCounted();
   int    k, i,shift,cnt, pos,curhighpos,curlowpos;

   if (Bars-count-1>2) 
     {
      count=0; NewBarTime=0; countbars=0; realcnt=0;
      ArrayInitialize(zz,0); ArrayInitialize(zzL,0); ArrayInitialize(zzH,0);
     }
   
   for (k=(Bars-count-1);k>=0;k--)
     {
   
      if(( NewBarTime==Time[0]) || (realcnt==Bars))
           first=false; 
      else first=true;
     
   
      //--------------------------------------------------------------------  
      //������� ������ ����� ����������
      //--------------------------------------------------------------------
      if (first)    
       {
         lastlowpos=Bars-1;
         lasthighpos=Bars-1;
         zzL[Bars-1]=0.0;
         zzH[Bars-1]=0.0;
         zz[Bars-1]=0.0;
         realcnt=2;
      
         for(shift=(Bars-2); shift>=0; shift--)
          {
            if ((High[shift]>High[shift+1]) && (Low[shift]>=Low[shift+1])) 
               {
                  zzL[shift]=0.0;
                  zzH[shift]=High[shift];
                  zz[shift]=High[shift];
                  lasthighpos=shift;
                  lasthigh=High[shift];
                  lastlow=Low[Bars-1];
                  pos=shift;
                  first=false;
                  break;          
               }
            if ((High[shift]<=High[shift+1]) && (Low[shift]<Low[shift+1])) 
               {
                  zzL[shift]=Low[shift];
                  zzH[shift]=0.0;
                  zz[shift]=Low[shift];
                  lasthigh=High[Bars-1];
                  lastlowpos=shift;
                  lastlow=Low[shift];
                  pos=shift;
                  first=false;
                  break;
               }
            if ((High[shift]>High[shift+1]) && (Low[shift]<Low[shift+1])) 
               {
                 if ((High[shift]-High[shift+1])>(Low[shift+1]-Low[shift]))
                  {
                     zzL[shift]=0.0;
                     zzH[shift]=High[shift];
                     zz[shift]=High[shift];
                     zzL[shift]=0.0;
                     lasthighpos=shift;
                     lasthigh=High[shift];
                     lastlow=Low[Bars-1];
                     pos=shift;
                     first=false;
                     break;
                  }
            if ((High[shift]-High[shift+1])<(Low[shift+1]-Low[shift]))
               {
                  zzL[shift]=Low[shift];
                  zzH[shift]=0.0;
                  zz[shift]=Low[shift];
                  lasthighpos=shift;
                  lasthigh=High[shift];
                  lastlow=Low[Bars-1];
                  pos=shift;
                  first=false;
                  break;
               } 
            if ((High[shift]-High[shift+1])==(Low[shift+1]-Low[shift]))
               {
                  zzL[shift]=0.0;
                  zzH[shift]=0.0;
                  zz[shift]=0.0;
               } 
         }   
         if  ((High[shift]<High[shift+1]) && (Low[shift]>Low[shift+1])) 
           {
              zzL[shift]=0.0;
              zzH[shift]=0.0;
              zz[shift]=0.0;
         }  
         pos=shift;
         realcnt=realcnt+1;   
         }
      
         //-------------------------------------------------------------------------
         // ����� ���������� ��������� ��������� ����� ��
         //-------------------------------------------------------------------------
          
         for(shift=pos-1; shift>=0; shift--)
          {
           if ((High[shift]>High[shift+1]) && (Low[shift]>=Low[shift+1]))
            {
               if (lasthighpos<lastlowpos)
                {
                  if (High[shift]>High[lasthighpos])
                    {
                     zzL[shift]=0.0;
                     zzH[shift]=High[shift];
                     zz[shift]=High[shift];
                     zz[lasthighpos]=0.0;
                     if (shift!=0)
                        lasthighpos=shift;
                     lasthigh=High[shift];
                     if (lastlowpos!=Bars) 
                        {
                        // ���� ���������� ������� ����� �����
                        }
                  }  
               } 
               if (lasthighpos>lastlowpos) 
                  {
                     if ((((High[shift]-Low[lastlowpos])>(StLevel*Point)) && ((lastlowpos-shift)>=minBars))  ||
                          ((High[shift]-Low[lastlowpos])>=(BigLevel*Point))) 
                     {
                        zzL[shift]=0.0;
                        zzH[shift]=High[shift];
                        zz[shift]=High[shift];
                        //zz[lasthighpos]=0.0;
                        if (shift!=0)
                           lasthighpos=shift;
                        lasthigh=High[shift]; 
                     }
                  }    
            }
           if ((High[shift]<=High[shift+1]) && (Low[shift]<Low[shift+1]))
            {
             if (lastlowpos<lasthighpos)
              {
               if (Low[shift]<Low[lastlowpos])
                { 
                  zzL[shift]=Low[shift];
                  zzH[shift]=0.0;
                  zz[shift]=Low[shift];
                  zz[lastlowpos]=0.0;
                  if (shift!=0)
                     lastlowpos=shift;
                  lastlow=Low[shift];
                }
             }
             if (lastlowpos>lasthighpos)
              {
               if ((((High[lasthighpos]-Low[shift])>(StLevel*Point)) && ((lasthighpos-shift)>=minBars))  ||
                    ((High[lasthighpos]-Low[shift])>=(BigLevel*Point))) 
                {
                  zzL[shift]=Low[shift];
                  zzH[shift]=0.0;
                  zz[shift]=Low[shift];
                  //zz[lastlowpos]=0.0;
                  if (shift!=0)
                     lastlowpos=shift;
                  lastlow=Low[shift]; 
               }
             } 
           }
           if ((High[shift]>High[shift+1]) && (Low[shift]<Low[shift+1]))
            {
             if (lastlowpos<lasthighpos)
              {
               if (Low[shift]<Low[lastlowpos])
                {
                  zzL[shift]=Low[shift];
                  zzH[shift]=0.0;
                  zz[shift]=Low[shift];
                  zz[lastlowpos]=0.0;
                  if (shift!=0) 
                     lastlowpos=shift;
                  lastlow=Low[shift];
               } 
             }
             if (lasthighpos<lastlowpos) 
              {
               if (High[shift]>High[lasthighpos])
                {
                  zzL[shift]=0.0;
                  zzH[shift]=High[shift];
                  zz[shift]=High[shift];
                  zz[lasthighpos]=0.0;
                  if (shift!=0)
                     lasthighpos=shift;
                  lasthigh=High[shift];
               }
             }
           } 
           realcnt=realcnt+1; 
           // if (shift<=0)
        }
        
       first=false; 
       countbars=Bars;
       NewBarTime=Time[0];
    }
    
    //****************************************************************************************************
    //
    //   ��������� �������� ����
    //
    //****************************************************************************************************    
    else
    //if (!first) 
    
    { 
     if (realcnt!=Bars)
     {
      first=True;
      return(0);
     } 
        
     if (Close[0]>=lasthigh) 
      {
       if (lastlowpos<lasthighpos)
        {
          if (Low[0]>lastlow)
           {
            if ((((High[0]-Low[lastlowpos])>(StLevel*Point)) && ((lastlowpos)>=minBars))  ||
                 ((High[0]-Low[lastlowpos])>(BigLevel*Point))) 
              {
               zzL[0]=0.0;
               zzH[0]=High[0];
               zz[0]=High[0]; 
               lasthigh=High[0];
               // lasthighpos=0;
              }
           }
        }
       if (lastlowpos>lasthighpos)
        {
         if (High[0]>=lasthigh)
          {
           zz[lasthighpos]=0.0;
           zz[0]=High[0];
           zzL[0]=0.0;
           zzH[0]=High[0];
           lasthighpos=0;
           lasthigh=High[0];
          }
        }  
       //lasthigh=High[0];
      }
     if (Close[0]<=lastlow) 
      {
       if (lastlowpos<lasthighpos)
        {
           zz[lastlowpos]=0.0;
           zz[0]=Low[0];
           zzL[0]=Low[0];
           zzH[0]=0.0;
           lastlow=Low[0];
           lastlowpos=0;  
        //  }
        }
       if (lastlowpos>lasthighpos)
        {
         if (High[0]<lasthigh)
          {
           if ((((High[lasthighpos]-Low[shift])>(StLevel*Point)) && ((lasthighpos-shift)>=minBars))  ||
                  ((High[lasthighpos]-Low[shift])>(BigLevel*Point)))
            {
             zz[0]=Low[0];
             zzL[0]=Low[0];
             zzH[0]=0.0;
             lastlow=Low[0];
             // lastlowpos=0;
            } 
          }
        }  
       //lastlow=Low[0];
      }
    }  
     
 return(0);
  }

  }
//--------------------------------------------------------
// ZZ_2L_nen . �����.
//#property copyright "Copyright � 2007, wellx. ver 0.07 alpha"
//#property link      "aveliks@gmail.com"
//--------------------------------------------------------

//--------------------------------------------------------
// ��������� i-vts . ������. 
//--------------------------------------------------------
//+------------------------------------------------------------------+
//|                                                        i-VTS.mq4 |
//|                                                    ����� & KimIV |
//|                                              http://www.kimiv.ru |
//|                                                                  |
//|  06.12.2005  ��������� VTS                                       |
//+------------------------------------------------------------------+
//
// ���� ��������� ����� ��� ������� � MQL �� MQ4
//
void i_vts() //
  {
   int    LoopBegin, sh;

 	if (NumberOfBars==0) LoopBegin=Bars-1;
   else LoopBegin=NumberOfBars-1;
   LoopBegin=MathMin(Bars-25, LoopBegin);

   for (sh=LoopBegin; sh>=0; sh--)
     {
      GetValueVTS("", 0, NumberOfVTS, sh);
      ha[sh]=ms[0];
      la[sh]=ms[1];
     }
  }

void i_vts1() //
  {
   int    LoopBegin, sh;

 	if (NumberOfBars==0) LoopBegin=Bars-1;
   else LoopBegin=NumberOfBars-1;
   LoopBegin=MathMin(Bars-25, LoopBegin);

   for (sh=LoopBegin; sh>=0; sh--)
     {
      GetValueVTS("", 0, NumberOfVTS1, sh);
      ham[sh]=ms[0];
      lam[sh]=ms[1];
     }
  }
//+------------------------------------------------------------------+
//------- ���������� ������� ������� ---------------------------------
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   sym - ������������ �����������                                 |
//|   tf  - ��������� (���������� �����)                             |
//|   ng  - ����� ������                                             |
//|   nb  - ����� ����                                               |
//|   ms  - ������ ��������                                          |
//+------------------------------------------------------------------+
void GetValueVTS(string sym, int tf, int ng, int nb)
  {
   if (sym=="") sym=Symbol();
   double f1, f2, s1, s2;

   f1=iClose(sym, tf, nb)-3*iATR(sym, tf, 10, nb);
   f2=iClose(sym, tf, nb)+3*iATR(sym, tf, 10, nb);
   for (int i=1; i<=ng; i++)
     {
      s1=iClose(sym, tf, nb+i)-3*iATR(sym, tf, 10, nb+i);
      s2=iClose(sym, tf, nb+i)+3*iATR(sym, tf, 10, nb+i);
      if (f1<s1) f1=s1;
      if (f2>s2) f2=s2;
     }
    ms[0]=f2;   // ������� �����
    ms[1]=f1;   // ������ �����
  }
//+------------------------------------------------------------------+
//--------------------------------------------------------
// ��������� i-vts . �����. 
//--------------------------------------------------------

//--------------------------------------------------------
// ��������� ������ ����������� � ������ ����������. ������. 
//--------------------------------------------------------
void info_TF()
  {
   string info="", info1="", info2="", info3="", info4="", txt="", txt0="", txt1="", regim="", perc="", mp0="", mp1="";
   int i, j=0, k;
   double pips;

   openTF[0]=iOpen(NULL,PERIOD_MN1,0);
   closeTF[0]=iClose(NULL,PERIOD_MN1,0);
   lowTF[0]=iLow(NULL,PERIOD_MN1,0);
   highTF[0]=iHigh(NULL,PERIOD_MN1,0);
   
   openTF[1]=iOpen(NULL,PERIOD_W1,0);
   closeTF[1]=iClose(NULL,PERIOD_W1,0);
   lowTF[1]=iLow(NULL,PERIOD_W1,0);
   highTF[1]=iHigh(NULL,PERIOD_W1,0);
   
   openTF[2]=iOpen(NULL,PERIOD_D1,0);
   closeTF[2]=iClose(NULL,PERIOD_D1,0);
   lowTF[2]=iLow(NULL,PERIOD_D1,0);
   highTF[2]=iHigh(NULL,PERIOD_D1,0);
   
   openTF[3]=iOpen(NULL,PERIOD_H4,0);
   closeTF[3]=iClose(NULL,PERIOD_H4,0);
   lowTF[3]=iLow(NULL,PERIOD_H4,0);
   highTF[3]=iHigh(NULL,PERIOD_H4,0);
   
   openTF[4]=iOpen(NULL,PERIOD_H1,0);
   closeTF[4]=iClose(NULL,PERIOD_H1,0);
   lowTF[4]=iLow(NULL,PERIOD_H1,0);
   highTF[4]=iHigh(NULL,PERIOD_H1,0);
   
   if (StringSubstr(info_comment,2,1)=="1")
     {
      if (minPercent>0) perc=DoubleToStr(MathAbs(minPercent),1); else perc="0.0";
      switch (ExtIndicator)
        {
         case 0     : {
                       if (noBackstep)
                         {
                          regim=" | "+ ExtIndicator + " / " + minBars;
                         }
                       else
                         {
                          regim=" | "+ ExtIndicator + " / " + minBars + " / " + ExtBackstep;
                         }
                       break;
                      }
         case 1     : {regim=" | "+ ExtIndicator + " / " + minSize + " / " + perc+" %"; break;}
         case 2     : {regim=" | "+ ExtIndicator + " / " + minBars + "/" + minSize; break;}
         case 3     : {regim=" | "+ ExtIndicator + " / " + minBars; break;}
         case 4     : {regim=" | "+ ExtIndicator + " / " + minSize; break;}
         case 5     : {regim=" | "+ ExtIndicator + " / " + minBars; break;}
         case 6     : {
                       if (noBackstep)
                         {
                          regim=" | "+ ExtIndicator + " / " + GrossPeriod + " / " + minBars;
                         }
                       else
                         {
                          regim=" | "+ ExtIndicator + " / " + GrossPeriod + " / " + minBars + " / " + ExtBackstep;
                         }
                       break;
                      }
         case 7     : {regim=" | "+ ExtIndicator + " / " + GrossPeriod + " / " + minBars; break;}
         case 8     : {regim=" | "+ ExtIndicator + " / " + GrossPeriod + " / " + minBars + " / " + ExtDeviation; break;}
         case 10    : {regim=" | "+ ExtIndicator + " / " + GrossPeriod + " / " + minBars; break;}
         case 11    : {
                       if (noBackstep)
                         {
                          regim=" | "+ ExtIndicator + " / " + Depth;
                         }
                       else
                         {
                          regim=" | "+ ExtIndicator + " / " + Depth + " / " + ExtBackstep;
                         }
                       break;
                      }
         case 12    : {regim=" | "+ ExtIndicator + " / " + minSize; break;}
         case 13    : {regim=" | "+ ExtIndicator + " / " + minBars + " / " + minSize; break;}
         case 14    : {regim=" | "+ ExtIndicator + " / " + StLevel + " / " + BigLevel + " / "  + minBars; break;}
        }
     }
   if (_ExtPitchforkStatic>0)
     {
      if (ExtCustomStaticAP)
        {
          regim=regim + " / APm";
        }
      else
        {
         if (ExtPitchforkCandle) regim=regim + " / APs-bars";
         else regim=regim + " / APs-" + ExtPitchforkStaticNum;
        }
     }
 
   info="";

   if (StringSubstr(info_comment,0,1)=="1")
     {
      for (i=0;i<5;i++)
        {
         pips=(highTF[i]-lowTF[i])/Point;
         if (pips>0)
           {
            if (openTF[i]==closeTF[i]) {txt=" = ";}
            else if (openTF[i]!=closeTF[i] && MathAbs((highTF[i]-lowTF[i])/(openTF[i]-closeTF[i]))>=6.6) {txt=" -|- ";}
            else if (openTF[i]>closeTF[i]) {txt=" \/ ";}
            else if (openTF[i]<closeTF[i]) {txt=" /\ ";}
            info=info + TF[i] + txt + DoubleToStr(pips,0) + "   " +  DoubleToStr((closeTF[i]-lowTF[i])/(pips*Point),3) + " |  ";
           }
         else if (pips==0)
           {
            txt=" -|- ";
            info=info + TF[i] + txt + DoubleToStr(pips,0) + " |  ";
           }
        }
      info1=info;
     }

   if (StringSubstr(info_comment,1,1)=="1")
     {
      info1=info1+Period_tf;
      if (afrl[0]>0)
        {
         if (afrh[1]!=0) info1=info1+"  "+DoubleToStr(100*MathAbs(afrh[1]-afrl[0])/afrh[1],2)+" %";
        }
      else
        {
         if (afrl[1]!=0) info1=info1+"  "+DoubleToStr(100*MathAbs(afrh[0]-afrl[1])/afrl[1],2)+" %";
        }
     }

   info1=info1+regim;

   if (StringSubstr(info_comment,3,1)=="1")
     {
      if (StringLen(vNamePatternToNumberPattern)>0)
        {
         info2="It is found " + countGartley + " patterns  -  for pattern N " + NumberPattern + " - " + vBullBearToNumberPattern + " " + vNamePatternToNumberPattern +" " +vNameStrongToNumberPattern+ " - " + DoubleToStr(LevelForDminToNumberPattern,Digits) + " < Range of the prices D < " + DoubleToStr(LevelForDmaxToNumberPattern,Digits) + "";
        }
      else info2="";
     }

   if (StringSubstr(info_comment,4,1)=="1")
     {
      if (info_RZS_RL=="")
        {
         info="";
        }
      else
        {
         info="RL_Static="+info_RZS_RL + "    ";
        }

      info3=info;

      if (info_RZD_RL=="")
        {
         info3=info;
        }
      else
        {
         info3=info+"RL_Dinamic="+info_RZD_RL;
        }
     }

   if (infoMerrillPattern)
     {
      for (k=4;k>=0;k--)
        {
         j=mPeak0[k][1];
         txt0=txt0+j;
         j=mPeak1[k][1];
         txt1=txt1+j;
        }

      for (k=0;k<32;k++)
        {
         if (txt0==mMerrillPatterns[k][0]) {mp0=mMerrillPatterns[k][1]+"   "+mMerrillPatterns[k][2];}
         if (txt1==mMerrillPatterns[k][0]) {mp1=mMerrillPatterns[k][1]+"   "+mMerrillPatterns[k][2];}
        }

      if (StringLen(mp1)>0 && StringLen(mp0)>0) info4="Static  "+mp1+"  /  "+"Dinamic  "+mp0;
      else if (StringLen(mp1)>0) info4="Static  "+mp1;
      else if (StringLen(mp0)>0) info4="Dinamic  "+mp0;
     }

   Comment(info1,"\n",info2,"\n",""+info3,"\n",""+info4);
//      if (RangeForPointD>0 && vNamePatternToNumberPattern != "")
   if (bigText)
     {
      nameObj="#_TextPattern_#" + ExtComplekt+"_";
      ObjectDelete(nameObj);
      if (StringLen(vNamePatternToNumberPattern)>0)
        {
         ObjectCreate(nameObj,OBJ_LABEL,0,0,0);

         ObjectSetText(nameObj,vBullBearToNumberPattern + " " + vNamePatternToNumberPattern + " " + vNameStrongToNumberPattern);
         ObjectSet(nameObj, OBJPROP_FONTSIZE, bigTextSize);
         if (vBullBearToNumberPattern=="Bullish") ObjectSet(nameObj, OBJPROP_COLOR, bigTextColor); else ObjectSet(nameObj, OBJPROP_COLOR, bigTextColorBearish);

         ObjectSet(nameObj, OBJPROP_CORNER, 1);
         ObjectSet(nameObj, OBJPROP_XDISTANCE, bigTextX);
         ObjectSet(nameObj, OBJPROP_YDISTANCE, bigTextY);
        }

      if (infoMerrillPattern)
        {
         nameObj="#_TextPatternMP_#" + ExtComplekt+"_";
         ObjectDelete(nameObj);
         ObjectCreate(nameObj,OBJ_LABEL,0,0,0);

         ObjectSetText(nameObj,info4);
         ObjectSet(nameObj, OBJPROP_FONTSIZE, bigTextSize);
         ObjectSet(nameObj, OBJPROP_COLOR, bigTextColor);

         ObjectSet(nameObj, OBJPROP_CORNER, 1);
         ObjectSet(nameObj, OBJPROP_XDISTANCE, bigTextX);
         ObjectSet(nameObj, OBJPROP_YDISTANCE, bigTextY+3+bigTextSize);
        }
     }

   close_TF=Close[0];
  }
//--------------------------------------------------------
// ��������� ������ ����������� � ������ ����������. �����. 
//--------------------------------------------------------

//--------------------------------------------------------
// ������� ������� � �������. ������. 
//--------------------------------------------------------
void array_()
  {
   for (int i=0; i<65; i++)
     {
      numberFibo            [i]=0;
      numberPesavento       [i]=0;
      numberGartley         [i]=0;
      numberGilmorQuality   [i]=0;
      numberGilmorGeometric [i]=0;
      numberGilmorHarmonic  [i]=0;
      numberGilmorArithmetic[i]=0;
      numberGilmorGoldenMean[i]=0;
      numberSquare          [i]=0;
      numberCube            [i]=0;
      numberRectangle       [i]=0;
      numberExt             [i]=0;
     }

   number                [0]=0.111;
   numbertxt             [0]=".111";
   numberCube            [0]=1;

   number                [1]=0.125;
   numbertxt             [1]=".125";
   numberMix             [1]=1;
   numberGilmorHarmonic  [1]=1;

   number                [2]=0.146;
   numbertxt             [2]=".146";
   numberFibo            [2]=1;
   numberGilmorGeometric [2]=1;

   number                [3]=0.167;
   numbertxt             [3]=".167";
   numberGilmorArithmetic[3]=1;

   number                [4]=0.177;
   numbertxt             [4]=".177";
   numberGilmorHarmonic  [4]=1;
   numberSquare          [4]=1;

   number                [5]=0.186;
   numbertxt             [5]=".186";
   numberGilmorGeometric [5]=1;

   number                [6]=0.192;
   numbertxt             [6]=".192";
   numberCube            [6]=1;

   number                [7]=0.2;
   numbertxt             [7]=".2";
   numberRectangle       [7]=1;

   number                [8]=0.236;
   numbertxt             [8]=".236";
   numberFibo            [8]=1;
   numberMix             [8]=1;
   numberGilmorGeometric [8]=1;
   numberGilmorGoldenMean[8]=1;

   number                [9]=0.25;
   numbertxt             [9]=".25";
   numberPesavento       [9]=1;
   numberGilmorQuality   [9]=1;
   numberGilmorHarmonic  [9]=1;
   numberSquare          [9]=1;

   number                [10]=0.3;
   numbertxt             [10]=".3";
   numberGilmorGeometric [10]=1;
   numberGilmorGoldenMean[10]=1;

   number                [11]=0.333;
   numbertxt             [11]=".333";
   numberGilmorArithmetic[11]=1;
   numberCube            [11]=1;

   number                [12]=0.354;
   numbertxt             [12]=".354";
   numberGilmorHarmonic  [12]=1;
   numberSquare          [12]=1;

   number                [13]=0.382;
   numbertxt             [13]=".382";
   numberFibo            [13]=1;
   numberPesavento       [13]=1;
   numberGartley         [13]=1;
   numberGilmorQuality   [13]=1;
   numberGilmorGeometric [13]=1;

   number                [14]=0.447;
   numbertxt             [14]=".447";
   numberGartley         [14]=1;
   numberRectangle       [14]=1;

   number                [15]=0.486;
   numbertxt             [15]=".486";
   numberGilmorGeometric [15]=1;
   numberGilmorGoldenMean[15]=1;

   number                [16]=0.5;
   numbertxt             [16]=".5";
   numberFibo            [16]=1;
   numberPesavento       [16]=1;
   numberGartley         [16]=1;
   numberGilmorQuality   [16]=1;
   numberGilmorHarmonic  [16]=1;
   numberSquare          [16]=1;

   number                [17]=0.526;
   numbertxt             [17]=".526";
   numberGilmorGeometric [17]=1;

   number                [18]=0.577;
   numbertxt             [18]=".577";
   numberGilmorArithmetic[18]=1;
   numberCube            [18]=1;

   number                [19]=0.618;
   numbertxt             [19]=".618";
   numberFibo            [19]=1;
   numberPesavento       [19]=1;
   numberGartley         [19]=1;
   numberGilmorQuality   [19]=1;
   numberGilmorGeometric [19]=1;
   numberGilmorGoldenMean[19]=1;

   number                [20]=0.667;
   numbertxt             [20]=".667";
   numberGilmorQuality   [20]=1;
   numberGilmorArithmetic[20]=1;

   number                [21]=0.707;
   numbertxt             [21]=".707";
   numberPesavento       [21]=1;
   numberGartley         [21]=1;
   numberGilmorHarmonic  [21]=1;
   numberSquare          [21]=1;

   number                [22]=0.764;
   numbertxt             [22]=".764";
   numberFibo            [22]=1;

   number                [23]=0.786;
   numbertxt             [23]=".786";
   numberPesavento       [23]=1;
   numberGartley         [23]=1;
   numberGilmorQuality   [23]=1;
   numberGilmorGeometric [23]=1;
   numberGilmorGoldenMean[23]=1;

   number                [24]=0.809;
   numbertxt             [24]=".809";
   numberExt             [24]=1;

   number                [25]=0.841;
   numbertxt             [25]=".841";
   numberPesavento       [25]=1;

   number                [26]=0.854;
   numbertxt             [26]=".854";
   numberFibo            [26]=1;
   numberMix             [26]=1;

   number                [27]=0.874;
   numbertxt             [27]=".874";
   numberExt             [27]=1;

   number                [28]=0.886;
   numbertxt             [28]=".886";
   numberGartley         [28]=1;

   number                [29]=1.0;
   numbertxt             [29]="1.";
   numberFibo            [29]=1;
   numberPesavento       [29]=1;
   numberGartley         [29]=1;
   numberGilmorQuality   [29]=1;
   numberGilmorGeometric [29]=1;

   number                [30]=1.128;
   numbertxt             [30]="1.128";
   numberPesavento       [30]=1;
   numberGartley         [30]=1;

   number                [31]=1.236;
   numbertxt             [31]="1.236";
   numberFibo            [31]=1;

   number                [32]=1.272;
   numbertxt             [32]="1.272";
   numberPesavento       [32]=1;
   numberGartley         [32]=1;
   numberGilmorQuality   [32]=1;
   numberGilmorGeometric [32]=1;
   numberGilmorGoldenMean[32]=1;

   number                [33]=1.309;
   numbertxt             [33]="1.309";
   numberExt             [33]=1;

   number                [34]=1.414;
   numbertxt             [34]="1.414";
   numberPesavento       [34]=1;
   numberGartley         [34]=1;
   numberGilmorHarmonic  [34]=1;
   numberSquare          [34]=1;

   number                [35]=1.5;
   numbertxt             [35]="1.5";
//   numberPesavento       [35]=1;
   numberGilmorArithmetic[35]=1;

   number                [36]=phi;
   numbertxt             [36]="1.618";
   numberFibo            [36]=1;
   numberPesavento       [36]=1;
   numberGartley         [36]=1;
   numberGilmorQuality   [36]=1;
   numberGilmorGeometric [36]=1;
   numberGilmorGoldenMean[36]=1;

   number                [37]=1.732;
   numbertxt             [37]="1.732";
   numberMix             [37]=1;
   numberGilmorQuality   [37]=1;
   numberGilmorArithmetic[37]=1;
   numberCube            [37]=1;

   number                [38]=1.75;
   numbertxt             [38]="1.75";
   numberGilmorQuality   [38]=1;

   number                [39]=1.902;
   numbertxt             [39]="1.902";
   numberMix             [39]=1;
   numberGilmorGeometric [39]=1;

   number                [40]=2.0;
   numbertxt             [40]="2.";
   numberPesavento       [40]=1;
   numberGartley         [40]=1;
   numberGilmorQuality   [40]=1;
   numberGilmorHarmonic  [40]=1;
   numberSquare          [40]=1;

   number                [41]=2.058;
   numbertxt             [41]="2.058";
   numberGilmorGeometric [41]=1;
   numberGilmorGoldenMean[41]=1;

   number                [42]=2.236;
   numbertxt             [42]="2.236";
   numberGartley         [42]=1;
   numberGilmorQuality   [42]=1;
   numberRectangle       [42]=1;

   number                [43]=2.288;
   numbertxt             [43]="2.288";
   numberExt             [43]=1;

   number                [44]=2.5;
   numbertxt             [44]="2.5";
   numberGilmorQuality   [44]=1;

   number                [45]=2.618;
   numbertxt             [45]="2.618";
   numberPesavento       [45]=1;
   numberGartley         [45]=1;
   numberGilmorQuality   [45]=1;
   numberGilmorGeometric [45]=1;
   numberGilmorGoldenMean[45]=1;

   number                [46]=2.828;
   numbertxt             [46]="2.828";
   numberGilmorHarmonic  [46]=1;
   numberSquare          [46]=1;

   number                [47]=3.0;
   numbertxt             [47]="3.0";
   numberGilmorQuality   [47]=1;
   numberGilmorArithmetic[47]=1;
   numberCube            [47]=1;

   number                [48]=3.142;
   numbertxt             [48]="3.142";
   numberGartley         [48]=1;

   number                [49]=3.236;
   numbertxt             [49]="3.236";
   numberExt             [49]=1;

   number                [50]=3.33;
   numbertxt             [50]="3.33";
   numberGilmorQuality   [50]=1;
   numberGilmorGeometric [50]=1;
   numberGilmorGoldenMean[50]=1;
   numberExt             [50]=1;

   number                [51]=3.464;
   numbertxt             [51]="3.464";
   numberExt             [51]=1;

   number                [52]=3.618;
   numbertxt             [52]="3.618";
   numberGartley         [52]=1;

   number                [53]=4.0;
   numbertxt             [53]="4.";
   numberPesavento       [53]=1;
   numberGilmorHarmonic  [53]=1;
   numberSquare          [53]=1;

   number                [54]=4.236;
   numbertxt             [54]="4.236";
   numberFibo            [54]=1;
   numberGilmorQuality   [54]=1;
   numberGilmorGeometric [54]=1;
   numberExt             [54]=1;

   number                [55]=4.472;
   numbertxt             [55]="4.472";
   numberExt             [55]=1;

   number                [56]=5.0;
   numbertxt             [56]="5.";
   numberRectangle       [56]=1;

   number                [57]=5.2;
   numbertxt             [57]="5.2";
   numberCube            [57]=1;

   number                [58]=5.388;
   numbertxt             [58]="5.388";
   numberGilmorGeometric [58]=1;

   number                [59]=5.657;
   numbertxt             [59]="5.657";
   numberGilmorHarmonic  [59]=1;
   numberSquare          [59]=1;

   number                [60]=6.0;
   numbertxt             [60]="6.";
   numberGilmorArithmetic[60]=1;

   number                [61]=6.854;
   numbertxt             [61]="6.854";
   numberGilmorQuality   [61]=1;
   numberGilmorGeometric [61]=1;

   number                [62]=8.0;
   numbertxt             [62]="8.";
   numberGilmorHarmonic  [62]=1;

   number                [63]=9.0;
   numbertxt             [63]="9.";
   numberCube            [63]=1;
/*
   number                []=;
   numbertxt             []=;

// ExtFiboType=0
   numberFibo            []=;
// 0
   numberPesavento       []=;
// 1
   numberGartley         []=;
// 2
   numberMix             []=;
// 3
   numberGilmorQuality   []=;
// 4
   numberGilmorGeometric []=;
// 5
   numberGilmorHarmonic  []=;
// 6
   numberGilmorArithmetic[]=;
// 7
   numberGilmorGoldenMean[]=;
// 8
   numberSquare          []=;
// 9
   numberCube            []=;
// 10
   numberRectangle       []=;
// 11
   numberExt             []=;
*/
  }
//--------------------------------------------------------
// ������� ������� � �������. �����. 
//--------------------------------------------------------

//--------------------------------------------------------
// ����������� �������� � ����� ����� ��� ��������� ���������. ������. 
//--------------------------------------------------------
void Pesavento_patterns()
  {
   if (ExtFiboType==1)
     {
      switch (ExtFiboChoice)
        {
         case 0  : {search_number(numberPesavento, ExtPesavento)        ;break;}
         case 1  : {search_number(numberGartley, ExtGartley886)         ;break;}
         case 2  : {search_number(numberGartley, ExtGartley886)         ;break;}
         case 3  : {search_number(numberGilmorQuality, ExtPesavento)    ;break;}
         case 4  : {search_number(numberGilmorGeometric, ExtPesavento)  ;break;}
         case 5  : {search_number(numberGilmorHarmonic, ExtPesavento)   ;break;}
         case 6  : {search_number(numberGilmorArithmetic, ExtPesavento) ;break;}
         case 7  : {search_number(numberGilmorGoldenMean, ExtPesavento) ;break;}
         case 8  : {search_number(numberSquare, ExtPesavento)           ;break;}
         case 9  : {search_number(numberCube, ExtPesavento)             ;break;}
         case 10 : {search_number(numberRectangle, ExtPesavento)        ;break;}
         case 11 : {search_number(numberExt, ExtPesavento)              ;break;}
        }
      }
    else
      {
       search_number(numberFibo, ExtPesavento);
      }

  }
//--------------------------------------------------------
// ����������� �������� � ����� ����� ��� ��������� ���������. �����. 
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ����� ��� ��������� ���������. ������. 
//--------------------------------------------------------
void search_number(int arr[], color cPattern)
  {
   int ki;
   colorPPattern=ExtNotFibo;
   if (ExtFiboChoice!=2)
     {
      if (ExtDeltaType==2) for (ki=kiPRZ;ki<=63;ki++)
                             {
                              if (arr[ki]>0)
                                {
                                 if (MathAbs((number[ki]-kj)/number[ki])<=ExtDelta)
                                   {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=cPattern; break;}
                                }
                             }

      if (ExtDeltaType==1) for (ki=kiPRZ;ki<=63;ki++)
                             {
                              if (arr[ki]>0)
                                {
                                 if (MathAbs(number[ki]-kj)<=ExtDelta)
                                   {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=cPattern; break;}
                                }
                             }
     }
   else
     {
      if (ExtDeltaType==2) for (ki=kiPRZ;ki<=63;ki++)
                             {
                              if (arr[ki]>0)
                                {
                                 if (MathAbs((number[ki]-kj)/number[ki])<=ExtDelta)
                                   {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=cPattern; break;}
                                }
                              else if (numberMix[ki]>0)
                                     if (MathAbs((number[ki]-kj)/number[ki])<=ExtDelta)
                                       {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=ExtPesavento; break;}
                             }

      if (ExtDeltaType==1) for (ki=kiPRZ;ki<=63;ki++)
                             {
                              if (arr[ki]>0)
                                {
                                 if (MathAbs(number[ki]-kj)<=ExtDelta)
                                   {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=cPattern; break;}
                                }
                              else if (numberMix[ki]>0)
                                     if (MathAbs(number[ki]-kj)<=ExtDelta)
                                       {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=ExtPesavento; break;}
                             }
     }
  }
//--------------------------------------------------------
// ����� ����� ��� ��������� ���������. �����. 
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������� �� ����������� �����. ������. 
//--------------------------------------------------------
void _SendMail(string subject, string some_text)
  {
  // GlobalVariableSet(StringConcatenate("PatternID_135",Symbol(),Period()),getPattern(vNamePattern));
   //SendMail(subject, some_text);
  }
//--------------------------------------------------------
// �������� ��������� �� ����������� �����. �����. 
//--------------------------------------------------------

//+------------------------------------------------------------------+
//| ������� �������� ���������� �� ������ � �������� ������          |
//| ���� double. ������.                                             |
//+------------------------------------------------------------------+
void _stringtodoublearray (string str, double& arr[], string& arr1[], int& x, bool y)
  {
   int i=0,j=-1,k=0;
   j=StringFind(str, ",",0);
   for (x=0;j>=0;x++)
     {
      j=StringFind(str, ",",j+1);
     }
   if(x>0)
     {
      x++;
      ArrayResize(arr,x);
      ArrayResize(arr1,x);
      if (y) ArrayResize(fitxt100,x);
     }

   for (i=0;i<x;i++)
     {
      j=StringFind(str,",",k);
      if (j<0)
        {
         arr1[i]=StringTrimLeft(StringTrimRight(StringSubstr(str,k)));
         arr[i]=StrToDouble(arr1[i]);
         if (arr[i]<1) arr1[i]=StringSubstr(arr1[i],1);
         if (y) fitxt100[i]=DoubleToStr(100*arr[i],1);
         break;
        }
      arr1[i]=StringTrimLeft(StringTrimRight(StringSubstr(str,k,j-k)));
      arr[i]=StrToDouble(arr1[i]);
      if (arr[i]<1) arr1[i]=StringSubstr(arr1[i],1);
      if (y) fitxt100[i]=DoubleToStr(100*arr[i],1);
      k=j+1;
     }
  }
//+------------------------------------------------------------------+
//| ������� �������� ���������� �� ������ � �������� ������          |
//| ���� double. �����.                                              |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| ������� �������� ���������� �� ������ � �������� ������          |
//| ���� color. ������.                                              |
//+------------------------------------------------------------------+
void _stringtocolorarray (string str, int& arr[], int& x)
  {
   int i=0,j=-1,k=0;
   j=StringFind(str, ",",0);
   for (x=0;j>=0;x++)
     {
      j=StringFind(str, ",",j+1);
     }
   if(x>0) {x++;ArrayResize(arr,x);}

   for (i=0;i<x;i++)
     {
      j=StringFind(str,",",k);
      if (j<0) {arr[i]=fStrToColor(StringSubstr(str,k)); break;}
      arr[i]=fStrToColor(StringSubstr(str,k,j-k));
      k=j+1;
     }
  }
//+------------------------------------------------------------------+
//| ������� �������� ���������� �� ������ � �������� ������          |
//| ���� color. �����.                                               |
//+------------------------------------------------------------------+

//--------------------------------------------------------
// �������������� ������ � ����. ������.
// ������� ������� Integer.  http://forum.mql4.com/ru/7134
//--------------------------------------------------------
color fStrToColor(string aName){
 
   color tColor[]={  Black, DarkGreen, DarkSlateGray, Olive, Green, Teal, Navy, Purple, 
                     Maroon, Indigo, MidnightBlue, DarkBlue, DarkOliveGreen, SaddleBrown, 
                     ForestGreen, OliveDrab, SeaGreen, DarkGoldenrod, DarkSlateBlue, 
                     Sienna, MediumBlue, Brown, DarkTurquoise, DimGray, LightSeaGreen, 
                     DarkViolet, FireBrick, MediumVioletRed, MediumSeaGreen, Chocolate, 
                     Crimson, SteelBlue, Goldenrod, MediumSpringGreen, LawnGreen, 
                     CadetBlue, DarkOrchid, YellowGreen, LimeGreen, OrangeRed, DarkOrange, 
                     Orange, Gold, Yellow, Chartreuse, Lime, SpringGreen, Aqua, DeepSkyBlue, 
                     Blue, Magenta, Red, Gray, SlateGray, Peru, BlueViolet, LightSlateGray, 
                     DeepPink, MediumTurquoise, DodgerBlue, Turquoise, RoyalBlue, SlateBlue, 
                     DarkKhaki, IndianRed, MediumOrchid, GreenYellow, MediumAquamarine, 
                     DarkSeaGreen, Tomato, RosyBrown, Orchid, MediumPurple, PaleVioletRed, 
                     Coral, CornflowerBlue, DarkGray, SandyBrown, MediumSlateBlue, Tan, 
                     DarkSalmon, BurlyWood, HotPink, Salmon, Violet, LightCoral, SkyBlue, 
                     LightSalmon, Plum, Khaki, LightGreen, Aquamarine, Silver, LightSkyBlue, 
                     LightSteelBlue, LightBlue, PaleGreen, Thistle, PowderBlue, PaleGoldenrod, 
                     PaleTurquoise, LightGray, Wheat, NavajoWhite, Moccasin, LightPink, 
                     Gainsboro, PeachPuff, Pink, Bisque, LightGoldenrod, BlanchedAlmond, 
                     LemonChiffon, Beige, AntiqueWhite, PapayaWhip, Cornsilk, LightYellow, 
                     LightCyan, Linen, Lavender, MistyRose, OldLace, WhiteSmoke, Seashell, 
                     Ivory, Honeydew, AliceBlue, LavenderBlush, MintCream, Snow, White
                  };  
   string tName[]={   "Black", "DarkGreen", "DarkSlateGray", "Olive", "Green", "Teal", "Navy", "Purple", 
                     "Maroon", "Indigo", "MidnightBlue", "DarkBlue", "DarkOliveGreen", "SaddleBrown", 
                     "ForestGreen", "OliveDrab", "SeaGreen", "DarkGoldenrod", "DarkSlateBlue", 
                     "Sienna", "MediumBlue", "Brown", "DarkTurquoise", "DimGray", "LightSeaGreen", 
                     "DarkViolet", "FireBrick", "MediumVioletRed", "MediumSeaGreen", "Chocolate", 
                     "Crimson", "SteelBlue", "Goldenrod", "MediumSpringGreen", "LawnGreen", 
                     "CadetBlue", "DarkOrchid", "YellowGreen", "LimeGreen", "OrangeRed", "DarkOrange", 
                     "Orange", "Gold", "Yellow", "Chartreuse", "Lime", "SpringGreen", "Aqua", "DeepSkyBlue", 
                     "Blue", "Magenta", "Red", "Gray", "SlateGray", "Peru", "BlueViolet", "LightSlateGray", 
                     "DeepPink", "MediumTurquoise", "DodgerBlue", "Turquoise", "RoyalBlue", "SlateBlue", 
                     "DarkKhaki", "IndianRed", "MediumOrchid", "GreenYellow", "MediumAquamarine", 
                     "DarkSeaGreen", "Tomato", "RosyBrown", "Orchid", "MediumPurple", "PaleVioletRed", 
                     "Coral", "CornflowerBlue", "DarkGray", "SandyBrown", "MediumSlateBlue", "Tan", 
                     "DarkSalmon", "BurlyWood", "HotPink", "Salmon", "Violet", "LightCoral", "SkyBlue", 
                     "LightSalmon", "Plum", "Khaki", "LightGreen", "Aquamarine", "Silver", "LightSkyBlue", 
                     "LightSteelBlue", "LightBlue", "PaleGreen", "Thistle", "PowderBlue", "PaleGoldenrod", 
                     "PaleTurquoise", "LightGray", "Wheat", "NavajoWhite", "Moccasin", "LightPink", 
                     "Gainsboro", "PeachPuff", "Pink", "Bisque", "LightGoldenrod", "BlanchedAlmond", 
                     "LemonChiffon", "Beige", "AntiqueWhite", "PapayaWhip", "Cornsilk", "LightYellow", 
                     "LightCyan", "Linen", "Lavender", "MistyRose", "OldLace", "WhiteSmoke", "Seashell", 
                     "Ivory", "Honeydew", "AliceBlue", "LavenderBlush", "MintCream", "Snow", "White", "CLR_NONE"
                  };
      aName=StringTrimLeft(StringTrimRight(aName));      
         for(int i=0;i<ArraySize(tName);i++){
            if(aName==tName[i])return(tColor[i]);
         }
      return(Red);                                     
                  
}

void setZZ(){
   int zzCount;
   double zz1,zz2;
   for(int i=0;i<Bars;i++){
      if(zz[i]>0 && zz1==0 && zz2==0) zz1=zz[i];
      else if(zz[i]>0 && zz1!=0 && zz2==0) zz2=zz[i];
      
      
   }
   GlobalVariableSet(StringConcatenate("CurrentZZ_135",Symbol(),Period()),zz1);
   GlobalVariableSet(StringConcatenate("CurrentZZStart_135",Symbol(),Period()),zz2);
}
void toVectorLevel(int vecID,double vecLevel){
   bool placed = false;
   for(int i =0; i<14; i++){
      if(interVectorLevels[1][i]==0 && placed==false){
         placed = true;
         interVectorLevels[1][i] = vecLevel;
         interVectorLevels[0][i] = vecID;
      }
    }
}
void setPRZLevels(double LevelForDmin,double LevelForDmax,double ptC, double ptD){
   double przRange,przThird,przFirstTestLevel,przSecondTestLevel,defaultTestLevel;
   double id1,val1,id2,val2,testdiff,finalDiff;
   double finalHigh,finalLow,finalHID,finalLID;
   int p;
   przRange = LevelForDmax - LevelForDmin;
   przThird = przRange/3;
   if(ptC>ptD) defaultTestLevel = LevelForDmin + (przRange * (defaultVectorRet/10) );
      else defaultTestLevel = LevelForDmax - (przRange * (defaultVectorRet/10) );
   //----------- Check for no levels
   int levelCount = 0;
   for(p=0;p<14;p++){
      if(interVectorLevels[1][p]>0)
         levelCount++;
   }
      //---------
      // No Level
      //----------
   if(levelCount==0){
      finalHigh = defaultTestLevel;
      finalLow = defaultTestLevel;
      finalHID = defaultVectorRet;
      finalLID = defaultVectorRet;
      //Print("[W][ZUP_135] No intra-vector retracement levels. Setting PRZ_HIGHRET_135 and PRZ_LOWRET_135 to %",DoubleToStr( (defaultVectorRet/10) ,Digits)," [",Symbol(),"|",Period(),"]");
   } 
   else if(levelCount==1){
      finalHigh = interVectorLevels[1][0]; finalLow = interVectorLevels[1][0]; finalHID = interVectorLevels[0][0]; finalLID = interVectorLevels[0][0];
        //Print("[W][ZUP_135] Only one intra-vector retracement. Setting PRZ_HIGHRET_135 and PRZ_LOWRET_135 to ",DoubleToStr(interVectorLevels[1][0],Digits)," [",Symbol(),"|",Period(),"|VecID: ",interVectorLevels[0][0]," : ",vecRetToString(interVectorLevels[0][0]),"]");
      
      }
   //-------
   //  BUY
   //-------
        
   else if(ptC>ptD && levelCount>1){
      przFirstTestLevel = LevelForDmin + przThird;
      przSecondTestLevel = przFirstTestLevel+przThird;
      for(p = 0; p<levelCount;p++){
         //------------------------
         // Find the high inter-vector retracement. This should be either the 1/3 retracement of the vector, or the 
         // nearest highest retracement level below DMax-(1/3)(DMax-DMin)
         //-------------------------
         if(interVectorLevels[1][p]>=przFirstTestLevel && interVectorLevels[1][p] > LevelForDmin){
            testdiff = MathAbs(przSecondTestLevel-interVectorLevels[1][p]);
            if( (testdiff<finalDiff) || finalDiff==0){
               finalDiff = testdiff;
               val1 = interVectorLevels[1][p];
               id1 = interVectorLevels[0][p];
               }
         }
         if(val1==0){
            val1 = przSecondTestLevel;
            id1 = defaultVectorRet;
         }
      }
      finalDiff = 0;
      for(p = 0; p<levelCount;p++){
         //------------------------
         // Find the low inter-vector retracement. This should be either the 1/3 retracement of the vector, or the 
         // nearest lowest retracement level around DMin+(1/3)(DMax-DMin)
         //-------------------------
         if(interVectorLevels[1][p]<val1 && interVectorLevels[1][p] > LevelForDmin){
            testdiff = MathAbs(przFirstTestLevel-interVectorLevels[1][p]);
            if( (testdiff<finalDiff) || finalDiff==0){
               finalDiff = testdiff;
               val2 = interVectorLevels[1][p];
               id2 = interVectorLevels[0][p];
               }
         }
         if(val2==0){
            val2 = przFirstTestLevel;
            id2 = defaultVectorRet;
            }
         }
         finalDiff = 0;
     } // close BUY
      //---------
      // SELL
      //----------
      
     else if(ptC<ptD && levelCount>1){
      przFirstTestLevel = LevelForDmax - przThird;
      przSecondTestLevel = przFirstTestLevel-przThird;
      
      for(p = 0; p<levelCount;p++){
         //------------------------
         // Find the high inter-vector retracement. This should be either the 1/3 retracement of the vector, or the 
         // nearest highest retracement level below DMax-(1/3)(DMax-DMin)
         //-------------------------
         if(interVectorLevels[1][p]<=przFirstTestLevel && interVectorLevels[1][p] < LevelForDmax){
            testdiff = MathAbs(przSecondTestLevel-interVectorLevels[1][p]);
            if( (testdiff<finalDiff) || finalDiff==0){
               finalDiff = testdiff;
               val2 = interVectorLevels[1][p];
               id2 = interVectorLevels[0][p];
            }
         }
         if(val2==0){
            val2 = przSecondTestLevel;
            id2 = defaultVectorRet;
         }
      }
      finalDiff = 0;
      
      for(p = 0; p<levelCount;p++){
         //------------------------
         // Find the low inter-vector retracement. This should be either the 1/3 retracement of the vector, or the 
         // nearest lowest retracement level around DMin+(1/3)(DMax-DMin)
         //-------------------------
         if(interVectorLevels[1][p] < LevelForDmax && interVectorLevels[1][p]>val2){
            testdiff = MathAbs(przFirstTestLevel-interVectorLevels[1][p]);
            if( (testdiff<finalDiff) || finalDiff==0){
               finalDiff = testdiff;
               val1 = interVectorLevels[1][p];
               id1 = interVectorLevels[0][p];
               }
            }
         if(val1==0){
            val1 = przFirstTestLevel;
            id1 = defaultVectorRet;
            }
      
         }
      
         finalDiff = 0;   
   } // close sell
   
   if(levelCount>1){
      finalHigh = val1; finalLow = val2; finalHID = id1; finalLID = id2;
      }
   if( (finalLow<LevelForDmin || finalLow>LevelForDmax) || (finalHigh>LevelForDmax || finalHigh<LevelForDmin) && levelCount > 1){
      if( (finalLow<LevelForDmin || finalLow>LevelForDmax) && !(finalHigh>LevelForDmax || finalHigh<LevelForDmin)){
         if(ptC>ptD)
            finalLow = LevelForDmin + ( (1000-defaultVectorRet) /1000)*przRange;
         else 
            finalLow = LevelForDmax - ( (1000-defaultVectorRet) /1000)*przRange;
         finalLID = defaultVectorRet;
         Print("[W][ZUP_135] The finalLow was out of range for [",periodToString(Period()),"|",Symbol(),"]. Setting to [",DoubleToStr(finalLow,Digits),"] PRZRange: ",DoubleToStr(przRange,Digits));
         }
      else if( !(finalLow<LevelForDmin || finalLow>LevelForDmax) && (finalHigh>LevelForDmax || finalHigh<LevelForDmin)){
         if(ptC>ptD)
            finalHigh = LevelForDmin + ( (1000-defaultVectorRet) /1000)*przRange;
         else 
            finalHigh = LevelForDmax - ( (1000-defaultVectorRet) /1000)*przRange;
         finalHID = defaultVectorRet;
         Print("[W][ZUP_135] The finalHigh was out of range for [",periodToString(Period()),"|",Symbol(),"]. Setting to [",DoubleToStr(finalHigh,Digits),"] PRZRange: ",DoubleToStr(przRange,Digits));
         }
      else{
         if(ptC>ptD)
            finalHigh = LevelForDmin + ( (1000-defaultVectorRet) /1000)*przRange;
         else 
            finalHigh = LevelForDmax - ( (1000-defaultVectorRet) /1000)*przRange;
         finalHID = defaultVectorRet; finalLow = finalHigh; finalLID = defaultVectorRet;
         Print("[W][ZUP_135] Both finalHigh and finalLow were out of range for [",periodToString(Period()),"|",Symbol(),"]. Setting to [",DoubleToStr(finalHigh,Digits),"] PRZRange: ",DoubleToStr(przRange,Digits));
         }
      }
      
   GlobalVariableSet(StringConcatenate("PRZ_HIGHRET_135",Symbol(),Period()),finalHigh);
   GlobalVariableSet(StringConcatenate("PRZ_LOWRET_135",Symbol(),Period()),finalLow);
   GlobalVariableSet(StringConcatenate("PRZ_HIGHID_135",Symbol(),Period()),finalHID);
   GlobalVariableSet(StringConcatenate("PRZ_LOWID_135",Symbol(),Period()),finalLID);
}

string periodToString(int period){
   if(period==noType) return("noType");
   switch(period){
         case 0: return("Invalid Period");
         case PERIOD_M1: return("PERIOD_M1");
         case PERIOD_M5: return("PERIOD_M5");
         case PERIOD_M15: return("PERIOD_M15");
         case PERIOD_M30: return("PERIOD_M30");
         case PERIOD_H1: return("PERIOD_H1");
         case PERIOD_H4: return("PERIOD_H4");
         case PERIOD_D1: return("PERIOD_D1");
         case noType: return("noType");
         default: return(StringConcatenate("PERIOD UNDEFINED ZUP_135. periodToString() [",period,"] Error: ",ErrorDescription(GetLastError())));
         }
}