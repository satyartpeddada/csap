%--------------------------------------------------------------------------
% LRSTF_gen.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function [savedTrees,nTrees] = LRSTF_gen(savedTrees,t,Premain,nc,nm,nTrees)

% check if any vertices still need to be connected
if ~any(isnan(t))
    nTrees = nTrees + 1; % increment
    savedTrees(nTrees,:) = t; % save complete tree
else
    % list of potential parents (dont include the current index)
    Plist = [0,RemoveElement(Premain,nm)];

    % go through each potential parent
    for idx = 1:length(Plist)
        % local copies
        t2 = t; nm2 = nm;
        
        % extract parent index
        Pk = Plist(idx);
        
        % assign parent to the current vertex
        t2(nm2) = Pk;

        % check for a cycles (trees don't have cycles)
        if Pk > 0 % only need to check when the parent isn't the root vertex
            if fixparent(t2) % see function below
                continue % cycle detected
            end
        end
        
        % move to the next vertex
        nm2 = nm2 + 1;
        
        % remove the parent from the list of available parents
        I2 = RemoveElement(Premain,Pk);
        
        % recursively call the function
        [savedTrees,nTrees]  = LRSTF_gen(savedTrees,t2,I2,nc,nm2,nTrees);
    end
end

end
% remove all occurences of r in I
function I = RemoveElement(I,r)
	I(I==r) = [];
end

% adapted from the matlab function "treelayout"
% the goal is to detect if there is a cycle in the tree
%   FIXPARENT(B) takes a vector of parent nodes for an
%   elimination tree, and re-orders it to produce an equivalent vector
%   A in which parent nodes are always higher-numbered than child
%   nodes.
function flag = fixparent(parent)
flag = 0; % initialize as no cycle detected

n = length(parent);
a = parent;
a(a==0) = n+1;
pv = 1:n;

niter = 0;
while(1)
   k = find(a<(1:n));
   if isempty(k), break; end
   k = k(1);
   j = a(k);
   
   % Put node k before its parent node j
   a  = [ a(1:j-1)  a(k)  a(j:k-1)  a(k+1:end)]; 
   pv = [pv(1:j-1) pv(k) pv(j:k-1) pv(k+1:end)]; 
   t = (a >= j & a < k);
   a(a==k) = j;
   a(t) = a(t) + 1;

   niter = niter+1;
   if (niter>n*(n-1)/2),
        flag = 1; % cycle detected
        break 
   end
end
end