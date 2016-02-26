%Plots


%Werte der Bauteile
Ci=[0.03*10^-9 0.06*10^-9 0.12*10^-9 0.12*10^-9];
Ri=470*10^3;
Rinf=1*10^12;
Czero=[2.5*10^-9 2.75*10^-9 3.3*10^-9 3.31*10^-9];

w=2*pi*logspace(0,5,100)
tandpol=zeros(100);
length(tandpol)
length(w)
tandpol(:,1)=w;
for i=1:4
tandpol(:,i)=(w.*Ci(i)*Ri.*Ci(i)/Czero(i))./((1+Ci(i)/Czero(i))+w.^2.*(Ci(i)*Ri).^2);
end
figure
subplot(2,1,1)



%semilogx(f,tandpol(:,4), '.-')
hold on
%plot(sqrt(1+Ci(4)/Czero(4))/(Ci(4)*Ri),(0.5*Ci(4)/Czero(4))/(sqrt(1+Ci(4)/Czero(4))), 'ro');
for i=1:4
semilogx(w/(2*pi),tandpol(:,i), '.-')
plot(sqrt(1+Ci(i)/Czero(i))/(Ci(i)*Ri),(0.5*Ci(i)/Czero(i))/(sqrt(1+Ci(i)/Czero(i))), 'ro');
(sqrt(1+Ci(4)/Czero(4))/(Ci(4)*Ri))
end


title('Polarization losses');
xlabel('Frequency [rad s^{-1}]')
ylabel('tan(δ)')
%hlegend= legend('C_i=0.03nF, C_{0}=2.5nF','ω_{max}@6.9kHz','C_i=0.06nF, C_{0}=2.75nF', ...
   % 'ω_{max}@67kHz','C_i=0.12nF, C_{0}=3nF','ω_{max}@33kHz','C_i=0.3nF, C_{0}=3.25nF','ω_{max}@17kHz', 'Location', 'northwest')


hText   = text(10, 0.0275, ...
  sprintf('\\it{Ri = 500 kΩ}'));
hText   = text(10, 0.0325, ...
  sprintf('\\it{R_{∞} = 10 MΩ }'));


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


tandlleit=zeros(100);
tandlleit(:,1)=w;

for i=1:4
tandlleit(:,i)=i*(w.^2.*((Ci(i)*Ri)^2)+1)./(w.*Czero(i)*Rinf.*(2.+w.^2.*(Ci(i)*Ri)^2));
end
subplot(2,1,2)
semilogx(w/(2*pi),tandlleit(:,5), '.-')

hold on
for i=1:4
semilogx(w/(2*pi),tandlleit(:,i), '.-')
end
title('Conduction losses');
xlabel('Frequency [s^{-1}]')
ylabel('tan(δ)_{l}')



%subplot(3,1,3)
%plot(w,tandlleit+tandpol, '.-')
%title('Combined losses');
%[M,I]=max(tandlleit+tandpol);
%hold on
%plot(w(I),M,'ro')


