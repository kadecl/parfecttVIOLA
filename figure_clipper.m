n = 1000;
t = (0:n-1)/n;

s = 1.2*sin(10*pi*t);
c = SoftClipper(s);

figure
tiledlayout(2,1)
nexttile
plot(t, s, "linewidth", 2, "displayname", "元信号")
hold on
plot(t, c, ':', "linewidth", 2, "displayname", "クリッピング後")
plot(t, abs(s), "displayname", "元信号の絶対値")
legend; xlabel("x", "Interpreter", "latex"); ylabel("振幅")

nexttile
axisfreq = t*1000;
semilogy(axisfreq, abs(fft(s)), "linewidth", 2, "displayname", "元信号")
hold on
semilogy(axisfreq, abs(fft(c)), ':', "linewidth", 2, "displayname", "クリッピング後")
semilogy(axisfreq, abs(fft(abs(s))), "linewidth", 1, "displayname", "元信号の絶対値")
xlabel("周波数 (Hz)"); ylabel("振幅")
legend; xlim([0,100]); ylabel("振幅スペクトル")