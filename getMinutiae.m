function [ Minutiae ] = getMinutiae( ImageFile, Same, Close, Walk)
%Program for Fingerprint Minutiae Extraction
%
%Based on program by Athi Narayanan S
%Senior Research Associate
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in
%
%Program Description
%This program extracts the ridges and bifurcation from a fingerprint image
%
%NEW FEATURES!  Now filters image to find ridges better, removes minutia at
%the edges, and minutia that are too close together, and finds the angles
%for the minutia.


%Read Input Image

if nargin<2
    Same=2;
end
if nargin<3
    Close=8;
end
if nargin<4
    Walk=12;
end

binary_image=imread(ImageFile);

blurry_image= 1-conv2(255-double(binary_image),fspecial('disk',20),'same')/256.0;
binary_image=imsharpen(binary_image,'radius',4,'amount',10,'threshold',0);

blurry_image=blurry_image>0.9;
blurry_image= 1-conv2(1-double(blurry_image),fspecial('disk',20),'same');
blurry_image=blurry_image>0.1;

%Small region is taken to show output clear
binary_image = im2bw(binary_image);
%figure;imshow(binary_image);title('Input image');

%Thinning
thin_image=~bwmorph(~binary_image,'thin',Inf);

%Minutiae extraction
s=size(thin_image);
N=3;%window size
n=(N-1)/2;
r=s(1)+2*n;
c=s(2)+2*n;
double temp(r,c);
temp=zeros(r,c);bifurcation=zeros(r,c);ridge=zeros(r,c);
temp((n+1):(end-n),(n+1):(end-n))=thin_image(:,:);
outImg=zeros(r,c,3);%For Display
outImg(:,:,1) = temp .* 255;
outImg(:,:,2) = temp .* 255;
outImg(:,:,3) = temp .* 255;
for x=(n+1+10):(s(1)+n-10)
    for y=(n+1+10):(s(2)+n-10)
        e=1;
        for k=x-n:x+n
            f=1;
            for l=y-n:y+n
                mat(e,f)=temp(k,l);
                f=f+1;
            end
            e=e+1;
        end;
        if(mat(2,2)==0)
            ridge(x,y)=sum(sum(~mat));
            bifurcation(x,y)=sum(sum(~mat));
        end
    end;
end;

% RIDGE END FINDING
[ridge_r, ridge_c]=find(ridge==2);
len=length(ridge_r);
ridges=[];%zeros(1,3);
counter=0;
for i=1:len
    if ~blurry_image(ridge_r(i),ridge_c(i))
        counter=counter+1;
        
        map = ~temp;
        
        map(ridge_r(i),ridge_c(i))=false;
        X = ridge_c(i);
        Y = ridge_r(i);
        for j = 1:Walk
            looking = true;
            for x=-1:1
                for y=-1:1
                    if looking && map(Y+y,X+x)
                        X=X+x;
                        Y=Y+y;
                        map(Y,X)=0;
                        looking = false;
                    end
                end
            end
        end
        Angle = atan2(Y-ridge_r(i),X-ridge_c(i))*180/pi;
        ridges(counter,:)=[ridge_c(i),ridge_r(i),Angle];
    end
end

%BIFURCATION FINDING
[bifurcation_r, bifurcation_c]=find(bifurcation==4);
len=length(bifurcation_r);

bifurcations=[];%zeros(1,3);
counter=0;
for i=1:len
    if ~blurry_image(bifurcation_r(i),bifurcation_c(i))
        counter=counter+1;
        
        Angle = calculateBifurcationAngle(bifurcation_r(i),bifurcation_c(i),Walk,~temp);
        bifurcations(counter,:)=[bifurcation_c(i),bifurcation_r(i),Angle];
        
    end
end

CrowdedMinutiae = [ridges;bifurcations];
Crowded=zeros(size(CrowdedMinutiae,1),1);
SameSq = Same^2;
CloseSq = Close^2;
for i=1:size(CrowdedMinutiae,1)
    for j=i:size(CrowdedMinutiae,1)
        if j ~= i;
            DistSq = sum((CrowdedMinutiae(i,1:2)-CrowdedMinutiae(j,1:2)).^2);
            if(DistSq<CloseSq)
                if DistSq>SameSq
                    Crowded(i)=true;
                end
                Crowded(j)=true;
            end
        end
    end
end
Minutiae = CrowdedMinutiae(find(~Crowded),:);

for i=1:size(Minutiae,1)
    Minutiae(i,:);
    outImg(Minutiae(i,2)-1:Minutiae(i,2)+1,Minutiae(i,1)-1:Minutiae(i,1)+1,1:2)=0;
    X2 = round(Minutiae(i,1)+Walk*cos(Minutiae(i,3)*pi/180));
    Y2 = round(Minutiae(i,2)+Walk*sin(Minutiae(i,3)*pi/180));
    outImg(Y2-1:Y2+1,X2-1:X2+1,2:3)=0;
end

figure;imshow(outImg);title('Minutiae');

end

function [Angle] = calculateBifurcationAngle(bifurcation_r,bifurcation_c, Walk, map)
%calculate angle
Points = zeros(3,2);
for j=1:size(Points,1)
    Points(j,:)=[bifurcation_c,bifurcation_r];
end
map(bifurcation_r,bifurcation_c)=0;

for counter=1:Walk
    for j=1:size(Points,1)
        X = Points(j,1);
        Y = Points(j,2);
        looking = true;
        for x=-1:1
            for y=-1:1
                if looking && map(Y+y,X+x)
                    Points(j,:) = [X+x,Y+y];
                    map(Y+y,X+x)=0;
                    looking = false;
                end
            end
        end
    end
end

for counter = 1:3
    Points(counter,:) = Points(counter,:)-[double(bifurcation_c),double(bifurcation_r)];
    Points(counter,:) = Points(counter,:)./sum(Points(counter,:).^2)^0.5;
end

bestpoint = 0;
bestcos = 2;
for counter = 1:3
    cos1 = sum(Points(counter).*Points(mod(counter,3)+1));
    cos2 = sum(Points(counter).*Points(mod(counter+1,3)+1));
    cos = max(cos1,cos2);
    if cos<bestcos
        bestcos = cos;
        bestpoint = counter;
    end
end
Angle = floor(atan2(Points(bestpoint,2),Points(bestpoint,1))*180/pi);
end

