function [ length ] = Calculate_Boundary( perimeter )
%Calculate_Boundary 
% perimeter = bw;
visited = zeros(size(perimeter));
parenti = zeros(size(perimeter));
parentj = zeros(size(perimeter));

length = 0;
firsti = 0;
firstj = 0;
scanptsi = [];
scanptsj = [];

for i=1:size(perimeter,1)
    if (firsti ~= 0) || (firstj ~= 0)
        break;
    end
    for j=1:size(perimeter,2)
       if (firsti ~= 0) || (firstj ~= 0)
        break;
       end
        if (perimeter(i,j) == 1)
                firsti = i;
                firstj = j;
                parenti(i,j) = i;
                parentj(i,j) = j;
                scanptsi = [i];
                scanptsj = [j];
        end
    end
end

while size(scanptsi,2) > 0
    
    i = scanptsi(1); scanptsi(1) = [];
    j = scanptsj(1); scanptsj(1) = [];
    
    visited(i,j) = 1;
    distpts = [j i; parentj(i,j) parenti(i,j)]; % [x(1) y(1); x(2) y(2)]
    length = length + pdist(distpts, 'euclidean');
    
    vari = [+1 +1 +1 0 0 -1 -1 -1];
    varj = [+1 -1 0 +1 -1 -1 +1 0];
   
    
    for it =1:size(vari,2)
        diffi = vari(it);
        diffj = varj(it);
        if i+diffi > 0 && j+diffj > 0 && i+diffi <= size(perimeter,1) && j+diffj <= size(perimeter,2)
        
        if (perimeter(i+diffi,j+diffj) == 1) && visited(i+diffi,j+diffj) == 0
            scanptsi = [ i+diffi scanptsi];
            scanptsj = [ j+diffj scanptsj];
            parenti(i+diffi, j+diffj) = i;
            parentj(i+diffi, j+diffj) = j;
%         elseif (firsti == i+diffi) && (j+diffj == firstj)
%             distpts = [j i; j+diffj i+diffi]; % [x(1) y(1); x(2) y(2)]
%             length = length + pdist(distpts, 'euclidean');
        end
        end
    end
end

end

