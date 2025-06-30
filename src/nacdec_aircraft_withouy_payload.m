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
w_do=[];%weightfraction for drop off
w_scp=[];%weightfraction for scooping
wdo(1)=1;

W_to=43079;
w_scp(1)=0.97+(W_pl/(W_to*w_es*w_tx*w_to*w_cl*w_ts*w_loiter*w_ds));
w_do(1)=0.99-(W_pl/(W_to*w_es*w_tx*w_to*w_cl*w_ts*w_loiter*w_ds*w_scp(1)*w_cl*w_td*w_ds));
w_scp(2)=0.97+(W_pl/(W_to*w_es*w_tx*w_to*w_cl*w_ts*w_loiter*w_ds*w_scp(1)*w_cl*w_td*w_ds*w_do(1)*w_cl*w_ts*w_loiter*w_ds));

    wscp(1)=1;
for i=2:10
    wdo(i)=wdo(i-1)*w_do(i-1);
    wscp(i)=wscp(i-1)*w_scp(i-1);
    w_scp(i)=0.97+(W_pl/(W_to*w_es*w_tx*w_to*w_cl*(w_ts*w_loiter*w_ds)^(i)*wscp(i)*wdo(i)*(w_cl*w_td*w_ds*w_cl)^(i-1)));
    w_do(i)=0.99-(W_pl/(W_to*w_es*w_tx*w_to*w_cl*(w_ts*w_loiter*w_ds*w_cl*w_td*w_ds)^(i)*wscp(i)*w_scp(i)*wdo(i)*(w_cl)^(i-1)));
end
    
wf=1-(w_es*w_tx*w_to*w_cl*((w_ts*w_loiter*w_ds*w_cl*w_td*w_ds*w_cl)^10)*wdo(10)*w_do(10)*wscp(10)*w_scp(10))
Wto=(200+14000)/(1-wf)