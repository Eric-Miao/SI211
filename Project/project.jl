include("adf.jl")
include("adb.jl")
include("fd.jl")
include("f.jl")

function forwardloop(f,n)
    x=ones(n)
    for i=1:n
        d=zeros(n)
        d[i]=1.0
        #println(f(x,d))
    end
end

function backwardloop(f,m,n)
    x=ones(n)
    for i=1:m
        d=zeros(m)
        d[i]=1.0
        #rintln(f(x,d))
    end
end

adb=ADbackward(f,2020)
adf=ADforward(f)

@time forwardloop(adf,2020)
@time backwardloop(adb,2,2020)
@time FiniteDiff(f,ones(2020))
