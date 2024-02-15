[x, Fs] = audioread('/Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P6/PDS_P6_3B_LE2_G2.wav');
load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P6/PDS_P6_3B_LE2_G2.mat;

%%
%% DISEÑO DE UN FILTRO FIR

%% A

sound(x, Fs);


%% B 

% La fs del filtro será la misma que la de la señal para que las muestras
% coincidan en el tiempo y se pueda hacer un filtrado adecuado

%Calculo la TF de mi señal para ver donde filtrar

X = fft(x, length(x)) / length(x);
fx = linspace(-Fs/2, Fs/2, length(x));

plot(fx, fftshift(abs(X)));
title("Transoformada de Fourier de x")
ylabel("Amplitude (Unidades)")
xlabel("Frecuency (KHz)")


%Pretendo mantener un audio producido por voz humana
%La voz humana produce frecuencias de hasta 4KHz si lo que nos interesa es
%mantener una conversación (no música)
%Fc del filtro a 6KHz para dar algo de margen, el pitido está en ~10KHz


%% C

%fdatool
load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P6/Filtro.mat;


%% D

H = fft(h, 500) / 500;
fh = linspace(-Fs/2, Fs/2, length(H));

plot(fh, fftshift(abs(H)));
hold on;
%plot(fx, fftshift(abs(X)));
legend("Filtro H")
title("Espectro del filtro H")
ylabel("Amplitude")
xlabel("Frecuency")


%Se ve perfectamente cómo el armónico no deseado (10KHz) se encuentra en la
%banda de atenuación, mientras que la voz (hasta 3-4KHz) queda dentro


%%
%%
%% IMPLEMENTACIÓN DE UN FILTRO FIR UTILIZANDO DFT

[x, Fs] = audioread('/Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P6/PDS_P6_3B_LE2_G2.wav');
%x = x(1: 50000);

L = 500; %Longitud de segmento a filtrar
P = length(h); %P es la longitud del filtro
N = L - P + 1; %Longitud del segmento (inicial y final) sin la parte sobrante

%Meto los P-1 ceros de primeras
zx = [zeros(1,P-1) x'];

%Transformada del filtro (Matlab (fft) coge por defecto sólo 1 periodo)
H = fft(h, L);

%Creo mi salida del filtro
y = [];


for r = 1:floor(length(x)/(L-P+1))

    %Se extrae el subpaquete xr del vector, las P-1 primeras muestras sólo sirven para 'cargar el filtro'
    xr = zx(N*r-N+1:(N*r+P-1)); 

    %Calculo la DFT del subpaquete
    Xr = fft(xr, L);
    %Multiplico el subpaquete con el filtro en frecuencia, operación equivalente a la convolución en el tiempo
    Yr = Xr.*H;
    %Realizo la DFT inversa del subpaquete ya filtrado
    yr = ifft(Yr, L);

    %Anido el subpaquete ya filtrado a un vector en el que meto todos los subpaquetes a medida que se van filtrando
    y = [y yr(P: end)];

end

%DEBUG (esto dentro del bucle)
disp(i);
disp(N*i-N+1);
disp(N*i+P-1);
disp(" ");


Y = fft(y, length(y)) / length(y);
fy = linspace(-Fs/2, Fs/2, length(Y));

plot(fy, fftshift(abs(Y)));
hold on;
plot(fg, fftshift(abs(G)));


%%
sound(y, Fs);
%%
%% 
%% ANÁLISIS DE RESULTADOS
%% A

g = filter(h, 1, x);
g = g(1:length(y))'; 

%Le quito los últimos valores a g (despreciables) para q tenga la misma
%longitud que y, y la hago fila


%% B

%tx = linspace(0, (1/Fs)*length(x), length(x));
%plot(tx, x);

ty = linspace(0, (1/Fs)*length(y), length(y));
tg = linspace(0, (1/Fs)*length(g), length(g));

plot(ty, y, '*');
hold on;
plot(tg, g);
legend("y", "g")
title("Señales y, g")
ylabel("Amplitude (Unidades)")
xlabel("Time (s)")


%Se ve perfectamente que son idénticas


%% C

ECM = (1/length(g))*sum((g - y).^2)
% ~0, como era de esperar


%% D

G = fft(g, length(g)) / length(g);
fg = linspace(-Fs/2, Fs/2, length(G));

plot(fx, fftshift(abs(X)));
hold on;
plot(fg, fftshift(abs(G)));
plot(fy, fftshift(abs(Y)));
legend("xf", "gf", "yf")
title("Transoformada de Fourier de x, g, y")
ylabel("Amplitude (Unidades)")
xlabel("Frecuency (KHz)")







