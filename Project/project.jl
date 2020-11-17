include("adf.jl")
include("new_adb.jl")
include("fd.jl")
include("f.jl")

function forwardloop(f,n)
    x=ones(n)
    ret=[]
    for i=1:n
        d=zeros(n)
        d[i]=1.0
        append!(ret,f(x,d))
    end
end

function backwardloop(f,m,n)
    ret=[]
    x=ones(n)
    for i=1:m
        d=zeros(m)
        d[i]=1.0
        append!(ret,f(x,d))
    end
end

adb=ADbackward(f)
adf=ADforward(f)

function time(n)
    @time forwardloop(adf,n)
    @time backwardloop(adb,2,n)
    @time FiniteDiff(f,ones(n))
end

function value(n)
    forwardloop(adf,n)
    backwardloop(adb,2,n)
    FiniteDiff(f,ones(n))
end

time(2020)