function varargout = Memb_2_Cyto(varargin)
% Memb_2_Cyto MATLAB code for Memb_2_Cyto.fig
%      Memb_2_Cyto, by itself, creates a new Memb_2_Cyto or raises the existing
%      singleton*.
%
%      H = Memb_2_Cyto returns the handle to a new Memb_2_Cyto or the handle to
%      the existing singleton*.
%
%      Memb_2_Cyto('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Memb_2_Cyto.M with the given input arguments.
%
%      Memb_2_Cyto('Property','Value',...) creates a new Memb_2_Cyto or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Memb_2_Cyto_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Memb_2_Cyto_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Memb_2_Cyto

% Last Modified by GUIDE v2.5 05-Mar-2016 23:49:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Memb_2_Cyto_OpeningFcn, ...
                   'gui_OutputFcn',  @Memb_2_Cyto_OutputFcn, ...
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before Memb_2_Cyto is made visible.
function Memb_2_Cyto_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
global GUI_opt ;        
global my_DB ;
GUI_opt.STOP = 0 ;

GUI_opt.plot_pause = 2 ;
GUI_opt.path_DIR = '' ;
GUI_opt.microTrack = '' ;
GUI_opt.path_FL = '' ;
GUI_opt.my_DB = '' ;
GUI_opt.exp_name = '' ;
GUI_opt.tm = datestr(now,'yymmdd') ;
GUI_opt.filename_cell =  '' ;
GUI_opt.filename_foci = '' ;
GUI_opt.file_C = 0 ;
GUI_opt.file_F = 0 ;
GUI_opt.DB_source = 0 ;      % DB source: if Oufti, then = 0
                             %            if microbeTracker, then = 1

GUI_opt.border_size = 10 ;      % extra border area to add to a cell cropped image
GUI_opt.Thres_F_size = 3;       % [pixel], min Foci size to consider
GUI_opt.Thres_Signal = 1500;    % Threshold intensity signal that identify foci = '' ;
GUI_opt.Thres_membrane = 2 ;    % number of circle to repeat to extend the membrane area: roughly each 
                                % cicle add a pixel width from perimeter inward to the cell to membrane area
GUI_opt.choise_plot = 0 ;
GUI_opt.choise_Retrive = 0 ;    %-> step 1 : retrive from microTracker.mat
GUI_opt.choise_Analyse = 0 ;    %-> step 2 : analize cell from my_DB.mat in their fluorescence signal
GUI_opt.choise_Save = 0 ;       %-> step 3 : from my_DB, reorganize data and create .txt file

guidata(hObject, handles);      % Update handles structure

% --- Outputs from this function are returned to the command line.
function varargout = Memb_2_Cyto_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------COMMAND BUTTON-----------------------------------

function pushbutton_start_Callback(hObject, eventdata, handles)
global GUI_opt ;
GUI_opt.STOP = 0 ;
Main_Fx(hObject, eventdata, handles) ;


% --- Executes on button press in pushbutton_stop.
function pushbutton_stop_Callback(hObject, eventdata, handles)
global GUI_opt ;
GUI_opt.STOP = 1 ;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------EDIT PARAMETERS---------------------------------

function edit_border_Callback(hObject, eventdata, handles)
global GUI_opt
GUI_opt.border_size = str2double(get(hObject,'String'));

function edit_membr_size_Callback(hObject, eventdata, handles)
global GUI_opt
GUI_opt.Thres_membrane = str2double(get(hObject,'String'));

function edit_focis_size_Callback(hObject, eventdata, handles)
global GUI_opt
GUI_opt.Thres_F_size = str2double(get(hObject,'String'));

function edit_sig_thres_Callback(hObject, eventdata, handles)
global GUI_opt
GUI_opt.Thres_Signal = str2double(get(hObject,'String'));

function edit_plot_pause_Callback(hObject, eventdata, handles)
global GUI_opt
GUI_opt.plot_pause = str2double(get(hObject,'String'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------MENU DB_detection SOURCE---------------------------
function popupmenu1_Callback(hObject, eventdata, handles)
global GUI_opt
val = get(handles.popupmenu1, 'Value');    % index into the menu contents
switch val                      % Set current data to the selected data set
    case 1 
        GUI_opt.DB_source = 0;
    case 2 
        GUI_opt.DB_source = 1;
end
% Save the handles structure.
% guidata(hObject,handles)

% ----- in Retrive_Cells.m ------
% if GUI_opt.DB_source == 0                               
%     temp_DB = Retrive_BF_mesh(cellList.meshData) ;
% elseif GUI_opt.DB_source == 1                           % input is  from microbeTracker
%     temp_DB = Retrive_BF_mesh(cellList) ;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------RADIO BUTTONS----------------------------------- 

function radio_plot_Callback(hObject, eventdata, handles)
global GUI_opt;
if get(hObject, 'Value') == 0        % Disable all buttons
    GUI_opt.choise_plot = 0 ;
    set(hObject, 'BackgroundColor', [1 0.25 0.25]);
elseif get(hObject, 'Value') == 1    % Enable all button
    GUI_opt.choise_plot = 1 ;
    set(hObject, 'BackgroundColor', [0.1 1 0.1]);
end


function radio_step1_Callback(hObject, eventdata, handles)
global  GUI_opt;
if get(hObject, 'Value') == 0        % Disable buttons
    act = 'off' ;
    GUI_opt.choise_Retrive = 0 ;
    set(hObject, 'BackgroundColor', [1 0.25 0.25]);
elseif get(hObject, 'Value') == 1    % Enable buttons
    act = 'on' ;
    GUI_opt.choise_Retrive = 1 ;
    set(hObject, 'BackgroundColor', [0.1 1 0.1]);
end
% Switch ON/OFF text and buttons
set(handles.pushbutton_microTrack , 'Enable', act);
set(handles.edit_microTrack_file , 'Enable', act);


function radio_step2_Callback(hObject, eventdata, handles)
global  GUI_opt;
if get(hObject, 'Value') == 0        % Disable buttons
    GUI_opt.choise_Analyse = 0 ;
    set(hObject, 'BackgroundColor', [1 0.25 0.25]);
elseif get(hObject, 'Value') == 1    % Enable buttons
    GUI_opt.choise_Analyse = 1 ;
    set(hObject, 'BackgroundColor', [0.1 1 0.1]);
end
% Switch ON/OFF text and buttons
% set(handles.pushbutton_my_DB , 'Enable', act);
% set(handles.edit_my_DB_file , 'Enable', act);


function radio_step3_Callback(hObject, eventdata, handles)
global  GUI_opt;
if get(hObject, 'Value') == 0        % Disable buttons
    GUI_opt.choise_Save = 0 ;
    set(hObject, 'BackgroundColor', [1 0.25 0.25]);
elseif get(hObject, 'Value') == 1    % Enable buttons
    GUI_opt.choise_Save = 1 ;
    set(hObject, 'BackgroundColor', [0.1 1 0.1]);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------EDIT/LOAD FOLDERs AND FILEs--------------------------- 

function edit_exp_name_Callback(hObject, eventdata, handles)
% On typing in edit area, save the name of the experiment
global GUI_opt
GUI_opt.exp_name = (get(hObject,'String'));
 
function edit_FL_folder_Callback(hObject, eventdata, handles)
% On typing in edit area, save the fluorescence folder path
global GUI_opt
[FileName,PathName] = fileparts( (get(hObject,'String')));
GUI_opt.path_FL = [PathName, FileName] ;
GUI_opt.path_DIR = PathName ;

function edit_microTrack_file_Callback(hObject, eventdata, handles)
% On typing in edit area, save the microbeTracter microTrack file path
global GUI_opt
[FileName,PathName] = fileparts( (get(hObject,'String')));
GUI_opt.microTrack = PathName;

function edit_my_DB_file_Callback(hObject, eventdata, handles)
% On typing in edit area, save the my_DB.mat file path
global GUI_opt
[FileName,PathName] = fileparts( (get(hObject,'String')));
GUI_opt.my_DB = PathName;



function pushbutton_FL_fold_Callback(hObject, eventdata, handles)
global GUI_opt
[PathName, FileName]  = fileparts(uigetdir) ;
GUI_opt.path_FL = [PathName, '/', FileName] ;
GUI_opt.path_DIR = PathName;          s_temp = [PathName, '/', FileName] ;
set(handles.edit_FL_folder, 'String', s_temp );
clear FileName PathName

function pushbutton_microTrack_Callback(hObject, eventdata, handles)
global GUI_opt
[FileName,PathName]  = uigetfile ;
GUI_opt.microTrack = FileName ;             s_temp = [PathName, '/', FileName] ;
set(handles.edit_microTrack_file, 'String', s_temp);
clear FileName PathName

function pushbutton_my_DB_Callback(hObject, eventdata, handles );
global GUI_opt
[FileName,PathName]  = uigetfile ;
GUI_opt.my_DB = FileName ;             s_temp = [PathName, '/', FileName] ;
set(handles.edit_my_DB_file, 'String', s_temp );
clear FileName PathName
