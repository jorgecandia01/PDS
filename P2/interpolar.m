function [y, t_interp] = interpolar(x, t, L)
    %T = (t(end)/(length(t)))/L;
    %t_interp = 0:T:t(end);
    t_interp = linspace(t(1), t(end), (length(t)*L) ); %Nuevo vector de tiempos de la señal interpolada
    y = interp1(t, x, t_interp,'spline');

   
