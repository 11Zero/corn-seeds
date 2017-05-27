function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 29-Apr-2017 22:16:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% 在运行主界面时隐藏一些控件
set(handles.axes1,'visible','off');
set(handles.axes2,'visible','off');
set(handles.text1,'visible','off');
set(handles.text2,'visible','off');


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openimg_button.
function openimg_button_Callback(hObject, eventdata, handles)
% hObject    handle to openimg_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 读取图像
[filename,pathname,filter] = uigetfile({'*.jpg;*.jpeg;*.bmp;*.gif;*.png'},'选择图片');
if filter == 0
    return
end
str = fullfile(pathname,filename);
I=imread(str);
% 将I保持为全局控件可用的变量,setappdata函数保持
setappdata(0,'I',I);

% 在句柄为sourceim的控件上显示图像
% axes(handles.sourceim);
imshow(I,'parent',handles.axes1);
set(handles.text1,'String','待识别原图');
set(handles.text1,'visible','on');

% --- Executes on button press in recog_button.
function recog_button_Callback(hObject, eventdata, handles)
% hObject    handle to recog_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I=getappdata(0,'I');

%% 二值化部分

[M,N,C]=size(I);

% 转灰度图
if C>1
    I_gray=rgb2gray(I);
else
    I_gray=I;
end

% 二值化
I_bw=im2bw(I_gray,0.25);


%% 形态学处理

I_bw=bwareaopen(I_bw,80);

%图像腐蚀操作，使图像边缘平滑，减少相邻种子重合概率
I_bw = imopen(I_bw,strel('square',3));


%% 标记部分

% 标记
[B,L] = bwboundaries(I_bw,'noholes');
stats = regionprops(L,'all');

% 设置存储特征数据变量
MyDatabase=zeros(length(B),4);

% 显示
imshow(I,'parent',handles.axes2);

% 对每个标定对象进行处理
for k = 1:length(B)

  % 获取边界坐标
  boundary = B{k};

  % 获取周长
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % 获取面积计算矩形度
  area = stats(k).Area;
  F=area/(stats(k).BoundingBox(3)*stats(k).BoundingBox(4));
  %计算伸长度
  major=stats(k).MajorAxisLength;
  minor=stats(k).MinorAxisLength;
  E=major/minor;
  % 计算圆形度
  metric = 4*pi*area/perimeter^2;
  
  % 保存面积
  MyDatabase(k,1)=area;
  % 保存周长
  MyDatabase(k,2)=perimeter;
  % 保存圆形度
  MyDatabase(k,3)=metric;
  
  % 判断
      if area>=1600;
          if metric>0.70;
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
  
  % 标定显示
%   rectangle('Position',stats(k).BoundingBox,'EdgeColor','r'); 
%   % 显示标号
%   text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','r', 'FontWeight','bold', 'FontSize',8);

%   centroid = stats(k).Centroid;
%   plot(centroid(1),centroid(2),'ko');
  
end

% 判断文件是否存在
 if exist('特征数据文件.xlsx','file')
    delete('特征数据文件.xlsx'); 
 end
 
% 写入excel文件
xlswrite('特征数据文件.xlsx',MyDatabase);

% 显示
set(handles.text2,'String','识别完成，已保存特征数据文件');
set(handles.text2,'visible','on');



% --- Executes on button press in quit_button.
function quit_button_Callback(hObject, eventdata, handles)
% hObject    handle to quit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button=questdlg('是否确认关闭','关闭确认','是','否','是');
if strcmp(button,'是')
    close(gcf)
else
    return;
end
