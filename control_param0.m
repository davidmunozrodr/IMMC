%%%%%%%%%%%%%%%%%%%%%
%   control_param0.m 
%%%%%%%%%%%%%%%%5%%%%
% Set control parameters based on the Geyer & Herr neuromuscular model, 2010. 
% It also sets sensory noise (not used) 

% load parameters
mt = load('t12o.mat').t13;

%% Muscle references
%  Physical muscle length reference

% HFL muscle reference length.
 LoHFL = table2array(mt('LoHFL', 1));
 
 % HAM muscle reference length
 LoHAM = table2array(mt('LoHAM', 1));
 
 % TA muscle reference length.
 LoTA = table2array(mt('LoTA', 1));

 %% Feedback Delays
 longD = 0.02;
 midD = 0.01;
 shortD = 0.005;

 % Little delay to avoid algebraic loops in simulink.
 % In case the algebraic loop is already delayed, corrD is substracted from
 % the delay.
 corrD = 0.001;

 longD = longD - corrD;
 midD = midD - corrD;
 shortD = shortD - corrD;

 %% Noise setting (not used)
 var_noise = 0.0075;
 nonoff = 0;
