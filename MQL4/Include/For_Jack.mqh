//+------------------------------------------------------------------+
//|                                                     For_Jack.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+

//---------------------------
      //   get_prz:
      //    @param std_period: PERIOD_X format
      //    @param isPartial: Special rules apply for partial patterns
      //          --> price_expansion, external_ret, internal_ret can be used
      //    @return: Proper stop for the pattern
      //    > Based off Fibonacci clustering
      //-----------------------------------
       double get_prz(int std_period){ return(get_prz(std_period,False));};
       double get_partial_prz(int std_period){ return(get_prz(std_period,True));};
       double get_prz(int std_period,bool isPartial){
         int z = int(zzz_points_index);
         int p = sym_def.get_period_index(std_period);
         //-------------------------------------
         // Fibonacci Retracement Schema:
         //       internal_ret, leg, ret_val_1, ret_val_2, ret_val_3, ret_vale_4, -1,
         //       external_ret, leg, ret_val_1, ret_val_2, -1       , -1        , -1,
         //    price_expansion, leg, ret_val_1, ret_val_2, ret_val_3, ret_val_4, ret_val_5
         //   price_projection, leg, ret_val_1, ret_val_2, ret_val_3, ret_val_4, -1
         //    > When iterating, negative values will be passed over
         //--------------------------------------
         // Internal Price Retracements:       External Price Retracements:   Price Expansion:                   Price Projection
         //    > Point X -> Point A              > Point B -> Point C           > Point A -> Point B             > Point B -> Point A
         //    > 38.2, 50, 61.8, 78.6%           > 127, 161.8%                  > 61.8, 100, 161.8, 200, 261.8%  > 61.8, 100, 161.8, 200%
         //---------------------------------------------
         double points_reference[int(fibonacci_schema_length)][5] = {
            0.382, 0.500, 0.618, 0.786, -1,    // Internal Price Retracements (fibonacci_schema.internal_ret)
            1.270, 1.618, -1   , -1   , -1,    // External Price Retracements (fibonacci_schema.external_ret)
            0.618, 1.000, 1.618, 2.000, 2.618, // Price Expansion             (fibonacci_schema.price_expansion)
            0.618, 1.000, 1.618, 2.000, -1     // Price Projection            (fibonacci_schema.price_projection)
         };
         double points[ int(fibonacci_retracement_points) ];
         int method_value[ int(fibonacci_retracement_points) ]; //--> For objects
         double retracement_value[ int(fibonacci_retracement_points) ]; //--> For objects
         color method_colors[ int(fibonacci_retracement_points) ] = {
            clrAqua, clrRed, clrDarkGoldenrod, clrDarkSalmon
         };
         //----------------------------
         //  Point Indexing:
         //    > Algorithm:
         //       1) Loop over all Fibonacci retracement method rows in turn
         //       2) Calculate retracement if value > -1
         //       3) Increment insert_index if value > -1
         //          a) If == -1, break out of sub loop
         //-----------------------------------------------
         int insert_index = 0;
         for(int method_index = 0; 
               (isPartial == False && method_index < int(fibonacci_schema_length)) 
            || (isPartial == True && method_index < int(fibonacci_schema_length)-1);
                method_index++){
               for(int val_index = 0; val_index < 5; val_index++){
                  double ret_val = points_reference[method_index][val_index];
                  if(ret_val!=-1){
                     //---- Deal with partial patterns
                     switch(isPartial){
                        case False: points[insert_index] = 
                                          get_leg_retracement( std_period, ret_val, method_index); break;
                        case True:  points[insert_index] = 
                                          get_partial_leg_retracement(std_period, ret_val, method_index ); break;
                     };
                     method_value[insert_index]      = method_index;
                     retracement_value[insert_index] = ret_val;
                     insert_index++;
                  }else if(ret_val == -1){ break;
                  }else{continue;};
               };
         };
         
         //---------------------------------------
         //  Object Creation:
         //    > Generate Objects and their labels
         //    > Vetting:
         //      1) Do not process Fibs below a sell, or above a buy.
         //      2) Do not process Fibs > 100% extension of highest point in pattern
         //-----------------------------------------------------------
         int order_type        = get_order_type(std_period);
         double low_threshold  = get_lowest_point(std_period)  - get_hilo_diff(std_period); // BUY
         double high_threshold = get_highest_point(std_period) + get_hilo_diff(std_period); // SELL
         int rej_count         = 0;
         
         if(isPartial) ArrayResize(points,11,0);
         for(int i = 0; i< ArraySize(points); i++){
            // Vet the points
            bool test_passed = False;
            switch(isPartial){
                  case False: if( (order_type == ORDER_TYPE_BUY && points[i] < get_point(std_period,point_d) && 
                                   points[i] > low_threshold) ||
                                (order_type == ORDER_TYPE_SELL && points[i] > get_point(std_period,point_d) && 
                                   points[i] < high_threshold )  ){
                                          test_passed = True;
                                          
                               }else{rej_count++;};
                  case True: if( (order_type == ORDER_TYPE_BUY && points[i] < get_point(std_period,point_d) ) || 
                                 (order_type == ORDER_TYPE_SELL && points[i] > get_point(std_period,point_d) ) ){
                                    test_passed = True;
                                 
                                 };
                 
              };
             
             //-------> Object creation if point passed the tests
             if(test_passed){
               string obj_name = StringConcatenate( sym_def.fibonacci_index_to_string(method_value[i]),":",DoubleToString(retracement_value[i],3));
               string obj_text = StringConcatenate("^ ",obj_name," ^");
               string obj_label = StringConcatenate(obj_name,"_Label");
               ObjectCreate(0,obj_name,OBJ_HLINE,0,0,points[i]);
               ObjectSet(obj_name,OBJPROP_COLOR,method_colors[ method_value[i] ]);
               ObjectCreate(0,obj_label,OBJ_TEXT,0,Time[1],ObjectGet(obj_name, OBJPROP_PRICE1));
               ObjectSetText(obj_label,obj_text,8,NULL,clrDarkOrange);
             };
         };
         demark.draw_demark_retracement(get_point(std_period,point_c),std_period);
         
         //-----------------------------------------------
         //  k-Means Cluster:
         //      1) Define initial partition - The two points that are furthest apart
         //         -> Mean vectors are now (first_mean,second_mean)
         //      2) Remaining points are now examined, and placed in the cluster they are closest to
         //         -> Euclidean measure
         //         -> The mean vector (first_mean, second_mean) is recalculated each time a new member is added
         //      3) Repartition
         //          -> Even though all individuals have now been added to their closest cluster, individual points
         //             could still possibly be closer to the opposite cluster. We must find out.
         //----------------------------------------------
             
           ArraySort(points,WHOLE_ARRAY,0,MODE_DESCEND); 
           double first_mean = points[0], second_mean = points[ArraySize(points)-1];
           Print("First_mean: ",string(first_mean)," Second-mean: ",string(second_mean));
           double first_cluster[1], second_cluster[1];
               first_cluster[0] = first_mean; second_cluster[0] = second_mean;
           int indexes_used[] = {0}; //--> add out first indicies used
               ArrayResize(indexes_used,ArraySize(indexes_used)+1); //--> Tracks what retracements from points have been used (by index)
               indexes_used[ ArraySize(indexes_used)-1 ] = ArraySize(points) - 1;
           bool break_out = False;
           while(!break_out){
               for(int i = 1; i < ArraySize(points)-1; i++){
                  Print("First_mean: ",DoubleToString(first_mean,_Digits)," Second-mean: ",DoubleToString(second_mean,_Digits),
                  " 1st-diff: ",DoubleToString(MathAbs(points[i] - first_mean),_Digits)," 2nd-diff: ",DoubleToString(MathAbs(points[i] - second_mean),_Digits));
                  if( MathAbs(points[i] - first_mean) < MathAbs(points[i] - second_mean) ){ //...if closer to first mean
                     first_mean = process_cluster(first_cluster,indexes_used,points[i],i); //... add to cluster, log index, return mean
                  }else{   //...closer to second mean
                     second_mean = process_cluster(second_cluster,indexes_used,points[i],i);
                  };
               };
               //>>>>>>>>>>>>>>>>>>>>>>
               // End initial partition
               //>>>>>>>>>>>>>>>>>>>>>>
               // Begin repartition
               //>>>>>>>>>>>>>>>>>>>>>
               int repartition_limit = 3; //--> This is largely arbitrary
               for(int p = 0; p < 15; p++){
                  Print("On repartition iteration #",p+1," FirstMean: ",DoubleToString(first_mean,_Digits)," Second Mean: ",DoubleToString(second_mean,_Digits));
                  for(int i = 0; i < ArraySize(first_cluster); i++){ //...see if first_cluster has any points closer to second_mean
                     if( MathAbs(first_cluster[i] - second_mean) > MathAbs(first_cluster[i] - first_mean)){
                        //Print("Found Repartition on [",p,"] partition iteration. Stripping from first");
                        swap_and_remove(first_cluster,i,second_cluster);
                        first_mean = take_mean(first_cluster);
                        second_mean = take_mean(second_cluster);
                     }else{continue;};
                  };
                  for(int i = 0; i < ArraySize(second_cluster); i++){
                     if(MathAbs(second_cluster[i] - first_mean) > MathAbs(second_cluster[i] - second_mean)){
                        //Print("Found Repartition on [",p,"] partition iteration. Stripping from second. ");
                        swap_and_remove(second_cluster,i,first_cluster);
                        first_mean = take_mean(first_cluster);
                        second_mean = take_mean(second_cluster);
                     }else{continue;};
                  };
               }
               
               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               //  End Repartition
               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               for(int v = 0; v < ArraySize(first_cluster); v++) Print("FirstCluster[",v,"] = ",DoubleToString(first_cluster[v],_Digits));
               for(int v = 0; v < ArraySize(second_cluster); v++) Print("SecondCluster[",v,"] = ",DoubleToString(second_cluster[v],_Digits));
               ObjectCreate(0,"FirstMean",OBJ_HLINE,0,0,first_mean);
               ObjectSet("FirstMean",OBJPROP_COLOR,clrPink);
               ObjectCreate(0,"SecondMean",OBJ_HLINE,0,0,second_mean);
               ObjectSet("SecondMean",OBJPROP_COLOR,clrPink);
               break_out = True;  
           };
         return(-1);
      };
            //---------------------------------
            // Helpers for get_prz: k-mean calculations
            //---------------------------------
            //  take_mean:
            //    @note: Helper. Calculates mean from given array
            //    @param data: Data to average
            //-----------------------------------
            double take_mean(double &data[]){
               double sum = 0;
               for(int i = 0; i < ArraySize(data); i++)
                  sum +=data[i];
               return(sum/ArraySize(data));
            };
           //-----------------------------------------
           //  process_cluster:
           //     @param cluster: Cluster array to resize and process
           //     @param indexes_used: Tracks which indicies from points[] has been used
           //     @param point_at_i: The data point to add to the cluster
           //     @param index: The index to add to indexes_used
           //     @return: new mean of the cluster
           //-----------------------------------------------
           double process_cluster(double &cluster[],int &indexes_used[], double point_at_i, int index){
               ArrayResize(cluster,ArraySize(cluster)+1); //...add and average
               ArrayResize(indexes_used,ArraySize(indexes_used)+1);
               cluster[ ArraySize(cluster) -1 ] = point_at_i; indexes_used[ ArraySize(indexes_used) -1 ] = index;
               return(take_mean(cluster)); //... updated cluster mean
           };
           //----------------------------------------
           //  swap_and_remove:
           //     @note: Must recalculate means after this operation
           //     @param cluster_to_pop: Needs to have a value removed
           //     @param pop_index: Index to strip value from and push to next cluster
           //     @param cluster_to_push: Array to be given new value
           //------------------------------------------------
           
           void swap_and_remove(double &cluster_to_pop[], int pop_index, double &cluster_to_push[]){
               double val = cluster_to_pop[pop_index];
               cluster_to_pop[pop_index] = -1000;
               ArraySort(cluster_to_pop,WHOLE_ARRAY,0,MODE_DESCEND); //---> Push value to back of array
               ArrayResize(cluster_to_pop,ArraySize(cluster_to_pop)-1); //--> Strip
               ArrayResize(cluster_to_push,ArraySize(cluster_to_push)+1);
               cluster_to_push[ ArraySize(cluster_to_push)-1 ] = val;
           };
           
           //-----------------------------------
      //  get_leg_retracement:
      //    @note: Calculates given retracement. Allows get_prz to be type agnostic
      //    @param leg_index: Leg to draw from (xa, ab, etc...)
      //    @param retracement: Retracement level
      //    @param std_period: PERIOD_X format
      //    @param fibonacci_index: Some Fibonacci projections draw from the later leg to the earlier, must match
      //    @return: Desired retracement ratio of leg
      //----------------------------------
       double get_leg_retracement(int std_period, double retracement, int fibonacci_index, bool isPartial){
         int p = sym_def.get_period_index(std_period);
         int z = int(zzz_points_index);
         //-----------------------------------------------------------------------------------
         // Methodology (Full Pattern):                Methodology (Partial Pattern):
         //    1) Interal Retracement       --> XA       1) Internal Retracement   --> AB
         //       > BUY  => Subtract from A                 > BUY  => Subtract from B
         //       > SELL => Add to A                        > SELL => Add to B
         //    2) External Retracement      --> BC       2) External Retracement   --> CD
         //       > BUY  => Subtract from C                 > BUY  => Subtract from D
         //       > SELL => Add to C                        > SELL => Add to D
         //    3) Price Expansion           --> AB       3) Price Expansion        --> BC
         //       > BUY  => Subtract from B                 > BUY  => Subtract from C
         //       > SELL => Add to B                        > SELL => Add to C
         //    3) Price Projection          --> AB
         //       > BUY  => Subtract from C
         //       > SELL => Add to C
         //------------------------------------------------------------------------------------
         double diff = -1;
         if(fibonacci_index == internal_ret){ 
            if(!isPartial) diff = MathAbs(zzz_points[p][ point_a ][z] - zzz_points[p][ point_x ][z]);
               else diff = MathAbs(zzz_points[p][ point_b ][z] - zzz_points[p][ point_a ][z]);
         }else if(fibonacci_index == external_ret ){
            if(!isPartial) diff = MathAbs(zzz_points[p][ point_c ][z] - zzz_points[p][ point_b ][z]);
               else diff = MathAbs(zzz_points[p][ point_d ][z] - zzz_points[p][ point_c ][z]);
         }else if(fibonacci_index == price_expansion || fibonacci_index == price_projection){
            if(!isPartial) diff = MathAbs(zzz_points[p][ point_a ][z] - zzz_points[p][ point_b ][z]);
               else diff = MathAbs(zzz_points[p][ point_c ][z] - zzz_points[p][ point_b ][z]);
         }else{Print("[ Symphony | Sorcery | GetRetracement ] Error. Unknown fibonacci_index: ",fibonacci_index); return(-1);};
         
         double ret_val = NormalizeDouble( (diff * retracement), _Digits);
         double result = -1;
         
         int order_type = -1; 
         if(!isPartial) order_type = get_order_type(std_period);
            else order_type = get_partial_order_type(std_period);
         int method_switch = 0;
         if(isPartial){ method_switch = 1; };
         //---> Fib methods
         int fib_techniques[2][int(fibonacci_schema_length)] = {
            internal_ret,external_ret,price_expansion,price_projection,
            internal_ret,external_ret,price_expansion,-1
         };
         //---> Method relevant point
         int fib_rel_point[2][int(fibonacci_schema_length)] = {
            point_a, point_c, point_b, point_c,   // Full pattern
            point_b, point_d, point_c, -1         // Partial pattern
         };
         
         for(int i = 0; (isPartial == False && i < int(fibonacci_schema_length)) 
                     || (isPartial == True && i < int(fibonacci_schema_length)-1); i++){
                     if(fibonacci_index == fib_techniques[method_switch][i]){
                        if(!isPartial){
                           if(order_type == ORDER_TYPE_BUY) result = get_point(std_period, fib_rel_point[method_switch][i] ) - ret_val;
                              else result = get_point(std_period, fib_rel_point[method_switch][i] ) + ret_val;
                        }else{
                           if(order_type == ORDER_TYPE_BUY) result = get_point(std_period, fib_rel_point[method_switch][i] ) + ret_val;
                              else result = get_point(std_period, fib_rel_point[method_switch][i] ) - ret_val;
                        };
                        return(result);
                     }
         };
         return(-1);
      };