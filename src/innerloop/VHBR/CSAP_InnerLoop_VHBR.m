%--------------------------------------------------------------------------
% CSAP_InnerLoop_VHBR.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function [F,O] = CSAP_InnerLoop_VHBR(p,currentTree,mdot_pump)

% extract pump speed
p.mdot_pump = mdot_pump;

% map tree graph to model representation
[P,LV] = LRSTF_map(currentTree);

% 
p.Veccomp = LV{:}';

%
Pino = p.Pino(P);

% 
p.xmax_fluids = p.xmax_fluids(P);
p.xmax_wall = p.xmax_wall(P);
p.xmax(5:2:end) = p.xmax_fluids;
p.xmax(6:2:end) = p.xmax_wall;

% 
x0_fluids = p.x0(5:2:end);
x0_wall = p.x0(6:2:end);
p.x0(5:2:end) = x0_fluids(P);
p.x0(6:2:end) = x0_wall(P);

% 
p = Setup_Graph_Generic(p.Veccomp,p);

% assign
p.Pino = Pino;

%--- Setup (all methods)
% assign
p.mdot_coolant = 0.2; %(kg/sec)
% rate of mass flow rate
p.mddot_bound = 0.05; % kg/s^2  

% compute
nu = length(p.B(1,:));

% extract
p.npar = nu-2; % number of parallel channels 
p.ns = length(p.As(:,1)); % number of states
p.npar = p.npar-1; % 

% control bounds
p.umin = zeros(p.npar,1);
p.umax = p.mdot_pump*ones(p.npar,1);

%--- Solve the inner-loop problem
% initialize
idx = 1; ContinueFlag = 1;

% compute inner-loop objective function value
while (ContinueFlag > 0) && (length(p.TF) >= idx)
    % maximum allowable final time for this iteration
    p.tf = p.TF(idx);
    
    % solve the problem
    if p.npar == 0  % 'pure' series
        % use CSAP_SeriesSimulation.m if this architecture is 'pure' series
        [F,O] = CSAP_SeriesSimulation(p);

        % maximum final time
        TF = F;

    elseif mdot_pump == 0 % mass flow rate is always zero
        % use CSAP_SeriesSimulation.m if the mass flow rate is always zero
        [F,O] = CSAP_SeriesSimulation(p);

        % maximum final time
        TF = F;

    else % general case
        % use gpops2 for general problems
        [F,O] = CSAP_GPOPS_VHBR(p);
        
        % maximum final time
        TF = F;
    end

    % check the steady-state condition
    steadyStateFlag = CSAP_SteadyStateCondition(p,O,TF);

    % 'small' time difference tolerance
    Ttol = 1e-3;

    % determine if we should continue
    if steadyStateFlag
        ContinueFlag = 0;
    elseif abs(TF - p.tf) > Ttol
        ContinueFlag = -1;
    else
        ContinueFlag = 1;
    end

    % assign to the output
    O.ContinueFlag = ContinueFlag;

    % increment index counter
    idx = idx + 1;

end

end