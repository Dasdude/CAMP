function c = gridcount(data,X)
%GRIDCOUNT D-dimensional histogram using linear binning.
%
% CALL  c = gridcount(data,X)
%
% c    = gridcount, size N x 1           if D = 1 
%                   size N x N x ... x N if D > 1  
% data = row vectors with D-dimensional data, size Nd x D
% X    = column vectors defining discretization, size N x D
%        Must include the range of the data.
% GRIDCOUNT obtains the grid counts using linear binning.
% There are 2 strategies: simple- or linear- binning.
% Suppose that an observation occurs at x and that the nearest point
% below and above is y and z, respectively. Then simple binning strategy
% assigns a unit weight to either y or z, whichever is closer. Linear
% binning, on the other hand, assigns the grid point at y with the weight
% of (z-x)/(z-y) and the gridpoint at z a weight of (y-x)/(z-y).
%  
% In terms of approximation error of using gridcounts as pdf-estimate,
% linear binning is significantly more accurate than simple binning.  
%
% NOTE: The interval [min(X);max(X)] must include the range of the data.
%       The order of C is permuted in the same order as 
%       meshgrid for D==2 or D==3.  
%   
% Example
%  N     = 500;
%  data  = wraylrnd(1,N,1);
%  x = linspace(0,max(data)+1,50).';  
%  dx = x(2)-x(1);  
%  c = gridcount(data,x);
%  plot(x,c,'.')   % 1D histogram
%  plot(x,c/dx/N)  % 1D probability density plot
%  trapz(x,c/dx/N)   
%
% See also  bincount, kdebin
  
%Reference
%  Wand,M.P. and Jones, M.C. (1995) 
% 'Kernel smoothing'
%  Chapman and Hall, pp 182-192  
  
%  History
% revised pab Feb2005
% -fixed a bug for d>2;  
% by pab Dec2003  
  
error(nargchk(2,2,nargin))

[n,d]    = size(data);  
[inc,d1] = size(X);

if d~=d1
  error('Dimension 2 of data and X do not match.')
end

dx  = diff(X(1:2,:),1);
xlo = X(1,  :);
xup = X(end,:);

if any(min(data,[],1)<xlo) | any(xup<max(data,[],1))
  error('X does not include whole range of the data!')
end

if d>1
  csiz = inc(:,ones(1,d));
  n1   = n;
else
  csiz = [inc,1];
  n1   = 1;
end
  
binx = floor((data-xlo(ones(n1,1),:))./dx(ones(n1,1),:))+1;
w    = prod(dx);
if  d==1,
  try,
    % binc is much faster than sparse for 1D data
    % However, for N-Dimensional data sparse is sometimes faster.
    c = zeros(csiz);
    [len,bin,val] = bincount(binx,(X(binx+1)-data));
    c(bin) = val;
    [len,bin,val] = bincount(binx+1,(data-X(binx)));
    c(bin) = c(bin)+val;
    c = c/w;
  catch
    c = full(sparse(binx,1,(X(binx+1)-data),inc,1)+...
	     sparse(binx+1,1,(data-X(binx)),inc,1))/w;
  end
elseif d==2
  b2 = binx(:,2);
  b1 = binx(:,1);
  c = full(sparse(b1,b2 ,abs(prod(([X(b1+1,1) X(b2+1,2)]-data),2)),inc,inc));
  c = c + sparse(b1+1,b2  ,abs(prod(([X(b1,1) X(b2+1,2)]-data),2)),inc,inc);
  c = c + sparse(b1  ,b2+1,abs(prod(([X(b1+1,1) X(b2,2)]-data),2)),inc,inc);
  c = (c + sparse(b1+1,b2+1,abs(prod(([X(b1,1) X(b2,2)]-data),2)),inc,inc))/w;
else % d>2
 useSparse = 1;
  Nc = prod(csiz);
  c  = zeros(Nc,1);
 
  fact2 = [0 inc*(1:d-1)];
  fact1 = [1 cumprod(csiz(1:d-1))];
  fact1 = fact1(ones(n,1),:);
  for ir=0:2^(d-1)-1,
      bt0 = bitget(ir,1:d);
      bt1 = ~bt0;
      
      % Convert to linear index (faster than sub2ind)
      b1  = sum((binx + bt0(ones(n,1),:)-1).*fact1,2)+1; %linear index to c
      bt2 = bt1 + fact2;
      b2  = binx + bt2(ones(n,1),:);                     % linear index to X
      if useSparse
        % Fast gridding using sparse
        c = c + sparse(b1,1,abs(prod(X(b2)-data,2)),Nc,1);
      else
        [len,bin,val] = bincount(b1,abs(prod(X(b2)-data,2)));
        c(bin)        = c(bin)+val;       
      end
      
       % Convert to linear index (faster than sub2ind)
      b1  = sum((binx + bt1(ones(n,1),:)-1).*fact1,2)+1; % linear index to c
      bt2 = bt0 + fact2;
      b2  = binx + bt2(ones(n,1),:);                     % linear index to X
      
      if useSparse
        % Fast gridding using sparse
        c = c + sparse(b1,1,abs(prod(X(b2)-data,2)),Nc,1);
      else
        [len,bin,val] = bincount(b1,abs(prod(X(b2)-data,2)));
        c(bin)        = c(bin)+val;   
      end
    end
    c = reshape(c/w,csiz);
end
switch d % make sure c is stored in the same way as meshgrid
 case 2,  c = c.';
 case 3,  c = permute(c,[2 1 3]);
end
return