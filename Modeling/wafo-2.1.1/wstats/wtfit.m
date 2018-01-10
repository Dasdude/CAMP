function [phat, cov,pci]=wtfit(data1, plotflag);
%WTFIT Parameter estimates for Student's T data.
%
% CALL:  [phat, var] = wtfit(data, plotflag)
%
%     phat = [df] = the maximum likelihood estimate of the  
%            parameter of the T distribution 
%            given the data.
%     var  = asymptotic variance of the estimate 
%     data = data vector
% plotflag = 0, do not plot
%          > 0, plot the empiricial distribution function and the
%               estimated cdf (see empdistr for options)(default)
%          
% Example:
%   R=wtrnd(2,1,100);
%   phat = wtfit(R,2) 
%
% See also  wtcdf, empdistr

% No Reference
%  

% tested on: matlab 5.3
% History:
% By  pab 24.10.2000
% revised PJ 03-Apr-2001
%  - fmins changed name to fminsearch for version >= 5.3


error(nargchk(1,2,nargin))
if nargin<2|isempty(plotflag),plotflag=1;end

data=data1(:); % make sure it is a vector

sa = std(data)^2;

% Supply a starting guess with method of moments:
phat0 = max(round(2*sa/(sa-1)),1);

mvrs=version;ix=find(mvrs=='.');
if str2num(mvrs(1:ix(2)-1))>5.2,
  phat = round(fminsearch('loglike',phat0,optimset,data,1,'wtpdf'));
else
  phat = round(fmins('loglike',phat0,[],[],data,1,'wtpdf'));
end

phat = [phat-1 phat phat+1] +(phat==1);
LL(1) = loglike(phat(1),data,'wtpdf');
LL(2) = loglike(phat(2),data,'wtpdf');
LL(3) = loglike(phat(3),data,'wtpdf');
[Y,ind] = min(LL);
phat = phat(ind);


if nargout>1,
  [LL, cov] = loglike(phat,data,'wtpdf');
end
if nargout>2
  alpha2 = ones(1,1)*0.05/2;
  var = cov;
  pci = wnorminv([alpha2;1-alpha2], [phat;phat],[var;var]);
end

if plotflag 
  sd = sort(data); 
  empdistr(sd,[sd, wtcdf(sd,phat)],plotflag)
  title([deblank(['Empirical and Student''s T estimated cdf'])])
end
