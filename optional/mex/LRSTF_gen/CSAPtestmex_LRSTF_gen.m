%--------------------------------------------------------------------------
% CSAPtestmex_LRSTF_gen.m
% Test function for LRSTF_gen
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function CSAPtestmex_LRSTF_gen

% display level
displevel = 0;

% inputs
n = 4; % number of nodes
Nmax = 1e7; % maximum graphs to preallocate for

% initialize
Premain = 1:n; % initialize list of potential parents
savedTrees = zeros(Nmax,n,'uint8'); % initialize list of trees
t = nan(1,n); % initialize all vertices as unnconnected

% original
tic
[savedTrees1,nTrees1] = LRSTF_gen(savedTrees,t,Premain,n,1,0);
if displevel, toc, end

% mex version
try
    % run mex version
    tic
    [savedTrees2,nTrees2] = LRSTF_gen_MEX(savedTrees,t,Premain,n,1,0);
    if displevel, toc, end
    
    % tests
    if isequal(savedTrees1,savedTrees2)
        c1 = 'passed';
    else
        c1 = 'failed';
    end
    if isequal(nTrees1,nTrees2)
        c2 = 'passed';
    else
        c2 = 'failed';
    end

    % display
    disp(['test 1 status: ',c1])
    disp(['test 2 status: ',c2])

catch
    error('mex version failed')
end

end