function [ MinutiaSets StraightMinutiaSets ] = brokenEnroll( Minutia, ShapeCount, PointCount, Seed)
%BROKENENROLL Breaks a minutia set into random smaller minutia sets
%   In order to store matchable minutia, without exposing the original
%   minutia set,  this function will break a minutia set into ${ShapeCount}
%   smaller minutia sets, each with ${PointCount} minutia.
%   Each smaller minutia set will be translated so that one of the points
%   is at 0,0 with a rotation of 0.  MinutiaSets contains the translated
%   minutia sets, and StraightMinutiaSets contains the minutia sets before
%   translation (for debugging).
    if nargin<4
        Seed=sum(100*clock);
    end
    StraightMinutiaSets = cell(ShapeCount,1);
    MinutiaSets = cell(ShapeCount,1);
    for i=1:ShapeCount
        MinutiaSets{i}=zeros(PointCount, 3);
        StraightMinutiaSets{i}=zeros(PointCount, 3);
    end
    notOctave = exist('OCTAVE_VERSION', 'builtin') == 0;
    if notOctave
        rng(Seed);
    end
    for Shape = 1:ShapeCount
        for Point = 1:PointCount
            Taken = true;
            while Taken
                Tmp = Minutia(randi(size(Minutia,1)),:);
                Taken = find(ismember(StraightMinutiaSets{Shape}(1:Point-1,:),Tmp,'rows'));
            end
            StraightMinutiaSets{Shape}(Point,:) = Tmp;
        end
        DTheta = mod(360+StraightMinutiaSets{Shape}(1,3),360);
        X1 = StraightMinutiaSets{Shape}(1,1);
        Y1 = StraightMinutiaSets{Shape}(1,2);
        for Point = 1:PointCount
            Theta = StraightMinutiaSets{Shape}(Point,3)-DTheta;
            X = StraightMinutiaSets{Shape}(Point,1)-X1;
            Y = StraightMinutiaSets{Shape}(Point,2)-Y1;
            DCos = cos(-DTheta*pi/180);
            DSin = sin(-DTheta*pi/180);
            NX = -X*DCos-Y*DSin;
            NY = X*DSin-Y*DCos;
            MinutiaSets{Shape}(Point, :) = untransformMinutia(StraightMinutiaSets{Shape}(Point,:),StraightMinutiaSets{Shape}(1,:));
        end
    end
end

