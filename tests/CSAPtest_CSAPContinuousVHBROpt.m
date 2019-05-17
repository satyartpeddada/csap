%--------------------------------------------------------------------------
% CSAPtest_CSAPContinuousVHBROpt.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
close all; clear; clc

% 
path2flag = 1;

% parameters
p.Veccomp = [2;1];
p.nc = 3;

% obtain model
p = Setup_Graph_Generic(p.Veccomp,p);

% more parameters
p.Pino = 2250*[1:p.nc]';
p.mdot_pump = 0.4;
p.mdot_coolant = 0.2;

% number of states
ns = size(p.As,1);

% number of controls
nu = length(p.Veccomp)-1;

% extract
As = p.As;
Bs = p.Bs;
B = p.B;
P2 = p.P2;
Ds = p.Ds;
mdot_pump = p.mdot_pump;
mdot_coolant = p.mdot_coolant;


% test time, states, and controls
nt = 100000;
T = linspace(0,1,nt);
T = T(:);
Y = rand(nt,ns+nu);
u = rand(nt,nu);

% time-varying power inputs
Pin = DTQP_tmatrix(p.Pino,[],T);

% m code (sparse) version 
tic
output1 = CSAP_Continuous_VHBR_Opt(T,Y,u,As,Bs,B,P2,Ds,mdot_pump,mdot_coolant,Pin,path2flag);
toc

% mex (sparse) version
tic
output2 = CSAP_Continuous_VHBR_Opt_MEX(T,Y,u,As,Bs,B,P2,Ds,mdot_pump,mdot_coolant,Pin,path2flag);
toc

% m code (full) version
tic
output3 = CSAP_Continuous_VHBR_Opt(T,Y,u,As,Bs,B,P2,Ds,mdot_pump,mdot_coolant,Pin,path2flag);
toc

% mex (full) version
tic
output4 = CSAP_Continuous_VHBR_Opt_MEX(T,Y,u,As,Bs,B,P2,Ds,mdot_pump,mdot_coolant,Pin,path2flag);
toc

% check the error between the two implementations
norm(output1.dynamics-output3.dynamics,'inf')
norm(output2.dynamics-output4.dynamics,'inf')
norm(output1.dynamics-output2.dynamics,'inf')
norm(output3.dynamics-output4.dynamics,'inf')