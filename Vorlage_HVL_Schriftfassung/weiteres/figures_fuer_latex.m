%Template zum Generieren von .eps und .tex Figures, um Bilder in LaTex
%darzustellen (mit LaTex-Schriftart)
i=1; %Figurenummer eingeben (das zu umwandelnde Figure muss geöffnet sein)
name = 'figure2'; %Dateiname

%%%%%%%%%%%%%%%%
hfig1 = figure(i);
figurepath = 'Y:\projects\PXIPD\04_experimental_work\DISS_S.A\DISS_July/';
set(hfig1,'units','centimeters','NumberTitle','off','Name', name);
%pos = get(hfig1,'position');
set(hfig1,'position',[10 10 8.5 6.4]); %Einstellen der Bildgrösse
matlabfrag(name);
copyfile([name,'.tex'], figurepath); %,'../../Bericht/figures/')
copyfile([name,'.eps'], figurepath);
saveas(figure(i), [name '_frag'], 'fig');

%%%%%%%%%%%%%%%%
%%%fuer die Erstellung von Label und Titel verwende:
% %title('Current $i_2$ during interruption in AC','Interpreter','none')
% xlabel('$t$ [s]','Interpreter','none')
% ylabel('$i_2$ [A]','Interpreter','none')
% grid on
% axis tight
% 
%%%zum Setzten der Bildgroesse, damit alle Bilder gleiche Erscheinung in
%%%Latex haben:
% name = 'exDC1ACvgli2';
% set(hfig1,'units','centimeters','NumberTitle','off','Name',name);
% pos = get(hfig1,'position');
% set(hfig1,'position',[pos(1:2),16,8]);
% 
%%%Erstellen der Files zum Einbinden in Latex und Speicherung an den
%%%richtigen Ort
% matlabfrag(name)
% copyfile([name,'.tex'],'../figures/')
% copyfile([name,'.eps'],'../figures/')
