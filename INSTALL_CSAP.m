%--------------------------------------------------------------------------
% INSTALL_CSAP.m
% Project link: https://github.com/satyartpeddada/csap
% This scripts helps you get the CSAP Project up and running
%--------------------------------------------------------------------------
% Automatically adds project files to your MATLAB path, downloads the
% required files, and opens an example
%--------------------------------------------------------------------------
% Install script based on MFX Submission Install Utilities
% https://github.com/danielrherber/mfx-submission-install-utilities
% https://www.mathworks.com/matlabcentral/fileexchange/62651
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function INSTALL_CSAP

    % add contents to path
    AddSubmissionContents(mfilename)

    % download required web zips
    RequiredWebZips
    
    % add contents to path
    AddSubmissionContents(mfilename)
    
    % extract required zips
    RequiredZips

    % run mex creation scripts
    RunThisFile('CSAPmex_LRSTF_gen')
    RunThisFile('CSAPmex_CSAP_Continuous_VHBR_Opt')

    % add contents to path (files have been downloaded)
    AddSubmissionContents(mfilename)

    % open an example
    OpenThisFile('CSAP_IDETC2018_VHBR_Case1_1')

    % close this file
    CloseThisFile(mfilename) % this will close this file

end
%--------------------------------------------------------------------------
function RequiredWebZips
    disp('--- Obtaining required web zips')

    % initialize index
    ind = 0;

    % initialize structure
    zips = struct('url','','folder','','test','');
    
    % zip 1
	ind = ind + 1; % increment
	zips(ind).url = 'https://github.com/altmany/export_fig/archive/master.zip';
	zips(ind).folder = 'MFX 23629';
	zips(ind).test = 'export_fig';

    % zip 2
	ind = ind + 1; % increment
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/40397/versions/7/download/zip/mfoldername_v2.zip';
	zips(ind).folder = 'MFX 40397';
	zips(ind).test = 'mfoldername';

    % zip 3
	ind = ind + 1; % increment
	zips(ind).url = 'https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/51986/versions/9/download/zip/Colormaps.zip';
	zips(ind).folder = 'MFX 51986';
	zips(ind).test = 'inferno';

    % zip 4
	ind = ind + 1; % increment
	zips(ind).url = 'https://github.com/danielrherber/dt-qp-project/archive/master.zip';
	zips(ind).folder = 'MFX 65434';
	zips(ind).test = 'DTQP_tmatrix';
    
    % zip 5
	ind = ind + 1; % increment
	zips(ind).url = 'https://github.com/danielrherber/gpops-user-interp/archive/master.zip';
	zips(ind).folder = 'MFX XXXXX';
	zips(ind).test = 'gpopsUserInterp';
    
    % obtain full function path
    full_fun_path = which(mfilename('fullpath'));
    outputdir = fullfile(fileparts(full_fun_path),'include');

    % download and unzip
    DownloadWebZips(zips,outputdir)

    disp(' ')
end
%--------------------------------------------------------------------------
function RequiredZips
    disp('--- Extracting required zips')

    % initialize index
    ind = 0;

    % initialize structure
    zips = struct('url','','folder','','test','');

    % zip 1
    % after mfoldername
	ind = ind + 1; % increment
    try
        mypath = mfoldername('GPOPS-II.zip','');
    catch
        disp('GPOPS-II is required to run this code')
        disp('It is commercial software available at www.gpops2.com')
        mypath = [];
    end
	zips(ind).url = [mypath,'GPOPS-II.zip'];
	zips(ind).folder = 'GPOPS-II';
	zips(ind).test = 'gpops2License.p';

    % obtain full function path
    full_fun_path = which(mfilename('fullpath'));
    outputdir = fullfile(fileparts(full_fun_path),'include');

    % download and unzip
    ExtractZips(zips,outputdir)

    disp(' ')
end
%--------------------------------------------------------------------------
function AddSubmissionContents(name)
	disp('--- Adding submission contents to path')
	disp(' ')

    % turn off potential warning
    warning('off','MATLAB:dispatcher:nameConflict')
    
	% current file
	fullfuncdir = which(name);

	% current folder 
	submissiondir = fullfile(fileparts(fullfuncdir));

	% add folders and subfolders to path
	addpath(genpath(submissiondir))
    
    % turn warning back on
    warning('on','MATLAB:dispatcher:nameConflict')
end
%--------------------------------------------------------------------------
function CloseThisFile(name)
    disp(['--- Closing ', name])
    disp(' ')

    % get editor information
    h = matlab.desktop.editor.getAll;

    % go through all open files in the editor
    for k = 1:numel(h)
        % check if this is the file
        if ~isempty(strfind(h(k).Filename,name))
            % close this file
            h(k).close
        end
    end
end
%--------------------------------------------------------------------------
function OpenThisFile(name)
	disp(['--- Opening ', name])

	try
	    % open the file
	    open(name);
	catch % error
	    disp(['Could not open ', name])
	end

	disp(' ')
end
%--------------------------------------------------------------------------
function DownloadWebZips(zips,outputdir)

    % store the current directory
    olddir = pwd;
    
    % create a folder for outputdir
    if ~exist(outputdir, 'dir')
        mkdir(outputdir); % create the folder
    else
        addpath(genpath(outputdir)); % add folders and subfolders to path
    end
    
    % change to the output directory
    cd(outputdir)

    % go through each zip
    for k = 1:length(zips)

        % get data
        url = zips(k).url;
        folder = zips(k).folder;
        test = zips(k).test;

        % first check if the test file is in the path
        if exist(test,'file') == 0

            try
                % download zip file
                zipname = websave(folder,url);

                % save location
                outputdirname = fullfile(outputdir,folder);

                % create a folder utilizing name as the foldername name
                if ~exist(outputdirname, 'dir')
                    mkdir(outputdirname);
                end

                % unzip the zip
                unzip(zipname,outputdirname);

                % delete the zip file
                delete([folder,'.zip'])

                % output to the command window
                disp(['Downloaded and unzipped ',folder])
            
            catch % failed to download
                % output to the command window
                disp(['Failed to download ',folder])
                
                % remove the html file
                delete([folder,'.html'])
                
            end
            
        else
            % output to the command window
            disp(['Already available ',folder])
        end
    end
    
    % change back to the original directory
    cd(olddir)
end
%--------------------------------------------------------------------------
function ExtractZips(zips,outputdir)

    % store the current directory
    olddir = pwd;
    
    % create a folder for outputdir
    if ~exist(outputdir, 'dir')
        mkdir(outputdir); % create the folder
    else
        addpath(genpath(outputdir)); % add folders and subfolders to path
    end
    
    % change to the output directory
    cd(outputdir)

    % go through each zip
    for k = 1:length(zips)

        % get data
        url = zips(k).url;
        folder = zips(k).folder;
        test = zips(k).test;

        % first check if the test file is in the path
        if exist(test,'file') == 0

            try
                % 
                zipname = url;
                
                % save location
                outputdirname = fullfile(outputdir,folder);

                % create a folder utilizing name as the foldername name
                if ~exist(outputdirname, 'dir')
                    mkdir(outputdirname);
                end

                % unzip the zip
                unzip(zipname,outputdirname);

                % % delete the zip file
                % delete([folder,'.zip'])

                % output to the command window
                disp(['Unzipped ',folder])
            
            catch % failed to download
                % output to the command window
                disp(['Failed to unzip ',folder])
                
            end
            
        else
            % output to the command window
            disp(['Already available ',folder])
        end
    end
    
    % change back to the original directory
    cd(olddir)
end
%--------------------------------------------------------------------------
function RunThisFile(name)
	disp(['--- Running ', name])

	try
	    % run the file
	    run(name);
	catch % error
	    disp(['Could not run ', name])
	end

	disp(' ')
end