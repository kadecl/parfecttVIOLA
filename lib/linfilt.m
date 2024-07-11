function coef = linfilt( gain )

% �Q�C���̌����擾
num_gain = size( gain, 1 ); 

% ���������̏ꍇ
if( mod( num_gain, 2 ) == 0 )
  % �Q�C���x�N�g�� total_gain �쐬(��(2.14)��0(�i�C�L�X�g
  % ���g���ɑ���)���Ȃ��`��)
  total_gain = [gain(1:end-1); flipud(gain(2:end-1))];
  
  % �V�t�g�ʎZ�o
  sft_num = num_gain - 1;  
else
% ������̏ꍇ
  % �Q�C���x�N�g�� total_gain �쐬(��(2.14)�̌`��)
  total_gain = [gain(1:end); flipud(gain(2:end-1))];
  % �V�t�g�ʎZ�o
  sft_num = num_gain - 2;
end

coef = ifft( total_gain );
coef = circshift( coef, sft_num );

end
