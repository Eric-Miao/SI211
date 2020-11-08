# Golden 3 key words: Data Structure, Algorithm, User Interface

# Project Requierments
# 1. Write a generic implementation
# 2. Write efficient code, usually time(ADforward) = 1000*time(ADbackward)
# 3. We don't know the exact evaluation error but the results of the three various(?) should coincide up to small errors (<= 10^-6)

# From a computer science perspective: (**NOT FOR REQUIREMENTS**)
# 1. Global variables are troublesome
# Solution: use shared pointers instead of global variables, [Maintain all variables locally, within the ADN data structure]
# 2. Avoid redundant code:
# => Outsource common code to a unary and binary operator. [Write generic operations / modules];
# 3.a. Don't require the users to provide n(the order of input) ! [Write a counter instead]
# 3.b. Return a code that returns f and f and d^Tf' [in order to ensure efficiency]

import Base.+, Base.*, Base.-, Base./, Base.sin, Base.cos

NOP = 0;    # Number of operations
FS = "";    # Forward Sweep
BS = "";    # Backward Sweep

mutable struct ADN
    i::Int16;
    ADN(i)=new(i)
end

# ADN op. ADN
function +(a::ADN, b::ADN)
    i = a.i;
    j = b.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = v[$i]+v[$j]; \n";
    global BS = "  w[$i] += w[$NOP]; \n" * BS;
    global BS = "  w[$j] += w[$NOP]; \n" * BS;
    return ADN(NOP);
end

function -(a::ADN, b::ADN)
    i = a.i;
    j = b.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = v[$i]-v[$j]; \n";
    global BS = "  w[$i] += w[$NOP]; \n" * BS;
    global BS = "  w[$j] += -w[$NOP]; \n" * BS;
    return ADN(NOP);
end

function /(a::ADN, b::ADN)
    i = a.i;
    j = b.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = v[$i]/v[$j]; \n";
    global BS = " w[$i] += 1/v[$j]*w[$NOP]; \n" * BS;
    global BS = " w[$j] += v[$i]/(v[$j]*v[$j])*w[$NOP]; \n" * BS;
    return ADN(NOP);
end

function *(a::ADN, b::ADN)
    i = a.i;
    j = b.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = v[$i]*v[$j]; \n";
    global BS = "  w[$i] += v[$j]*w[$NOP]; \n" * BS;
    global BS = "  w[$j] += v[$i]*w[$NOP]; \n" * BS;
    return ADN(NOP);
end

function sin(a::ADN)
    i = a.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = sin(v[$i]); \n";
    global BS = "  w[$i] += cos(v[$i]) * w[$NOP]; \n" * BS;
    return ADN(NOP);
end

function cos(a::ADN)
    i=a.i
    global NOP=NOP + 1
    global FS = FS * "  v[$NOP] = cos(v[$i]); \n";
    global BS = "  w[$i] += -sin(v[$i]) * w[$NOP]; \n" * BS;
    return ADN(NOP);
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
    global BS = " w[$j] += $a/(v[$j]*v[$j])*w[$NOP]; \n" * BS;
    return ADN(NOP)
end

function /(a::ADN, b::Float64)
    i=a.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = v[$i]/$a; \n";
    global BS = "  w[$i] += w[$NOP]/$a; \n" * BS
    return ADN(NOP)
end

function *(a::Float64, b::ADN)
    j = b.i;
    global NOP = NOP + 1;
    global FS = FS * "  v[$NOP] = $a*v[$j]; \n";
    global BS = " w[$j] += $a*w[$NOP]; \n" * BS;
    return ADN(NOP)
end

function *(a::ADN, b::Float64)
    return b*a;
end



function ADbackward(f, n)
    global FS = "";
    global BS = "";

    xx = [];
    for i=1:n
        global FS = FS*"  v[$i] = x[$i]; \n";
        xx = [xx; ADN(i)];
    end

    global NOP = n;

    yy = f(xx);
    m = length(yy);
    program = "function h(x, d) \n";
    program *= "v = zeros($NOP); \n";
    program *= "w = zeros($NOP); \n";
    program *= "y = zeros($m); \n";
    program *= FS;

    for i=1:m
        j = yy[i].i;
        program *= "  w[$j] = d[$i]; \n";
    end

    program *= BS;
    for i=1:m
        program *= "  y[$i] = w[$i]; \n";
    end
    program *= "  return y; \n";
    program *= "end \n";

    # Uncomment this to check
    println(program);
    # Transform the string into executable code && Execute it 
    eval( Meta.parse(program) );
    return h;
end

#function f(x)
 #   return [ x[1] * x[2]; x[1] + x[2]*x[2]];
#end

# main()
#h = ADbackward(minif,5);
#print(h([1,1], [1,1])); #[2, 3]