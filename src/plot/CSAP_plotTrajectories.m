%--------------------------------------------------------------------------
% CSAP_plotTrajectories.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function CSAP_plotTrajectories(O,iplot,Nplot)

% 
if strcmpi(O(iplot).method,'gpops')
    O2 = gpopsUserInterp(O(iplot),Nplot,'endpts');
    T = O2.result.interpsolution.phase.time;
    Y = O2.result.interpsolution.phase.state;
    U = O2.result.interpsolution.phase.control;
else
    T = O(iplot).result.solution.phase.time;
    Y = O(iplot).result.solution.phase.state;
    U = O(iplot).result.solution.phase.control;
end

% 
figure;
plot(T,U,'.')

% 
figure;
plot(T,Y,'.')

end