%--------------------------------------------------------------------------
% CSAPmex_CSAP_Continuous_VHBR_Opt.m
% Generate MEX-function for CSAP_Continuous_VHBR_Opt
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
% files
org_name = 'CSAP_Continuous_VHBR_Opt'; % function that should be mexed
mex_name = 'CSAP_Continuous_VHBR_Opt_MEX'; % mex function name
test_name = 'CSAPtestmex_CSAP_Continuous_VHBR_Opt'; % test function

% number of output arguments
noutputs = 1;

% define argument types for entry-point function
ARGS = cell(1,1);
ARGS{1} = cell(12,1);
ARGS{1}{1} = coder.typeof(0,[Inf  1],[1 0]); % T
ARGS{1}{2} = coder.typeof(0,[Inf Inf],[1 1]); % Y
ARGS{1}{3} = coder.typeof(0,[Inf Inf],[1 1]); % u
ARGS{1}{4} = coder.typeof(0,[Inf Inf],[1 1]); % As
ARGS{1}{5} = coder.typeof(0,[Inf Inf],[1 1]); % Bs
ARGS{1}{6} = coder.typeof(0,[Inf Inf],[1 1]); % B
ARGS{1}{7} = coder.typeof(0,[Inf Inf],[1 1]); % P2
ARGS{1}{8} = coder.typeof(0,[Inf Inf],[1 1]); % Ds
ARGS{1}{9} = coder.typeof(0); % mdot_pump
ARGS{1}{10} = coder.typeof(0); % mdot_coolant
ARGS{1}{11} = coder.typeof(0,[Inf Inf],[1 1]); % Pin
ARGS{1}{12} = coder.typeof(0); % path2flag

% directories
oldfolder = pwd; % get current directory
mexfolder = mfoldername(mfilename('fullpath'),''); % mex folder
tempfolder = getenv('TEMP'); % get temp folder

% create configuration object of class coder.MexCodeConfig
cfg = coder.config('mex');
cfg.GenerateReport = true;
cfg.ReportPotentialDifferences = false;

% change to project directory
cd(tempfolder);

% invoke MATLAB Coder
str = ['codegen -config cfg -o ',mex_name,' ',org_name,...
    ' -args ARGS{1} -nargout ',num2str(noutputs)];
eval(str)

% copy the mex file from the temp directory
source = fullfile(tempfolder,[mex_name,'.',mexext]);
copyfile(source,mexfolder,'f')

% change back to original directory
cd(oldfolder)

% run test function
eval(test_name)