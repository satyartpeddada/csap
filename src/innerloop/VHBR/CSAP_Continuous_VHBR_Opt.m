%--------------------------------------------------------------------------
% CSAP_Continuous_VHBR_Opt.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function output = CSAP_Continuous_VHBR_Opt(T,Y,u,As,Bs,B,P2,Ds,mdot_pump,...
    mdot_coolant,Pin,path2flag)

% number of states
ns = size(As,1);

% dimensions of time vector
nt = length(T);

% transpose
Y = Y';

% original states (temperatures)
X = Y(1:ns,:);

% original controls (mdot)
U = Y(ns+1:end,:);

% mass flow rates
mdot_pump = mdot_pump*ones(1,nt);
mdot_coolant = mdot_coolant*ones(1,nt);

% append sink state
T_all = [X;zeros(1,nt)];

% input vector
U_org = [mdot_pump;mdot_coolant;mdot_pump-sum(U,1);U];

% computer state derivatives
T_dot = zeros(nt,ns);
if any(isnan(Y(:))) || any(isnan(u(:)))
    for k = 1:nt
        T_dot(k,:) = sparse(As + Bs*diag(B*U_org(:,k))*P2)*T_all(:,k) + Ds*Pin(k,:)';
    end
else
    for k = 1:nt
        T_dot(k,:) = (As + Bs*diag(B*U_org(:,k))*P2)*T_all(:,k) + Ds*Pin(k,:)';
    end
end

% controls
m_ddot = u;
    
% path constraints
path1 = sum(U,1);
path2 = sum(u,2);

% Outputs
output.dynamics = [T_dot,m_ddot];
output.path = [path1',path2];
if path2flag
    output.integrand = sum(u.^2,2) + path2.^2;
else
    output.integrand = sum(u.^2,2);
end

end