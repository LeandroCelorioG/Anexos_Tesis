%% Transformada Reasignada de Fourier
%ESCUELA POLITECNICA NACIONAL
%MAIN PRINCIPAL
clc, 
close all, clear all
%% 1. Recepción de datos (frecuencia, amplitudes y duraciones) de todas las componentes:
% Los datos siguientes solo deben ser remplazados según se desee introducir problemas de:
% - Resolución en frecuencia: tonos muy juntos
% - Detección: componentes muy pequeñas relativas a la mayor de 1.
% %1.1 Frecuencias de las componentes (ordenadas de menor a mayor):
% f1=200; f2=300; f3=600; f4=800; f5=900;

%f1=11; f2=20; f3=30; f4=38; f5=44;
% % 1.2 Amplitudes:
% a1=1; a2=1; a3=1; a4=1; a5=1; a6=1; a7=1; a8=1;
%a1=0.4; a2=0.3; a3=0.2; a4=0.15; a5 = 0.10;
%a1= 1; a2= 0.001; a3= 0.0001; a4= 0.001; a5= 1;
% 1.3 Duraciones de las componentes:
%t1=[0 1]; t2=[1 4]; t3=[2 3]; t4=[3 4]; t5=[4 5]; 



%f1=10; f2=30; f3=60; f4=80; f5=90; 
f1=100; f2=300; f3=400; f4=500; f5=550;
% DESCOMENTAR PARA HACER USO DE LA PRUEBA 1
% % 1.2 Amplitudes: en este caso todas las amplitudes son iguales (0,3). 
% a1 = 0.3; a2 = 0.3; a3 = 0.3; a4 = 0.3; a5 = 0.3; 
a1 = 1; a2 = 1; a3 = 1; a4 = 1; a5 = 1; 

% 1.3 Duraciones de las componentes:
%t1=[0 0.75]; t2=[0.5 1]; t3=[0.5 0.75]; t4=[0.5 1]; t5=[0.25 0.75]; 
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
figure
subplot(6,1,1);plot(t,comp5);xlim([0 5]);title('componente 5'); xlabel('t(s)');grid on;
subplot(6,1,2);plot(t,comp4);xlim([0 5]);title('componente 4'); xlabel('t(s)');grid on;
subplot(6,1,3);plot(t,comp3);xlim([0 5]);title('componente 3'); xlabel('t(s)');grid on;
subplot(6,1,4);plot(t,comp2);xlim([0 5]);title('componente 2'); xlabel('t(s)');grid on;
subplot(6,1,5);plot(t,comp1);xlim([0 5]);title('componente 1'); xlabel('t(s)');grid on;
% Una vez generadas las componentes, las sumamos para obtener la señal compuesta:
yt1 = comp1+comp2+comp3+comp4+comp5;
subplot(6,1,6);plot(t,yt1,'r');title('Señal Compuesta'); xlabel('t(s)');grid minor;
sgtitle('Componentes individuales y señal compuesta')
xlim([0 5])
% Visualización del TF ideal en conjunto con la señal compuesta obtenida de
% manera que se vea la existencia de una o varias componentes según los intervalos
figure
subplot(2,1,1);
hold on
plot (t1,[f1 f1],'linewidth',2)
plot (t2,[f2 f2],'linewidth',2)
plot (t3,[f3 f3],'linewidth',2)
plot (t4,[f4 f4],'linewidth',2)
plot (t5,[f5 f5],'linewidth',2)

grid minor
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL')
xlabel('t(sec)')
ylabel('F(Hz)')
%axis([0 5])
legend(['a1 = ' num2str(a1)],['a2 = ' num2str(a2)],['a3 = ' num2str(a3)],...
    ['a4 = ' num2str(a4)],['a5 = ' num2str(a5)])
%legend('Amp.1: 1','Amp.2: 0.01','Amp.3: 0.001','Am.p4: 0.01','Amp.5: 1')
subplot(2,1,2);
plot(t,yt1);
xlim([0 5])
grid minor
title('Señal compuesta Suma de Señales');
xlabel('t(sec)');
ylabel('Amplitud');
%axis([0 5]) % mismos limites horizontales que el TF ideal para ver correspondencias
xn = yt1';
%% 3. ANÁLISIS EN T-F:
figure (3) %%Resultados en Frecuencia
subplot(2,1,1);
hold on
plot (t1,[f1 f1],'linewidth',2)
plot (t2,[f2 f2],'linewidth',2)
plot (t3,[f3 f3],'linewidth',2)
plot (t4,[f4 f4],'linewidth',2)
plot (t5,[f5 f5],'linewidth',2)
grid minor
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL')
xlabel('t(sec)')
ylabel('F(Hz)')
axis([0 5 0 550])
legend(['a1 = ' num2str(a1)],['a2 = ' num2str(a2)],['a3 = ' num2str(a3)],...
    ['a4 = ' num2str(a4)],['a5 = ' num2str(a5)])

%% Para Frecuencia
subplot(2,1,2);
[P, F, T]=pspectrum(yt1,Fs,'FrequencyLimits',[0 600],'TimeResolution',0.1,'Leakage',0.85,'spectrogram','Reassign',true);
mesh(seconds(T),F,P)
colormap parula
title('ESPECTROGRAMA REASIGNADO EN FRECUENCIA')
xlabel('Tiempo')
ylim([0 600])
ylabel('F(Hz)')
axis tight
view(2)

figure(4) %%Resultados en Tiempo

subplot(2,1,1);
hold on
plot (t1,[f1 f1],'linewidth',2)
plot (t2,[f2 f2],'linewidth',2)
plot (t3,[f3 f3],'linewidth',2)
plot (t4,[f4 f4],'linewidth',2)
plot (t5,[f5 f5],'linewidth',2)
grid minor
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL')
xlabel('t(sec)')
ylabel('F(Hz)')
axis([0 5 0 600])
legend(['a1 = ' num2str(a1)],['a2 = ' num2str(a2)],['a3 = ' num2str(a3)],['a4 = ' num2str(a4)],['a5 = ' num2str(a5)])

subplot(2,1,2);
%[P, F, T]=pspectrum(yt1,Fs,'TimeResolution',1.5,'spectrogram','Reassign',true);
[P, F, T]=pspectrum(yt1,Fs,'FrequencyLimits',[0 650],'Leakage',0.85,'TimeResolution',0.1,'spectrogram','Reassign',true);
%[P, F, T]=pspectrum(yt1,Fs,'spectrogram','Reassign',true);
mesh(seconds(T),F,P)
%colormap hot
title('ESPECTROGRAMA REASIGNADO EN TIEMPO')

xlabel('Tiempo')
ylabel('F(Hz)')
ylim([0 650])
axis tight
%xlim(seconds([0.39 5]));
view(2)
%colormap pink

