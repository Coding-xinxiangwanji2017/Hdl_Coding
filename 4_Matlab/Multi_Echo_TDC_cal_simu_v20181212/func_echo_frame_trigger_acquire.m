function [ trigger_edge ] = func_echo_frame_trigger_acquire( ts, ys_sum )
%FUNC_ECHO_FRAME_TRIGGER_ACUIRE Summary of this function goes here
%   Detailed explanation goes here
threshold = [0.08, 0.2, 0.5, 0.9]; 
nlen = length(ts) ; 

trigger_edge = zeros( 24, 2); 
ind_edge = 1; 
for k = 1:1:4 
    ind_temp = 1; 
    last_rising_edge = -1; 
    while ind_temp < nlen-1
        
        % rising-edge
        ind_rising = find( ys_sum(ind_temp:nlen) > threshold(k), 1); 
        
        if isempty(ind_rising) ~= 1
            ind_temp = ind_temp + ind_rising  ; 
            temp_rising_edge = ts( ind_temp -1 ) ;
            
            if (temp_rising_edge - last_rising_edge) >= 20e-9
                trigger_edge(ind_edge, 1) = ts( ind_temp -1 );
                trigger_edge(ind_edge, 2) = k;
                trigger_edge(ind_edge, 3) = threshold(k);
                fprintf('Threshold %g, Rising-edge at %g-th: time %g frameID %i ...\n', [threshold(k), ind_temp,trigger_edge(ind_edge, 1:2) ] );
                ind_edge = ind_edge + 1;
            end
            
            
            % falling-edge
            ind_falling = find( ys_sum(ind_temp:nlen) < threshold(k), 1);
            ind_temp = ind_temp + ind_falling  ;
            if (temp_rising_edge - last_rising_edge) >= 20e-9
                trigger_edge(ind_edge, 1) = ts( ind_temp -1 );
                trigger_edge(ind_edge, 2) = 9 - k; 
                trigger_edge(ind_edge, 3) = threshold(k);
                fprintf('Threshold %g, Falling-edge at %g-th: time %g frameID %i...\n', [threshold(k), ind_temp,trigger_edge(ind_edge, 1:2) ] ); 
                ind_edge = ind_edge + 1;
            end            
            last_rising_edge = temp_rising_edge; 
        else 
            ind_temp = nlen ;             
        end               
    end
end

%% sorting triggered edge sequence
trigger_edge = sortrows(trigger_edge); 
[row col] = size(trigger_edge) ; 
trigger_edge(25:row, :) = []; 

end

