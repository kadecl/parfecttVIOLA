function shifted_signal = shift_pitch(signal, fs, f_ratio)
    % Calls psola pitch shifting algorithm
    % signal: original signal in the time-domain
    % fs: sample rate
    % f_ratio: ratio by which the frequency will be shifted
    
    peaks = find_peaks(signal, fs);
    shifted_signal = psola(signal, peaks, f_ratio);
end

function peaks = find_peaks(signal, fs, max_hz, min_hz, analysis_win_ms, max_change, min_change)
    % Find sample indices of peaks in time-domain signal
    % max_hz: maximum measured fundamental frequency
    % min_hz: minimum measured fundamental frequency
    % analysis_win_ms: window size used for autocorrelation analysis
    % max_change: restrict periodicity to not increase by more than this ratio from the mean
    % min_change: restrict periodicity to not decrease by more than this ratio from the mean
    
    N = length(signal);
    min_period = fs / max_hz;
    max_period = fs / min_hz;
    
    % compute pitch periodicity
    sequence = round(analysis_win_ms / 1000 * fs);  % analysis sequence length in samples
    periods = compute_periods_per_sequence(signal, sequence, min_period, max_period);
    
    % simple hack to avoid octave error: assume that the pitch should not vary much, restrict range
    mean_period = mean(periods);
    max_period = round(mean_period * 1.1);
    min_period = round(mean_period * 0.9);
    periods = compute_periods_per_sequence(signal, sequence, min_period, max_period);
    
    % find the peaks
    peaks = zeros(1, 1);
    while true
        prev = peaks(end);
        idx = floor(prev / sequence) + 1;  % current autocorrelation analysis window
        if prev + round(periods(idx) * max_change) >= N
            break;
        end
        % find maximum near expected location
        [~, loc] = max(signal(prev + round(periods(idx) * min_change): prev + round(periods(idx) * max_change)));
        peaks = [peaks, prev + round(periods(idx) * min_change) + loc - 1];
    end
end

function periods = compute_periods_per_sequence(signal, sequence, min_period, max_period)
    % Computes periodicity of a time-domain signal using autocorrelation
    % sequence: analysis window length in samples. Computes one periodicity value per window
    % min_period: smallest allowed periodicity
    % max_period: largest allowed periodicity
    
    offset = 1;  % current sample offset
    periods = [];  % period length of each analysis sequence
    
    while offset <= length(signal)
        fourier = fft(signal(offset: offset + sequence - 1));
        fourier(1) = 0;  % remove DC component
        autoc = ifft(fourier .* conj(fourier)).real;
        [~, autoc_peak] = max(autoc(min_period: max_period));
        periods = [periods, min_period + autoc_peak - 1];
        offset = offset + sequence;
    end
end

function new_signal = psola(signal, peaks, f_ratio)
    % Time-Domain Pitch Synchronous Overlap and Add
    % signal: original time-domain signal
    % peaks: time-domain signal peak indices
    % f_ratio: pitch shift ratio
    
    N = length(signal);
    % Interpolate
    new_signal = zeros(1, N);
    new_peaks_ref = linspace(1, length(peaks), length(peaks) * f_ratio);
    new_peaks = zeros(1, length(new_peaks_ref));
    
    for i = 1:length(new_peaks_ref)
        weight = mod(new_peaks_ref(i), 1);
        left = floor(new_peaks_ref(i));
        right = ceil(new_peaks_ref(i));
        new_peaks(i) = round(peaks(left) * (1 - weight) + peaks(right) * weight);
    end
    
    % PSOLA
    for j = 1:length(new_peaks)
        % find the corresponding old peak index
        [~, i] = min(abs(peaks - new_peaks(j)));
        % get the distances to adjacent peaks
        P1 = [new_peaks(j) - (j == 1) * new_peaks(j) + (j > 1) * new_peaks(j - 1),
              (N - 1 - new_peaks(j)) * (j == length(new_peaks)) + (j < length(new_peaks)) * (new_peaks(j + 1) - new_peaks(j))];
        % edge case truncation
        if peaks(i) - P1(1) < 1
            P1(1) = peaks(i) - 1;
        end
        if peaks(i) + P1(2) > N
            P1(2) = N - peaks(i);
        end
        % linear OLA window
        window = [linspace(0, 1, P1(1) + 1) + (j > 1) * (linspace(1, 0, P1(1) + 1) + (j < length(new_peaks)) * linspace(0, 1, P1(2) + 1) + (j == length(new_peaks)) * linspace(1, 0, P1(2) + 1))];
        % center window from original signal at the new peak
        new_signal(new_peaks(j) - P1(1): new_peaks(j) + P1(2)) = new_signal(new_peaks(j) - P1(1): new_peaks(j) + P1(2)) + window .* signal(peaks(i) - P1(1): peaks(i) + P1(2));
    end
end
