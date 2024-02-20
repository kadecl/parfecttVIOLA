function [B,A] = biquad_highshelf(fc, gain, s, fs)
%BIQUAD_HIGHSHELF   Biquad high-shelf filter
%   [B,A] = biquad_highshelf(fc, gain, s, fs)
%
%   Input:
%      fc - shelf midpoint frequency (Hz)
%      gain - gain at the midpoint (dB)
%      s - shelf slope (S=1 for steepest slope)
%      fs - sampling frequency (Hz)
%
%   2010-01-18 by MARUI Atsushi
%              based on "Cookbook formulae for audio EQ biquad filter
%              coefficients" by Robert Bristow-Johnson.

omega = 2 * pi * fc / fs;
a = 10 ^ (gain/40);
alpha = sin(omega) / 2 * sqrt((a + 1/a) * (1/s - 1) + 2);

B = [
   a * ((a+1) + (a-1)*cos(omega) + 2*sqrt(a)*alpha)
-2*a * ((a-1) + (a+1)*cos(omega)                  )
   a * ((a+1) + (a-1)*cos(omega) - 2*sqrt(a)*alpha)
]';

A = [
       ((a+1) - (a-1)*cos(omega) + 2*sqrt(a)*alpha)
   2 * ((a-1) - (a+1)*cos(omega)                  )
       ((a+1) - (a-1)*cos(omega) - 2*sqrt(a)*alpha)
]';
