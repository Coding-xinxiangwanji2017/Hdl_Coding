function [ output_data ] = func_echo_timing_cal( curr_echo )
%FUNC_ECHO_TIMING_CAL Summary of this function goes here
%   Detailed explanation goes here

[row_echo , ~] = size(curr_echo);

width8_ismaxtrigger_max = 7.5e-9 ; % max pulse width <7ns @ 8%-triggered only
width20_ismaxtrigger_max = 7e-9 ; % max pulse width <7ns @ 20%-triggered only
width50_ismaxtrigger_max = 6.5e-9 ; % max pulse width <7ns @ 50%-triggered only
width90_ismaxtrigger_max = 5.5e-9 ; % max pulse width <7ns @ 90%-triggered only

width8_min = 4.5e-9; % minimum pulse width for width-calibration
width20_min = 4e-9; % minimum pulse width for width-calibration
width50_min = 3.5e-9; % minimum pulse width for width-calibration
width90_min = 3.5e-9; % minimum pulse width for width-calibration

tr8T20_single_echo_max = 3e-9 ; % single-echo max 8%-20% rising edge : max 1.3e-9
tr20T50_single_echo_max = 3e-9  ;  % single-echo max 20%-50% rising edge : max  1.25e-9
tr50T90_single_echo_max = 3e-9  ;  % single-echo max 50%-90% rising edge : max 1.25e-9 

tf90T50_single_echo_max = 3e-9 ;   % single-echo max 90%-50% falling edge : max 1e-9
tf50T20_single_echo_max = 4e-9 ;   % single-echo max 50%-20% falling edge : max 2e-9
tf20T8_single_echo_max = 3e-9 ;    % single-echo max 20%-8% falling edge : max 2e-9
tf90T20_single_echo_max = 5e-9  ;   % single-echo max 90%-20% falling edge : max 3e-9
tf50T8_single_echo_max = 5.5e-9 ;    % single-echo max 50%-8% falling edge : max 3.6e-9
tf90T8_single_echo_max = 6e-9 ;    % single-echo max 90%-8% falling edge : max 4.1e-9

tr8T20_single_echo_min = 0.4e-9 ;  % single-echo non-saturate 8%-20% rising edge
tr20T50_single_echo_min = 0.55e-9 ;  % single-echo non-saturate 20%-50% rising edge
tr50T90_single_echo_min = 0.9e-9 ;  % single-echo non-saturate 50%-90% rising edge

t_caled(1,1) = 0;
k = 1; 
switch row_echo
    % =====================================================================
    case {2} % only level-8% was triggered  % total 2/34-cases % 
        tr8 = curr_echo(1,1) ;
        tf8 = curr_echo(2,1) ;
        
        width8 = tf8 - tr8 ; % width at 8%
        
        % case #4:  width8 less than stardard-single-echo-width-max-limit
        if width8 <= width8_ismaxtrigger_max
            t_caled = tr8 + func_peak_timing_cal('width8', width8) ;  % func_peak_timing_cal: type 1, width8
            % case #34: width8 larger than stardard-single-echo-width-max-limit
        else
            t_caled(1, 1) = tr8 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed cal
            t_caled(2, 1) = tf8 + func_peak_timing_cal('fixed-falling-cal', 0); % using fixed cal
        end
    % =====================================================================
    case {4} % only level-8% & level-20% was triggered,  % total 5/34-cases %  
        tr8 = curr_echo(1,1) ;
        tf8 = curr_echo(4,1) ;
        tr20 = curr_echo(2,1) ;
        tf20 = curr_echo(3,1) ;
        
        width8 = tf8 - tr8 ;   % width at 8%
        width20 = tf20 - tr20 ;   % width at 20%
        
        tr8T20 = tr20 - tr8 ; % rising-edge from 8%-20%
        tf20T8 = tf8 - tf20 ; % falling-edge from 20%-8%
        
        % trigger-level-20% is single-echo
        if (width20 <= width20_ismaxtrigger_max ) && (width20 > width20_min )
            % case #3 #29 #30
            t_caled(k, 1) = tr20 + func_peak_timing_cal('width20', width20); % using width-20% cal
            k = k+1; 
            % case #33
            if tr8T20 > tr8T20_single_echo_max                
                t_caled(k, 1) = tr8 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed cal
                k = k+1; 
            end
            % trigger-level-20% is multi-echo
        else
            % case #28
            if tr8T20 <= tr8T20_single_echo_max
                t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8T-20% cal
                k = k+1; 
                if tf20T8 <= tf20T8_single_echo_max
                    t_caled(k, 1) = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-rising-8T-20% cal
                    k = k+1; 
                end
            end
        end
    % =====================================================================
    case {6}  % only level-8% & level-20% & level-50% was triggered,  % total 10/34-cases %
        tr8  = curr_echo( curr_echo(:,2)==1 ,1) ;
        tr20 = curr_echo( curr_echo(:,2)==2 ,1) ;
        tr50 = curr_echo( curr_echo(:,2)==3 ,1) ;
        tf50 = curr_echo( curr_echo(:,2)==6 ,1) ;
        tf20 = curr_echo( curr_echo(:,2)==7 ,1) ;
        tf8  = curr_echo( curr_echo(:,2)==8 ,1) ;
        
        width8 = tf8 - tr8 ;   % width at 8%
        width20 = tf20 - tr20 ;   % width at 20%
        width50 = tf50 - tr50;  % width at 50%
        
        tr8T20 = tr20 - tr8 ; % rising-edge from 8%-20%
        tr20T50 = tr50 - tr20 ; % rising-edge from 20%-50%
        tf50T20 = tf20 - tf50 ; % falling-edge from 50%-20%
        tf20T8 = tf8 - tf20 ; % falling-edge from 20%-8%
        
        tf50T8 = tf8 - tf50 ; % falling-edge from 50%-8%
        
        % trigger-level-50% is single-echo
        if (width50 >= width50_min  ) && ( width50 < width50_ismaxtrigger_max)
            % case #2
            t_caled(k, 1) = tr50 + func_peak_timing_cal('width50', width50); % using width-50% cal
            k = k+1; 
            
            % case #26
            if ( tr20T50 > tr20T50_single_echo_max) && (tr50 < tf20)
                t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                k = k+1;    
            % case #27
            else if ( tr20T50 > tr20T50_single_echo_max) && (tr50 > tf20)
                t_caled(k, 1) = tr20 + func_peak_timing_cal('width20', width20); % using T-rising-8%-20% cal
                k = k+1; 
                end
            end
            
            % case #32
            if ( tr8T20 > tr8T20_single_echo_max) 
                t_caled(k, 1) = tr8 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed rising edge 8% cal
                k = k+1; 
            end
            
            % case #19 #21
            if ( tf50T20 > tf50T20_single_echo_max ) &&  ( tf20T8 <= tf20T8_single_echo_max ) 
                t_caled(k, 1) = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-20%-8% cal
                k = k+1; 
            end
            
            % case #20 #22 #23
            if ( tf20T8 > tf20T8_single_echo_max )
                % ignore ...  do nothing
            end
            
        % trigger-level-50% is multi-echo    
        else if ( width50 > width50_ismaxtrigger_max)
                % case #18                
                if ( tr20T50 < tr20T50_single_echo_max ) % rising edge
                    t_caled(k, 1) = tr50 + func_peak_timing_cal('tr20T50', tr20T50); % using T-rising-20%-50% cal
                    k = k+1; 
                else if ( tr8T20 < tr8T20_single_echo_max )
                    t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                    k = k+1; 
                    end
                end
                
                if ( tf50T20 < tf50T20_single_echo_max )  % falling edge
                    t_caled(k, 1) = tf50 + func_peak_timing_cal('tf50T20', tf50T20); % using T-falling-50%-20% cal
                    k = k+1; 
                else if ( tf20T8 < tf20T8_single_echo_max )
                    t_caled(k, 1) = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-20%-8% cal
                    k = k+1; 
                    end
                end
                
            % trigger-level-50% is single-echo, but jitter over spec
            else if (width50 < width50_min )
                    % case #2 #20 #22 #23 #27 #32
                    if (width20 < 9e-9) % width20 < 9ns
                        t_caled(k, 1) = tr20 + func_peak_timing_cal('width20', width20); % using width-20% cal
                        k = k+1;
                        % case #27
                        if (tr50 > tf20)
                            % to do.....
                            t_caled(k, 1) = tf50 + func_peak_timing_cal('tf50T8', tf50T8); % using T-falling-edge 50%-8% cal
                            k = k+1;
                        end
                        % case 32
                        if (tr8T20 > tr8T20_single_echo_max)
                            t_caled(k, 1) = tr8 + func_peak_timing_cal('fixed-rising-cal', 0); % using T-rising-8%-20% cal
                            k = k+1;
                        end
                    % case #19 #21 #26 
                    else % width20 > 9ns %
                        if (tr8T20 < tr8T20_single_echo_max)
                             t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                             k = k+1;
                        else 
                            t_caled(k, 1) = tr8 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed-rising-cal
                            k = k+1;
                            t_caled(k, 1) = tr20 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed-rising-cal
                            k = k+1;
                        end
                        
                        if (tf20T8 < tf20T8_single_echo_max)
                             t_caled(k, 1) = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-20%-8% cal
                             k = k+1;
                        end
                    end                    
                end
            end            
        end  
        
    % =====================================================================
    case {8}  % all 4-level level-8% & level-20% & level-50% & 90% was triggered,  % total 17/34-cases %
        tr8  = curr_echo( curr_echo(:,2)==1 ,1) ;
        tr20 = curr_echo( curr_echo(:,2)==2 ,1) ;
        tr50 = curr_echo( curr_echo(:,2)==3 ,1) ;
        tr90 = curr_echo( curr_echo(:,2)==4 ,1) ;
        tf90 = curr_echo( curr_echo(:,2)==5 ,1) ;
        tf50 = curr_echo( curr_echo(:,2)==6 ,1) ;
        tf20 = curr_echo( curr_echo(:,2)==7 ,1) ;
        tf8  = curr_echo( curr_echo(:,2)==8 ,1) ;
        
        width8 = tf8 - tr8 ;   % width at 8%
        width20 = tf20 - tr20 ;   % width at 20%
        width50 = tf50 - tr50;  % width at 50%
        width90 = tf90 - tr90;  % width at 90%
        
        tr8T20 = tr20 - tr8 ; % rising-edge from 8%-20%
        tr20T50 = tr50 - tr20 ; % rising-edge from 20%-50%
        tr50T90 = tr90 - tr50 ; % rising-edge from 50%-90%
        tf90T50 = tf50 - tf90 ; % falling-edge from 90%-50%
        tf50T20 = tf20 - tf50 ; % falling-edge from 50%-20%
        tf20T8 = tf8 - tf20 ; % falling-edge from 20%-8%
        
        tf90T20 = tf20 - tf90 ; % falling-edge from 90%-20%        
        tf90T8 = tf8 - tf90 ; % falling-edge from 90%-8%        
        tf50T8 = tf8 - tf50 ; % falling-edge from 50%-8%                
        
        % peak saturation
        if (width90 > width90_min) 
            % case #1 #5 #8 #11 #13 #14
            t_caled(k, 1)  = tr90 + func_peak_timing_cal('width90', width90); % using width-90% cal
            k = k+1; fprintf(' case #1 #5 #8 #11 #13 #14 \n'); 
            
            if (tf90T50 > tf90T50_single_echo_max) 
                % case #6 #9 
                if (tf50T20 < tf50T20_single_echo_max)  && (tf50T20 > 0)
                    
                    t_caled(k, 1)  = tf50 + func_peak_timing_cal('tf50T20', tf50T20); % using T-falling-edge-50-20% cal
                    k = k+1; fprintf(' case #6 #9 \n');
                % corner case 
                else if (tf20T8 < tf20T8_single_echo_max)  && (tf20T8 > 0)                        
                        t_caled(k, 1)  = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-edge-20-8% cal
                        k = k+1; fprintf(' case #6 #9 corner case \n');
                    end
                end                   
            % case #7 #10 #12
            else if (tf50T20 > tf50T20_single_echo_max) && (tf90T50 > 0) && (tf20T8 < tf20T8_single_echo_max)
                    t_caled(k, 1)  = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-edge-20-8% cal
                    k = k+1; fprintf('  case #7 #10 #12 \n');
                end
            end
            
            
            if ( tr50T90 > tr50T90_single_echo_max) && (tf50 > tr90) 
                % case #15
                if (tr20T50 < tr20T50_single_echo_max )
                    t_caled(k, 1) = tr50 + func_peak_timing_cal('tr20T50', tr20T50); % using T-rising-20%-50% cal
                    k = k+1; fprintf(' case #15 \n');
                % corner case
                else if (tr8T20 < tr8T20_single_echo_max )
                        t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                        k = k+1; fprintf(' case #15 corner case \n');
                    else t_caled(k, 1) = tr8 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed-rising-cal
                        k = k+1; fprintf(' case #15 corner case \n');
                        t_caled(k, 1) = tr20 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed-rising-cal
                        k = k+1;
                    end
                end
            % case #16
            else if ( tr50T90 > tr50T90_single_echo_max) && (tf50 < tr90) && (tf20 > tf90)
                    if (width50 > width50_min)
                        t_caled(k, 1) = tr50 + func_peak_timing_cal('width50', width50); % using width-50% cal
                        k = k+1; fprintf(' case #16 \n');
                    else
                        % corner case
                        if (tr20T50 < tr20T50_single_echo_max ) && (tr8T20 < tr8T20_single_echo_max )
                            t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                            k = k+1; fprintf(' case #16 corner case \n');
                        else if (tr8T20 < tr8T20_single_echo_max )
                                t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                                k = k+1; fprintf(' case #16 corner case\n');
                            else if (tr8T20 > tr8T20_single_echo_max )
                                    t_caled(k, 1) = tr8 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed-rising-cal
                                    k = k+1; fprintf(' case #16 corner case \n');
                                    t_caled(k, 1) = tr20 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed-rising-cal
                                    k = k+1; fprintf(' case #16 corner case\n');
                                end
                            end
                        end
                    end
                    % case #17
                else if ( tr50T90 > tr50T90_single_echo_max) && (tf50 < tr90) && (tf20 < tr90)
                        t_caled(k, 1) = tr20 + func_peak_timing_cal('width20', width20); % using width-20% cal
                        k = k+1; fprintf(' case #17 \n');
                        % case #24
                    else if ( tr50T90 < tr50T90_single_echo_max) && ( tr20T50 > tr20T50_single_echo_max) && (tf20 > tr90)
                            t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                            k = k+1; fprintf(' case #24 \n');
                            % case #25
                        else if ( tr50T90 < tr50T90_single_echo_max) && ( tr20T50 > tr20T50_single_echo_max) && (tf20 < tr90)
                                if (width20 > width20_min)
                                    t_caled(k, 1) = tr20 + func_peak_timing_cal('width20', width20); % using width-20% cal
                                    k = k+1; fprintf(' case #25 \n');
                                else
                                    t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                                    k = k+1; fprintf('  \n');
                                end
                                
                                % case #31
                            else if ( tr50T90 < tr50T90_single_echo_max) && ( tr20T50 < tr20T50_single_echo_max) && ( tr8T20 > tr8T20_single_echo_max)
                                    t_caled(k, 1) = tr8 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed cal
                                    k = k+1; fprintf(' case #31 \n');
                                end
                            end
                        end
                    end
                end
            end
            % peak non-saturation
        else if (width90 < width90_min)
                % case #1 #5 #7 #8 #10 #11 #12 #13 #14 #24 #25 #31
                if (tr50T90 < tr50T90_single_echo_max)                     
                    if (tf90T50 < tf90T50_single_echo_max) && (tf90T50 > 0)
                        t_caled(k, 1) = tr50 + func_peak_timing_cal('width50', width50); % using width-50% cal
                        k = k+1; fprintf(' case #1 #5 #7 #8 #10 #11 #12 #13 #14 #24 #25 #31 \n');
                    else
                        if (tr20T50 < tr20T50_single_echo_max)
                            t_caled(k, 1) = tr50 + func_peak_timing_cal('tr20T50', tr20T50); % using T-rising-20%-50% cal
                            k = k+1; fprintf(' case #1 #5 #7 #8 #10 #11 #12 #13 #14 #24 #25 #31 \n');
                        else
                            t_caled(k, 1) = tr90 + func_peak_timing_cal('tr50T90', tr50T90); % using T-rising-50%-90% cal
                            k = k+1; fprintf(' case #1 #5 #7 #8 #10 #11 #12 #13 #14 #24 #25 #31 \n');
                        end
                    end
                end
                
                if (tf90T50 > tf90T50_single_echo_max)
                    % case #6 #9
                    if (tf50T20 < tf50T20_single_echo_max)  && (tf50T20 > 0)
                        t_caled(k, 1)  = tf50 + func_peak_timing_cal('tf50T20', tf50T20); % using T-falling-edge-50-20% cal
                        k = k+1; fprintf(' case #6 #9 \n');
                        % corner case
                    else if (tf20T8 < tf20T8_single_echo_max)  && (tf20T8 > 0)
                            t_caled(k, 1)  = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-edge-20-8% cal
                            k = k+1; fprintf(' case #6 #9 corner case \n');
                        end
                    end
                    % case #7 #10 #12
                else if (tf50T20 > tf50T20_single_echo_max) && (tf90T50 > 0)
                        t_caled(k, 1)  = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-edge-20-8% cal
                        k = k+1; fprintf(' case #7 #10 #12 \n');
                    end
                end
                
                % case #15
                if ( tr50T90 > tr50T90_single_echo_max) && (tf50 > tf90)
                    t_caled(k, 1) = tr50 + func_peak_timing_cal('tr20T50', tr20T50); % using T-rising-20%-50% cal
                    k = k+1; fprintf(' case #15 \n');
                    if (tf50T20 > tf50T20_single_echo_max)
                        t_caled(k, 1)  = tf50 + func_peak_timing_cal('tf50T20', tf50T20); % using T-falling-edge-50-20% cal
                        k = k+1; fprintf(' case #15 corner case\n');
                    else if (tf20T8 > tf20T8_single_echo_max)
                            t_caled(k, 1)  = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-edge-20-8% cal
                            k = k+1; fprintf('case #15 corner case \n');
                        end
                    end
                    % case #16
                else if ( tr50T90 > tr50T90_single_echo_max) && (tf50 < tf90) && (tf20 > tf90)
                        if (width50 > width50_min)
                            t_caled(k, 1) = tr50 + func_peak_timing_cal('width50', width50); % using width-50% cal
                            k = k+1; fprintf(' case #16 \n');
                        else
                            t_caled(k, 1) = tr50 + func_peak_timing_cal('tr20T50', tr20T50); % using T-rising-20%-50% cal
                            k = k+1; fprintf(' case #16 corner case\n');
                        end
                        if (tf20T8 > tf20T8_single_echo_max)
                            t_caled(k, 1)  = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-edge-20-8% cal
                            k = k+1; fprintf(' case #16 corner case \n');
                        end
                        % case #17
                    else if ( tr50T90 > tr50T90_single_echo_max) && (tf50 < tf90) && (tf20 < tr90)
                            t_caled(k, 1) = tr20 + func_peak_timing_cal('width20', width20); % using width-20% cal
                            k = k+1; fprintf(' case #17 \n');
                            t_caled(k, 1)  = tf90 + func_peak_timing_cal('tf90T8', tf90T8); % using T-falling-edge-90-8% cal
                            k = k+1; fprintf(' case #17 \n');
                            % case #24
                        else if ( tr50T90 < tr50T90_single_echo_max) && ( tr20T50 > tr20T50_single_echo_max) && (tf20 > tr90)
                                t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                                k = k+1; fprintf(' case #24 \n');
                                if (tf50T20 > tf50T20_single_echo_max)
                                    t_caled(k, 1)  = tf50 + func_peak_timing_cal('tf50T20', tf50T20); % using T-falling-edge-50-20% cal
                                    k = k+1; fprintf(' case #24 \n');
                                else if (tf20T8 > tf20T8_single_echo_max)
                                        t_caled(k, 1)  = tf20 + func_peak_timing_cal('tf20T8', tf20T8); % using T-falling-edge-20-8% cal
                                        k = k+1; fprintf(' case #24 \n');
                                    end
                                end
                                % case #25
                            else if ( tr50T90 < tr50T90_single_echo_max) && ( tr20T50 > tr20T50_single_echo_max) && (tf20 < tr90)
                                    if (width20 > width20_min)
                                        t_caled(k, 1) = tr20 + func_peak_timing_cal('width20', width20); % using width-20% cal
                                        k = k+1; fprintf(' case #25 \n');
                                    else
                                        t_caled(k, 1) = tr20 + func_peak_timing_cal('tr8T20', tr8T20); % using T-rising-8%-20% cal
                                        k = k+1; fprintf(' case #25 \n');
                                    end
                                    if (tf90T50 > tf90T50_single_echo_max)
                                        t_caled(k, 1)  = tf50 + func_peak_timing_cal('tf50T8', tf50T8); % using T-falling-edge-50-8% cal
                                        k = k+1; fprintf(' case #25 \n');
                                    end
                                    % case #31
                                else if ( tr50T90 < tr50T90_single_echo_max) && ( tr20T50 < tr20T50_single_echo_max) && ( tr8T20 > tr8T20_single_echo_max)
                                        t_caled(k, 1) = tr8 + func_peak_timing_cal('fixed-rising-cal', 0); % using fixed cal
                                        k = k+1; fprintf(' case #31 \n');
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
end
k = k+1 ; 
output_data = t_caled;

end

