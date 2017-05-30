function varargout = debug(varargin)
% DEBUG MATLAB code for debug.fig
%      DEBUG, by itself, creates a new DEBUG or raises the existing
%      singleton*.
%
%      H = DEBUG returns the handle to a new DEBUG or the handle to
%      the existing singleton*.
%
%      DEBUG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEBUG.M with the given input arguments.
%
%      DEBUG('Property','Value',...) creates a new DEBUG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before debug_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to debug_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help debug

% Last Modified by GUIDE v2.5 30-May-2017 21:41:33

% Begin initialization code - DO NOT EDIT
% set(handles.path,'userdata','');

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @debug_OpeningFcn, ...
                   'gui_OutputFcn',  @debug_OutputFcn, ...
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


% --- Executes just before debug is made visible.
function debug_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to debug (see VARARGIN)

% Choose default command line output for debug
handles.output = hObject;
path = '';
set(handles.btn_userdata,'userdata',path);
svmStruct = load('svmStruct.mat');%从mat文件中载入向量机训练结果
set(handles.edit_correct_rate,'String', svmStruct.correct_rate*100);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes debug wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = debug_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menu_open_Callback(hObject, eventdata, handles)
% hObject    handle to menu_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Filename,Pathname]=uigetfile({'*.jpg';'*.bmp';'*.gif'},'选择图片');
%global path;
set(handles.btn_userdata,'userdata',fullfile(Pathname,Filename));
%set(handles.path,'userdata',[Pathname Filename]);
%handles.path=[Pathname Filename];

%Readimg(path,handles);


% --- Executes during object creation, after setting all properties.
function axes_origin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_origin


% --- Executes during object creation, after setting all properties.
function axes_taged_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_taged (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_taged


% --- Executes on button press in btn_recognize.
function btn_recognize_Callback(hObject, eventdata, handles)
% hObject    handle to btn_recognize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global path;
path = get(handles.btn_userdata,'userdata');
if(isempty(path))
    h=errordlg('未选择有效图片！','警告');
    ha=get(h,'children');
else
    Main_adjoin(path,handles);
end



% --- Executes on button press in btn_userdata.
function btn_userdata_Callback(hObject, eventdata, handles)
% hObject    handle to btn_userdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_exercise_Callback(hObject, eventdata, handles)
% hObject    handle to menu_exercise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_correct_rate,'String', 100*exercise());
h=msgbox('训练完成！','提示');
ha=get(h,'children');



function edit_correct_rate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_correct_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_correct_rate as text
%        str2double(get(hObject,'String')) returns contents of edit_correct_rate as a double


% --- Executes during object creation, after setting all properties.
function edit_correct_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_correct_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_update_seeds_Callback(hObject, eventdata, handles)
% hObject    handle to menu_update_seeds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileFolder='seeds\good';
dirOutput=dir([fileFolder '\*.jpg']);
fileNames={dirOutput.name}';
%disp(fileNames);
fp = fopen('seeds\good\list.txt','w');
for i =1 : length(fileNames)
    fprintf(fp, '%s\r\n', fileNames{i});
end
fclose(fp);

fileFolder='seeds\bad';
dirOutput=dir([fileFolder '\*.jpg']);
fileNames={dirOutput.name}';
%disp(fileNames);
fp = fopen('seeds\bad\list.txt','w');
for i =1 : length(fileNames)
    fprintf(fp, '%s\r\n', fileNames{i});
end
fclose(fp);
