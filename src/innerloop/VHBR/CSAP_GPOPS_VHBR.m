%--------------------------------------------------------------------------
% CSAP_GPOPS_VHBR.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function [F,output] = CSAP_GPOPS_VHBR(p)

% flags
if isfield(p,'scaleflag')
    scaleflag = p.scaleflag;
else
    scaleflag = 0; % 0,1
end
if isfield(p,'dispflag')
    dispflag = p.dispflag;
else
    dispflag = 0; % 0,1
end
if isfield(p,'profileflag')
    profileflag = p.profileflag;
else
    profileflag = 0; % 0,1
end
if isfield(p,'guessflag')
    guessflag = p.guessflag;
else
    guessflag = 1; % 0,1,2
end
if isfield(p,'meshflag')
    meshflag = p.meshflag;
else
    meshflag = 2; % 1,2,3,4
end

% penalty value
p.rho = 1e-2/((p.npar+1)*p.mddot_bound.^2);

% control scaling
p.us = p.mddot_bound;

%--- Problem setup
% phase-specific bounds
phase(1).initialtime.lower = 0;
phase(1).initialtime.upper = 0;
phase(1).finaltime.lower = p.tf*0.001;
phase(1).finaltime.upper = p.tf;
phase(1).initialstate.lower = [p.x0',p.umin']; 
phase(1).initialstate.upper = [p.x0',p.umax'];
phase(1).state.lower = [zeros(1,p.ns),p.umin'];
phase(1).state.upper = [p.xmax',p.umax'];
phase(1).finalstate.lower = [zeros(1,p.ns),p.umin'];
phase(1).finalstate.upper = [p.xmax',p.umax'];
phase(1).control.lower = -p.mddot_bound*ones(1,p.npar)/p.us;
phase(1).control.upper = p.mddot_bound*ones(1,p.npar)/p.us;
phase(1).path.lower = [0,-p.mddot_bound];
phase(1).path.upper = [p.mdot_pump,p.mddot_bound];
phase(1).integral.lower = 0;
phase(1).integral.upper = p.tf*(p.npar+1)*p.mddot_bound.^2;
bounds.phase = phase; % group

%--- Guess
switch guessflag
    case 0
        % calculate flow rates per parallel flow - weighted
        mdot_constant = p.mdot_pump/sum(p.Veccomp)*p.Veccomp;

        % create constant control vector 
        U = [p.mdot_pump;p.mdot_coolant;mdot_constant];

        % run a simulation
        options = odeset('RelTol',1e-9,'AbsTol',1e-12);
        [tout,xout] = ode15s( @(t,x) CSAP_Sys_Thermal_Deriv(t,x',U,p),[0 p.tf], p.x0',options);

        % 6. Set the guess fields properly - time, states come from simulation 
        guess.phase.time = tout;
        guess.phase.state = 0*[xout,repmat(mdot_constant(2:end)',length(tout),1)];
        guess.phase.control = zeros(length(tout),p.npar);
        guess.phase.integral = 0;

        F = p.tf;
    case 1
        % calculate flow rates per parallel flow - weighted
        mdot_constant = p.mdot_pump/sum(p.Veccomp)*p.Veccomp;

        % create constant control vector 
        U = [p.mdot_pump;p.mdot_coolant;mdot_constant];

        % run a simulation
        options = odeset('RelTol',1e-9,'AbsTol',1e-12);
        [tout,xout] = ode15s( @(t,x) CSAP_Sys_Thermal_Deriv(t,x',U,p),[0 p.tf], p.x0',options);

        % 6. Set the guess fields properly - time, states come from simulation 
        guess.phase.time = tout;
        guess.phase.state = [xout,repmat(mdot_constant(2:end)',length(tout),1)];
        guess.phase.control = zeros(length(tout),p.npar)/p.us;
        guess.phase.integral = 0;

        F = tout(end);

        p.tfscale = F;

    case 2
        [F,output] = CSAP_SeriesSimulation(p);

        tout = output.result.solution.phase.time;
        xout = output.result.solution.phase.state;
        uout = output.result.solution.phase.control;

        xout(:,end-p.npar) = [];
        uout(:,end-p.npar) = [];

        guess.phase.time = tout;
        guess.phase.state = xout;
        guess.phase.control = uout;
        guess.phase.integral = 0;

        p.tfscale = F;
end

%--- Mesh parameters
switch meshflag
    case 1
        npts = 4;
        nt = length(tout);
        T = interp1(1:nt,tout,linspace(1,nt,ceil(nt/20)));
    case 2
        npts = 4;
        nt = length(tout);
        T = interp1(1:nt,tout,linspace(1,nt,ceil(nt/20)));
        Ned = 50;
        T = unique([T,linspace(0,T(end),Ned)]);
    case 3
        npts = 6;
        Ned = 5;
        T = linspace(0,F,Ned);
    case 4 % single polynomial
        npts = 20;
        Ned = 2;
        T = linspace(0,F,Ned);
    case 5 
        npts = 5;
        Ned = 50;
        T = linspace(0,F,Ned);
end

%     mesh.method          = 'hp-PattersonRao';
%     mesh.method          = 'hp-DarbyRao';    
%     mesh.method          = 'hp-LiuRao';   
mesh.method          = 'hp-LiuRao-Legendre';   

if isfield(p,'meshtol')
    mesh.tolerance = p.meshtol;
else
    mesh.tolerance = 1e-5;
end
mesh.maxiterations   = 30;
mesh.colpointsmin    = 3;
%     mesh.colpointsmax    = 16;
mesh.colpointsmax    = 100;
mesh.phase.colpoints = npts*ones(1,length(T)-1);
mesh.phase.fraction  = diff(T/T(end));

%--- Assemble
setup.mesh                            = mesh;
setup.name                            = 'CSAP';
setup.functions.endpoint              = @CSAP_Endpoint_VHBR;
setup.functions.continuous            = @CSAP_Continuous_VHBR;
setup.auxdata                         = p;
setup.bounds                          = bounds;
setup.guess                           = guess;
setup.derivatives.supplier            = 'sparseCD';
setup.derivatives.dependencies        = 'sparseNaN'; % 'full'
setup.nlp.solver                      = 'snopt';
setup.nlp.snoptoptions.tolerance      = 1e-7;
setup.nlp.snoptoptions.maxiterations = 500;
setup.method = 'RPM-Differentiation'; % 'RPM-Integration'

if scaleflag
    % setup.scales.method = 'automatic-guess';
    setup.scales.method = 'automatic-bounds';
    % setup.scales.method = 'automatic-hybrid';
end

if dispflag 
    setup.displaylevel = 2;
else
    setup.displaylevel = 0;
end

if profileflag
    profile on
end

%--- Run GPOPS2
Ogpops = gpops2(setup);

if profileflag
    profile viewer
end

%--- Extract the results
output.method = 'gpops';
output.error = Ogpops.meshhistory(end).result.maxerror;
output.totaltime = Ogpops.totaltime;
output.penalty = Ogpops.result.objective+Ogpops.result.solution.phase.time(end);
output.result.collocation = Ogpops.result.collocation;
output.result.setup.mesh = Ogpops.result.setup.mesh;

% using solution
tsol = Ogpops.result.solution.phase.time;
Ysol = Ogpops.result.solution.phase.state;
Usol = Ogpops.result.solution.phase.control;
output.result.solution.phase.time = tsol;
mdot_add = p.mdot_pump-sum(Ysol(:,p.ns+1:end),2);
output.result.solution.phase.state = [Ysol(:,1:p.ns),mdot_add,Ysol(:,p.ns+1:end)];
Usol = p.us*Usol;
mddot_add = -sum(Usol,2);
output.result.solution.phase.control = [mddot_add,Usol];

% using interpsolution
tinterp = Ogpops.result.interpsolution.phase.time;
Yinterp = Ogpops.result.interpsolution.phase.state;
Uinterp = Ogpops.result.interpsolution.phase.control;
output.result.interpsolution.phase.time = tinterp;
mdot_add = p.mdot_pump-sum(Yinterp(:,p.ns+1:end),2);
output.result.interpsolution.phase.state = [Yinterp(:,1:p.ns),mdot_add,Yinterp(:,p.ns+1:end)];
Uinterp = p.us*Uinterp;
mddot_add = -sum(Uinterp,2);
output.result.interpsolution.phase.control = [mddot_add,Uinterp];

% maximum final time
F = tsol(end);

end