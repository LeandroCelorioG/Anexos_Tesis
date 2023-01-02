%% Transformada Sincronizada de Fourier
%ESCUELA POLITECNICA NACIONAL
%MAIN PRINCIPAL
clc, 
close all, clear all
%1. Recepcion de datos (frecuencia, amplitudes y duraciones) de todas las componentes:
% Los datos siguientes solo deben ser remplazados segun se desee introducir problemas de:
% - Resolucion en frecuencia: tonos muy juntos
% - Deteccion: componentes muy pequeñas relativas a la mayor de 1.
 
% 1.1 Frecuencias de las componentes (ordenadas de menor a mayor):
f1=11; f2=20; f3=30; f4=38; f5=44; 
 
% % 1.2 Amplitudes:
a1 = 0.3; a2 = 0.3; a3 = 0.2; a4 = 0.15; a5 = 0.10; 

% 1.3 Duraciones de las componentes:
t1=[0 1]; t2=[1 4]; t3=[2 3]; t4=[3 5]; t5=[4 5]; 

% 1.4 Generacion de la señal compuesta (suma de todas las componentes):
Fs=10*f5; % Fs respecto de la f8 que es la mas exigente 
Ts=1/Fs;
duracion=8; % es el tiempo maximo que ocupan las componentes
t=0:Ts:duracion;
% Primeramente se generan cada una de las componentes en todo el intervalo (4 segundos):
comp1=a1*sin(2*pi*f1*t);
comp2=a2*sin(2*pi*f2*t);
comp3=a3*sin(2*pi*f3*t);
comp4=a4*sin(2*pi*f4*t);
comp5=a5*sin(2*pi*f5*t);
% Se llena de ceros las componentes en los intervalos donde no existen pero se aprovecha
% las posibilidades de Matlab:
comp1=(t<=1).*(comp1);
comp2=((t>=1)&(t<=4)).*(comp2);
comp3=((t>2) & (t<=3)).*(comp3);
comp4=((t>=3)&(t<=5)).*(comp4);
comp5=((t>=4)&(t<=5)).*(comp5);
% Presentacion de las componentes en forma ascendentes tal como es el
% diagrama TF ideal:
figure (1)
subplot(6,1,1);plot(t,comp5);xlim([0 5]);title('componente 5'); xlabel('t(s)');grid on;
subplot(6,1,2);plot(t,comp4);xlim([0 5]);title('componente 4'); xlabel('t(s)');grid on;
subplot(6,1,3);plot(t,comp3);xlim([0 5]);title('componente 3'); xlabel('t(s)');grid on;
subplot(6,1,4);plot(t,comp2);xlim([0 5]);title('componente 2'); xlabel('t(s)');grid on;
subplot(6,1,5);plot(t,comp1);xlim([0 5]);title('componente 1'); xlabel('t(s)');grid on;
% Una vez generadas las componentes, las sumamos para obtener la seÃ±al compuesta:
yt1 = comp1+comp2+comp3+comp4+comp5;
subplot(6,1,6);plot(t,yt1,'r');title('Señal compuesta'); xlabel('t(s)');grid on;
sgtitle('Componentes individuales y señal compuesta')
xlim([0 5]) 
% Visualizacion del TF ideal en conjunto con la señal compuesta obtenida de
% manera que se vea la existencia de una o varias componentes segun los intervalos  
figure (2)
subplot(2,1,1);
hold on
plot (t1,[f1 f1],'linewidth',2)
plot (t2,[f2 f2],'linewidth',2)
plot (t3,[f3 f3],'linewidth',2)
plot (t4,[f4 f4],'linewidth',2)
plot (t5,[f5 f5],'linewidth',2)
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL')
grid minor
xlabel('t(sec)')
ylabel('F(Hz)')
axis([0 5 0 50])
legend('a1 = 0.3','a2 = 0.3','a3 = 0.2','a4 = 0.15','a5 = 0.10')
subplot(2,1,2);
plot(t,yt1);
title('Señal compuesta');
xlabel('t(sec)');
ylabel('F(Hz)');
grid minor
axis([0 5 -0.5 0.5]) % mismos limites horizontales que el TF ideal para ver correspondencias
xn=yt1;

%% ANALISIS EN T-F CON FSST
 
%4.1 MEJOR RESOLUCION EN TIEMPO
window_T=rectwin(fix(length(xn)/20));
[d_T, f_T, t_T] = fsst(xn,Fs,window_T);
 
%4.2 MEJOR RESOLUCION EN FRECUENCIA
window_F=blackmanharris(fix(length(xn)/5));
[d_F, f_F, t_F] = fsst(xn,Fs,window_F);


%% TIEMPO
figure
subplot(2,1,1);
hold on
plot (t1,[f1 f1],'linewidth',2)
plot (t2,[f2 f2],'linewidth',2)
plot (t3,[f3 f3],'linewidth',2)
plot (t4,[f4 f4],'linewidth',2)
plot (t5,[f5 f5],'linewidth',2)
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL')
xlabel('t(sec)')
ylabel('F(Hz)')
axis([0 5 0 50])
grid minor
legend(['a1 = ' num2str(a1)],['a2 = ' num2str(a2)],['a3 = ' num2str(a3)],...
    ['a4 = ' num2str(a4)],['a5 = ' num2str(a5)])

% FSST RESOLUCION EN TIEMPO
subplot(2,1,2);
contour(t_T,f_T,abs(d_T));
title('FSST CON RESOLUCION EN TIEMPO')
xlabel('t(sec)')
ylabel('F(Hz)')
axis([0 5 0 50])
grid minor
 
%% Frecuencia
figure
subplot(2,1,1);
hold on
plot (t1,[f1 f1],'linewidth',2)
plot (t2,[f2 f2],'linewidth',2)
plot (t3,[f3 f3],'linewidth',2)
plot (t4,[f4 f4],'linewidth',2)
plot (t5,[f5 f5],'linewidth',2)
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL')
xlabel('t(sec)')
ylabel('F(Hz)')
axis([0 5 0 60])
grid minor
legend(['a1 = ' num2str(a1)],['a2 = ' num2str(a2)],['a3 = ' num2str(a3)],...
    ['a4 = ' num2str(a4)],['a5 = ' num2str(a5)])

%colorbar
%FSST RESOLUCION EN FRECUENCIA
subplot(2,1,2);
contour(t_F,f_F,abs(d_F));



title('FSST CON RESOLUCION EN FRECUENCIA')
xlabel('t(sec)')
ylabel('F(Hz)')
axis([0 5 0 50])
grid minor