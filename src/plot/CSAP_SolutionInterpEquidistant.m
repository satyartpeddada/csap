%--------------------------------------------------------------------------
% CSAP_SolutionInterpEquidistant.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function output = CSAP_SolutionInterpEquidistant(output,Nplot)

% 
if strcmpi(output.method,'gpops')
    %
    output = gpopsUserInterp(output,Nplot,'endpts');
else
    % 
    t = output.result.solution.phase.time;
    y = output.result.solution.phase.state;
    u = output.result.solution.phase.control;
    
    % 
    T = linspace(t(1),t(end),Nplot)';
    Y = interp1(t,y,T,'pchip');
    U = interp1(t,u,T,'pchip');
    
    % 
    output.result.interpsolution.phase.time = T;
    output.result.interpsolution.phase.state = Y;    
    output.result.interpsolution.phase.control = U;
end

end