mutable struct ADV
	a
	b
end

import Base.+
import Base.-
import Base.*
import Base./
import Base.sin
import Base.cos
import Base.length

function length(A::ADV)
    return 1
end

function +(A::ADV,B::ADV)
	return ADV(A.a+B.a,A.b+B.b);
end

function -(A::ADV,B::ADV)
	return ADV(A.a+B.a,A.b-B.b);
end

function *(A::ADV,B::ADV)
	return ADV(A.a*B.a,A.a*B.b+A.b*B.a);
end

function /(A::ADV,B::ADV)
	return ADV(A.a/B.a,(A.b*B.a-A.a*B.b)/B.a^2)
end

#Int64 op. ADV
function +(A::Int64,B::ADV)
    return ADV(A,0.0)+B;
end

function -(A::Int64,B::ADV)
    return ADV(A,0.0)-B;
end

function *(A::Int64,B::ADV)
    return ADV(A,0.0)*B;
end

function /(A::Int64,B::ADV)
    return ADV(A,0.0)/B;
end
#-------------

#ADV op. Int64
function +(B::ADV,A::Int64)
    return B+ADV(A,0.0);
end

function -(B::ADV,A::Int64)
    return B-ADV(A,0.0);
end

function *(B::ADV,A::Int64)
    return ADV(A,0.0)*B;
end

function /(B::ADV,A::Int64)
    return B/ADV(A,0.0);
end
#-------------

#Float64 op. ADV
function +(A::Float64,B::ADV)
    return ADV(A,0.0)+B;
end

function -(A::Float64,B::ADV)
    return ADV(A,0.0)-B;
end

function *(A::Float64,B::ADV)
    return ADV(A,0.0)*B;
end

function /(A::Float64,B::ADV)
    return ADV(A,0.0)/B;
end
#-------------

#ADV op. Float64
function +(B::ADV,A::Float64)
    return B+ADV(A,0.0);
end

function -(B::ADV,A::Float64)
    return B-ADV(A,0.0);
end

function *(B::ADV,A::Float64)
    return ADV(A,0.0)*B;
end

function /(B::ADV,A::Float64)
    return B/ADV(A,0.0);
end
#-------------


function sin(A::ADV)
	return ADV(sin(A.a),cos(A.a)*A.b);
end

function cos(A::ADV)
	return ADV(cos(A.a),-sin(A.a)*A.b);
end


function diff(f)
    function g(x)
	    X=ADV(x,1.0);
        Y=f(X);
        return Y.b;
    end
	return g
end

function diff(f,d)
	function g(x)
		X = [ADV(x[1],d[1]);ADV(x[2],d[2])];
        Y=f(X);
        return Y.b
	end
    return g
end

function ADforward(f)
	function g(x,d)
		n = length(x)
		X = Array{ADV}(undef, n)
		for i = 1:n
			X[i] = ADV(x[i],d[i])
		end
		Y = f(X)
        if length(Y) == 1
            Y=[Y]
        end
        #print(Y)
        ret=[]
        for y in Y 
            if typeof(y)==ADV
                append!(ret,y.b)
            else
                append!(ret,0.0)
            end
        end
		return ret
	end
	return g
end
		
