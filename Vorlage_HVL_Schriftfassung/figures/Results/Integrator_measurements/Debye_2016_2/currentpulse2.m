% Fourierreihenkoeffizienten des Strompulses

% Defining the constant parameters

% fundamental period [s]
T=1e-3;

% fundamental frequency [Hz]
f0=1/T;

% pulse amplitude [V]
U0=10;

% pulse rise time [s]
tr=1e-6;

% pulse fall time [s]
tf=tr;

% FWHM [s]
tau=0.5e-3;

% frequencies associated with Fourier components [Hz]
nmax=1e4; % highest harmonic included in the Fourier sum
n=1:nmax;
w=2*pi*n*f0;


% Debye network parameters:
Ci=0.3*10^-9; % [F]
Ri=5*10^3; % [ohm]
Rinf=10*10^6; % [ohm]
Czero=2.5*10^-9; % [F]


% Fourier coefficients of the trapezoidal pulse train
base=2*U0./(1i*w*T); % [V]
coeff=base.*(exp(1i*w*tau*0.5).*sin(w*tr*0.5)./(w*tr*0.5)-exp(-1i*w*tau*0.5).*sin(w*tf*0.5)./(w*tf*0.5)); % [V]

% computing each individual current component using the debye network
% impedance
cucoeff=coeff.*((1/(Rinf)+1./(Ri+1./(1i*w*Ci))+1i*Czero*w)); % [A]

figure(1) % Fourier coefficients (amplitude)

step=ceil(length(w)/1000);

loglog(w(1:step:length(w)),abs(coeff(1:step:length(w))),'-.r',w(1:step:length(w)),abs(cucoeff(1:step:length(w))),'-.b');
title('Magnitude of Fourier coefficients of trapezoidal pulse train')
legend('Voltage', 'Current')

t=linspace(-0.5e-3,+0.5e-3,20000); % time axis [s]
timefunc=0;
timefuncfilter=0;
timefunccu=0;
timefunccufilter=0;

% Butterworth filter transfer function
fc=1e5; % cutoff frequency [Hz]
norder=8; % filter order

hBW=ButterworthTF(w/(2*pi),fc,norder);

% recreating the time signals
% note: could be done more efficiently by using matrix multiplication


%Cancer
%timefunc=sum(bsxfun(@times,exp(1i*w'*t),coeff'));               %[V]
%timefunccu=sum(bsxfun(@times,exp(1i*w'*t),cucoeff'));         % [A]
%timefuncfilter=sum(bsxfun(@times,exp(1i*w'*t),hBW'.*coeff')); % [V]
%timefunccufilter=sum(bsxfun(@times,exp(1i*w'*t),hBW'.*cucoeff'));   % [A]

for i=1:nmax;
   timefunc=timefunc+coeff(i)*exp(1i*w(i)*t); % [V]
    timefuncfilter=timefuncfilter+hBW(i)*coeff(i)*exp(1i*w(i)*t); % [V]
   timefunccu=timefunccu+cucoeff(i)*exp(1i*w(i)*t); % [A]
    timefunccufilter=timefunccufilter+hBW(i)*cucoeff(i)*exp(1i*w(i)*t); % [A]
end

figure(2) % time domain signals


subplot(2,1,1)
voltplot= line(t,real(timefunc));

set(voltplot                         , ...
  'Color'           , [0 0 .5], 'LineWidth', 2, 'LineStyle', '-.'    );


title('Voltage signal')

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
  'YTick'       , -5:2:5, ...
  'LineWidth'   , 1         );



subplot(2,1,2)
currentplot= line(t,real(timefunccu));
title('Current signal')

set(currentplot                         , ...
  'Color'           , 'r', 'LineWidth', 2, 'LineStyle', '-.'    );



vlabel=xlabel('Time [s]')
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
  'YTick'       , 0:5*1e-4:5*1e-3, ...
  'LineWidth'   , 1         );



figure(3) % filtered time domain signals


subplot(2,1,1)
plot(t,real(timefuncfilter));
title('Filtered Voltage signal')


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
  'YTick'       , -5:2:5, ...
  'LineWidth'   , 1         );

subplot(2,1,2)
plot(t,real(timefunccufilter), 'Color', 'r');
title('Filtered Current signal')

vlabel=xlabel('Time [s]')
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
  'YTick'       , 0:5*1e-4:5*1e-3, ...
  'LineWidth'   , 1         );


