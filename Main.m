function result = Main(filename)
[B source]= Readimg(filename);%获取每个种子轮廓绝对坐标下的像素集合
result = source;
%load svmStruct  

B_items_tangle = zeros(length(B),4);
img_with_rect = source;
img1 = figure(1);
imshow(img_with_rect);
global svmStruct;
svmStruct = load('svmStruct.mat');
svmStruct = svmStruct.svmStruct;
for i=1:length(B)
    B_max = max(B{i});
    B_min = min(B{i});
    B_items_tangle(i,1) = B_min(1);%1234位分别代表矩形框的上下左右像素位
    B_items_tangle(i,2) = B_max(1);
    B_items_tangle(i,3) = B_min(2);
    B_items_tangle(i,4) = B_max(2);
    for j=1:size(B{i},1)
        B{i}(j,1) = B{i}(j,1) - B_min(1)+1;
        B{i}(j,2) = B{i}(j,2) - B_min(2)+1;
    end
    B_max = max(B{i});
    B_min = min(B{i});
    seed_rect_length = 70;
    if(B_max(1)+2>seed_rect_length || B_max(2)+2>seed_rect_length)
        if(B_max(1)>B_max(2))
            seed_rect_length = B_max(1)+2;
        else
            seed_rect_length = B_max(2)+2;
        end
    end
    B_item = zeros(seed_rect_length,seed_rect_length);
    for j=1:size(B{i},1)
        B_item(floor((seed_rect_length - B_max(1)+2)/2)+B{i}(j,1)+1,floor((seed_rect_length - B_max(2)+2)/2)+B{i}(j,2)+1) = 255;
    end
%     set(B_item,'position',[0,0,70,70])
%     im=imresize(B_item,[70,70]);
%     hogt =hogcalculator(im);  
%     assess = svmclassify(svmStruct,hogt);%assess的值即为分类结果  
    assess = Judgeimg(rotateimg(B_item,B{i}));
    %rectangle('Position',[0,0,10,20],'EdgeColor','r');
    %img_with_rect = drawRect(img_with_rect,[B_items_tangle(i,3),B_items_tangle(i,1)],[B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],1,[255,0,0]);
    figure(img1);
    if(assess>0.9)
        rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','g');
    else
        rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','r');
    end
        text(B_items_tangle(i,3),B_items_tangle(i,1),sprintf('%d',i),'color','g');
    %line([B_items_tangle(i,3) B_items_tangle(i,1)],[B_items_tangle(i,4) B_items_tangle(i,1)],'color','b','LineWidth',3);
     B_items{i,1} = B_item;%获取每个种子相对坐标下像素
%      path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds',sprintf('%03d.jpg',296+i));
%      imwrite(rotateimg(B_items{i},B{i}),path,'jpg');
end

%disp(B_items_tangle);

B_items_circum = zeros(length(B_items),1);%周长
B_items_area = zeros(length(B_items),1);%面积
B_items_area_per = zeros(length(B_items),1);%面积占本身矩形面积百分比
B_items_area_average_per = zeros(length(B_items),1);%面积占平均面积百分比
B_items_totol_area = 0;%各个种子的总面积
B_items_totol_tangle_area = 0;%各个种子所在矩形的总面积
items_num = length(B);
for i = 1:items_num
    %subplot(3,5,i),imshow(B_items{i});
    B_items_circum(i,1) = length(find(B_items{i}==255));
    B_item = B_items{i};
    item_inside = B_item>150; % inside
    item_inside = bwfill(item_inside,'holes');
    item_inside = bwareaopen(item_inside,1000);
    B_items_area(i,1) = length(find(item_inside==1));
    B_items_totol_area = B_items_totol_area+B_items_area(i,1);
    B_items_area_per(i,1) = 100*B_items_area(i,1)./(size(B_item,1)*size(B_item,2));
    B_items_totol_tangle_area = B_items_totol_tangle_area+size(B_item,1)*size(B_item,2);
    %subplot(3,5,i+5),imshow(item_inside),title('inside');
end
result = B_items_circum;
img2 = figure(2);
figure(img2);
plot(result);
for i = 1:items_num
    B_items_area_average_per(i,1) = B_items_area(i,1)/(B_items_totol_tangle_area/items_num);
end

%imshow(B{1});


%imshow(B{2});
% imshow(rotateimg(B_items{1},B{1}));

% figure;
% ExerciseOval(B{3});
% figure;
% ExerciseOval(B{4});
% figure;
% ExerciseOval(B{5});
end



function alpha = ExerciseOval(source_border)
%?拟合椭圆型曲线段
%?设出圆锥曲线方程?
B_max = max(source_border);
B_min = min(source_border);
B_max(1) = -B_max(1);
B_min(1) = -B_min(1);
    for j=1:size(source_border,1)
        source_border(j,1) = -source_border(j,1);
        source_border(j,1) = source_border(j,1) - B_min(1)+1+floor(((70-(B_max(1)-B_min(1)))/2));
        source_border(j,2) = source_border(j,2) - B_min(2)+1+floor(((70-(B_max(2)-B_min(2)))/2));
    end
F=@(p,x)p(1)*x(:,1).^2+p(2)*x(:,1).*x(:,2)+p(3)*x(:,2).^2+p(4)*x(:,1)+p(5)*x(:,2)+p(6);%椭圆一般方程
%?离散数据点
Up=source_border;%excel文件路径
%?p0系数初值
p0=[1 1 1 1 1 1];
%?拟合系数，最小二乘方法?
p=nlinfit(Up,zeros(size(Up,1),1),F,p0);
A=p(1)/p(6);
B=p(2)/p(6);
C=p(3)/p(6);
D=p(4)/p(6);
E=p(5)/p(6);
% X_center = (B*E-2*C*D)/(4*A*C - B^2);
% Y_center = (B*D-2*A*E)/(4*A*C - B^2);
%长轴倾角
alpha=0.5 * atan(B/(A-C));%找到长轴倾角，以便旋转
end

function B = rotateimg(source,border_cource)
angel = round(ExerciseOval(border_cource)*180/pi);
big_source = imresize(source,[200,200]);
B = imrotate(big_source,angel,'bilinear','crop');
B = imresize(B,size(source));
B = im2bw(B,0.99);%二值化去除毛刺
H = fspecial('unsharp');
B = imfilter(B,H,'replicate');%拉普拉斯锐化
end
% figure;
% imshow(B);
function result = Judgeimg(img_mat)
%% 训练完成后保存 svmStruct即可对新输入的对象进行分类了无需再执行上面训练阶段代码  
img=img_mat; 
im=imresize(img,[64,64]);  
hogt =hogcalculator(im); 
global svmStruct;%全局向量机结构
result = svmclassify(svmStruct,hogt);%result的值即为分类结果  
end
