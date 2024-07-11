function res = LTAS( sig, fs, Noct )
% fft setting
fsResample = 1024*8;
NFFT = 1024*4;
overlapLength = round(NFFT/2);

% resample
sig = resample(sig, fsResample, fs);

% fft (done by stft)
units = @(x) 10*log10(x);
[S,f] = stft(sig,fsResample,"Window",hann(NFFT),"OverlapLength",overlapLength,"FrequencyRange","onesided");
PSDavr = units(mean(abs(S/NFFT).^2,2)); % mean PSD in DB

% smoothing
res = smoothSpectrum(PSDavr,f,Noct);
end
