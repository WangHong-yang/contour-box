% Refer to the ICCV15 paper "Contour Box"
%
% USAGE:
%  run main.m
% INPUTS:
%  box info
%  edge info
% OUTPUT:
%  not needed
%
% Version 1.0
% Code written by Hongyang Wang, 2016.01.19
% Licensed under the MSR-LA Full Rights License 

% parameters
picNum = 1;
picStrNum = num2str(picNum'./1e4);
picStrNum = ['00',picStrNum(3:end)];  % to keep form as 6bits
polIr = 90; polIc = 50;
maxR  = 283; maxC  = 283;  % refer to cartTOpol.m
midR  = 142; midC  = 142;  % refer to cartTOpol.m
maxTH = 360; maxRAD= 200;  % refer to cartTOpol.m
lamda = 0.1;

% load bbs
bbs = load([picStrNum, '/EdgeBoxes-orien-score-edge-test.mat']);
bbs = bbs.bbs;
bbs = bbs{1,1};

% load E and adjust
E = load([picStrNum, '/E.txt']);
for ii = 1:size(E,1)
    for jj = 1:size(E,2)
        if E(ii,jj)<=0.001
            E(ii,jj) = 0;  % FIXME! -1
        end
    end
end

% prepare coordinate mapping data used in cartTOpol.m
rMat(maxTH,maxRAD) = 0;
cMat(maxTH,maxRAD) = 0;
polTI(maxTH,maxRAD)= 0;  % polTI - tightness map of size 90x50
for TH = 1:maxTH
    for RAD = 1:maxRAD
        rMat(TH,RAD) = midR + int32(RAD*sind(TH));
        cMat(TH,RAD) = midC + int32(RAD*cosd(TH));
        if rMat(TH,RAD)<1 || rMat(TH,RAD)>maxR || cMat(TH,RAD)<1 || cMat(TH,RAD)>maxC
            polTI(TH,RAD) = 0;   % FIXME! 
        else
            polTI(TH,RAD) = min(0.7,((midR + RAD*sind(TH)-midR)/(maxR/2))^2+((midC + RAD*cosd(TH)-midC)/(maxC/2))^2);
        end
    end 
end
polTI = imresize(polTI,[90 50],'bilinear');  % resize polTI -> 90x50
dataMat = {rMat,cMat};

for bc = 1:size(bbs,1)
    boxNum = bc;
    boxStrNum = num2str(boxNum);
    boxC = bbs(boxNum,1); boxR = bbs(boxNum,2); boxW = bbs(boxNum,3); boxH = bbs(boxNum,4);

    % cart to polar
    cartI = E(boxR:(boxR+boxH),boxC:(boxC+boxW));
    polCI = cartTOpol(cartI, dataMat);
    polI = polCI+lamda*polTI;

    % get path
    [score, path, ed] = dijkRevised(polI,40);
    for ct=1:39
        ii = 40-ct;
        % note that 41~50 is out of rect boundary, so not counted
        [tmpScore, tmpPath, tmpEd] = dijkRevised(polI,ii);
        if tmpScore>score
            score = tmpScore;
            path  = tmpPath;
            ed    = tmpEd;
        end
    end
%     imshow(polI);
%     hold on;
%     road = 1:90;
%     plot(path,road,'o-','MarkerSize',2);

    % keep info
    bbs(bc,7) = score; bbs(bc,8:97)=path;
    disp(bc);
end

% save info
save('/Users/Mr-why/Documents/ScienceResearch/object-proposal/contour_box/after.mat','bbs');