clear
clc
close all

%
%% 破损玉米粒检测主函数
%
%


%% 读取图像部分

% % 读取原图
% I=imread('pic\2011060309265708.jpg');

% 读取图像
[filename,pathname,filter] = uigetfile({'*.jpg;*.jpeg;*.bmp;*.gif;*.png'},'选择图片');
if filter == 0
    return
end
str = fullfile(pathname,filename);
I=imread(str);
I0=I;
% I=imresize(I,[696 928]);

% 显示
figure
imshow(I);
title('原图');


%% 二值化部分

[M,N,C]=size(I);

% 转灰度图
if C>1
    I_gray=rgb2gray(I);
else
    I_gray=I;
end


% 显示
figure
imshow(I_gray);
title('灰度图');

I_bw=im2bw(I_gray,0.25);
figure
imshow(I_bw);
title('二值图');


%% 形态学处理

I_bw=bwareaopen(I_bw,150);

figure
imshow(I_bw);
title('去噪');
figure
imshow(I_bw);
title('标定');
hold on;
[B,L]=bwboundaries(I_bw,'noholes');
stats=regionprops(L,'all');

for k = 1:length(B)

  % 获取边界坐标
  boundary = B{k};

  % 获取周长
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % 获取面积
  
  area = stats(k).Area;
  F=area/(stats(k).BoundingBox(3)*stats(k).BoundingBox(4));
  a(1,k)=F;
  major=stats(k).MajorAxisLength;
  minor=stats(k).MinorAxisLength;
  E=major/minor;
  c(1,k)=E;
  % 计算圆形度
  metric = 4*pi*area/perimeter^2;
  b(1,k)=metric;
  % 保存面积
  MyDatabase(k,1)=area;
  % 保存周长
  MyDatabase(k,2)=perimeter;
  % 保存圆形度
  MyDatabase(k,3)=metric;
  
  % 判断
    res_str='标定';
          MyDatabase(k,4)=1;
          rectangle('Position',stats(k).BoundingBox,'EdgeColor','g');
          text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','g', 'FontWeight','bold', 'FontSize',8);
end

figure
imshow(I);
title('识别后的图像');
hold on;


%% 标记部分

% 标记
[B,L]=bwboundaries(I_bw,'noholes');
stats=regionprops(L,'all');
a=zeros(1,length(B));
b=zeros(1,length(B));
c=zeros(1,length(B));
% 设置存储特征数据变量
MyDatabase=zeros(length(B),4);

% 对每个标定对象进行处理
for k = 1:length(B)

  % 获取边界坐标
  boundary = B{k};

  % 获取周长
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % 获取面积
  
  area = stats(k).Area;
  F=area/(stats(k).BoundingBox(3)*stats(k).BoundingBox(4));
  a(1,k)=F;
  major=stats(k).MajorAxisLength;
  minor=stats(k).MinorAxisLength;
  E=major/minor;
  c(1,k)=E;
  % 计算圆形度
  metric = 4*pi*area/perimeter^2;
  b(1,k)=metric;
  % 保存面积
  MyDatabase(k,1)=area;
  % 保存周长
  MyDatabase(k,2)=perimeter;
  % 保存圆形度
  MyDatabase(k,3)=metric;
  
  % 判断
   if area>=1595
      if (F>0.66)
          res_str='合格';
          % 保存 
          MyDatabase(k,4)=1;
          rectangle('Position',stats(k).BoundingBox,'EdgeColor','g');
          text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','g', 'FontWeight','bold', 'FontSize',8);
      else
          res_str='破损';
          MyDatabase(k,4)=0;
          rectangle('Position',stats(k).BoundingBox,'EdgeColor','r');
          text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','r', 'FontWeight','bold', 'FontSize',8);
      end
  else
      res_str='破损';
      MyDatabase(k,4)=0;
      rectangle('Position',stats(k).BoundingBox,'EdgeColor','r');
          text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','r', 'FontWeight','bold', 'FontSize',8);
  end
  
%   % 标定显示
%   rectangle('Position',stats(k).BoundingBox,'EdgeColor','r'); 
%   % 显示标号
%   text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','r', 'FontWeight','bold', 'FontSize',12);

%   centroid = stats(k).Centroid;
%   plot(centroid(1),centroid(2),'ko');
  
end

% 写入excel文件
xlswrite('特征数据文件.xlsx',MyDatabase);


