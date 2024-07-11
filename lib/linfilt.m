function coef = linfilt( gain )

% ゲインの個数を取得
num_gain = size( gain, 1 ); 

% 個数が偶数の場合
if( mod( num_gain, 2 ) == 0 )
  % ゲインベクトル total_gain 作成(式(2.14)の0(ナイキスト
  % 周波数に相当)がない形に)
  total_gain = [gain(1:end-1); flipud(gain(2:end-1))];
  
  % シフト量算出
  sft_num = num_gain - 1;  
else
% 個数が奇数の場合
  % ゲインベクトル total_gain 作成(式(2.14)の形に)
  total_gain = [gain(1:end); flipud(gain(2:end-1))];
  % シフト量算出
  sft_num = num_gain - 2;
end

coef = ifft( total_gain );
coef = circshift( coef, sft_num );

end
