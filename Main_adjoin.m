function result = Main_adjoin(filename)
close all;
[B source]= Readimg_adjoin(filename);%��ȡÿ�������������������µ����ؼ���
result = source;
%load svmStruct  
figure(1);
hold on;
B_items_tangle = zeros(length(B),4);
img_with_rect = source;
imshow(img_with_rect);
global svmStruct;
svmStruct = load('C:\Users\Administrator\Desktop\corn-seeds\svmStruct.mat');
svmStruct = svmStruct.svmStruct;
for i=1:length(B)
    B_max = max(B{i});
    B_min = min(B{i});
    B_items_tangle(i,1) = B_min(1);%1234λ�ֱ������ο��������������λ
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
    B_item_circum = length(find(B_item==255));
    if(B_item_circum>250)%����Ϊ�ܳ�>250����Ԫ��Ϊ��ճ��
        splitter(B_item);
    end
%     set(B_item,'position',[0,0,70,70])
%     im=imresize(B_item,[70,70]);
%     hogt =hogcalculator(im);  
%     assess = svmclassify(svmStruct,hogt);%assess��ֵ��Ϊ������  
    assess = Judgeimg(rotateimg(B_item,B{i}));
    %rectangle('Position',[0,0,10,20],'EdgeColor','r');
    %img_with_rect = drawRect(img_with_rect,[B_items_tangle(i,3),B_items_tangle(i,1)],[B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],1,[255,0,0]);
    if(assess>0.9)
        rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','g');
    else
        rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','r');
    end
        text(B_items_tangle(i,3),B_items_tangle(i,1),sprintf('%d',287+i),'color','g');
    %line([B_items_tangle(i,3) B_items_tangle(i,1)],[B_items_tangle(i,4) B_items_tangle(i,1)],'color','b','LineWidth',3);
     B_items{i,1} = B_item;%��ȡÿ�������������������
%      path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds',sprintf('%03d.jpg',287+i));
%      imwrite(B_item,path,'jpg');
end

B_items_circum = zeros(length(B_items),1);%�ܳ�
B_items_area = zeros(length(B_items),1);%���
B_items_area_per = zeros(length(B_items),1);%���ռ�����������ٷֱ�
B_items_area_average_per = zeros(length(B_items),1);%���ռƽ������ٷֱ�
B_items_totol_area = 0;%�������ӵ������
B_items_totol_tangle_area = 0;%�����������ھ��ε������
items_num = length(B);
for i = 1:items_num
    %subplot(3,5,i),imshow(B_items{i});
    B_items_circum(i,1) = length(find(B_items{i}==255));
    if(B_items_circum(i,1)>250)
        
    end
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
figure;
plot(result);
title(filename);
for i = 1:items_num
    B_items_area_average_per(i,1) = B_items_area(i,1)/(B_items_totol_tangle_area/items_num);
end


function B = rotateimg(source,border_cource)
angel = round(ExerciseOval(border_cource)*180/pi);
big_source = imresize(source,[200,200]);
B = imrotate(big_source,angel,'bilinear','crop');
B = imresize(B,size(source));
B = im2bw(B,0.99);%��ֵ��ȥ��ë��
H = fspecial('unsharp');
B = imfilter(B,H,'replicate');%������˹��


function alpha = ExerciseOval(source_border)
%?�����Բ�����߶�
%?���Բ׶���߷���?
B_max = max(source_border);
B_min = min(source_border);
B_max(1) = -B_max(1);
B_min(1) = -B_min(1);
    for j=1:size(source_border,1)
        source_border(j,1) = -source_border(j,1);
        source_border(j,1) = source_border(j,1) - B_min(1)+1+floor(((70-(B_max(1)-B_min(1)))/2));
        source_border(j,2) = source_border(j,2) - B_min(2)+1+floor(((70-(B_max(2)-B_min(2)))/2));
    end
F=@(p,x)p(1)*x(:,1).^2+p(2)*x(:,1).*x(:,2)+p(3)*x(:,2).^2+p(4)*x(:,1)+p(5)*x(:,2)+p(6);%��Բһ�㷽��
%?��ɢ���ݵ�
Up=source_border;%excel�ļ�·��
%?p0ϵ����ֵ
p0=[1 1 1 1 1 1];
%?���ϵ������С���˷���?
p=nlinfit(Up,zeros(size(Up,1),1),F,p0);
A=p(1)/p(6);
B=p(2)/p(6);
C=p(3)/p(6);
D=p(4)/p(6);
E=p(5)/p(6);
%�������
alpha=0.5 * atan(B/(A-C));%�ҵ�������ǣ��Ա���ת


function result = splitter(adjoin_item)


function result = Judgeimg(img_mat)
%% ѵ����ɺ󱣴� svmStruct���ɶ�������Ķ�����з�����������ִ������ѵ���׶δ���  
img=img_mat; 
im=imresize(img,[64,64]);  
hogt =hogcalculator(im); 
global svmStruct;%ȫ���������ṹ
result = svmclassify(svmStruct,hogt);%result��ֵ��Ϊ������  