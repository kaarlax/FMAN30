function S = im2segment(im)

H = fspecial('gaussian'); % Gaussian filter
im = imfilter(im, H);

level = 43;
new_image = im > level;
[L, ~] = bwlabel(new_image);
T = regionprops(L, 'Area');
areas = [T.Area];

[~, idx] = maxk(areas, 5);
idx = sort(idx);

NoSeg = length(idx);
S = cell(1, NoSeg);

for i = 1:NoSeg
    S{i} = ismember(L, idx(i));
end

end




% function S = im2segment(im)
% 
%   
% H = fspecial('gaussian'); %gaussian filter
% im = imfilter(im,H);
% 
% level = 43;
% new_image = im>level;
% [L,~]=bwlabel(new_image);
% T = regionprops(L,'Area');
% areas = [T.Area];
% [sortedAreas, idx] = sort(areas, 'descend');
% numAreasToKeep = 5;
% selectedIdx = idx(1:numAreasToKeep);
% %findN = find([T.Area]>P);
% NoSeg = length(selectedIdx);
% S = cell(1,NoSeg);
% 
% 
% %pick the 5 biggest areas
% for i=1:NoSeg
%     S{i} = ismember(L,selectedIdx(i));
% 
% end
% 
% end

% % I feel more comfortable with the 0-1 range
% maxValue = max(im(:));
% im=im./maxValue;
% 
% %Threshold is set to 0.2, it gave me the best jaccard score and when I
% %tested built in functions like graythresh it did not perform as good. I
% %also thought that this is not where the biggest problem is and focused
% %more on other aspect of the segmentation. 
% 
% threshold_image = im > 0.2;
% 
% % Had a problem with 2-3 images that were blurry so that the bwlabel
% % registred very small segments of a pixel, to eliminate those I looked up
% % the properties of bwlabel and decided to use the Area stat to filter
% % those out. This really made a big difference in the Jaccard score.
% [L,num]=bwlabel(threshold_image);
% stats= regionprops(L, 'Area');
% validSegments = 0;
% 
% %Since L is a matrix from bwlabel that now have different regions  
% % with values from 1 to nbrsegments I create a mask from L and use
% % element-wise multiplication with the image matrix to have only one image 
% % at a time. Each segment is also checked upon if the area is greater than
% %  1 to eliminate most of the wrongly segmented sections from bwlabel
% for i = 1:num
%     mask = L == i;
%     %segment= im .* mask;
%     if stats(i).Area > 3
%             validSegments = validSegments + 1;
%             S{validSegments} = mask;
%     end
% end
% 
% S = S(1:validSegments);
