%--------------------------------------------------------------------------
% CSAP_trapezoid.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function s = CSAP_trapezoid(t,T,W,R,F,H,P)

% 
initial_height = 0;

% 
pulse(:,1) = [initial_height,0];
pulse(:,2) = [H,pulse(2,1)+R];
pulse(:,3) = [H,pulse(2,2)+W];
pulse(:,4) = [initial_height,pulse(2,3)+F];
pulse(:,5) = [initial_height,T];

%   
temp = pulse(2,:);
temp2 = temp(2:5)+T;
pulset = [pulse(2,:),temp2];
    
% 
pulsev = [pulse(1,:),pulse(1,2:5)];
    
% 
temp3 = temp(1:end-1)-T;
pulset = [temp3,pulset];
pulsev = [pulse(1,1:4),pulsev];
    
%
s = interp1(pulset,pulsev,rem(t-P,T),'linear');

end