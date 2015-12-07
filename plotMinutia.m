function [] = plotMinutia(PointMatrix, Format, Limits)
if nargin < 2
    Format = '.r';
end
if nargin < 3
    Limits = [0 512 0 512];
end
plot(PointMatrix(:,1),PointMatrix(:,2),Format);
axis(Limits);
end
