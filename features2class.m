% REPLACE WITH YOUR OWN FUNCTION
function y = features2class(x,classification_data)
    [m, n] = size(classification_data);
    mx = length(x);
    dist_sum = [];

    for i = 1:n
        sum_dist = 0; 
        for j = 1:mx
            dist = sqrt((x(j,1) - classification_data(j,i))^2);
            sum_dist = sum_dist + dist;
        end
        dist_sum =[dist_sum,sum_dist];
    end
    [~, index] = sort(dist_sum, 'ascend');

    k = 1;
    index = index(1:k);
    y_coresp = classification_data(m,index);
    y= y_coresp;

%     k = 5;
%     y_all = zeros(1, k);
%    for i = 1:k
%         index_at = index(1:i);
%         y_all(i) = classification_data(m, index_at(i));
%    end
% 
%     class_counts = histcounts(y_all, 1:(max(classification_data(m, :)) + 1));
% 
%     % Find the class with the maximum count
%     [~, max_class_index] = max(class_counts);
% 
%     % Assign the class label
%     y = max_class_index;

end

