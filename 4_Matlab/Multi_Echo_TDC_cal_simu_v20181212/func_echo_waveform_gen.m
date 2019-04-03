function [ ys_sum, obj_distance_put ] = func_echo_waveform_gen( ts,   fs, range_max , num_obj)
%FUNC_ECHO_WAVEFORM_GEN Summary of this function goes here
%   Detailed explanation goes here
vc = 299792458 ; % speed of light

obj_whether_put = ( rand(1,4) > 0.5); 
obj_distance_put = range_max * rand(1,4) ; 
obj_reflect_ratio = rand(1,4); 

% generate adjacent objects
obj_distance_put(2) = obj_distance_put(1) + 2*rand(1); 

ys = zeros(size(ts)); 
ys_sum = ys; 
for ind = 1:1:num_obj
    ampl = obj_reflect_ratio(ind) * (range_max / obj_distance_put(ind))^2; 
    
    ind_start = round(obj_distance_put(ind)/vc*2*fs)+1; 

    tempwave = func_Tx_pulse_gen( fs ) * ampl ;
    
    [row col] = size(tempwave); 
    tempewave_align = ys; 
    tempewave_align(ind_start:1:(ind_start+row-1)) = tempwave(:,2); 
    ys_sum = ys_sum + tempewave_align ; 
    
%     figure(1); 
%     plot(ts, tempewave_align,'.'); hold on; ylim([0,1]); 
end
% hold off;
[ind_Saturate C] = find(ys_sum > 1) ; 
ys_sum( ind_Saturate) = 1; 
figure(2); plot(ts, ys_sum,'.'); ylim([0,1]); 


end

