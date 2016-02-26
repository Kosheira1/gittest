function h=ButterworthTF(f,fc,n)
% H=ButterworthTF(f,fc,n)
% Returns the complex Butterworth filter transfer function value
% (order n, cutoff frequency fc) corresponding to the frequency f.
% Choose n=0,1,2,...,8 (0 produces a brick wall filter).

% poles
s=@(k,n) exp(1j*(2*k+n-1)*pi/(2*n));

switch n
    case 0
        h=f<=fc;
    case 1
        h=(1j*f/fc-s(1,1)).^(-1);
    case 2
        h=((1j*f/fc-s(1,2)).*(1j*f/fc-s(2,2))).^(-1);
    case 3
        h=((1j*f/fc-s(1,3)).*(1j*f/fc-s(2,3)).*(1j*f/fc-s(3,3))).^(-1);
    case 4
        h=((1j*f/fc-s(1,4)).*(1j*f/fc-s(2,4)).*(1j*f/fc-s(3,4)).*(1j*f/fc-s(4,4))).^(-1);
    case 5
        h=((1j*f/fc-s(1,5)).*(1j*f/fc-s(2,5)).*(1j*f/fc-s(3,5)).*(1j*f/fc-s(4,5)).*(1j*f/fc-s(5,5))).^(-1);
    case 6
        h=((1j*f/fc-s(1,6)).*(1j*f/fc-s(2,6)).*(1j*f/fc-s(3,6)).*(1j*f/fc-s(4,6)).*(1j*f/fc-s(5,6)).*(1j*f/fc-s(6,6))).^(-1);
    case 7
        h=((1j*f/fc-s(1,7)).*(1j*f/fc-s(2,7)).*(1j*f/fc-s(3,7)).*(1j*f/fc-s(4,7)).*(1j*f/fc-s(5,7)).*(1j*f/fc-s(6,7)).*(1j*f/fc-s(7,7))).^(-1);
    case 8
        h=((1j*f/fc-s(1,8)).*(1j*f/fc-s(2,8)).*(1j*f/fc-s(3,8)).*(1j*f/fc-s(4,8)).*(1j*f/fc-s(5,8)).*(1j*f/fc-s(6,8)).*(1j*f/fc-s(7,8)).*(1j*f/fc-s(8,8))).^(-1);
    otherwise
        h=f<=fc;
        disp('Note: only orders 1..8 are implemented in the Butterworth transfer function.');
end     
     
end