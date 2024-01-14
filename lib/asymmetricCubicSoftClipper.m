function clippedData = asymmetricCubicSoftClipper(input)
clippedData = zeros(size(input));
for i = 1:length(input)
    temp = input(i);
    if temp >= 1
        clippedData(i) = 2/3;
    elseif temp > -1
        clippedData(i) = temp.^3 - temp;
    else
        clippedData(i) = -2/3;
    end
end
end