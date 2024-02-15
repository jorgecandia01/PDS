%% A
[x_n, fs1] = audioread('/Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P2/PDS_P2_3A_LE1_G1.wav');
%sound(x_n, fs1);
%fs1 = 96kHz


%% B 

ts1=1/fs1;
t=0:ts1:(length(x_n)-1)*ts1; %de 0 a el final (length) en intervalos de ts
plot(t,x_n,'-+')
%podrías hacer un plot(x_n) pq son muestras y sale para cada valor de x_n,
%su valor del índice n en el eje de abscisas, pero al hacerlo con t, vemos
%la señal en el dominio del tiempo y no de muestras

%% C 

ind1 = find(abs(x_n)>0.01,1,"first");
ind2 = find(abs(x_n)>0.01,1,"last");

y_n = x_n(ind1:ind2);
ty = 0:ts1:(length(y_n)-1)*ts1;
%plot(ty,y_n);
%sound(y_n,fs1)

%Nos hemos cargado los instantes del principio y del final del audio sin
%voz sabiendo que las amplitudes de las muestras ahí son despreciables, le
%pedimos a matlab que nos coja el primer y el último instante de amplitud no
%despreciable 


%% E 

[gn, t_gn] = diezmar(y_n, ty, 2); %Me quedo con 1 de cada M valores

%plot(t_gn,gn);

%% F
g_ts = t_gn(2)-t_gn(1);
fs2 = 1/g_ts; %Nueva fmuestreo de x_n -> 48kHz (fs1/M = x_fs/M)

%% G
figure
plot(ty,y_n,'-o');
hold on;
plot(t_gn,gn,'-*');
legend('y(t)', 'g(t)');
%Se ve como el asterico aparece en uno de cada dos círculos


%% H
Yn = fft(y_n,length(y_n)) ./ length(y_n);
f_yn = linspace(-fs1/2, fs1/2, length(Yn));
Gn = fft(gn,length(gn)) ./ length(gn);
f_gn = linspace(-fs2/2,fs2/2,length(Gn)); %CUIDADO! fs2!! si pongo fs1 me ensancha la señal!!

figure
plot(f_yn,fftshift(abs(Yn)),'-o');
hold on
plot(f_gn,fftshift(abs(Gn)),'-*'); 
legend('Y','G');
%Al estar en frecuencia analógica, los espectros son los mismos (el centrado en el cero)


%% H Sin el ./length() en las amplitudes
Gn = fft(gn);
f_gn = linspace(-fs2/2,fs2/2,length(Gn)); 
Yn = fft(y_n);
f_yn = linspace(-fs1/2, fs1/2, length(Yn));

figure
plot(f_yn,fftshift(abs(Yn)),'-o');
hold on
plot(f_gn,fftshift(abs(Gn)),'-*'); 
legend('Y','G');

%Se puede ver perfectamente la amplitud dividida por M



%% H En frecuencia digital

fdy = linspace(-1/2, 1/2, length(y_n));
fdg = linspace(-1/2, 1/2, length(gn));

%Con los mismos límites de linspace pero la length de cada señal, la señal
%diezmada se ensancha por un factor de M al estar en frecuencia digital

figure
plot(fdy,fftshift(abs(Yn)),'-o');
hold on
plot(fdg,fftshift(abs(Gn)),'-*'); 
legend('Y','G');


%% I

%Si existiese energía entre fs1 y fs2, es decir, entre 96kHz y 48kHz, al
%diezmar la señal y[n] por un factor de 2, la nueva frecuencia de muestreo
%es 48kHz (fs2), por lo que todo el espectro por encima de esa frecuencia se
%solaparía con los clones de Y[n] en múltiplos de la nueva frecuencia de
%muestreo fs2, fenómeno conocido como aliasing




%% 
%% 
%% EJERCICIO 2

%B

[h_n, t_h] = interpolar(y_n, ty, 2);

plot(ty, y_n, '-+');
hold on
plot(t_h, h_n, '-o');
legend('y(t)', 'h(t)');
hold off;


%% C

fs3 = 1/(t_h(2)-t_h(1));
disp(fs3/1000)


%% D

%Primero miro el BW de de h_n y lo comparo con y_n

Hn = fft(h_n, length(h_n))./length(h_n);
f_hn = linspace(-fs3/2, fs3/2, length(Hn));


figure;
plot(f_yn, fftshift(abs(Yn)), '-+');
hold on;
plot(f_hn, fftshift(abs(Hn)), '-o');
legend('Y', 'H');

%Las señales se solapan (las amplitudes aprox, y sólo la réplica centrada 
%en 0 por cosas de matlab), BW=15kHz

k_n = Filtro(h_n, fs3, 1, 15000);


%% E

%La ganancia del filtro en la banda de paso debe ser de 1V/V para que se
%mantenga igual que a la entrada


%% F

%fc = BW(Hn) = 15kHz


%% G

%En vez de usar eje temporal uso eje de muestras para saber cuantas quitar
figure;
plot(1:length(h_n), h_n, '-o');
hold on;
plot(1:length(k_n), k_n, '-+');
legend('h(t)', 'k(t)');
hold off;
%k retrasada 73 muestras


%% Desplazo la k

k_n_desp = k_n(74:end);
k_n_desp = [k_n_desp zeros(1,73)];

figure;
plot(1:length(h_n), h_n, '-o');
hold on;
plot(1:length(k_n_desp), k_n_desp, '-+');
legend('h(t)', 'k(t)');
hold off;

%Se ven las dos señales en fase, pero k tiene un poco menos de amplitud
%debido a su paso por el filtro

%% H

Kn = fft(k_n_desp, length(k_n_desp))./length(k_n_desp);
f_kn = linspace(-fs3/2, fs3/2, length(k_n_desp)); 
%k_n viene de filtrar h_n, por lo que su frecuencia de muestreo sigue siendo fs3

figure;
plot(f_yn, fftshift(abs(Yn)), '-+');
hold on;
plot(f_kn, fftshift(abs(Kn)), '-o');
legend('Y', 'K');

%A partir de 15kHz empieza a desaparecer la señal. Se parece mucho a Yn/Hn
%ya que realmente hemos filtrado sobre el ancho de banda

%sound(k_n_desp, fs3) %Suena igual


%% I

%No sé



%% 
%% 
%%  EJERCICIO 3

% A

% 128 = L/M * 96 , L/M = 4/3
% L = 4
% M = 3

%% B

[h_n, t_h] = interpolar(y_n, ty, 4);


%% C

fsh = 1/(t_h(2)-t_h(1));


%% D


%Primero miro el BW de de h_n y lo comparo con y_n

Yn = fft(y_n, length(y_n))./length(y_n);
f_yn = linspace(-fs1/2, fs1/2, length(Yn));
Hn = fft(h_n, length(h_n))./length(h_n);
f_hn = linspace(-fsh/2, fsh/2, length(Hn));


figure;
plot(f_yn, fftshift(abs(Yn)), '-+');
hold on;
plot(f_hn, fftshift(abs(Hn)), '-o');
legend('Y', 'H');

%Las señales se solapan (las amplitudes aprox, y sólo la réplica centrada 
%en 0 por cosas de matlab), BW=15kHz

k_n = Filtro(h_n, fsh, 1, 15000); %Su vector de tiempos y fs siguen siendo los de h!!!


%%
%En vez de usar eje temporal uso eje de muestras para saber cuantas quitar
figure;
plot(1:length(h_n), h_n, '-o');
hold on;
plot(1:length(k_n), k_n, '-+');
legend('h(t)', 'k(t)');
hold off;

[max1,pos1] = max(h_n);
[max2,pos2] = max(k_n);

%k retrasada 150 muestras, realmente hay varios retrasos según donde mires


%% Desplazo la k

k_n_desp = k_n(151:end);
k_n_desp = [k_n_desp zeros(1,150)];

figure;
plot(1:length(h_n), h_n, '-o');
hold on;
plot(1:length(k_n_desp), k_n_desp, '-+');
legend('h(t)', 'k(t)');
hold off;

%Se ven las dos señales en fase, pero k tiene un poco menos de amplitud
%debido a su paso por el filtro


%% F

[g_n, t_g] = diezmar(k_n_desp, t_h, 3);


%% G

figure
plot(ty, y_n, '-o');
hold on;
plot(t_g, g_n, '-+');
legend('y', 'g');

%Hay 1.25 muestras en g por cada una de y


%% H
Gn = fft(g_n, length(g_n)) ./ length(g_n);
f_gn = linspace(-fs1*4/3/2, fs1*4/3/2, length(Gn));


figure
plot(f_yn, fftshift(abs(Yn)), '-+');
hold on;
plot(f_gn, fftshift(abs(Gn)), '-o');
legend('Y', 'G');

%Como era de esperar, las señales se solapan. Como matlab solo muestra la
%réplica centrada en cero, no se puede decir mucho más.
%A partir de los 15kHz, se puede ver un poco como G se reduce a cero de
%forma más bruca que Y.













