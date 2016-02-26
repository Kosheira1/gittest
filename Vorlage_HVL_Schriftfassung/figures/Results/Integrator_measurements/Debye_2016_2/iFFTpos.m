function [s,taxis]=iFFTpos(faxis,cFFTpos)
% [s,taxis]==iFFTpos(faxis,cFFTpos)
% reconstructs the (real) time domain signal s from the positive frequency
% components cFFTpos and the corresponding frequency values faxis [Hz].
% It is the inverse transform of [cFFTpos,faxis]=FFTpos(dt,s).

% positive Fourier coeff. from 0 to Nmax
Nmax=length(faxis)-1;

% number of points in time domain signal s
if ~isreal(cFFTpos(Nmax+1)) %  Npoints is odd
    Npoints=2*Nmax+1;
else % Npoints is even
    Npoints=2*Nmax;
end
%Npoints=2*Nmax;

% total measurement interval [s]
T=Nmax/faxis(end);

% interval between sampled signal points [s]
dt=T/Npoints;

% time axis [s]
taxis=0:dt:T-dt; % Npoints
taxis=taxis'; % vertical

% recover signal
s=real(exp(1j*taxis*2*pi*faxis')*cFFTpos);
% NOTE: this is obviously computationally more costly (~N^2) than the FFT
% (~N log(N))



end