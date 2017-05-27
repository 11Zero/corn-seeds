function [B ,source]= Readimg(filename)
str = fullfile('C:\Users\Administrator\Desktop\贺磊\破损玉米识别',filename);
I=imread(str);
source  = I;
I0=I;
% I=imresize(I,[696 928]);

% 显示
%figure
%imshow(I);
%title('原图');
%% 二值化部分

[M,N,C]=size(I);

% 转灰度图
if C>1
    I_gray=rgb2gray(I);
else
    I_gray=I;
end

% 显示
%figure;
%hold on;
%imshow(I_gray);
%title('灰度图');

I_bw=im2bw(I_gray,0.25);
%figure
%imshow(I_bw);
%title('二值图');

%% 形态学处理

I_bw=bwareaopen(I_bw,150);

%figure
%imshow(I_bw);
%title('去噪');
%figure
%imshow(I_bw);
%title('标定');


% %% 边缘查找
% 
% 
% BW1=edge(I_bw,'sobel'); %用SOBEL算子进行边缘检测
% BW2=edge(I_bw,'roberts');%用Roberts算子进行边缘检测
% BW3=edge(I_bw,'prewitt'); %用prewitt算子进行边缘检测
% BW4=edge(I_bw,'log'); %用log算子进行边缘检测
% BW5=edge(I_bw,'canny'); %用canny算子进行边缘检测
% h=fspecial('gaussian',8);
% BW6=edge(I_bw,'canny');
% subplot(2,3,1), %imshow(BW1);
% %title('sobel edge check');
% subplot(2,3,2), %imshow(BW2);
% %title('sobel edge check');
% subplot(2,3,3), %imshow(BW3);
% %title('prewitt edge check');
% subplot(2,3,4), %imshow(BW4);
% %title('log edge check');
% subplot(2,3,5), %imshow(BW5);
% %title('canny edge check');
% subplot(2,3,6), %imshow(BW6);
% %title('gasussian&canny edge check');%此为用高斯滤波后Canny算子边缘检测结果
% %figure
% %imshow(BW6);
% %title('gasussian&canny edge check');%此为用高斯滤波后Canny算子边缘检测结果

%% 标记部分
% 标记
[B,L]=bwboundaries(I_bw,'noholes');
