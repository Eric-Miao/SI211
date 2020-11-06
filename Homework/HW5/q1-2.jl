using Plots
using QuadGK

f(x)=exp(x)
#This is integrated by hand

#The Upper bound of err is defined by the equation below, 
#Here, we directly let f=exp(x)
function err(f,a,b)
    return exp(b)/factorial(4) * (b-a)^5/120
end

#We still take N from 1 to 100
f(x)=exp(x)
N=range(1,100,step=1)
error=[]

for n in N 
    sum_err = 0
    #for each n we take, sum all the upper bound err of
    #small intervals we generated depending on n
    for i=0:n 
        sum_err+=err(f,4*i/n,4*(i+1)/n)
    end
    append!(error,sum_err)
end

plot(N,error,label="error based on N")