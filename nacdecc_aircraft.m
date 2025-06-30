Vc=250;%cruise speed (Kmph)
sfc=7.17634e-7;%specific fuel consumption
n=0.8;%efficiency
L_D=15;%lift to drag(Kg)
W_pl=5500;%weight of payload or water weight(Kg)
%W_to=30000;%take off weight
w_es=0.992;%weightfraction for engine start
w_tx=0.99;%weightfraction for taxing
w_to=0.97;%weightfraction for take off
w_cl=0.985;%weightfraction for climb
w_ds=0.99;%weight fraction for descent
w_fdo=exp(-(185000*sfc)/(n*L_D));%weightfraction for to sea
w_ts=exp(-(Vc*0.278*9*60*sfc)/(n*L_D));%weightfraction for to sea
w_loiter=exp(-(120*0.278*Vc*sfc)/(n*0.866*L_D));%weightfraction for loiter
w_td=exp(-(Vc*0.278*7.9*60*sfc)/(n*L_D));%weightfraction to drop
w_l=0.99;%weightfraction for landing
w__do=0.99;
w__scp=0.97;
w_do=[];%weightfraction for drop off
w_scp=[];%weightfraction for scooping
wdo(1)=1;
wdo(2)=1;

W_to=46900;
w_do(1)=0.99-(W_pl/(W_to*w_es*w_tx*w_to*w_cl*w_fdo*w_ds));
w_scp(1)=0.97+(W_pl/(W_to*w_es*w_tx*w_to*w_cl*w_fdo*w_ds*w_do(1)*w_cl*w_ts*w_loiter*w_ds));
w_do(2)=0.99-(W_pl/(W_to*w_es*w_tx*w_to*w_cl*w_fdo*w_ds*w_do(1)*w_cl*w_ts*w_loiter*w_ds*w_scp(1)*w_cl*w_td*w_ds));
w_scp(2)=0.97+(W_pl/(W_to*w_es*w_tx*w_to*w_cl*w_fdo*w_ds*w_do(1)*w_cl*w_ts*w_loiter*w_ds*w_scp(1)*w_cl*w_td*w_ds*w_do(2)*w_cl*w_ts*w_loiter*w_ds));

    wscp(2)=w_scp(2);
for i=3:10
    wdo(i)=wdo(i-1)*w_do(i-1);
    wscp(i)=wscp(i-1)*w_scp(i-1);
    w_do(i)=0.99-(W_pl/(W_to*w_es*w_tx*w_to*w_cl*w_fdo*w_ds*w_do(1)*w_cl*(w_ts*w_loiter*w_ds*w_cl*w_td*w_ds)^(i-1)*wscp(i)*wdo(i)*(w_cl)^(i-2)));
    w_scp(i)=0.97+(W_pl/(W_to*w_es*w_tx*w_to*w_cl*w_fdo*w_ds*w_do(1)*w_cl*(w_ts*w_loiter*w_ds)^(i)*wscp(i)*wdo(i)*w_do(i)*(w_cl*w_td*w_ds*w_cl)^(i-1)));
end
    
wf=1-(w_es*w_tx*w_to*w_cl*w_fdo*w_ds*w_do(1)*w_cl*((w_ts*w_loiter*w_ds*w_cl*w_td*w_ds*w_cl)^9)*wdo(10)*w_do(10)*wscp(10)*w_ds*w_l);
wff=wf-(W_pl/W_to)
Wto=(200+14000)/(1-wf)

% BY ADDING FUEL WEIGHTS
W_es=W_to*(1-w_es);
W_tx=(W_to-W_es)*(1-w_tx);
Wf_to=(W_to-W_es-W_tx)*(1-w_to);
W_cl(1)=(-Wf_to+W_to-W_es-W_tx)*(1-w_cl);
W_fdo=(W_to-sum(W_cl)-Wf_to-W_es-W_tx)*(1-w_fdo);
W_ds(1)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx)*(1-w_ds);
W_do(1)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds))*(1-w__do);
W_cl(2)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-5500)*(1-w_cl);

for i=1:9
    W_ts(i)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-5500)*(1-w_ts);
    W_lo(i)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-5500)*(1-w_loiter);
    W_ds(2*i)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-sum(W_lo)-5500)*(1-w_ds);
    W_scp(i)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-sum(W_lo))*(1-w__scp);
    W_cl(2*i+1)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-sum(W_lo)-sum(W_scp))*(1-w_cl);
    W_td(i)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-sum(W_lo)-sum(W_scp))*(1-w_td);
    W_ds(2*i+1)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-sum(W_lo)-sum(W_scp)-sum(W_td))*(1-w_ds);
    W_do(i+1)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-sum(W_lo)-sum(W_scp)-sum(W_td))*(1-w__do);
    W_cl(2*(i+1))=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-sum(W_lo)-sum(W_scp)-sum(W_td)-5500)*(1-w_cl);
end
W_ds(20)=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-sum(W_lo)-sum(W_scp)-sum(W_td)-5500)*(1-w_ds);
W_l=(W_to-W_fdo-sum(W_cl)-Wf_to-W_es-W_tx-sum(W_ds)-sum(W_do)-sum(W_ts)-sum(W_lo)-sum(W_scp)-sum(W_td)-5500)*(1-w_l);

WFF=(W_es+W_tx+Wf_to+W_fdo+W_l+sum(W_cl)+sum(W_ds)+sum(W_do)+sum(W_scp)+sum(W_ts)+sum(W_td)+sum(W_lo))/W_to
