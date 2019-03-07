clc
clear all
close all

A = importdata('C:\Users\dell\Desktop\rom_apd_slt_machine6.txt');

A(1:10000,2) = A(5000,2);
A(10001:20000,2) = A(15000,2);
A(20001:30000,2) = A(25000,2);

fid = fopen('C:\Users\dell\Desktop\rom_apd_slt_machine6_1.txt','w');
for i=1:30000
    fprintf(fid,'%d\t\t:\t%d;\n',A(i,1),A(i,2));
end
fclose(fid);