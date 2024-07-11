localopt.coef = 1;
win = hamming(length(x1));
t = smoothdata(log10(abs(fft(win.*y))),"movmedian",1000);
o = smoothdata(log10(abs(fft(win.*shiftPitch(x1,-19)))));
ratio = t - o;

% subplot(2,1,1);plot(ratio)
% 
% gain = ratio(1:end/2);
% gain = downsample(gain, 441);
% l = length(gain);
% gain(round(l/3):end) = 0;
% gain = smoothdata(gain,"lowess");
% subplot(2,1,2); plot(gain)