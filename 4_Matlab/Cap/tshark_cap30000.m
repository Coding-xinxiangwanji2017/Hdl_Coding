
clear
close all


% OneCap  = ceil(LLtoSave/25)+5; %100 udp *.pcap
top_cnt = 2; %minimum 2
frame_pcap = 125;
OneCap  = top_cnt*frame_pcap + 1; %100 udp *.pcap

capture_interface = 1; % NIC 1 % network interface card #1
capture_interface_str = ['-i ',num2str(capture_interface)];
capture_filter = 'udp and src port 3500';
capture_filter_str = [' -f "', capture_filter, '"']; %用双引号补充参数
capture_stop_str = [' -c ',num2str(OneCap)];



%% Run GSC-01
LLLnn = [];
nn = 1;
LL = []; % matrix for measured ranges
while true
 
    
    % capture_file_name = [dat_str,'-',num2str(Ang),'deg-cap',num2str(OneCap)];
    capture_file_name = ['cap',num2str(OneCap)];
    capture_file_str = [' -w ',capture_file_name,'.pcap'];
    
    %captue mode
    eval(['status = system(''tshark ', capture_interface_str, capture_stop_str, capture_file_str, capture_filter_str,' ''); '])
    assert(~status,'Capture using Tshark did not run well. Please make sure your inputs were correct.')
    
    %read mode
    eval(['status = system(''','tshark -r ',capture_file_name,'.pcap',' -T fields -e data.data',' -F k12text', ' >', capture_file_name,'.txt', ''');'])
    assert(~status,'Read using Tshark did not run well. Please make sure your inputs were correct.')
    
    fin = fopen([capture_file_name,'.txt'],'r');
    tline = fgetl(fin);
    capframeHead = [];
    capframeData = [];
    while ischar(tline) && ~isempty(tline)
        
        %processing
        tlineTrim = tline;
        tlineTrim(strfind(tlineTrim,':')) = [];
        %aa = reshape(tlineTrim,4,[])';
        %oneframe = [oneframe; aa];
        capframeHead = [capframeHead; tlineTrim(1:4)];
        
        %omit succeesive frame ID check
        % frameID = tlineTrim(5:8);
        
        %omit the last 10 word ( 40*4bit )
        capframeData = [capframeData; tlineTrim(9:end-40)];
        
        %read next
        tline = fgetl(fin);
        
    end
    fclose(fin);
    
    %find succeesive frame head 'aaaa'
    %with efficiency
    idx_aaaa = find(strcmp(cellstr(capframeHead),'aaaa'));
    oneframeData = capframeData(idx_aaaa(1):(idx_aaaa(2)-1),:);
    bb = reshape(oneframeData',8*4,[])';
    
    
    
    cc_xy(:,1)  = hex2dec( bb(:,1:4)  ) ;
    cc_xy(:,2)  = hex2dec( bb(:,5:8)  );
  
    
    tmp1  = hex2bin(  bb(:,9:16),   32);
    data1 = bin2dec(  tmp1(:, 1:(32-13)) )*0.15/100; %cm -> m
    
    tmp2  = hex2bin(  bb(:,17:24),   32);
    data2 = bin2dec(  tmp2(:,1:(32-13)) )*0.15/100; %cm -> m
    
    tmp3  = hex2bin(  bb(:,25:end),   32);
    data3 = bin2dec(  tmp3(:,1:(32-13)) )*0.15/100; %cm -> m
    
    
    dd_xy(:,1) = cc_xy(:,1) - min(cc_xy(:,1));
    dd_xy(:,1) = dd_xy(:,1)/max(dd_xy(:,1)) * pi/180*40 - pi/180*20; %
    
    
    dd_xy(:,2) = cc_xy(:,2) - min(cc_xy(:,2));
    dd_xy(:,2) = dd_xy(:,2)/max(dd_xy(:,2)) * pi/180*30 - pi/180*15;  %
%     
%     % dd_xtheta = spline(Cx, xtheta(ix), dd_xy(:,1));
%     dd_xtheta = ppval(Cx_xtheta, dd_xy(:,1));
%     % dd_ytheta = spline(Cy, ytheta(iy), dd_xy(:,2));
%     dd_ytheta = ppval(Cy_ytheta, dd_xy(:,2));
    
    
    [x1,y1,z1] = sph2cart(dd_xy(:,1),dd_xy(:,2),data1);
    [x2,y2,z2] = sph2cart(dd_xy(:,1),dd_xy(:,2),data2);
    [x3,y3,z3] = sph2cart(dd_xy(:,1),dd_xy(:,2),data3);
    % [x,y,z] = sph2cart(dd_ytheta,dd_xtheta,data1);
    
    
    
    figure(1), plot( [1:10000], [data1'], [1:10000], 10*dd_xy(:,1)' ), ylim([0, 10]) %
    figure(2), plot( [1:10000], [data2'], [1:10000], 10*dd_xy(:,1)' ), ylim([0, 10]) %
    figure(3), plot( [1:10000], [data3'], [1:10000], 10*dd_xy(:,1)' ), ylim([0, 10]) %
    figure(4), plot3(x1,y1,z1,'.')
    figure(5), plot3(x2,y2,z2,'.')
    figure(6), plot3(x3,y3,z3,'.')
    %
    %     [X1,Y1] = meshgrid(x1,y1);
    %     [X2,Y2] = meshgrid(x2,y2);
    %     [X3,Y3] = meshgrid(x3,y3);
    %     figure(1), surf(X1,Y1,z1,'.') % scatter3(x1,y1,z1,'.')
    %     figure(2), surf(X2,Y2,z2,'.') % scatter3(x2,y2,z2,'.')
    %     figure(3), surf(X3,Y3,z3,'.') % scatter3(x3,y3,z3,'.')
    %
    
    
end



dd_xy(:,1) = cc_xy(:,1) - min(cc_xy(:,1))
dd_xy(:,1) = dd_xy(:,1)/max(dd_xy(:,1));


dd_xy(:,2) = cc_xy(:,2) - min(cc_xy(:,2))
dd_xy(:,2) = dd_xy(:,2)/max(dd_xy(:,2));

load Cx_xtheta.mat
load Cy_ytheta.mat
% dd_xtheta = spline(Cx, xtheta(ix), dd_xy(:,1));
dd_xtheta = ppval(Cx_xtheta, dd_xy(:,1));
% dd_ytheta = spline(Cy, ytheta(iy), dd_xy(:,2));
dd_ytheta = ppval(Cy_ytheta, dd_xy(:,2));


[x1,y1,z1] = sph2cart(dd_xtheta,dd_ytheta,data1);

% [x,y,z] = sph2cart(dd_ytheta,dd_xtheta,data1);

figure, scatter3(x1,y1,z1)



