%--------------------------------------------------------------------------
% CSAPtestmex_CSAP_Continuous_VHBR_Opt.m
% Test function for CSAP_Continuous_VHBR_Opt
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function CSAPtestmex_CSAP_Continuous_VHBR_Opt

% display level
displevel = 1;

% inputs
load('CSAPtestmex_CSAP_Continuous_VHBR_Opt.mat','p')
As = p.As;
Bs = p.Bs;
B = p.B;
P2 = p.P2;
Ds = p.Ds;
mdot_pump = p.mdot_pump;
mdot_coolant = p.mdot_coolant;
path2flag = 0;
nt = 10000;
T = linspace(0,1,nt)';
Y = rand(nt,size(As,1)+2);
u = rand(nt,size(B,2)-3);
Pin = DTQP_tmatrix(p.Pino,[],T);

% original
tic
output1 = CSAP_Continuous_VHBR_Opt(T,Y,u,As,Bs,B,P2,Ds,mdot_pump,mdot_coolant,Pin,path2flag);
if displevel, toc, end

% mex version
try
    % run mex version
    tic
    output2 = CSAP_Continuous_VHBR_Opt_MEX(T,Y,u,As,Bs,B,P2,Ds,mdot_pump,mdot_coolant,Pin,path2flag);
    if displevel, toc, end
    
    % tests
    if isequal(output1,output2)
        c1 = 'passed';
    else
        c1 = 'failed';
    end

    % display
    disp(['test 1 status: ',c1])

catch
    error('mex version failed')
end

end