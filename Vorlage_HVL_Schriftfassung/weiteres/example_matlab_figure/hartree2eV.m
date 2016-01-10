
function [ deltaE ] = hartree2eV( E1,E2 );
%rechnet Energiedifferenz Anion/neutral oder Kation/neutral aus Turbomole
%in eV um (für Ionsieierungsenergien) bzw. Anlagerungsenergien

HartreeineV = 27.21138505; % NIST, 7.5.2012

deltaE = (E1 - E2)*HartreeineV;

end

