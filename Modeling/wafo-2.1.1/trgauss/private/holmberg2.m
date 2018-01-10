function E=holmberg2(S,a,b,Q1,Q2)
% HOLMBERG2 Computes moments for higher order reliability methods.
%
% CALL: E=holmberg2(S,a,b,Q1);
%
% Computation of the expectation of 
% sqrt(pi/2)*(b'*X)*(X'*Q1*X)(X'*Q2*X)*(2*normcdf(a'*X)-1)
% if S is normally distributed with mean zero and covariance matrix
% S.
Q1=(Q1+Q1')/2;
Q2=(Q2+Q2')/2;
E=1/4*(4*holmquist2(S,Q1,Q2)*(a'*S*b)+8*holmquist2(S,Q1,Q2)*(a'*S*b)*(a'*S*a)+...
    4*holmquist2(S,Q1,Q2)*(a'*S*b)*(a'*S*a)^2+4*holmquist1(S,Q1)*(2*a'*S*Q2*S*b)+...
    8*holmquist1(S,Q1)*(2*a'*S*Q2*S*b)*(a'*S*a)+4*holmquist1(S,Q1)*(2*a'*S*Q2*S*b)*(a'*S*a)^2-...
    2*holmquist1(S,Q1)*(a'*S*b)*(2*a'*S*Q2*S*a)-2*holmquist1(S,Q1)*(a'*S*b)*(2*a'*S*Q2*S*a)*(a'*S*a)+...
    4*holmquist1(S,Q2)*(2*a'*S*Q1*S*b)+8*holmquist1(S,Q2)*(2*a'*S*Q1*S*b)*(a'*S*a)+...
    4*holmquist1(S,Q2)*(2*a'*S*Q1*S*b)*(a'*S*a)^2+4*1*(4*a'*(S*Q1*S*Q2*S+S*Q2*S*Q1*S)*b)+...
    8*1*(4*a'*(S*Q1*S*Q2*S+S*Q2*S*Q1*S)*b)*(a'*S*a)+4*1*(4*a'*(S*Q1*S*Q2*S+S*Q2*S*Q1*S)*b)*(a'*S*a)^2-...
    2*1*(2*a'*S*Q1*S*b)*(2*a'*S*Q2*S*a)-2*1*(2*a'*S*Q1*S*b)*(2*a'*S*Q2*S*a)*(a'*S*a)-...
    2*holmquist1(S,Q2)*(a'*S*b)*(2*a'*S*Q1*S*a)-2*holmquist1(S,Q2)*(a'*S*b)*(2*a'*S*Q1*S*a)*(a'*S*a)-...
    2*1*(2*a'*S*Q2*S*b)*(2*a'*S*Q1*S*a)-2*1*(2*a'*S*Q2*S*b)*(2*a'*S*Q1*S*a)*(a'*S*a)+...
    3*1*(a'*S*b)*(2*a'*S*Q1*S*a)*(2*a'*S*Q2*S*a)-2*1*(a'*S*b)*(4*a'*(S*Q1*S*Q2*S+S*Q2*S*Q1*S)*a)-...
    2*1*(a'*S*b)*(4*a'*(S*Q1*S*Q2*S+S*Q2*S*Q1*S)*a)*(a'*S*a))/(1+(a'*S*a))^(5/2);
% Tested in test041104_1.m





