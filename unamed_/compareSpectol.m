filepath = "./vc/";
files = dir(filepath);

fw = figure;
fw.Position(2) = 100;
fw.Position(3) = 800;
fw.Position(4) = 800;
tiledlayout(3,4)
for i = 3:length(files)
    s = audioread(filepath + files(i).name);

    window = hamming(length(s));
    s_windowed = s .* window;

    spectol = abs(fft(s_windowed));
    %spectol = spectol(1:ceil(length(spectol)/2));
    nexttile
    loglog(spectol)
    xlim([200, ceil(length(spectol)/2)])
    title(files(i).name, 'Interpreter','none')
end

