function y = changeVA2VN(s, fs, gain, ratio)
%%% gain: strongness of the effect of soft clipping
%%% ratio: mixing ratio of wet and dry

fn = fs / 2;
preAmplification = 1;
s = shiftPitch(s, -12);
x = preAmplification * s;

%% EXCITER
% highpass: 2nd order butterworth
butter_deg = 2; % harder clipping by larger degree
butter_freq = 5000; % how to detemine this ?
% our aim is to eliminate F0

[butter_b, butter_a] = butter(butter_deg, butter_freq / fn, "high");
x = filter(butter_b, butter_a, x);

% compressor

% pre-gain
x = gain * x;

% asymmetric cubic soft clipper
x = asymmetricCubicSoftClipper( x );
% post-gain
x = x / gain;

%% amplitude attenuator

%% mixer
y = s + ratio * x;
end

