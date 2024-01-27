n = 1000;
t = (0:n-1)/n;

s = 1.2*sin(10*pi*t);
c = SoftClipper(s);

figure
tiledlayout(2,1)
nexttile
plot(s, "linewidth", 2, "displayname", "元信号")
hold on
plot(c, ':', "linewidth", 2, "displayname", "クリッピング後")
plot(abs(s), "displayname", "元信号の絶対値")
legend; xlabel("時間"); ylabel("振幅")

nexttile
axisfreq = t * 2 * pi;
semilogy(axisfreq, abs(fft(s)), "linewidth", 2, "displayname", "元信号")
hold on
semilogy(axisfreq, abs(fft(c)), ':', "linewidth", 2, "displayname", "クリッピング後")
semilogy(axisfreq, abs(fft(abs(s))), ':', "linewidth", 2, "displayname", "元信号の絶対値")
xlabel("正規化周波数[rad]"); ylabel("振幅")
legend; xlim([0,0.5]); ylabel("振幅スペクトル")