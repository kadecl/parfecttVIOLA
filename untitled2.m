figure
subplot(2,1,1)
semilogy(axisFreq, abs(fft(sbi + sbi_harm  + nmix + tmix + 0.2*org_high)));
xlim([50, fs/2])
subplot(2,1,2); semilogy(axisFreq, abs(fft(lowpass(sbi+nWR+tOLA,fs/4,fs))))
xlim([50, fs/2])
xlabel("周波数 (Hz)")