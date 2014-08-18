//+------------------------------------------------------------------------------------+
#define     _NAME_                  "ZigZagZug"
#define     _TITLE_                 "ZigZagZug (v1.1r5) - MetaTrader 4 Indicator"
#define     _ABSTRACT_              "ZigZag Indicator with Extra Features"
#property   copyright               "Copyright © 2014, Fernando M. I. Carreiro"
#property   link                    "mailto:fmi@carreiro.co.pt?subject=ZigZagZug.v1.0"
#property   indicator_chart_window
#property   indicator_buffers       7
#property   indicator_width1        2
#property   indicator_style1        0
#property   indicator_color1        Silver
#property   indicator_width2        1
#property   indicator_style2        0
#property   indicator_color2        Aqua
#property   indicator_width3        1
#property   indicator_style3        0
#property   indicator_color3        Magenta
#property   indicator_width4        1
#property   indicator_style4        2
#property   indicator_color4        Aqua
#property   indicator_width5        1
#property   indicator_style5        2
#property   indicator_color5        Magenta
#property   indicator_width6        1
#property   indicator_style6        0
#property   indicator_color6        Aqua
#property   indicator_width7        1
#property   indicator_style7        0
#property   indicator_color7        Magenta
//+------------------------------------------------------------------------------------+
//                                  Please note that the TAB Size is based on 4, not 3
//+------------------------------------------------------------------------------------+


//+------------------------------------------------------------------------------------+
//  Indicator Settings
//+------------------------------------------------------------------------------------+

//--- Primary Indicator Settings
     string
        strPrimarySettings  = "--- Primary Indicator Settings ---"
    ;

//---- Define ZigZag Parameters
     int
        intDepth            = 12        // Depth Search of ZigZag Extreems
    ,   intBackStep         = 3         // BackStep for ZigZag Extreems
    ;
     double
        dblDeviation        = 5.0       // Price Deviation of ZigZag Extreems
    ;
     bool
        boolShowBreakOut    = false     // Show where Breakouts occured
    ,   boolAlertOnBreakOut = false     // Alert User of a Breakout
    ;
     string
        strBreakoutMsgUpper = "(High) Breakout has occured!"
    ,   strBreakoutMsgLower = "(Low) Breakout has occured!"
    ;
    

//---- Define ZigZagZug Buffers
    double
        dblArrayZigZag[]                // ZigZag Points
    ,   dblArrayZigZagHigh[]            // ZigZag Highs
    ,   dblArrayZigZagLow[]             // ZigZag Lows
    ,   dblArrayHigh[]                  // Running High of Depth Search
    ,   dblArrayLow[]                   // Running Low of Depth Search
    ,   dblArrayBreakOutHigh[]          // BreakOut High of Depth Search
    ,   dblArrayBreakOutLow[]           // BreakOut Low of Depth Search
    ;

//---- Define Extra Variables

    bool
        boolDownloadHistory = false     // Download History Data
    ;
    int
        intLevel            = 3         // For Depth Recounting
    ,   intIndexLimit       = 100       // Limit Count of Index
    ;
    datetime
        dtAlertLastUpper    = NULL      // Date/Time of last Upper Alert
    ,   dtAlertLastLower    = NULL      // Date/Time of last Lower Alert
    ;
    
//---- Define Search States
#define _SEARCH_PEAK_   +1
#define _SEARCH_BOTH_   0
#define _SEARCH_VALLEY_ -1
        
        
//+------------------------------------------------------------------------------------+
//  Indicator Functions
//+------------------------------------------------------------------------------------+

//---- Initialise Buffer Index and other Properties
    int init()
    {
        // Set Number of Buffers to be used
        if( boolShowBreakOut )
            IndicatorBuffers( 7 );
        else
            IndicatorBuffers( 5 );

        // Set Number of Digits (Precision)
        IndicatorDigits( Digits );  

        // Set Indicator Name
        IndicatorShortName(
            StringConcatenate(
                "ZigZagZug (", intDepth
            ,   ",", intBackStep
            ,   ",", dblDeviation, ")"
            ) );

        // Set Buffer Index
        SetIndexBuffer( 0, dblArrayZigZag );
        SetIndexBuffer( 1, dblArrayZigZagHigh );
        SetIndexBuffer( 2, dblArrayZigZagLow );
        SetIndexBuffer( 3, dblArrayHigh );
        SetIndexBuffer( 4, dblArrayLow );

        // Set Index Label
        SetIndexLabel( 0, "ZigZag Points" );
        SetIndexLabel( 1, "ZigZag Highs" );
        SetIndexLabel( 2, "ZigZag Lows" );
        SetIndexLabel( 3, "Depth High" );
        SetIndexLabel( 4, "Depth Low" );

        // Set Line Style
        SetIndexStyle( 0, DRAW_SECTION, STYLE_SOLID, 2, Silver );
        SetIndexStyle( 1, DRAW_ARROW, STYLE_SOLID, 1, Aqua );
        SetIndexStyle( 2, DRAW_ARROW, STYLE_SOLID, 1, Magenta );
        SetIndexStyle( 3, DRAW_LINE, STYLE_DOT, 1, Aqua );
        SetIndexStyle( 4, DRAW_LINE, STYLE_DOT, 1, Magenta );

        // Set Arrow Types
        SetIndexArrow( 1, 108 );
        SetIndexArrow( 2, 108 );

        // Set Empty Value
        SetIndexEmptyValue( 0, NULL );
        SetIndexEmptyValue( 1, NULL );
        SetIndexEmptyValue( 2, NULL );
        SetIndexEmptyValue( 3, NULL );
        SetIndexEmptyValue( 4, NULL );
        
        if( boolShowBreakOut )  // Extra Indicator Settings to show Breakouts
        {
            // Set Buffer Index
            SetIndexBuffer( 5, dblArrayBreakOutHigh );
            SetIndexBuffer( 6, dblArrayBreakOutLow );

            // Set Index Label
            SetIndexLabel( 5, "BreakOut High" );
            SetIndexLabel( 6, "BreakOut Low" );

            // Set Line Style
            SetIndexStyle( 5, DRAW_ARROW, STYLE_SOLID, 1, Aqua );
            SetIndexStyle( 6, DRAW_ARROW, STYLE_SOLID, 1, Magenta );

            // Set Arrow Types
            SetIndexArrow( 5, 161 );
            SetIndexArrow( 6, 161 );
            
            // Set Empty Value
            SetIndexEmptyValue( 5, NULL );
            SetIndexEmptyValue( 6, NULL );
        }
        
        //---- Adjust for 3 or 5 Digit Brokers
        if( ( Digits == 3 ) || ( Digits == 5 ) ) dblDeviation *= 10;
        
        // Correct External Variables
        if( intDepth    < 1 )   intDepth    = 1;
        if( intBackStep < 1 )   intBackStep = 1;

        dblDeviation = MathRound( MathAbs( dblDeviation ) ) * Point;

        return( NULL );
    }
        

//---- Initialise Buffer Index and other Properties
    int start()
    {
      
        int
            intLimitBars,   intCountedBars  = IndicatorCounted()
        ,   intCounter,     intSearch       = _SEARCH_BOTH_
        ,   intLowPosition, intHighPosition
        ,   intShift,       intBack
        ,   intIndex
        ;
        double
            dblResult,      dblValue
        ,   dblCurrentLow,  dblCurrentHigh
        ,   dblPreviousLow, dblPreviousHigh
        ;
        
        if ( intCountedBars < 0 )
            return( EMPTY );
        
        if( intCountedBars == 0 )
        {
            // Check for Downloaded History Data
            if( boolDownloadHistory )
            { 
                if(ArraySize(dblArrayZigZag)!=0) 
                  ArrayInitialize( dblArrayZigZag, NULL );
                if(ArraySize(dblArrayZigZagHigh)!=0)
                  ArrayInitialize( dblArrayZigZagHigh, NULL );
                if(ArraySize(dblArrayZigZagLow)!=0)
                  ArrayInitialize( dblArrayZigZagLow, NULL );
                if(ArraySize(dblArrayHigh)!=0)
                  ArrayInitialize( dblArrayHigh, NULL );
                if(ArraySize(dblArrayLow)!=0)
                  ArrayInitialize( dblArrayLow, NULL );
                if(ArraySize(dblArrayBreakOutHigh)!=0)
                  ArrayInitialize( dblArrayBreakOutHigh, NULL );
                if(ArraySize(dblArrayBreakOutLow)!=0)
                  ArrayInitialize( dblArrayBreakOutLow, NULL );
            }

            intLimitBars = Bars - intDepth;
            boolDownloadHistory = true;
        }
        
        // function for depth recounting    
        if ( intCountedBars > 0 ) // if the IndicatorCounted is greater than 0
        {
            for(    intIndex = 0, intCounter = 0;
                    ( intCounter < intLevel ) && ( intIndex < intIndexLimit );
                    intIndex++ )
            {
                dblResult = dblArrayZigZag[ intIndex ];
                if( dblResult !=0 ){
                  intCounter++;
                  }
            }
        
            intIndex--;
        
            intLimitBars = intIndex;
        
            dblResult = dblArrayZigZagLow[ intIndex ];
            if( dblResult != 0 ) 
            {
                dblCurrentLow = dblResult;
                intSearch = _SEARCH_PEAK_;
            }
            else
            {
                dblCurrentHigh = dblArrayZigZagHigh[ intIndex ];
                intSearch = _SEARCH_VALLEY_;
            }
        
            for( intIndex = intLimitBars - 1; intIndex > 0; intIndex-- )
            {
                dblArrayZigZag[ intIndex ]          = NULL;
                dblArrayZigZagLow[ intIndex ]       = NULL;
                dblArrayZigZagHigh[ intIndex ]      = NULL;
                dblArrayBreakOutLow[ intIndex ]     = NULL;
                dblArrayBreakOutHigh[ intIndex ]    = NULL;
            }   
        }
        
        
        //---- Initial Analysis of Data
        
        for( intShift = intLimitBars; intShift >= 0; intShift-- )
        {
            //---- Verify the High Value
            dblArrayHigh[ intShift ]
                = High[ iHighest( NULL, 0, MODE_HIGH, intDepth, intShift ) ];
            dblValue = dblArrayHigh[ intShift ];
            
            if( boolShowBreakOut )
            {
                if( High[ intShift ] == dblValue)
                    dblArrayBreakOutHigh[ intShift ] = dblValue;
                else
                    dblArrayBreakOutHigh[ intShift ] = NULL;
            }
            
            if( dblValue == dblPreviousHigh )
                dblValue = NULL;
            else
            {
                dblPreviousHigh = dblValue;
                
                if( ( dblValue - High[ intShift ] ) > dblDeviation )
                    dblValue = NULL;
                else
                {
                    for( intBack = 1; intBack <= intBackStep; intBack++ )
                    {
                        dblResult = dblArrayZigZagHigh[ intShift + intBack ];
                        if( ( dblResult != 0 ) && ( dblResult < dblValue ) )
                            dblArrayZigZagHigh[ intShift + intBack ] = NULL; 
                    }
                }
            }
            
            if( High[ intShift ] == dblValue)
                dblArrayZigZagHigh[ intShift ] = dblValue;
            else
                dblArrayZigZagHigh[ intShift ] = NULL;

                
            //---- Verify the Low Value
            dblArrayLow[ intShift ]
                = Low[ iLowest( NULL, 0, MODE_LOW, intDepth, intShift ) ];
            dblValue = dblArrayLow[ intShift ];
            
            if( boolShowBreakOut )
            {
                if( Low[ intShift ] == dblValue)
                    dblArrayBreakOutLow[ intShift ] = dblValue;
                else
                    dblArrayBreakOutLow[ intShift ] = NULL;
            }
            
            if( dblValue == dblPreviousLow )
                dblValue = NULL;
            else
            {
                dblPreviousLow = dblValue;
                
                if( ( Low[ intShift ] - dblValue ) > dblDeviation )
                    dblValue = NULL;
                else
                {
                    for( intBack = 1; intBack <= intBackStep; intBack++ )
                    {
                        dblResult = dblArrayZigZagLow[ intShift + intBack ];
                        if( ( dblResult != 0 ) && ( dblResult > dblValue ) )
                            dblArrayZigZagLow[ intShift + intBack ] = NULL; 
                    } 
                }
            }
            
            if( Low[ intShift ] == dblValue)
                dblArrayZigZagLow[ intShift ] = dblValue;
            else
                dblArrayZigZagLow[ intShift ] = NULL;
        }
        
        
        //---- Final Filtering and Adjustments
        
        if( intSearch == _SEARCH_BOTH_ )
        {
            dblPreviousLow  = NULL;
            dblPreviousHigh = NULL;
        }
        else
        {
            dblPreviousLow  = dblCurrentLow;
            dblPreviousHigh = dblCurrentHigh;
        }
        
        for( intShift = intLimitBars; intShift >= 0; intShift-- )
        {
            switch( intSearch )
            {
               
                  
                case _SEARCH_BOTH_:
                    if( ( dblPreviousLow == NULL ) && ( dblPreviousHigh == NULL ) )
                    {
                        if( dblArrayZigZagHigh[ intShift ] != NULL )
                        {
                            intHighPosition             = intShift;
                            dblPreviousHigh             = High[ intShift ];
                            dblArrayZigZag[ intShift ]  = dblPreviousHigh;
                            intSearch                   = _SEARCH_VALLEY_;
                        }
                        
                        if( dblArrayZigZagLow[ intShift ] != NULL )
                        {
                            intLowPosition              = intShift;
                            dblPreviousLow              = Low[ intShift ];
                            dblArrayZigZag[ intShift ]  = dblPreviousLow;
                            intSearch                   = _SEARCH_PEAK_;
                        }
                    }
                    break;
            

                case _SEARCH_PEAK_:
                    if( dblArrayZigZagHigh[ intShift ] == NULL )
                    {
                        if( ( dblArrayZigZagLow[ intShift ] != NULL             ) &&
                            ( dblArrayZigZagLow[ intShift ] < dblPreviousLow    )       )
                        {
                            dblArrayZigZag[ intLowPosition ]    = NULL;
                            intLowPosition                      = intShift;
                            dblPreviousLow                      = dblArrayZigZagLow[ intShift ];
                            dblArrayZigZag[ intShift ]          = dblPreviousLow;
                        }
                    }
                    else
                    {
                        if( dblArrayZigZagLow[ intShift ] == NULL )
                        {
                            intHighPosition                     = intShift;
                            dblPreviousHigh                     = dblArrayZigZagHigh[ intShift ];
                            dblArrayZigZag[ intShift ]          = dblPreviousHigh;
                            intSearch                           = _SEARCH_VALLEY_;
                        }
                    }
                    break;

                case _SEARCH_VALLEY_:
                    if( dblArrayZigZagLow[ intShift ] == NULL )
                    {
                        if( ( dblArrayZigZagHigh[ intShift ]    != NULL             ) &&
                            ( dblArrayZigZagHigh[ intShift ]    > dblPreviousHigh   )       )
                        {
                            dblArrayZigZag[ intHighPosition ]   = NULL;
                            intHighPosition                     = intShift;
                            dblPreviousHigh                     = dblArrayZigZagHigh[ intShift ];
                            dblArrayZigZag[ intShift ]          = dblPreviousHigh;
                        }
                    }
                    else
                    {
                        if( dblArrayZigZagHigh[ intShift ] == NULL )
                        {
                            intLowPosition                      = intShift;
                            dblPreviousLow                      = dblArrayZigZagLow[ intShift ];
                            dblArrayZigZag[ intShift ]          = dblPreviousLow;
                            intSearch                           = _SEARCH_PEAK_;
                        }
                    }
                    break;
            }
        }
        
        // Check current bar for breakouts and alert user
        if( boolAlertOnBreakOut )
        {
            if( High[ 0 ] == dblArrayBreakOutHigh[ 0 ] )
            {
                if( Time[ 0 ] != dtAlertLastUpper )
                {
                    Alert( strBreakoutMsgUpper, " ( ", DoubleToStr( High[ 0 ], Digits ), " )" );
                    dtAlertLastUpper = Time[ 0 ];
                }
            }
            
            if( Low[ 0 ] == dblArrayBreakOutLow[ 0 ] )
            {
                if( Time[ 0 ] != dtAlertLastLower )
                {
                    Alert( strBreakoutMsgLower, " ( ", DoubleToStr( Low[ 0 ], Digits ), " )" );
                    dtAlertLastLower = Time[ 0 ];
                }
            }
        }
      // ----- Loop to set global variable
      /*double cur = 0,start=0; int i=0; bool curHigh = false; // -> curHigh = Is the current ZigZag a high (as opposed to a low)?
      
      while((cur==0. || start==0.) || //...as long as the relevant points are not set
            i<=IndicatorCounted()){
         if(cur==0.){
            if(dblArrayZigZagHigh[i]!=0.){
                cur = dblArrayZigZagHigh[i];
                curHigh = true; // -> set flag
            }
            else if(dblArrayZigZagLow[i]!=0.) cur = dblArrayZigZagLow[i];
            //if(cur!=0.) Print("Current: ",DoubleToStr(cur,Digits));
         } 
         else if(start==0.){
            if(curHigh==false && dblArrayZigZagHigh[i]!=0.) start = dblArrayZigZagLow[i];
            else if(dblArrayZigZagLow[i]!=0) start = dblArrayZigZagLow[i];
            //if(start!=0.) Print("Start: ",DoubleToStr(start,Digits));
         }  
         
         i++;
      }*/
      //Print("Current: ",DoubleToStr(cur,5)," Start: ",DoubleToStr(start,5));
      double points[5];
      
      for(int i=0, count = 0; 
         i<Bars && count<5;
         i++){
         
         if(dblArrayZigZag[i]!=0.){
           points[count] = dblArrayZigZag[i]; 
           count++;
            }
          
         }
      
      GlobalVariableSet(StringConcatenate("ZigZagZug_D",Symbol(),Period()),points[0]);
      GlobalVariableSet(StringConcatenate("ZigZagZug_C",Symbol(),Period()),points[1]);
      GlobalVariableSet(StringConcatenate("ZigZagZug_B",Symbol(),Period()),points[2]);
      GlobalVariableSet(StringConcatenate("ZigZagZug_A",Symbol(),Period()),points[3]);
      GlobalVariableSet(StringConcatenate("ZigZagZug_X",Symbol(),Period()),points[4]);
      
        return( NULL );
    }

//+------------------------------------------------------------------------------------+