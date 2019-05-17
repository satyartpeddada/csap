%--------------------------------------------------------------------------
% CSAP_pdfSave.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Contributors: SRT Peddada (satyartpeddada), DR Herber (danielrherber),
% HC Pangborn (herschelpangborn)
% POETS, University of Illinois at Urbana-Champaign
% Project link: https://github.com/satyartpeddada/csap
%--------------------------------------------------------------------------
function CSAP_pdfSave(myfilename,mysavename,pdfflag,varargin)

% 
if pdfflag
    % save the figure with export_fig
    pathpdf = mfoldername(myfilename,'pdf');
    filename = [pathpdf,mysavename];
    str = ['export_fig ''',filename,''' -pdf'];
    eval(str)

    % optional additional save location
    if ~isempty(varargin)
        % save the figure with export_fig
        pathpdf = mfoldername(varargin{1},'pdf');
        filename = [pathpdf,mysavename];
        str = ['export_fig ''',filename,''' -pdf'];
        eval(str)
    end
end

end