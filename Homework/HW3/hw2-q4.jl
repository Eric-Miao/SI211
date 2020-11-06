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

