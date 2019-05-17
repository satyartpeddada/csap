%--------------------------------------------------------------------------
% CSAP_OuterLoop_VHBR.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function [F,savedTrees,O] = CSAP_OuterLoop_VHBR(p)

% generate the graphs for each architecture
savedTrees = LRSTF_main(p.nc);

% select architectures to evaluate
testnum = 1;
switch testnum
    case 1 % all
        n = length(savedTrees); 
    case 2 % fixed length 1:n
        n = 3; 
    case 3 % single specific architecture
        n = 1;
        savedTrees = [2 3 0];
end

% create a grid of architectures and pump values
[N,P] = ndgrid(1:n,p.mdot_pump);

% (for testing) series architectures 
seriesflag = 0;
if seriesflag
    indseries = find(sum(savedTrees==0,2)==1);
    for idx = indseries'
        [F(idx),O(idx)] = CSAP_InnerLoop_VHBR(p,savedTrees(N(idx),:),P(idx));   
        disp(F(idx))
    end
    return
end

% (for testing) single architecture, no parallel job created
singleflag = 0;
if singleflag
    idx = 2;
    [F,O] = CSAP_InnerLoop_VHBR(p,savedTrees(N(idx),:),P(idx));
    return
end

% create jobs
for idx = 1:numel(N)
	parJobs(idx) = parfeval(@(x,y) CSAP_InnerLoop_VHBR(p,x,y),2,savedTrees(N(idx),:),P(idx));
end    

% initialize
F = nan(numel(N),1);
counter = 0;

% fetch jobs as they complete
tic % start timer
for idx = 1:numel(N)
    % get the next job
    [completedidx,f,o] = fetchNext(parJobs);

    % get objective function value
    F(completedidx) = f;
    
    % get output structure
    O(completedidx) = o;
    
    % display stuff to command window
    counter = counter + 1;
    disp(['idx:',num2str(counter),...
        ' f:',num2str(f),...
        ' p:',num2str(P(completedidx)),...
        ' tree:[',num2str(savedTrees(N(completedidx),:)),...
        '] error:',num2str(o.error),...
        ' t:',num2str(toc),' s'])
end

end