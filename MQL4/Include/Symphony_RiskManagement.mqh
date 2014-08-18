//+------------------------------------------------------------------+
//|                                               PositionSizing.mq4 |
//|                                                           Luke S |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luke S"
#property link      ""
#define NUMBER_OF_SYMBOLS 57


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
//--------------------------------------------------------------

class SymphonyRiskManager
{
   bool MoneyInsteadOfRisk;
   bool UseEquityInsteadOfBalance;
   double MaxLotSize;
   double Risk;
   private:
      MqlTick last_tick;
      double get_ask(){
         SymbolInfoTick(_Symbol,this.last_tick);
         return(this.last_tick.ask);
         };
      double get_bid(){
         SymbolInfoTick(_Symbol,this.last_tick);
         return(this.last_tick.bid);
         };
   public:
      SymphonyRiskManager(){
         this.MoneyInsteadOfRisk = false;
         this.UseEquityInsteadOfBalance = false;
         this.MaxLotSize = 1.0;
         this.Risk = 0.02;
      }
      SymphonyRiskManager(double r){
         this.MoneyInsteadOfRisk = false;
         this.UseEquityInsteadOfBalance = false;
         this.MaxLotSize = 1.0;
         this.Risk = r;
      }
      SymphonyRiskManager(bool MoneyInsteadOfRisk, bool UseEquityInsteadOfBalance, double MaxLotSize) {
         this.MoneyInsteadOfRisk = MoneyInsteadOfRisk;
         this.UseEquityInsteadOfBalance = UseEquityInsteadOfBalance;
         this.MaxLotSize = MaxLotSize;
         this.Risk = 0.02;
      }
      //######################
      //#  SETTERS
      //######################
      
      void set_money_instead_of_risk(bool set)        { this.MoneyInsteadOfRisk=set;       }
      void set_equity_instead_of_balance(bool set)    { this.UseEquityInsteadOfBalance=set;}
      void set_max_lot_size(double set)               { this.MaxLotSize=set;               }
      void set_risk(double risk)                      { this.Risk = risk;                  }
      double get_max_lot_size()                       { return(this.MaxLotSize);           }
      double get_risk()                               { return(this.Risk);                 }
      
      
      //--------------------------------------------------------------------
      //  PositionSize:
      //    > Usage
      //       1) StopLossLevel - Your stoploss.
      //       2) RiskLevelOrMoneyToRisk - if (MoneyInsteadOfRisk == true) input $Risk, 
      //          if false input %Risk (as double e.g. 0.02)
      //       3) MaxLotSize - 0 for default [1.0]
      //---------------------------------------------------------------------
      
      double position_size(double StopLossLevel, double RiskLevelOrMoneyToRisk)
         {
         string symbol = Symbol();
         int type;
         if(StopLossLevel<this.get_ask()) type = ORDER_TYPE_BUY; else type = ORDER_TYPE_SELL;
         if(MoneyInsteadOfRisk==false && RiskLevelOrMoneyToRisk > 100){
            Print("[ Symphony | Risk Management ] Please make sure you have the proper inputs. Refer to Usage.");
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
         int currencyConvert = 0,stopInPips; // Counter currency (e.g. EURUSD) = 1, Base Currency (e.g. USDJPY) =2, Acct Denom not in current pair, but same as conversion pair's counter = 3 (e.g. trading EURGBP, convert with GBPUSD), "" same as conversion pair's base = 4 (e.g. EURCAD, convert with USDCAD)
         string convertConcat; // string for parsing counter and base currency in case 3 and 4
         
      //---------------------------------------------------
      //                    Basic Account Info
      //---------------------------------------------------
         int lot_size = MarketInfo(Symbol(),MODE_LOTSIZE);
         switch(lot_size)
                  {
                  case 100000:   lotValPerPip=10; break;           //" Standard account"; 1 lot = 100,000 units, each pip worth $10
                  case 10000:   lotValPerPip=1; break;           //" Mini Lot account"; 1 lot = 10,000 units, each pip worth $1
                  case 1000:  lotValPerPip=0.1; break;           //" Micro Lot account"; 1 lot= 1,000 units, each pip work $0.10
                  default:    lotValPerPip=1; Print("[ Symphony | Risk Management ] Uncoded lot size account. Min Lot Size: ",MarketInfo(Symbol(),MODE_LOTSIZE)); break;
                  }
                  
      //---------------------------------------------------
      //                    Identify Symbol
      //---------------------------------------------------
           int i = 0;
           if(StringSubstr(symbol,3)=="USD") 
               currencyConvert = 1; // check for USD pairs, should be good for oil,gold,etc
           else if(StringSubstr(symbol,0,3)=="USD") 
               currencyConvert = 2; // check for USD pairs
           for(i=0;i<ArraySize(threes);i++)
               if(symbol==threes[i]) currencyConvert = 3;
           for(i=0;i<ArraySize(fours);i++)
               if(symbol==fours[i]) currencyConvert = 4;
           if(currencyConvert == 0) 
               Print("[ Symphony | Risk Management ] No listed currency found. Double check the arrays.");
           currencyPoint = _Point;
      //---------------------------------------------------
      //                    Convert
      //---------------------------------------------------     
           switch(type){
               case ORDER_TYPE_BUY: stopInPips = NormalizeDouble(MathAbs(this.get_ask()-StopLossLevel),_Digits)*MathPow(10,_Digits);
                             break;
               case ORDER_TYPE_SELL: stopInPips = NormalizeDouble(MathAbs(this.get_bid()-StopLossLevel),_Digits)*MathPow(10,_Digits);
                             break;
               default: Print("[ Symphony | Risk Management ] Error, Type Undefined. Last Error: ",GetLastError()); break;
           }
           switch(currencyConvert){
            case 1: dollarAmtRisk = (RiskPoints*Size); // dollar amount risked
                    break;
            case 2: dollarAmtRisk = (RiskPoints*Size)/this.get_ask(); // dollar amount risked * inverse of base currency exchange rate (e.g. dollarAmtRisk[USDCAD] = (RiskPoints*Size) * (1/Close[USDCAD]))
                    break;
            case 3: convertConcat = StringSubstr(symbol,0,3); StringAdd(convertConcat,"USD"); // specifies conversion pair
                    dollarAmtRisk = (RiskPoints*Size)*this.get_ask(); // dollar amount risked
                    break;
            case 4: convertConcat = "USD"; StringAdd(convertConcat,StringSubstr(symbol,3)); // specifies conversion pair
                    dollarAmtRisk = (RiskPoints*Size)*(1/this.get_ask()); // dollar amount risked
                    break;
            }// end switch
             valPerPip = (dollarAmtRisk)/(stopInPips);
             lotSize = (valPerPip * SYMBOL_TRADE_CONTRACT_SIZE/lotValPerPip)/SYMBOL_TRADE_CONTRACT_SIZE;
             lotSize*=100; lotSize =  MathFloor(lotSize); lotSize/=100;  // Rounds lot down
             Print("[ Symphony | Risk Management ] [",symbol,"] [Case:",currencyConvert,"] [stopPips:",stopInPips,"|AccountSize:",DoubleToString(Size,2),"|Amnt@Risk:",DoubleToString((RiskPoints*Size),2),"|valPerPip:",DoubleToString(valPerPip,_Digits),"|LotSize:",DoubleToString(lotSize,2),"|LvPp:",lotValPerPip,"]");
      
      //---------------------------------------------------
      //                    Normalize Lot Size
      //---------------------------------------------------      
             if(lotSize<MarketInfo(Symbol(),MODE_MINLOT)) return(MarketInfo(Symbol(),MODE_MINLOT));
             if(lotSize<=maxLotSize) return(lotSize); else return(maxLotSize);
      };
      
      //-----------------------------------
      //      END POSITIONSIZE
      //  ########################
      //     BEGIN RISK/REWARD  
      //-----------------------------------
      
      //------------------------------------
      //  riskReward:
      //    > Yields the risk/reward ratio of the
      //      supplied stop and take profit
      //-------------------------------------
      
      double risk_reward(double stoploss, double takeprofit){
         double stopInPips,profitInPips, ratio;
         int type;
         if(stoploss<takeprofit) type = ORDER_TYPE_BUY; else type = ORDER_TYPE_SELL;
         string symbol = Symbol();
         switch(type){
               case ORDER_TYPE_BUY: stopInPips = MathAbs(this.get_ask()-stoploss);
                            profitInPips = MathAbs(takeprofit-this.get_ask());
                             break;
               case ORDER_TYPE_SELL: stopInPips = MathAbs(stoploss-this.get_bid());
                             profitInPips = MathAbs(this.get_bid()-takeprofit);
                             break;
               default: Print("[ Symphony | RiskManagement ] Type Undefined. Inputs: [SL:",DoubleToString(stoploss,_Digits),"|TP: ",
                              DoubleToString(stoploss,_Digits),"] Last Error: ",GetLastError()); return(-1);
           }
         ratio = profitInPips/stopInPips;
         return(ratio);
      };
      
      //------------------------------------
      //  riskRewardPartialClosing:
      //    > Parameters:
      //         1) Initial stop/takeprofit
      //         2) Partial close level
      //         3) Initial lot size and the portion of the
      //            lot size to be closed
      //-------------------------------------
      double risk_reward_partial_closing(double stoploss, double takeprofit, double ptlCloseLevel, double initialLotSize, double lotsToClose){
            double profitFinal,pPips1,pPips2,loss,lossPips,profit1,profit2,valPerPip1,valPerPip2,ratio;
            int type;
            valPerPip1 = initialLotSize*10;
            valPerPip2 = (initialLotSize - lotsToClose);
            if(stoploss<takeprofit) type = ORDER_TYPE_BUY; else type = ORDER_TYPE_SELL;
            switch(type){
               case ORDER_TYPE_BUY: pPips1 = (ptlCloseLevel-this.get_ask())*MathPow(10,_Digits);
                            pPips2 = (takeprofit-ptlCloseLevel)*MathPow(10,_Digits);
                            lossPips = (this.get_ask() - stoploss)*MathPow(10,_Digits);
               case ORDER_TYPE_SELL: pPips1 = (this.get_bid()-ptlCloseLevel)*MathPow(10,_Digits);
                             pPips2 = (ptlCloseLevel-takeprofit)*MathPow(10,_Digits);
                             lossPips = (stoploss - this.get_bid())*MathPow(10,_Digits); 
               default: Print("[ Symphony | Risk Management ] riskRewardPartialClose. Error: ",GetLastError());
            }
            profit1 = (pPips1*valPerPip1);
            if(lotsToClose>0) profit2 = (pPips2*valPerPip2);
               else profit2 = (pPips2*valPerPip1);
            profitFinal = profit1+profit2;
            loss = valPerPip1*lossPips;
            ratio = profitFinal/loss;
            return(ratio);
      };
      //---------------------------------------------------//
      //  lotsToClose:                                     //
      //    > Normalizes the proper portion of lots to     //
      //      close when handling partial order closes     //
      //---------------------------------------------------//
      
      double lots_to_close(double lots){
         double lotstoclose;
         string symbol = Symbol();
         if(lots==0.01)
            return(0);
         else if(lots==0.02)
            return(0.01);
         else if(lots==0.03)
            return(0.01);
         else{
            lotstoclose = (lots*1000)/3; 
            lotstoclose = MathFloor(lotstoclose); 
            lotstoclose /= 1000;
            lotstoclose = NormalizeDouble(lotstoclose,2);
            if(lotstoclose>=0.01) return(lotstoclose);
                else return(SYMBOL_VOLUME_MIN);
         }
         return(0.00);
      };

};
