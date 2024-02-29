function r = evenHarmGenerator(x, offset, A)
%特許公開平成8-95567
%  x += offset
%  A is the coefficient of below of half-wave
x = x + offset;
r = zeros(size(x));
r(x>=0) = x(x>=0);
r(x<0) = A*x(x<0);
end