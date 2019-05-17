%--------------------------------------------------------------------------
% CSAP_SteadyStateCondition.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function steadyStateFlag = CSAP_SteadyStateCondition(p,output,TF)

% 'small' derivative tolerance
Dxtol = 1e-4;

% final state values
Xend = output.result.solution.phase.state(end,1:p.ns);

% final control values
Uend = [p.mdot_pump;...
    p.mdot_coolant;output.result.solution.phase.state(end,p.ns+1:end)'];

% calculate final derivative values
Dx = CSAP_Sys_Thermal_Deriv(TF,Xend,Uend,p);

% check if steady-state was reached
if norm(Dx,inf) < Dxtol
    steadyStateFlag = 1;
else
    steadyStateFlag = 0;
end

end