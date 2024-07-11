win = hamming(length(x1));
t = smoothdata(log10(abs(fft(win.*y))),"movmedian",4000);
o = smoothdata(log10(abs(fft(win.*shiftPitch(x1,-19)))));
ratio = t - o;
% figure
% subplot(2,1,1);plot(linspace(0,1,length(ratio)), ratio)
% 
% gain = ratio(1:end/2);
% gain = downsample(gain, 4410);
% l = length(gain);
% gain(round(l/3):end) = 0;
% gain = smoothdata(gain,"lowess");
% subplot(2,1,2); plot(gain)