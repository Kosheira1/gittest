%Plots


%Werte der Bauteile
Ci=0.3*10^-9;
Ri=5*10^5;
Rinf=10*10^6;
Czero=2.5*10^-9;

w=2*pi*linspace(1,16000,1000);
tandpol=(w*Ci*Ri*Ci/Czero)./((1+Ci/Czero)+w.^2.*(Ci*Ri)^2);
figure
subplot(3,1,1)
plot(w,tandpol, '.-')
title('Polarization losses');
hold on
plot(sqrt(1+Ci/Czero)/(Ci*Ri),(0.5*Ci/Czero)/(sqrt(1+Ci/Czero)), 'ro');

tandlleit=(w.^2.*((Ci*Ri)^2)+1)./(w.*Czero*Rinf.*(2.+w.^2.*(Ci*Ri)^2))
subplot(3,1,2)
plot(w,tandlleit, '.-')
title('Conduction losses');


subplot(3,1,3)
plot(w,tandlleit+tandpol, '.-')
title('Combined losses');
[M,I]=max(tandlleit+tandpol);
hold on
plot(w(I),M,'ro')


