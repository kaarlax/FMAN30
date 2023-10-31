function features = segment2features(I)


digit = regionprops(I,'all').Image;
square = imresize(digit, [400, 400]);
[m,n] = size(square);

% corner_sum = 0;
% kernel_size=5;

% for i = [1, m - kernel_size + 1]
%     for j = [1, n - kernel_size + 1]
%         corner_region=square(i:i+kernel_size-1, j:j+kernel_size-1);
%         corner_value = sum(corner_region(:));
%         corner_sum = corner_sum + corner_value;
%     end
% end
% 
% corners_value_norm = corner_sum / (4 * kernel_size^2);
% features(1)=corners_value_norm;


top_left=sum(square(1:ceil(m/3),1:ceil(n/2)),'all'); %top left
top_right=sum(square(1:ceil(m/3),ceil(n/2):n), 'all'); %top right
m_left=sum(square(ceil(m/3):ceil((2*m)/3),1:ceil(n/2)),'all'); %middle left
m_right=sum(square(ceil(m/3):ceil((2*m)/3),ceil(n/2):n),'all'); %middle right
bot_left=sum(square(ceil((2*m)/3):m,1:ceil(n/2)),'all'); %bottom left
bot_right=sum(square(ceil((2*m)/3):m,ceil(n/2)+1:n),'all'); %bottom right

sumpxl = sum(square(:));
white_pxl=sumpxl/numel(square);

features=5*[top_left,m_left,bot_left,top_right,m_right,bot_right]./sumpxl;


holes = bwconncomp(~I);          
holes_no = holes.NumObjects - 1;
if holes_no > 3
    holes_no=3;
end
features(7)=holes_no;

rl_ratio=(top_left+m_left+bot_left)/(top_right+m_right+bot_right);
tb_ratio=(top_left+top_right)/(bot_left+bot_right);
if rl_ratio>2
    rl_ratio=2;
elseif rl_ratio < -2
    rl_ratio=-2;
end

if tb_ratio>2
    tb_ratio=2;
elseif tb_ratio < -2
    tb_ratio=-2;
end

horiz_edges = edge(square, 'Sobel', [], 'horizontal');
vert_edges = edge(square, 'Sobel', [], 'vertical');

% Count the number of pixels with edges in each direction
horiz_edges = sum(horiz_edges(:));
vert_edges = sum(vert_edges(:));



mom=(round(sum(moment(square,3)))+180)/180;

features(8)=white_pxl;
features(9)=rl_ratio;
features(10)=tb_ratio;
features(11)=mom;
features(12)=50*horiz_edges/sumpxl;
features(13)=50*vert_edges/sumpxl;


% 
% E=regionprops(square,'Eccentricity'); %new
% features(8)=[E.Eccentricity];
% 
% C=regionprops(square,'Circularity'); %new
% features(9)=[C.Circularity];
% 
% stats = regionprops(square, 'Centroid'); %new
% features(10) = stats.Centroid(1)/n;
% features(11) = stats.Centroid(2)/m;


% [rows, cols] = find(I==1);
% min_cols = min(cols);
% max_cols = max(cols);
% min_rows = min(rows);
% max_rows = max(rows);
% 
% square = I(min_rows:max_rows, min_cols:max_cols); %create a square containing only the number for a segment
% 
% [m, n]=size(square); 
% 
% sumpxl = sum(square(:));
% 
% sums_seg=zeros(6,1);
% sums_seg(1)=sum(square(1:floor(m/3),1:floor(n/2)),'all'); %top left
% sums_seg(4)=sum(square(1:floor(m/3),floor(n/2)+1:n), 'all'); %top right
% sums_seg(2)=sum(square(floor(m/3)+1:floor((2*m)/3),1:floor(n/2)),'all'); %middle left
% sums_seg(5)=sum(square(floor(m/3)+1:floor((2*m)/3),floor(n/2)+1:n),'all'); %middle right
% sums_seg(3)=sum(square(floor((2*m)/3)+1:m,1:floor(n/2)),'all'); %bottom left
% sums_seg(6)=sum(square(floor((2*m)/3)+1:m,floor(n/2)+1:n),'all'); %bottom right 
% 
% 
% a=(sums_seg(1)+sums_seg(2))/sum(sums_seg); %top/middle left 
% 
% b=(sums_seg(1)+sums_seg(4)+sums_seg(5)+sums_seg(2))/sum(sums_seg); %Upper(top mid)
% 
% c=(sums_seg(1)+sums_seg(4))/sum(sums_seg);%only top
% 
% d=(sums_seg(1)+sums_seg(4)+sums_seg(3)+sums_seg(6))/sum(sums_seg); %top bot 
% 
% e=(sums_seg(1)+sums_seg(6))/sum(sums_seg); %left top and right bot
% 
% f=(sums_seg(3)+sums_seg(4))/sum(sums_seg); %top right left bot
% 
% g=(sums_seg(1)+sums_seg(2)+sums_seg(3))/sum(sums_seg); %left side vs all
% h=(sums_seg(4)+sums_seg(5)+sums_seg(6))/sum(sums_seg); %left side vs all
% 
% i=sums_seg(2)/sum(sums_seg);
% 
% E=regionprops(square,'Eccentricity'); %new
% C=regionprops(square,'Circularity'); %new
% P=regionprops(square,'Perimeter');
% perimeter=P.Perimeter/(bwarea(square)); %new
% 
% % stats = regionprops(square, 'Centroid'); %new
% % features(8) = stats.Centroid(1)/n;
% % features(9) = stats.Centroid(2)/m;
% area_number=bwarea(square)/(m*n); %Area of the number
% 
% 
% features=[1-a,b,c,d,e,f,g,1-i,[E.Eccentricity],[C.Circularity], area_number];
% 
% end

% FIRST DRAFT BEST PERCENTAGE YET
% -------------------------------------------------------------------------
% features = zeros(10,1); %11 features
% function features = segment2features(I) 
% [rows, cols] = find(I==1);
% min_cols = min(cols);
% max_cols = max(cols);
% min_rows = min(rows);
% max_rows = max(rows);
% 
% square = I(min_rows:max_rows, min_cols:max_cols); 
% 
% % digit = regionprops(I,'all').Image;
% % square = imresize(digit, [400, 400]);
% 
% [m, n]=size(square); 
% 
% features(1)= m/(m+n); % %Length of number
% 
% features(2)= n/(m+n); % %Width of number 
% 
% %Corners
% corner_sum = 0;
% kernel_size=4;
% 
% for i = [1, m - kernel_size + 1]
%     for j = [1, n - kernel_size + 1]
%         corner_region=square(i:i+kernel_size-1, j:j+kernel_size-1);
%         corner_value = sum(corner_region(:));
%         corner_sum = corner_sum + corner_value;
%     end
% end
% 
% corners_value_norm = corner_sum / (4 * kernel_size^2);
% 
% features(3) = corners_value_norm; %of 1's in the four corners 
% 
% %features(4)=sum(square(ceil(m/2)-2:ceil(m/2)+2,ceil(n/2)-2:ceil(n/2)+2),'all')/(25);
% 
% % holes = bwconncomp(~I);          
% % holes_no = holes.NumObjects - 1;
% % features(4)=holes_no/2;
% 
% 
% features(4)=bwarea(square)/(m*n); %Area of the number
% 
% mom=moment(square,3);
% features(5)=mean(mom); %Mean skewness in binary image
% 
% E=regionprops(square,'Eccentricity'); %new
% features(6)=[E.Eccentricity];
% 
% C=regionprops(square,'Circularity'); %new
% features(7)=[C.Circularity];
% 
% stats = regionprops(square, 'Centroid'); %new
% features(8) = stats.Centroid(1)/n;
% features(9) = stats.Centroid(2)/m;
% 
% %P=regionprops(square,'Perimeter');
% %features(10)=P.Perimeter/(bwarea(square)); %new
% 
% features(10) = sum(sum(square))/(m*n); %new

% col_sums=sum(square);
% row_sums=sum(square,2);
% max_val_rows=max(row_sums);
% max_val_cols=max(col_sums);
% features(11)=max_val_cols/n;
% features(12)=max_val_rows/m;

end

%% SECOND DRAFT
% function features = segment2features(I)
% 
% 
% %features = zeros(11,1); %11 features
% 
% [rows, cols] = find(I==1);
% min_cols = min(cols);
% max_cols = max(cols);
% min_rows = min(rows);
% max_rows = max(rows);
% 
% square = I(min_rows:max_rows, min_cols:max_cols); %create a square containing only the number for a segment
% 
% [m, n]=size(square); 
% 
% L= m/(m+n); % %Length of number
% 
% W=n/(m+n); % %Width of number 
% 
% sums_seg=zeros(6,1);
% sums_seg(1)=sum(square(1:floor(m/3),1:floor(n/2)),'all'); %top left
% sums_seg(4)=sum(square(1:floor(m/3),floor(n/2)+1:n), 'all'); %top right
% sums_seg(2)=sum(square(floor(m/3):floor((2*m)/3),1:floor(n/2)),'all'); %middle left
% sums_seg(5)=sum(square(floor(m/3):floor((2*m)/3),floor(n/2)+1:n),'all'); %middle right
% sums_seg(3)=sum(square(floor((2*m)/3):m,1:floor(n/2)),'all'); %bottom left
% sums_seg(6)=sum(square(floor((2*m)/3):m,floor(n/2)+1:n),'all'); %bottom right 
% sumpxl = sum(square(:));
% 
% sums_seg=sums_seg./sumpxl;
% 
% 
% area_n=bwarea(square)/(m*n); %Area of the number
% % 
% mom=moment(square,3);
% skew=mean(mom); %Mean skewness in binary image
% 
% E=regionprops(square,'Eccentricity');
% 
% C=regionprops(square,'Circularity');
% 
% stats = regionprops(square, 'Centroid');
% c_n=stats.Centroid(1)/n;
% c_m=stats.Centroid(2)/m;
% 
% pxl_per_area = sumpxl/(m*n);
% 
% sum_square = sum(sum(square))/(m*n);
% 
% P=regionprops(square,'Perimeter');
% P_f=P.Perimeter/(bwarea(square)); %new
% 
% %features= [pxl_per_area,sums_seg(1),sums_seg(2),sums_seg(3),sums_seg(4),sums_seg(5),sums_seg(6)];
% %features=[L, W, area_n,skew,[E.Eccentricity],[C.Circularity],c_n,c_m,P_f];
% 
% %area_n,skew,[E.Eccentricity], [C.Circularity], c_n, c_m, sum_square
% 
% %Graveyard
% % E=regionprops(square,'EulerNumber');
% % features(11)=E.EulerNumber/3;
% 
% % centroids = regionprops(square, 'centroid');
% % features(8) = (centroids.Centroid(1)*centroids.Centroid(2))/(m*n);
% 
% corner_sum = 0;
% kernel_size=2;
% 
% for i = [1, m - kernel_size + 1]
%     for j = [1, n - kernel_size + 1]
%         corner_region=square(i:i+kernel_size-1, j:j+kernel_size-1);
%         corner_value = sum(corner_region(:));
%         corner_sum = corner_sum + corner_value;
%     end
% end
% 
% corners_value_norm = corner_sum / (4 * kernel_size^2);
% corner_f = corners_value_norm; % %of 1's in the four corners 
% 
% features=[L, W, area_n,skew,[E.Eccentricity],[C.Circularity],c_n,c_m,P_f, corner_f, sum_square];
