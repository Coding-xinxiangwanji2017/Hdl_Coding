clc;
clear all;
%% capture range 0~2048;
%% Gain Range 0~10^2.5;
%%
% Gain = 10^(2.5 - AgcVol/600);

% test levels 
vLevel = [1	1.5	2 3	4 6 6.5 5 4 4.5 5 5.5 6 6.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5]; 
vLevelMin = 10; 
nLevel = length(vLevel); 

%Point
Ntotal = 200e3; 
n = 100; 
nCycle = Ntotal/n;

%%Àƒ…·ŒÂ»Î
Vol = ceil(rand(nCycle,1)*nLevel); %%nCycle*1
VolData = vLevel(Vol); %%1*nCycle
VolRand = ones(1,nCycle);
for k = 1:nCycle
    VolRand(1,k) = VolRand(1,k)*max(VolData(k),vLevelMin);
end 
subplot(2,1,1);
% figure(1);
plot(VolRand);

Gain = ones(1,nCycle);
CmpData = ones(1,nCycle);
%% Gain
i = 1;
while (i <= nCycle)
    % for i = 1:nCycle
    if (i == 1)
        AgcVol = 1000;
        GainTemp = 10^(2.5 - AgcVol/600);
        Gain(1,1) = Gain(1,1)*GainTemp;
    elseif (1 < i && i < 5) 
        CmpData(1,i) = CmpData(1,i)*ceil(Gain(1,i-1) * VolRand(1,i-1));
        if (CmpData(1,i) <= 100)
            if (AgcVol > 540)
                AgcVol = AgcVol - 540;
            else
                AgcVol = 0;
            end
        elseif (100 < CmpData(1,i) && CmpData(1,i)<= 200)
            if (AgcVol > 360) 
                AgcVol = AgcVol - 360;
            else
                AgcVol = 0;
            end
        elseif (200 < CmpData(1,i) && CmpData(1,i) <= 300)
            if (AgcVol > 180) 
                AgcVol = AgcVol - 180;
            else
                AgcVol = 0;
            end
        elseif (1200 < CmpData(1,i) && CmpData(1,i) <= 1500)
            if (AgcVol < 1320)
                AgcVol = AgcVol + 180;
            else
                AgcVol = 1500;
            end
        elseif (1500 < CmpData(1,i) && CmpData(1,i) <= 2048)
            if (AgcVol < 1140)
                AgcVol = AgcVol + 360;
            else
                AgcVol = 1500;
            end
        end
        Gain(1,i) = Gain(1,i)*10^(2.5 - AgcVol/600);
      elseif (i >= 5)
        CmpData(1,i) = CmpData(1,i)*ceil((Gain(1,i-1)*VolRand(1,i-1) + Gain(1,i-2)*VolRand(1,i-2)+ Gain(1,i-3)*VolRand(1,i-3)+ Gain(1,i-4)*VolRand(1,i-4))/4);
        if (CmpData(1,i) <= 100)
            if (AgcVol > 540)
                AgcVol = AgcVol - 540;
            else
                AgcVol = 0;
            end
        elseif (100 < CmpData(1,i) && CmpData(1,i)<= 200)
            if (AgcVol > 360) 
                AgcVol = AgcVol - 360;
            else
                AgcVol = 0;
            end
        elseif (200 < CmpData(1,i) && CmpData(1,i) <= 300)
            if (AgcVol > 180) 
                AgcVol = AgcVol - 180;
            else
                AgcVol = 0;
            end
        elseif (1200 < CmpData(1,i) && CmpData(1,i) <= 1500)
            if (AgcVol < 1320)
                AgcVol = AgcVol + 180;
            else
                AgcVol = 1500;
            end
        elseif (1500 < CmpData(1,i) && CmpData(1,i) <= 2048)
            if (AgcVol < 1140)
                AgcVol = AgcVol + 360;
            else
                AgcVol = 1500;
            end
        end
        Gain(1,i) = Gain(1,i)*10^(2.5 - AgcVol/600);
    end
    i = i + 1;
end
subplot(2,1,2);
plot(CmpData);
title('TestData');
VolResult = find(300 < CmpData & CmpData <= 1200);
Gainlen = length(VolResult);
Number = Gainlen/nCycle;
fprintf('efficiency : %2f%%\n',Number*100);