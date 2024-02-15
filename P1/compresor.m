%%Cuantificación No Uniforme
%%a
function comp = compresor(A, x)

for i = 1:length(x)
    if abs(x(i))<1/A
        comp(i) = sign(x(i))*A.*abs(x(i))/(1+log(A));
    else
        comp(i) = sign(x(i)).*(1+log(A*abs(x(i))))/(1+log(A));
    end
end
end
