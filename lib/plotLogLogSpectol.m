function spec = plotLogLogSpectol( fs, varargin )
%%% fs: sampling  frequency
%%% display input's spectol by hamming-windowing

% めんどくさいので信号長を偶数に固定
N = length(varargin{1});
for i = 2:length(varargin)
    if N > length(varargin{i})
        N = length(varargin{i});
    end
end

if mod(N, 2)
    N = N-1;
end

for i = 1:length(varargin)
    varargin{i} = varargin{i}(1:N);
end

fnq = ceil(fs/2); % ナイキスト周波数
hamWin = hamming(N);
axis_freq = fs * (1:N) / N;

% plottiong
figure
for i = 1:length(varargin)
    spec{i} = abs(fft(varargin{i} .* hamWin));
    temp = spec{i};
    loglog(axis_freq, temp); xlim([1, fnq])
    hold on
end

end