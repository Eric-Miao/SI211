# Reimplement Boris's Backward function, hope this works
import Base.+, Base.*, Base.-, Base./, Base.sin, Base.cos

NOP = 0;    # Number of operations
FS = [];    # Forward Sweep
BS = [];    # Backward Sweep

mutable struct ADN
    id::Int16;
    op;
    a::Int16;
    b::Int16;
    val::Float64;
end

# mark the operators representations below
# 0 = +
# 1 = -
# 2 = *
# 3 = /
# 4 = sin
# 5 = cos


# Reload
# ADN op. ADN
function +(a::ADN, b::ADN)
    global NOP
    global FS
    global BS
    i = a.id;
    j = b.id;
    NOP = NOP + 1;
    value = a.val + b.val;
    op = 0;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end

function -(a::ADN, b::ADN)
    global NOP
    global FS
    global BS
    i = a.id;
    j = b.id;
    NOP = NOP + 1;
    value = a.val - b.val;
    op = 1;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end

function *(a::ADN, b::ADN)
    global NOP
    global FS
    global BS
    i = a.id;
    j = b.id;
    NOP = NOP + 1;
    value = a.val + b.val;
    op = 2;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end

function /(a::ADN, b::ADN)
    global NOP
    global FS
    global BS
    i = a.id;
    j = b.id;
    NOP = NOP + 1;
    value = a.val / b.val;
    op = 3;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end


function sin(a::ADN)
    global NOP
    global FS
    global BS
    i = a.id;
    j = -1
    NOP = NOP + 1;
    value = sin(a.val);
    op = 4;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end


function cos(a::ADN)
    global NOP
    global FS
    global BS
    i = a.id;
    j = -1;
    NOP = NOP + 1;
    value = cos(a.val);
    op = 5;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end


# Float64 op. ADN
function +(a::Float64, b::ADN)
    global NOP
    global FS
    global BS
    i = b.id;
    j = -1
    NOP = NOP + 1;
    value = a+b.val;
    op = 0;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end

function +(a::ADN, b::Float64)
    return b+a;
end

function -(a::Float64, b::ADN)
    return (-a)+b;
end

function -(a::ADN, b::Float64)
    return a+(-b);
end

function /(a::Float64, b::ADN)
    global NOP
    global FS
    global BS
    j = b.id;
    i = -1
    NOP = NOP + 1;
    value = a/b.val;
    op = 3;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end

function /(a::ADN, b::Float64)
    global NOP
    global FS
    global BS
    i = a.id;
    j = -1
    NOP = NOP + 1;
    value = a.val/b;
    op = 3;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end

function *(a::Float64, b::ADN)
    global NOP
    global FS
    global BS
    i = b.id;
    j = -1
    NOP = NOP + 1;
    value = a*b.val;
    op = 2;
    new=ADN(NOP,op,i,j,value)
    push!(FS,new);
    push!(BS,0);
    return new;
end

function *(a::ADN, b::Float64)
    return b*a;
end

function ADbackward(f)
    function g(x,d)
        global FS=[]
        global BS=[]
        global NOP=0
        xx=[]
        n = length(x);
        j = -1;
        i = -1;
        op = -1;
        #println(BS)
        #println(FS)
        for i = 1:n
            NOP = NOP+1;
            new = ADN(NOP,op,i,j,x[i])
            push!(FS,new);
            push!(BS,0)
            push!(xx,new)
        end
        y=f(xx)
        #println(y)
        m=length(y)
        #println(m)
        #println(FS)
        #println(BS)
        for i=1:m
            #println(y[i].id)
            BS[y[i].id]=d[i]
        end
        #println(BS)
        #println(NOP)
        for j = 1:NOP
            i = NOP+1-j
            temp=FS[i]
            op=temp.op
            #print(op)
            # +
            if op == 0
                #println(BS[temp.a],BS[temp.id])
                BS[temp.a]+=BS[temp.id]
                if temp.b != -1
                    BS[temp.b]+=BS[temp.id]
                end
            # -
            elseif op == 1
                BS[temp.a]+=BS[temp.id]
                BS[temp.b]+=(-1)*BS[temp.id]
            # *
            elseif op == 2
                if temp.b != -1
                    BS[temp.a]+=FS[temp.b].val*BS[temp.id]
                    BS[temp.b]+=FS[temp.a].val*BS[temp.id] 
                else 
                    b=FS[temp.id].val/FS[temp.a].val
                    BS[temp.a]+=b*BS[temp.id]
                end
            # /
            elseif op == 3
                if temp.a != -1 & temp.b != -1
                    BS[temp.a]+=(1/FS[temp.b].val)*BS[temp.id]
                    BS[temp.b]+=(-1)*(FS[temp.a].val/FS[temp.b].val^2)*BS[temp.id]
                elseif temp.a != -1
                    b = FS[temp.a].val/FS[temp.id].val
                    BS[temp.a]+=(1/b)*BS[temp.id]
                elseif temp.b != -1
                    a = FS[temp.b].val*FS[temp.id].val
                    BS[temp.b]+=(-1)*(a/FS[temp.b].val^2)*BS[temp.id]
                end
            # sin
            elseif op == 4
                BS[temp.a]+=cos(FS[temp.a].val)*BS[temp.id]
            
            # cos
            elseif op ==5
                BS[temp.a]+=-sin(FS[temp.a].val)*BS[temp.id]

            end
        end
        #println(FS)
        #println(BS)
        return BS[1:n]
    end
    return g;
end

#function f(x)
#    return [x[1] * x[2]+2.0; 5.0*x[1] / x[2]*x[2]/2.0;sin(x[1]);cos(x[2])*x[1]];
#end
#g = ADbackward(f);
#print(g([1,1], [1,1,1,1]));