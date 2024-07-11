function [Z, fy] = getSmoothSpectol(y, Fs, NFFT)
win = hamming(length(y));
NFFT = length(y);
Y = fft(win.*y, NFFT);
% keep only meaningful frequencies

if mod(NFFT,2)==0
    Nout = (NFFT/2)+1;
else
    Nout = (NFFT+1)/2;
end
Y = Y(1:Nout);
fy = ((0:Nout-1)'./NFFT).*Fs;

% put into dB
Y = 20*log10(abs(Y)./NFFT);

% smooth
Noct = 3;
Z = smoothSpectrum(Y,fy,Noct);
end