function varargout = videolabeler(varargin)
% VIDEOLABELER MATLAB code for videolabeler.fig
%      VIDEOLABELER, by itself, creates a new VIDEOLABELER or raises the existing
%      singleton*.
%
%      H = VIDEOLABELER returns the handle to a new VIDEOLABELER or the handle to
%      the existing singleton*.
%
%      VIDEOLABELER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEOLABELER.M with the given input arguments.
%
%      VIDEOLABELER('Property','Value',...) creates a new VIDEOLABELER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before videolabeler_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to videolabeler_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help videolabeler

% Last Modified by GUIDE v2.5 10-Apr-2018 21:01:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @videolabeler_OpeningFcn, ...
                   'gui_OutputFcn',  @videolabeler_OutputFcn, ...
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

% --- Executes just before videolabeler is made visible.
function videolabeler_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to videolabeler (see VARARGIN)

% Choose default command line output for videolabeler
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using videolabeler.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes videolabeler wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = videolabeler_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in browsebutton.
function browsebutton_Callback(hObject, eventdata, handles)
% hObject    handle to browsebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% open a file brower and select the video file
[video_file_name, video_file_path] = uigetfile({'*.mkv'}, 'Pick a video file');
if (video_file_path==0)
    return;
end
input_video_file = [video_file_path, video_file_name];
%input_label_file = [video_file_path, ]
set(handles.filenametext, 'String', video_file_name);
set(handles.filenametext, 'Visible', 'on')

% acquiring video
videoObject = VideoReader(input_video_file);
% display first frame
frame_1 = read(videoObject, 1);
axes(handles.screen);
imshow(frame_1);
drawnow;
axis(handles.screen, 'off')
% display frame number
set(handles.text2, 'String', '1');
set(handles.text3, 'String', ['  /  ', num2str(videoObject.NumberOfFrames)]);
set(handles.text1, 'Visible', 'on');
set(handles.text2, 'Visible', 'on');
set(handles.text3, 'Visible', 'on');
set(handles.browsebutton, 'Enable', 'off');
set(handles.playbutton, 'Enable', 'on');
set(handles.replaybutton, 'Enable', 'on');
set(handles.savebutton, 'Enable', 'on');
% update handles
handles.videoObject = videoObject;
handles.currentFrame = 1;
guidata(hObject, handles);


% --- Executes on button press in playbutton.
function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.playbutton, 'String'), 'Play')
    set(handles.playbutton, 'String', 'Pause');
    currentFrame = handles.currentFrame;
    videoObject = handles.videoObject;
    axes(handles.screen);
    for frameCount = (currentFrame+1):videoObject.NumberOfFrames
        % display frames
        set(handles.text2, 'String', num2str(frameCount));
        frame = read(videoObject, frameCount);
        imshow(frame);
        drawnow;
    end
else
    set(handles.playbutton, 'String', 'Play');
    currentFrame = str2num(get(handles.text2, 'String'));
    handles.currentFrame = currentFrame;
    guidata(hObject, handles);
end


% --- Executes on button press in replaybutton.
function replaybutton_Callback(hObject, eventdata, handles)
% hObject    handle to replaybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in selectedlbox.
function selectedlbox_Callback(hObject, eventdata, handles)
% hObject    handle to selectedlbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectedlbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectedlbox


% --- Executes during object creation, after setting all properties.
function selectedlbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectedlbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in candidatebox.
function candidatebox_Callback(hObject, eventdata, handles)
% hObject    handle to candidatebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns candidatebox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from candidatebox


% --- Executes during object creation, after setting all properties.
function candidatebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to candidatebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function selecttext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selecttext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function candidatetext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to candidatetext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function filenametext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenametext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
