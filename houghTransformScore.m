function [ Score Transformation ] = houghTransformScore( A, B, Threshold )
%HOUGHTRANSFORM Uses HoughTransform to score minutia.
%   Minutia (x,y,theta) in the rows of B are translated to best line up
%   with A.  Score counts the number of translated points in B that are
%   within Threshold distance of a point in A.  Transform contains the
%   optimal transformation of B (x,y,theta).

%Create a gaussian for the accumulator so that close points still count a
%little
Gaussian = fspecial('gaussian',[9 9],3);
Gaussian = Gaussian/Gaussian(ceil(size(Gaussian,1)/2),ceil(size(Gaussian,1)/2));

%Create sparse matrixes for accumulation
Accumulator = cell(360,1);
for t = 1:360
    Accumulator{t} = sparse(1024,1024);
end
for i = 1:size(A,1)
    for j = 1:size(B,1)
        Theta1 = mod(A(i,3),360);
        Theta2 = mod(B(j,3),360);
        DTheta = round(mod(360+Theta1-Theta2,360));
        DCos = cos(DTheta*pi/180);
        DSin = sin(DTheta*pi/180);
        Rx = B(j,1)*DCos-B(j,2)*DSin;
        Ry = B(j,1)*DSin+B(j,2)*DCos;
        Dx = A(i,1)-Rx;
        Dy = A(i,2)-Ry;
        Dx = floor(Dx/2+512);
        Dy = floor(Dy/2+512);
        GausDia = floor(size(Gaussian,1));
        GausMid = ceil(GausDia/2);
        for k=1:GausDia
            Index = mod(DTheta-GausMid+k+359,360)+1;
            if Index>0 && Index<=360
                MinX = Dx-GausMid+1;
                MaxX = Dx-GausMid+GausDia;
                MinY = Dy-GausMid+1;
                MaxY = Dy-GausMid+GausDia;
                Accumulator{Index}(MinX:MaxX,MinY:MaxY) = Accumulator{Index}(MinX:MaxX,MinY:MaxY)+Gaussian*Gaussian(GausMid,k);
            end
        end
    end
end
%find maximum angle
MaxAngle = 0;
MaxI = 1;
for i=1:360
    CurrMax = max(max(Accumulator{i}));
    if CurrMax > MaxAngle
        MaxI = i;
        MaxAngle = CurrMax;
    end
end
%find maximum
[~, MaxY] = max(max(Accumulator{MaxI}));
[~, MaxX] = max(Accumulator{MaxI}(:,MaxY));
Transformation = [(MaxX-512)*2, (MaxY-512)*2, MaxI];
%Transformation =[205 314 287]
%Align the Minutia
AlignedMinutia = B;
for count = 1:size(B,1)
    AlignedMinutia(count,:) = transformMinutia(AlignedMinutia(count,:),Transformation);
end

%Pair the minutia
MinDist2 = Threshold*Threshold; %holds distance squared
MinAngle = 5280; %degrees
%Point sets
%counter, list, flags
Count = 0;
Pairs = [];
F1 = zeros(size(A,1),1);
F2 = zeros(size(AlignedMinutia,1),1);
for j = 1:size(AlignedMinutia,1)
    for i = 1:size(A,1)
        Distance2 = sum((A(i,1:2)-AlignedMinutia(j,1:2)).^2);
        Rotation1 = mod(abs(A(i,3)-AlignedMinutia(j,3)),360);
        Rotation2 = mod(abs(abs(A(i,3)-AlignedMinutia(j,3))-360),360);
        Rotation = min (Rotation1, Rotation2);
        if F1(i)==0 && F2(j)==0 && Distance2 <= MinDist2 && Rotation <= MinAngle
            F1(i) = 1;
            F2(j) = 1;
            Count = Count+1;
            Pairs(Count, 1:2) = [i,j];
        end
    end
end
for i=1:size(AlignedMinutia,1)
    %AlignedMinutia(i,:)
end
%AlignedMinutia
Score = ((Count-1.0)/(size(B,1)-1.0))^2;
end

