[W_scp Wf_scp We_scp]=all_scoop()

[W_fr Wf_fr We_fr]=all_fire_retardant()

function [W01,Wf,We]=all_scoop()

Vc=250;%cruise speed (Kmph)
sfc=7.79e-7;%specific fuel consumption
n=0.8;%efficiency
L_D=15;%lift to drag(Kg)
W_pl=5500;%weight of payload or water weight(Kg)
w_to=0.98;%weightfraction for take off
w_cl=0.99;%weightfraction for climb
w_ds=1;%weight fraction for descent
w_fdo=exp(-(200000*sfc)/(n*L_D));%weightfraction for to sea
w_ts=exp(-(250000*sfc)/(n*L_D));%weightfraction for to sea
w_loiter=exp(-(120*0.278*Vc*sfc)/(n*0.866*L_D));%weightfraction for loiter
w_td=exp(-(250000*sfc)/(n*L_D));%weightfraction to drop
w_to_land=exp(-(200000*sfc)/(n*L_D));%weight fraction to land
w_l=0.99;%weightfraction for landing
w_do=exp(-(30*60*0.278*Vc*sfc)/(n*0.866*L_D));
w_scp=exp(-(1000*sfc)/(n*L_D));

W01=27800;%take off weight
dW=5;
while dW>1
    W0=W01;
    %take off segment
    W1=W0*w_to;
    Wf1=W0-W1;

    %climb segment
    W2=W1*w_cl;
    Wf2=W1-W2;

    %first drop range segmnet
    W3=W2*w_fdo;
    Wf3=W2-W3;

    %descent segment
    W4=W3*w_ds;
    Wf4=W3-W4;

    % 1st drop segment
    W5=W4*w_do-W_pl;
    Wf5=W4*(1-w_do);

    %climb
    W6=W5*w_cl;
    Wf6=W5-W6;

    %to sea
    W7=W6*w_ts;
    Wf7=W6-W7;
    
    %descent 
    W8=W7*w_ds;
    Wf8=W7-W8;
    
    %scoop
    W9=W8*w_scp+W_pl;
    Wf9=W8*(1-w_scp);
    
    %climb
    W10=W9*w_cl;
    Wf10=W9-W10;
    
    %to drop
    W11=W10*w_td-W_pl;
    Wf11=W10*(1-w_do);
    
    %descent
    W12=W11*w_ds;
    Wf12=W11-W12;
    
    %drop
    W13=W12*w_do-W_pl;
    Wf13=W12*(1-w_do);
    
    %climb
    W14=W13*w_cl;
    Wf14=W13-W14;
    
    %to land
    W15=W14*w_to_land;
    Wf15=W14-W15;
    
    %descent 
    W16=W15*w_ds;
    Wf16=W15-W16;
    
    %land
    W17=W16*w_l;
    Wf17=W16-W17;


    Wf=Wf1+Wf2+Wf3+Wf4+Wf5+Wf6+Wf7+Wf8+Wf9+Wf10+Wf11+Wf12+Wf13+Wf14+...
        Wf15+Wf16+Wf17;

    We=0.42*(2.20462*W0)^-0.01*(12*9.81/745.7/2.20462)^0.05*...
        (1350/9.81*2.20462/3.28^2)^-0.12*270^0.18;

    W01=200+Wf+W_pl+We*W0;
    dW=abs(W01-W0);
end
end
    
function [W01 Wf We]=all_fire_retardant()

Vc=250;%cruise speed (Kmph)
sfc=7.79e-7;%specific fuel consumption
n=0.8;%efficiency
L_D=15;%lift to drag(Kg)
W_pl=5000;%weight of payload or water weight(Kg)
w_to=0.98;%weightfraction for take off
w_cl=0.99;%weightfraction for climb
w_ds=1;%weight fraction for descent
w_return=exp(-(200000*sfc)/(n*L_D));%weightfraction for return to airport
w_td=exp(-(200000*sfc)/(n*L_D));%weightfraction to drop
w_to_land=exp(-(200000*sfc)/(n*L_D));%weight fraction to land
w_l=0.99;%weightfraction for landing
w_do=exp(-(30*60*0.278*Vc*sfc)/(n*0.866*L_D));

W01=27800;%take off weight
dW=5;
while dW>1
    W0=W01;
    W9=W0;
    for i=1:2
        %take off segment
        W1=W9*w_to+(i-1)*W_pl;
        Wf1=W9*(1-w_to);

        %climb segment
        W2=W1*w_cl;
        Wf2=W1-W2;

        %to drop range segmnet
        W3=W2*w_td;
        Wf3=W2-W3;

        %descent segment
        W4=W3*w_ds;
        Wf4=W3-W4;

        %drop segment
        W5=W4*w_do-W_pl;
        Wf5=W4*(1-w_do);

        %climb
        W6=W5*w_cl;
        Wf6=W5-W6;

        %to airport
        W7=W6*w_return;
        Wf7=W6-W7;

        %descent 
        W8=W7*w_ds;
        Wf8=W7-W8;

        %land
        W9=W8*w_l;
        Wf9=W8-W9;

        Wf_(i)=Wf1+Wf2+Wf3+Wf4+Wf5+Wf6+Wf7+Wf8+Wf9;
    end

    Wf=sum(Wf_);
    
    We=0.42*(2.20462*W0)^-0.01*(12*9.81/745.7/2.20462)^0.05*...
        (1350/9.81*2.20462/3.28^2)^-0.12*270^0.18;

    W01=200+Wf+W_pl+We*W0;
    dW=abs(W01-W0);
end

end

