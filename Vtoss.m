climb_grad=1;
cg=atan(climb_grad/100);
ivtoss=15;
T=243;
W=1210;
cd=0.02;
S=11.11;
dv=1;
while dv>=0.0001
    vtoss=0.9*T*ivtoss/(W*sin(cg)+0.5*1.22*ivtoss^2*cd*S);
    dv=abs(vtoss-ivtoss);
    ivtoss=vtoss;
end
disp(vtoss)