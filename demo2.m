filepath = "./data/";
filename_va = "viola2.wav";

[s_va,fs] = audioread(filepath + filename_va);
if mod(length(s_va), 2)
s_va = s_va(1:end-1) * 0.8 /max(abs(s_va));
end
%sound(s_va, fs); pause(3)
N = length(s_va);
fnq = ceil(fs/2);
hamWin = hamming(N);
axis_freq = fs * (1:N) / N;

alpha = 0.5;

% 重音に弱い、トランジェントがきつい、ビブラートもきつい
%s_va_wsola = wsolaTSM(s_va, alpha);
%s_va_wsola_resample = lowpass(resample(s_va_wsola, 2, 1), fnq/2, fs);

%% setting parameters
parameter.pvSynHop = 512;
parameter.pvWin = win(2048,2); % hann
parameter.pvZeroPad = 0;
parameter.pvRestoreEnergy = 0;
parameter.pvFftShift = 0;
parPv.synHop = parameter.pvSynHop;
parPv.win = parameter.pvWin;
parPv.zeroPad = parameter.pvZeroPad;
parPv.restoreEnergy = parameter.pvRestoreEnergy;
parPv.fftShift = parameter.pvFftShift;
parPv.phaseLocking = 1;

%% adapting Phase Vocoder
yPV = pvTSM(s_va, alpha, parPv);
% yPV = wsolaTSM(s_va, alpha);
yPVr = resample(yPV,2,1);
yPVrl = lowpass(yPVr, fnq/2, fs);
%sound(yPVrl, fs); pause(length(yPVrl)/fs + 1)

% plotLogLogSpectol(fs, yPVr, s_va_wsola_resample);

gain_post = 1;
gain_pre = 1;
harm = gain_post * asymmetricCubicSoftClipper(yPVrl*gain_pre);
harm = harm * 0.8 / max(abs(harm));
edge = highpass(s_va, fnq/2, fs);

%yPVrl_edge = yPVrl + edge;
%yPVrl_harm = yPVrl + harm;
%sound(yPVrl_harm, fs); pause(length(yPVrl)/fs + 1)
%sound(harm, fs)
%% harm tanntai de yokune