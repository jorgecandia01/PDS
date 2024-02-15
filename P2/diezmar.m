function [y, t] = diezmar(x, t, M)
    y = x(1:M:length(x)); %Me quedo con 1 de cada M valores
    t = t(1:M:length(t));
