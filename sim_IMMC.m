%%%%%%%%%%%%%%%%
% IMMC model
% created by David Munoz
%%%%%%%%%%%%%%%%
% This script needs the modoel itself, tg9.slx, the control

close all;
clear;
clc;

%% Dialog section to select task to display
% Please introduce the correct input to avoid errors
% If you select stw, a second dialog will appear to select speed

% First dialog
disp1 = 'Please, indicate behaviour (stw (1) / stw and wts (2) / backward walking (3)) / bwts(4): ';

ans1 = 0;
while ans1 == 0
    beh = input(disp1, "s");

    if isempty(beh)
        beh = 0;
    elseif length(beh) > 1
        beh = 0;
    end

    if any(str2double(beh) == [1 2 3 4])
        ans1 = 1;
        beh = str2double(beh);
    else
        disp('Please, enter 1 for stw, 2 for stw and wts, 3 for backward walking, 4 for running, or 5 for bwts')
    end
end

% Second dialog
disp2 = 'Please, indicate speed of gait: 0.8 (1), 1 (2), 1.2 (3), 1.6 (4), 1.8 (5), 2 (6), 2.2 (7): ';

ans2 = 0;
if beh == 1

    while ans2 == 0
    
        speed = input(disp2, "s");
    
        if isempty(speed)
            speed = 0;
        elseif length(speed) >1
            speed = 0;
        end

        speed = str2double(speed);
    
        if any(speed == 1:7)
            ans2 = 1;
 
        else
            disp('Please, enter 1 to 7 to select gait speed')
        end    
    end
else
    speed = 1;
end

%% Loading model
% Load simulink model and inititial parameters according to the selected
% motor task

% Model
model = "tg9";
load_system(model);
% Disclaimer: the model includes several blocks with zero-corrsing detection
% and other blocks that can affect the output of the simulation.

% Visualisation
set_param(model, 'SimMechanicsOpenEditorOnUpdate', 'on');
set_param(model, 'SimulationMode', 'accelerator');  % Just for making simulation faster. You can just comment this line.

% Simulation duration according to motor task
if beh == 1
    set_param(model, 'StopTime', '10');
elseif (beh == 2) || (beh == 4)
    set_param(model, 'StopTime', '15');
else
    set_param(model, 'StopTime', '10');
end

% Solver
set_param(model, 'solver', 'ode15s');

% Table to introduce the correct u to the correct speed
stable = [1.6 1.4 1.2 1 .8 .6 .4; .8 1 1.2 1.6 1.8 2 2.2];

%% loading gains
% Get parameters and parameters' names to load them in the model
T = readtable('gains.csv','PreserveVariableNames',true);
gains = table2array((T(:,"FINAL VALUE")));
parameters = table2array((T(:,"PARAMETER")));

% number of parameters
n = length(gains);

% Starting input parameters
in = Simulink.SimulationInput(model);

% Loading u, controlling signal for walking, depending on the selected
% forward speed. This paramater can be overrided in the following lines
% depending on the selected task.
in = in.setVariable('uo', stable(1, speed));

% ALmost all forward walking, standing and no internal-model-related
% parameters are loaded here.
for i = 1 : 104
    in = in.setVariable(parameters{i}, gains(i));
end

% Selecting and loading WTS or BWTS parameters depending on the selected
% task.
if beh == 4
    for i = 113 : 120
        in = in.setVariable(parameters{i}, gains(i));
    end
else
    for i = 105 : 112
        in = in.setVariable(parameters{i}, gains(i));
    end
end

% Laoding MLR parameters to manage task chnage during simulations.
switchTime = 5;
b1 = 1; b0 = 0;
g1 = 1; g0 = 0;
xon = 1; xoff = 0;
son = 1; soff = 0;
bon = 1; boff = 0;
back1 = 1; back0 = 0;
r1 = 1; r0 = 0;

if beh == 1
    bon = 0;
    son = 0;
    back1 = 0;
    switch2 = 20;
    r1 = 0;
elseif beh == 2
    back1 = 0;
    bon = 0;
    r1 = 0;
    switch2 = in.getVariable('switch2');
elseif beh == 3
    son = 0;
    xon = 0;
    g1 = 0;
    u0 = 0;
    switch2 = 20;
    in = in.setVariable('uo', u0);
    r1 = 0;
elseif beh == 4
    xon = 0;
    g1 = 0;
    u0 = 0;
    in = in.setVariable('uo', u0);
    r1 = 0;
    switch2 = in.getVariable('switch2');
end

in = in.setVariable('switch2', switch2);
in = in.setVariable('switchTime', switchTime);
in = in.setVariable('b1', b1);
in = in.setVariable('b0', b0);
in = in.setVariable('g1', g1);
in = in.setVariable('g0', g0);
in = in.setVariable('xon', xon);
in = in.setVariable('xoff', xoff);
in = in.setVariable('son', son);
in = in.setVariable('soff', soff);
in = in.setVariable('bon', bon);
in = in.setVariable('boff', boff);
in = in.setVariable('back1', back1);
in = in.setVariable('back0', back0);
in = in.setVariable('r1', r1);
in = in.setVariable('r0', r0);

% Loading backward walking parameters
for i = 121 : n
    in = in.setVariable(parameters{i}, gains(i));
end

out = sim(in, 'ShowProgress','on');
