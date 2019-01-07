function varargout = Pic2Sketch(varargin)
% PIC2SKETCH MATLAB code for Pic2Sketch.fig
%      PIC2SKETCH, by itself, creates a new PIC2SKETCH or raises the existing
%      singleton*.
%
%      H = PIC2SKETCH returns the handle to a new PIC2SKETCH or the handle to
%      the existing singleton*.
%
%      PIC2SKETCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PIC2SKETCH.M with the given input arguments.
%
%      PIC2SKETCH('Property','Value',...) creates a new PIC2SKETCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pic2Sketch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pic2Sketch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pic2Sketch

% Last Modified by GUIDE v2.5 06-Jan-2019 17:24:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pic2Sketch_OpeningFcn, ...
                   'gui_OutputFcn',  @Pic2Sketch_OutputFcn, ...
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


% --- Executes just before Pic2Sketch is made visible.
function Pic2Sketch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pic2Sketch (see VARARGIN)

% Choose default command line output for Pic2Sketch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Pic2Sketch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pic2Sketch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset properties back to initial state
reset();
% filepath
[filename,filepath] = uigetfile({'*.*';'*.jpg';'*.png';'*.jpeg'},'Search Image to Convert');
fname = [filepath filename];
% store info for later use
hObject.UserData = struct('fname',fname,'name',filename);
% display image
im = imread(fname);
axes(handles.axes1);
imagesc(im);
axis off
axis image


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% access filepath
h = findobj('Tag','pushbutton1');
path = h.UserData.fname;
% convert to sketch
imfile = convert(path);
% store image matrix for later use
hObject.UserData = imfile;
% display converted image
axes(handles.axes1);
imagesc(imfile);
axis off
axis image


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% access image matrix and file name
h = findobj('Tag','pushbutton2');
h2 = findobj('Tag','pushbutton1');
fname = h2.UserData.name;
img = h.UserData;
% save
imwrite(img,fname);
set(hObject,'String','Success!');


% --- Reset function
function reset()
% find objects
h1 = findobj('Tag','pushbutton1');
h2 = findobj('Tag','pushbutton2');
h3 = findobj('Tag','pushbutton3');
% clear properties
cla
h1.UserData = [];
h2.UserData = [];
set(h3,'String','Save Image');
