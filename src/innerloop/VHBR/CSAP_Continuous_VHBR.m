%--------------------------------------------------------------------------
% CSAP_Continuous_VHBR.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function output = CSAP_Continuous_VHBR(input)

% inputs
T = input.phase.time; % time
Y = input.phase.state; % state
u = input.phase.control; % control

% auxillary data
p = input.auxdata;

% extract
As = p.As;
Bs = p.Bs;
B = p.B;
P2 = p.P2;
Ds = p.Ds;
mdot_pump = p.mdot_pump;
mdot_coolant = p.mdot_coolant;

% get time-varying power inputs
Pin = DTQP_tmatrix(p.Pino,[],T);

% unscale
u = p.us*u;

% which variant of the path constraint?
path2flag = 0; % only mdot^2

% obtain derivatives, path constraints, and integrand
try % mex version
    output = CSAP_Continuous_VHBR_Opt_MEX(T,Y,u,As,Bs,B,P2,Ds,mdot_pump,mdot_coolant,Pin,path2flag);
catch
    output = CSAP_Continuous_VHBR_Opt(T,Y,u,As,Bs,B,P2,Ds,mdot_pump,mdot_coolant,Pin,path2flag);
end

end