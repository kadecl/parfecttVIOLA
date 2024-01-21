%2012/12/27 声質を維持したピッチシフト
% 
% 江成拓哉，宮澤幸希（m-kouki@brain.riken.jp）
% 早稲田大学 菊池英明研究室
% http://speechresearch.fiw-web.net/66.html#qee1e455

clear all;
[data_before, Fs, NBITS] = audioread('a.aif');
%data_before = data_before(f)
%data_before = filter([1 -0.97],1,data_before);      % プリエンファシス
%% 

frameSize = 0.025;                                  % フレーム長：0.025秒（25ms）
frameShift = 0.010;                                 % フレームシフト長：0.010秒（10ms）
frameSizeSample = fix( Fs * frameSize );            % フレーム長：サンプル換算
frameShiftSample = fix( Fs * frameShift );          % フレームシフト長：サンプル換算
maxFrame = fix((length(data_before)-(frameSizeSample-frameShiftSample))/frameShiftSample)-1;
startFrame = 1;                                     % フレームの開始サンプル番号
endFrame = startFrame + frameSizeSample - 1;        % フレームの終了サンプル番号

data_after = zeros(length(data_before), 1);             % 結合後の音声データを格納
ModifiedSTFTM = zeros(frameSizeSample * 2, maxFrame);   %【各フレームの加工後の振幅スペクトル】を格納

%【どれくらいピッチをシフトさせるかの値】
% 正値なら高く、負値なら低くします。-1.0～+1.0の間で指定して下さい。
movex = -1;
%movex = -0.4;

for countFrame = 1 : 1 : maxFrame
	thisData = data_before(startFrame : endFrame);  % フレーム切り出し
	window = hanning(frameSizeSample);              % ハニング窓を生成
	thisData = thisData .* window;                  % 窓掛け
	fftsize = frameSizeSample * 2;                  % FFT次数
	dft = fft(thisData, fftsize);                   % フーリエ変換
	Adft = abs(dft);                                % 振幅スペクトル
	Adft_log = log10(abs(dft));                     % 対数振幅スペクトル
	Angdft = atan2(imag(dft), real(dft));           % 位相スペクトル
	cps = real(ifft(Adft_log));                     % ケプストラム

	% リフタリング（ピッチのピーク位置を調べるために声道成分を除去する）
	cps_lif_P = cps;
	cps_lif_P(1:100) = 0; cps_lif_P(length(cps)-98:length(cps)) = 0;    % 声道成分除去
	% 注：ここではピッチのピークピッキングのためにリフタリングしているので、
	%     1番目の成分も除去していますが、振幅スペクトルの加工が目的なら2番目から除去します。
	cps_lif_P = cps_lif_P(1:fftsize/2);                                 % 前半だけを取り出す
	% リフタリング済みのケプストラムが最大になる点のインデックスを求める
	pitchIndex = find(cps_lif_P==max(cps_lif_P));	
	% 該当するインデックスが複数あったとき、ケフレンシーの一番小さい値を選ぶ
	if length(pitchIndex) > 1
		pitchIndex = max(pitchIndex);
	end
    
	% ピッチ加工処理（ケフレンシー軸でピッチのピークをずらす）
	%  まずはケプストラムの左半分を（1番目の値とlength(cps)/2+1番目の値は非対称なので、これらも）取り出します。
	cps_left = cps(1:(length(cps)/2+1));
	%  ピッチを何フレームずらすかを決めます。
	if movex > 0
		%  ピッチを高くするとき→ケフレンシー軸を左に移動（3～ピッチピーク の範囲内をmovexの割合で移動）
		move = round((-1*movex) * (pitchIndex - 3));
	else
		%  ピッチを低くするとき→ケフレンシー軸を右に移動（ピッチピーク～左半分の最大値-3 の範囲内をmovexの割合で移動）
		move = round((-1*movex) * ((length(cps_left) - 3) - pitchIndex));
	end
	%  ピッチピークの前後3つを含む7ポイントのケプストラム値を取り出す
	pitch1 = cps_left(pitchIndex-3 : pitchIndex+3);
	%  取り出したピッチ区間のケプストラム値を3倍にする
	pitch1 = pitch1 * 3;
	%  pitch1を動かす先のインデックスをコピー
	pitch2 = cps_left(pitchIndex+(move-3) : pitchIndex+(move+3));
	%  pitch1とpitch2を入れ替える
	cps_left(pitchIndex+(move-3) : pitchIndex+(move+3)) = pitch1;
	cps_left(pitchIndex-3 : pitchIndex+3) = pitch2;
	%  cps_left の2番目～最後-1番目までをコピーして、上下反転させて結合して新しいケプストラムを作る
	cps_new = [cps_left ; flipud(cps_left(2:length(cps_left)-1))];
    
	%  確認用
	%subplot(2,1,1); plot(cps); subplot(2,1,2); plot(cps_new); pause();

	% 新しいケプストラムから加工後の振幅スペクトルを求める
	dftSpc_P = fft(cps_new, fftsize);
	AdftSpc_P = abs(10 .^ dftSpc_P);
	%【各フレームの加工後の振幅スペクトル】を代入
	ModifiedSTFTM(:, countFrame) = AdftSpc_P;
    
	% 加工後の振幅スペクトルと加工前の位相スペクトルから音声波形を求める
	sound_fft = AdftSpc_P .* exp(Angdft*j);
	sound_part = real(ifft(sound_fft, fftsize));    % 逆フーリエ変換をして実部を取り出す
	sound_part_cut = sound_part(1:fftsize/2);       % 波形成分は1番目～半分まで

	% 音声を結合
	data_after(startFrame:endFrame) = data_after(startFrame:endFrame) + sound_part_cut;

	startFrame = startFrame + frameShiftSample;
	endFrame = startFrame + frameSizeSample - 1;
end

%LSEE-MSTFTMアルゴリズム
wgn_sf = Fs; wgn_n = length(data_after); rand('state', sum(100 * clock));
data_LSEEMSTFTM = randn(1, wgn_n)';       % 初期信号（ホワイトノイズ）の生成
% 50回のループ
for count_i = 1 : 50
	% data_LSEEMSTFTM の位相スペクトルを解析して、加工後の振幅スペクトルと結合して新しい音声data_newを作る
	data_new = zeros(length(data_LSEEMSTFTM), 1);
	% 各フレームごとに解析
	%  フレームの個数だけ処理を繰り返す
	startFrame = 1; endFrame = startFrame + frameSizeSample - 1;
	for count_frame = 1 : maxFrame
		thisData = data_LSEEMSTFTM(startFrame : endFrame);
		window = hanning(frameSizeSample);
		thisData = thisData .* window;
		dft_LSEEMSTFTM = fft(thisData, fftsize);

		%【data_LSEEMSTFTM の位相スペクトル】
		Angdft_LSEEMSTFTM = atan2(imag(dft_LSEEMSTFTM), real(dft_LSEEMSTFTM));
		%【加工後振幅スペクトルとdata_LSEEMSTFTM の位相スペクトルから音声波形を作る】
		sound_fft_LSEEMSTFTM = ModifiedSTFTM(:,count_frame) .* exp(Angdft_LSEEMSTFTM*j);
		% 逆フーリエ変換
		sound_part_LSEEMSTFTM = real(ifft(sound_fft_LSEEMSTFTM, fftsize));
		sound_part_LSEEMSTFTM = sound_part_LSEEMSTFTM(1:fftsize/2);

		%音声を足しあわせ
		data_new(startFrame:endFrame) = data_new(startFrame:endFrame) + sound_part_LSEEMSTFTM;
		startFrame = startFrame + frameShiftSample;
		endFrame = startFrame + frameSizeSample - 1;
	end
	data_LSEEMSTFTM = data_new;
end

%プロット
subplot(3, 1, 1); 
spectrogram(data_before, hamming(64), 32, 256, Fs, 'yaxis');
title('元の波形');
subplot(3, 1, 2); 
spectrogram(data_after, hamming(64), 32, 256, Fs, 'yaxis');
title('ピッチをずらして再結合した波形');
subplot(3, 1, 3); 
spectrogram(data_LSEEMSTFTM, hamming(64), 32, 256, Fs, 'yaxis');
title('LSEE-MSTFTMアルゴリズムにかけて再結合した波形');
%再生
wavplay(data_before, Fs);
wavplay(data_after, Fs);
wavplay(data_LSEEMSTFTM, Fs);
audiowrite(data_LSEEMSTFTM, Fs, 'Test_pitchUP.wav');
%wavwrite(data_LSEEMSTFTM, Fs, 'Test_pitchDOWN.wav');
