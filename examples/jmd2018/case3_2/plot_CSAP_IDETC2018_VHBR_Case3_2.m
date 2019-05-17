%--------------------------------------------------------------------------
% plot_CSAP_IDETC2018_VHBR_Case3_2.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
close all; clear; clc

% add all subfolders to our path
addpath(genpath(mfoldername(mfilename('fullpath'),'')));

%% load data
myloadname = mfilename;
myloadname(1:5) = [];

load(myloadname)

pdfflag = 1;

Nplot = 1000;

%%
mycolor1 = [0.8500 0.3250 0.0980]; % custom color 1
mycolor2 = [0.4940 0.1840 0.5560]; % custom color 2
wcolor = [1 1 1]; % white color
bcolor = [0 0 0]; % black color


c(1,:) = [211, 47, 47]/255; % red
c(2,:) = [255, 87, 34]/255; % orange
c(3,:) = [255,193,7]/255; % amber
c(4,:) = [76,175,80]/255; % green
c(5,:) = [139,195,74]/255; % lime
c(6,:) = [33,150,243]/255; % blue
c(7,:) = [26, 35, 126]/255; % purple
c(8,:) = [63,81,181]/255; % indigo

c(9,:) = [96,125,139]/255; % blue grey
c(10,:) = [121,85,72]/255; % brown
c(11,:) = [158,158,158]/255; % grey
c(12,:) = [0,188,212]/255; % cyan

c(13,:) = [233,30,99]/255; % pink

c = flipud(parula(13));


% %% create
fwidth = 500; % figure width in pixels
fheight = 400; % figure height in pixels
fontlabel = 20; % x,y label font size
fontlegend = 12; % x,y legend font size
fonttick = 12; % x,y tick font size

set(0,'DefaultTextInterpreter','latex'); % change the text interpreter
set(0,'DefaultLegendInterpreter','latex'); % change the legend interpreter
set(0,'DefaultAxesTickLabelInterpreter','latex'); % change the tick interpreter
% 
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 fwidth fheight]; % set figure size and position

for idx = 1:size(F,1)
   xt = Vmdot_pump(idx,:);
   yt = F(idx,:);
   
   % remove nan
   inan = isnan(yt);
   xt(inan) = [];
   yt(inan) = [];
   
   plot(xt,yt,'-','linewidth',4,'color',c(idx,:),'linewidth',1); hold on
end

% add 
plot(0.399,277,'k.','markersize',10);

xmin = min(Vmdot_pump(:)); % x axis minimum
xmax = max(Vmdot_pump(:)); % x axis maximum
xmax = 0.43; % x axis maximum
ymin = min(0); % x axis minimum
ymax = max(750); % x axis maximum
% ymax = max(300); % x axis maximum
myxlabel = '$\dot{m}_p$ (kg/s)'; % x label with latex
myylabel = '$t_{\mathrm{end}}$ (s)'; % y label with latex
mysavename = [myloadname,'-mp-sens']; % name to give the saved file

xlabel(myxlabel) % create x label
ylabel(myylabel) % create y label
xlim([xmin xmax]) % change x limits
ylim([ymin ymax]) % change y limits

ha = gca; % get current axis handle
ha.XAxis.Color = bcolor; % change the x axis color to black (not a dark grey)
ha.YAxis.Color = bcolor; % change the y axis color to black (not a dark grey)
ha.XAxis.FontSize = fonttick; % change x tick font size
ha.YAxis.FontSize = fonttick; % change y tick font size
ha.XAxis.Label.FontSize = fontlabel; % change x label font size
ha.YAxis.Label.FontSize = fontlabel; % change y label font size
% 

ha = gca;
Position = ha.Position;
% Position(2) = Position(2)+0.02;
Position(4) = Position(4)-0.02;
ha.Position = Position;

% #1 - parallel
htxt = annotation('textarrow','String','1-2-3','Interpreter','latex',...
    'LineStyle','none','FontSize',fonttick,'HorizontalAlignment','left',...
    'VerticalAlignment','middle', 'TextRotation',90,'HeadStyle','none','LineStyle', 'none');
htxt.Position = [0.84 0.91 0.1 0.1];

% #10 - best
htxt = annotation('textarrow','String','321','Interpreter','latex',...
    'LineStyle','none','FontSize',fonttick,'HorizontalAlignment','left',...
    'VerticalAlignment','middle', 'TextRotation',90,'HeadStyle','none','LineStyle', 'none');
htxt.Position = [0.66 0.91 0.1 0.1];

% #5 - worst
htxt = annotation('textarrow','String','123','Interpreter','latex',...
    'LineStyle','none','FontSize',fonttick,'HorizontalAlignment','left',...
    'VerticalAlignment','middle', 'TextRotation',90,'HeadStyle','none','LineStyle', 'none');
htxt.Position = [0.91 0.91 0.1 0.1];

% #9 - worst
htxt = annotation('textarrow','String','213','Interpreter','latex',...
    'LineStyle','none','FontSize',fonttick,'HorizontalAlignment','left',...
    'VerticalAlignment','middle', 'TextRotation',90,'HeadStyle','none','LineStyle', 'none');
htxt.Position = [0.94 0.91 0.1 0.1];

set(gca,'LineWidth',1);

% clear mylegend
% mylegend= {};
% for k = 1:3
%     mylegend{end+1} = ['$P^s_{',num2str(k),'}$'];
% end
% 
% hl = legend(mylegend,'location','northoutside'); % create legend
% hl.FontSize = fontlegend; % change legend font size
% hl.EdgeColor = bcolor; % change the legend border to black (not a dark grey)
% hl.Orientation = 'horizontal';

set(gca,'LineWidth',1);

% save the figure with export_fig
if pdfflag
    % save the figure with export_fig
    pathpdf = mfoldername(mfilename('fullpath'),'pdf');
    filename = [pathpdf,mysavename];
    str = ['export_fig ''',filename,''' -pdf'];
    eval(str)

    % save the figure with export_fig
    pathpdf = mfoldername('CSAP_IDETC2018_RunAll','pdf');
    filename = [pathpdf,mysavename];
    str = ['export_fig ''',filename,''' -pdf'];
    eval(str)
end