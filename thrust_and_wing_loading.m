WS_to=1:1:6000;%N/m2
PW_tof=(2*sqrt(0.03/(pi*0.7*8.5))*500*0.278/0.8):1:50;
%taking off
top=520;
sigma=1;
CL_to=2.2;
PW_to=WS_to.*((2.20462*745.7)/(0.45*9.81*3.28084^2*9.81*top*sigma*CL_to));
%service ceiling
roc=0.508;
rho_sc=0.66;
CD_sc=0.04;
AR=8.5;
e=0.7;
w_to=0.98;
w_cl=0.99;
V_sc=sqrt(2.*WS_to.*(w_to*w_cl*sqrt(1/(pi*AR*e*3*CD_sc))));
PW_sc=((roc+0.5*rho_sc.*V_sc.^2*CD_sc.*V_sc./(WS_to.*(w_to*w_cl)))./(w_to*w_cl))./0.8;
%Maximum speed
rho_ms=0.9093;
V_ms=500*0.278;
AR=8.5;
e=0.7;
n=0.8;
CD_ms=0.03;
W_pl=5500;
WTO=17000;
w_cruise=0.988071713;
w_ds=1;
w_drop1=0.991370017-W_pl/(WTO*w_to*w_cl*w_cruise*w_ds);
w_scooping=0.991370017+W_pl/(WTO*w_to*w_cl*w_cruise*w_ds*w_drop1*w_cl*...
    w_cruise*w_ds);
w_drop2=0.991370017-W_pl/(WTO*w_to*w_cl*w_cruise*w_ds*w_drop1*w_cl*...
    w_cruise*w_ds*w_scooping*w_cl*w_cruise*w_ds);
w=w_to*w_cl*w_cruise*w_ds*w_drop1*w_cl*w_cruise*w_ds*w_scooping*w_cl*...
    w_cruise*w_ds*w_drop2*w_cl;
%PW_ms=(V_ms/n)*((0.5*rho_ms*V_ms^2*CD_ms)./(WS_to.*w)+...
%  WS_to.*((4*w)/(rho_ms*V_ms^2)));
WS_ms=(2*CD_ms*0.5*rho_ms*V_ms^2)./(PW_tof.*(n/V_ms)+...
    sqrt((PW_tof.*(n/V_ms)).^2-4*CD_ms/(pi*AR*e)));
%cruise
rho_cr=0.66;
V_cr=250*0.278;
CL_cr=0.8;
WS_cr=0.5*rho_cr*V_cr^2*CL_cr;
%second stage climb gradient
rho_to=1.225;
V_stall=1.3*40;%sqrt(2*WS_to/(rho_to*CL_to));
L_D=15;
g_sscg=0.024;
PW_sscg=(V_stall/n)*2*(1/L_D+g_sscg);
%missed approach gradient
CL_land=2;
V_stall=1.3*40;%sqrt(2*WS_to*w*w_cruise/(rho_to*CL_land));
g_mag=0.021;
PW_mag=(V_stall/n)*2*(1/L_D+g_mag);
%landing distance
S_land=500;
rho_land=1.225;
mu_roll=0.4;
beta=(11900+200)/23000;
WS_land=S_land*rho_land*CL_land*mu_roll*9.81/(1.69*beta);

WS_stall=0.5*rho_cr*40^2*2.6;

figure();
plot(WS_to,PW_to,'r')
hold on
plot(WS_to,PW_sc,'b')
hold on
plot(WS_ms,PW_tof,'g')
hold on 
xline(WS_cr,'c')
hold on
xline(WS_land,'m')
hold on
xline(WS_stall)
hold on
yline(PW_mag,'y')
hold on 
yline(PW_sscg)
hold on
legend('take-off','sevice ceiling','max speed','cruise','landing',...
    'missed approach','second stage climb')
axis([0 6500 0 50])