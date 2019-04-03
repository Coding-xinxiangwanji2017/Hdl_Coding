function [output ] = func_Tx_pulse_gen(fs) 

fc = 0.5E8; 
% fs=10E9;
tc = gmonopuls('cutoff',fc);
% t  = -2*tc : 1/fs : 2*tc;
t  = transpose(0 : 1/fs : 3*tc);   

y = gmonopuls(t,fc); 

output = [t, y]; 

end