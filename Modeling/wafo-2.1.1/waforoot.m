function exedir=watroot;
% WAFOROOT Root directory of WAFO installation.
%
% CALL:  Str = waforoot 
% 
%    Str = string with the path name to the directory where the
%          Wave Analysis for Fatigue and Oceanography Toolbox is installed.
%
%  WAFOROOT is used to produce platform dependent paths
%  to the various WAFO directories.
% 
%  Example:
%    fullfile(waforoot,filesep, 'spec','')
%
%    produces a full path to the <waforoot>/spec directory that
%    is correct for platform it's executed on.
% 
%    See also  wafopath, wafoexepath, fullfile.


%          NOTE: User no longer has to edit this file (since v1.1.14).
%          It is now automatic.

% Tested on: Matlab 5.3
% History:
% revised by pab 15.09.00
%   - fixed bug: lower(exedir)
% revised by pab 11.08.99
%   new routine  based on old  wavepath  

exedir=which('waforoot');
i=max(findstr(lower(exedir),'waforoot'))-2;
if i>0
  exedir=exedir(1:i);
else
  exedir=[];
  disp('Cannot locate  waforoot.m')
  disp('You must add the path to the WAFO Toolbox')
  disp('to the Matlab-path.')
  error('!!')
end
