NFFT = 128;
[Zy, fy] = getSmoothSpectol(y, fs, NFFT);
[Zx, fx] = getSmoothSpectol(x1, fs, NFFT);

% plot
figure
semilogx(fy,Zy)
hold on
semilogx(fx,Zx)
grid on