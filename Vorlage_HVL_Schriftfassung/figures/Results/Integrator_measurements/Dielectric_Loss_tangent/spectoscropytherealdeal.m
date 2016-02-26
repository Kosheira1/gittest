%Spectoscropy 20.02.2016


%Werte der Bauteile
Ci=0.12*10^-9;
Ri=470*10^3;
Rinf=1*10^12;
Czero=3.31*10^-9;

w=2*pi*logspace(0,4.6,1000);
tandpol=(w.*Ci*Ri.*Ci/Czero)./((1+Ci/Czero)+w.^2.*(Ci*Ri).^2);


neww_ct_no_int=[2000,2500,2700,2800,2950,3000,5000,10000];
tandpol_ct_no_int=[0.0139,0.0137,0.0173,0.01766,0.0195,0.0161,0.0144,0.0109];

neww_ct_int=[2000,2500,2600,2700,2750,2800,2850,2900,2950,3000,5000,10000];
tandpol_ct_int=1/100*[1.62,1.89,1.65,1.63,1.4,1.71,1.91,1.89,1.51,1.92,1.53,0.84];

figure(1)

semilogx(w/2/pi,tandpol, '.-')
hold on;
semilogx(neww_ct_no_int,tandpol_ct_no_int, '.', 'Color', 'r');
semilogx(neww_ct_int,tandpol_ct_int, '.', 'Color', 'g'); 
i=1;


title('Polarization losses');
xlabel('Frequency [s^{-1}]')
ylabel('tan(δ)')
hlegend= legend('C_i=0.03nF, C_{0}=2.5nF')
%plot(sqrt(1+Ci/Czero)/(Ci*Ri)/2/pi,(0.5*Ci/Czero)/(sqrt(1+Ci/Czero)), 'ro');

hText   = text(10, 0.0275, ...
  sprintf('\\it{Ri = 470 kΩ}'));
hText   = text(10, 0.0325, ...
  sprintf('\\it{R_{∞} =  ∞}'));


set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.4 .3 .3], ...
  'YTick'       , 0:0.005:8, ...
  'LineWidth'   , 1         );
