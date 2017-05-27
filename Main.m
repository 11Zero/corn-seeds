function B = Main(filename)
[B source]= Readimg(filename);%获取每个种子轮廓绝对坐标下的像素集合
result = source;
figure(1);
imshow(source);
hold on;
B_items_tangle = zeros(length(B),4);
for i=1:length(B)
    B_max = max(B{i});
    B_min = min(B{i});
    B_items_tangle(i,1) = B_min(2);%1234位分别代表矩形框的上下左右像素位
    B_items_tangle(i,2) = B_max(2);
    B_items_tangle(i,3) = B_min(1);
    B_items_tangle(i,4) = B_max(1);
    for j=1:size(B{i},1)
        B{i}(j,1) = B{i}(j,1) - B_min(1)+1;
        B{i}(j,2) = B{i}(j,2) - B_min(2)+1;
    end
    B_max = max(B{i});
    B_min = min(B{i});
    B_item = zeros(B_max(1)+2,B_max(2)+2);
    for j=1:size(B{i},1)
        B_item(B{i}(j,1)+1,B{i}(j,2)+1) = 255;
    end
    rectangle('Position',[0,0,10,20],'EdgeColor','r');
    rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','r');
    %line([B_items_tangle(i,3) B_items_tangle(i,1)],[B_items_tangle(i,4) B_items_tangle(i,1)],'color','b','LineWidth',3);
    B_items{i,1} = B_item;%获取每个种子相对坐标下像素
    %imwrite(B_item,sprintf('%03d.jpg',i),'jpg');
end
disp(B_items_tangle);

B_items_circum = zeros(length(B_items),1);%周长
B_items_area = zeros(length(B_items),1);%面积
B_items_area_per = zeros(length(B_items),1);%面积占本身矩形面积百分比
B_items_area_average_per = zeros(length(B_items),1);%面积占平均面积百分比
B_items_totol_area = 0;%各个种子的总面积
B_items_totol_tangle_area = 0;%各个种子所在矩形的总面积
items_num = 5;
figure(2);
for i = 1:items_num
    subplot(3,5,i),imshow(B_items{i});
    B_items_circum(i,1) = length(find(B_items{i}==255));
    B_item = B_items{i};
    item_inside = B_item>150; % inside
    item_inside = bwfill(item_inside,'holes');
    item_inside = bwareaopen(item_inside,1000);
    B_items_area(i,1) = length(find(item_inside==1));
    B_items_totol_area = B_items_totol_area+B_items_area(i,1);
    B_items_area_per(i,1) = 100*B_items_area(i,1)./(size(B_item,1)*size(B_item,2));
    B_items_totol_tangle_area = B_items_totol_tangle_area+size(B_item,1)*size(B_item,2);
    subplot(3,5,i+5),imshow(item_inside),title('inside');
end

for i = 1:items_num
    B_items_area_average_per(i,1) = B_items_area(i,1)/(B_items_totol_tangle_area/items_num);
end
figure;
%imshow(B{1});
ExerciseOval(B{1});
figure;
%imshow(B{2});
ExerciseOval(B{2});



function ExerciseOval(source_border)
%?拟合椭圆型曲线段
%?设出圆锥曲线方程?
F=@(p,x)p(1)*x(:,1).^2+p(2)*x(:,1).*x(:,2)+p(3)*x(:,2).^2+p(4)*x(:,1)+p(5)*x(:,2)+p(6);%椭圆一般方程
%?离散数据点
Up=source_border;%excel文件路径
UpX=Up(:,1);
UpY=Up(:,2);
%?p0系数初值
p0=[1 1 1 1 1 1];
warning off
%?拟合系数，最小二乘方法?
p=nlinfit(Up,zeros(size(Up,1),1),F,p0);
plot(UpX,UpY,'r.');
hold on;
UpMinx=min(UpX);
UpMaxx=max(UpX);
UpMiny=min(UpY);
UpMaxy=max(UpY);%?作图?
axis equal;
ezplot(@(x,y)F(p,[x,y]),[-1+UpMinx,1+UpMaxx,-1+UpMiny,1+UpMaxy]);
title('曲线拟合');
%legend('样本点','拟合曲线');
% %拟合椭圆边界
% 
% row=length(source_border');%椭圆边界点的个数，超定方程组的方程个数
% %以下构造超定方程组的系数矩阵，5列
% for i=1:row
%     transfor(i,1)=source_border(i,2)^2;
%     transfor(i,2)=source_border(i,2)*source_border(i,2);
%     transfor(i,3)=source_border(i,1)^2;
%     transfor(i,4)=source_border(i,2);
%     transfor(i,5)=source_border(i,1);
% end
% bit=-10000*ones(1,row);
% x=bit*transfor;
% syms xx yy;
% figure;
% h=ezplot(x(1)*xx^2+x(2)*xx*(139-yy)+x(3)*(139-yy)^2+x(4)*xx+x(5)*(139-yy)+10000,[0,195,0,139]);
% set(h,'Color','blue')