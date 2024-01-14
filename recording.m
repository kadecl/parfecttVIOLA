nbits = 16;
fs = 44100;
duration = 5;
devNum = 1;

info = audiodevinfo;
info.input(devNum)

fig = uifigure;
dialogbox = uiprogressdlg(fig,'Title','Please Wait',...
    'Message','counting in');
for i = 1:4
    dialogbox.Value = (i-1)/4;
    pause(1)
end
recorder = audiorecorder(fs, nbits, 1, devNum);
dialogbox.Value = 1;
dialogbox.Message = "recording in progress...";
record(recorder, duration);
for i=1:duration
    pause(1)
    dialogbox.Value = (i-1)/duration;
end
dialogbox.Value = 1;
pause(1);
close(dialogbox)
figure
plot(getaudiodata(recorder));
