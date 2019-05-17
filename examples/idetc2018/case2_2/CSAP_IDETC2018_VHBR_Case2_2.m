%--------------------------------------------------------------------------
% CSAP_IDETC2018_VHBR_Case2_2.m
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
p.Pino = 1000*[2.0;6.1;4.7;6.7;3.2;6.7];

% input CPHX temperature constraints
Tmax2 = [41,53,60,42,47,50];

% number of components
p.nc = length(p.Pino);

% temperature constraints
max_T = 45;
p.xmax = nan(4+2*p.nc,1);
p.xmax_htp = max_T*ones(4,1);  % Max T constraints for heat exchanger inlet, outlet, etc.
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

% fixed mass flow rate of the pump
p.mdot_pump = 0.4;    

% maximum allowable final time
p.TF = 60;

% mesh tolerance
p.meshtol = 1e-5;

% run
[F,savedTrees,O] = CSAP_OuterLoop_VHBR(p);

% plot
[B,I] = sort(F,'descend');
iplot = I(1);
Nplot = 1000;
CSAP_plotTrajectories(O,iplot,Nplot);

% plot
figure;
plot(B,'.')

% save the results
mysavename = mfilename;
mypath = mfoldername(mfilename('fullpath'),'data');
save([mypath,mysavename],'F','savedTrees','O','p');