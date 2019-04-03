clear all; clc; 


% tic
% fc = 0.5E8; fs=10E9;
% tc = gmonopuls('cutoff',fc);
% % t  = -2*tc : 1/fs : 2*tc;
% t  = 0 : 1/fs : 3*tc;   
% 
% y = gmonopuls(t,fc); 
% toc
% plot(t/1e-9,y)


load('Echo_cal_data.mat'); 

trise_cal_8p = Echo_cal_data(:,4); 
width8 = Echo_cal_data(:,26); 
width8_error = Echo_cal_data(:,27); 

figure; 
 plot(width8, trise_cal_8p);
% errorbar(trise_cal_8p,  width8, width8_error); grid on; 