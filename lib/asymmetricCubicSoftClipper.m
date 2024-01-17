function clippedData = asymmetricCubicSoftClipper(input)
clippedData = zeros(size(input));
for i = 1:length(input)
    temp = input(i);
    if temp >= 1
        clippedData(i) = 1;
    elseif temp > -1
        clippedData(i) = 3/2 * (temp - (temp^3)/3);
    else
        clippedData(i) = -1;
    end
end
end