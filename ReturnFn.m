function F = ReturnFn(aprime,a,z,r,w,sigma)


cons = (1+r)*a+w*z-aprime;

F = -inf(size(cons));

pos = cons>0;

F(pos) = cons(pos).^(1-sigma)/(1-sigma);

 


end