%--------------------------------------------------------------------------
% CSAPmex_LRSTF_gen.m
% Generate MEX-function for LRSTF_gen
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
% files
org_name = 'LRSTF_gen'; % function that should be mexed
mex_name = 'LRSTF_gen_MEX'; % mex function name
test_name = 'CSAPtestmex_LRSTF_gen'; % test function

% number of output arguments
noutputs = 2;

% define argument types for entry-point function
ARGS = cell(1,1);
ARGS{1} = cell(6,1);
ARGS{1}{1} = coder.typeof(uint8(0),[Inf Inf],[1 1]); % savedTrees
ARGS{1}{2} = coder.typeof(0,[1 Inf],[0 1]); % t
ARGS{1}{3} = coder.typeof(0,[1 Inf],[0 1]); % Premain
ARGS{1}{4} = coder.typeof(0); % nc
ARGS{1}{5} = coder.typeof(0); % nm
ARGS{1}{6} = coder.typeof(0); % nTrees

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