%2012/12/27 �������ێ������s�b�`�V�t�g
% 
% �]����ƁC�{�V�K��im-kouki@brain.riken.jp�j
% ����c��w �e�r�p��������
% http://speechresearch.fiw-web.net/66.html#qee1e455

clear all;
[data_before, Fs, NBITS] = audioread('a.aif');
%data_before = data_before(f)
%data_before = filter([1 -0.97],1,data_before);      % �v���G���t�@�V�X
%% 

frameSize = 0.025;                                  % �t���[�����F0.025�b�i25ms�j
frameShift = 0.010;                                 % �t���[���V�t�g���F0.010�b�i10ms�j
frameSizeSample = fix( Fs * frameSize );            % �t���[�����F�T���v�����Z
frameShiftSample = fix( Fs * frameShift );          % �t���[���V�t�g���F�T���v�����Z
maxFrame = fix((length(data_before)-(frameSizeSample-frameShiftSample))/frameShiftSample)-1;
startFrame = 1;                                     % �t���[���̊J�n�T���v���ԍ�
endFrame = startFrame + frameSizeSample - 1;        % �t���[���̏I���T���v���ԍ�

data_after = zeros(length(data_before), 1);             % ������̉����f�[�^���i�[
ModifiedSTFTM = zeros(frameSizeSample * 2, maxFrame);   %�y�e�t���[���̉��H��̐U���X�y�N�g���z���i�[

%�y�ǂꂭ�炢�s�b�`���V�t�g�����邩�̒l�z
% ���l�Ȃ獂���A���l�Ȃ�Ⴍ���܂��B-1.0�`+1.0�̊ԂŎw�肵�ĉ������B
movex = -1;
%movex = -0.4;

for countFrame = 1 : 1 : maxFrame
	thisData = data_before(startFrame : endFrame);  % �t���[���؂�o��
	window = hanning(frameSizeSample);              % �n�j���O���𐶐�
	thisData = thisData .* window;                  % ���|��
	fftsize = frameSizeSample * 2;                  % FFT����
	dft = fft(thisData, fftsize);                   % �t�[���G�ϊ�
	Adft = abs(dft);                                % �U���X�y�N�g��
	Adft_log = log10(abs(dft));                     % �ΐ��U���X�y�N�g��
	Angdft = atan2(imag(dft), real(dft));           % �ʑ��X�y�N�g��
	cps = real(ifft(Adft_log));                     % �P�v�X�g����

	% ���t�^�����O�i�s�b�`�̃s�[�N�ʒu�𒲂ׂ邽�߂ɐ�����������������j
	cps_lif_P = cps;
	cps_lif_P(1:100) = 0; cps_lif_P(length(cps)-98:length(cps)) = 0;    % ������������
	% ���F�����ł̓s�b�`�̃s�[�N�s�b�L���O�̂��߂Ƀ��t�^�����O���Ă���̂ŁA
	%     1�Ԗڂ̐������������Ă��܂����A�U���X�y�N�g���̉��H���ړI�Ȃ�2�Ԗڂ��珜�����܂��B
	cps_lif_P = cps_lif_P(1:fftsize/2);                                 % �O�����������o��
	% ���t�^�����O�ς݂̃P�v�X�g�������ő�ɂȂ�_�̃C���f�b�N�X�����߂�
	pitchIndex = find(cps_lif_P==max(cps_lif_P));	
	% �Y������C���f�b�N�X�������������Ƃ��A�P�t�����V�[�̈�ԏ������l��I��
	if length(pitchIndex) > 1
		pitchIndex = max(pitchIndex);
	end
    
	% �s�b�`���H�����i�P�t�����V�[���Ńs�b�`�̃s�[�N�����炷�j
	%  �܂��̓P�v�X�g�����̍��������i1�Ԗڂ̒l��length(cps)/2+1�Ԗڂ̒l�͔�Ώ̂Ȃ̂ŁA�������j���o���܂��B
	cps_left = cps(1:(length(cps)/2+1));
	%  �s�b�`�����t���[�����炷�������߂܂��B
	if movex > 0
		%  �s�b�`����������Ƃ����P�t�����V�[�������Ɉړ��i3�`�s�b�`�s�[�N �͈͓̔���movex�̊����ňړ��j
		move = round((-1*movex) * (pitchIndex - 3));
	else
		%  �s�b�`��Ⴍ����Ƃ����P�t�����V�[�����E�Ɉړ��i�s�b�`�s�[�N�`�������̍ő�l-3 �͈͓̔���movex�̊����ňړ��j
		move = round((-1*movex) * ((length(cps_left) - 3) - pitchIndex));
	end
	%  �s�b�`�s�[�N�̑O��3���܂�7�|�C���g�̃P�v�X�g�����l�����o��
	pitch1 = cps_left(pitchIndex-3 : pitchIndex+3);
	%  ���o�����s�b�`��Ԃ̃P�v�X�g�����l��3�{�ɂ���
	pitch1 = pitch1 * 3;
	%  pitch1�𓮂�����̃C���f�b�N�X���R�s�[
	pitch2 = cps_left(pitchIndex+(move-3) : pitchIndex+(move+3));
	%  pitch1��pitch2�����ւ���
	cps_left(pitchIndex+(move-3) : pitchIndex+(move+3)) = pitch1;
	cps_left(pitchIndex-3 : pitchIndex+3) = pitch2;
	%  cps_left ��2�Ԗځ`�Ō�-1�Ԗڂ܂ł��R�s�[���āA�㉺���]�����Č������ĐV�����P�v�X�g���������
	cps_new = [cps_left ; flipud(cps_left(2:length(cps_left)-1))];
    
	%  �m�F�p
	%subplot(2,1,1); plot(cps); subplot(2,1,2); plot(cps_new); pause();

	% �V�����P�v�X�g����������H��̐U���X�y�N�g�������߂�
	dftSpc_P = fft(cps_new, fftsize);
	AdftSpc_P = abs(10 .^ dftSpc_P);
	%�y�e�t���[���̉��H��̐U���X�y�N�g���z����
	ModifiedSTFTM(:, countFrame) = AdftSpc_P;
    
	% ���H��̐U���X�y�N�g���Ɖ��H�O�̈ʑ��X�y�N�g�����特���g�`�����߂�
	sound_fft = AdftSpc_P .* exp(Angdft*j);
	sound_part = real(ifft(sound_fft, fftsize));    % �t�t�[���G�ϊ������Ď��������o��
	sound_part_cut = sound_part(1:fftsize/2);       % �g�`������1�Ԗځ`�����܂�

	% ����������
	data_after(startFrame:endFrame) = data_after(startFrame:endFrame) + sound_part_cut;

	startFrame = startFrame + frameShiftSample;
	endFrame = startFrame + frameSizeSample - 1;
end

%LSEE-MSTFTM�A���S���Y��
wgn_sf = Fs; wgn_n = length(data_after); rand('state', sum(100 * clock));
data_LSEEMSTFTM = randn(1, wgn_n)';       % �����M���i�z���C�g�m�C�Y�j�̐���
% 50��̃��[�v
for count_i = 1 : 50
	% data_LSEEMSTFTM �̈ʑ��X�y�N�g������͂��āA���H��̐U���X�y�N�g���ƌ������ĐV��������data_new�����
	data_new = zeros(length(data_LSEEMSTFTM), 1);
	% �e�t���[�����Ƃɉ��
	%  �t���[���̌������������J��Ԃ�
	startFrame = 1; endFrame = startFrame + frameSizeSample - 1;
	for count_frame = 1 : maxFrame
		thisData = data_LSEEMSTFTM(startFrame : endFrame);
		window = hanning(frameSizeSample);
		thisData = thisData .* window;
		dft_LSEEMSTFTM = fft(thisData, fftsize);

		%�ydata_LSEEMSTFTM �̈ʑ��X�y�N�g���z
		Angdft_LSEEMSTFTM = atan2(imag(dft_LSEEMSTFTM), real(dft_LSEEMSTFTM));
		%�y���H��U���X�y�N�g����data_LSEEMSTFTM �̈ʑ��X�y�N�g�����特���g�`�����z
		sound_fft_LSEEMSTFTM = ModifiedSTFTM(:,count_frame) .* exp(Angdft_LSEEMSTFTM*j);
		% �t�t�[���G�ϊ�
		sound_part_LSEEMSTFTM = real(ifft(sound_fft_LSEEMSTFTM, fftsize));
		sound_part_LSEEMSTFTM = sound_part_LSEEMSTFTM(1:fftsize/2);

		%�����𑫂����킹
		data_new(startFrame:endFrame) = data_new(startFrame:endFrame) + sound_part_LSEEMSTFTM;
		startFrame = startFrame + frameShiftSample;
		endFrame = startFrame + frameSizeSample - 1;
	end
	data_LSEEMSTFTM = data_new;
end

%�v���b�g
subplot(3, 1, 1); 
spectrogram(data_before, hamming(64), 32, 256, Fs, 'yaxis');
title('���̔g�`');
subplot(3, 1, 2); 
spectrogram(data_after, hamming(64), 32, 256, Fs, 'yaxis');
title('�s�b�`�����炵�čČ��������g�`');
subplot(3, 1, 3); 
spectrogram(data_LSEEMSTFTM, hamming(64), 32, 256, Fs, 'yaxis');
title('LSEE-MSTFTM�A���S���Y���ɂ����čČ��������g�`');
%�Đ�
wavplay(data_before, Fs);
wavplay(data_after, Fs);
wavplay(data_LSEEMSTFTM, Fs);
audiowrite(data_LSEEMSTFTM, Fs, 'Test_pitchUP.wav');
%wavwrite(data_LSEEMSTFTM, Fs, 'Test_pitchDOWN.wav');
