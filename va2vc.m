function res = va2vc( x, fs )
%%% x: input signal (double, monoral)
%%% fs: sampling frequency (hz)

params = getParamsIter;
params.gamma = 2;
[b,a] = biquad_highshelf(fs/4+1000,6,0.6,fs);
[s,t,n] = highHarmEnhanceIterSTN(filter(b,a,x), params);

%% noise
n = lowpass(resample(n,2,1),fs/4,fs);
nWR = wsolaTSM(n,0.5);

%% transients
paramOLA.tolerance = 0;
paramOLA.synHop = 256;
paramOLA.win = win(512,2); % hann window
t = lowpass(resample(t, 2, 1),fs/4,fs);
tOLA = wsolaTSM(t, 0.5, paramOLA);

%% sines
sbi = lowpass(highpass(shiftPitch(s, -12), 30,fs), fs/4, fs);
sbi_found = lowpass(sbi, 400, fs, "steepness", 0.9);

%% harmonics
amp_even = 1;
amp_odd_pre = 2;
amp_odd_post = 1;
f_cut_harm = fs/4;
sbi_odd = highpass(SoftClipper(sbi_found*amp_odd_pre)*amp_odd_post, f_cut_harm, fs, "steepness", 0.9);
sbi_even = highpass(abs(sbi_found)*amp_even, f_cut_harm, fs, "steepness", 0.9);
sbi_harm = lowpass(sbi_odd + sbi_even, 6000 ,fs, "Steepness", 0.5);
% sbi_harm = lowpass(sbi_harm, fs/3,fs, "Steepness", 0.5);

high = highpass(x,fs/4,fs,"Steepness",0.9);
l1 = length(sbi);
l2 = length(high);
resid = l2-l1;
offset = round(resid/2);
res = sbi  + nWR + tOLA + sbi_harm + high(offset+1:end-(resid-offset));
end