clear all; clc; 

range_max = 100; % max detection range --> 8%
vc = 299792458 ; % speed of light

fs = 1000e9; % samplign frequency

ts = transpose(0:1/fs:1e-6 ); 
nlen = length(ts) ; 


%% generate random series 
num_obj = 4; 
[ys_sum obj_distance_put]= func_echo_waveform_gen( ts,   fs, range_max , num_obj) ; 

%% obtain rising/falling trigger edges
trigger_edge  = func_echo_frame_trigger_acquire( ts, ys_sum ) ;

%% echo split

% xx = func_echo_split(trigger_edge); 

trigger_edge  = func_echo_split( trigger_edge ); 
% trigger_edge
figure(2); hold on; plot(trigger_edge(:,1), trigger_edge(:,3), '*'); hold off; 
%% peak identify

num_echo = max(trigger_edge(:,4)); 
fprintf('The total Echo number is : %g . \n', num_echo); 
echo_range_data = []; 
for k=1:1:num_echo
    fprintf('*************Starting No. %i echo : \n', k); 
    ind = find(trigger_edge(:,4) == k) ; 
    curr_echo = trigger_edge(ind, :); 
    
%     curr_echo
%     [row col] = size(curr_echo); 
    
    % temp = diff(curr_echo(:,1)).*sign(diff(curr_echo(:,3)))
    
    tempData = func_echo_timing_cal( curr_echo ) ; 
    echo_range_data = [echo_range_data ; tempData] ;  
end
sort(obj_distance_put')
echo_range_data = echo_range_data + 1930 * 10e-12 ; 
echo_range_data * vc/2
[row col] = size(echo_range_data); 
for i=1:row
    xx = echo_range_data(i,1)*ones(3,1); 
    yy = [0,0.5, 1]; 
    figure(2); hold on; plot(xx, yy,'r','LineWidth',2); hold off; 
end