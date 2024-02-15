function aclaracionPractica3PDS 

% Aclaración sobre amplitud de las transformadas de Fourier en prática 3

% Dividir por length(x) el resultado de la función fft(x)
% es algo que hacemos para normalizar la amplitud del espectro.  
% La justificación se basa en cómo implemente Matlab la función fft(x).

% Si utilizamos este procedimiento con una función seno de amplitud uno, 
% por ejemplo, cuyo espectro sabemos que serán dos deltas de amplitud 1/2:

 Fs=150;                                    % frecuencia de muestreo [Hz]
 t=0:1/Fs:1;                                % vector de tiempos [s]
 f=5;                                       % frecuencia seno [Hz]
 
 x=sin(2*pi*t*f);                           % señal, x(t)
 
 X = fft(x, length(x)) ./ length(x);        % TdF señal x(t), X(f)  
 f = linspace(-Fs/2, Fs/2, length(X));      % vector de frecuencias [Hz]
 f = f';
 
 figure(1);                                 % representación x(t)           
 plot(t,x)
 title('Señal x(t)');
 xlabel('Tiempo [s]');
 ylabel('Amplitud [V]');
 
 figure(2)                                  % representación X(f), TdF{x(t)}
 plot(f, fftshift(abs(X)));             
 title('TdF de x(t)');
 xlabel('Frecuencia [Hz]');
 ylabel('|X(f)|');
 
% Vemos claramente como aparecen tonos a -5 Hz y 5 Hz (frecuencia del seno)
% con amplitud 1/2. Hemos representado correctamente la TdF de una función
% seno continua.

% En el contexto de la práctica 3, trabajamos con señales discretas.
% Por lo tanto, tendremos que multiplicar la amplitud por Fs (tal y como
% vimo en teoría, debido al proceso de muestreo). Si no hacemos esto vamos 
% a tener problemas a la hora de interpretar correctamente los procesos de
% diezmado e interpolación.

 Xn = Fs*fft(x, length(x)) ./ length(x);    % TdF señal x[n], Xn(f) 

 figure(3)                                  % representación Xn(f), TdF{x[n]}
 plot(f, fftshift(abs(Xn)));             
 title('TdF de x[n]');
 xlabel('Frecuencia [Hz]');
 ylabel('|Xn(f)|');
 
 % Vemos como en este caso la amplitud de los tonos es Fs/2=75.