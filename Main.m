function result = Main(filename)
    [B source]= Readimg(filename);%��ȡÿ�������������������µ����ؼ��ϣ�BΪ�������ӱ�Ե�������꼯�ϣ�sourceΪԭʼͼ�������Ϣ
    result = source;%resultΪ��������������Ҫ����ָ��
    %load svmStruct  

    B_items_tangle = zeros(length(B),4);%�þ������ڴ洢һ��ͼ���������ӵľ��ο����꣬1234λ�ֱ������ο��������������λ
    img_with_rect = source;%�þ���Ϊ�����ο��ͼƬ����
    img1 = figure(1);
    imshow(img_with_rect);%��ͼ�����Σ�
    global svmStruct;%����������ȫ�ֱ���
    svmStruct = load('svmStruct.mat');%��mat�ļ�������������ѵ�����
    svmStruct = svmStruct.svmStruct;%Ϊ������������ֵ
    for i=1:length(B)
        B_max = max(B{i});%��i�����ӱ�Ե�������ֵ
        B_min = min(B{i});%��i�����ӱ�Ե������Сֵ
        B_items_tangle(i,1) = B_min(1);%1234λ�ֱ������ο��������������λ
        B_items_tangle(i,2) = B_max(1);
        B_items_tangle(i,3) = B_min(2);
        B_items_tangle(i,4) = B_max(2);
        for j=1:size(B{i},1)%��ÿ�����ӵı�Ե������ȫ��ֵת��Ϊ���ֵ�����ڽ�ÿ�����ӵ�����ͼƬ��ʽ�洢
            B{i}(j,1) = B{i}(j,1) - B_min(1)+1;
            B{i}(j,2) = B{i}(j,2) - B_min(2)+1;
        end
        B_max = max(B{i});%�������ת������������꼫ֵ
        B_min = min(B{i});
        seed_rect_length = 70;%�������ӵ����洢ΪͼƬʱ��СΪ70x70
        if(B_max(1)+2>seed_rect_length || B_max(2)+2>seed_rect_length)%������ͼ���Ƶ�70x70ͼƬ����
            if(B_max(1)>B_max(2))
                seed_rect_length = B_max(1)+2;
            else
                seed_rect_length = B_max(2)+2;
            end
        end
        B_item = zeros(seed_rect_length,seed_rect_length);%����þ������ڴ洢���Ӷ�ֵͼ����Ϣ
        for j=1:size(B{i},1)
            B_item(floor((seed_rect_length - B_max(1)+2)/2)+B{i}(j,1)+1,floor((seed_rect_length - B_max(2)+2)/2)+B{i}(j,2)+1) = 255;
        end

        assess = Judgeimg(rotateimg(B_item,B{i}));%�ú������������������жϵ�ǰ���Ӻû���assessΪ���
        figure(img1);
        if(assess>0.9)%����жϽ�����ʴ���0.9���Ϳ���ɫ
            rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','g');
        else%���򣬾Ϳ��ɫ
            rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','r');
        end%Ϊ���ӱ��
        text(B_items_tangle(i,3),B_items_tangle(i,1),sprintf('%d',i),'color','g');
        B_items{i,1} = B_item;%��ȡÿ�������������������
    %      path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds',sprintf('%03d.jpg',296+i));
    %      imwrite(rotateimg(B_items{i},B{i}),path,'jpg');
    end

    %disp(B_items_tangle);

    B_items_circum = zeros(length(B_items),1);%�ܳ�
    B_items_area = zeros(length(B_items),1);%���
    B_items_area_per = zeros(length(B_items),1);%���ռ�����������ٷֱ�
    B_items_area_average_per = zeros(length(B_items),1);%���ռƽ������ٷֱ�
    B_items_totol_area = 0;%�������ӵ������
    B_items_totol_tangle_area = 0;%�����������ھ��ε������
    items_num = length(B);%����һ��ѭ������������Ŀǰȡ��������
    for i = 1:items_num
        %subplot(3,5,i),imshow(B_items{i});
        B_items_circum(i,1) = length(find(B_items{i}==255));%���������ܳ�����B_items_circum��
        B_item = B_items{i};
        item_inside = B_item>150; % inside
        item_inside = bwfill(item_inside,'holes');
        item_inside = bwareaopen(item_inside,1000);
        B_items_area(i,1) = length(find(item_inside==1));%���������������B_items_area��
        B_items_totol_area = B_items_totol_area+B_items_area(i,1);%�ۼӵ�ǰͼƬ�����ӵ������
        B_items_area_per(i,1) = 100*B_items_area(i,1)./(size(B_item,1)*size(B_item,2));%���㵱ǰ�������ռ���ӿ�������İٷֱ�
        B_items_totol_tangle_area = B_items_totol_tangle_area+size(B_item,1)*size(B_item,2);%�ۼӼ����������ӿ����������
        %subplot(3,5,i+5),imshow(item_inside),title('inside');
    end
    result = B_items_circum;%resultΪ�����ܳ�����
    img2 = figure(2);
    figure(img2);
    plot(result);%��������ܳ�����
    for i = 1:items_num
        B_items_area_average_per(i,1) = B_items_area(i,1)/(B_items_totol_tangle_area/items_num);%����ÿ���������ռƽ����������İٷֱ�
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



function alpha = ExerciseOval(source_border)%�ú������alphaΪ��ǰ���Ӿ�����Բ��Ϻ�����ĳ�����ˮƽ�߼нǣ����ں�����ת���ӵ�ˮƽ����ֱλ��
    %?�����Բ�����߶�
    %?���Բ׶���߷���?
    B_max = max(source_border);%���ӱ�Ե�������ֵ
    B_min = min(source_border);%���ӱ�Ե������Сֵ
    B_max(1) = -B_max(1);
    B_min(1) = -B_min(1);
        for j=1:size(source_border,1)%�����ӱ�Ե��߽�����x�ᷭת������չ���ӻ�����СΪ70x70
            source_border(j,1) = -source_border(j,1);
            source_border(j,1) = source_border(j,1) - B_min(1)+1+floor(((70-(B_max(1)-B_min(1)))/2));
            source_border(j,2) = source_border(j,2) - B_min(2)+1+floor(((70-(B_max(2)-B_min(2)))/2));
        end
    F=@(p,x)p(1)*x(:,1).^2+p(2)*x(:,1).*x(:,2)+p(3)*x(:,2).^2+p(4)*x(:,1)+p(5)*x(:,2)+p(6);%��Բһ�㷽��
    Up=source_border;%����ϵ㼯��
    p0=[1 1 1 1 1 1];%p0ϵ����ֵ
    p=nlinfit(Up,zeros(size(Up,1),1),F,p0);%���ϵ������С���˷���
    A=p(1)/p(6);
    B=p(2)/p(6);
    C=p(3)/p(6);
    D=p(4)/p(6);
    E=p(5)/p(6);
    % X_center = (B*E-2*C*D)/(4*A*C - B^2);%��Բ���ĵ�����
    % Y_center = (B*D-2*A*E)/(4*A*C - B^2);
    %�������
    alpha=0.5 * atan(B/(A-C));%�ҵ�������ǣ��Ա���ת
end

function B = rotateimg(source,border_source)%��ת����
    angel = round(ExerciseOval(border_source)*180/pi);%�õ���ת�Ƕ�
    big_source = imresize(source,[200,200]);%��ԭ����Ŵ�
    B = imrotate(big_source,angel,'bilinear','crop');%��ת�Ŵ��ľ���angle��
    B = imresize(B,size(source));%��ԭ��ת��ľ���Ϊ��ʼ��С
    B = im2bw(B,0.99);%��ֵ��ȥ��ë��
    H = fspecial('unsharp');
    B = imfilter(B,H,'replicate');%������˹��
end
% figure;
% imshow(B);
function result = Judgeimg(img_mat)%�������ӵĿ��Ŷ�
%% ѵ����ɺ󱣴� svmStruct���ɶ�������Ķ�����з�����������ִ������ѵ���׶δ���  
    img=img_mat; 
    im=imresize(img,[64,64]);  
    hogt =hogcalculator(im); 
    global svmStruct;%ȫ���������ṹ
    result = svmclassify(svmStruct,hogt);%result��ֵ��Ϊ������  
end
