%% 
%% 
%% EJERCICIO 1 - MUESTREO
%La se�al X esta muy muy muestreada, en vez de darnosla como analogica 
%nos la dan asi, y a partir de ahi nos piden cosas


%A)
Ts_x = t(2)-t(1)
Fx = 1/Ts_x/1000 %Lo paso de Hz a kHz

%% B

%plot(t,x)
Xf = fft(x,length(x))./length(x) %con el ./ normalizo la se�al (?, no es 1 el max)
F = linspace(-Fx/2,Fx/2,length(Xf)) %Length de Y!! no X!!! (realmente es lo mismo)
%plot(F,fftshift(abs(Xf))) 
B=24.1 %kHz
Fnyquist = B*2 %fs-min

%% C

Fg = 3/2*Fnyquist %fs-g = 73.3 kHz
Fh = 2/3*Fnyquist


Ts_g = 1/(1000*Fg)
Ts_h = 1/(1000*Fh)


%LA G
ts_g = 0:Ts_g:max(t)

Gt = interp1(t,x,ts_g,'spline')

%plot(ts_g,Gt) %g(t) en el tiempo

Gf = fft(Gt,length(Gt))./length(Gt)
fs_g = linspace(-Fg/2,Fg/2,length(Gf))

figure
plot(fs_g,fftshift(abs(Gf))) ;
figure
plot(fs_h,fftshift(abs(Hf)));

%LA H
ts_h = 0:Ts_h:max(t)

Ht = interp1(t,x,ts_h,'spline')

%plot(ts,Ht) %h(t) en el tiempo

Hf = fft(Ht,length(Ht))./length(Ht)
fs_h = linspace(-Fh/2,Fh/2,length(Hf))
fs_h_ampliado = linspace(-Fh,Fh,length(Hf)) %No sirve pq Hf no da suficientes muestras
%Matlab no deja (no se como) ver todo el espectro con las movidas solapandose
%plot(fs_h,fftshift(abs(Hf))); %Se ve como se solapan los armonicos de 24.1kHz (8kHz) y 19.7kHz (12.4kHz)

%% D

figure
%subplot(2,1,1)
plot(F,fftshift(abs(Xf)),'-*');
hold on
%subplot(2,1,2)
plot(fs_g,fftshift(abs(Gf)), 'r') ;
hold on
plot(fs_h,fftshift(abs(Hf)), 'g');

%Se plotean bien, pero al remuestrear no debería cambiar la amplitud?
%No debería cambiar la amplitud en las señales remuestreadas??? g3/2 y h2/3

%La energía de poca potencia es el ruido blanco gaussiano (?)


%% E

%x, Gt, Ht ;; t, ts_g, ts_h
figure
plot(t,x,'-x');
hold on
plot(ts_g,Gt, '-o') ;
hold on
plot(ts_h,Ht, '-*');
legend('x', 'g', 'h');
%Debería verse más g, luego x y luego h, por el nº de muestras, pero vamos
%que no entiendo ni guarra en ese churro, hago zoom y no lo parece




%% 
%% 
%% EJERCICIO 2 - CUANTIFICACION UNIFORME

%q =quantizer('fixed' ,'round' ,'saturate' ,[B D]); %La escala de cuantificación
%y_b = num2bin(q, b); %Para cuantificar la señal, convierte b a la escala especificada en q (en binario)
%y_d = bin2num(q, b); %Pasa los valores binarios a decimal


%a: 2^B (niveles totales, nº de escalones)
%b: de 1/(2^D) bits
%c: rango = (11,111 -- 01,111)
%d: 1/(2^D)/2, *Vmax??

%% E

B = 5
D = 3

niveles = 2^B; %(niveles totales, nº de escalones)
salto = 1/(2^D); 
nivel_max = 2^(B-1-D); %El primer bit es signo
nivel_min = -2^(B-1-D); %Falta la parte decimal, toda a uno, se sumaría 
%c: rango = (11,111 -- 01,111)
error_max = 1/(2^D)/2; % *Vmax?? %Precisión decimal, el primer escalón mide 1/2

%% F

q30 = quantizer('fixed' ,'round' ,'saturate' ,[4 0]);
q12 = quantizer('fixed' ,'round' ,'saturate' ,[4 2]);
q32 = quantizer('fixed' ,'round' ,'saturate' ,[6 2]);
q50 = quantizer('fixed' ,'round' ,'saturate' ,[6 0]);

k30 = bin2num(q30, num2bin(q30, k));
k12 = bin2num(q12, num2bin(q12, k));
k32 = bin2num(q32, num2bin(q32, k));
k50 = bin2num(q50, num2bin(q50, k));


%% G

%Plots en el tiempo
figure %Divido la representación en 2 para q se vea mejor
plot(t_k,k,'-o');
hold on;
plot(t_k,k30,'*');
hold on;
plot(t_k,k12,'s');
legend('k','k30','k12');

figure
plot(t_k,k,'-o');
hold on;
plot(t_k,k32,'.');
hold on;
plot(t_k,k50,'+');
hold on;
legend('k','k32','k50');

%% Plots en frecuencia

%Espectros de k, k30 y k12
K = fft(k);
K30 = fft(k30);
K12 = fft(k12);

%Vector de frecuencias, hallo f de muestreo de k
fm = 1/(t_k(2)-t_k(1))/1000; %Lo paso a kHz
F = linspace(-fm/2,fm/2,length(k)); %Misma F para todas las K

%Los plots
figure;
plot(F,fftshift(abs(K)),'-o');
hold on;
plot(F,fftshift(abs(K30)),'*');
hold on;
plot(F,fftshift(abs(K12)),'s'); 
legend('K','K30','K12');

%K12(s): Al cuantificar con tan pocos niveles, las amplitudes erroneamente iguales en el tiempo confunden 
%la periodicidad de la señal -> el espectro se ralla, tanto las frecuencias como sus amplitudes
%K30(*): Esta tiene mas niveles y se acerca mucho a la señal real k, pero no es exactamente igual


%% H

MSE_k30 = mean((k - k30).^2); %0.1153
MSE_k12 = mean((k - k12).^2); %enorme, 2.9667
MSE_k32 = mean((k - k32).^2); %El mejor, 0.0090
MSE_k50 = mean((k - k50).^2); %0.1153

%Pasar de 3 bits a 5 no mejora la cuantificación, añade niveles a los que no llega la amplitud de k,
%para mejorar hay que añadir parte decimal

%En k12 hay precisión decimal pero llega a muy poca amplitud, la mayor parte de la señal se cuantifica mal

%% A
[x_n, f] = audioread('PDS_P1_3A_LE1_G1.wav');
% sound(y_n, f);
max(x_n);
min(x_n);

y_n(find(abs(x_n)<0.01))=0;

q = quantizer('fixed', 'round', 'saturate', [7,6]);
q_u = num2bin(q, y_n);
q_u2 = bin2num(q, q_u);

err = immse(q_u2,y_n)

figure;
plot(q_u2);
xlabel('n');
ylabel('q_u[n]');
title('Audio cuantificado uniformemente');

%% 
%% 
%% EJERCICIO 3 - CUANTIFICACION NO UNIFORME

%%B
figure
plot((linspace(-1,1,100)));
hold on
plot(compresor(87.6,(linspace(-1,1,100))));
xlabel('n');
ylabel('se�ales');
title('Respuesta del compresor');

figure
plot((linspace(-1,1,100)));
hold on
plot(expansor(87.6,(linspace(-1,1,100))));
xlabel('n');
ylabel('se�ales');
title('Respuesta del expansor');
%% C
close all
clc

[x_n, f] = audioread('PDS_P1_3A_LE1_G1.wav');
y_n(find(abs(x_n)<0.01))=0;

q = quantizer('fixed', 'round', 'saturate', [7,5]);
y_c = compresor(87.6, y_n);
q_nu_c = num2bin(q, y_c);
q_nu_c2 = bin2num(q, q_nu_c);
q_nu_e = expansor(87.6, q_nu_c2);

figure
plot(q_nu_e);
xlabel('n');
ylabel('q_n_u[n]');
title('Audio cuantificado no uniformemente');
%% 
%% 
%% EJERCICIO 4 - ANALISIS DE RESULTADOS

%B
figure;
hold on
plot(q_u2,"-o");
plot(q_nu,"-*");
plot(x_n);
xlabel('n');
ylabel('se�ales');
ylim([-1 1]);


%%
%C
[x_n, f] = audioread('PDS_P1_3A_LE1_G1.wav');
N=length(x_n);

%Error cuadratico medio se�al original
ecm_x_n = 0;

for n = 1:N
    ecm_x_n = ecm_x_n + (x_n(n)-x_n(n))^2;
end
ecm_x_n/N

%Error cuadratico medio se�al qu[n] (cuanti uniform)
ecm_qu = 0;

for n = 1:N
    ecm_qu = ecm_qu + (y_n(n)-q_u2(n))^2;
end

ecm_qu/N

%Error cuadratico medio se�al qnu[n] (cuanti no uniform)
ecm_qnu = 0;

for n = 1:N
    ecm_qnu = ecm_qnu + (y_n(n)-q_nu(n))^2;
end

ecm_qnu/N








