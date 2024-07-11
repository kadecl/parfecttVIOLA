calc_coef;

% gain(6) = 0.2;
% gain(7:10)=0.3;
% gain(5) = 0.2;
% gain(9) = 0.35;
% gain(11) = 0.2;
% gain(15) = 0.4;
% gain(16) = 0.25;
% gain(17) = 0.1;
opt.coef = 1;%linfilt(gain);

figure
t = tiledlayout(5, 3);
nexttile(1,[1 3])
plot(gain)

ax1 = 2*(0:length(y)-1)/length(y);
ax2 = 2*(0:length(x1)-1)/length(x1);

nexttile(4,[2 3])
semilogy(ax1, abs(fft(y)));
hold on
%semilogy(ax2, abs(fft(shiftPitch(x1,-19))));
y1 = vn2vc(x1,opt);
semilogy(ax2, abs(fft(y1)));
xlim([0,1])

nexttile(10,[2 3])
semilogy(ax1, abs(fft(y)));
hold on
semilogy(ax2, abs(fft(x1)));


