viola = audioread("viola.wav");
vnt = audioread("viola_nontonal.wav");
vt = audioread("viola_tonal.wav");
vnt_shift= shiftPitch(vt, -12);
Fs = 44100;
%% 

v_highpass = highpass(viola,4000,Fs,ImpulseResponse="auto",Steepness=0.5);
vt_shift = vnt_shift;
%% 

sound(0.8 * vt_shift + 0.2 * v_highpass(1:length(vt)), Fs)
%% 
sound(shiftPitch(viola, -12), Fs)
%% 
sound(0.8 * shiftPitch(viola, -12) + 0.2 * v_highpass(1:length(viola)), Fs)