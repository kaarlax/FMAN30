f =[3 4 7 4 3 5 6 12];
x =1:8;
plot(x, f);
grid on;

xlabel('x');
ylabel('Grayvalue');

%% PLOT g(x)
x = -3:0.1:3;
y = zeros(size(x)); 

for i = 1:length(x)
    y(i) = g(x(i));
end

plot(x, y);
xlabel('x');
ylabel('g(x)');
title('Plot of g(x)');
%% PLOT F1(x)
x_values = 1:0.1:8;
y = zeros(size(x_values)); 

for i = 1:length(x_values)
    y(i) = F1(x_values(i));
end

plot(x_values, y);
xlabel('x');
ylabel('F_g(x)');
title('Plot of F_g(x)');

%% 

c1=[0.4003 0.3988 0.3998 0.3997 0.4010 0.3995 0.3991];
c2=[0.2554 0.3139 0.2627 0.3802 0.3287 0.3160 0.2924];
c3=[0.5632 0.7687 0.0524 0.7586 0.4243 0.5005 0.6769];

X_train=[c1(1:4),c2(1:4),c3(1:4)];
X_test =[c1(5:7),c2(5:7),c3(5:7)];
y_train=[1 1 1 1 2 2 2 2 3 3 3 3];
y_test=[1 1 1 2 2 2 3 3 3];

predicted_labels = knn(X_train, y_train, X_test);
tp=[];

for i=1:length(predicted_labels)
    if predicted_labels(i)==y_test(i)
        tp=[tp,predicted_labels(i)];
    end
end

accuracy = length(tp) / length(predicted_labels);
fprintf('Accuracy: %f\n', accuracy);

%% 3.2 Gaussian distribution
c1=[0.4003 0.3988 0.3998 0.3997 0.4010 0.3995 0.3991];
c2=[0.2554 0.3139 0.2627 0.3802 0.3287 0.3160 0.2924];
c3=[0.5632 0.7687 0.0524 0.7586 0.4243 0.5005 0.6769];

m1=0.4;
m2=0.32;
m3=0.55;

sigma1=0.01;
sigma2=0.05;
sigma3=0.2;

prior=1/3;
correct=[];
max=[];

for i = 1:length(c1)
    p_C1 = normpdf(c2(i), m1, sigma1);
    p_C2 = normpdf(c2(i), m2, sigma2);
    p_C3 = normpdf(c2(i), m3, sigma3);
    p_x = (p_C1*prior+p_C2*prior+p_C3*prior);

    post_C1 =(p_C1*prior)/(p_x);
    post_C2 =(p_C2*prior)/(p_x);
    post_C3 =(p_C3*prior)/(p_x);
    
    if post_C2 > post_C1 && post_C2 >post_C3
        correct=[correct,1];
    end

   
end
length(correct)
%% 
image(:,1) = [0 1 1 0];
image(:,2) = [1 0 0 1];
image(:,3) = [1 1 1 0];
observed_i = [0 1 1 1];
prior=[0.25 0.5 0.25];
error_rate=[0.1 0.4];
likelihood_list=[];

for j=1:width(image)
    likelihood=1;
    for i=1:length(observed_i)
        pixel=image(i,j);
        if pixel == observed_i(i)
            p=1-(error_rate(2));
            likelihood = likelihood*p;
        else
            p=error_rate(2);
            likelihood = likelihood*p;
        end
      
    end
likelihood_list=[likelihood_list,likelihood];
end
lh_prior =likelihood_list.*prior;

total = sum(lh_prior);

posteriori = lh_prior ./ total

map= max(posteriori)

%% 
prior=[0.3 0.2 0.2 0.3];
error_rate=0.2;
likelihood_list=[];

correct_im = [0 1 1 1; 1 0 1 1; 1 1 0 1; 1 0 1 1];

for n = 1:4
image = ones(4,4);
image(1:4, n) = zeros(4,1);
likelihood = 1;

    for i = 1:4
        for j =1:4
            if image(i,j) == correct_im(i,j)
                likelihood =likelihood*(1-error_rate);
            else
                likelihood =likelihood*error_rate;
            end
        end
    end
    likelihood_list=[likelihood_list,likelihood];
end

lh_prior = likelihood_list.*prior;
total = sum(lh_prior);

posteriori = lh_prior ./ total
%% 
prior=[0.35 0.4 0.25];
error_white_black=[0.3 0.2];
correct_white_black=[1 1] -error_white_black;
likelihood =1;


imB= [0 0 1; 0 1 0; 0 0 1; 0 1 0;0 0 1];
im0= [1 0 1; 0 1 0; 0 1 0; 0 1 0;1 0 1];
im8= [1 0 1; 0 1 0; 1 0 1; 0 1 0;1 0 1];
imx= [1 1 1; 0 1 1; 1 0 1; 1 1 0;0 0 1];

for i = 1:5
        for j =1:3
            if im8(i,j) == 1
                if imx(i,j)==1
                    likelihood = likelihood *correct_white_black(1);
                else
                    likelihood = likelihood *error_white_black(1);
                end
            else
                if imx(i,j)==1
                    likelihood=likelihood *error_white_black(2);
                else
                    likelihood=likelihood *correct_white_black(2);
                end
            end
        end
end
    eight=likelihood
    %% 
likelihood_list=[b noll eight];

lh_prior = likelihood_list.*prior;
total = sum(lh_prior);

posteriori = lh_prior ./ total

%% 
function [summa] =F1(x)
f =[3 4 7 4 3 5 6 12];
summa = 0;
for i=1:8
    t = g(x-i);
    summa= summa + (t*f(i));
end
end
%% 

function result = g(x)
if abs(x) <= 1
    result = cos(pi/2 * x);
elseif abs(x) > 1 && abs(x) <= 2
    result = (-pi/2) * ((abs(x)^3) - (5 * abs(x)^2) + (8 * abs(x)) - 4);
else
    result = 0;
end
end



%% 
function distance=d(x1,x2)
distance= abs(x1-x2);
end
%% 
function clf = knn(x_train,y_train,x_test)
labels=[];
for i = 1:length(x_test)
    current=x_test(i);
    point=[];
    for j = 1:length(x_train)
        dist=d(x_train(j),current);
        point=[point,dist];
    end
    [~, index] = min(point);
    labels=[labels,y_train(index)];
end
clf=labels;
end


