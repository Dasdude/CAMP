function R = rt(df,varargin)
%WTRND  Random matrices from a Student's T distribution
%
% CALL:  R = wtrnd(dfn,sz)
%
%        R = matrix of random numbers
%       df = degrees of freedom
%       sz = size(R)    (Default size(df))
%            sz can be a comma separated list or a vector 
%            giving the size of R (see zeros for options)
%
% The random numbers are generated by the inverse method. 
%
% Examples:
%   R  = wtrnd(1,1,100);
%   R2 = wtrnd(1:10);
%   R3 = wtrnd(4,[2 2 3])
%  
% See also  wtinv


% Tested on: Matlab 5.3
% History: 
% revised pab 23.10.2000
%  - added comnsize + nargchk
%  - added greater flexibility on the sizing of R
%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

error(nargchk(1,inf,nargin))
if nargin>1,
  [errorcode df] = comnsize(df,zeros(varargin{:}));
  if errorcode > 0
    error('df must be a scalar or of corresponding size as given by m and n.');
  end
end
csiz=size(df);
R = wtinv(rand(csiz),df);



