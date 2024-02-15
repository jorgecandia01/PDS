load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P5/PDS_P5_3B_LE2_G2.mat

%% CUANTIFICACIÓN DE LOS COEFICIENTES DE UN FILTRO
%% A

%fdatool
load /Users/jorgecandia/UNIVERSIDAD/TERCERO/PDS/P5/Filter.mat

%% B

%q =quantizer('fixed' ,'round' ,'saturate' ,[B D]); %La escala de cuantificación
%y_b = num2bin(q, b); %Para cuantificar la señal, convierte b a la escala especificada en q (en binario)
%y_d = bin2num(q, b); %Pasa los valores binarios a decimal

%Creo el filtro X a partir de los coeficientes (la respuesta en frecuencia)
%H = freqz(NumX, DenX, 5000); %Realmente no me lo piden, tengo que cuantificar los coeficientes a y b!!

Q = quantizer('fixed' ,'round' ,'saturate' ,[16 8]); %Mi cuantificador
NumQ = bin2num(Q, num2bin(Q, NumX)); %Paso el filtro por el cuantificador y lo convierto a decimal
DenQ = bin2num(Q, num2bin(Q, DenX));

%figure;
%plot(NumX);
%hold on;
%plot(NumQ);
%legend('Numerador', 'Numerador Q');
%title('Numerador vs Numerador cuantificado');
%El resultado de cuantificar el numerador es un desastre, al ser todos números muy cercanos a cero, 
%la escala de cuantificación escogida no logra resaltar el detalle del numerador

disp(NumX);
disp(NumQ');
%Se puede ver perfectamente haciendo un print de los coeficientes sobre la 
%ventana de comandos cómo la mayoría de valoren convergen en cero


%figure;
%plot(DenX);
%hold on;
%plot(DenQ);
%legend('Denominador', 'Denominador Q');
%title('Denominador vs Denominador cuantificado');
%En el denominador esto no pasa, los valores de los coeficientes funcionan
%muy bien en la escala de cuantificación escogida

disp(DenX);
disp(DenQ');
%Se puede ver perfectamente haciendo un print de los coeficientes sobre la 
%ventana de comandos cómo todos los valores mantienen gran precisión


[FiltroX] = freqz(NumX, DenX, 50000);

fX = linspace(0, Fs/2, length(FiltroX))

plot(fX, 20*log10(abs(FiltroX)));
hold on;



[FiltroQ] = freqz(NumQ, DenQ, 50000);

fQ = linspace(0, Fs/2, length(FiltroQ));

plot(fQ, 20*log10(abs(FiltroQ)));
hold on;



%%

FiltroOriginal = freqz(NumX,DenX,50000);

foriginal = linspace(0,Fs/2,length(FiltroOriginal));

plot(foriginal, 20*log10(abs(FiltroOriginal)));


%% SECCIONES DE SEGUNDO ORDEN
%% A

[SOS, g] = tf2sos(NumX, DenX);
%SOS tiene 4 filas, son los polinimios que dan las 4 raices conjugadas (2 polinomios por fila, num y den)
%SOS tiene 6 columnas, las 3 primeras son el polinomio del Num y las 3 últimas el polinomio del Den

%% B

SOSQvector = bin2num(Q, num2bin(Q, SOS));

%Me da un vector, lo convierto a matriz
SOSQ = reshape(SOSQvector, [4,6]);

[FiltroSOSQ] = freqz(SOSQ, 50000);
fSOSQ = linspace(0, Fs/2, length(FiltroSOSQ))

plot(fSOSQ, 20*log10(abs(FiltroSOSQ)));
hold on;




 

%% RAÍCES EN SECCIONES DE SEGUNDO ORDEN
%% A

%Paso SOS a vector para hacer el bucle más fácil
SOSvector = reshape(SOS', [1,numel(SOS)]);

roots_SOS = []

for i = 1:(numel(SOS)/3)
    roots_SOS = [roots_SOS, roots(SOSvector((i*3)-2: i*3))']
end


roots_SOSQ = bin2num(Q, num2bin(Q, roots_SOS));


%Numerador
num = [roots_SOSQ(1:2); roots_SOSQ(5:6); roots_SOSQ(9:10); roots_SOSQ(13:14)]'
den = [roots_SOSQ(3:4); roots_SOSQ(7:8); roots_SOSQ(11:12); roots_SOSQ(15:16)]'

numPol = poly(num);
denPol = poly(den);

[FiltroRootsSOSQ] = freqz(numPol, denPol, 50000);

frootsSOSQ = linspace(0, Fs/2, length(FiltroRootsSOSQ))

plot(frootsSOSQ, 20*log10(abs(FiltroRootsSOSQ)));
hold on;



%% ROOTS SIN Q

roots_SOS = roots_SOS'

%Numerador
numA = [roots_SOS(1:2); roots_SOS(5:6); roots_SOS(9:10); roots_SOS(13:14)]'
denA = [roots_SOS(3:4); roots_SOS(7:8); roots_SOS(11:12); roots_SOS(15:16)]'

%numA = 
numPolA = poly(numA);
denPolA = poly(denA);

[FiltroRootsSOS] = freqz(numPolA, denPolA, 50000);

frootsSOS = linspace(0, Fs/2, length(FiltroRootsSOS))

plot(frootsSOS, 20*log10(abs(FiltroRootsSOS)));
hold on;

%CUIDADO! Cada 2 raices se alternan numerador y denominador (1era num)

%% B

%roots_SOSQ = bin2num(Q, num2bin(Q, roots_SOS));






%% ANÁLISIS GENERAL
%% A) MSEs

n = length(NumX);
polosOriginal = DenX;
cerosOriginal = NumX;

% Filtro cuantificado
% Polos
ECMpQ = abs((1/n)*sum((roots(polosOriginal)- roots(DenQ)).^2))

% Ceros
ECMcQ = abs((1/n)*sum((roots(cerosOriginal)- [roots(NumQ);0;0;0;0]).^2))


% Filtro SOS cuantificado
% Polos
ECMpSOSQ = abs((1/n)*sum((roots(polosOriginal)- roots(denPolA)).^2))

% Ceros
ECMcSOSQ = abs((1/n)*sum((roots(cerosOriginal)- roots(numPolA)).^2))


% Filtro SOS cuantificando las raíces
% Polos
ECMpRootsSOSQ = abs((1/n)*sum((roots(polosOriginal)- roots(denPol)).^2))

% Ceros
ECMcRootsSOSQ = abs((1/n)*sum((roots(cerosOriginal)- roots(numPol)).^2))

%% Display de los resultados

disp("Filtro con coeficientes originales cuantificados:")
disp(" - Error de polos: " + ECMpQ)
disp(" - Error de ceros: " + ECMcQ)
disp(" ")
disp("Filtro con coeficientes de la SOS cuantificados:")
disp(" - Error de polos: " + ECMpSOSQ)
disp(" - Error de ceros: " + ECMcSOSQ)
disp(" ")
disp("Filtro con las raíces de la SOS cuantificadas:")
disp(" ")
disp(" - Error de polos: " + ECMpRootsSOSQ)
disp(" - Error de ceros: " + ECMcRootsSOSQ)
disp(" ")
disp(" ")


%% B) COMPARACIÓN DE TODOS LOS FILTROS

figure;
plot(fX, 20*log10(abs(FiltroX)));
hold on;
plot(fX, 20*log10(abs(FiltroQ)));
plot(fX, 20*log10(g*abs(FiltroSOSQ)));
plot(fX, 20*log10(g*abs(FiltroRootsSOSQ)));
hold off;
legend('Filtro Original', 'FiltroQ', 'FiltroSOSQ', 'FiltroRootsQSOS');
title('Comparación de todos los filtros');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');




%% C

figure;
plot(fX, unwrap(angle(FiltroX)));
hold on;
plot(fX, unwrap(angle(FiltroQ)));
plot(fX, unwrap(angle(FiltroSOSQ)));
plot(fX, unwrap(angle(FiltroRootsSOSQ)));
hold off;
legend('Filtro Original', 'FiltroQ', 'FiltroSOSQ', 'FiltroRootsQSOS');
title('Comparación de todos los filtros (fase)');
xlabel('Fase (rad)');
ylabel('Magnitud (dB)');


%% D

figure
subplot(2,2,1)
zplane(roots(NumX),roots(DenX))
title('Filtro')
subplot(2,2,2)
zplane(roots(NumQ),roots(DenQ))
title('FiltroQ')
subplot(2,2,3)
zplane(roots(numPolA),roots(denPolA))
title('FiltroSOSQ')
subplot(2,2,4)
zplane(roots(numPol),roots(denPol))
title('FiltroRootsQSOS')
hold off
%Como todas las equis (polos) están dentro de la circunferencia
%quiere decir que es un sistema estable, si sale una solo
%ya se vuelve inestable

%c) Por cómo están configurados los polos y los ceros, polos -> frec. paso,
%ceros -> frec. anulada





