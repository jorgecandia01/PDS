%%Cuantificación No Uniforme
%%a
function expan = expansor(A, x)

for i = 1:length(x)
    if abs(x(i))<1/(1+log(A))
        expan(i) = sign(x(i)).*abs(x(i))*(1+log(A))/A;
    else
        expan(i) = sign(x(i)).*exp(abs(x(i))*(1+log(A))-1)/A;
    end
end
end