function [cFFTpos,faxis]=FFTpos(dt,s)
% FFTpos(deltat,signal)
% Calculates the one-sided Fourier transform of the signal "s", assumed to be
% real and sampled equidistantly at intervals "dt" [s].
% Returns the complex positive frequency Fourier amplitudes "cFFTpos" and
% the corresponding frequencies in "faxis" [Hz].
% Note: the following holds:
% s(t_m)=Re[ sum_n=0^Nmax cFFTpos(n)*exp(j*omega_n*t_m)]
% where omega_n=n*2*pi/T.

% number of data points
Npoints=length(s);

% make s vertical, if it isn't already
if size(s,2)>1
   s=s'; 
end

% total measurement interval [s]
T=Npoints*dt; 

% spectrum cutoff point Nmax (=integer) for real-valued signals
% (i.e. redundant information in DFT coefficients will be discarded)
if mod(Npoints,2)==0 % Npoints is even
    Nmax=Npoints/2;
else % Npoints is odd
    Nmax=(Npoints-1)/2;
end

% frequency axis
faxis=((0:Nmax)/T); 
faxis=faxis'; % vertical vector

% FFT
cFFTtwosided=fft(s)/Npoints; % scaling is chosen such that the 1/Npoints is not needed in the inversion formula

% truncate spectrum to remove redundant information (real-valued data assumed)
cFFTonesided=cFFTtwosided(1:Nmax+1); % note that the frequency index ranges from 0 to Nmax (accessed in Matlab by indices 1:Nmax+1)

% complex positive frequency Fourier coefficients
cFFTpos=2*cFFTonesided;
cFFTpos(1)=cFFTpos(1)/2; % dc component must not be doubled
if mod(Npoints,2)==0
   cFFTpos(Nmax+1)=cFFTpos(Nmax+1)/2; % if Npoints is even, the highest frequency component must not be doubled (it is also real, as is the dc value)
end

end