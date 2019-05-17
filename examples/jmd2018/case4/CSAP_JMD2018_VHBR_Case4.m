%--------------------------------------------------------------------------
% CSAP_JMD2018_VHBR_Case4.m
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
% p.Pino = [5000;5000;5000];
% p.Pino{1,1} = @(t) 5000*(1-(t>80));
% p.Pino{2,1} = @(t) 6000*(1-(t>60));
% p.Pino{3,1} = @(t) 7000*(1-(t>40));

p.Pino{1,1} = @(t) CSAP_trapezoid(t,5,0.5,1/4,1/4,30000,1); % low duty, high power
p.Pino{2,1} = @(t) CSAP_trapezoid(t,10,7.5,1/4,1/4,12000,2); % high duty, medium power
p.Pino{3,1} = @(t) CSAP_trapezoid(t,10,3.5,1/4,1/4,5000,7); % medium duty, low power

% figure; hold on
% t = linspace(0,50,1e5);
% plot(t,p.Pino{1,1}(t));
% plot(t,p.Pino{2,1}(t));
% plot(t,p.Pino{3,1}(t));
% 
% return

% number of components
p.nc = length(p.Pino);
        
% temperature constraints
max_T = 45;
p.xmax = nan(4+2*p.nc,1);
p.xmax_htp = max_T*ones(4,1); % Max T constraints for heat exchanger inlet, outlet, etc. 
p.xmax_wall = max_T*ones(p.nc,1); % Max T constraints for the cold plate walls
p.xmax_fluids = max_T*ones(p.nc,1); % Max T constraints for the clod plate fluid temperatures
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
p.scaleflag = 1; % scale flag
p.dispflag = 1;
p.meshflag = 5;
p.guessflag = 2;

% maximum allowable final time
p.TF = 100;

p.meshtol = 1e-4; % mesh tolerance
p.scaleflag = 1; % scale flag

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