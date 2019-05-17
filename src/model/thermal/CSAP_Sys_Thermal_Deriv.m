%--------------------------------------------------------------------------
% CSAP_Sys_Thermal_Deriv.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function T_dot = CSAP_Sys_Thermal_Deriv(t,x,u,param)

% extract
mdot  = u(:);           
Pino = param.Pino;
As = param.As;
Bs = param.Bs;
B = param.B;
P2 = param.P2;
Ds = param.Ds;

% append sink states to vertex states
T_all = [x(:);0]; 

% get power inputs at current time
Pin = DTQP_tmatrix(Pino,[],t);

% column vector
Pin = Pin(:);

% compute state derivatives
T_dot = As*T_all + Bs*diag(B*mdot)*P2*T_all + Ds*Pin;

end