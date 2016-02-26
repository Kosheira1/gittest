%Fourierreihenkoeffizienten des Strompulses


%Defining the (hopefully) constant parameters
Pfund=1/(1e+3);
U0=10;
n=linspace(1,10000,10000);
w=2*pi*1e+3*n;

tr=0.2e-6;
tf=0.2e-6;
tla=1e-6;

Ci=0.3*10^-9;
Ri=5*10^5;
Rinf=10*10^6;
Czero=2.5*10^-9;


%using the fourier coefficients of the signal pulse
base=2*U0./(1i*w*Pfund);
coeff=base.*(exp(1i*w*tla*0.5).*sin(w*tr*0.5)./(w*tr*0.5)-exp(-1i*w*tla*0.5).*sin(w*tf*0.5)./(w*tf*0.5));

%computing each individual current component using the debye network's
%impedance
cucoeff=coeff.*((1/(Rinf)+1./(Ri+1./(1i*w*Ci))+1i*Czero*w));

%plotting fourier coefficients
figure

loglog(w(1:10:length(w)),abs(coeff(1:10:length(w))),'-.r',w(1:10:length(w)),abs(cucoeff(1:10:length(w))),'-.b');
title('Fourier coefficients of the signals applied to the network')
legend('Voltage', 'Current');
xlabel('Frequency [rad s^{-1}]');
ylabel('Coefficients: Current [A], Voltage[V]');

t=linspace(-1e-3,+1e-3,10000);
timefunc=0;
timefunccu=0;

%recreating the time signals
%for i=1:10000;
    %timefunc=timefunc+coeff(i)*exp(1i*w(i)*t);
    %timefunccu=timefunccu+cucoeff(i)*exp(1i*w(i)*t);
%end

%With matrix multiplication

timefunc=sum(bsxfun(@times,exp(1i*w'*t),coeff'));
timefunccu=sum(bsxfun(@times,exp(1i*w'*t),cucoeff'));


figure('Units', 'pixels', ...
       'Position', [100 100 500 375]);
hold on

subplot(2,1,1)

%plotting the voltage function
voltplot= line(t,timefunc);
title('Voltage signal')
set(voltplot                         , ...
  'Color'           , [0 0 .5], 'LineWidth', 2, 'LineStyle', '-.'    );

vlabel=xlabel('Time [s]')
vylabel=ylabel('Voltage [V]')
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.4 .3 .3], ...
  'YTick'       , 0:2:10, ...
  'LineWidth'   , 1         );

hText   = text(1e-6, 8, ...
  sprintf('\\it{τ_{rise} = τ_{fall}=%0.1gμs  }', ...
  0.2));
hText   = text(1e-6, 6, ...
  sprintf('\\it{Fundamental Period=%0.1gms  }', ...
  1));

%plotting the current function

subplot(2,1,2)
currentplot= line(t,timefunccu, 'Color', 'r');
title('Current signal')

set(currentplot                         , ...
  'Color'           , 'r', 'LineWidth', 2, 'LineStyle', '--'    );

vxlabel=xlabel('Time [s]')
vylabel=ylabel('Current [A]')
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.4 .3 .3], ...
  'YTick'       , -0.15:0.05:0.15, ...
  'LineWidth'   , 1         );




%Filtered coefficients and measured time signals
