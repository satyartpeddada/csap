%--------------------------------------------------------------------------
% plot_CSAP_JMD2018_VHBR_Case4.m
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

% I = [48,54]; %  [1:length(F)];

%
[A,B] = sort(F,'descend');

% I = B([1 3 5])'; %B;
% I = 1; % parallel (ok)
% I = 5; % series bad
% I = 10; % best 

% I = I(:)';
% I = B';

I = [B(1),B(end)];
% I = 3247;

pdfflag = 1;

Nplot = 1000;

%%
mycolor1 = [0.8500 0.3250 0.0980]; % custom color 1
mycolor2 = [0.4940 0.1840 0.5560]; % custom color 2
wcolor = [1 1 1]; % white color
bcolor = [0 0 0]; % black color

c(1,:) = [26, 35, 126]/255; % purple
c(2,:) = [211, 47, 47]/255; % red
c(3,:) = [255, 183, 77]/255; % orange
c(4,:) = [76,175,80]/255; % green
c(5,:) = [96,125,139]/255; % % blue grey
c(6,:) = [33,150,243]/255; % blue

fontlabel = 20; % 20 old value; % x,y label font size
fontlegend = 18; % 12 old value;  % x,y legend font size
fonttick = 16; % 12 old value;  % x,y tick font size

% %% create
fwidth = 500; % figure width in pixels
fheight = 400; % figure height in pixels

set(0,'DefaultTextInterpreter','latex'); % change the text interpreter
set(0,'DefaultLegendInterpreter','latex'); % change the legend interpreter
set(0,'DefaultAxesTickLabelInterpreter','latex'); % change the tick interpreter
% 
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 fwidth fheight]; % set figure size and position

t = linspace(O(I(1)).result.solution.phase.time(1),O(I(1)).result.solution.phase.time(end),Nplot);
P1 = p.Pino{1,1}(t)/1e3;
P2 = p.Pino{2,1}(t)/1e3;
P3 = p.Pino{3,1}(t)/1e3;

plot(t,P1,'-','linewidth',1,'color',c(1,:),'linewidth',1); hold on
plot(t,P2,'-','linewidth',1,'color',c(2,:),'linewidth',1); hold on
plot(t,P3,'-','linewidth',1,'color',c(3,:),'linewidth',1); hold on


x = linspace(0,100,length(F));

xmin = min(t); % x axis minimum
xmax = max(t); % x axis maximum
ymin = min([P1,P2,P3]); % x axis minimum
ymax = max([P1,P2,P3]); % x axis maximum
myxlabel = '$t$ (s)'; % x label with latex
myylabel = 'power (kW)'; % y label with latex
mysavename = [myloadname,'-P']; % name to give the saved file
% 

% 
% annotation('textbox',[0.05 0.02 0.16 0.1],'String','best','Interpreter','latex',...
%     'LineStyle','none','FontSize',fonttick,'HorizontalAlignment','center',...
%     'VerticalAlignment','middle');
% 
% annotation('textbox',[0.825 0.02 0.16 0.1],'String','worst','Interpreter','latex',...
%     'LineStyle','none','FontSize',fonttick,'HorizontalAlignment','center',...
%     'VerticalAlignment','middle');
% 
% post tasks
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

set(gca,'LineWidth',1);

clear mylegend
mylegend= {};
for k = 1:3
    mylegend{end+1} = ['$P^s_{',num2str(k),'}$'];
end

hl = legend(mylegend,'location','northoutside'); % create legend
hl.FontSize = fontlegend; % change legend font size
hl.EdgeColor = bcolor; % change the legend border to black (not a dark grey)
hl.Orientation = 'horizontal';

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


% return

%%
for idx = I
    
clear mylegend

currentTree = savedTrees(idx,:);
output = O(idx);

nu = size(output.result.solution.phase.control,2);

% map tree graph to model representation
[P,LV] = LRSTF_map(currentTree);
p.Veccomp = LV{:}';
Pino = p.Pino(P);
p = Setup_Graph_Generic(p.Veccomp,p);
p.Pino = Pino;

[~,IP] = sort(P);

% compute inner-loop objective function value
p.tf = 100;

% if exist('Plinear_Nc3_output.mat','file')
%     load('Plinear_Nc3_output.mat','output')
% else
%     [F,feasibleFlag,output] = CSAP_SMT_GPOPS(p);
%     save('Plinear_Nc3_output.mat','output');
% end



output = CSAP_SolutionInterpEquidistant(output,Nplot);
t = output.result.interpsolution.phase.time;
x = output.result.interpsolution.phase.state;
u = output.result.interpsolution.phase.control;

% permute
x_fluids = x(:,5:2:end-nu);
x_fluids = x_fluids(:,IP);
x_wall = x(:,6:2:end-nu);
x_wall = x_wall(:,IP);
x(:,5:2:end-nu) = x_fluids;
x(:,6:2:end-nu) = x_wall;


% t = output.time;
% x = output.state;
% u = output.control;
% s = output.parameter;
nu = size(u,2);
nst = size(x,2)-4-nu;



%% plot 1: wall and fluid temperatures
X = x(:,5:end-nu);

xmin = min(t(:)); % x axis minimum
xmax = max(t(:)); % x axis maximum
ymin = min(X(:)-2); % x axis minimum
ymax = max([X(:)]+2); % x axis maximum
myxlabel = '$t$ (s)'; % x label with latex
myylabel = '$T$  ($^\circ$C)'; % y label with latex
mysavename = [myloadname,'-T-',num2str(idx)]; % name to give the saved file
fwidth = 500; % figure width in pixels
fheight = 380; % figure height in pixels

set(0,'DefaultTextInterpreter','latex'); % change the text interpreter
set(0,'DefaultLegendInterpreter','latex'); % change the legend interpreter
set(0,'DefaultAxesTickLabelInterpreter','latex'); % change the tick interpreter

hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 fwidth fheight]; % set figure size and position


hp = [];

% plot the data
plot(t,p.xmax(5)*ones(size(t)),':','color',[0 0 0]); hold on
% plot(t,p.xmax(7)*ones(size(t)),':','color',[0 0 0]); hold on
% plot(t,p.xmax(9)*ones(size(t)),':','color',[0 0 0]); hold on
% plot(t,p.xmax(11)*ones(size(t)),':','color',[0 0 0]); hold on
% plot(t,p.xmax(13)*ones(size(t)),':','color',[0 0 0]); hold on
% plot(t,p.xmax(15)*ones(size(t)),':','color',[0 0 0]); hold on

% if ymax >= p.xmax(5)
%     text(0.03*(max(t)-min(t)),p.xmax(5),'1','interpreter','latex')
% end
% if ymax >= p.xmax(7)
%     text(0.05*(max(t)-min(t)),p.xmax(7),'2','interpreter','latex')
% end
% if ymax >= p.xmax(9)
%     text(0.05*(max(t)-min(t)),p.xmax(9),'3','interpreter','latex')
% end
% if ymax >= p.xmax(11)
%     text(0.05*(max(t)-min(t)),p.xmax(11),'4','interpreter','latex')
% end
% if ymax >= p.xmax(13)
%     text(0.05*(max(t)-min(t)),p.xmax(13),'5','interpreter','latex')
% end
% if ymax >= p.xmax(15)
%     text(0.05*(max(t)-min(t)),p.xmax(15),'6','interpreter','latex')
% end

for k = 1:size(X,2)/2
    hp(end+1) = plot(t,X(:,2*k-1),'--','linewidth',1,'color',c(k,:)); hold on
    hp(end+1) = plot(t,X(:,2*k),'linewidth',1,'color',c(k,:)); hold on
end


% post tasks
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

ha.Position = ha.Position - [0 0 0.01 0];

% text(xmax,ymin,num2str(round(xmax)),'interpreter','latex');
text(xmax+0.2,ymin,{'','$t_{\mathrm{end}}$',['$',num2str(round(xmax,1)),'$'],'',''},...
    'interpreter','latex','FontSize',fonttick);

% text(xmax,ymin,num2str(round(xmax)),'interpreter','latex');

% mylegend{1} = '$T_{\max}$';
% mylegend{2} = '$T_{\max}$';
% mylegend{3} = '$T_{\max}$';
% mylegend{4} = '$T_{\max}$';
% mylegend = {};
% for k = 1:nst/2
%     mylegend{end+1} = ['$T_{f,',num2str(k),'}$'];
%     mylegend{end+1} = ['$T_{w,',num2str(k),'}$'];
% end
% 
% hl = legend(hp,mylegend,'location','NorthEastOutside'); % create legend
% hl.FontSize = fontlegend; % change legend font size
% hl.EdgeColor = bcolor; % change the legend border to black (not a dark grey)


set(gca,'LineWidth',1);

% add the tree
if B(1) == idx
	ax1 = axes('Position',[0.6 0.15 0.3 0.35]);
elseif B(end) ==idx
    ax1 = axes('Position',[0.06 0.58 0.3 0.35]);
end
ax1.Visible='off';
treeplot([0,1+currentTree],'k.'); hold on
[x,y] = treelayout([0,1+currentTree]);
% x = (x-min(x))/(max(x)-min(x));
% y = (y-min(y))/(max(y)-min(y));
for i=2:length(x)
    text(x(i)+0.045,y(i)-0.01,num2str(i-1),'FontSize',fonttick); hold on
end
for i = 1:length(x)
    plot(x(i),y(i),'.','color','k','markersize',14); hold on
end

set(findall(gca, 'Type', 'Line'),'LineWidth',1);

ax1.Visible='off';

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

%% plot 2: mass flow rates
x = output.result.interpsolution.phase.state;
X = x(:,nst+4+1:end);
% question: do we need to sort the controls?

xmin = min(t(:)); % x axis minimum
xmax = max(t(:)); % x axis maximum
ymin = 0; % x axis minimum
ymax = p.mdot_pump*1.06; % x axis maximum
myxlabel = '$t$ (s)'; % x label with latex
myylabel = '$\dot{m}$  (kg/s)'; % y label with latex
mysavename = [myloadname,'-U-',num2str(idx)]; % name to give the saved file
fwidth = 500; % figure width in pixels
fheight = 200; % figure height in pixels

set(0,'DefaultTextInterpreter','latex'); % change the text interpreter
set(0,'DefaultLegendInterpreter','latex'); % change the legend interpreter
set(0,'DefaultAxesTickLabelInterpreter','latex'); % change the tick interpreter

hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 fwidth fheight]; % set figure size and position

% plot the data
% plot(t,p.xmax(1)*ones(size(t)),'k--'); hold on
for k = 1:size(X,2)
    plot(t,X(:,k),'linewidth',1,'color',c(k,:)); hold on
end

% post tasks
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

% text(xmax,ymin,num2str(round(xmax)),'interpreter','latex');

% mylegend{1} = '$T_{\max}$';
clear mylegend
mylegend= {};
for k = 1:nu
    mylegend{end+1} = ['$\dot{m}_{f,',num2str(k),'}$'];
end

hl = legend(mylegend,'location','NorthEastOutside'); % create legend
hl.FontSize = fontlegend; % change legend font size
hl.EdgeColor = bcolor; % change the legend border to black (not a dark grey)

set(gca,'LineWidth',1);

% add the tree
% ax1 = axes('Position',[0.70 0.0 0.3 0.3]);
% ax1.Visible='off';
% treeplot([0,1+currentTree],'k.'); hold on
% [x,y] = treelayout([0,1+currentTree]);
% % x = (x-min(x))/(max(x)-min(x));
% % y = (y-min(y))/(max(y)-min(y));
% for i=2:length(x)
%     text(x(i)+0.035,y(i)-0.02,num2str(i-1)); hold on
% end
% for i = 1:length(x)
%     plot(x(i),y(i),'.','color','k','markersize',14); hold on
% end

% ax1.Visible='off';

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

end