
% Load audio
[orig_signal, fs] = audioread('data/viola.wav');
N = length(orig_signal);

% Pitch shift amount as a ratio
f_ratio = 2 ^ (-12 / 12);

% Shift pitch
new_signal = shift_pitch(orig_signal, fs, f_ratio);

% Plot
figure;
plot(orig_signal(1:end-1));
title('Original Signal');

figure;
plot(new_signal(1:end-1));
title('Pitch-Shifted Signal');

% Write to disk
audiowrite(sprintf('female_scale_transposed_%0.2f.wav', f_ratio), new_signal, fs);