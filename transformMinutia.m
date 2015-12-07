function [ TransformedMinutia ] = transformMinutia( Minutia, Transformation)
%TRANFORMMINUTIA Rotates and translates a minutia
%   Rotates and Translates a minutia (x,y,theta)
    DTheta = Transformation(3)*pi/180.0;
    Dx = Transformation(1);
    Dy = Transformation(2);
    X = Minutia(1);
    Y = Minutia(2);
    Rx = X*cos(DTheta) - Y*sin(DTheta);
    Ry = X*sin(DTheta) + Y*cos(DTheta);
    TransformedMinutia = [Rx+Dx,Ry+Dy,Minutia(3)+Transformation(3)];
end

