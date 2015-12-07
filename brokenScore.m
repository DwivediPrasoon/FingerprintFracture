function [ Score ] = brokenScore( Minutia, MinutiaSets, Threshold, DebugLevel, FormatString )
%BROKENSCORE Scores fingerprint minutia on how many minutia sets it matches
%   Each set of minutia in MinutiaSets is compared to the provided Minutia.
%   The score of each individual minutia set (squared) will be added to Score.
%   Threshold is the minimum distance between points that are considered 
%   to be the same.
%   If DebugLevel is provided
if nargin < 4
    DebugLevel=2;
end
if nargin < 5
    FormatString=['*r';'sr';'dr';'+r';'*b';'sb';'db';'+b';'*g';'sg';'dg';'+g';'*m';'sm';'dm';'+m';'*c';'sc';'dc';'+c';'*y';'sy';'dy';'+y'];
end
Score=0;
held = ishold();
for i=1:size(MinutiaSets,1)
    [MinutiaSetScore, Transformation]=houghTransformScore(Minutia,MinutiaSets{i},12);
    Score = Score+MinutiaSetScore^2;
    if MinutiaSetScore>=DebugLevel
        AlignedMinutia = zeros(size(MinutiaSets{i},1),3);
        for count = 1:size(MinutiaSets{i},1)
            AlignedMinutia(count,:) = transformMinutia(MinutiaSets{i}(count,:),Transformation);
        end
        plotMinutia(AlignedMinutia,FormatString(mod(i-1,size(FormatString,2))+1));
        hold on;
    end
end
if held ~= ishold();
    hold
end
end

