%--------------------------------------------------------------------------
% CSAP_IDETC2018_VHBR_Case1_3.m
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

% input the electronic loading conditions           
p.Pino = [3750;3750;7500];

% number of components
p.nc = length(p.Pino);

% temperature constraints
max_T = 45;
p.xmax = nan(4+2*p.nc,1);
p.xmax_htp = max_T*ones(4,1); % Max T constraints for heat exchanger inlet , outlet , etc. 
p.xmax_wall = max_T*ones(p.nc,1); % Max T constraints for the cold plate walls.
p.xmax_fluids = max_T*ones(p.nc,1); % Max T constraints for the clod plate fluid temperatures.
% p.xmax = [p.xmax_htp;p.xmax_wall;p.xmax_fluids]; % Appending all Max. temperature constraints into a single vector
p.xmax(1:4) = p.xmax_htp;
p.xmax(5:2:end) = p.xmax_fluids;
p.xmax(6:2:end) = p.xmax_wall;

% initial states
x0(1:2,1) = 15*ones(2,1);
x0(3:4,1) = 20*ones(2,1);
x0(5:2*p.nc+4,1)= 20*ones(2*p.nc,1);
p.x0 = x0;

% fixed mass flow rate of the pump
p.mdot_pump = 0.4;  

% maximum allowable final time
p.TF = 1000;

p.meshtol = 1e-5; % mesh tolerance
p.scaleflag = 1; % scaleflag

% run
[F,savedTrees,O] = CSAP_OuterLoop_VHBR(p);

% save the results
mysavename = mfilename;
mypath = mfoldername(mfilename('fullpath'),'data');
save([mypath,mysavename],'F','savedTrees','O','p');