%%%%%%%%%%%%%%%%%%%%%
%   mecha_param2.m 
%%%%%%%%%%%%%%%%5%%%%
% This script declares the mechanical parameters of the Reflex-based model
% of Geyer&Herr, 2010.
% It includes segments, joints, ground/reference and sphere contacts
% parameters.

%% 1. Reference parameters
% color for the body segments
bcolor = [0.4 1.0 0.8];

% z-axis as vertical reference
% gravity
g = 9.81; %[m/s^2]


%% 2. Segments parameters

%--------------------------------------------------------------------------
% 2.1. Head-Arms-Trunk(HAT)/Trunk
% Distal end = hips
% Trunk length
L_HAT = 0.8; %[m]

% HAT radius
r_HAT = 0.3412 / 2; %[m]

% Trunk dg, from trunk GC to hips
DG_HAT = 0.35; %[m]

% Trunk mass
m_HAT = 53.5; %[kg]

% Trunk inertia
In_HAT = 3; %[kg*m^2]

% Distance to hips
DJ_HAT = 0.2; %[m]

%--------------------------------------------------------------------------
% 2.2. Thighs
% Distal end = knee joint
% Thigh length
L_thigh = 0.46; %[m]

% Thigh radius
% McDowell et al. 2008
r_thigh = 0.533/(2*pi); %[m]

% Thigh dg, from thigh GC to knee joint
DG_thigh = 0.28; %[m]

% Thigh dj, from proximal joint (hips) to knee joint
DJ_thigh = L_thigh; %[m]

% Thigh mass
m_thigh = 8.5; %[kg]

% Thigh inertia (axis ball-CG-heel). I think this is wrong, it should be
% axis knee-CG-hip
In_thigh = 0.15; %[kg*m^2]

%--------------------------------------------------------------------------
% 2.3. Shanks
% Distal end = ankle joint
% Shank length
L_shank = 0.46; %[m]

% Shank radius, it is arbitrarily the half of the thigh
r_shank = r_thigh/2;

% Shank dg, from shank GC to ankle joint
DG_shank = 0.28; %[m]

% Shank dj, from proximal joint (knee) to ankle joint
DJ_shank = L_shank; %[m]

% Shank mass
m_shank = 3.5; %[kg]

% Shank inertia (axis ankle-CG-knee)
In_shank = 0.05; %[kg*m^2]

%--------------------------------------------------------------------------
% 2.4. Foot
% Distal end = fore-foot impact point
% Foot dimensions
L_foot = 0.2; %[m]
H_foot = 0.08; %[m]

r_cs = 0.025; %[m], radius of the contact sphere

r_foot = 0.035;  %[m], radius of the talus

% Foot size, except L_foot, the rest are provisional measurements
S_foot = [0.1 L_foot 0.05]; %[m]

% Foot dg, from foot GC to fore-foot impact point
DG_foot = 0.14; %[m]
DGx_foot = 0.14; %[m]
DGy_foot = 0.07; %[m]

% Foot dj1, from proximal joint (ankle) to fore-foot impact point
DJ1_foot = 0.16; %[m]
DJ1x_foot = 0.16-r_cs; %[m]
DJ1y_foot = 0.08; %[m]

% cm_foot = [(DJ1x_foot-DGx_foot) 0 (DGy_foot - DJ1y_foot)];
cm_foot = [0.065 0 -0.04];
% cm_foot = [0.135 0 -0.004];

% Segments of the foot: calcaneus-toes, calcaneus-talus
calctoes = sqrt((H_foot-r_cs)^2 + (DJ1x_foot)^2);
calctalus = sqrt((L_foot - (DJ1x_foot))^2 + (H_foot-r_cs)^2);

% Segment orientations
phictoes = asind((DJ1y_foot-r_cs)/calctoes);
phictalus = asind((L_foot-(DJ1x_foot))/calctalus);

% Foot dj2, from heel pad impact point to fore-foot impact point
DJ2_foot = 0.2; %[m]

% Relative position of the Contact Sphere for the toe
toe_cs = [0 -L_foot/2 0]; %[m]

% Relative position of the Contact Sphere for the heel
heel_cs = [0 (DJ2_foot - (L_foot/2)) 0]; %[m]

% Foot mass
m_foot = 1.25; %[kg]

% Foot inertia (axis ball-CG-heel)
In_foot = 0.005; %[kg*m^2]

%--------------------------------------------------------------------------
% 2.5. Contact spheres, massless

% Normal force
stiff = (2*(m_foot+m_shank+m_thigh)+m_HAT)*g/0.01; %[N/m], from G&H MATLAB model
damp = stiff/10; %[N/(m/s)]
trw = 1e-4; %[m]

% Frictional (horizontal) force
mu_static = 0.8;
mu_dynamic = 0.9;
vLimit = 0.01; %[m/s]

%--------------------------------------------------------------------------
% 2.6. Proportion parameters
% Total mass of the body
m_body = m_HAT + (m_thigh + m_shank + m_foot) * 2; %[kg]
% Total height of the body
m_height = L_HAT + L_thigh + L_shank + H_foot; %[m]

% Relative position of the HAT to the ground
HAT_ground = [0 0 ((L_HAT/2) + L_thigh + L_shank + (H_foot-0.005))]; %[m]

% Relative position of the right hip
hipR_HAT = [(r_thigh-DJ_HAT) 0 -L_HAT/2]; %[m]
% Relative position of the left hip
hipL_HAT = [(DJ_HAT-r_thigh) 0 -L_HAT/2]; %[m]
% Relative position of the thigh
thigh_hip = [-(L_thigh/2) 0 0]; %[m]

% Relative position of the knee
knee_thigh = [0 0 -(L_thigh/2)]; %[m]
% Relative position of the shank
shank_knee = [-(L_shank/2) 0 0]; %[m]

% Relative position of the ankle to the shank
ankle_shank = [0 0 -(L_shank/2)]; %[m]
% Relative postion of the foot
foot_ankle = [0 0 0]; %[m]

%--------------------------------------------------------------------------
% 2.7. Soft limits range
% Default joint limit
phi_dl = 180; %[deg]

% Ankle
phi_a_low = (70) * (pi / 180); %[rad]
phi_a_up = (130) * (pi / 180); %[rad]

% Knee
phi_k = 175 * (pi / 180); %[rad]

% Hip
phi_h = 230 * (pi / 180); %[rad]

% Joint stiffness
c_jointstop = 0.3 / (pi/180); %[Nm/rad]

% Maximum joint stop relaxation speed
w_max_jointstop = 1 * pi/180; %[rad/s]


%% 3. Muscle-tendon units parameters

%--------------------------------------------------------------------------
% 3.1. Joint specific link parameters

% Hip FLexor group attachement
rHFL       =       0.08; % [m]   constant lever contribution 
phirefHFL  = 160*pi/180; % [rad] reference angle at which MTU length equals 
rhoHFL     =        0.5; %       sum of lopt and lslack          

% GLUtei group attachement
rGLU       =       0.08; % [m]   constant lever contribution 
phirefGLU  = 120*pi/180; % [rad] reference angle at which MTU length equals 
rhoGLU     =        0.5; %       sum of lopt and lslack 
                         
% HAMstring group attachement (hip)
rHAMh       = 0.08;         % [m]   constant lever contribution 
phirefHAMh  = 150*pi/180;   % [rad] reference angle at which MTU length equals 
rhoHAMh     = 0.5;          %       sum of lopt and lslack 

% HAMstring group attachement (knee)
rHAMk       = 0.05;         % [m]   constant lever contribution 
phirefHAMk  = 180*pi/180;   % [rad] reference angle at which MTU length equals 
rhoHAMk     = 0.5;          %       sum of lopt and lslack 

% RF group attachement (hip)
rRFh      =       0.08; % [m]   constant lever contribution 
phirefRFh = 170*pi/180; % [rad] reference angle at which MTU length equals 
rhoRFh    =        0.3; %       sum of lopt and lslack 

% RF group attachement (knee)
rRFkmax     = 0.06;         % [m]   maximum lever contribution
rRFkmin     = 0.04;         % [m]   minimum lever contribution
phimaxRFk   = 165*pi/180;   % [rad] angle of maximum lever contribution
phiminRFk   =  45*pi/180;   % [rad] angle of minimum lever contribution
phirefRFk   = 125*pi/180;   % [rad] reference angle at which MTU length equals 
rhoRFk      = 0.5;          %       sum of lopt and lslack 
phiScaleRFk = acos(rRFkmin/rRFkmax)/(phiminRFk-phimaxRFk);

% VAStus group attachement
rVASmax     = 0.06;         % [m]   maximum lever contribution
rVASmin     = 0.04;         % [m]   minimum lever contribution
phimaxVAS   = 165*pi/180;   % [rad] angle of maximum lever contribution
phiminVAS   =  45*pi/180;   % [rad] angle of minimum lever contribution
phirefVAS   = 120*pi/180;   % [rad] reference angle at which MTU length equals 
rhoVAS      = 0.6;          %       sum of lopt and lslack
phiScaleVAS = acos(rVASmin/rVASmax)/(phiminVAS-phimaxVAS);

% BFSH group attachement
rBFSH    	= 0.04;         % [m]   constant lever contribution 
phirefBFSH 	= 160*pi/180;   % [rad] reference angle at which MTU length equals 
rhoBFSH    	= 0.7;          %       sum of lopt and lslack
   
% GAStrocnemius attachement (knee joint)
rGASkmax    = 0.05;         % [m]   maximum lever contribution
rGASkmin    = 0.02;         % [m]   minimum lever contribution
phimaxGASk  = 140*pi/180;   % [rad] angle of maximum lever contribution
phiminGASk  =  45*pi/180;   % [rad] angle of minimum lever contribution
phirefGASk  = 165*pi/180;   % [rad] reference angle at which MTU length equals 
rhoGASk     = 0.7;          %       sum of lopt and lslack 
phiScaleGASk = acos(rGASkmin/rGASkmax)/(phiminGASk-phimaxGASk);

% GAStrocnemius attachement (ankle joint)
rGASamax    = 0.06;         % [m]   maximum lever contribution
rGASamin    = 0.02;         % [m]   minimum lever contribution
phimaxGASa  = 100*pi/180;  	% [rad] angle of maximum lever contribution
phiminGASa  = 180*pi/180; 	% [rad] angle of minimum lever contribution
phirefGASa  =  80*pi/180;  	% [rad] reference angle at which MTU length equals 
rhoGASa     =        0.7; 	%       sum of lopt and lslack 
phiScaleGASa  = acos(rGASamin/rGASamax)/(phiminGASa-phimaxGASa);

% SOLeus attachement
rSOLmax     = 0.06;         % [m]   maximum lever contribution
rSOLmin     = 0.02;         % [m]   minimum lever contribution
phimaxSOL   = 100*pi/180;   % [rad] angle of maximum lever contribution
phiminSOL   = 180*pi/180;   % [rad] angle of minimum lever contribution
phirefSOL   =  90*pi/180;   % [rad] reference angle at which MTU length equals 
rhoSOL      = 0.5;          %       sum of lopt and lslack 
phiScaleSOL = acos(rSOLmin/rSOLmax)/(phiminSOL-phimaxSOL);

% Tibialis Anterior attachement
rTAmax      = 0.04;         % [m]   maximum lever contribution
rTAmin      = 0.01;         % [m]   minimum lever contribution
phimaxTA    =  80*pi/180;   % [rad] angle of maximum lever contribution
phiminTA    = 180*pi/180;   % [rad] angle of minimum lever contribution
phirefTA    = 110*pi/180;   % [rad] reference angle at which MTU length equals 
phiScaleTA  = acos(rTAmin/rTAmax)/(phiminTA-phimaxTA);
rhoTA       = 0.7;

%--------------------------------------------------------------------------
% 3.2. Shared muscle tendon parameters
% Excitation-contraction  coupling
preA = 0.01; %[], preactivation
tau = 0.01; %[s], delay time constant

% CE force-length relationship
w = 0.56; %[lopt], width
c = 0.05; %[], residual force factor

% CE force-velocity relationship
N = 1.5; %[Fmax], eccentric force enhancement
K = 5; %[], shape factor

% SE force-length relationship
eref = 0.04; %[lslack], tendon reference strain

%--------------------------------------------------------------------------
% 3.3. Muscle-Specific Parameters
% hip flexor muscles
FmaxHFL   = 2000; % maximum isometric force [N]
loptHFL   = 0.11; % optimum fiber length CE [m]
vmaxHFL   =   12; % maximum contraction velocity [lopt/s]
lslackHFL = 0.10; % tendon slack length [m]

% glutei muscles
FmaxGLU   = 1500; % maximum isometric force [N]
loptGLU   = 0.11; % optimum fiber length CE [m]
vmaxGLU   =   12; % maximum contraction velocity [lopt/s]
lslackGLU = 0.13; % tendon slack length [m]

% hamstring muscles
FmaxHAM   = 3000; % maximum isometric force [N]
loptHAM   = 0.10; % optimum fiber length CE [m]
vmaxHAM   =   12; % maximum contraction velocity [lopt/s]
lslackHAM = 0.31; % tendon slack length [m]

% rectus femoris muscles
FmaxRF   = 1200; % %850 maximum isometric force [N]
loptRF   = 0.08; % optimum fiber length CE [m]
vmaxRF   =   12; % maximum contraction velocity [lopt/s]
lslackRF = 0.35; % tendon slack length [m]

% vasti muscles
FmaxVAS     = 6000; % maximum isometric force [N]
loptVAS     = 0.08; % optimum fiber length CE [m]
vmaxVAS     =   12; % maximum contraction velocity [lopt/s]
lslackVAS   = 0.23; % tendon slack length [m]

% BFSH
FmaxBFSH	=  350; % maximum isometric force [N]
loptBFSH    = 0.12; % optimum fiber length CE [m]
vmaxBFSH    =   12; %6 % maximum contraction velocity [lopt/s]
lslackBFSH  = 0.10; % tendon slack length [m]

% gastrocnemius muscle
FmaxGAS    = 1500; % maximum isometric force [N]
loptGAS    = 0.05; % optimum fiber length CE [m]
vmaxGAS    =   12; % maximum contraction velocity [lopt/s]
lslackGAS  = 0.40; % tendon slack length [m]

% soleus muscle
FmaxSOL    = 4000; % maximum isometric force [N]
loptSOL    = 0.04; % optimum fiber length CE [m]
vmaxSOL    =    6; % maximum contraction velocity [lopt/s]
lslackSOL  = 0.26; % tendon slack length [m]

% tibialis anterior
FmaxTA     =  800; % maximum isometric force [N]
loptTA     = 0.06; % optimum fiber length CE [m]
vmaxTA     =   12; % maximum contraction velocity [lopt/s]
lslackTA   = 0.24; % tendon slack length [m]

%% 4. Thigh Segment Pressure Sheet

% This part of the model seems to be a pressure detector in the middle of
% the thigh (not used).

% Reference compression corresponding to steady-state with HAT mass
DeltaThRef = 5e-3; %[m]

% Interaction stiffness
Kpress = m_HAT * g / DeltaThRef; %[N/m]

% Max. relaxation speed
vmaxpress = 0.5; %[m/s]

%Position of the sheet in the thigh

ThPos = 4/5; %[L_thigh]
