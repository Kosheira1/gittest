%Fourierreihenkoeffizienten von Trapezpuls mit 1kHz Fundamentalperiode


tr=0.5e-6;
tf=0.1e-6;
t=1e-6;

Pfund=1/(1e+3);
U0=10;
w=linspace(1e+3,1e+9,10000);
w1=w(1:20);
w2=w(21:80);
w3=w(81:10000);
%calculating the coefficients

base=2*U0./(1i*w*Pfund);
coeff=base.*(exp(1i*w*t*0.5).*sin(w*tr*0.5)./(w*tr*0.5)-exp(-1i*w*t*0.5).*sin(w*tf*0.5)./(w*tf*0.5));

%deriving the constant slope approximations
env=base.*(1./(w*tr*0.5)+1./(w*tr*0.5));
env2=base.*(1./(w*tf*0.5));
env(3);

polate1=1/800*abs(base(1))*ones(length(w1));
polate2=2*10^6*polate1(length(polate1))./(w2);
polate3=8*10^13*polate2(length(polate2))./(w3.^2);

loglog(w,abs(coeff));
hold on;
loglog(w1,polate1, 'r',  'LineWidth',2)
loglog(w2,polate2, 'g',  'LineWidth',2)
loglog(w3,polate3, 'm',  'LineWidth',2)

xlabel('Frequency')
ylabel('Amplitude of harmonics with slope envelope')

