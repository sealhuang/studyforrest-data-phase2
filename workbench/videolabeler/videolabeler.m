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

% Last Modified by GUIDE v2.5 16-Apr-2018 21:44:53

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

% UIWAIT makes videolabeler wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% load db_dir and the prefix of the filename
handles.dbDir = '/Users/sealhuang/Downloads/studyforrest';
%dbDir = 'D:\dataset\studyforrest_dataset\movie_stimuli';
handles.prefix = 'fg_av_seg';
clipList = dir(fullfile(handles.dbDir, [handles.prefix, '*.mov']));
if isempty(clipList)
    error('Error: No movie file found!');
end

% update handles
handles.clipList = clipList;
guidata(hObject, handles);

% load first movie clip and the corresponding candidate labels
reset_env(hObject, handles, 1)

% --- Initialize GUI env for `i`th clip.
function reset_env(hObject, handles, i)
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% i          the index of clip
clipList = handles.clipList;
input_video_file = fullfile(clipList(i).folder, clipList(i).name);
[~, n, ~] = fileparts(input_video_file);
handles.currentPrefix = n;
input_label_file = fullfile(clipList(i).folder, [n, '_candidate.txt']);
videoObj= VideoReader(input_video_file);
candidate_fid = fopen(input_label_file);
candidate_labels = textscan(candidate_fid, '%s', 'delimiter', '\n');
candidate_labels = candidate_labels{1};
% update handles
handles.currentClip = i;
handles.videoObject = videoObj;
guidata(hObject, handles);

% config GUI status
set(handles.filenametext, 'String', clipList(i).name);
% display first frame
frame_1 = readFrame(videoObj);
axes(handles.screen);
image(frame_1);
axis(handles.screen, 'off')
% display time
set(handles.text2, 'String', num2str(videoObj.CurrentTime));
set(handles.text3, 'String', [' / ', num2str(videoObj.Duration)]);
% display candidate labels
set(handles.candidatebox, 'String', candidate_labels);
set(handles.selectedbox, 'String', {});
set(handles.nextbutton, 'Enable', 'off');
set(handles.playbutton, 'String', 'Play');

% --- Outputs from this function are returned to the command line.
function varargout = videolabeler_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in playbutton.
function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.playbutton, 'String'), 'Play')
    set(handles.playbutton, 'String', 'Pause');
else
    set(handles.playbutton, 'String', 'Play');
end
videoObj = handles.videoObject;
axes(handles.screen);
while hasFrame(videoObj) && strcmp(get(handles.playbutton, 'String'), 'Pause')
    % display frames
    frame = readFrame(videoObj);
    set(handles.text2, 'String', num2str(videoObj.CurrentTime));
    image(frame);
    axis(handles.screen, 'off')
    drawnow;
    %pause(1/videoObj.FrameRate);
end
if videoObj.CurrentTime==videoObj.Duration
    videoObj.CurrentTime=0;
    set(handles.playbutton, 'String', 'Play');
end

% --- Executes on button press in nextbutton.
function nextbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.currentClip < length(handles.clipList)
    reset_env(hObject, handles, handles.currentClip+1)
end
    

% --- Executes on selection change in selectedbox.
function selectedbox_Callback(hObject, eventdata, handles)
% hObject    handle to selectedbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectedbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectedbox
if strcmp(get(handles.figure1, 'SelectionType'), 'open') && ~isempty(get(handles.selectedbox, 'String'))
    index_selected = get(handles.selectedbox, 'Value');
    selected_list = get(handles.selectedbox, 'String');
    candidate_label = selected_list{index_selected};
    % remove selected label from the selected labels
    selected_list(index_selected) = [];
    set(handles.selectedbox, 'String', selected_list);
    set(handles.selectedbox, 'Value', 1);
    % insert the selected label into selected label list
    candidate_list = get(handles.candidatebox, 'String');
    candidate_list = [candidate_label; cellstr(candidate_list)];
    set(handles.candidatebox, 'String', candidate_list);
end

% --- Executes during object creation, after setting all properties.
function selectedbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectedbox (see GCBO)
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
if strcmp(get(handles.figure1, 'SelectionType'), 'open') && ~isempty(get(handles.candidatebox, 'String'))
    index_selected = get(handles.candidatebox, 'Value');
    candidate_list = get(handles.candidatebox, 'String');
    selected_label = candidate_list{index_selected};
    % remove selected label from the candidate labels
    candidate_list(index_selected) = [];
    set(handles.candidatebox, 'String', candidate_list);
    set(handles.candidatebox, 'Value', 1);
    % insert the selected label into selected label list
    selected_list = get(handles.selectedbox, 'String');
    selected_list = [selected_label; cellstr(selected_list)];
    set(handles.selectedbox, 'String', selected_list);
end
    

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
if ~isempty(get(handles.selectedbox, 'String'))
    selected_labels = get(handles.selectedbox, 'String');
    outfile = fullfile(handles.dbDir, [handles.currentPrefix, '_selected_labels.txt']);
    outf = fopen(outfile, 'w');
    fprintf(outf, '%s\n', selected_labels{:});
    fclose(outf);
    set(handles.nextbutton, 'Enable', 'on');
end
    

% --- Executes during object creation, after setting all properties.
function filenametext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenametext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
