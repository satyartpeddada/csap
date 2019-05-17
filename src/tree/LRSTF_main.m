%--------------------------------------------------------------------------
% LRSTF_main.m
% Generate all labeled-rooted skinny-tree forests for a particular n
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function savedTrees = LRSTF_main(n)

% integer sequence number OEIS A000262 representing # of 'sets of lists'
% https://oeis.org/A000262
S = 0;
for k = 1:n
    S = S + nchoosek(n,k)*nchoosek(n-1,k-1)*factorial(n-k);
end

% upper bound on the number of trees
Nmax = S;

% initialize some stuff
Premain = 1:n; % initialize list of potential parents
savedTrees = zeros(Nmax,n,'uint8'); % initialize list of trees
t = nan(1,n); % initialize all vertices as unnconnected

% enumerate all the trees
try % mex version
    [savedTrees,nTrees] = LRSTF_gen_MEX(savedTrees,t,Premain,n,1,0);
catch
    [savedTrees,nTrees] = LRSTF_gen(savedTrees,t,Premain,n,1,0);
end

% remove unassigned rows
savedTrees(nTrees+1:end,:) = [];

% remove all graphs without the root as a parent
savedTrees(~any(~savedTrees,2),:) = []; % need at least one zero (root)

% convert data type (need for the plotting function)
savedTrees = double(savedTrees);

end