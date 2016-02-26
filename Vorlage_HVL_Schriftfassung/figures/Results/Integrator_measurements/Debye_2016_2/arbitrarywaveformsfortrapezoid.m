%creating arbitrary waveforms

% Defining the constant parameters

% fundamental period [s]
T=1e-3;

% fundamental frequency [Hz]
f0=1/T;

% pulse amplitude [V]
U0=1;

% pulse rise time [s]
tr=1e-5;

% pulse fall time [s]
tf=tr;

% FWHM [s]
tau=0.5e-3;


% frequencies associated with Fourier components [Hz]
nmax=1e4; % highest harmonic included in the Fourier sum
n=1:nmax;
w=2*pi*n*f0;

%{
%computing coefficients
base=4./(w*T); % [V]
coeff1=base.*(1./(w*tr).*(-(tr*cos(T*w/8).*w+sin(T*w/8-tr*w)-sin(T*w/8))));
coeff2=base.*(-(cos(3*T*w/8)-cos(T*w/8)));
coeff3=base.*(1./(w*tr).*(-(-tr*cos(3*T*w/8).*w+sin(3*T*w/8+tr*w)-sin(3*T*w/8))));
coefftot=coeff1+coeff2+coeff3;
%}

% Fourier coefficients of the trapezoidal pulse train
base=4*U0./(1i*w*T); % [V]
coeff=base.*(exp(1i*w*tau*0.5).*sin(w*tr*0.5)./(w*tr*0.5)-exp(-1i*w*tau*0.5).*sin(w*tf*0.5)./(w*tf*0.5)); % [V]


% Debye network parameters:
Ci=0.3*10^-9; % [F]
Ri=5*10^3; % [ohm]
Rinf=10*10^6; % [ohm]
Czero=2.5*10^-9; % [F]


% computing each individual current component using the debye network
% impedance
cucoeff=coeff.*((1/(Rinf)+1./(Ri+1./(1i*w*Ci))+1i*Czero*w)); % [A]



%defining time scope
t=linspace(0,+1e-3,8192);

timefunc=0;
timefunccu=0;
% time signal generation
for i=1:nmax;
   timefunc=timefunc+coeff(i)*exp(1i*w(i)*t); % [V]
   timefunccu=timefunccu+cucoeff(i)*exp(1i*w(i)*t); % [A]
end




%% Plotting

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
  'YTick'       , -1:0.5:1, ...
  'LineWidth'   , 1         );


subplot(2,1,2)
currentplot= line(t,real(timefunccu));

set(currentplot                        , ...
  'Color'           , [0 0 .5], 'LineWidth', 2, 'LineStyle', '-.'    );


title('Current signal')

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
  'YTick'       , min(real(timefunccu)):0.0001:max(real(timefunccu)), ...
  'LineWidth'   , 1         );







