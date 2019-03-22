% V4 is based on V2, and is dedicated for internal debug
clc;
clear all;
close all;
% 

fileName = 'bug4.pcap';

id = fopen(fileName);


HdPcap = 24;
HdLL = 16;
HdUDP = 42;
LenData = 1304;
TotFr = 0;
PktPerFr = 125;
PntPerPkt = 80;
BytePerPnt = 16;
Frame =20; % FPS
PntPerSec = 200000;

TotByte = dir(fileName);
TotPkt = (TotByte.bytes-HdPcap)/(HdLL+HdUDP+LenData);
fclose(id);

BgnPkt = 0;




id = fopen(fileName);
for i=1:1:TotPkt
    
    if i==1
        fseek(id,HdPcap+HdLL+HdUDP,'bof');
        tempchar = dec2hex(fread(id,2,'uint8'));
    else
        fseek(id,HdLL+HdUDP+LenData-2,'cof');
        tempchar = dec2hex(fread(id,2,'uint8'));
    end
    
    if (tempchar ==['AA';'AA'])
        TotFr = floor((TotPkt-i+1)/PktPerFr);
        BgnPkt = i;
        break;
    end    
end
fclose(id);


%===========================Ethernet integrity Test==============================
id = fopen(fileName);
AAtotal = 0;
AAcnt=zeros(TotFr,1);
CCcnt=zeros(TotFr,1);
PktCntFlag = 0;
TotFrFlag = 0;
FirstFlag = 0;
StartingPkt = 0;
for i=1:1:TotPkt
    
    if i==1
        fseek(id,HdPcap+HdLL+HdUDP,'bof');
        tempchar = dec2hex(fread(id,2,'uint8'));
    else
        fseek(id,HdLL+HdUDP+LenData-2,'cof');
        tempchar = dec2hex(fread(id,2,'uint8'));
    end
    

%     tempchar
   if (FirstFlag ==1)
    if (tempchar ==['AA';'AA'])
        PktCntFlag = 0;
        TotFrFlag = TotFrFlag +1;
        PktCntFlag = PktCntFlag +1; 
        AAcnt(TotFrFlag,1) = PktCntFlag;
        
    else if (tempchar ==['CC';'CC'])  
        PktCntFlag = PktCntFlag +1; 
        CCcnt(TotFrFlag,1) = PktCntFlag;
        end
    end
   else if ((FirstFlag ==0))
       if (tempchar ==['AA';'AA'])
        FirstFlag=1;
        PktCntFlag = 0;
        TotFrFlag = TotFrFlag +1;
        PktCntFlag = PktCntFlag +1; 
        AAcnt(TotFrFlag,1) = PktCntFlag;
        StartingPkt=i;
       end
       end
   end
   
   if (FirstFlag ==1)
       if ((tempchar ==['AA';'AA']))
        if (mod((i-StartingPkt),PktPerFr)==0)
    AAtotal = AAtotal +1;
        end
       end
   end
end
AAtotal
fclose(id);






%=======================================================================




id = fopen(fileName);

for SelFr = 1:50
% SelFr =20;
Azimuth=zeros(PntPerSec/Frame,1);
Elevation=zeros(PntPerSec/Frame,1);
Intensity=zeros(PntPerSec/Frame,1);
Temperature=zeros(PntPerSec/Frame,1);
Stop1=zeros(PntPerSec/Frame,1);
Stop2=zeros(PntPerSec/Frame,1);
Stop4=zeros(PntPerSec/Frame,1);
AD7547=zeros(PntPerSec/Frame,1);
for j =1:PktPerFr
    for k=1:PntPerPkt
        index = HdPcap + (BgnPkt-1)*(HdLL+HdUDP+LenData)+ (SelFr-1)*PktPerFr*(HdLL+HdUDP+LenData);
        index = index+ (j-1)*(HdLL+HdUDP+LenData) +HdLL+HdUDP + (k-1)*BytePerPnt+4;
        fseek(id,index,'bof');
        Azimuth(k+(j-1)*PntPerPkt)=fread(id,1,'uint16','b');
        Elevation(k+(j-1)*PntPerPkt)=fread(id,1,'uint16','b');
        Intensity(k+(j-1)*PntPerPkt)=fread(id,1,'uint16','b');
        Temperature(k+(j-1)*PntPerPkt)=fread(id,1,'uint16','b');
        Stop1(k+(j-1)*PntPerPkt)=fread(id,1,'uint16','b');
        Stop2(k+(j-1)*PntPerPkt)=fread(id,1,'uint16','b');
        Stop4(k+(j-1)*PntPerPkt)=fread(id,1,'uint16','b');
        AD7547(k+(j-1)*PntPerPkt)=fread(id,1,'uint16','b');
    end
    
end
Azimuth_Record(:,SelFr) = Azimuth; 
Elevation_Redord(:,SelFr) = Elevation; 
Intensity_Record(:,SelFr) = Intensity; 
Stop1_Record(:,SelFr) =  Stop1; 

figure(7)
% contour(Azimuth,Elevation,Stop1);
scatter(Azimuth,Elevation,[],Stop1*5,'filled','d');
pause(0.1); 
end

fclose(id);

figure(1);
subplot(2,2,1)
plot(Stop1);
title('Stop1');
subplot(2,2,2)
plot(Stop2);
title('Stop2');
subplot(2,2,3)
plot(Stop4);
title('Stop4');
subplot(2,2,4)
plot(AD7547);
title('AD7547');


figure(2);
subplot(2,2,1)
% plot(Azimuth);
plot(Azimuth);
title('Azimuth');
subplot(2,2,2)
% plot(Elevation);
plot( Elevation);
title('Elevation');
subplot(2,2,3)
plot(Temperature);
title('Temperature');
subplot(2,2,4)
plot(Intensity);
title('Intensity');


figure(5);
subplot(2,2,1)
% plot(Azimuth);
plot(1:length(Azimuth), Azimuth_Record);
title('Azimuth');
subplot(2,2,2)
% plot(Elevation);
plot(1:length(Azimuth), Elevation_Redord);
title('Elevation');
subplot(2,2,3)
plot(1:length(Stop1), Stop1_Record);
title('Stop1');
subplot(2,2,4)
plot(Intensity);
title('Intensity');


figure(3);
x=normrnd(1,0.5,1,1000);
xmin=min(x);
xmax=max(x);
xp=linspace(xmin,xmax,20);
f=ksdensity(x,xp);
plot(xp,f,'*');

figure(4); 
plot(Azimuth_Record, Elevation_Redord) ; 


figure(7)
% contour(Azimuth,Elevation,Stop1);
scatter(Azimuth,Elevation,[],Stop1*5);

