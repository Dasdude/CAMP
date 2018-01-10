function R = wgamrnd(a,b,varargin);
%WGAMRND Random matrices from a Gamma distribution.
%
%  CALL:  R = wgamrnd(a,b,sz);
%
%       a,b = parameters, a,b>0
%        sz = size(R)    (Default common size of a and b)
%             sz can be a comma separated list or a vector 
%             giving the size of R (see zeros for options).
%
% The random numbers are generated by rejection sampling.
%
% Example:
%   R = wgamrnd(2,1,1,100);
%   plot(R,'.')
%
% See also  wgaminv


% Tested on: matlab 5.3
% History:
% based on rgamma.m (stixbox) by  (c) Anders Holtsberg 10-05-2000.
% revised pab 23.10.2000
%  - added default b
%  - added comnsize, nargchk
%  - added greater flexibility on the sizing of R
%  - rejection sampling method modified to give any size of a and b
%    the recursive call in rgamma is replaced with a while loop.
%  - replaced inversion method with a modified version of 
%    rgamma from stixbox (Anders Holtsberg)
% The algorithm is a rejection method. The logarithm of the gamma 
% variable is simulated by dominating it with a double exponential.
% The proof is easy since the log density is convex!
% 
% Reference: There is no reference! Send me (Anders Holtsberg) an email
% if you can't  figure it out.

error(nargchk(1,inf,nargin))
if nargin<2|isempty(b), b=1; end

if nargin<3,
  [errorcode a b] = comnsize(a,b);
else
  [errorcode a b] = comnsize(a,b,zeros(varargin{:}));
end

if errorcode > 0,
  error('a and b must be of common size or scalar.');
end

%R = wgaminv(rand(size(a)),a,b); % slower
%return
R = zeros(size(a));

ok = ((a>0) & (b>0));
k = find(ok);
if any(k),
  ak=a(k);
  y0 = log(ak)-1./sqrt(ak);
  c  = ak - exp(y0);
  c1 =(ak.*y0 - exp(y0));
  c2 = abs((y0-log(ak)));
  
  accept=k;  omit=[];
  while ~isempty(accept)
    ak(omit)=[];  c(omit) =[];
    c1(omit)=[];  c2(omit)=[];
    sz = size(ak);
    la = log(ak);
    y  = log(rand(sz)).*sign(rand(sz)-0.5)./c + la;

    f = ak.*y-exp(y) - c1;
    g = c.*(c2 - abs(y-la));
  
    omit = find((log(rand(sz)) + g) <= f);
    if ~isempty(omit)
      R(accept(omit)) = exp(y(omit));
      accept(omit)=[];
    end
  end % while
  R(k) = R(k).*b(k);
end
  
k1=find(~ok);
if any(k1);
  tmp=NaN;
  R(k1)=tmp(ones(size(k1)));
end
return



