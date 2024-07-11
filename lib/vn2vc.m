function y = vn2vc(x, opt)
%%% input x: violin recording at sampling freq. fs
%%% output y: cello-like timbre sound

%y_frmnt = shiftPitch(x, -19, "LockPhase", true, "PreserveFormants",true, "CepstralOrder", 50);
y = lowpass(shiftPitch(x, -19, "LockPhase", true), 0.34);
y = conv(y, opt.coef, "same");
x_hfr = shiftPitch(x, -8);
y_HFR = highpass(highpass(x_hfr, 0.33, "Steepness", 0.9),0.45,"Steepness",0.7);

%% amplification
amp = norm(lowpass(x, 0.33))/ norm(y);

y = amp * y;
y = y + 0.25*y_HFR;
end