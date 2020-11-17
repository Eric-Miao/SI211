# This is the code for finite differences
eps = 10^(-8.0)

function FiniteDiff(f,x)
    ret=[]
    yy=f(x)
    for i=1:length(yy)
        temp=[]
        for j=1:length(x)
            xx=copy(x)
            xx[j]=xx[j]+eps
            diff = (f(xx)[i]-yy[i])/eps
            append!(temp,diff)
        end
        append!(ret,[temp])
    end
    return ret
end