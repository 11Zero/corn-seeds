function result = Main(filename)
    [B source]= Readimg(filename);%获取每个种子轮廓绝对坐标下的像素集合，B为所有种子边缘像素坐标集合，source为原始图像矩阵信息
    result = source;%result为输出结果，根据需要随意指定
    %load svmStruct  

    B_items_tangle = zeros(length(B),4);%该矩阵用于存储一张图中所有种子的矩形框坐标，1234位分别代表矩形框的上下左右像素位
    img_with_rect = source;%该矩阵为带矩形框的图片矩阵
    img1 = figure(1);
    imshow(img_with_rect);%画图带矩形，
    global svmStruct;%定义向量机全局变量
    svmStruct = load('svmStruct.mat');%从mat文件中载入向量机训练结果
    svmStruct = svmStruct.svmStruct;%为向量机变量赋值
    for i=1:length(B)
        B_max = max(B{i});%第i个种子边缘坐标最大值
        B_min = min(B{i});%第i个种子边缘坐标最小值
        B_items_tangle(i,1) = B_min(1);%1234位分别代表矩形框的上下左右像素位
        B_items_tangle(i,2) = B_max(1);
        B_items_tangle(i,3) = B_min(2);
        B_items_tangle(i,4) = B_max(2);
        for j=1:size(B{i},1)%将每个种子的边缘坐标由全局值转化为相对值，用于将每个种子单独以图片方式存储
            B{i}(j,1) = B{i}(j,1) - B_min(1)+1;
            B{i}(j,2) = B{i}(j,2) - B_min(2)+1;
        end
        B_max = max(B{i});%获得坐标转化后的种子坐标极值
        B_min = min(B{i});
        seed_rect_length = 70;%设置种子单独存储为图片时大小为70x70
        if(B_max(1)+2>seed_rect_length || B_max(2)+2>seed_rect_length)%将种子图像移到70x70图片中央
            if(B_max(1)>B_max(2))
                seed_rect_length = B_max(1)+2;
            else
                seed_rect_length = B_max(2)+2;
            end
        end
        B_item = zeros(seed_rect_length,seed_rect_length);%定义该矩阵用于存储种子二值图像信息
        for j=1:size(B{i},1)
            B_item(floor((seed_rect_length - B_max(1)+2)/2)+B{i}(j,1)+1,floor((seed_rect_length - B_max(2)+2)/2)+B{i}(j,2)+1) = 255;
        end

        assess = Judgeimg(rotateimg(B_item,B{i}));%该函数用向量机特征库判断当前种子好坏，assess为结果
        figure(img1);
        if(assess>0.9)%如果判断结果概率大于0.9，就框绿色
            rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','g');
        else%否则，就框红色
            rectangle('Position',[B_items_tangle(i,3),B_items_tangle(i,1),B_items_tangle(i,4) - B_items_tangle(i,3)+1,B_items_tangle(i,2) - B_items_tangle(i,1)+1],'EdgeColor','r');
        end%为种子编号
        text(B_items_tangle(i,3),B_items_tangle(i,1),sprintf('%d',i),'color','g');
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
    items_num = length(B);%输入一下循环的种子数，目前取所有种子
    for i = 1:items_num
        %subplot(3,5,i),imshow(B_items{i});
        B_items_circum(i,1) = length(find(B_items{i}==255));%计算种子周长放入B_items_circum中
        B_item = B_items{i};
        item_inside = B_item>150; % inside
        item_inside = bwfill(item_inside,'holes');
        item_inside = bwareaopen(item_inside,1000);
        B_items_area(i,1) = length(find(item_inside==1));%计算种子面积放入B_items_area中
        B_items_totol_area = B_items_totol_area+B_items_area(i,1);%累加当前图片中种子的总面积
        B_items_area_per(i,1) = 100*B_items_area(i,1)./(size(B_item,1)*size(B_item,2));%计算当前种子面积占种子框区面积的百分比
        B_items_totol_tangle_area = B_items_totol_tangle_area+size(B_item,1)*size(B_item,2);%累加计算所有种子框区的面积和
        %subplot(3,5,i+5),imshow(item_inside),title('inside');
    end
    result = B_items_circum;%result为种子周长集合
    img2 = figure(2);
    figure(img2);
    plot(result);%输出种子周长曲线
    for i = 1:items_num
        B_items_area_average_per(i,1) = B_items_area(i,1)/(B_items_totol_tangle_area/items_num);%计算每个种子面积占平均框区面积的百分比
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



function alpha = ExerciseOval(source_border)%该函数输出alpha为当前种子经过椭圆拟合后算出的长轴与水平线夹角，用于后续旋转种子到水平或竖直位置
    %?拟合椭圆型曲线段
    %?设出圆锥曲线方程?
    B_max = max(source_border);%种子边缘坐标最大值
    B_min = min(source_border);%种子边缘坐标最小值
    B_max(1) = -B_max(1);
    B_min(1) = -B_min(1);
        for j=1:size(source_border,1)%将种子边缘左边进行绕x轴翻转，并扩展种子画布大小为70x70
            source_border(j,1) = -source_border(j,1);
            source_border(j,1) = source_border(j,1) - B_min(1)+1+floor(((70-(B_max(1)-B_min(1)))/2));
            source_border(j,2) = source_border(j,2) - B_min(2)+1+floor(((70-(B_max(2)-B_min(2)))/2));
        end
    F=@(p,x)p(1)*x(:,1).^2+p(2)*x(:,1).*x(:,2)+p(3)*x(:,2).^2+p(4)*x(:,1)+p(5)*x(:,2)+p(6);%椭圆一般方程
    Up=source_border;%待拟合点集合
    p0=[1 1 1 1 1 1];%p0系数初值
    p=nlinfit(Up,zeros(size(Up,1),1),F,p0);%拟合系数，最小二乘方法
    A=p(1)/p(6);
    B=p(2)/p(6);
    C=p(3)/p(6);
    D=p(4)/p(6);
    E=p(5)/p(6);
    % X_center = (B*E-2*C*D)/(4*A*C - B^2);%椭圆中心点坐标
    % Y_center = (B*D-2*A*E)/(4*A*C - B^2);
    %长轴倾角
    alpha=0.5 * atan(B/(A-C));%找到长轴倾角，以便旋转
end

function B = rotateimg(source,border_source)%旋转种子
    angel = round(ExerciseOval(border_source)*180/pi);%得到旋转角度
    big_source = imresize(source,[200,200]);%将原矩阵放大
    B = imrotate(big_source,angel,'bilinear','crop');%旋转放大后的矩阵angle度
    B = imresize(B,size(source));%还原旋转后的矩阵为初始大小
    B = im2bw(B,0.99);%二值化去除毛刺
    H = fspecial('unsharp');
    B = imfilter(B,H,'replicate');%拉普拉斯锐化
end
% figure;
% imshow(B);
function result = Judgeimg(img_mat)%计算种子的可信度
%% 训练完成后保存 svmStruct即可对新输入的对象进行分类了无需再执行上面训练阶段代码  
    img=img_mat; 
    im=imresize(img,[64,64]);  
    hogt =hogcalculator(im); 
    global svmStruct;%全局向量机结构
    result = svmclassify(svmStruct,hogt);%result的值即为分类结果  
end
