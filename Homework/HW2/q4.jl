using Plots
gr()

struct DDtable
	x
	d
end

function addData!(T,x,y)
              n = length(T.x)
              append!(T.x,x)
              append!(T.d,y)
              for i = 1:n
                  nom = T.d[end]-T.d[end-n]
                  den=T.x[end]-T.x[end-i]
                  append!(T.d,nom/den)
              end
end

function getNewtonCoefficients(T)
       n = length(T.x)
       b = zeros(0)
       k = 0
       for i = 1:n
           k = k+i
           append!(b,T.d[k])
       end
       return b
end

function getPoly(T)
       n = length(T.x)
       c = getNewtonCoefficients(T)
       return function p(x)
           b = c[end]
           for i = 1:n-1
               b = c[n-i]+b*(x-T.x[n-i])
           end
           return b
       end
end

function interpolate(range,f)
        table = DDtable(zeros(0),zeros(0))
        for i = 1:length(range)
        	addData!(table,range[i],f(range[i]))
        end
        return getPoly(table)
end

T = DDtable(zeros(0),zeros(0))
R = range(-5,5,length=11)
f1(x) = sin(x)
f2(x) = 1/(1+x^2)

p1 = interpolate(R,f1)
p2 = interpolate(R,f2)

X = range(-5,5,length=1000)
pf1 = plot(X,f1,label="f1(x)=sin(x)")
pp1 = plot(X,p1,label="p1(x)")
pf2 = plot(X,f2,label="f2(x)=1/1+x^2")
pp2 = plot(X,p2,label="p2(x)")
plot(pf1,pp1,pf2,pp2,layout=(2,2))
savefig("q4.png")
