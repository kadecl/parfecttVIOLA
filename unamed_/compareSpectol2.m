fw2 = figure;
fw2.Position(2) = 100;
fw2.Position(3) = 800;
fw2.Position(4) = 800;
%tiledlayout(2,1)

[s, fs] = audioread("./va/va_e3.wav");
axisFreq = (0:length(s)-1) * fs / length(s);

[s, fs] = audioread("./vc/vc_e2.wav");
window = hamming(length(s));
s_windowed = s .* window;
spectol = abs(fft(s_windowed));
%nexttile
p = semilogy(axisFreq, spectol, "DisplayName", "チェロの振幅スペクトル (E3)");
%p.Color(4) = 0.4;

hold on

window = hamming(length(s));
s_windowed = s .* window;
spectol = abs(fft(s_windowed));
spectol(length(s)/2+1:end) = 0;
semilogy(0.5*axisFreq, spectol, "DisplayName", "ヴィオラの振幅スペクトル (E4）を"...
    +newline +"本来の周波数の1/2の位置に配置したもの");

legend("location", "southwest")
xlim([100, fs/2])
%ylim([1e-2, 1e4])
xlabel("Frequency (Hz)")
ylabel("Power spectol")