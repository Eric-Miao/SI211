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
    j = b.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = $a+v[$j]; \n";
    global BS = "  w[$j] += w[$NOP]; \n" * BS;
    return ADN(NOP);
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
    j = b.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = $a/v[$j]; \n";
    global BS = "  w[$j] += -1*$a/(v[$j]*v[$j])*w[$NOP]; \n" * BS;
    return ADN(NOP)
end

function /(a::ADN, b::Float64)
    i=a.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = v[$i]/$b; \n";
    global BS = "  w[$i] += w[$NOP]/$b; \n" * BS
    return ADN(NOP)
end

function *(a::Float64, b::ADN)
    j = b.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = $a*v[$j]; \n";
    global BS = "  w[$j] += $a*w[$NOP]; \n" * BS;
    return ADN(NOP)
end

function *(a::ADN, b::Float64)
    return b*a;
end