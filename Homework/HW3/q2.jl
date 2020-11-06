#Please name the code from Q1 "q1.jl"
include("q1.jl")
include("hw2-q4.jl")

using Plots
using Calculus
using QuadGK
gr()

function f(x)
	1/(1+x^2)
end

X=range(-5,5,length=11)
Y=(f(x) for x in X)

coe = spline(X,Y)
coesub = NCP(X,Y)

a=coe[1]
b=coe[2]
c=coe[3]
d=coe[4]

plotx = range(X[1],X[length(X)],length=100000)

function spline_f(x,rangeX,A,B,C,D)
	flag=0
	if x<=rangeX[2]
		flag = 1
	elseif rangeX[2]<x<=rangeX[3]
        flag = 2
	elseif rangeX[3]<x<=rangeX[4]
        flag = 3
	elseif rangeX[4]<x<=rangeX[5]
        flag = 4
	elseif rangeX[5]<x<=rangeX[6]
        flag = 5
    elseif rangeX[6]<x<=rangeX[7]
        flag = 6
    elseif rangeX[7]<x<=rangeX[8]
        flag = 7
    elseif rangeX[8]<x<=rangeX[9]
        flag = 8
    elseif rangeX[9]<x<=rangeX[10]
        flag = 9
    elseif rangeX[10]<x
        flag = 10
	end
    return  A[flag]+B[flag]*(x-X[flag])+C[flag]*(x-X[flag])^2+D[flag]*(x-X[flag])^3	
	
end

function NCS(x)
	return spline_f(x,X,a,b,c,d)
end


function f(x)
	return 1/(1+x^2)
end

T = DDtable(zeros(0),zeros(0))
p = interpolate(X,f)
#plots=plot(plotx,NCS,label="Natural Cubic Spline")
#temp = plot!(plots,plotx,f,label="Original Fucntion")
#plot!(temp,plotx,p,label="Interpolate")

# Below is for Q3
function second_diff_NCS(x)
    rangeX=X
    flag=0
    if x<=rangeX[2]
        flag = 1
    elseif rangeX[2]<x<=rangeX[3]
        flag = 2
    elseif rangeX[3]<x<=rangeX[4]
        flag = 3
    elseif rangeX[4]<x<=rangeX[5]
        flag = 4
    elseif rangeX[5]<x<=rangeX[6]
        flag = 5
    elseif rangeX[6]<x<=rangeX[7]
        flag = 6
    elseif rangeX[7]<x<=rangeX[8]
        flag = 7
    elseif rangeX[8]<x<=rangeX[9]
        flag = 8
    elseif rangeX[9]<x<=rangeX[10]
        flag = 9
    elseif rangeX[10]<x
        flag = 10
    end

	return 2*c[flag]+6*d[flag]*(x-X[flag])
end

function second_diff_f(x)
	return 8*x^2/(1+x^2)^3-2/(1+x^2)^2
end

calx=range(-5,5,length=1000000)
int_F = sum([second_diff_f(x)^2*10/length(calx) for x in calx ])
int_S = sum([second_diff_NCS(x)^2*10/length(calx) for x in calx ])
int_P = sum([second_derivative(p,x)^2*10/length(calx) for x in calx])

diff2_f(x) = second_diff_f(x)^2
diff2_s(x) = second_diff_NCS(x)^2

print("Fa=",int_F,"\n","Fb=",int_P,"\n","Fc=",int_S)

p=plot(plotx,diff2_f,label="The plot of (a) before integration")
plot!(p,plotx,diff2_s,label="The plot of (c) before integration")
#plots=plot(plotx,NCS,label="Natural Cubic Spline")
#temp = plot!(plots,plotx,f,label="Original Fucntion")
#plot!(temp,plotx,p,label="Interpolate")


