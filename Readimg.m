function [B ,source]= Readimg(fullfilename,handles)
%str = fullfile('pics',filename);
I=imread(fullfilename);
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

%figure(2001);


axes(handles.axes_origin);
imshow(I_gray);
I_bw=im2bw(I_gray,0.25);

%% 形态学处理

I_bw=bwareaopen(I_bw,150);


%% 标记部分
% 标记
[B,L]=bwboundaries(I_bw,'noholes');
