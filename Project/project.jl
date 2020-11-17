include("adf.jl")
include("adb.jl")
include("fd.jl")
include("f.jl")

function forwardloop(f,n)
    x=ones(n)
    ret=[]
    for i=1:n
        d=zeros(n)
        d[i]=1.0
        append!(ret,[f(x,d)])
    end
    return ret
end

function backwardloop(f,m,n)
    ret=[]
    x=ones(n)
    for i=1:m
        d=zeros(m)
        d[i]=1.0
        append!(ret,[f(x,d)])
    end
    return ret
end

adb=ADbackward(f)
adf=ADforward(f)

function time(n=2020)
    println("time of ADforward:")
    @time forwardloop(adf,n)
    println("time of ADbackward:")
    @time backwardloop(adb,2,n)
    println("time of FiniteDiff:")
    @time FiniteDiff(f,ones(n))
    return "The end of the performance test";
end

function answer(n=2020)
    ret_adf=forwardloop(adf,n)
    ret_adb=backwardloop(adb,2,n)
    ret_fd=FiniteDiff(f,ones(n))

    println("The result from ADforward:\n")
    for temp in ret_adf
        println(temp)
    end

    println("\nThe result from ADbackward:\n")
    for temp in ret_adb
        println(temp)
    end

    println("\nThe result from FiniteDiff:\n")
    for temp in ret_fd
        println(temp)
    end
    
end