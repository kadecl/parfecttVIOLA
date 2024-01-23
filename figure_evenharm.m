n = 1000;
t = (0:n-1)/n;

s = sin(10*pi*t);
c = s + 0.5 * abs(s);
c = abs(s);

figure
tiledlayout(2,1)
nexttile
plot(s, "displayname", "元信号", "linewidth", 1.5)
hold on
plot(c, ':', "linewidth", 2, "displayname", "クリッピング後")
legend; xlabel("時間"); ylabel("振幅")

nexttile
axisfreq = t * 2 * pi;
semilogy(axisfreq, abs(fft(s)),"displayname", "元信号", "linewidth", 1.5)
hold on
semilogy(axisfreq, abs(fft(c)), ':', "linewidth", 2, "displayname", "クリッピング後")
xlabel("正規化周波数[rad]")
legend; xlim([0,0.5]); ylabel("パワースペクトル")