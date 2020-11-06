using Plots
using QuadGK

f(x)=exp(x)
#This is integrated by hand
int=-1 + exp(4)
a=0
b=4
N=range(1,100,step=1)

function simpson(f,a,b)
    h=(b-a)/2
    return h/3*(f(a)+4*f((a+b)/2)+f(b))
end

function sum(f,N)
    sum=0.0
    for i=0:N-1
        sum += simpson(f,4*i/N,4*(i+1)/N)
    end
    return sum
end

error=[]
for n in N
    err=int-sum(f,n)
    append!(error,err)
end

plot(N,error,label="error based on N")


