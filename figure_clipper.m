n = 1000;
t = (0:n-1)/n;

s = 1.2*sin(10*pi*t);
c = SoftClipper(s);
e = evenHarmGenerator(s, 0, 0.5);

figure
tiledlayout(2,1)
nexttile
plot(t, s, "linewidth", 2, "displayname", "元信号")
hold on
plot(t, c, ':', "linewidth", 2, "displayname", "クリッピング処理")
plot(t, e, "displayname", "(2)による処理 A_\text{lower} = -1")
legend; xlabel("x", "Interpreter", "latex"); ylabel("振幅")

nexttile
axisfreq = t*1000;
semilogy(axisfreq, abs(fft(s)), "linewidth", 2, "displayname", "元信号")
hold on
semilogy(axisfreq, abs(fft(c)), ':', "linewidth", 2, "displayname", "クリッピング処理")
semilogy(axisfreq, abs(fft(e)), "linewidth", 1, "displayname", "(2)による処理 A_\text{lower} = -1　")
xlabel("周波数 (Hz)"); ylabel("振幅")
legend; xlim([0,100]); ylabel("振幅スペクトル")