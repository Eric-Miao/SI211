
#Using quadgk package to to integration.

using Plots
using QuadGK
using Printf
function L(i,n)
    function g(t)
        ret = 1.0
        for j=0:n
            if j == i
                continue
            end
            ret = ret*(t-j)/(i-j)
        end
        return ret
    end
    return g
end

function alpha(i,n)
    l=L(i,n)
    return quadgk(l,0,n)[1]
end

function int_app(f,a,b,n,closed)
    if closed == 1
        H=(b-a)/n
    else
        H=(b-a)/(n+2)
    end

    sum=0.0
    for i=0:n 
        x_i=a+i*H
        if closed == 0
            x_i += H
        end
        sum += H*alpha(i,n)*f(x_i)
    end
    return sum
end

f(x)=sin(x)
a=0
b=pi/4
ans = 1 - 1/sqrt(2)
closed_3 = int_app(f,a,b,3,1)
err1 = ans-closed_3
closed_5 = int_app(f,a,b,5,1)
err2 = ans-closed_5
open_3 = int_app(f,a,b,3,0)
err3 = ans-open_3
open_5 = int_app(f,a,b,5,0)
err4 = ans-open_5

Printf.@printf("the approximation of closed formula with n=3 is %.6f, the err is %.6f\n",closed_3,err1)
Printf.@printf("the approximation of closed formula with n=5 is %.6f, the err is %.6f\n",closed_5,err2)
Printf.@printf("the approximation of open formula with n=3 is %.6f, the err is %.6f\n",open_3,err3)
Printf.@printf("the approximation of open formula with n=5 is %.6f, the err is %.6f\n",open_5,err4)


