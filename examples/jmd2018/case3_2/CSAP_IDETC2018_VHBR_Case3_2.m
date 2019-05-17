%--------------------------------------------------------------------------
% CSAP_IDETC2018_VHBR_Case3_2.m
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

% number of pump flow rates to test
Npump = 100;

% range of pump flow rates to test
mdot_pump_min = 0;
mdot_pump_max = 0.6;

% vector of pump flow rates to test
Vmdot_pump = linspace(mdot_pump_min,mdot_pump_max,Npump);

% input the electronic loading conditions   
p.Pino = [2.25;4.5;6.75]*1e3;
% p.Pino = 1000*[2;5;4;3];

% input CPHX temperature constraints
Tmax2 = [45,45,45];
% Tmax2 = [40,60,50,70];

% Input the number of components
p.nc = length(p.Pino);
max_T = 45;

% temperature constraints
p.xmax = nan(4+2*p.nc,1);
p.xmax_htp = max_T*ones(4,1);  % Max T constraints for heat exchanger inlet, outlet , etc.
p.xmax_wall = Tmax2;  % Max T constraints for the cold plate walls
p.xmax_fluids = Tmax2;  % Max T constraints for the clod plate fluid temperatures
% p.xmax = [p.xmax_htp;p.xmax_wall;p.xmax_fluids]; % Appending all Max. temperature constraints into a single vector
p.xmax(1:4) = p.xmax_htp;
p.xmax(5:2:end) = p.xmax_fluids;
p.xmax(6:2:end) = p.xmax_wall;

% initial states
x0(1:2,1) = 15*ones(2,1);
x0(3:4,1) = 20*ones(2,1);
x0(5:2*p.nc+4,1)= 20*ones(2*p.nc,1);
p.x0 = x0;

% maximum allowable final time
p.TF = 1000;

% options
p.meshtol = 1e-2; % mesh tolerance
p.scaleflag = 1; % scale flag

% Fixed mass flow rate of the pump
p.mdot_pump = Vmdot_pump; 

% run
[F,savedTrees,O] = CSAP_OuterLoop_VHBR(p);

% 
Ntest = size(F,1)/Npump;

% 
Vmdot_pump = kron(Vmdot_pump',ones(Ntest,1));

% reshape outputs
F = reshape(F,Ntest,[]);
Vmdot_pump = reshape(Vmdot_pump,Ntest,[]);

% 
plot(Vmdot_pump',F','.-')

% save the results
mysavename = mfilename;
mypath = mfoldername(mfilename('fullpath'),'data');
save([mypath,mysavename],'F','savedTrees','O','p','Vmdot_pump');