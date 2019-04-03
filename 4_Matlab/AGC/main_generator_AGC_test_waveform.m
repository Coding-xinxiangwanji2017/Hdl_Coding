clc; clear all; 

% test levels 
vLevel = [1	1.5	2	3	4	6	8	10	15	20	30	40	60	80	100	150	200	300	400	600	800	1000 1200	1500	2000	2500]; 
vLevelMin = 3; 

nLevel = length(vLevel); 
%
Ntotal = 200e3; 
n = 100; 
nCycle = Ntotal/n; 

%
indV = ceil(rand(nCycle, 1)*nLevel); 
vLevelRand = vLevel(indV); 

vArbWave = []; 

for i=1:nCycle
   vTemp = ones(n,1)* max(vLevelRand(i), vLevelMin); 
   vArbWave = [vArbWave ; vTemp]; 
    
end
%subplot(2,1,1);
%plot(vLevelRand);
figure(1);
plot(vArbWave); 