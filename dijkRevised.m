function [score, path, ed] = dijkRevised( polCI, st )
% Revise dijkstra, for certain pair of start/end point, cal MAX Score Path
%
% USAGE:
%  [score, path] = dijkRevised(polarI,st,ed)
% INPUTS:
%  polarI- 90x50 polar map
%  st    - start point
%  
% OUTPUT:
%  score - MAX score added along path
%  path  - MAX score path -> longest path? :)
%  ed    - end point
%
% Version 1.0
% Code written by Hongyang Wang, 2016.01.21
% Licensed under the MSR-LA Full Rights License 


%  polarI  权值矩阵   st 搜索的起点   ed 搜索的终点
pnum = size(polCI,2);  % 50 st & 50 ed
len = size(polCI,1);  % every path's length is 90
D = zeros(len,pnum);  % score integral map
parent = zeros(len,pnum);  % parent point
path =[];

% init first two lines 
D(1,st) = polCI(1,st);
for ii=clamp(1,st-3,pnum):1:clamp(1,st+3,pnum)
    D(2,ii) = polCI(2,ii)+D(1,st);
end
parent(1,st) = 0;
parent(2,st) = st;
parent(2,max(1,st-3))=st; parent(2,max(1,st-2))=st; parent(2,max(1,st-1))=st;
parent(2,min(pnum,st+3))=st; parent(2,min(pnum,st+2))=st; parent(2,min(pnum,st+1))=st;

% compute other lines
for r=3:len
    for c=1:pnum
        
        % find the parent D and score
        for k=-3:1:3
            if (c+k)>=1 && (c+k)<=pnum
                if D(r-1,c+k)>0 && polCI(r,c)+D(r-1,c+k)>D(r,c)
                    parent(r,c) = c+k;
                    D(r,c)  = polCI(r,c)+D(r-1,c+k);
                end
            end
        end
        
        
    end
end

% get path and score
[score, pos] = max(D(len,:));
ed = pos;
path = pos;
for ii=0:(len-2)
    pos = parent((len-ii),pos);
    path = [pos,path];
end


end
