%% Transformada de Gabor
%ESCUELA POLITECNICA NACIONAL
%MAIN PRINCIPAL
 
clc, 
close all, 
clear all,
 
%% 1. Recepción de datos (frecuencia, amplitudes y duraciones) de todas las componentes:
% Los datos siguientes solo deben ser remplazados según se desee introducir problemas de:
% - Resolución en frecuencia: tonos muy juntos
% - Detección: componentes muy pequeñas relativas a la mayor de 1.
 
% %1.1 Frecuencias de las componentes (ordenadas de menor a mayor):
% Prueba 1
f1=1000; f2=2000; f3=3000; f4=3500; f5=4000;

% Prueba 2
%f1=10; f2=30; f3=60; f4=80; f5=90; 

%% DESCOMENTAR PARA HACER USO DE LA PRUEBA 1
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
% Primeramente se generan cada una de las componentes en todo el intervalo (8 segundos):
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
 
% Presentación de las componentes en forma ascendente tal como es el
% diagrama TF ideal:
figure

subplot(6,1,1);plot(t,comp5);xlim([0 5]);title('componente 5'); xlabel('t(s)');grid on;
subplot(6,1,2);plot(t,comp4);xlim([0 5]);title('componente 4'); xlabel('t(s)');grid on;
subplot(6,1,3);plot(t,comp3);xlim([0 5]);title('componente 3'); xlabel('t(s)');grid on;
subplot(6,1,4);plot(t,comp2);xlim([0 5]);title('componente 2'); xlabel('t(s)');grid on;
subplot(6,1,5);plot(t,comp1);xlim([0 5]);title('componente 1'); xlabel('t(s)');grid on;
 
% Una vez generadas las componentes, las sumamos para obtener la señal compuesta:
yt1 = comp1+comp2+comp3+comp4+comp5;
subplot(6,1,6);plot(t,yt1,'r');title('Señal compuesta'); xlabel('t(s)');grid on;
sgtitle('Componentes individuales y señal compuesta')
xlim([0 5])
% Visualización del TF ideal en conjunto con la señal compuesta obtenida de
% manera que se vea la existencia de una o varias componentes según los intervalos  
figure
hold on
grid minor
plot (t1,[f1 f1],'linewidth',1.5)
plot (t2,[f2 f2],'linewidth',1.5)
plot (t3,[f3 f3],'linewidth',1.5)
plot (t4,[f4 f4],'linewidth',1.5)
plot (t5,[f5 f5],'linewidth',1.5)
hold off
title('DIAGRAMA TIEMPO-FRECUENCIA IDEAL')
xlabel('t(sec)')
ylabel('F(Hz)')
xlim([0 5])
ylim([0 4000])
legend(['a1 = ' num2str(a1)],['a2 = ' num2str(a2)],['a3 = ' num2str(a3)],['a4 = ' num2str(a4)],['a5 = ' num2str(a5)])
 
%% Espectrograma haciendo uso de DGTtool que utiliza la transformada discreta de Gabor
tic 
tic
xn = yt1;
inputSignal = yt1'; %señal de entrada 
 
% Se crea el objeto DGTtool
% Algunas de las opciones se pueden omitir (se utilizarán los valores predeterminados).
% El orden de las opciones no está restringido (cualquier orden es aceptable).
% La lista de ventanas disponibles se puede obtener mediante DGTtool.windowList.
% El nombre de la ventana se puede acortar (por ejemplo, 'b' es aceptable en lugar de 'Blackman').f
% Si la versión de MATLAB es 2021a o posterior, se puede utilizar la siguiente sintaxis.
% F = DGTtool(windowShift=20,windowLength=250,FFTnum=400,windowName='Blackman')
%F = DGTtool('windowShift',5,'windowLength',250,'FFTnum',256,'windowName','Blackman')
%F = DGTtool('windowShift',20,'windowLength',250,'windowName','Blackman')
F = DGTtool('windowShift',256,'windowLength',2048,'FFTnum',2048,'windowName','Gauss');

% F = DGTtool('windowShift',100,'windowLength',1000,'FFTnum',nFFT_ventana_RT,'windowName','Gauss')
% Se calcula el espectrograma
% La señal de entrada debe ser un vector de columna.
X = F(inputSignal); %Se calacula el espectrograma de la señal de entrada
x = F.pinv(X);% convierte el espectrograma de nuevo en señal
toc
% Trazar el espectrograma
% Gráfica del espectrograma. La frecuencia de muestreo se puede omitir: F.plot(x).
% Nota: Las funciones de trazado se pueden usar directamente después de definir F.
F.plot(x,Fs); %Graficacion del espectrograma
sgtitle('Transformada de Gabor ventana de Gauss');
toc