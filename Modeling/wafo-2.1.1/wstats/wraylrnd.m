function R = wraylrnd(b,varargin);
%WRAYLRND Random matrices from a Rayleigh distribution
% 
% CALL:  R = wraylrnd(b,sz)
%     
%        R = matrix of random numbers
%        b = parameter
%       sz = size(R)    (Default size(b))
%            sz can be a comma separated list or a vector 
%            giving the size of R (see zeros for options).
%
% The Rayleigh distribution is defined by its cdf
%
%  F(x;b) = 1 - exp(-x^2/(2b^2)), x>=0
%
% The random numbers are generated by the inverse method. 
%
% Example:
%   R=wraylrnd(2,1,100);
%   wraylplot(R);
%
% See also  wraylinv

% Reference: Cohen & Whittle, (1988) "Parameter Estimation in Reliability
% and Life Span Models", p. 181 ff, Marcel Dekker.


% Tested on: Matlab 5.3
% History: 
% revised PJ 03-Apr-2001
%  - added comnsize, nargchk
%  - made sizing of R more flexible
% revised jr 22.11.2000
% - 'reshape' introduced to obtain wanted dimension of output 
% added ms 15.06.2000

error(nargchk(1,inf,nargin))
if nargin>1,
 [errorcode b]=comnsize(b,zeros(varargin{:}));
 if errorcode
   error('b must be a scalar or comply to the size info given.');
 end
end

%if nargin==1,
% m=1;n=1;
%end

R = wraylinv(rand(size(b)),b);
%R = reshape(wraylinv(rand(m,n),b),m,n);

