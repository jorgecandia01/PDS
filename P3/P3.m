load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P3/PDS_P3_3B_LE2_G2.mat

%% FILTRADO DE SEÑALES
%% A
fs = 1/(t(2)-t(1))
%BW = bandwidth(x) %?

%B = fft(b,length(b))./length(b)
%F = linspace(-fs/2, fs/2, length(b))
%plot(F, fftshift(abs(B)))

%% B

M=length(b) %En el enunciado el orden M es 100
x_n = x;
y = zeros(length(x_n),1)';

for n = 1:length(x_n)
    for k = 1:(M)
        if (n-k+1 > 0)
            y(n) = y(n) + b(k)*x_n(n-k+1);            
        end
    end
end

y=y';


%% C
g = conv(b, x);
g = g(1:(end-100));


%% D
h = filter(b, 1, x)

%% E

%Representar y, h, g en la misma gráfica es un caos -> se demuestra que son
%la misma señal y represento solo una junto a x
for i=1:length(g)
    gi = floor(g(i)*10000)/10000; %Trunco con 4 decimales 
    hi = floor(h(i)*10000)/10000;
    yi = floor(y(i)*10000)/10000;
    iguales(i) = (isequal(yi,hi,gi));
end

disp(sum(iguales) == length(g)) %Efectivamente son exactamente la misma señal, 
% g, h e y son exactamente los mismos vectores y por tanto se puede 
% prescindir de representarlos a todos a la vez

hold off;
plot(t, x, "-o");
hold on;
plot(t, g, "-+");

title("Señales x, g");
legend("x", "g");
ylabel("Amplitude");
xlabel("Time");
hold off;

%% F
tfin= t(end)
df = 1/tfin
f = (-fs-df)/2:df:(fs-df)/2
f = f'

xf = fft(x, length(x)) / length(x)
gf = fft(g, length(g)) / length(g)

plot(f, fftshift(abs(xf)), "-o")
hold on
plot(f, fftshift(abs(gf)), "-+")

legend("xf", "gf")
title("Transoformada de Fourier de x, g")
ylabel("Amplitude")
xlabel("Frecuency")
hold off





%%
%% 
%% DISEÑO DE FILTROS FIR

%% FILTRO PASO BAJO

%fdatool
%fs=188000, fcl=52000

load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P3/LPF.mat

%Plot del FPB en el tiempo
%plot(LPFb)

%Plot del FPB en frecuencia comparado con el filtro proporcionado
%Tienen el mismo orden
figure;
flpf = linspace(-fs/2, fs/2, length(LPFb)); 
plot(flpf, fftshift(abs(fft(b,length(b))./length(b))));
hold on;
plot(flpf, fftshift(abs(fft(LPFb,length(LPFb))./length(LPFb))));
legend('b', 'FPB');
%Se puede ver como coinciden en la banda de paso máxima (~50kHz)


%Señal X tras en filtro paso bajo
x_l = filter(LPFb, 1, x);
X_l = fft(x_l, length(x_l))./length(x_l);
fl = linspace(-fs/2, fs/2, length(X_l));

figure;
plot(f, fftshift(abs(xf)), "-o");
hold on;
plot(fl, fftshift(abs(X_l)), "-+");
legend("X", "Xlpf");
hold off;


%% FILTRO PASO ALTO

%fdatool
%fs=188000, fh=18000

load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P3/HPF.mat

%Plot del FPB en el tiempo
%plot(LPFb)

%Plot del HPB en frecuencia comparado con el filtro proporcionado
%Tienen el mismo orden
figure;
fhpf = linspace(-fs/2, fs/2, length(HPFb));
plot(flpf, fftshift(abs(fft(b,length(b))./length(b))));
hold on;
plot(fhpf, fftshift(abs(fft(HPFb, length(HPFb))./length(HPFb))));
legend('b', 'FPA');
%Se puede ver como coinciden en la banda de paso mínima (~19kHz)


%Señal X tras en filtro paso alto
x_h = filter(HPFb, 1, x);
X_h = fft(x_h, length(x_h))./length(x_h);
fh = linspace(-fs/2, fs/2, length(X_h));

figure;
plot(f, fftshift(abs(xf)), "-o");
hold on;
plot(fh, fftshift(abs(X_h)), '-+');
legend("X", "Xhpf");
hold off;




%% 
%% 
%% ANÁLISIS DE FILTROS
%% SUPERPOSICIÓN

%A
y = filter(LPFb, 1, x);

%B
g = filter(HPFb, 1, y);

%C
%fdatool
load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P3/BPF.mat

%D
h = filter(BPFb, 1, x);

%E Espectros de X, G, H
X = fft(x, length(x))./length(x);
G = fft(g, length(g))./length(g);
H = fft(h, length(h))./length(h);

f = linspace(-fs/2, fs/2, length(X));

plot(f, fftshift(abs(X)), '-o');
hold on;
plot(f, fftshift(abs(G)), '-+');
hold on;
plot(f, fftshift(abs(H)), '-*');
legend('X','G','H');


%% ORDEN DEL FILTRO

%A
%fdatool
load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P3/LP10.mat
load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P3/LP20.mat
load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P3/LP50.mat

%B
[h10, w10] = freqz(LP10, 1, length(LP10)*1000);
[h20, w20] = freqz(LP20, 1, length(LP20)*1000);
[h50, w50] = freqz(LP50, 1, length(LP50)*1000);
[h100, w100] = freqz(LPFb, 1, length(LPFb)*1000);
[b100, wb100] = freqz(BPFb, 1, length(BPFb)*1000); %curioseo con el paso banda

plot(w10/pi, abs(h10));
hold on;
plot(w20/pi, abs(h20));
hold on;
plot(w50/pi, abs(h50));
hold on;
plot(w100/pi, abs(h100));
hold on;
plot(wb100/pi, abs(b100));
legend('LP10', 'LP20', 'LP50', 'LP100', 'BPFb');

disp('Retardo introducido por LP10: ')
disp((1/fs)*length(LP10));
disp('Retardo introducido por LP20: ')
disp((1/fs)*length(LP20));
disp('Retardo introducido por LP50: ')
disp((1/fs)*length(LP50));
disp('Retardo introducido por LPFb: ')
disp((1/fs)*length(LPFb));


%% Pruebas con otro eje

figure;
flpf = linspace(-fs/2, fs/2, length(LPFb)); 
flpf10 = linspace(-fs/2, fs/2, length(LP10)); 
flpf20 = linspace(-fs/2, fs/2, length(LP20)); 
flpf50 = linspace(-fs/2, fs/2, length(LP50)); 

plot(flpf, fftshift(abs(fft(b,length(b))./length(b))));
hold on;
plot(flpf, fftshift(abs(fft(LPFb,length(LPFb))./length(LPFb))));
hold on;
plot(flpf10, fftshift(abs(fft(LP10,length(LP10))./length(LP10))));
hold on;
plot(flpf20, fftshift(abs(fft(LP20,length(LP20))./length(LP20))));
hold on;
plot(flpf50, fftshift(abs(fft(LP50,length(LP50))./length(LP50))));

legend('b', 'FPB', '10', '20','50');


























