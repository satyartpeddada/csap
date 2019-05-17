%--------------------------------------------------------------------------
% CSAP_square.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function s = CSAP_square(t,T,W,H,P)

%
t = t/T*(2*pi);

% 
duty = W/T*100;

% Compute values of t normalized to (0,2*pi)
tmp = mod(t-2*pi/T*P,2*pi);

% Compute normalized frequency for breaking up the interval (0,2*pi)
w0 = 2*pi*duty/100;

% Assign 1 values to normalized t between (0,w0), 0 elsewhere
nodd = (tmp < w0);

% The actual square wave computation
s = 2*nodd-1;

% 
s = H/2*(s+1);

end