% plottet Potentialkurven Von SF6

clear all  % deletes all variables
close all  % closes all figures

% load the data from textfile (annotations in text-file must start with %)
data = load('.\N2_potentialcurve.txt');
data_kation = load('.\N2_potentialcurve_kation.txt');

% load a *.mat file
% load potential_curves_N2.mat


% Data handling 
R = data(:,1);
E_hartree = data(:,2);

R_kat = data_kation(:,1);
E_hartree_kat = data_kation(:,2);

E = hartree2eV(E_hartree,0);
E_kat = hartree2eV(E_hartree_kat,0);


% plot the figure
figure(1);  % opens the figure No. 1
set(gcf, 'Units', 'centimeters'); % could also be 'normalized' or 'points' or .....
set(gcf, 'Position', [1 3 20 12]); % [left bottom width height]
set(gcf, 'PaperPositionMode', 'auto');  % ensure that on the printout it looks like on the screen
 
get(gcf) % to see what other commands are possible gcf="get current figure"

% plot the data
h1 = axes('Position',[ 0.1300    0.5    0.7750    0.35]);
plot(R,E,'k-d','linewidth',2,'markersize',7,'markerfacecolor','k');
hold on; grid on;
plot(R_kat,E_kat,'k--o','linewidth',2,'markersize',7,'markerfacecolor','k');
set(h1,'Fontsize',14);
set(h1,'XLim',[0 6.5],'YLim',[-3000 -2900],'XTickLabel',[]);
title('DFT calculation of N_2-total energy');
leg=legend('N-N','N-N^+');
set(leg,'Location','Best','fontsize',8);

% annotation(gcf,'textbox',[0 0 0.1 0.1],'String','a)','FontSize',8,'LineStyle','none','FontWeight','bold') 

h2 = axes('Position',[ 0.1300    0.1    0.7750    0.35]);
plot(R,E,'k-d','linewidth',2,'markersize',7,'markerfacecolor','k');
xlabel('R [a_0]');
ylabel('E [eV]');


print -depsc potential_curve_N2.eps
print -djpeg100 -r200 potential_curve_N2.jpg
print -dpng potential_curve_N2.png

