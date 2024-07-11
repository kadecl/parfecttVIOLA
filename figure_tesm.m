t = (0:1000-1) / 1000;

y1 = sin(4*pi*t);
y2 = sin(2*pi*t);

y = [y1, y2];
fw = figure;
fw.Position(3) = 500;
fw.Position(4) = 400;
plot(y, "LineWidth",4,"Color", "black")
hold on
plot(zeros(size(y)), "LineWidth", 1, "Color", "blue")
xlim([-100,2100])
ylim([-1.2, 1.2])
daspect([300 1 1])