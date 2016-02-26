%Setup-variance when re-inserting the sample

Nphase=25;
load('samplevariance.mat')

mean_C=1e12*mean(sample_Cmag); %[pF]
SD_C=1e12*std(sample_Cmag);    %[pF]

cStudent=tinv(1-(1-0.95)/2,Nphase-1); %student factor for 95% confidence level
twosidemargin=cStudent*SD_C/sqrt(Nphase);

load('systemvariance.mat');
bar_margin=(ones(1,25))*error_margin;
length(bar_margin)
errorbar(sample_Cmag,bar_margin);

ylabel('Capacitance [pF]')

    
   