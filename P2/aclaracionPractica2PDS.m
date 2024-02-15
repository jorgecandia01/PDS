function aclaracionPractica3PDS 

% Aclaraci�n sobre amplitud de las transformadas de Fourier en pr�tica 3

% Dividir por length(x) el resultado de la funci�n fft(x)
% es algo que hacemos para normalizar la amplitud del espectro.  
% La justificaci�n se basa en c�mo implemente Matlab la funci�n fft(x).

% Si utilizamos este procedimiento con una funci�n seno de amplitud uno, 
% por ejemplo, cuyo espectro sabemos que ser�n dos deltas de amplitud 1/2:

 Fs=150;                                    % frecuencia de muestreo [Hz]
 t=0:1/Fs:1;                                % vector de tiempos [s]
 f=5;                                       % frecuencia seno [Hz]
 
 x=sin(2*pi*t*f);                           % se�al, x(t)
 
 X = fft(x, length(x)) ./ length(x);        % TdF se�al x(t), X(f)  
 f = linspace(-Fs/2, Fs/2, length(X));      % vector de frecuencias [Hz]
 f = f';
 
 figure(1);                                 % representaci�n x(t)           
 plot(t,x)
 title('Se�al x(t)');
 xlabel('Tiempo [s]');
 ylabel('Amplitud [V]');
 
 figure(2)                                  % representaci�n X(f), TdF{x(t)}
 plot(f, fftshift(abs(X)));             
 title('TdF de x(t)');
 xlabel('Frecuencia [Hz]');
 ylabel('|X(f)|');
 
% Vemos claramente como aparecen tonos a -5 Hz y 5 Hz (frecuencia del seno)
% con amplitud 1/2. Hemos representado correctamente la TdF de una funci�n
% seno continua.

% En el contexto de la pr�ctica 3, trabajamos con se�ales discretas.
% Por lo tanto, tendremos que multiplicar la amplitud por Fs (tal y como
% vimo en teor�a, debido al proceso de muestreo). Si no hacemos esto vamos 
% a tener problemas a la hora de interpretar correctamente los procesos de
% diezmado e interpolaci�n.

 Xn = Fs*fft(x, length(x)) ./ length(x);    % TdF se�al x[n], Xn(f) 

 figure(3)                                  % representaci�n Xn(f), TdF{x[n]}
 plot(f, fftshift(abs(Xn)));             
 title('TdF de x[n]');
 xlabel('Frecuencia [Hz]');
 ylabel('|Xn(f)|');
 
 % Vemos como en este caso la amplitud de los tonos es Fs/2=75.