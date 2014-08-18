//+------------------------------------------------------------------+
//|                                               PositionSizing.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""
#define NUMBER_OF_SYMBOLS 57
#include <stdlib.mqh>
#include <stderror.mqh> 

//----------------------------
//  Position Sizing Policy:
//    -> Dynamic lot sizing. By default, will calculate lots to trade with give a %Risk or $Risk parameter
//    -> Toggle via setters
//    1) MoneyInsteadOfRisk - True if you would use a nominal value for risk.
//                            False if you would rather use %R.
//    2) EquityInsteadOfBalance - Default is false. Will use AccountBalance()
//                               True if you would rather use your equity in calculations
//    3) MaxLotSize - 1.0 by default
//    
//------- 
bool MoneyInsteadOfRisk = false;
bool UseEquityInsteadOfBalance = false;
double MaxLotSize = 1.0;
void risk.setMoneyInsteadOfRisk(bool set){ MoneyInsteadOfRisk=set;}
void risk.setEquityInsteadOfBalance(bool set){ UseEquityInsteadOfBalance=set;}
void risk.setMaxLotSize(double set){ MaxLotSize=set;}
//--------------------------------------------------------------------
//                           Usage
//    1) StopLossLevel - Your stoploss.
//    2) RiskLevelOrMoneyToRisk - if (MoneyInsteadOfRisk == true) input $Risk, if false input %Risk (as double e.g. 0.02)
//    
//    5) MaxLotSize - 0 for default [1.0]
//
//
//---------------------------------------------------------------------

double risk.positionSize(double StopLossLevel, double RiskLevelOrMoneyToRisk)
   {
   string symbol = Symbol();
   int type;
   if(StopLossLevel<MarketInfo(symbol,MODE_ASK)) type = OP_BUY; else type = OP_SELL;
   if(MoneyInsteadOfRisk==false && RiskLevelOrMoneyToRisk > 100){
      Print("[MM] Please make sure you have the proper inputs. Refer to Usage.");
      return(0);
      }
  string threes[] = {"EURCHF","EURGBP","EURAUD", // symbols with USD as 
                     "GBPNZD","GBPAUD","AUDNZD", // conversion pair's counter currency
                     "EURNZD","EURNZD"};
  string fours[] = {"EURJPY","GBPJPY","CHFJPY", // symbols with USD as 
                    "GBPCHF","EURCAD","AUDCAD", // conversion pair's base currency
                    "AUDJPY","CADJPY","NZDJPY",
                    "GBPCAD","EURSEK","EURNOK",
                    "AUDCHF","EURPLN","EURCZK",
                    "EURDKK","GBPSEK","NOKJPY",
                    "SEKJPY","SGDJPY","HKDJPY",
                    "ZARJPY","EURTRY","NZDCHF",
                    "CADCHF","NZDCAD","CHFSEK",
                    "CHFNOK","EURHUF"};
   double maxLotSize, Size, dollarAmtRisk,valPerPip, currencyPoint, lotValPerPip, lotSize, RiskPoints;
   //---- Account Size parameters
   if(UseEquityInsteadOfBalance) Size = AccountEquity(); else Size = AccountBalance();
   //---- Risk metrics
   if(MoneyInsteadOfRisk) RiskPoints = NormalizeDouble((RiskLevelOrMoneyToRisk/Size),2); else RiskPoints = RiskLevelOrMoneyToRisk;
   if(MaxLotSize==0) maxLotSize = 1.0; else maxLotSize = MaxLotSize; 
   RefreshRates();
   
   
   int currencyConvert = 0,stopInPips; // Counter currency (e.g. EURUSD) = 1, Base Currency (e.g. USDJPY) =2, Acct Denom not in current pair, but same as conversion pair's counter = 3 (e.g. trading EURGBP, convert with GBPUSD), "" same as conversion pair's base = 4 (e.g. EURCAD, convert with USDCAD)
   string convertConcat; // string for parsing counter and base currency in case 3 and 4
   
//---------------------------------------------------
//                    Basic Account Info
//---------------------------------------------------

   switch(MarketInfo(Symbol(),MODE_LOTSIZE))
            {
            case 100000:   lotValPerPip=10; break;           //" Standard account"; 1 lot = 100,000 units, each pip worth $10
            case 10000:   lotValPerPip=1; break;           //" Mini Lot account"; 1 lot = 10,000 units, each pip worth $1
            case 1000:  lotValPerPip=0.1; break;           //" Micro Lot account"; 1 lot= 1,000 units, each pip work $0.10
            default:    lotValPerPip=1; Print("[MM] Uncoded lot size account"); break;
            }
            
//---------------------------------------------------
//                    Identify Symbol
//---------------------------------------------------

     
     if(StringSubstr(symbol,3)=="USD") currencyConvert = 1; // check for USD pairs, should be good for oil,gold,etc
     else if(StringSubstr(symbol,0,3)=="USD") currencyConvert = 2; // check for USD pairs
     for(int i=0;i<ArraySize(threes);i++){
         if(symbol==threes[i]) currencyConvert = 3;
     }
     for(i=0;i<ArraySize(fours);i++){
      if(symbol==fours[i]) currencyConvert = 4;
     }
     
     if(currencyConvert == 0) Print("[MM][ - ] No listed currency found. Double check the arrays.");
     currencyPoint = MarketInfo(symbol,MODE_POINT);
//---------------------------------------------------
//                    Convert
//---------------------------------------------------     
     
     switch(type){
         case OP_BUY: stopInPips = NormalizeDouble(MathAbs(MarketInfo(symbol,MODE_ASK)-StopLossLevel),MarketInfo(symbol,MODE_DIGITS))*MathPow(10,MarketInfo(symbol,MODE_DIGITS));
                       break;
         case OP_SELL: stopInPips = NormalizeDouble(MathAbs(MarketInfo(symbol,MODE_BID)-StopLossLevel),MarketInfo(symbol,MODE_DIGITS))*MathPow(10,MarketInfo(symbol,MODE_DIGITS));
                       break;
         default: Print("[E][MM] Type Undefined. Last Error: ",ErrorDescription(GetLastError())); break;
     }
     Print("Currency convert switch");
     switch(currencyConvert){
      case 1: dollarAmtRisk = (RiskPoints*Size); // dollar amount risked
              break;
             
      case 2: dollarAmtRisk = (RiskPoints*Size)/MarketInfo(symbol,MODE_ASK); // dollar amount risked * inverse of base currency exchange rate (e.g. dollarAmtRisk[USDCAD] = (RiskPoints*Size) * (1/Close[USDCAD]))
              break;
             
      case 3: convertConcat = StringSubstr(symbol,0,3); convertConcat = StringConcatenate(convertConcat,"USD"); // specifies conversion pair
              dollarAmtRisk = (RiskPoints*Size)*MarketInfo(convertConcat,MODE_ASK); // dollar amount risked
              break;
             
      case 4: convertConcat = StringSubstr(symbol,3); convertConcat = StringConcatenate("USD",convertConcat); // specifies conversion pair
              dollarAmtRisk = (RiskPoints*Size)*(1/MarketInfo(convertConcat,MODE_ASK)); // dollar amount risked
              break;
              
      }// end switch
       valPerPip = (dollarAmtRisk)/(stopInPips);
       lotSize = (valPerPip * (MarketInfo(Symbol(),MODE_LOTSIZE)/lotValPerPip))/MarketInfo(Symbol(),MODE_LOTSIZE);
       lotSize*=100; lotSize =  MathFloor(lotSize); lotSize/=100;  // Rounds lot down
       Print("[MM] [",symbol,"}[Case:",currencyConvert,"] [stopPips:",stopInPips,"|AccountSize:",DoubleToStr(Size,2),"|Amnt@Risk:",DoubleToStr((RiskPoints*Size),2),"|valPerPip:",DoubleToStr(valPerPip,MarketInfo(Symbol(),MODE_DIGITS)),"|LotSize:",DoubleToStr(lotSize,2),"|LvPp:",lotValPerPip,"]");

//---------------------------------------------------
//                    Normalize Lot Size
//---------------------------------------------------      
       
       if(lotSize<MarketInfo(Symbol(),MODE_MINLOT)) return(MarketInfo(Symbol(),MODE_MINLOT));
       if(lotSize<=maxLotSize) return(lotSize); else return(maxLotSize);
   }

double risk.riskReward(double stoploss, double takeprofit){
   double stopInPips,profitInPips, ratio;
   int type;
   if(stoploss<takeprofit) type = OP_BUY; else type = OP_SELL;
   string symbol = Symbol();
   switch(type){
         case OP_BUY: stopInPips = MathAbs(MarketInfo(symbol,MODE_ASK)-stoploss);
                      profitInPips = MathAbs(takeprofit-MarketInfo(symbol,MODE_ASK));
                       break;
         case OP_SELL: stopInPips = MathAbs(stoploss-MarketInfo(symbol,MODE_BID));
                       profitInPips = MathAbs(MarketInfo(symbol,MODE_BID)-takeprofit);
                       break;
         default: Print("[E][MM] Type Undefined. Last Error: ",ErrorDescription(GetLastError())); return(-1);
     }
   ratio = profitInPips/stopInPips;
   //Print("stopInPips: ",DoubleToStr(stopInPips,Digits)," profitInPips: ",DoubleToStr(profitInPips,Digits)," Ratio: ",DoubleToStr(ratio,Digits));
   return(ratio);
}

double risk.riskRewardPartialClosing(double stoploss, double takeprofit, double ptlCloseLevel, double initialLotSize, double lotsToClose){
   double profitFinal,pPips1,pPips2,loss,lossPips,profit1,profit2,valPerPip1,valPerPip2,ratio;
   int type;
   
   valPerPip1 = initialLotSize*10;
   valPerPip2 = (initialLotSize - lotsToClose);
   
   if(stoploss<takeprofit) type = OP_BUY; else type = OP_SELL;
   
   
   switch(type){
      case OP_BUY: pPips1 = (ptlCloseLevel-Ask)*MathPow(10,Digits);
                   pPips2 = (takeprofit-ptlCloseLevel)*MathPow(10,Digits);
                   lossPips = (Ask - stoploss)*MathPow(10,Digits);
      case OP_SELL: pPips1 = (Bid-ptlCloseLevel)*MathPow(10,Digits);
                    pPips2 = (ptlCloseLevel-takeprofit)*MathPow(10,Digits);
                    lossPips = (stoploss - Bid)*MathPow(10,Digits); 
      default: Print("Error: ",ErrorDescription(GetLastError()));
   }
   profit1 = (pPips1*valPerPip1);
   if(lotsToClose>0) profit2 = (pPips2*valPerPip2);
      else profit2 = (pPips2*valPerPip1);
   profitFinal = profit1+profit2;
   loss = valPerPip1*lossPips;
   Print("1");
   Print("vPP1: ",DoubleToStr(valPerPip1,Digits)," vPP2: ",DoubleToStr(valPerPip2,Digits));
   Print("stopLoss: ",DoubleToStr(stoploss,Digits)," tP: ",DoubleToStr(takeprofit,5)," ptlCloseLevel: ",DoubleToStr(ptlCloseLevel,5)," initLS: ",DoubleToStr(initialLotSize,Digits)," lotsToClose: ",DoubleToStr(lotsToClose,Digits));
   Print("Loss: ",DoubleToStr(loss,Digits)," profitFinal: ",DoubleToStr(profitFinal,Digits)," [Pr1: ",DoubleToStr(profit1,3),"|Pr2:",DoubleToStr(profit2,3),"|pPip1: ",pPips1,"|pPips2: ",pPips2,"|lossPip: ",lossPips,"]");
   ratio = profitFinal/loss;
   Print("2");
   return(ratio);
}

//---------------------------------------------------//
//                                                   //
//          Normalizes proper closing lot size       //
//          for partial closings (normally 1/3)      //
//                                                   //
//---------------------------------------------------//

double risk.lotsToClose(double lots){
   double lotstoclose;
   string symbol = Symbol();
   switch(lots){
      case 0.01: return(0);
      case 0.02: return(0.01);
      case 0.03: return(0.01);
      default: lotstoclose = (lots*1000)/3; 
               lotstoclose = MathFloor(lotstoclose); 
               lotstoclose /= 1000;
               NormalizeDouble(lotstoclose,2);
               if(lotstoclose>=0.01) return(lotstoclose);
                    else return(MarketInfo(symbol,MODE_MINLOT));
   }
   
   return(0.00);
}

