function B = Main(filename)
[B source]= Readimg(filename);%��ȡÿ�������������������µ����ؼ���
result = source;
%load svmStruct  

figure(1);
hold on;
B_items_tangle = zeros(length(B),4);
img_with_rect = source;
imshow(img_with_rect);
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
    %B_item = zeros(B_max(1)+2,B_max(2)+2);
     B_item = zeros(70,70);
    for j=1:size(B{i},1)
        B_item(floor((70 - B_max(1)+2)/2)+B{i}(j,1)+1,floor((70 - B_max(2)+2)/2)+B{i}(j,2)+1) = 255;
    end
%     set(B_item,'position',[0,0,70,70])
%     im=imresize(B_item,[70,70]);
%     hogt =hogcalculator(im);  
%     assess = svmclassify(svmStruct,hogt);%assess��ֵ��Ϊ������  
assess = 1;
    %rectangle('Position',[0,0,10,20],'EdgeColor','r');
    %img_with_rect = drawRect(img_with_rect,[B_items_tangle(i,3),B_items_tangle(i,1)],[B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],1,[255,0,0]);
    if(assess>0.99)
        rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','g');
    else
        rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','r');
    end
        text(B_items_tangle(i,3),B_items_tangle(i,1),sprintf('%d',i),'color','g');
    %line([B_items_tangle(i,3) B_items_tangle(i,1)],[B_items_tangle(i,4) B_items_tangle(i,1)],'color','b','LineWidth',3);
    B_items{i,1} = B_item;%��ȡÿ�������������������
     path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds',sprintf('%03d.jpg',222+i));
     %imwrite(B_item,path,'jpg');
end

%disp(B_items_tangle);

B_items_circum = zeros(length(B_items),1);%�ܳ�
B_items_area = zeros(length(B_items),1);%���
B_items_area_per = zeros(length(B_items),1);%���ռ�����������ٷֱ�
B_items_area_average_per = zeros(length(B_items),1);%���ռƽ������ٷֱ�
B_items_totol_area = 0;%�������ӵ������
B_items_totol_tangle_area = 0;%�����������ھ��ε������
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
%?�����Բ�����߶�
%?���Բ׶���߷���?
F=@(p,x)p(1)*x(:,1).^2+p(2)*x(:,1).*x(:,2)+p(3)*x(:,2).^2+p(4)*x(:,1)+p(5)*x(:,2)+p(6);%��Բһ�㷽��
%?��ɢ���ݵ�
Up=source_border;%excel�ļ�·��
UpX=Up(:,2);
UpY=Up(:,1);
%?p0ϵ����ֵ
p0=[1 1 1 1 1 1];
warning off
%?���ϵ������С���˷���?
p=nlinfit(Up,zeros(size(Up,1),1),F,p0);
plot(UpX,UpY,'r.');
hold on;
UpMinx=min(UpX);
UpMaxx=max(UpX);
UpMiny=min(UpY);
UpMaxy=max(UpY);%?��ͼ?
axis equal;
ezplot(@(x,y)F(p,[x,y]),[-1+UpMinx,1+UpMaxx,-1+UpMiny,1+UpMaxy]);
title('�������');
%legend('������','�������');
% %�����Բ�߽�
% 
% row=length(source_border');%��Բ�߽��ĸ���������������ķ��̸���
% %���¹��쳬���������ϵ������5��
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