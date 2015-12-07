function [ TransformedMinutia ] = transformMinutia( Minutia, Transformation)
%TRANFORMMINUTIA Inversely Rotates and translates a minutia
%   Rotates and Translates a minutia (x,y,theta)
    DTheta = -Transformation(3)*pi/180.0;
    Dx = Transformation(1);
    Dy = Transformation(2);
    X = Minutia(1)-Dx;
    Y = Minutia(2)-Dy;
    Rx = X*cos(DTheta) - Y*sin(DTheta);
    Ry = X*sin(DTheta) + Y*cos(DTheta);
    TransformedMinutia = [Rx,Ry,Minutia(3)-Transformation(3)];
end