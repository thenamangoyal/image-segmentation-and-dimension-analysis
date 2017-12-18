function RunAll( RGB, method)
%RunAll( RGB, method) - Generates the boundary box around and calculate the
%bounding box dimension and boundary dimension 
% Specify method as 'lazy'(default) , 'active contour', 'morphological', 'matlab'

if nargin<1
    error('No input image');
end

%% Read image

% RGB = imread('data/Phone 1.jpg');

%% Segment Image
if nargin < 2
method = 'lazy';
end
fprintf('Using method %s\n', method);
if strcmp(method,'active contour') == 1
    imshow(RGB);
    str = 'Click to select initial contour location. Double-click inside the ROI to confirm and proceed.';
    title(str,'Color','b','FontSize',12);
%     disp(sprintf('\nNote: Click close to object boundaries for more accurate result.'))

    mask = roipoly;

%     figure, imshow(mask)
%     title('Initial MASK');
    close;
    maxIterations = 1000; 
    atime =  tic;
    fprintf('Running %s\n', method);
    BW = activecontour(RGB, mask, maxIterations);
    fprintf('%s ran in %f sec\n', method, toc(atime));
elseif strcmp(method, 'morphological') == 1
    
    
    atime =  tic;
    fprintf('Running %s\n', method);
    GRAY=rgb2gray(RGB);

    [BW, threshold] = edge(GRAY, 'sobel');
    fudgeFactor = .5;
    BW = edge(GRAY,'sobel', threshold * fudgeFactor);
    se90 = strel('line', 3, 90);
    se0 = strel('line', 3, 0);
    BW = imdilate(BW, [se90 se0]);
    BW = imfill(BW, 'holes');
    se = strel('line',11,90);
    BW = imerode(BW,se);
    BW = imerode(BW,se);
    seD = strel('diamond',1);
    BW = imerode(BW,seD);
    BW = imerode(BW,seD);
    
    fprintf('%s ran in %f sec\n', method, toc(atime));
elseif strcmp(method, 'lazy') == 1
    X = rgb2lab(RGB);
    figure; 

    imshow(RGB)
     title('Select Foreground as freehand');
    h1 = imfreehand(gca,'Closed',false);
    foresub = getPosition(h1);
    
    foregroundInd = sub2ind(size(RGB),foresub(:,2),foresub(:,1));



    % Graph Cut
    
    title('Select Background as freehand');
    h2 = imfreehand(gca,'Closed',false);
    backsub = getPosition(h2);
    backgroundInd = sub2ind(size(RGB),backsub(:,2),backsub(:,1));
    
    close;
    atime =  tic;
    fprintf('Running %s\n', method);
    L = superpixels(X,1000,'IsInputLab',true);

    % Convert L*a*b* range to [0 1]
    scaledX = X;
    scaledX(:,:,1) = X(:,:,1) / 100;
    scaledX(:,:,2:3) = (X(:,:,2:3) + 100) / 200;
    BW = lazysnapping(scaledX,L,int64(foregroundInd),int64(backgroundInd));
    
    fprintf('%s ran in %f sec\n', method, toc(atime));
elseif strcmp(method, 'matlab') == 1
    imageSegmenter close;
    fprintf('Please Export variable as BW and press enter\n');
    imageSegmenter(RGB);
    
    pause;
    BW = evalin('base','BW');
else
    error('Wrong method - Specify method as lazy (default) , active contour, morphological, matlab');
    
end
%% Enhance using morphological orperations
BW = imclearborder(BW);

% take largest connected component 
% BW = bwconncomp(BW);
BW = bwareafilt(BW,1);

%% Display segmented image
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
figure, imshowpair(BW,maskedImage, 'montage' );
title(['Segmented Image using ', method]);


%% Get the perimeter

BW = bwperim(BW);

%% Get the image to pixel ratio
figure;
imshow(RGB);
% [x, y] = getpts(gcf);
 title('Select Points here of reference object');
 n_points = 2;
    x = zeros(n_points,1);
    y = zeros(n_points,1);
    for i=1:1:n_points
        hold on,
        [x(i),y(i)] = ginput(1);
%         text(x(i),y(i),strcat('\leftarrow ',num2str(i)),'Color', 'b','FontSize',8);
        plot(x(i),y(i),'bo');
    end
dist = [x(1) y(1); x(2) y(2)];
euc_dist = pdist(dist, 'euclidean');
close(gcf);

actual_dist = input('Enter the reference object distance (cm)>> ');
factor = actual_dist/euc_dist;

%% Find the boundary of the box

boundary_len = Calculate_Boundary(BW);

%% Find bounding box
[mincol, maxcol, minrow, maxrow] = Find_Bound_Box(BW);
%% Display the result

final_dist = factor*boundary_len;
fprintf('Final boundary length %f (cm)\n',final_dist);

width=maxcol-mincol;
height=maxrow-minrow;
width_bbox = width*factor;
height_bbox = height*factor;
fprintf('Width bounding box %f (cm)\n', width_bbox);
fprintf('Heigth bounding box %f (cm)\n', height_bbox);

%% Display the bounding box 
figure;
imshow(RGB)
title(strcat('Final dimension using: ', method),'fontsize',16);
hold on
rectangle('Position', [mincol, minrow, width, height], 'EdgeColor','r', 'LineWidth', 3);
text(round(mincol+width/2), minrow-5,strcat('Width: ', num2str(width_bbox), ' cm'),'FontSize',14,'HorizontalAlignment','center','VerticalAlignment','bottom', 'Color', 'r');
text(mincol-5, round(minrow+height/2),strcat('Height: ', num2str(height_bbox), ' cm'),'FontSize',14,'HorizontalAlignment','right', 'Color', 'r');
text(round(size(RGB,2)/2),size(RGB,1),strcat('Boundary: ', num2str(final_dist), ' cm'), 'FontSize',14,'HorizontalAlignment','center','VerticalAlignment','top', 'Color', 'b');
end