function [ mincol, maxcol, minrow, maxrow ] = Find_Bound_Box( BW, factor  )
%Find_Bound_Box 
% bw = perimeter;
mincol = inf;
maxcol = 0;
minrow = inf;
maxrow = 0;

% min row, max row
for i=1:size(BW,1)
    for j=1:size(BW,2)
        if BW(i,j)==1
            minrow = min(i, minrow);
            maxrow = max(i, maxrow);
            mincol = min(j, mincol);
            maxcol = max(j, maxcol);
        end
    end
end


end

