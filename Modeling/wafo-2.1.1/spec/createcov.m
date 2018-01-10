function R=createcov(nr,vari,ctype)
% CREATECOV Covariance class constructor
%
% CALL:  R=createcov(nr,variables,ctype)
% 
%         nr = number of derivatives (default 0   )
%  variables = 'xyt'                 (default 't' )
%       ctype = 'enc', 'none'   (default none)
%
% Example: R=createcov(1,'tx') create a structure with proper fieldnames for covariance
%           
%       R: []
%       x: []
%       t: []
%       h: Inf
%      tr: []
%    type: 'none'
%    norm: []
%      Rx: []
%      Rt: []
%    note: []
%    date: '16-Sep-1999, 09:50:44'
%
% See also  createspec, datastructures

%Tested on: Matlab 5.3
%History:
% by pab 12.08.99

if nargin<1|isempty(nr)
  nr = 0;
end
if nargin<2|isempty(vari)
  vari = 't';
  Nv   = 1;
else
  vari = sort(lower(vari));
  Nv   = length(vari);
  if ( (vari(1)=='t') & (Nv>1)),
    vari = [vari(2:Nv), 't'];
  end 
end

if nargin<3|isempty(ctype)
  ctype='none';
end

R=struct('R',[]);
for ix=1:Nv
  R = setfield(R,vari(ix),[]);
end
if Nv==1,
  R.stdev=[];
end
R.h=inf;
R.tr=[];
R.phi=0;
if strcmp(ctype(1:3),'enc')
   R.v=0;
end
R.type=ctype;
R.norm=[];

% initialize struct
switch Nv
 case 1, 
  fieldname = vari(ones(1,nr)); 
  for ix=1:nr
    R = setfield(R,fieldname(1:ix),[]);
  end   
case 2,
  for ix=1:nr
    for iy=0:nr-ix
      tmp=[vari(ones(1,ix),1)' vari(ones(1,iy),2)'];
      eval(['R.R' tmp '=[];'  ])
    end
  end   
  for ix=1:nr
    tmp=vari(ones(1,ix),2)';
    eval(['R.R' tmp '=[];'])
  end   
case 3,
 for ix=1:nr
    for iy=0:nr-ix
      for iz=0:nr-ix-iy
        tmp=[vari(ones(1,ix),1)' vari(ones(1,iy),2)' vari(ones(1,iz),3)'];
        eval(['R.R' tmp '=[];' ])
      end
    end
  end   
  for ix=1:nr
    for iy=0:nr-ix
       tmp=[vari(ones(1,ix),2)' vari(ones(1,iy),3)'];
      eval(['R.R' tmp '=[];' ])
    end
  end   
  for ix=1:nr
    tmp=vari(ones(1,ix),3)';
    eval(['R.R' tmp '=[];'])
  end   

otherwise, error('unknown # variables')
end

R.note=[];
R.date=datestr(now);
