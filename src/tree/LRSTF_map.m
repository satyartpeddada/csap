%--------------------------------------------------------------------------
% LRSTF_map.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function [P,LV] = LRSTF_map(savedTrees)

% 
n = size(savedTrees,2);
N = size(savedTrees,1);

%
P = zeros(N,n);

% 
LV = cell(N,1);

%
for k = 1:N
    % 
    a = savedTrees(k,:);
    
    % 
    p = []; % permutation vector
    lv = []; % circuit components layout 
    A = a + 1;
    idx = 0;
    
    while any(A)
        % 
        lv(end+1) = 0;

        % find next component connected to the root
        I = find(A==1,1,'first');
        idx = idx + 1;
        p(I) =  idx;
        lv(end) = lv(end) + 1;
        A(I) = 0;

        %
        while ~isempty(I)
            I = find(A-1==I,1,'first');
            if ~isempty(I)
                idx = idx + 1;
                p(I) =  idx;
                lv(end) = lv(end) + 1;
                A(I) = 0;
            end
        end

    end
    
    % fix
    [~,p] = sort(p);
    
    % 
    P(k,:) = p;
    LV{k} = lv;

end