function [polCI] = cartTOpol(cartI, dataMat)
% Revise cart2pol, make any size of input image convert 2 polar, th=90 r=50
%
% USAGE:
%  run main.m
% INPUTS:
%  
% OUTPUT:
%  polCI - completeness map of size 90x50
%
% Version 1.0
% Code written by Hongyang Wang, 2016.01.19
% Licensed under the MSR-LA Full Rights License 

% resize cartI to 283x283, to get half diagonal line=200
maxR  = 283;
maxC  = 283;
midR  = 142; 
midC  = 142;
cartI = imresize(cartI,[283 283],'nearest');

% get polCI & polTI 360x200: 
%  -> select center point 
%  -> rotate with radius=200 from +x axis
%  -> map pixel val from cartI to polCI
maxTH = 360;
maxRAD= 200;
polCI(maxTH,maxRAD)=0;

for TH = 1:maxTH
    for RAD = 1:maxRAD
        r = dataMat{1,1}(TH,RAD);  % midR + int32(RAD*sind(TH));
        c = dataMat{1,2}(TH,RAD);  % midC + int32(RAD*cosd(TH));
        if r<1 || r>maxR || c<1 || c>maxC
            polCI(TH,RAD) = 0;  % if runout cartI % FIXME! -1
        else
            polCI(TH,RAD) = cartI(r,c);
        end
    end
end


% resize polCI -> 90x50
polCI = imresize(polCI,[90 50],'bilinear');

% imshow(polCI);
end