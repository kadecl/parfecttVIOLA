figure
semilogy(axisFreq, abs(fft(sbi + sbi_harm  + nmix + tmix + 0.2*org_high)));
hold on;
semilogy(axisFreq, abs(fft(lowpass(sbi+nWR+tOLA,fs/4,fs))))
xlim([50, fs/2])
legend("提案法", "既存手法")
xlabel("周波数 (Hz)")