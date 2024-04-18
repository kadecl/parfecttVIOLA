hamwin = hamming(fs+1);

figure
tiledlayout(3,1)
nexttile
semilogy(abs(fft(resHP(fs:2*fs).*hamwin)), "DisplayName", "HP-TSM");
xlim([50, fs/2]);  ylabel("amplitude")
legend

nexttile
semilogy(abs(fft(res(fs:2*fs).*hamwin)), "DisplayName", "proposal");
xlim([50, fs/2]);  ylabel("amplitude")
legend

nexttile
semilogy(abs(fft(truth(fs:2*fs).*hamwin)), "DisplayName", "cello's recording");
xlim([50, fs/2]); xlabel("frequency (Hz)"); ylabel("amplitude")
legend