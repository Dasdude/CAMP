function r = wgevrnd(k,s,m0,varargin);
%WGEVRND Random matrices from a Generalized Extreme Value distribution
% 
% CALL:  R = wgevrnd(k,s,m0,sz)
%     
%        R = matrix of random numbers
%        k = shape parameter in the GEV
%        s = scale parameter in the GEV, s>0  (default 1)
%       m0 = location parameter in the GEV    (default 0)
%       sz = size(R)    (Default common size of k,s and m0)
%            sz can be a comma separated list or a vector 
%            giving the size of R (see zeros for options). 
% 
% The generalized extreme-value distribution is defined by its cdf
%
%                exp( - (1 - k(x-m)/s))^1/k) ),  k~=0
%  F(x;k,s,m) =
%                exp( -exp(-(x-m)/s) ),  k==0
%
%  for x>s/k+m (when k<=0) and x<m+s/k (when k>0).
%
% The random numbers are generated by the inverse method. 
%
% Example:
%   R1=wgevrnd(0.5,5,0,1,100);  % Finite end-point (R1<4)
%   plot(R1,'.')
%   R2=wgevrnd(0,2,0,1,100);    % Gumbel
%   plot(R2,'.')
%   R3=wgevrnd(-.5,.2,0,1,100); % Heavy tailed
%   plot(R3,'.')
%
% See also  wgevinv, zeros


% Tested on: Matlab 5.3
% History: 
% Revised by jr 22.12.1999
% revised ms 14.06.2000
% - updated header info
% - changed name to wgevrnd (from gevrnd)
% - allowed 3 arguments
% revised pab 23.10.2000
%   - added default s,m0
%  - added comnsize, nargchk
%  - added greater flexibility on the sizing of R

error(nargchk(2,inf,nargin))
if nargin<2|isempty(s), s=1;end
if nargin<3|isempty(m0), m0=0;end

if nargin<4,
  [errorcode k ,s,m0] = comnsize(k,s,m0);
else
  [errorcode k,s,m0] = comnsize(k,s,m0,zeros(varargin{:}));
end
if errorcode > 0
  error('k,s and m0 must be of common size or scalar.');
end
  
r = wgevinv(rand(size(k)),k,s,m0);
