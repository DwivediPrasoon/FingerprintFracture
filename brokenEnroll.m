function [ MinutiaSets, StraightMinutiaSets ] = brokenEnroll( Minutia, ShapeCount, PointCount, Seed)
%BROKENENROLL Breaks a minutia set into random smaller minutia sets
%   In order to store matchable minutia, without exposing the original
%   minutia set,  this function will break a minutia set into ${ShapeCount}
%   smaller minutia sets, each with ${PointCount} minutia.
%   Each smaller minutia set will be translated so that one of the points
%   is at 0,0 with a rotation of 0.  MinutiaSets contains the translated
%   minutia sets, and StraightMinutiaSets contains the minutia sets before
%   translation (for debugging).
    %Yes, I tested this in octave.  DON'T JUDGE ME!
    notOctave = exist('OCTAVE_VERSION', 'builtin') == 0;
    if notOctave
        if nargin<4
            rng shuffle;
        else
            rng(Seed);
        end
    end
    StraightMinutiaSets = cell(ShapeCount,1);
    MinutiaSets = cell(ShapeCount,1);
    for i=1:ShapeCount
        MinutiaSets{i}=zeros(PointCount, 3);
        StraightMinutiaSets{i}=zeros(PointCount, 3);
    end

    %If a point is used repeatedly, it has more weight during verification
    %Best to try to mitigate this
    PointWeights = zeros(size(Minutia,1),1);
    TotalWeight = 0;
    for Shape = 1:ShapeCount
        for Point = 1:PointCount
            Taken = true;
            r=0;
            while Taken
                r=randi(size(Minutia,1));
                Tmp = Minutia(r,:);
                OverRepresented = false;
                if PointWeights(r)>0
                    PointRepresentation = double(PointWeights(r))/TotalWeight;
                    OverRepresented = (PointRepresentation > 1+double(TotalWeight)/size(Minutia,1));
                end
                %Trouble with && operator on find
                Taken = OverRepresented;
                if ~Taken
                    Taken = find(ismember(StraightMinutiaSets{Shape}(1:Point-1,:),Tmp,'rows'));
                end
            end
            PointWeights(r)=PointWeights(r)+1;
            TotalWeight=TotalWeight+1;
            StraightMinutiaSets{Shape}(Point,:) = Tmp;
        end
        for Point = 1:PointCount
            MinutiaSets{Shape}(Point, :) = untransformMinutia(StraightMinutiaSets{Shape}(Point,:),StraightMinutiaSets{Shape}(1,:));
        end
    end
end

