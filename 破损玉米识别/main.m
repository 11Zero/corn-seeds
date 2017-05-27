clear
clc
close all

%
%% �������������������
%
%


%% ��ȡͼ�񲿷�

% % ��ȡԭͼ
% I=imread('pic\2011060309265708.jpg');

% ��ȡͼ��
[filename,pathname,filter] = uigetfile({'*.jpg;*.jpeg;*.bmp;*.gif;*.png'},'ѡ��ͼƬ');
if filter == 0
    return
end
str = fullfile(pathname,filename);
I=imread(str);
I0=I;
% I=imresize(I,[696 928]);

% ��ʾ
figure
imshow(I);
title('ԭͼ');


%% ��ֵ������

[M,N,C]=size(I);

% ת�Ҷ�ͼ
if C>1
    I_gray=rgb2gray(I);
else
    I_gray=I;
end


% ��ʾ
figure
imshow(I_gray);
title('�Ҷ�ͼ');

I_bw=im2bw(I_gray,0.25);
figure
imshow(I_bw);
title('��ֵͼ');


%% ��̬ѧ����

I_bw=bwareaopen(I_bw,150);

figure
imshow(I_bw);
title('ȥ��');
figure
imshow(I_bw);
title('�궨');
hold on;
[B,L]=bwboundaries(I_bw,'noholes');
stats=regionprops(L,'all');

for k = 1:length(B)

  % ��ȡ�߽�����
  boundary = B{k};

  % ��ȡ�ܳ�
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % ��ȡ���
  
  area = stats(k).Area;
  F=area/(stats(k).BoundingBox(3)*stats(k).BoundingBox(4));
  a(1,k)=F;
  major=stats(k).MajorAxisLength;
  minor=stats(k).MinorAxisLength;
  E=major/minor;
  c(1,k)=E;
  % ����Բ�ζ�
  metric = 4*pi*area/perimeter^2;
  b(1,k)=metric;
  % �������
  MyDatabase(k,1)=area;
  % �����ܳ�
  MyDatabase(k,2)=perimeter;
  % ����Բ�ζ�
  MyDatabase(k,3)=metric;
  
  % �ж�
    res_str='�궨';
          MyDatabase(k,4)=1;
          rectangle('Position',stats(k).BoundingBox,'EdgeColor','g');
          text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','g', 'FontWeight','bold', 'FontSize',8);
end

figure
imshow(I);
title('ʶ����ͼ��');
hold on;


%% ��ǲ���

% ���
[B,L]=bwboundaries(I_bw,'noholes');
stats=regionprops(L,'all');
a=zeros(1,length(B));
b=zeros(1,length(B));
c=zeros(1,length(B));
% ���ô洢�������ݱ���
MyDatabase=zeros(length(B),4);

% ��ÿ���궨������д���
for k = 1:length(B)

  % ��ȡ�߽�����
  boundary = B{k};

  % ��ȡ�ܳ�
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % ��ȡ���
  
  area = stats(k).Area;
  F=area/(stats(k).BoundingBox(3)*stats(k).BoundingBox(4));
  a(1,k)=F;
  major=stats(k).MajorAxisLength;
  minor=stats(k).MinorAxisLength;
  E=major/minor;
  c(1,k)=E;
  % ����Բ�ζ�
  metric = 4*pi*area/perimeter^2;
  b(1,k)=metric;
  % �������
  MyDatabase(k,1)=area;
  % �����ܳ�
  MyDatabase(k,2)=perimeter;
  % ����Բ�ζ�
  MyDatabase(k,3)=metric;
  
  % �ж�
   if area>=1595
      if (F>0.66)
          res_str='�ϸ�';
          % ���� 
          MyDatabase(k,4)=1;
          rectangle('Position',stats(k).BoundingBox,'EdgeColor','g');
          text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','g', 'FontWeight','bold', 'FontSize',8);
      else
          res_str='����';
          MyDatabase(k,4)=0;
          rectangle('Position',stats(k).BoundingBox,'EdgeColor','r');
          text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','r', 'FontWeight','bold', 'FontSize',8);
      end
  else
      res_str='����';
      MyDatabase(k,4)=0;
      rectangle('Position',stats(k).BoundingBox,'EdgeColor','r');
          text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','r', 'FontWeight','bold', 'FontSize',8);
  end
  
%   % �궨��ʾ
%   rectangle('Position',stats(k).BoundingBox,'EdgeColor','r'); 
%   % ��ʾ���
%   text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','r', 'FontWeight','bold', 'FontSize',12);

%   centroid = stats(k).Centroid;
%   plot(centroid(1),centroid(2),'ko');
  
end

% д��excel�ļ�
xlswrite('���������ļ�.xlsx',MyDatabase);


