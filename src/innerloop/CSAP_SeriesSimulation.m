%--------------------------------------------------------------------------
% CSAP_SeriesSimulation.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function [F,varargout] = CSAP_SeriesSimulation(p)

% start timer
tic

% calculate flow rates per parallel flow - weighted
mdot_constant = p.mdot_pump/sum(p.Veccomp)*p.Veccomp;

% create constant control vector
U = [p.mdot_pump;p.mdot_coolant;mdot_constant];

% minimum time bound
a = 0;

% maximum time bound
b = p.tf;

% set the simulation tolerances
options = odeset('RelTol',1e-9,'AbsTol',1e-12);

% stopping tolerance
tol = 1e-3;

% initialize iteration counter
n = 0;

% initial guess for the stopping time
m = b;

% check if the maximum time bound satisfies the temperature constraints
fb = CSAP_SeriesSimulation_FeasibilityCheck(b,U,p,options);

% continue if maximum time bound is too long (unfeasible results)
if ~fb 
    % continue until the tolerance is satisfied
    while (b-a)/2^n > tol
        % increment iteration counter
        n = n + 1;

        % determine the feasibility of the new point
        fm = CSAP_SeriesSimulation_FeasibilityCheck(m,U,p,options);

        % add or subtract from the current final time
        if fm % new point passes
            m = m + (b-a)/2^n;
        else % new point fails
            m = m - (b-a)/2^n;
        end
    end
end

% run the simulation
[tout,xout] = ode15s( @(t,x) CSAP_Sys_Thermal_Deriv(t,x',U,p),[0 m], p.x0',options);

% assign objective function value (final time)
F = m;

totaltime = toc;

% create the output structure if required
if nargout == 2
    output.method = 'ode15s';
    output.error = 0;
    output.totaltime = totaltime;
    output.penalty = 0;
    output.result.solution.phase.time = tout;
    output.result.solution.phase.state = [xout,repmat(mdot_constant',length(tout),1)];
    output.result.solution.phase.control = zeros(length(tout),p.npar+1);
    varargout{1} = output; 

end

end
% run the simulation and check for feasibility of the results
function f = CSAP_SeriesSimulation_FeasibilityCheck(tf,U,p,options)

% run the simulation
[~,xout] = ode15s( @(t,x) CSAP_Sys_Thermal_Deriv(t,x',U,p),[0 tf], p.x0',options);

% obtain the relevant states
X = xout(:,1:p.ns);

% check if any of the states violation the simple bounds
f = ~any(max(X,[],1) > p.xmax'); 

end