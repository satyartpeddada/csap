%--------------------------------------------------------------------------
% LRSTF_plot.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function LRSTF_plot(M)

close all

% number of vertices
n = size(M,2);

% only plot for small sizes
nM = min(108,size(M,1)); % number of trees
ny = ceil(sqrt(nM*2/3)); % number of rows
nx = ceil(nM/ny); % number of columns

% pretasks
set(0,'DefaultTextInterpreter','latex'); % change the text interpreter
set(0,'DefaultLegendInterpreter','latex'); % change the legend interpreter
set(0,'DefaultAxesTickLabelInterpreter','latex'); % change the tick interpreter
hf = figure; % create a new figure and save handle
hf.Color = [1 1 1]; % change the figure background color
hf.Position = [200 200 1100 700]; % set figure size and position
colors = hsv(n); % colors
if nM <= 13
    markersize = 30;
else
    markersize = 15;
end

% add each tree to the figure
for k = 1:nM
    % disp(i)
    subplot(ny,nx,k)
    treeplot([0 (1+M(k,:))],'k.'); hold on

    % plot the vertex numbers
    [x,y] = treelayout([0 (1+M(k,:))]); hold on

    for i = 2:length(x)
        % text(x(i)*1.05,y(i),num2str(i-1),'FontSize',9); hold on
        plot(x(i),y(i),'.','color',colors(i-1,:),'markersize',markersize); hold on
    end

    % turn off the axis
    ha = gca;
    ha.Visible = 'off';
    axis tight
end

end