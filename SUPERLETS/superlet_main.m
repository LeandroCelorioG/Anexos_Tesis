%% SUPERLETS
%ESCUELA POLITECNICA NACIONAL
%MAIN PRINCIPAL
clc, close all, clear all

%% 1. Recepción de datos (frecuencia, amplitudes y duraciones) de todas las componentes:
% Los datos siguientes solo deben ser remplazados según se desee introducir problemas de:
% - Resolución en frecuencia: tonos muy juntos
% - Detección: componentes muy pequeñas relativas a la mayor de 1.
 
% %1.1 Frecuencias de las componentes (ordenadas de menor a mayor):
f1=11; f2=20; f3=30; f4=38; f5=44;
% % 1.2 Amplitudes:
a1 = 0.3; a2 = 0.3; a3 = 0.2; a4 = 0.15; a5 = 0.10; 
% 1.3 Duraciones de las componentes:
t1=[0 1]; t2=[1 4]; t3=[2 3]; t4=[3 5]; t5=[4 5]; 

%% 2. Generación de la señal compuesta (suma de todas las componentes):
Fs=10*f5; % Fs respecto de la f5 que es la más exigente 
Ts=1/Fs;
duracion = 5; % es el tiempo máximo que ocupan las componentes
t=0:Ts:duracion;
%% MÉTODO 2: aprovechando las ventajas de programación de Matlab,
% se realiza el método anterior pero ahora de manera compacta:
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
 
% Presentación de las componentes en forma ascendentes tal como es el
% diagrama TF ideal:
% Una vez generadas las componentes, las sumamos para obtener la señal compuesta:
yt1 = comp1+comp2+comp3+comp4+comp5;

figure (1)
subplot(6,1,1);plot(t,comp5);xlim([0 5]);title('componente 5'); xlabel('t(s)');grid on;
subplot(6,1,2);plot(t,comp4);xlim([0 5]);title('componente 4'); xlabel('t(s)');grid on;
subplot(6,1,3);plot(t,comp3);xlim([0 5]);title('componente 3'); xlabel('t(s)');grid on;
subplot(6,1,4);plot(t,comp2);xlim([0 5]);title('componente 2'); xlabel('t(s)');grid on;
subplot(6,1,5);plot(t,comp1);xlim([0 5]);title('componente 1'); xlabel('t(s)');grid on;
% Una vez generadas las componentes, las sumamos para obtener la seÃ±al compuesta:
yt1 = comp1+comp2+comp3+comp4+comp5;
subplot(6,1,6);plot(t,yt1,'r');title('Señal compuesta'); xlabel('t(s)');grid on;
sgtitle('Componentes individuales y señal compuesta');
xlim([0 5]); 
% Visualización del TF ideal en conjunto con la señal compuesta obtenida de
% manera que se vea la existencia de una o varias componentes según los intervalos  
figure (2)
subplot(2,1,1);
hold on
plot (t1,[f1 f1],'linewidth',2);
plot (t2,[f2 f2],'linewidth',2);
plot (t3,[f3 f3],'linewidth',2);
plot (t4,[f4 f4],'linewidth',2);
plot (t5,[f5 f5],'linewidth',2);
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL');
grid minor;
xlabel('t(sec)');
ylabel('F(Hz)');
axis([0 5 0 50]);
legend('a1 = 0.3','a2 = 0.3','a3 = 0.2','a4 = 0.15','a5 = 0.10');
subplot(2,1,2);
plot(t,yt1);
title('Señal compuesta');
grid minor
xlabel('t(sec)');
ylabel('F(Hz)');
xlim([0 5]); % mismos limites horizontales que el TF ideal para ver correspondencias
%axis([0 6 -5 5]) 
xn = yt1;

%% 2. ANÁLISIS EN FRECUENCIA:
N=length(xn); % numero de muestras de la senial discretizada
FACTOR = 128;
nFFT=2^(ceil(log2(N)))*FACTOR;
f=linspace(0,Fs,nFFT);

%% 3. ANÁLISIS EN T-F: 
% 3.1 T-F (RESOLUCIÓN EN TIEMPO): 
% Se debe emplear el ESPECTROGRAMA con ventana rectangular pequeña (señal / 20):
%window_RT = rectwin(fix(length(xn)/20));
window_RT = blackmanharris(fix(length(xn)/20));
noverlap_RT=fix(length(window_RT)/2);
L_ventana_RT=length(window_RT);
FACTOR = 128;
nFFT_ventana_RT=2^(ceil(log2(L_ventana_RT)))*FACTOR;
[P_RT,f_RT,t_RT]=spectrogram(xn,window_RT,noverlap_RT,nFFT_ventana_RT,Fs,'yaxis');
 
%% 3.2 (T-F): RESOLUCIÓN EN FRECUENCIA: 
% Se debe emplear el ESPECTROGRAMA con ventana de Rectangular grande (señal / 5):
%window_RF = rectwin(fix(length(xn)/5));
window_RF = blackmanharris(fix(length(xn)/5));
noverlap_RF=fix(length(window_RF)/2);
L_ventana_RF=length(window_RF);
FACTOR = 128;
nFFT_ventana_RF=2^(ceil(log2(L_ventana_RF)))*FACTOR;
[P_RF,f_RF,t_RF]=spectrogram(xn,window_RF,noverlap_RF,nFFT_ventana_RF,Fs,'yaxis');
%% Superlets
fois = 0.1:0.1:50;  %vector buffer para el rango de las frecuencias 
srord= [1, 30];     %vector de ciclos para tiempo
srord2= [1, 50];    %vector de ciclos para frecuencia
% tiempo
RT_SL = aslt(xn, Fs, fois, 5, srord, 0);
% frecuencia
RF_SL = faslt(xn, Fs, fois, 8, srord2, 0);
%% RESULTADOS EN TIEMPO
figure (3) 
subplot(3,1,1);
hold on
plot (t1,[f1 f1],'linewidth',2);
plot (t2,[f2 f2],'linewidth',2);
plot (t3,[f3 f3],'linewidth',2);
plot (t4,[f4 f4],'linewidth',2);
plot (t5,[f5 f5],'linewidth',2);
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL');
xlabel('t(sec)');
ylabel('F(Hz)');
axis([0 5 0 50]);
legend('a1 = 0.3','a2 = 0.3','a3 = 0.2','a4 = 0.15','a5 = 0.10');
grid minor;

subplot(3,1,2);
%contour(t_RT,f_RT,abs(P_RT));
contour(t_RT,f_RT,20*log10(abs(P_RT)));
colorbar('vert');
%axis([0 5 0 50])
ylim([0 50]);
grid on;
xlabel('TIEMPO (segundos)');
title('ESPECTROGRAMA CON RESOLUCIÓN EN TIEMPO');
xlabel('t(sec)');
ylabel('F(Hz)');

%Graficamos la resolucion en tiempo Superlets
subplot(3,1,3);
imagesc(t,fois,RT_SL);
set(gca, 'ydir', 'normal');
colormap jet;
axis([0 5 0 50]);
grid on;
xlabel('TIEMPO (segundos)');
title('SUPERLETS CON RESOLUCIÓN EN TIEMPO');
xlabel('t(sec)');
ylabel('F(Hz)');
%% RESULTADOS EN FRECUENCIA
figure (4) 
subplot(3,1,1);
hold on;
plot (t1,[f1 f1],'linewidth',2);
plot (t2,[f2 f2],'linewidth',2);
plot (t3,[f3 f3],'linewidth',2);
plot (t4,[f4 f4],'linewidth',2);
plot (t5,[f5 f5],'linewidth',2);
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL');
xlabel('t(sec)');
ylabel('F(Hz)');
axis([0 5 0 50]);
legend('a1 = 0.3','a2 = 0.3','a3 = 0.2','a4 = 0.15','a5 = 0.10');
grid minor;

%Resolucion en frecuencia
%contour(t_RF,f_RF,abs(P_RF));
subplot(3,1,2);
contour(t_RF,f_RF,20*log10(abs(P_RF)));
colorbar('vert');
%axis([0 5 0 50])
ylim([0 50]);
grid on;
xlabel('TIEMPO (segundos)');
title('ESPECTROGRAMA CON RESOLUCIÓN EN FRECUENCIA');

%Graficamos la resolucion en frecuencia Superlets 
subplot(3,1,3);
imagesc(t,fois,RF_SL);
set(gca, 'ydir', 'normal');
colormap jet;
axis([0 5 0 50]);
grid on;
xlabel('TIEMPO (segundos)');
title('SUPERLETS CON RESOLUCIÓN EN FRECUENCIA');
xlabel('t(sec)');
ylabel('F(Hz)');