clc, clear all, close all,
%% Condiciones Iniciales y cambio de variables
simp=1;
umax=16;
g=9.81;
x0=-1.05;
z0=1.3;
zf0=1.1;
xd0=4.1;
zd0=-2;
x=x0;
z=z0*umax/g;
xd=xd0/sqrt(umax);
zd=zd0*sqrt(umax)/g;
zf=zf0*umax/g;
Ts=-x/xd
Zc=z-x/xd*zd-1/2*(x/xd)^2
g=1;
%% Definición de tiempo en simulación
T=0.00025;
tf=60;
it=(1:tf/T)*T;
Ts=-x/xd
Zc=z-x/xd*zd-1/2*(x/xd)^2
%% Control, Saturación e Integración por Euler
figure(1)
k2=(sqrt(zf)+1)/2;
for i=1:tf/T
Ts=-x/xd;
Zc=z-x/xd*zd-1/2*(x/xd)^2;
k=1+1./(Ts-1);
u=min(max(((1+k.*Ts.*(1-Ts))*k2+(k.*Ts+1).*(Zc-1/2))./(Ts.^4 ...
.*(1/2+sqrt(zf)./(2*Ts.^2))),0),1);
xdd=x*u;
zdd=-g+z*u;
xd=xd+T*xdd;
zd=zd+T*zdd;
x=x+T*xd;
z=z+T*zd;
X(:,i)=[x;z];
Xd(:,i)=[xd;zd];
XR(:,i)=[x;z*9.81/umax];
XRd(:,i)=[xd*sqrt(umax);zd*9.81/sqrt(umax)];
U(i)=u;
end
Ts=-X(1,:)./Xd(1,:);
Zc=X(2,:)-X(1,:)./Xd(1,:).*Xd(2,:)-1/2*(Ts).^2;
%% Gráfico de simulación
Tdis=0.1;
if simp
for i=0:round((tf/Tdis)/2)
hold off
plot(XR(1,round(1+i*Tdis/T)),XR(2,round(1+i*Tdis/T)),'*r');
hold on
plot(XR(1,:),XR(2,:),'r')
line([XR(1,round(1+i*Tdis/T)) 0],[XR(2,round(1+i*Tdis/T)) 0])
DX=0.5*XRd(1,round(1+i*Tdis/T));DY=0.5*XRd(2,round(1+i*Tdis/T));
quiver(XR(1,round(1+i*Tdis/T)),XR(2,round(1+i*Tdis/T)),DX,DY, ...
'g','MaxHeadSize',0.4)
quiver(0,0,XR(1,round(1+i*Tdis/T))*U(round(1+i*Tdis/T)),XR(2, ...
round(1+i*Tdis/T))*U(round(1+i*Tdis/T)),'linewidth',2, ...
'MaxHeadSize',0.4)
%legend('CoM', 'Trayectoria', '"Pierna" virtual', ...
% 'Vector velocidad CoM','Fuerza de Reacción')
axis([-1.5 1 -1 2])
title('x vs z')
xlabel('x (m)'),ylabel('y (m)'),
drawnow
%pause
pause(Tdis/sqrt(umax))
end
end
%% Gráfico de Salidas: Posición
figure(2)
plot(it/sqrt(umax),XR(1,:)), hold on
plot(it/sqrt(umax),XR(2,:))
plot(it/sqrt(umax),zf0*ones(size(it)),'k')
xlabel('t (s)')
legend('Posición en x (m)','Posición en z (m)' ...
,'zf Referencia en z (m)')
grid on
%% Gráfico de Salidas: Velocidades
figure(3)
plot(it/sqrt(umax),XRd(1,:)), hold on
plot(it/sqrt(umax),XRd(2,:))
xlabel('t (s)')
legend('Velocidad en x (m/s)','Velocidad en z (m/s)')
grid on
%% Gráfico de Entradas: Señal de control
figure(4)
subplot(211)
plot(it/sqrt(umax),U), hold on
axis([0 15 0 1])
xlabel('t (s)')
legend('Señal de control escalada u')
grid on
subplot(212)
plot(it/sqrt(umax),umax*60*U.*sqrt(XR(1,:).^2+XR(2,:).^2)), hold on
xlabel('t (s)')
legend('Fuerza de reacción al suelo real(N)')
grid on
%% Gráfico de Superficie deslizante
figure(5)
plot(it/sqrt(umax),(1./Ts).*(Zc-((sqrt(zf)+1)*(Ts-1)/2+1/2))), hold on
xlabel('t (s)')
legend('Superficie deslizante')
grid on