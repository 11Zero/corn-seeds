function result = Judgeimg(imgfilename)
%% 训练完成后保存 svmStruct即可对新输入的对象进行分类了无需再执行上面训练阶段代码  
load svmStruct  
path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds',imgfilename);
img=imread(path); 
im=imresize(img,[64,64]);  
figure;  
imshow(im);  
%img=rgb2gray(im);  
hogt =hogcalculator(im);  
result = svmclassify(svmStruct,hogt);%result的值即为分类结果  