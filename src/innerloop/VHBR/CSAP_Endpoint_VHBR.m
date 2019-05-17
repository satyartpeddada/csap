%--------------------------------------------------------------------------
% CSAP_Endpoint_VHBR.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function output = CSAP_Endpoint_VHBR(input)

% obtain integral value
I = input.phase.integral;

% extract auxiliary data
p = input.auxdata;

% calculate objective
% output.objective = (-input.phase.finaltime + p.rho*I)/p.tfscale;
output.objective = -input.phase.finaltime + p.rho*I;

end