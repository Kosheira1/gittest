function eps=distancetopermit(d)

fileID=fopen('Cylindrical_LV_C0.txt','r');
formatSpec='%f';

A=csvread('Cylindrical_LV_C0.txt');
C0vector=-A(:,2);
dvector=A(:,1);

looked_up=1e12*interp1(dvector,C0vector,d) %[pF]

load('samplevariance.mat')

Nphase=25;
load('samplevariance.mat')

mean_C=mean(sample_Cmag) %[pF]
SD_C=std(sample_Cmag);    %[pF]

cStudent=tinv(1-(1-0.95)/2,Nphase-1); %student factor for 95% confidence level
twosidemargin=cStudent*SD_C/sqrt(Nphase);

eps=(3.5*looked_up/mean_C);


fclose(fileID);