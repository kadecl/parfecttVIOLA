ax1 = (0:length(y)-1) * fs / length(y);
semilogy(ax1, abs(fft(y)))
hold on;

ax2 = (0:length(x1)-1) * fs / length(x1);
semilogy(ax2, abs(fft(shiftPitch(x1,-19))))
xlim([0,fs/2])