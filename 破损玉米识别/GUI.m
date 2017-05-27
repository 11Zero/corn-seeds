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


% ������������ʱ����һЩ�ؼ�
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

% ��ȡͼ��
[filename,pathname,filter] = uigetfile({'*.jpg;*.jpeg;*.bmp;*.gif;*.png'},'ѡ��ͼƬ');
if filter == 0
    return
end
str = fullfile(pathname,filename);
I=imread(str);
% ��I����Ϊȫ�ֿؼ����õı���,setappdata��������
setappdata(0,'I',I);

% �ھ��Ϊsourceim�Ŀؼ�����ʾͼ��
% axes(handles.sourceim);
imshow(I,'parent',handles.axes1);
set(handles.text1,'String','��ʶ��ԭͼ');
set(handles.text1,'visible','on');

% --- Executes on button press in recog_button.
function recog_button_Callback(hObject, eventdata, handles)
% hObject    handle to recog_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I=getappdata(0,'I');

%% ��ֵ������

[M,N,C]=size(I);

% ת�Ҷ�ͼ
if C>1
    I_gray=rgb2gray(I);
else
    I_gray=I;
end

% ��ֵ��
I_bw=im2bw(I_gray,0.25);


%% ��̬ѧ����

I_bw=bwareaopen(I_bw,80);

%ͼ��ʴ������ʹͼ���Եƽ�����������������غϸ���
I_bw = imopen(I_bw,strel('square',3));


%% ��ǲ���

% ���
[B,L] = bwboundaries(I_bw,'noholes');
stats = regionprops(L,'all');

% ���ô洢�������ݱ���
MyDatabase=zeros(length(B),4);

% ��ʾ
imshow(I,'parent',handles.axes2);

% ��ÿ���궨������д���
for k = 1:length(B)

  % ��ȡ�߽�����
  boundary = B{k};

  % ��ȡ�ܳ�
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % ��ȡ���������ζ�
  area = stats(k).Area;
  F=area/(stats(k).BoundingBox(3)*stats(k).BoundingBox(4));
  %�����쳤��
  major=stats(k).MajorAxisLength;
  minor=stats(k).MinorAxisLength;
  E=major/minor;
  % ����Բ�ζ�
  metric = 4*pi*area/perimeter^2;
  
  % �������
  MyDatabase(k,1)=area;
  % �����ܳ�
  MyDatabase(k,2)=perimeter;
  % ����Բ�ζ�
  MyDatabase(k,3)=metric;
  
  % �ж�
      if area>=1600;
          if metric>0.70;
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
  
  % �궨��ʾ
%   rectangle('Position',stats(k).BoundingBox,'EdgeColor','r'); 
%   % ��ʾ���
%   text(stats(k).BoundingBox(1)-5, stats(k).BoundingBox(2)-5, sprintf('%d,%s',k,res_str), 'Color','r', 'FontWeight','bold', 'FontSize',8);

%   centroid = stats(k).Centroid;
%   plot(centroid(1),centroid(2),'ko');
  
end

% �ж��ļ��Ƿ����
 if exist('���������ļ�.xlsx','file')
    delete('���������ļ�.xlsx'); 
 end
 
% д��excel�ļ�
xlswrite('���������ļ�.xlsx',MyDatabase);

% ��ʾ
set(handles.text2,'String','ʶ����ɣ��ѱ������������ļ�');
set(handles.text2,'visible','on');



% --- Executes on button press in quit_button.
function quit_button_Callback(hObject, eventdata, handles)
% hObject    handle to quit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button=questdlg('�Ƿ�ȷ�Ϲر�','�ر�ȷ��','��','��','��');
if strcmp(button,'��')
    close(gcf)
else
    return;
end
