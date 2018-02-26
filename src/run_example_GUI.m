function varargout = run_example_GUI(varargin)
% RUN_EXAMPLE_GUI MATLAB code for run_example_GUI.fig
%      RUN_EXAMPLE_GUI, by itself, creates a new RUN_EXAMPLE_GUI or raises the existing
%      singleton*.
%
%      H = RUN_EXAMPLE_GUI returns the handle to a new RUN_EXAMPLE_GUI or the handle to
%      the existing singleton*.
%
%      RUN_EXAMPLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN_EXAMPLE_GUI.M with the given input arguments.
%
%      RUN_EXAMPLE_GUI('Property','Value',...) creates a new RUN_EXAMPLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run_example_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run_example_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run_example_GUI

% Last Modified by GUIDE v2.5 23-Apr-2015 10:51:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run_example_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @run_example_GUI_OutputFcn, ...
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


% --- Executes just before run_example_GUI is made visible.
function run_example_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run_example_GUI (see VARARGIN)

% Choose default command line output for run_example_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.listbox_optimizer, 'String', ...
    { ...
        '1: Gradient Descent Method', ...
        '2: Newton Method', ...
        '3: Gradient + Line Search', ...
        '4: Newton + Trust Region', ...
        '5: Newton + Trust Region + Saddle Free' ...
        '6: Quasi Newton BFGS' ...
    } ...
   );
set(handles.listbox_function, 'String', ...
    { ...
        'f  = @(x, data)(x.^4);', ...
        'f  = @(x, data)(x.^3 - 2*x + 1)', ...
        'matyas', ...
        'rosenbrock', ...
    } ...
   );
set(handles.edit_range,  'String', '[-1.5, 1.5]');
set(handles.edit_lambda, 'String', '0.001');
set(handles.edit_slope_modifier, 'String', '10^-4');
set(handles.edit_max_iter, 'String', '100');
set(handles.edit_x0, 'String', '1.5');

optimizier_init(handles, 0);
% UIWAIT makes run_example_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = run_example_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox_optimizer.
function listbox_optimizer_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_optimizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_optimizer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_optimizer
optimizier_init(handles, 1);

% --- Executes during object creation, after setting all properties.
function listbox_optimizer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_optimizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox_function.
function listbox_function_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_function contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_function
optimizier_init(handles, 0);

% --- Executes during object creation, after setting all properties.
function listbox_function_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_lambda_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lambda as text
%        str2double(get(hObject,'String')) returns contents of edit_lambda as a double


% --- Executes during object creation, after setting all properties.
function edit_lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_range_Callback(hObject, eventdata, handles)
% hObject    handle to edit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_range as text
%        str2double(get(hObject,'String')) returns contents of edit_range as a double


% --- Executes during object creation, after setting all properties.
function edit_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_slope_modifier_Callback(hObject, eventdata, handles)
% hObject    handle to edit_slope_modifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_slope_modifier as text
%        str2double(get(hObject,'String')) returns contents of edit_slope_modifier as a double


% --- Executes during object creation, after setting all properties.
function edit_slope_modifier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_slope_modifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_max_iter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_max_iter as text
%        str2double(get(hObject,'String')) returns contents of edit_max_iter as a double


% --- Executes during object creation, after setting all properties.
function edit_max_iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_x0_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x0 as text
%        str2double(get(hObject,'String')) returns contents of edit_x0 as a double


% --- Executes during object creation, after setting all properties.
function edit_x0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_current_iter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_current_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_current_iter as text
%        str2double(get(hObject,'String')) returns contents of edit_current_iter as a double


% --- Executes during object creation, after setting all properties.
function edit_current_iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_current_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x as text
%        str2double(get(hObject,'String')) returns contents of edit_x as a double


% --- Executes during object creation, after setting all properties.
function edit_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tolerance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tolerance as text
%        str2double(get(hObject,'String')) returns contents of edit_tolerance as a double


% --- Executes during object creation, after setting all properties.
function edit_tolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_current_tolerance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_current_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_current_tolerance as text
%        str2double(get(hObject,'String')) returns contents of edit_current_tolerance as a double


% --- Executes during object creation, after setting all properties.
function edit_current_tolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_current_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disp('start')
set(handles.edit_current_iter, 'String', num2str(0));
optimizier_init(handles, 1);
optimizer_run(handles);

% --- Executes on button press in pushbutton_step.
function pushbutton_step_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disp('step')
% optimizier_init(handles);
current_tol = str2num(get(handles.edit_current_tolerance, 'String'));
target_tol  = str2num(get(handles.edit_tolerance, 'String'));

if(current_tol > target_tol)
    optimizer_run(handles);
end


% --- Executes on button press in pushbutton_go.
function pushbutton_go_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disp('go')
% optimizier_init(handles);

itr = str2num(get(handles.edit_current_iter, 'String'));
max_itr = str2num(get(handles.edit_max_iter, 'String'));

current_tol = str2num(get(handles.edit_current_tolerance, 'String'));
target_tol  = str2num(get(handles.edit_tolerance, 'String'));

if(current_tol > target_tol)
    for i=itr:max_itr
        pushbutton_step_Callback(hObject, eventdata, handles);
    end
end


%% user defined function 
function optimizier_init(handles, start)
global prob
global config
global config_B_BFGS

config_B_BFGS = 1 ;

% disp('optim init');

set(handles.edit_current_iter, 'String', num2str(0));
set(handles.edit_current_tolerance, 'String', num2str(inf));
set(handles.edit_slope_modifier, 'String', num2str(0.5)); 

eval(['data_range = '     get(handles.edit_range,          'String') ';']);
eval(['lambda = '         get(handles.edit_lambda,         'String') ';']);
eval(['slope_modifier = ' get(handles.edit_slope_modifier, 'String') ';']);
eval(['x0 = '             get(handles.edit_x0,             'String') ';']);


% The given problem
func = get(handles.listbox_function, 'Value');
if func==1,
    [f,fp,fpp] = feval(@test_function_x4);
    if(start == 0)
        data_range = [-2.1,2.1];
        x0 = 2;
        lambda = 0.001;
        str_data_range = ['[', num2str(data_range(1)), ', ', num2str(data_range(2)), ']'];        
        set(handles.edit_range,  'String', str_data_range);        
        set(handles.edit_x0, 'String', num2str(x0));
        set(handles.edit_lambda, 'String', num2str(lambda)); 
    end
end;
if func==2,
    f   = @(x, data)(x.^3 - 2*x + 1);
    fp  = @(x, data)(3*x.^2 - 2);
    fpp = @(x, data)(6*x);
    if(start == 0)
        data_range = [-1.5,2];
        x0 = 0;
        lambda = 0.001;
        str_data_range = ['[', num2str(data_range(1)), ', ', num2str(data_range(2)), ']'];        
        set(handles.edit_range,  'String', str_data_range);        
        set(handles.edit_x0, 'String', num2str(x0));
        set(handles.edit_lambda, 'String', num2str(lambda)); 
    end
end;
if func==4,
    [f,fp,fpp] = feval(@test_function_rosenbrock);
    config_B_BFGS = eye(2) ;

    if(start == 0)
        data_range = [-3, 3 ; -3, 3];
        x0 = [-2;2];
        lambda = 0.001;
        str_data_range = ['[', num2str(data_range(1)), ', ', num2str(data_range(3)), '; ' num2str(data_range(2)), ', ', num2str(data_range(4)), ']'];        
        str_x0= ['[', num2str(x0(1)), '; ', num2str(x0(2)), ']'];        
        set(handles.edit_range,  'String', str_data_range);        
        set(handles.edit_x0, 'String', str_x0);
        set(handles.edit_lambda, 'String', num2str(lambda)); 
    end
end
if func==3,
    [f,fp,fpp] = feval(@test_function_matyas);
    config_B_BFGS = eye(2) ;

    if(start == 0)
        data_range = [-3, 3 ; -3, 3];
        x0 = [-2;2];
        lambda = 0.001;
        str_data_range = ['[', num2str(data_range(1)), ', ', num2str(data_range(3)), '; ' num2str(data_range(2)), ', ', num2str(data_range(4)), ']'];        
        str_x0= ['[', num2str(x0(1)), '; ', num2str(x0(2)), ']'];        
        set(handles.edit_range,  'String', str_data_range);        
        set(handles.edit_x0, 'String', str_x0);
        set(handles.edit_lambda, 'String', num2str(lambda)); 
    end
end

% Set the problem, configuration, and initial point
prob = evl_get_empty_problem();
prob.func = f;
prob.deriv1st = fp;
prob.deriv2nd = fpp;

config = evl_get_default_config();
config.algo_lambda = lambda;
config.slope_modifier = slope_modifier;
config.B = config_B_BFGS;

if(size(x0,1) == 1 ) 
        set(handles.edit_x, 'String', num2str(x0));
    else
        str_x0= ['[', num2str(x0(1)), '; ', num2str(x0(2)), ']'];  
        set(handles.edit_x, 'String', str_x0);
    end
if(start == 0)
    set(handles.edit_tolerance, 'String', num2str(config.term_tolerance));
end

% evl_plot_function(prob, data_range);
evl_plot_function(handles.axes1, prob, data_range);

% axes_handle = evl_plot_function(prob, data_range);
% axes(handles.axes1);


function optimizer_run(handles)
global prob
global config

% disp('optim run');

config.term_tolerance = str2num(get(handles.edit_tolerance, 'String'));
x = str2num(get(handles.edit_x, 'String'));   

% Optimize the problem and update its result
max_iter = config.term_max_iter;
config.term_max_iter = 1;

optimizer = get(handles.listbox_optimizer, 'Value');
itr = str2num(get(handles.edit_current_iter, 'String')) + 1 ;
max_iter = str2num(get(handles.edit_max_iter, 'String'));
set(handles.edit_current_iter, 'String', num2str(itr));

% for itr = 1:max_iter
    % Optimize the problem with its previous result
    switch optimizer,
        case 1
            [x_new, tol] = evl_optimize_gradient(prob, x, config);
        case 2
            [x_new, tol] = evl_optimize_newton(prob, x, config);
        case 3
            [x_new, tol] = evl_optimize_gradient_line_search(prob, x, config);
        case 4
            [x_new, tol,tr_radius] = evl_optimize_newton_trust(prob, x, config);
            config.initial_tr_radius = tr_radius;
        case 5
            [x_new, tol,tr_radius] = evl_optimize_newton_trust_saddlefree(prob, x, config);
            config.initial_tr_radius = tr_radius;
        case 6
            [x_new, tol, B] = evl_optimize_quasi_newton_BFGS(prob, x, config);
            config.B = B;
            
        otherwise
            disp('Unknown method.');
            set(handles.text_logo, 'String', str);

            return
    end;
    str = ['[EVL] iter = ', num2str(itr), ', x = ', num2str(x_new'), ', tol = ', num2str(tol)];
    disp(str);
    set(handles.edit_current_tolerance, 'String', num2str(tol));

    set(handles.text_logo, 'String', str);
    
    % Visualize the result
    evl_plot_x(handles.axes1, prob, x_new, 'r', x, 'm');
    
    % Check termination condition
    tol = norm(x_new-x);
    if tol < config.term_tolerance
        str = ['[EVL] Optimization is terminate because it satisfied tolerance condition.'];
        disp(str);
        set(handles.text_logo, 'String', str);
        return;
    end 

    % Prepare the next optimization
    x = x_new;
    if(size(x,1) == 1 ) 
        set(handles.edit_x, 'String', num2str(x));
    else
        str_x0= ['[', num2str(x(1)), '; ', num2str(x(2)), ']'];  
        set(handles.edit_x, 'String', str_x0);
    end
% end
